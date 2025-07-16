local addonName, addonTable = ...

-- Current database schema version
local CURRENT_VERSION = 1

-- Initialize variables
local DiceTrackerDB
local statsFrame, statsText, predictionText, recommendationText
local safeCall
-- Forward declaration for roll processing helper
local processRollPair

local LSTMNetwork = {
    inputWeights = {},
    hiddenWeights = {},
    biasWeights = {},
    outputWeights = {},
    outputBiases = {},
    cellState = {},
    hiddenState = {},
    training = true,
    dropoutRate = 0.2,
    regularizationRate = 0.001,
    prevAccuracy = 0,
    performanceCheckpoints = {
        bestAccuracy = 0,
        bestStructure = nil,
        maxLayerCount = 5,
        minLayerCount = 2,
    },
    checkpointInterval = 50,
    initialized = false,
    epoch = 0
}

-- Ensure cellState and hiddenState are properly sized
function LSTMNetwork:resetStates()
    for i = 1, self.hiddenSize do
        self.cellState[i] = 0
        self.hiddenState[i] = 0
    end
end

-- Localize math functions for performance and to avoid globals
local exp, log, random = math.exp, math.log, math.random
local floor, max = math.floor, math.max

-- ─────── Neural Network Utility Functions ───────
local function sigmoid(x)
    return 1 / (1 + math.exp(-x))
end

local function tanh(x)
    return (math.exp(x) - math.exp(-x)) / (math.exp(x) + math.exp(-x))
end

local function normalDistribution(mean, stddev)
    local u1 = math.max(math.random(), 1e-6)
    local u2 = math.random()
    local z0 = math.sqrt(-2.0 * math.log(u1)) * math.cos(2.0 * math.pi * u2)
    return z0 * stddev + mean
end

local function applyDropout(layerOutputs, dropoutRate)
    if dropoutRate > 0 then
        for i = 1, #layerOutputs do
            if layerOutputs[i] and math.random() < dropoutRate then
                layerOutputs[i] = 0
            elseif layerOutputs[i] then
                layerOutputs[i] = layerOutputs[i] / (1 - dropoutRate)
            end
        end
    end
    return layerOutputs
end


-- Simple feed-forward neural network for dice prediction
-- Input size increased to include cyclical time features
-- Feed-forward network used as a lightweight fall back predictor
-- Increased hidden size for a bit more capacity
local FFNetwork = {inputSize = 20, hiddenSize = 16, outputSize = 3, eta = 0.01}

function FFNetwork:initialize()
    self.W1 = self.W1 or {}
    self.b1 = self.b1 or {}
    self.W2 = self.W2 or {}
    self.b2 = self.b2 or {}

    -- Adam optimizer moment estimates
    self.mW1, self.vW1 = self.mW1 or {}, self.vW1 or {}
    self.mW2, self.vW2 = self.mW2 or {}, self.vW2 or {}
    self.mb1, self.vb1 = self.mb1 or {}, self.vb1 or {}
    self.mb2, self.vb2 = self.mb2 or {}, self.vb2 or {}
    self.t = self.t or 0

    local std1 = math.sqrt(2 / (self.inputSize + self.hiddenSize))
    local std2 = math.sqrt(2 / (self.hiddenSize + self.outputSize))

    for i = 1, self.hiddenSize do
        self.W1[i] = self.W1[i] or {}
        self.mW1[i] = self.mW1[i] or {}
        self.vW1[i] = self.vW1[i] or {}
        self.b1[i] = self.b1[i] or 0
        self.mb1[i] = self.mb1[i] or 0
        self.vb1[i] = self.vb1[i] or 0
        for j = 1, self.inputSize do
            if type(self.W1[i][j]) ~= "number" then
                self.W1[i][j] = normalDistribution(0, std1)
            end
            self.mW1[i][j] = self.mW1[i][j] or 0
            self.vW1[i][j] = self.vW1[i][j] or 0
        end
    end

    for i = 1, self.hiddenSize do
        self.W2[i] = self.W2[i] or {}
        self.mW2[i] = self.mW2[i] or {}
        self.vW2[i] = self.vW2[i] or {}
        for k = 1, self.outputSize do
            if type(self.W2[i][k]) ~= "number" then
                self.W2[i][k] = normalDistribution(0, std2)
            end
            self.mW2[i][k] = self.mW2[i][k] or 0
            self.vW2[i][k] = self.vW2[i][k] or 0
        end
    end

    for k = 1, self.outputSize do
        self.b2[k] = self.b2[k] or 0
        self.mb2[k] = self.mb2[k] or 0
        self.vb2[k] = self.vb2[k] or 0
    end
end

-- Forward pass returning hidden activations and softmax probabilities
function FFNetwork:forward(input)
    local hidden = {}
    for i = 1, self.hiddenSize do
        local sum = self.b1[i]
        for j = 1, self.inputSize do
            sum = sum + (self.W1[i][j] or 0) * (input[j] or 0)
        end
        hidden[i] = 1 / (1 + exp(-sum))
    end

    local out = {}
    for k = 1, self.outputSize do
        local sum = self.b2[k]
        for i = 1, self.hiddenSize do
            sum = sum + (self.W2[i][k] or 0) * hidden[i]
        end
        out[k] = sum
    end

    local total = 0
    for k = 1, self.outputSize do
        out[k] = exp(out[k])
        total = total + out[k]
    end
    for k = 1, self.outputSize do
        out[k] = out[k] / total
    end

    return hidden, out
end

-- Single step of gradient descent
function FFNetwork:train(input, target)
    local hidden, out = self:forward(input)
    local deltaOut = {}
    for k = 1, self.outputSize do
        deltaOut[k] = (out[k] - target[k])
    end

    local beta1, beta2 = 0.9, 0.999
    local eps = 1e-8
    self.t = self.t + 1

    local maxDelta = 0

    -- Update W2 and b2 using Adam
    for i = 1, self.hiddenSize do
        for k = 1, self.outputSize do
            local grad = deltaOut[k] * hidden[i]
            self.mW2[i][k] = beta1 * self.mW2[i][k] + (1 - beta1) * grad
            self.vW2[i][k] = beta2 * self.vW2[i][k] + (1 - beta2) * grad * grad
            local mHat = self.mW2[i][k] / (1 - math.pow(beta1, self.t))
            local vHat = self.vW2[i][k] / (1 - math.pow(beta2, self.t))
            local update = self.eta * mHat / (math.sqrt(vHat) + eps)
            local old = self.W2[i][k]
            self.W2[i][k] = old - update
            local diff = math.abs(update)
            if diff > maxDelta then maxDelta = diff end
        end
    end
    for k = 1, self.outputSize do
        self.mb2[k] = beta1 * self.mb2[k] + (1 - beta1) * deltaOut[k]
        self.vb2[k] = beta2 * self.vb2[k] + (1 - beta2) * deltaOut[k] * deltaOut[k]
        local mHat = self.mb2[k] / (1 - math.pow(beta1, self.t))
        local vHat = self.vb2[k] / (1 - math.pow(beta2, self.t))
        local update = self.eta * mHat / (math.sqrt(vHat) + eps)
        local old = self.b2[k]
        self.b2[k] = old - update
        local diff = math.abs(update)
        if diff > maxDelta then maxDelta = diff end
    end

    local deltaHidden = {}
    for i = 1, self.hiddenSize do
        local sum = 0
        for k = 1, self.outputSize do
            sum = sum + deltaOut[k] * self.W2[i][k]
        end
        deltaHidden[i] = sum * hidden[i] * (1 - hidden[i])
    end

    -- Update W1 and b1 using Adam
    for i = 1, self.hiddenSize do
        for j = 1, self.inputSize do
            local grad = deltaHidden[i] * (input[j] or 0)
            self.mW1[i][j] = beta1 * self.mW1[i][j] + (1 - beta1) * grad
            self.vW1[i][j] = beta2 * self.vW1[i][j] + (1 - beta2) * grad * grad
            local mHat = self.mW1[i][j] / (1 - math.pow(beta1, self.t))
            local vHat = self.vW1[i][j] / (1 - math.pow(beta2, self.t))
            local update = self.eta * mHat / (math.sqrt(vHat) + eps)
            local old = self.W1[i][j]
            self.W1[i][j] = old - update
            local diff = math.abs(update)
            if diff > maxDelta then maxDelta = diff end
        end
        self.mb1[i] = beta1 * self.mb1[i] + (1 - beta1) * deltaHidden[i]
        self.vb1[i] = beta2 * self.vb1[i] + (1 - beta2) * deltaHidden[i] * deltaHidden[i]
        local mHat = self.mb1[i] / (1 - math.pow(beta1, self.t))
        local vHat = self.vb1[i] / (1 - math.pow(beta2, self.t))
        local update = self.eta * mHat / (math.sqrt(vHat) + eps)
        local old = self.b1[i]
        self.b1[i] = old - update
        local diff = math.abs(update)
        if diff > maxDelta then maxDelta = diff end
    end

    -- Persist updated weights only if they changed appreciably
    if maxDelta > 1e-4 then
        local ok = pcall(function()
            DiceTrackerDB.weights.W1 = self.W1
            DiceTrackerDB.weights.b1 = self.b1
            DiceTrackerDB.weights.W2 = self.W2
            DiceTrackerDB.weights.b2 = self.b2
        end)
        if not ok then
            print("DiceTracker: Error saving weights, resetting database")
            DiceTrackerDB.weights = {W1={}, b1={}, W2={}, b2={}}
        end
    end
