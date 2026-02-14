# LangChain

> 最流行的 LLM 应用开发框架

## 📊 项目概览

- **GitHub**: https://github.com/langchain-ai/langchain
- **Stars**: 85k+
- **Forks**: 12k+
- **License**: MIT
- **语言**: Python, TypeScript/JavaScript
- **发布日期**: 2022-10
- **维护状态**: 活跃开发中

---

## 🎯 项目简介

LangChain 是一个用于构建上下文感知推理应用的开源框架。它提供了模块化的组件，让开发者能够轻松构建复杂的 AI 应用，包括聊天机器人、智能体、RAG 系统等。

### 核心特性

- **模块化设计**：链（Chains）、智能体（Agents）、记忆（Memory）、工具（Tools）
- **多 LLM 支持**：OpenAI、Anthropic、HuggingFace、Ollama 等
- **丰富的集成**：50+ 文档加载器、向量数据库、工具
- **企业级特性**：监控、日志、部署支持

---

## 🏗️ 技术架构

```
┌─────────────────────────────────────────┐
│          应用层                          │
│  (Chatbots, Agents, RAG Applications)   │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│        LangChain 核心层                 │
│  ┌──────────┐  ┌──────────┐  ┌──────┐ │
│  │ Chains   │  │ Agents   │  │Memory│ │
│  └──────────┘  └──────────┘  └──────┘ │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│         集成层                           │
│  ┌──────────┐  ┌──────────┐  ┌──────┐ │
│  │LLMs      │  │Vector DB │  │Tools │ │
│  └──────────┘  └──────────┘  └──────┘ │
└─────────────────────────────────────────┘
```

### 核心组件

#### 1. Chains（链）

将多个组件串联起来形成工作流。

```python
from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate

# 创建提示模板
prompt = PromptTemplate(
    input_variables=["product"],
    template="为 {product} 写一段营销文案"
)

# 创建链
chain = LLMChain(llm=llm, prompt=prompt)

# 运行
result = chain.run("AI 写作助手")
```

#### 2. Agents（智能体）

让 LLM 根据用户输入自主决定使用哪些工具。

```python
from langchain.agents import Tool, AgentExecutor
from langchain.tools import DuckDuckGoSearchRun

# 定义工具
search = DuckDuckGoSearchRun()
tools = [
    Tool(
        name="Search",
        func=search.run,
        description="搜索互联网信息"
    )
]

# 创建智能体
agent = initialize_agent(tools, llm, agent="zero-shot-react-description")

# 运行
agent.run("2026年最新的AI趋势是什么？")
```

#### 3. Memory（记忆）

让应用记住对话历史。

```python
from langchain.memory import ConversationBufferMemory

memory = ConversationBufferMemory()
memory.save_context({"input": "你好"}, {"output": "你好！有什么可以帮助你的？"})
memory.load_memory_variables({})
```

---

## 🚀 最佳实践场景

### 场景 1：企业知识库问答系统

**适用情况**：
- 企业有大量文档需要查询
- 需要准确的答案，避免幻觉
- 要求引用来源

**实施步骤**：

1. **安装依赖**
```bash
pip install langchain openai chromadb
```

2. **加载文档**
```python
from langchain.document_loaders import DirectoryLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter

loader = DirectoryLoader('./docs', glob="**/*.pdf")
documents = loader.load()

text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200
)
splits = text_splitter.split_documents(documents)
```

3. **创建向量存储**
```python
from langchain.vectorstores import Chroma
from langchain.embeddings import OpenAIEmbeddings

embedding = OpenAIEmbeddings()
vectordb = Chroma.from_documents(
    documents=splits,
    embedding=embedding,
    persist_directory="./chroma_db"
)
```

4. **构建检索链**
```python
from langchain.chains import RetrievalQA
from langchain.chat_models import ChatOpenAI

llm = ChatOpenAI(model="gpt-4", temperature=0)
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=vectordb.as_retriever(search_kwargs={"k": 3}),
    return_source_documents=True
)
```

