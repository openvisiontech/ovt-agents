

# **Technical Whitepaper: Uli SDK**

## **Bridging Robotic Assets with Agentic AI**

### 

### **Executive Overview**

The **Uli (Unified Link Interface) SDK** is the robotic nervous system for Agentic AI, serving as a high-performance middleware that bridges the gap between traditional infrastructures of robotic assets and modern agentic AI ecosystems.

---

### **1\. Core Architectural Principles**

#### **Dynamic and Self-Configuring Infrastructure**

At the heart of the Uli SDK is a dynamic, self-configuring infrastructure. This architecture allows functional modules to be discovered, integrated, and utilized at runtime through unified interfaces. By eliminating static, pre-configured connections, the system achieves true agility, allowing components to be seamlessly added or removed to meet evolving mission requirements.

#### **Multi-Domain Interoperability**

The framework connects disparate systems across multiple domains:

* **Aerial and Ground Assets**: Drones and autonomous vehicles.  
* **Operational Systems**: Robot arms, process tools, and controllers.  
* **Intelligence Layers**: AI agents and data viewers/loggers.

Leveraging a **DoW MOSA-compliant design** (Modular Open Systems Approach), the Uli SDK ensures seamless collaboration and rapid reconfiguration.

---

### **2\. AI Integration**

#### 

The Uli SDK implements a **Discovery-Driven Semantic Engine**. This infrastructure provides standardized services that allow robotic assets to export themselves, their functional capabilities, and their telemetry as context for synthesis into a **Knowledge Graph**.

**Implementation Detail:**

* **Standardized Discovery Services:** Assets "self-announce" via the Unified Link Interface (ULI), broadcasting identity (Asset URI, Pose, Privileges), functional skills (Agent Context), and data structures (Telemetry Context).  
* **Knowledge Graph Synthesis:** The discovery engine automatically instantiates discovered data as nodes and edges within a dynamic Knowledge Graph. This creates a searchable **Context Layer** that AI agents use for semantic retrieval.  
* **State Estimation:** Beyond raw data access, AI agents leverage the **Telemetry Context** to perform high-level state estimation. By reasoning over the semantics of subscribed data topics within the graph, agents maintain a real-time world model of the asset's physical and operational status.  
* **Python & AI Integration:** Through native **Python Bindings**, the SDK enables immediate interoperability with the broader AI ecosystem, including ROS-based stacks and ML research modules, allowing for rapid transition from simulation to hardware.    
* **Agent-to-UI (A2UI)**: Telemetry Context provides the information needed for the AI to select appropriate Flutter UI Widgets for displaying data or providing user input fields for configuration and periodic control parameters.

---

### **3\. Operational Integrity: Security, Safety, and Reliability**

* **Security**: The framework utilizes a **certificate-based authentication** model. Access is strictly governed by the Data Access Privileges (Classified, Controlled, Unclassified) and App Access roles (Operator, Maintainer, Administrator) defined in the Asset Context.  
* **Safety**: An integrated safety framework combines proactive detection with a redundant triggering system. It automatically responds to application errors or manual e-stop commands.  
* **Reliability**: Achieved through a two-tiered state machine system supported by operating modes such as Standard, Reduced, Training, and Maintenance.

---

### **4\. Development and Deployment Ecosystem**

* **Code Generation**: Utilities produce C++ code for messages and applications while automatically generating **Python bindings** and **Dart-FFI**.  
* **High-Efficiency Building**: Utilizes **Bazel** for cross-building for x86\_64 and **NVIDIA Jetson** (Nano, Xavier, Orin).  
* **IDE Support**: Developers utilize the **Claude Code** and **Google Antigravity IDE** for accelerated SDK development.  
* **Deployment**: Included shell scripts simplify the staging and deployment of applications across networked devices.

---

### **Conclusion**

The Uli SDK is engineered to deliver a decisive edge in adaptability and operational integrity. By bridging the gap between AI and robotics through a skills-based, MOSA-compliant architecture, it provides a mission-ready solution that eliminates vendor lock-in.

**For more information, visit [www.ulisdk.com](http://www.ulisdk.com/).**