end

-- UI Initialization and Stats Update

-- Buffer for tracking dice toss events
local tossBuffer = {player = nil, time = 0, rolls = {}}

local function getBucket(t)
    return floor((t % 60) / 5) + 1
end

local function frequencyPredict(bucket)
    local data = DiceTrackerDB.buckets[bucket]
    if not data or (data.count or 0) == 0 then
        return "7", 0
    end
    -- Laplace smoothing to avoid zero probabilities
    local counts = {(data.Low or 0) + 1, (data["7"] or 0) + 1, (data.High or 0) + 1}
    local total = counts[1] + counts[2] + counts[3]
    local idx, maxC = 1, counts[1]
    if counts[2] > maxC then idx, maxC = 2, counts[2] end
    if counts[3] > maxC then idx, maxC = 3, counts[3] end
    local cats = {"Low", "7", "High"}
    return cats[idx], maxC / total
end

local function buildFeatureVector(now)
    local bucket = getBucket(now)
    local v = {}
    for i = 1, 12 do v[i] = (i == bucket) and 1 or 0 end

    local delta = DiceTrackerDB.lastTossTime and (now - DiceTrackerDB.lastTossTime) or 60
    if delta < 0 or delta > 3600 then delta = 60 end
    v[13] = delta / 60

    for i = 1, 3 do
        v[13 + i] = (i == (DiceTrackerDB.prevCategoryIndex or 0)) and 1 or 0
    end

    local secondsInDay  = 24 * 3600
    local secondsInWeek = 7 * secondsInDay
    local dayTime  = now % secondsInDay
    local weekTime = now % secondsInWeek
    v[17] = math.sin(2*math.pi*dayTime/secondsInDay)
    v[18] = math.cos(2*math.pi*dayTime/secondsInDay)
    v[19] = math.sin(2*math.pi*weekTime/secondsInWeek)
    v[20] = math.cos(2*math.pi*weekTime/secondsInWeek)

    return v
end

local function scheduleSave()
    if not addonTable.saveTicker then
        addonTable.saveTicker = C_Timer.NewTicker(1, function()
            if DiceTrackerDB then
                DiceTrackerDB.isDirty = false
                SavedVariables["DiceTrackerDB"] = DiceTrackerDB
            end
            addonTable.saveTicker:Cancel()
            addonTable.saveTicker = nil
        end)
    end
end

-- Public API to predict the next outcome
function addonTable:Predict()
    local now = time()

    if DiceTrackerDB.lastTossTime and (now - DiceTrackerDB.lastTossTime) > 300 then
        LSTMNetwork:resetStates()
    end

    local input = buildFeatureVector(now)

    local lstmThreshold  = 0.5
    local ffThreshold    = 0.6
    local accuracy       = DiceTrackerDB.stats and DiceTrackerDB.stats.accuracy or 0
    if accuracy < 0.4 then ffThreshold = 0.55 end
    if accuracy < 0.3 then ffThreshold = 0.5 end

    if LSTMNetwork:isFullyInitialized() then
        local cat, conf = LSTMNetwork:predict(input)
        if conf >= lstmThreshold then
            return cat:sub(1,1):upper() .. cat:sub(2), conf
        end
    end

    local _, out = FFNetwork:forward(input)
    local idx, prob = 1, out[1]
    for i = 2, 3 do
        if out[i] > prob then idx, prob = i, out[i] end
    end
    local cats = {"Low","7","High"}

    local bucket = getBucket(now)
    if prob < ffThreshold
       or not DiceTrackerDB.buckets[bucket]
       or (DiceTrackerDB.buckets[bucket].count or 0) < 20
    then
        return frequencyPredict(bucket)
    end

    return cats[idx], prob
end
local function initializeUI()
    if statsFrame then return end

    statsFrame = CreateFrame("Frame", "DiceTrackerStatsFrame", UIParent)
    statsFrame:SetSize(360, 140)
    statsFrame:SetPoint("CENTER")
    statsFrame:SetMovable(true)
    statsFrame:EnableMouse(true)
    statsFrame:RegisterForDrag("LeftButton")
    statsFrame:SetScript("OnDragStart", statsFrame.StartMoving)
    statsFrame:SetScript("OnDragStop", statsFrame.StopMovingOrSizing)

    local bg = statsFrame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(statsFrame)
    bg:SetColorTexture(0, 0, 0, 0.5)

    statsText = statsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    statsText:SetPoint("TOP", 0, -10)
    statsText:SetJustifyH("CENTER")
    statsText:SetSize(340, 20)

    predictionText = statsFrame:CreateFontString(nil, "OVERLAY")
    predictionText:SetFont("Fonts\\FRIZQT__.TTF", 16)
    predictionText:SetPoint("TOP", 0, -40)
    predictionText:SetJustifyH("CENTER")
    predictionText:SetSize(340, 60)

    recommendationText = statsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    recommendationText:SetPoint("BOTTOM", 0, 10)
    recommendationText:SetJustifyH("CENTER")
    recommendationText:SetSize(340, 25)
end

-- Making UpdateUI globally accessible
function addonTable.updateUI()
    if not DiceTrackerDB or not DiceTrackerDB.initialized then return end

    if not statsFrame then initializeUI() end

    if LSTMNetwork:isFullyInitialized() then
        if DiceTrackerDB.stats.lastPrediction then
            local confidence = DiceTrackerDB.stats.lastPredictionConfidence or 0
            predictionText:SetText("Next most likely: " .. DiceTrackerDB.stats.lastPrediction .. " (Confidence: " .. string.format("%.2f%%", confidence * 100) .. ")")
        else
            predictionText:SetText("Next most likely: Analyzing...")
        end
    else
        predictionText:SetText("Next most likely: Initializing...")
    end

    statsText:SetText("Total Rolls: " .. DiceTrackerDB.stats.totalRolls ..
                      " | Low: " .. DiceTrackerDB.stats.low ..
                      " | Seven: " .. DiceTrackerDB.stats.seven ..
                      " | High: " .. DiceTrackerDB.stats.high)

    local accuracy = DiceTrackerDB.stats.accuracy or 0
    recommendationText:SetText("Accuracy: " .. string.format("%.2f%%", accuracy * 100))

    local accuracyPercentage = accuracy * 100
    local color = {r = 1, g = 1, b = 1}
    if accuracyPercentage < 38 then
        color = {r = 1, g = 0, b = 0}
    elseif accuracyPercentage >= 39 and accuracyPercentage <= 49 then
        color = {r = 1, g = 1, b = 0}
    elseif accuracyPercentage >= 50 then
        color = {r = 0, g = 1, b = 0}
    end
    recommendationText:SetTextColor(color.r, color.g, color.b)
end

-- Throttle UI refreshes to avoid excessive work
addonTable.uiCounter = 0
local function maybeUpdateUI(force)
    addonTable.uiCounter = addonTable.uiCounter + 1
    if force or addonTable.uiCounter % 2 == 0 then
        addonTable.updateUI()
    end
end
-- Initialize DiceTrackerDB with default data
local function initializeDefaultData()
    if not DiceTrackerDB then
        DiceTrackerDB = {
            stats = {low = 0, seven = 0, high = 0, totalRolls = 0, correctPredictions = 0, incorrectPredictions = 0, accuracy = 0},
            learningData = {
                lstmNetworkData = {
                    serializedStructure = nil,
                    inputs = {},
                    targets = {},
                    learningRate = 0.005,
                    inputSize = 20,
                    hiddenSize = 64,
                    outputSize = 3,
                    trainAfterNOutcomes = 1,
                    outcomeCountForTraining = 0,
                    epoch = 0,
                    dropoutRate = 0.2,
                    complexityIncreaseThreshold = 0.01,
                    complexityDecreaseThreshold = 0.02,
                    maxLayerCount = 5,
                    minLayerCount = 2,
                    regularizationRate = 0.001,
                    truePositives = {low = 0, seven = 0, high = 0},
                    falsePositives = {low = 0, seven = 0, high = 0},
                    falseNegatives = {low = 0, seven = 0, high = 0},
                    cellState = {},
                    hiddenState = {},
                    slidingWindowSize = 1000,
                    slidingWindow = {},
                    slidingWindowAdjustInterval = 100
                },
            },
            initialized = true,
            uiDisplayed = true,
            pendingRolls = {},
            statisticsData = {
                numLowOutcomes = 0,
                numSevenOutcomes = 0,
                numHighOutcomes = 0,
                totalOutcomes = 0,
            },
            initialTrainingData = nil,
            saveInterval = 100,  -- Save data every 100 rolls
            rollsSinceLastSave = 0,  -- Counter for rolls since last save
            dirtyFlags = {}  -- Dirty flags for incremental saving
            ,weights = {W1={}, b1={}, W2={}, b2={}}
            ,buckets = {}
            ,version = 1
            ,prevCategoryIndex = 0
            ,lastTossTime = 0
        }
    end