5. **查询**
```python
query = "公司的休假政策是什么？"
result = qa_chain({"query": query})

print(f"答案: {result['result']}")
print(f"来源: {result['source_documents']}")
```

**生产环境建议**：
- 使用更快的向量数据库（如 Pinecone、Qdrant）
- 添加缓存层减少 API 调用
- 实施重试机制处理失败
- 添加日志和监控

---

### 场景 2：AI 智能客服

**适用情况**：
- 需要处理大量用户咨询
- 部分问题需要人工介入
- 需要记住对话上下文

**实施步骤**：

```python
from langchain.agents import Tool, AgentExecutor, create_openai_functions_agent
from langchain.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.memory import ConversationBufferMemory
from langchain.tools import StructuredTool
from pydantic import BaseModel, Field

# 定义工具的输入模型
class SearchInput(BaseModel):
    query: str = Field(description="搜索查询")

def search_knowledgebase(query: str) -> str:
    """搜索产品知识库"""
    # 实现知识库搜索逻辑
    return "搜索结果"

def escalate_to_human(issue: str) -> str:
    """转接到人工客服"""
    # 实现人工转接逻辑
    return f"已转接到人工客服：{issue}"

tools = [
    StructuredTool.from_function(
        func=search_knowledgebase,
        name="SearchKB",
        description="搜索产品知识库，回答常见问题",
        args_schema=SearchInput
    ),
    Tool(
        name="Escalate",
        func=escalate_to_human,
        description="将复杂问题转接到人工客服"
    )
]

# 创建提示模板
prompt = ChatPromptTemplate.from_messages([
    ("system", """你是一个专业的AI客服助手。
     使用提供的工具回答用户问题。
     如果问题复杂或涉及敏感信息，使用 Escalate 工具转接人工客服。
     """),
    MessagesPlaceholder(variable_name="chat_history"),
    ("human", "{input}"),
    MessagesPlaceholder(variable_name="agent_scratchpad")
])

# 创建智能体
llm = ChatOpenAI(model="gpt-4", temperature=0)
agent = create_openai_functions_agent(llm, tools, prompt)

memory = ConversationBufferMemory(
    memory_key="chat_history",
    return_messages=True,
    max_token_limit=2000
)

agent_executor = AgentExecutor(
    agent=agent,
    tools=tools,
    memory=memory,
    verbose=True,
    handle_parsing_errors=True,
    max_iterations=5
)
```

**使用示例**：
```python
# 简单问答
result = agent_executor.invoke({
    "input": "如何重置密码？"
})

# 复杂问题转接
result = agent_executor.invoke({
    "input": "我的账户被锁定了，需要紧急处理"
})
```

---

### 场景 3：多步骤工作流自动化

**适用情况**：
- 需要多步骤处理任务
- 每个步骤依赖前一步的输出
- 需要错误处理和回退机制

**实施步骤**：

```python
from langchain.chains import SequentialChain
from langchain.prompts import PromptTemplate

# 步骤 1：生成大纲
outline_prompt = PromptTemplate(
    input_variables=["topic"],
    template="为以下主题生成一个详细的大纲：{topic}"
)

outline_chain = LLMChain(
    llm=llm,
    prompt=outline_prompt,
    output_key="outline"
)

# 步骤 2：根据大纲生成内容
content_prompt = PromptTemplate(
    input_variables=["outline"],
    template="根据以下大纲写一篇完整的文章：\n{outline}"
)

content_chain = LLMChain(
    llm=llm,
    prompt=content_prompt,
    output_key="content"
)

# 步骤 3：生成摘要
summary_prompt = PromptTemplate(
    input_variables=["content"],
    template="为以下文章生成一个100字的摘要：\n{content}"
)

summary_chain = LLMChain(
    llm=llm,
    prompt=summary_prompt,
    output_key="summary"
)

# 组合成顺序链
overall_chain = SequentialChain(
    chains=[outline_chain, content_chain, summary_chain],
    input_variables=["topic"],
    output_variables=["outline", "content", "summary"],
    verbose=True
)

# 运行
result = overall_chain("AI 在教育中的应用")
```

