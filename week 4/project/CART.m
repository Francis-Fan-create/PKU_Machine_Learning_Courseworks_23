function [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
inputTable = trainingData;
predictorNames = {'x', 's', 'n', 't', 'p1', 'f', 'c', 'n1', 'k', 'e', 'e1', 's1', 's2', 'w', 'w1', 'p2', 'w2', 'o', 'p3', 'k1', 's3', 'u'};
predictors = inputTable(:, predictorNames);
response = inputTable.p;
isCategoricalPredictor = [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true];
classNames = categorical({'e'; 'p'});

% 训练分类器
classificationTree = fitctree(...
    predictors, ...
    response, ...
    'SplitCriterion', 'gdi', ...
    'MaxNumSplits', 4, ...
    'Surrogate', 'off', ...
    'ClassNames', classNames);

% 使用预测函数创建结果结构体
predictorExtractionFcn = @(t) t(:, predictorNames);
treePredictFcn = @(x) predict(classificationTree, x);
trainedClassifier.predictFcn = @(x) treePredictFcn(predictorExtractionFcn(x));

% 向结果结构体中添加字段
trainedClassifier.RequiredVariables = {'c', 'e', 'e1', 'f', 'k', 'k1', 'n', 'n1', 'o', 'p1', 'p2', 'p3', 's', 's1', 's2', 's3', 't', 'u', 'w', 'w1', 'w2', 'x'};
trainedClassifier.ClassificationTree = classificationTree;
trainedClassifier.About = '此结构体是从分类学习器 R2023a 导出的训练模型。';
trainedClassifier.HowToPredict = sprintf('要对新表 T 进行预测，请使用: \n [yfit,scores] = c.predictFcn(T) \n将 ''c'' 替换为作为此结构体的变量的名称，例如 ''trainedModel''。\n \n表 T 必须包含由以下内容返回的变量: \n c.RequiredVariables \n变量格式(例如矩阵/向量、数据类型)必须与原始训练数据匹配。\n忽略其他变量。\n \n有关详细信息，请参阅 <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>。');

% 提取预测变量和响应
inputTable = trainingData;
predictorNames = {'x', 's', 'n', 't', 'p1', 'f', 'c', 'n1', 'k', 'e', 'e1', 's1', 's2', 'w', 'w1', 'p2', 'w2', 'o', 'p3', 'k1', 's3', 'u'};
predictors = inputTable(:, predictorNames);
response = inputTable.p;
isCategoricalPredictor = [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true];
classNames = categorical({'e'; 'p'});

% 设置留出法验证
cvp = cvpartition(response, 'Holdout', 0.44);
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :);
trainingIsCategoricalPredictor = isCategoricalPredictor;

% 训练分类器
classificationTree = fitctree(...
    trainingPredictors, ...
    trainingResponse, ...
    'SplitCriterion', 'gdi', ...
    'MaxNumSplits', 4, ...
    'Surrogate', 'off', ...
    'ClassNames', classNames);

% 使用预测函数创建结果结构体
treePredictFcn = @(x) predict(classificationTree, x);
validationPredictFcn = @(x) treePredictFcn(x);

% 计算验证预测
validationPredictors = predictors(cvp.test, :);
validationResponse = response(cvp.test, :);
[validationPredictions, validationScores] = validationPredictFcn(validationPredictors);

% 计算验证准确度
correctPredictions = (validationPredictions == validationResponse);
isMissing = ismissing(validationResponse);
correctPredictions = correctPredictions(~isMissing);
validationAccuracy = sum(correctPredictions)/length(correctPredictions);