end

-- Safely execute a function and reset data if an error occurs
function safeCall(func)
    local ok, res = pcall(func)
    if not ok then
        print("DiceTracker: database error, resetting data")
        initializeDefaultData()
    end
    return ok, res
end

-- Upgrade stored data to the current version if needed
local function migrateDatabase()
    if not DiceTrackerDB.version then
        DiceTrackerDB.version = CURRENT_VERSION
    elseif DiceTrackerDB.version < CURRENT_VERSION then
        -- Future migration logic goes here
        DiceTrackerDB.version = CURRENT_VERSION
    end
end

function LSTMNetwork:initialize()
    if self.initialized then
        print("LSTM Network already initialized.")
        return
    end

    -- Check if DiceTrackerDB.learningData exists, and initialize it if necessary
    if not DiceTrackerDB.learningData then
        DiceTrackerDB.learningData = {}
    end

    -- Check if DiceTrackerDB.learningData.lstmNetworkData exists, and initialize it if necessary
    if not DiceTrackerDB.learningData.lstmNetworkData then
        DiceTrackerDB.learningData.lstmNetworkData = {
            serializedStructure = nil,
            inputs = {},
            targets = {},
            learningRate = 0.005,
            inputSize = 20,
            hiddenSize = 64,
            outputSize = 3,
            trainAfterNOutcomes = 1,
            outcomeCountForTraining = 0,
            epoch = 0,
            dropoutRate = 0.2,
            complexityIncreaseThreshold = 0.01,
            complexityDecreaseThreshold = 0.02,
            maxLayerCount = 5,
            minLayerCount = 2,
            regularizationRate = 0.001,
            truePositives = {low = 0, seven = 0, high = 0},
            falsePositives = {low = 0, seven = 0, high = 0},
            falseNegatives = {low = 0, seven = 0, high = 0},
            cellState = {},
            hiddenState = {},
            slidingWindowSize = 1000,
            slidingWindow = {},
            slidingWindowAdjustInterval = 100
        }
    end

    local nnData = DiceTrackerDB.learningData.lstmNetworkData
    if nnData then
        self.inputSize = nnData.inputSize or 20
        self.hiddenSize = nnData.hiddenSize or 64
        self.outputSize = nnData.outputSize or 3
        self.learningRate = nnData.learningRate or 0.005
        self.dropoutRate = nnData.dropoutRate or 0.2
        self.regularizationRate = nnData.regularizationRate or 0.001
        self.epoch = 0
        self.performanceCheckpoints.maxLayerCount = self.performanceCheckpoints.maxLayerCount or 5
        self.performanceCheckpoints.minLayerCount = self.performanceCheckpoints.minLayerCount or 2
    else
        self.inputSize = 20
        self.hiddenSize = 64
        self.outputSize = 3
        self.learningRate = 0.005
        self.dropoutRate = 0.2
        self.regularizationRate = 0.001
        self.epoch = 0
        self.performanceCheckpoints.maxLayerCount = 5
        self.performanceCheckpoints.minLayerCount = 2
    end

    -- Initialize weights and bias tables using Xavier initialization
    self.inputWeights = {
        f = {},
        i = {},
        o = {},
        c = {}
    }
    self.hiddenWeights = {
        f = {},
        i = {},
        o = {},
        c = {}
    }
    self.biasWeights = {
        f = 0,
        i = 0,
        o = 0,
        c = 0
    }
    self.outputWeights = {}
    self.outputBiases = {}

    -- Xavier initialization for input weights
    for _, gate in ipairs({"f", "i", "o", "c"}) do
        for i = 1, self.inputSize do
            self.inputWeights[gate][i] = normalDistribution(0, math.sqrt(2 / (self.inputSize + self.hiddenSize)))
        end
    end

    -- Xavier initialization for hidden weights
    for _, gate in ipairs({"f", "i", "o", "c"}) do
        for i = 1, self.hiddenSize * self.hiddenSize do
            self.hiddenWeights[gate][i] = normalDistribution(0, math.sqrt(2 / (self.hiddenSize + self.hiddenSize)))
        end
    end

    -- Initialize output weights and biases using He initialization
    for i = 1, self.hiddenSize do
        self.outputWeights[i] = {}
        for j = 1, self.outputSize do
            self.outputWeights[i][j] = normalDistribution(0, math.sqrt(2 / self.hiddenSize))
        end
    end
    for i = 1, self.outputSize do
        self.outputBiases[i] = 0
    end

    -- Initialize cell state and hidden state
    for i = 1, self.hiddenSize do
        self.cellState[i] = 0
        self.hiddenState[i] = 0
    end

    self.initialized = true
    print("LSTM Network initialized.")
end

function LSTMNetwork:getNumHiddenLayers()
    local numLayers = 0
    for _, weightTable in pairs(self.hiddenWeights) do
        if next(weightTable) then
            numLayers = numLayers + 1
        end
    end
    return numLayers
end

function LSTMNetwork:removeHiddenLayer()
    local numLayers = self:getNumHiddenLayers()
    if numLayers > 1 then
        self.hiddenWeights[numLayers] = nil
        -- Update other relevant parts of the network if necessary
    end
end

function LSTMNetwork:addHiddenLayer()
    local newLayerIndex = self:getNumHiddenLayers() + 1
    self.hiddenWeights[newLayerIndex] = {
        f = {},
        i = {},
        o = {},
        c = {}
    }
    -- Initialize the weights for the new hidden layer using Xavier initialization
    for i = 1, self.hiddenSize * self.hiddenSize do
        self.hiddenWeights[newLayerIndex].f[i] = normalDistribution(0, math.sqrt(2 / (self.hiddenSize + self.hiddenSize)))
        self.hiddenWeights[newLayerIndex].i[i] = normalDistribution(0, math.sqrt(2 / (self.hiddenSize + self.hiddenSize)))
        self.hiddenWeights[newLayerIndex].o[i] = normalDistribution(0, math.sqrt(2 / (self.hiddenSize + self.hiddenSize)))
        self.hiddenWeights[newLayerIndex].c[i] = normalDistribution(0, math.sqrt(2 / (self.hiddenSize + self.hiddenSize)))
    end
    -- Update other relevant parts of the network if necessary
end

function LSTMNetwork:isReady()
    if not self.initialized then
        return false
    end
    return true
end

function LSTMNetwork:isFullyInitialized()
    return self.initialized and DiceTrackerDB and DiceTrackerDB.initialized
end

function LSTMNetwork:getPerformanceMetric()
    local correctPredictions = DiceTrackerDB.stats.correctPredictions or 0
    local incorrectPredictions = DiceTrackerDB.stats.incorrectPredictions or 0
    local totalPredictions = correctPredictions + incorrectPredictions
    return totalPredictions > 0 and (correctPredictions / totalPredictions) or 0
end

function LSTMNetwork:adjustLearningRateDynamically()
    local currentLearningRate = self.learningRate or 0.01
    local accuracy = self:getPerformanceMetric()

    local accuracyDelta = accuracy - (self.prevAccuracy or 0)
    if accuracyDelta > 0 then
        self.learningRate = math.min(currentLearningRate * 1.01, 0.1)
    else
        self.learningRate = math.max(currentLearningRate * 0.99, 0.001)
    end
    self.prevAccuracy = accuracy
end

function LSTMNetwork:postTrainingAdjustments()
    self:adjustLearningRateDynamically()
    self:adjustRegularizationAndDropoutRate()
self:evaluatePerformance()
end
function LSTMNetwork:adjustRegularizationAndDropoutRate()
local performanceMetric = self:getPerformanceMetric()
local precision, recall = self:calculatePrecisionAndRecall()
local f1Score = 2 * precision * recall / (precision + recall)

if f1Score > 0.8 then
    self.dropoutRate = math.max(self.dropoutRate * 0.9, 0.1)
    self.regularizationRate = math.max(self.regularizationRate * 0.99, 0.001)
