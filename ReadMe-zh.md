# Bit Slicer

![Bit Slicer 图标](https://zgcoder.net/software/bitslicer/images/web_icon.png#3)

[下载 Bit Slicer](https://github.com/RayanceKing/Bit-Slicer-ZH/releases)

> 本仓库是上游 [Bit Slicer](https://github.com/zorgiepoo/Bit-Slicer) 的**简体中文分支**：在保留全部功能的基础上，内置了简体中文本地化，并在「设置」中新增了界面语言切换功能。下方内容翻译自上游 ReadMe，与本分支不一致的地方已单独标注。

## 简介

Bit Slicer 是 macOS 上的通用游戏修改工具，基于 Cocoa 与 Mach 内核 API 编写。

它通过搜索并修改游戏中的数值（例如分数、生命值、弹药等），让你在游戏中作弊。

## 功能

* 内存扫描
	* 搜索并收窄多种类型的值：整数、浮点数、字符串、字节数组、指针
	* 便捷地添加、删除、修改变量
	* 冻结变量的值
	* 保存进程的整个虚拟内存空间，并基于增量变化进行搜索
	* 通过解引用变量地址操作指针
* 内存查看
	* 以十六进制编辑器风格的窗口实时查看与编辑内存
	* 把内存转储到磁盘文件，便于人工分析
	* 修改内存保护属性
* 调试器
	* 监视哪些指令访问了文档中的某个变量
	* 实时查看指令的反汇编结果
	* 直接修改指令字节，或汇编写入（包括填充 nop）
	* 设置断点、命中后继续运行、查看调用栈、操作线程寄存器，以及单步步入 / 步出 / 步过
	* 运行中动态注入新的汇编代码
* 保存切片（slice）文档，方便把修改方案发给朋友
* 编写 Python 脚本，自动化虚拟内存与调试器相关的操作
* 暂停与恢复当前进程
* 支持多种操作的撤销与重做，包括搜索
* 自动求解数学表达式（例如在 Flash 游戏中直接搜索 `58 * 8`）
* 以普通用户运行，不需要 root 权限！
* 支持系统级特性：自动保存、文档版本、窗口状态恢复、App Nap、深色模式等

### 本分支新增

* **界面语言切换**：`⌘,` 打开「设置 → 通用 / General」，可以在「跟随系统」「简体中文」「English」「Español」「Русский」之间选择。语言列表由应用内置的本地化资源自动生成，选择后重启应用生效，设置面板中有「重新启动」按钮。设置窗口可自由拉伸，没有最小尺寸限制。

## 系统要求

* **本分支构建产物**：Apple Silicon（M 系列）Mac，**macOS 15.6 或更新**

> 上游官方发行版要求 macOS 11.5 或更新。本分支将 Xcode 工程的 `MACOSX_DEPLOYMENT_TARGET` 提高到了 15.6，且仅构建 arm64 架构，因此无法在 Intel Mac 或更早的 macOS 上运行。如需支持旧系统，请自行下调部署目标。

以下是上游历史版本对系统的要求，仅供参考：

* [1.8.2](https://github.com/zorgiepoo/Bit-Slicer/releases/download/1.8.2/Bit.Slicer.dmg)：macOS 10.14.6
* [1.7.12](https://github.com/zorgiepoo/Bit-Slicer/releases/download/1.7.12/Bit.Slicer.dmg)：macOS 10.13
* [1.7.11](https://github.com/zorgiepoo/Bit-Slicer/releases/download/1.7.11/Bit.Slicer.dmg)：macOS 10.11
* [1.7.9](https://github.com/zorgiepoo/Bit-Slicer/releases/download/1.7.9/Bit.Slicer.dmg)：macOS 10.10
* [1.7.8](https://github.com/zorgiepoo/Bit-Slicer/releases/download/1.7.8/Bit.Slicer.dmg)：macOS 10.8
* [1.6.2](https://github.com/zorgiepoo/Bit-Slicer/releases/download/1.6.2/Bit_Slicer_1.6.2.zip)：macOS 10.6.8，Intel 64 位 Mac
* [1.5.2](https://github.com/zorgiepoo/Bit-Slicer/releases/download/1.5.2/Bit_Slicer_1.5.2.zip)：macOS 10.6.8

## 支持

* 阅读 [Wiki](https://github.com/zorgiepoo/Bit-Slicer/wiki/) 了解如何使用 Bit Slicer
* 在 [Discord 房间](https://discord.gg/qpfdYYw) 交流。注意并非全天候有人提供帮助
* 本分支的问题请在本仓库的 [Issues](https://github.com/RayanceKing/Bit-Slicer-ZH/issues) 中反馈

## 参与贡献

* 改进 [Wiki](https://github.com/zorgiepoo/Bit-Slicer/wiki/)：修正错误或补充内容
* 在 issue tracker 报告 bug 或提出功能需求
* [帮助把 Bit Slicer 翻译成其他语言](https://github.com/zorgiepoo/Bit-Slicer/wiki/Localization)
* 了解[如何构建源码并贡献代码](https://github.com/zorgiepoo/Bit-Slicer/wiki/Source-Code)

本地化资源位于 `Bit Slicer/<语言>.lproj/`（现有 `en` / `es` / `ru` / `zh` 与 `Base`）：xib 界面文案放在与 xib 同名的 `.strings` 中，代码文案放在 `[Code] <模块名>.strings`，复数规则使用 `.stringsdict`。请注意 es、ru、zh 目录下的 `[Code] *.strings` 为 UTF-16LE 编码，修改前先确认编码，并用 `plutil -lint` 校验。

参与贡献前，请阅读项目根目录下的 [Code Of Conduct](CODE_OF_CONDUCT.md)。

## 许可与再分发

本分支遵循上游的 BSD 风格许可，详见 [LICENSE](LICENSE)：源码与二进制形式的再分发都必须保留版权声明、条件与免责声明；未经事先书面许可，不得以原作者或贡献者的名义为衍生产品背书。

需要注意，`LICENSE` 中明确排除了部分美术资源的再分发授权：

* `bitslicericon.icon`（Matthew Skiles 设计的应用图标）
* `bitslicerdocicon.iconset/` 与 `bitslicerdocicon.svg`（maxtron95 设计的文档图标）

这些资源在未经 Bit Slicer 作者事先书面许可的情况下，不得随二进制包再分发或修改。若要以二进制形式公开发布本分支，请先取得许可或更换为自有美术资源。以上为对 `LICENSE` 条款的转述，不构成法律意见。

## 致谢

* 开发者：Mayur Pawashe
* 美术：Matthew Skiles（应用图标）、maxtron95（文档图标与旧版应用图标）、Aureliano Candido（旧版美术）
* 本地化：Haoyan Zhang（简体中文）、Dmitry Petrenko（Русский）、Sebastian Mallol（Español）
* 所用框架：Capstone（反汇编）、Keystone（汇编）、CoreSymbolication Header（调试符号）、Shortcut Recorder（全局快捷键）、DDMathParser（数学表达式求值）、AGScopeBar（搜索范围栏）、Hex Fiend（内存查看与字符串搜索）、Sparkle（自动更新）、Python（脚本支持）