---

## ⚠️ 注意事项

### 常见陷阱

1. **提示词泄露**
   - 问题：将敏感信息放入提示词
   - 解决：使用加密、审计日志

2. **成本失控**
   - 问题：频繁调用 LLM API 导致高额费用
   - 解决：
     - 使用缓存
     - 选择合适的模型（GPT-3.5 vs GPT-4）
     - 设置预算告警

3. **延迟问题**
   - 问题：复杂链导致响应慢
   - 解决：
     - 使用更快的模型
     - 并行处理独立任务
     - 异步执行

4. **幻觉问题**
   - 问题：LLM 生成不准确的信息
   - 解决：
     - 使用 RAG（检索增强生成）
     - 限制模型的知识范围
     - 添加事实核查步骤

---

## 🔄 替代方案对比

| 框架 | 优势 | 劣势 | 推荐场景 |
|------|------|------|----------|
| **LangChain** | 生态完整、文档丰富、社区活跃 | 学习曲线陡峭、性能有待优化 | 复杂 AI 应用、快速原型 |
| [LlamaIndex](https://github.com/run-llama/llama_index) | 专注于 RAG、性能好、索引强大 | 生态相对较小、灵活性较低 | 数据密集型应用、企业搜索 |
| [Haystack](https://github.com/deepset-ai/haystack) | 企业级、文档好、生产就绪 | 社区较小、更新较慢 | 企业级部署、NLP 应用 |
| [Semantic Kernel](https://github.com/microsoft/semantic-kernel) | Microsoft 支持、企业友好 | 功能相对新、社区小 | Microsoft 生态集成 |

---

## 📚 学习资源

### 官方资源

- **文档**: https://python.langchain.com/
- **GitHub**: https://github.com/langchain-ai/langchain
- **Discord**: https://discord.gg/6ADMQjjRK5

### 推荐教程

1. **[LangChain 快速入门](https://python.langchain.com/docs/get_started/introduction)**
2. **[RAG 应用开发指南](https://python.langchain.com/docs/use_cases/question_answering)**
3. **[Agent 开发教程](https://python.langchain.com/docs/modules/agents/)**

### 示例项目

- **GitHub Awesome LangChain**: https://github.com/sugarforever/LangChain-Tutorials
- **LangChain Cookbook**: https://github.com/gkamradt/langchain-tutorials

---

## 💡 专家建议

### 适合人群

✅ **推荐使用**：
- 需要快速构建 AI 原型
- 开发复杂的 AI 应用
- 需要丰富的集成支持
- 企业级开发需求

❌ **不推荐使用**：
- 简单的 LLM API 调用（直接用 API 更简单）
- 性能要求极高的场景
- 预算非常有限（考虑开源替代）

### 生产环境检查清单

- [ ] 实施错误处理和重试机制
- [ ] 添加日志和监控
- [ ] 设置 API 调用限制和预算告警
- [ ] 使用缓存减少 API 调用
- [ ] 实施安全措施（敏感信息处理）
- [ ] 性能测试和优化
- [ ] 文档和代码注释
- [ ] 单元测试和集成测试

---

## 📊 项目卡片

| 属性 | 值 |
|------|-----|
| 开发语言 | Python, TypeScript |
| 许可证 | MIT |
| 活跃度 | ⭐⭐⭐⭐⭐ (非常活跃) |
| 学习曲线 | ⭐⭐⭐⭐ (较陡) |
| 文档质量 | ⭐⭐⭐⭐⭐ (优秀) |
| 生产就绪 | ⭐⭐⭐⭐ (适合生产) |
| 社区支持 | ⭐⭐⭐⭐⭐ (强大) |

---

**最后更新**: 2026-02-11
**维护者**: OpenClaw AI Agent
**推荐指数**: ★★★★★ (强烈推荐)