elseif f1Score < 0.6 then
    self.dropoutRate = math.min(self.dropoutRate * 1.1, 0.5)
    self.regularizationRate = math.min(self.regularizationRate * 1.01, 0.1)
end

end
function LSTMNetwork:evaluateAndAdapt()
local nnData = DiceTrackerDB.learningData.lstmNetworkData
self:postTrainingAdjustments()
nnData.epoch = nnData.epoch + 1
self.epoch = self.epoch + 1
end
function LSTMNetwork:preprocessData(data)
    local processed = {}
    if type(data) == "table" then
        for i = 1, self.inputSize do
            processed[i] = tonumber(data[i]) or 0
        end
    else
        -- fallback when given a single number or unexpected type
        for i = 1, self.inputSize do
            processed[i] = (i == 1 and tonumber(data) or 0) or 0
        end
    end
    return processed
end
function LSTMNetwork:forwardPass(inputs)
-- Add error handling and validation checks
if not inputs then
print("Error: Empty or invalid input data in forwardPass.")
return {}
end

local outputSequence = {}

for t = 1, #inputs do
    local xt = self:preprocessData(inputs[t])

    local inputLen  = #xt
    local hiddenLen = #self.hiddenState

    local ft = sigmoid(
        self:dotProduct(self.inputWeights.f, xt, inputLen) +
        self:dotProduct(self.hiddenWeights.f, self.hiddenState, hiddenLen) +
        self.biasWeights.f
    )

    local it = sigmoid(
        self:dotProduct(self.inputWeights.i, xt, inputLen) +
        self:dotProduct(self.hiddenWeights.i, self.hiddenState, hiddenLen) +
        self.biasWeights.i
    )

    local ot = sigmoid(
        self:dotProduct(self.inputWeights.o, xt, inputLen) +
        self:dotProduct(self.hiddenWeights.o, self.hiddenState, hiddenLen) +
        self.biasWeights.o
    )

    -- Compute candidate cell state directly from raw weights
    local ct_x = self:dotProduct(self.inputWeights.c, xt, inputLen)
    local ct_h = self:dotProduct(self.hiddenWeights.c, self.hiddenState, hiddenLen)

    local ct_candidate = {}
    for i = 1, self.hiddenSize do
        ct_candidate[i] = tanh(ct_x + ct_h + self.biasWeights.c)
    end

    if #self.cellState == 0 then
        self:initialize()
    end
    self.cellState = self:elementWiseAdd(self:elementWiseMultiply(ft, self.cellState), self:elementWiseMultiply(it, ct_candidate))
    self.hiddenState = self:elementWiseMultiply(ot, self:applyTanh(self.cellState))

    -- Apply dropout to the hidden state during training
    if self.training then
        self.hiddenState = applyDropout(self.hiddenState, self.dropoutRate)
    end

    local outputLayer = {}

    -- Pass hidden state through the output layer
    for i = 1, self.outputSize do
        local sum = 0
        for j = 1, self.hiddenSize do
            sum = sum + (self.hiddenState[j] or 0) * (self.outputWeights[j] and self.outputWeights[j][i] or 0)
        end
        sum = sum + self.outputBiases[i]
        outputLayer[i] = sum
    end

    -- Apply softmax activation to the output layer
    local sumExp = 0
    for i = 1, self.outputSize do
        outputLayer[i] = math.exp(outputLayer[i])
        sumExp = sumExp + outputLayer[i]
    end
    for i = 1, self.outputSize do
        outputLayer[i] = outputLayer[i] / sumExp
    end

    outputSequence[t] = outputLayer
end

return outputSequence

end
function LSTMNetwork:backwardPass(inputs, outputs, targets)
    if #inputs == 0 or #outputs == 0 then
        print("Error: Empty inputs/outputs in backwardPass.")
        return
    end

    -- Ensure the network has a valid state
    if #self.hiddenState == 0 then
        self:resetStates()
    end

    -- Preprocess all inputs
    for t = 1, #inputs do
        inputs[t] = self:preprocessData(inputs[t])
    end

-- Initialize gradients
local dWxi, dWhi, dWxf, dWhf, dWxo, dWho, dWxc, dWhc = {}, {}, {}, {}, {}, {}, {}, {}
local dWy, dby = {}, {}
local dbi, dbf, dbo, dbc = 0, 0, 0, 0
local dhnext = {}
local dcnext = {}

-- Initialize dhnext, dcnext, and gradient tables with default values
for i = 1, self.hiddenSize do
    dhnext[i] = 0
    dcnext[i] = 0
    dWxi[i] = dWxi[i] or 0
    dWhi[i] = dWhi[i] or 0
    dWxf[i] = dWxf[i] or 0
    dWhf[i] = dWhf[i] or 0
    dWxo[i] = dWxo[i] or 0
    dWho[i] = dWho[i] or 0
    dWxc[i] = dWxc[i] or 0
    dWhc[i] = dWhc[i] or 0
end
for i = 1, self.outputSize do
    dWy[i] = {}
    for j = 1, self.hiddenSize do
        dWy[i][j] = 0
    end
    dby[i] = 0
end

-- Backpropagate through time
for t = #inputs, 1, -1 do
    local xt = inputs[t]
    local inputLen  = #xt
    local hiddenLen = #self.hiddenState

    local ft = sigmoid(
        self:dotProduct(self.inputWeights.f, xt, inputLen) +
        self:dotProduct(self.hiddenWeights.f, self.hiddenState, hiddenLen) +
        self.biasWeights.f
    )
    local it = sigmoid(
        self:dotProduct(self.inputWeights.i, xt, inputLen) +
        self:dotProduct(self.hiddenWeights.i, self.hiddenState, hiddenLen) +
        self.biasWeights.i
    )
    local ot = sigmoid(
        self:dotProduct(self.inputWeights.o, xt, inputLen) +
        self:dotProduct(self.hiddenWeights.o, self.hiddenState, hiddenLen) +
        self.biasWeights.o
    )

    -- compute the candidate cell update exactly once per time step
    local ct_x    = self:dotProduct(self.inputWeights.c, xt, inputLen)
    local ct_h    = self:dotProduct(self.hiddenWeights.c, self.hiddenState, hiddenLen)
    local baseCt  = tanh(ct_x + ct_h + self.biasWeights.c)

    local ct_candidate = {}
    for j = 1, self.hiddenSize do
        ct_candidate[j] = baseCt
    end

    local dy = {}
    for i = 1, self.outputSize do
        dy[i] = outputs[t][i] - targets[i]
    end

    -- Backpropagation through the output layer
    for i = 1, self.outputSize do
        for j = 1, self.hiddenSize do
            dWy[i][j] = dWy[i][j] + (dy[i] or 0) * (self.hiddenState[j] or 0)
        end
        dby[i] = dby[i] + (dy[i] or 0)
    end

    -- Backpropagation through the hidden state
    for i = 1, self.hiddenSize do
        local dh = 0
        for j = 1, self.outputSize do
            dh = dh + (dy[j] or 0) * (self.outputWeights[i] and self.outputWeights[i][j] or 0)
        end
        dhnext[i] = dhnext[i] + dh
    end

    -- Backpropagation through the output gate
    local dot = {}
    for i = 1, self.hiddenSize do
        local dyValue = dy[i] or 0
        local cellStateValue = self.cellState[i] or 0
        local hiddenStateValue = self.hiddenState[i] or 0
        local xtValue = xt[i] or 0

        dot[i] = dyValue * tanh(cellStateValue)
        dWho[i] = (dWho[i] or 0) + dot[i] * hiddenStateValue
        dWxo[i] = (dWxo[i] or 0) + dot[i] * xtValue
        dbo = dbo + dot[i]
        dot[i] = dot[i] * self.hiddenWeights.o[(i - 1) * self.hiddenSize + i]
        dhnext[i] = dhnext[i] + dot[i]
    end

    -- Backpropagation through the cell state
    local dcellState = {}
    for i = 1, self.hiddenSize do
        local dcnextValue = dcnext[i] or 0
        local hiddenStateValue = self.hiddenState[i] or 0
        local dotValue = dot[i] or 0

        dcellState[i] = dcnextValue + hiddenStateValue * (1 - hiddenStateValue) * dotValue
    end
    dcnext = {}

    -- Backpropagation through the forget gate
    local dft = {}
    for i = 1, self.hiddenSize do
        dft[i] = dcellState[i] * (self.cellState[i] or 0)
        dWxf[i] = (dWxf[i] or 0) + dft[i] * (xt[i] or 0)
        dWhf[i] = (dWhf[i] or 0) + dft[i] * self.hiddenWeights.f[(i - 1) * self.hiddenSize + i]
        dbf = dbf + dft[i]
        dft[i] = dft[i] * self.hiddenWeights.f[(i - 1) * self.hiddenSize + i]
        dhnext[i] = dhnext[i] + dft[i]
        dcnext[i] = dcellState[i] * (self.inputWeights.f[i] or 0)
    end

    -- Backpropagation through the input gate
    local dit = {}
    for i = 1, self.hiddenSize do
        dit[i] = dcellState[i] * ct_candidate[i]
        dWxi[i] = (dWxi[i] or 0) + dit[i] * (xt[i] or 0)
        dWhi[i] = (dWhi[i] or 0) + dit[i] * self.hiddenWeights.i[(i - 1) * self.hiddenSize + i]
        dbi = dbi + dit[i]
        dit[i] = dit[i] * self.hiddenWeights.i[(i - 1) * self.hiddenSize + i]
        dhnext[i] = dhnext[i] + dit[i]
        dcnext[i] = dcnext[i] + dcellState[i] * it * (1 - math.pow(ct_candidate[i], 2))
    end

    -- Backpropagation through the candidate cell state
    local dct_candidate = {}
    for i = 1, self.hiddenSize do
        dct_candidate[i] = dcellState[i] * it * (1 - math.pow(ct_candidate[i], 2))
        dWxc[i] = (dWxc[i] or 0) + dct_candidate[i] * (xt[i] or 0)
        dWhc[i] = (dWhc[i] or 0) + dct_candidate[i] * self.hiddenWeights.c[(i - 1) * self.hiddenSize + i]
        dbc = dbc + dct_candidate[i]
        dct_candidate[i] = dct_candidate[i] * self.hiddenWeights.c[(i - 1) * self.hiddenSize + i]
        dhnext[i] = dhnext[i] + dct_candidate[i]
    end
