# Flask API 服務，提供 GPT 相關功能
# 包含文本生成、摘要等 AI 能力接口

import os
from flask import Flask, request, jsonify

app = Flask(__name__)

# 從環境變數讀取 OpenAI API Key
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

@app.route('/test', methods=['GET'])
def test():
    """測試接口，確認服務運行狀態"""
    return "GPT service is running"

@app.route('/generate', methods=['POST'])
def generate():
    """文本生成接口"""
    data = request.get_json()
    prompt = data.get('prompt', '')
    
    # TODO: 實際調用 OpenAI API 進行文本生成
    # import openai
    # response = openai.ChatCompletion.create(...)
    
    return jsonify({"result": "mock generated text"})

@app.route('/summarize', methods=['POST'])
def summarize():
    """文本摘要接口"""
    data = request.get_json()
    content = data.get('content', '')
    
    # TODO: 實際調用 OpenAI API 進行文本摘要
    # import openai
    # response = openai.ChatCompletion.create(...)
    
    return jsonify({"summary": "mock summary"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)