end

-- Apply regularization to the gradients
local regularizationTerm = self.regularizationRate / (#inputs)
for i = 1, self.inputSize do
    for j = 1, self.hiddenSize do
        local flatIndex = (j - 1) * self.inputSize + i
        dWxi[j] = dWxi[j] + regularizationTerm * (self.inputWeights.i[flatIndex] or 0)
        dWxf[j] = dWxf[j] + regularizationTerm * (self.inputWeights.f[flatIndex] or 0)
        dWxo[j] = dWxo[j] + regularizationTerm * (self.inputWeights.o[flatIndex] or 0)
        dWxc[j] = dWxc[j] + regularizationTerm * (self.inputWeights.c[flatIndex] or 0)
    end
end
for i = 1, self.hiddenSize do
    for j = 1, self.hiddenSize do
local flatIndex = (i - 1) * self.hiddenSize + j
dWhi[j] = dWhi[j] + regularizationTerm * (self.hiddenWeights.i[flatIndex] or 0)
dWhf[j] = dWhf[j] + regularizationTerm * (self.hiddenWeights.f[flatIndex] or 0)
dWho[j] = dWho[j] + regularizationTerm * (self.hiddenWeights.o[flatIndex] or 0)
dWhc[j] = dWhc[j] + regularizationTerm * (self.hiddenWeights.c[flatIndex] or 0)
end
end
for i = 1, self.outputSize do
for j = 1, self.hiddenSize do
dWy[i][j] = dWy[i][j] + regularizationTerm * (self.outputWeights[j] and self.outputWeights[j][i] or 0)
end
dby[i] = dby[i] + regularizationTerm * self.outputBiases[i]
end

-- Update weights and biases using the Adam optimization algorithm
self:updateWeights(dWxi, dWhi, dWxf, dWhf, dWxo, dWho, dWxc, dWhc, dWy, dby, dbi, dbf, dbo, dbc)

end
function LSTMNetwork:updateWeights(dWxi, dWhi, dWxf, dWhf, dWxo, dWho, dWxc, dWhc, dWy, dby, dbi, dbf, dbo, dbc)
    -- ensure each gate table exists
    for _, gate in ipairs({"i", "f", "o", "c"}) do
        self.inputWeights[gate]  = self.inputWeights[gate]  or {}
        self.hiddenWeights[gate] = self.hiddenWeights[gate] or {}
    end
    -- ensure biases exist
    self.biasWeights.i = self.biasWeights.i or 0
    self.biasWeights.f = self.biasWeights.f or 0
    self.biasWeights.o = self.biasWeights.o or 0
    self.biasWeights.c = self.biasWeights.c or 0

    -- make sure our Adam tables and output tables are all in place
    self.outputWeights  = self.outputWeights  or {}
    self.outputBiases   = self.outputBiases   or {}
    self.mWy            = self.mWy            or {}
    self.vWy            = self.vWy            or {}
    self.mby            = self.mby            or {}
    self.vby            = self.vby            or {}

    for i = 1, self.outputSize do
        self.mWy[i]           = self.mWy[i]           or {}
        self.vWy[i]           = self.vWy[i]           or {}
        self.outputWeights[i] = self.outputWeights[i] or {}
        -- bias-moment entries
        self.mby[i]           = self.mby[i]           or 0
        self.vby[i]           = self.vby[i]           or 0
    end

    -- Hyperparameters for Adam optimization
    local beta1 = 0.9
local beta2 = 0.999
local epsilon = 1e-8

-- Initialize Adam's m and v for each weight and bias
self.mWxi = self.mWxi or {}
self.vWxi = self.vWxi or {}
self.mWhi = self.mWhi or {}
self.vWhi = self.vWhi or {}
self.mWxf = self.mWxf or {}
self.vWxf = self.vWxf or {}
self.mWhf = self.mWhf or {}
self.vWhf = self.vWhf or {}
self.mWxo = self.mWxo or {}
self.vWxo = self.vWxo or {}
self.mWho = self.mWho or {}
self.vWho = self.vWho or {}
self.mWxc = self.mWxc or {}
self.vWxc = self.vWxc or {}
self.mWhc = self.mWhc or {}
self.vWhc = self.vWhc or {}
self.mWy = self.mWy or {}
self.vWy = self.vWy or {}
self.mbi = self.mbi or 0
self.vbi = self.vbi or 0
self.mbf = self.mbf or 0
self.vbf = self.vbf or 0
self.mbo = self.mbo or 0
self.vbo = self.vbo or 0
self.mbc = self.mbc or 0
self.vbc = self.vbc or 0
self.mby = self.mby or {}
self.vby = self.vby or {}

-- Update weights and biases
for i = 1, self.inputSize do
    for j = 1, self.hiddenSize do
        -- Input gate weights
        local flatIndex = (j - 1) * self.inputSize + i
        self.mWxi[flatIndex] = beta1 * (self.mWxi[flatIndex] or 0) + (1 - beta1) * (dWxi[j] or 0)
        self.vWxi[flatIndex] = beta2 * (self.vWxi[flatIndex] or 0) + (1 - beta2) * math.pow((dWxi[j] or 0), 2)
        local mWxiHat = self.mWxi[flatIndex] / (1 - math.pow(beta1, self.epoch + 1))
        local vWxiHat = self.vWxi[flatIndex] / (1 - math.pow(beta2, self.epoch + 1))
        -- Guard against nil weights by treating missing values as zero
        self.inputWeights.i[flatIndex] = (self.inputWeights.i[flatIndex] or 0) -
            self.learningRate * mWxiHat / (math.sqrt(vWxiHat) + epsilon)

        -- Forget gate weights
        self.mWxf[flatIndex] = beta1 * (self.mWxf[flatIndex] or 0) + (1 - beta1) * (dWxf[j] or 0)
        self.vWxf[flatIndex] = beta2 * (self.vWxf[flatIndex] or 0) + (1 - beta2) * math.pow((dWxf[j] or 0), 2)
        local mWxfHat = self.mWxf[flatIndex] / (1 - math.pow(beta1, self.epoch + 1))
        local vWxfHat = self.vWxf[flatIndex] / (1 - math.pow(beta2, self.epoch + 1))
        self.inputWeights.f[flatIndex] = (self.inputWeights.f[flatIndex] or 0) -
            self.learningRate * mWxfHat / (math.sqrt(vWxfHat) + epsilon)

        -- Output gate weights
        self.mWxo[flatIndex] = beta1 * (self.mWxo[flatIndex] or 0) + (1 - beta1) * (dWxo[j] or 0)
        self.vWxo[flatIndex] = beta2 * (self.vWxo[flatIndex] or 0) + (1 - beta2) * math.pow((dWxo[j] or 0), 2)
        local mWxoHat = self.mWxo[flatIndex] / (1 - math.pow(beta1, self.epoch + 1))
        local vWxoHat = self.vWxo[flatIndex] / (1 - math.pow(beta2, self.epoch + 1))
        self.inputWeights.o[flatIndex] = (self.inputWeights.o[flatIndex] or 0) -
            self.learningRate * mWxoHat / (math.sqrt(vWxoHat) + epsilon)

        -- Candidate cell state weights
        self.mWxc[flatIndex] = beta1 * (self.mWxc[flatIndex] or 0) + (1 - beta1) * (dWxc[j] or 0)
        self.vWxc[flatIndex] = beta2 * (self.vWxc[flatIndex] or 0) + (1 - beta2) * math.pow((dWxc[j] or 0), 2)
        local mWxcHat = self.mWxc[flatIndex] / (1 - math.pow(beta1, self.epoch + 1))
        local vWxcHat = self.vWxc[flatIndex] / (1 - math.pow(beta2, self.epoch + 1))
        self.inputWeights.c[flatIndex] = (self.inputWeights.c[flatIndex] or 0) -
            self.learningRate * mWxcHat / (math.sqrt(vWxcHat) + epsilon)
    end
end

for i = 1, self.hiddenSize do
    for j = 1, self.hiddenSize do
        -- Input gate weights
        local flatIndex = (i - 1) * self.hiddenSize + j
        self.mWhi[flatIndex] = beta1 * (self.mWhi[flatIndex] or 0) + (1 - beta1) * (dWhi[j] or 0)
        self.vWhi[flatIndex] = beta2 * (self.vWhi[flatIndex] or 0) + (1 - beta2) * math.pow((dWhi[j] or 0), 2)
        local mWhiHat = self.mWhi[flatIndex] / (1 - math.pow(beta1, self.epoch + 1))
        local vWhiHat = self.vWhi[flatIndex] / (1 - math.pow(beta2, self.epoch + 1))
        self.hiddenWeights.i[flatIndex] = (self.hiddenWeights.i[flatIndex] or 0) -
            self.learningRate * mWhiHat / (math.sqrt(vWhiHat) + epsilon)

        -- Forget gate weights
        self.mWhf[flatIndex] = beta1 * (self.mWhf[flatIndex] or 0) + (1 - beta1) * (dWhf[j] or 0)
        self.vWhf[flatIndex] = beta2 * (self.vWhf[flatIndex] or 0) + (1 - beta2) * math.pow((dWhf[j] or 0), 2)
        local mWhfHat = self.mWhf[flatIndex] / (1 - math.pow(beta1, self.epoch + 1))
        local vWhfHat = self.vWhf[flatIndex] / (1 - math.pow(beta2, self.epoch + 1))
        self.hiddenWeights.f[flatIndex] = (self.hiddenWeights.f[flatIndex] or 0) -
            self.learningRate * mWhfHat / (math.sqrt(vWhfHat) + epsilon)

        -- Output gate weights
        self.mWho[flatIndex] = beta1 * (self.mWho[flatIndex] or 0) + (1 - beta1) * (dWho[j] or 0)
        self.vWho[flatIndex] = beta2 * (self.vWho[flatIndex] or 0) + (1 - beta2) * math.pow((dWho[j] or 0), 2)
        local mWhoHat = self.mWho[flatIndex] / (1 - math.pow(beta1, self.epoch + 1))
        local vWhoHat = self.vWho[flatIndex] / (1 - math.pow(beta2, self.epoch + 1))
        self.hiddenWeights.o[flatIndex] = (self.hiddenWeights.o[flatIndex] or 0) -
            self.learningRate * mWhoHat / (math.sqrt(vWhoHat) + epsilon)

        -- Candidate cell state weights
        self.mWhc[flatIndex] = beta1 * (self.mWhc[flatIndex] or 0) + (1 - beta1) * (dWhc[j] or 0)
        self.vWhc[flatIndex] = beta2 * (self.vWhc[flatIndex] or 0) + (1 - beta2) * math.pow((dWhc[j] or 0), 2)
        local mWhcHat = self.mWhc[flatIndex] / (1 - math.pow(beta1, self.epoch + 1))
        local vWhcHat = self.vWhc[flatIndex] / (1 - math.pow(beta2, self.epoch + 1))
        self.hiddenWeights.c[flatIndex] = (self.hiddenWeights.c[flatIndex] or 0) -
            self.learningRate * mWhcHat / (math.sqrt(vWhcHat) + epsilon)
    end
end

for i = 1, self.outputSize do
    for j = 1, self.hiddenSize do
        self.mWy[i][j] = beta1 * (self.mWy[i][j] or 0) + (1 - beta1) * (dWy[i][j] or 0)
        self.vWy[i][j] = beta2 * (self.vWy[i][j] or 0) + (1 - beta2) * math.pow((dWy[i][j] or 0), 2)
        local mWyHat = self.mWy[i][j] / (1 - math.pow(beta1, self.epoch + 1))
        local vWyHat = self.vWy[i][j] / (1 - math.pow(beta2, self.epoch + 1))
        self.outputWeights[j] = self.outputWeights[j] or {}
        self.outputWeights[j][i] = (self.outputWeights[j][i] or 0) -
            self.learningRate * mWyHat / (math.sqrt(vWyHat) + epsilon)
    end
    self.mby[i] = beta1 * (self.mby[i] or 0) + (1 - beta1) * (dby[i] or 0)
    self.vby[i] = beta2 * (self.vby[i] or 0) + (1 - beta2) * math.pow((dby[i] or 0), 2)
    local mbyHat = self.mby[i] / (1 - math.pow(beta1, self.epoch + 1))
    local vbyHat = self.vby[i] / (1 - math.pow(beta2, self.epoch + 1))
    self.outputBiases[i] = (self.outputBiases[i] or 0) -
        self.learningRate * mbyHat / (math.sqrt(vbyHat) + epsilon)
end

-- Update biases
self.mbi = beta1 * self.mbi + (1 - beta1) * dbi
self.vbi = beta2 * self.vbi + (1 - beta2) * math.pow(dbi, 2)
local mbiHat = self.mbi / (1 - math.pow(beta1, self.epoch + 1))
local vbiHat = self.vbi / (1 - math.pow(beta2, self.epoch + 1))
self.biasWeights.i = self.biasWeights.i - self.learningRate * mbiHat / (math.sqrt(vbiHat) + epsilon)

self.mbf = beta1 * self.mbf + (1 - beta1) * dbf
self.vbf = beta2 * self.vbf + (1 - beta2) * math.pow(dbf, 2)
local mbfHat = self.mbf / (1 - math.pow(beta1, self.epoch + 1))
local vbfHat = self.vbf / (1 - math.pow(beta2, self.epoch + 1))
self.biasWeights.f = self.biasWeights.f - self.learningRate * mbfHat / (math.sqrt(vbfHat) + epsilon)

self.mbo = beta1 * self.mbo + (1 - beta1) * dbo
self.vbo = beta2 * self.vbo + (1 - beta2) * math.pow(dbo, 2)
local mboHat = self.mbo / (1 - math.pow(beta1, self.epoch + 1))
local vboHat = self.vbo / (1 - math.pow(beta2, self.epoch + 1))
self.biasWeights.o = self.biasWeights.o - self.learningRate * mboHat / (math.sqrt(vboHat) + epsilon)

self.mbc = beta1 * self.mbc + (1 - beta1) * dbc
self.vbc = beta2 * self.vbc + (1 - beta2) * math.pow(dbc, 2)
local mbcHat = self.mbc / (1 - math.pow(beta1, self.epoch + 1))
local vbcHat = self.vbc / (1 - math.pow(beta2, self.epoch + 1))
self.biasWeights.c = self.biasWeights.c - self.learningRate * mbcHat / (math.sqrt(vbcHat) + epsilon)
end
function LSTMNetwork:evaluatePerformance()
local currentAccuracy = self:getPerformanceMetric()
local epoch = DiceTrackerDB.learningData.lstmNetworkData.epoch

-- Save the best performing network structure and parameters
if currentAccuracy > self.performanceCheckpoints.bestAccuracy then
    self.performanceCheckpoints.bestAccuracy = currentAccuracy
    self.performanceCheckpoints.bestStructure = self:serializeStructure()
end

-- Periodic performance review
if epoch % self.checkpointInterval == 0 then
    if currentAccuracy < self.performanceCheckpoints.bestAccuracy then
        -- Rollback to the best performing structure if current performance is worse
        self:loadStructure(self.performanceCheckpoints.bestStructure)
    end
    -- Reset checkpoint accuracy to current to allow for future improvements
    self.performanceCheckpoints.bestAccuracy = currentAccuracy
end

-- Adjust network complexity based on performance
if currentAccuracy < 0.4 then
    -- Increase network complexity if accuracy is consistently low
    local numLayers = self:getNumHiddenLayers()
    if numLayers < self.performanceCheckpoints.maxLayerCount then
        self:addHiddenLayer()
    end
elseif currentAccuracy > 0.75 then
    -- Decrease network complexity if accuracy is consistently high
    local numLayers = self:getNumHiddenLayers()
    if numLayers > self.performanceCheckpoints.minLayerCount then
        self:removeHiddenLayer()
    end
end

end
function LSTMNetwork:predict(inputs)
if not self:isFullyInitialized() then
print("LSTM Network is not fully initialized. Skipping prediction.")
return "Analyzing...", 0
end

self.training = false
local processedInputs = self:preprocessData(inputs)
local outputProbabilities = self:forwardPass(processedInputs)
self.training = true

if #outputProbabilities == 0 then
    print("Warning: Empty output probabilities. Returning default prediction.")
    return "Analyzing...", 0
end

local lastOutput = outputProbabilities[#outputProbabilities]
local categoryMap = {"low", "seven", "high"}
local maxProbability = 0
local predictedCategory = ""
for i, probability in ipairs(lastOutput) do
    if probability > maxProbability then
        maxProbability = probability
        predictedCategory = categoryMap[i]
    end
end

return predictedCategory, maxProbability

end
function LSTMNetwork:calculatePrecisionAndRecall()
local tp_low = DiceTrackerDB.learningData.lstmNetworkData.truePositives.low
local fp_low = DiceTrackerDB.learningData.lstmNetworkData.falsePositives.low
local fn_low = DiceTrackerDB.learningData.lstmNetworkData.falseNegatives.low
local tp_seven = DiceTrackerDB.learningData.lstmNetworkData.truePositives.seven
local fp_seven = DiceTrackerDB.learningData.lstmNetworkData.falsePositives.seven
local fn_seven = DiceTrackerDB.learningData.lstmNetworkData.falseNegatives.seven
local tp_high = DiceTrackerDB.learningData.lstmNetworkData.truePositives.high
local fp_high = DiceTrackerDB.learningData.lstmNetworkData.falsePositives.high
local fn_high = DiceTrackerDB.learningData.lstmNetworkData.falseNegatives.high

local precision_low = tp_low > 0 and tp_low / (tp_low + fp_low) or 0
local recall_low = tp_low > 0 and tp_low / (tp_low + fn_low) or 0
local precision_seven = tp_seven > 0 and tp_seven / (tp_seven + fp_seven) or 0
local recall_seven = tp_seven > 0 and tp_seven / (tp_seven + fn_seven) or 0
local precision_high = tp_high > 0 and tp_high / (tp_high + fp_high) or 0
local recall_high = tp_high > 0 and tp_high / (tp_high + fn_high) or 0

local average_precision = (precision_low + precision_seven + precision_high) / 3
local average_recall = (recall_low + recall_seven + recall_high) / 3

return average_precision, average_recall

end
-- Serialize Structure Function
function LSTMNetwork:serializeStructure()
local structure = {
inputWeights = self.inputWeights,
hiddenWeights = self.hiddenWeights,
biasWeights = self.biasWeights,
outputWeights = self.outputWeights,
outputBiases = self.outputBiases
}
local serialized = self:serializeTable(structure)
DiceTrackerDB.learningData.lstmNetworkData.serializedStructure = serialized

return serialized

end
function LSTMNetwork:serializeTable(table)
local serializedTable = {}
for key, value in pairs(table) do
if type(value) == "table" then
serializedTable[key] = self:serializeTable(value)
else
serializedTable[key] = value
end
end
return serializedTable
end
-- Load Structure Function
function LSTMNetwork:loadStructure(serializedStructure)
local structure = self:deserializeTable(serializedStructure)
self.inputWeights = structure.inputWeights
self.hiddenWeights = structure.hiddenWeights
self.biasWeights = structure.biasWeights
self.outputWeights = structure.outputWeights
self.outputBiases = structure.outputBiases
self.initialized = true

-- Ensure hyperparameters are properly initialized
local nnData = DiceTrackerDB.learningData.lstmNetworkData
if nnData then
    self.inputSize = nnData.inputSize or 20
    self.hiddenSize = nnData.hiddenSize or 64
    self.outputSize = nnData.outputSize or 3
    self.learningRate = nnData.learningRate or 0.005
    self.dropoutRate = nnData.dropoutRate or 0.2
    self.regularizationRate = nnData.regularizationRate or 0.001
    self.epoch = 0
    self.performanceCheckpoints.maxLayerCount = self.performanceCheckpoints.maxLayerCount or 5
    self.performanceCheckpoints.minLayerCount = self.performanceCheckpoints.minLayerCount or 2
end

end
function LSTMNetwork:deserializeTable(serializedTable)
local table = {}
for key, value in pairs(serializedTable) do
if type(value) == "table" then
table[key] = self:deserializeTable(value)
else
table[key] = value
end
end
return table
end
-- Save Functionality
function saveAddonData()
local serializedStructure = LSTMNetwork:serializeStructure()
DiceTrackerDB.learningData.lstmNetworkData.serializedStructure = serializedStructure
DiceTrackerDB.learningData.lstmNetworkData.cellState = LSTMNetwork.cellState
DiceTrackerDB.learningData.lstmNetworkData.hiddenState = LSTMNetwork.hiddenState

-- Incremental saving
local dirtyData = {}
for key, value in pairs(DiceTrackerDB.dirtyFlags) do
    if value then
        dirtyData[key] = DiceTrackerDB[key]
        DiceTrackerDB.dirtyFlags[key] = nil
    end
end

-- Save the dirty data
DiceTrackerSavedVariables = DiceTrackerSavedVariables or {}
for key, value in pairs(dirtyData) do
    DiceTrackerSavedVariables[key] = value
end

end
-- Enhanced Neural Network Initialization Check
function checkAndInitializeLSTMNetwork()
    if DiceTrackerDB.learningData.lstmNetworkData.serializedStructure then
        print("Loading saved LSTM Network structure...")
        LSTMNetwork:loadStructure(DiceTrackerDB.learningData.lstmNetworkData.serializedStructure)
        LSTMNetwork.cellState = DiceTrackerDB.learningData.lstmNetworkData.cellState or {}
        LSTMNetwork.hiddenState = DiceTrackerDB.learningData.lstmNetworkData.hiddenState or {}
    else
        print("Initializing LSTM Network...")
        LSTMNetwork:initialize()
    end

    saveAddonData()
end
-- Adjusted Addon Initialization and Event Handling
function initializeAddonData()
-- Check and initialize DiceTrackerDB if it doesn't exist
    if not DiceTrackerDB then
        print("Initializing DiceTrackerDB with default data...")
        initializeDefaultData()
    end

-- Load saved variables
    if DiceTrackerSavedVariables then
        for key, value in pairs(DiceTrackerSavedVariables) do
            DiceTrackerDB[key] = value
        end
    end

    migrateDatabase()

    -- Ensure LSTM network data structures are initialized
    DiceTrackerDB.learningData.lstmNetworkData.outcomeCountForTraining = DiceTrackerDB.learningData.lstmNetworkData.outcomeCountForTraining or 0

    -- Ensure predictor data structures are initialized
    DiceTrackerDB.weights = DiceTrackerDB.weights or {W1={}, b1={}, W2={}, b2={}}
    DiceTrackerDB.buckets = DiceTrackerDB.buckets or {}
    DiceTrackerDB.prevCategoryIndex = DiceTrackerDB.prevCategoryIndex or 0
    DiceTrackerDB.lastTossTime = DiceTrackerDB.lastTossTime or 0

    local ok, err = pcall(function()
        FFNetwork.W1 = DiceTrackerDB.weights.W1
        FFNetwork.b1 = DiceTrackerDB.weights.b1
        FFNetwork.W2 = DiceTrackerDB.weights.W2
        FFNetwork.b2 = DiceTrackerDB.weights.b2
    end)
    if not ok then
        print("DiceTracker: error loading weights", err)
    end
    FFNetwork:initialize()

    -- Initialize or load the LSTM network structure
    checkAndInitializeLSTMNetwork()

-- Evaluate and adapt the LSTM network
LSTMNetwork:evaluateAndAdapt()

-- Update the UI
addonTable.updateUI()

DiceTrackerDB.initialized = true

end
-- Train the neural network with the latest observed roll pair
processRollPair = function(player, roll1, roll2)
    if not LSTMNetwork:isFullyInitialized() then return end

    local now = time()
    if DiceTrackerDB.lastTossTime and (now - DiceTrackerDB.lastTossTime) > 300 then
        LSTMNetwork:resetStates()
    end

    local fv = buildFeatureVector(now)

    -- update bucket statistics, FF training, stats update...
    local bucket = getBucket(now)
    local total  = roll1 + roll2
    local cat    = (total<=6 and 1) or (total==7 and 2) or 3
    local catName = (cat==1 and "low") or (cat==2 and "seven") or "high"

    local b = DiceTrackerDB.buckets[bucket] or {Low=0,["7"]=0,High=0,count=0}
    local keyMap = {"Low","7","High"}
    b[keyMap[cat]] = (b[keyMap[cat]] or 0) + 1
    b.count = (b.count or 0) + 1
    DiceTrackerDB.buckets[bucket] = b

    FFNetwork:train(fv, {cat==1 and 1 or 0, cat==2 and 1 or 0, cat==3 and 1 or 0})

    DiceTrackerDB.stats = DiceTrackerDB.stats or {low=0, seven=0, high=0, totalRolls=0, correctPredictions=0, incorrectPredictions=0, accuracy=0}
    DiceTrackerDB.stats[catName] = (DiceTrackerDB.stats[catName] or 0) + 1
    DiceTrackerDB.stats.totalRolls = (DiceTrackerDB.stats.totalRolls or 0) + 1

    local correct = DiceTrackerDB.stats.lastPrediction == catName
    if correct then
        DiceTrackerDB.stats.correctPredictions = (DiceTrackerDB.stats.correctPredictions or 0) + 1
    else
        DiceTrackerDB.stats.incorrectPredictions = (DiceTrackerDB.stats.incorrectPredictions or 0) + 1
    end
    local c = DiceTrackerDB.stats.correctPredictions or 0
    local ic = DiceTrackerDB.stats.incorrectPredictions or 0
    local tp = c + ic
    DiceTrackerDB.stats.accuracy = tp > 0 and c/tp or 0

    -- record for LSTM: one-hot roll vectors
    local rollVec = {}
    for i=1,6 do rollVec[i] = (i==roll1) and 1 or 0 end
    for i=1,6 do rollVec[6+i] = (i==roll2) and 1 or 0 end

    local win = DiceTrackerDB.learningData.lstmNetworkData.slidingWindow
    table.insert(win, rollVec)
    if #win > DiceTrackerDB.learningData.lstmNetworkData.slidingWindowSize then
        table.remove(win, 1)
    end

    local seq    = {rollVec}
    local target = {cat==1 and 1 or 0, cat==2 and 1 or 0, cat==3 and 1 or 0}

    local function doTrainingPasses()
        local passes = 3
        local ticker
        ticker = C_Timer.NewTicker(0.05, function()
            if passes > 0 then
                local ok = pcall(function()
                    LSTMNetwork:forwardPass(seq)
                    LSTMNetwork:backwardPass(seq, LSTMNetwork:forwardPass(seq), target)
                end)
                if not ok then
                    print("DiceTracker: LSTM training error (ignored)")
                end
                passes = passes - 1
            else
                ticker:Cancel()
            end
        end)
    end
    doTrainingPasses()

    table.insert(DiceTrackerDB.learningData.lstmNetworkData.inputs, seq)
    local hist = DiceTrackerDB.learningData.lstmNetworkData.inputs
    if #hist > 5000 then
        for i=1,#hist-5000 do table.remove(hist,1) end
    end
    table.insert(DiceTrackerDB.learningData.lstmNetworkData.targets, target)
    local th = DiceTrackerDB.learningData.lstmNetworkData.targets
    if #th > 5000 then
        for i=1,#th-5000 do table.remove(th,1) end
    end

    scheduleSave()

    DiceTrackerDB.lastTossTime      = now
    DiceTrackerDB.prevCategoryIndex = cat

    DiceTrackerDB.stats.lastPrediction, DiceTrackerDB.stats.lastPredictionConfidence = addonTable:Predict()
    maybeUpdateUI()
end
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("CHAT_MSG_EMOTE")
frame:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
frame:RegisterEvent("CHAT_MSG_SYSTEM")
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "DiceTracker" then
            initializeAddonData()
            print("DiceTracker loaded.")
        end
    elseif event == "PLAYER_LOGOUT" then
        saveAddonData()
    elseif event == "PLAYER_ENTERING_WORLD" then
        initializeAddonData()
    elseif event == "CHAT_MSG_EMOTE" or event == "CHAT_MSG_TEXT_EMOTE" then
        local msg, player = ...
        -- Detect the emote indicating a dice toss from the Worn Troll Dice toy
        -- Match the text regardless of item link color codes or gendered pronouns
        if msg and msg:find("casually tosses") and msg:find("%[Worn Troll Dice%]") then
            if tossBuffer.player and time() - tossBuffer.time <= 10 then
                tossBuffer.rolls = {}
            end
            tossBuffer.player = Ambiguate(player, "none")
            tossBuffer.time = time()
            tossBuffer.rolls = {}
        end
    elseif event == "CHAT_MSG_SYSTEM" then
        local message = ...
        -- match the roll message from the dice, allowing any text within the parentheses
        local player, roll = message:match("^(.-) rolls (%d+) %b()$")
        player = player and Ambiguate(player, "none") or nil

        if tossBuffer.player and player == tossBuffer.player and roll then
            table.insert(tossBuffer.rolls, tonumber(roll))
            if #tossBuffer.rolls == 2 then
                -- hand the two-dice result off to your real tracker:
                processRollPair(tossBuffer.player,
                                tossBuffer.rolls[1],
                                tossBuffer.rolls[2])
                -- reset for the next toss:
                tossBuffer.player = nil
                tossBuffer.rolls  = {}
                -- immediately refresh the UI
                maybeUpdateUI()
            end
        end
        if tossBuffer.player and time() - tossBuffer.time > 10 then
            tossBuffer.player = nil
            tossBuffer.rolls = {}
        end
    end
end)
-- Define the retrainModelWithLatestData method
function LSTMNetwork:retrainModelWithLatestData()
if #DiceTrackerDB.learningData.lstmNetworkData.inputs == 0 then
print("No new data available for retraining.")
return
end

for i = 1, #DiceTrackerDB.learningData.lstmNetworkData.inputs do
    local input = DiceTrackerDB.learningData.lstmNetworkData.inputs[i]
    local target = DiceTrackerDB.learningData.lstmNetworkData.targets[i]
    -- Use the entire output sequence for backpropagation
    local outputs = self:forwardPass(input)
    self:backwardPass(input, outputs, target)
end

-- After training, clear the inputs and targets to start fresh
DiceTrackerDB.learningData.lstmNetworkData.inputs = {}
DiceTrackerDB.learningData.lstmNetworkData.targets = {}

end

-- Robust dot product that gracefully handles non-numeric values
function LSTMNetwork:dotProduct(a, b, size)
    local sum = 0
    for i = 1, size do
        local ai = tonumber(type(a) == "table" and a[i] or a) or 0
        local bi = tonumber(type(b) == "table" and b[i] or b) or 0
        sum = sum + ai * bi
    end
    return sum
end

function elementWiseMultiplyHelper(a, b)
    local maxLen = math.max(#a, #b)
    local result = {}
    for i = 1, maxLen do
        local ai = tonumber(a[i]) or 0
        local bi = tonumber(b[i]) or 0
        result[i] = ai * bi
    end
    return result
end

function LSTMNetwork:elementWiseMultiply(a, b)
if type(a) == "number" and type(b) == "table" then
return elementWiseMultiplyHelper({a}, b)
elseif type(a) == "table" and type(b) == "number" then
return elementWiseMultiplyHelper(a, {b})
elseif type(a) == "table" and type(b) == "table" then
return elementWiseMultiplyHelper(a, b)
else
error("Invalid input types for elementWiseMultiply")
end
end
function LSTMNetwork:applyTanh(x)
local result = {}
for i = 1, #x do
if type(x[i]) == "number" then
result[i] = tanh(x[i])
else
print("Warning: Skipping non-numeric value in applyTanh:", x[i])
result[i] = 0
end
end
return result
end

-- Slash commands for user interaction
SLASH_DICETRACKER1 = "/dicetracker"
SlashCmdList["DICETRACKER"] = function(msg)
    msg = msg and msg:lower() or ""
    if msg == "reset" then
        DiceTrackerDB.weights = {W1={}, b1={}, W2={}, b2={}}
        DiceTrackerDB.buckets = {}
        DiceTrackerDB.prevCategoryIndex = 0
        print("DiceTracker: data reset")
    elseif msg == "toggleui" then
        if statsFrame and statsFrame:IsShown() then
            statsFrame:Hide()
        else
            addonTable.updateUI()
            if statsFrame then statsFrame:Show() end
        end
    else
        print("/dicetracker reset | toggleui")
    end
end
function LSTMNetwork:elementWiseAdd(a, b)
local maxSize = math.max(#a, #b)
local result = {}
for i = 1, maxSize do
local valueA = type(a[i]) == "number" and a[i] or 0
local valueB = type(b[i]) == "number" and b[i] or 0
result[i] = valueA + valueB
end
return result
end
