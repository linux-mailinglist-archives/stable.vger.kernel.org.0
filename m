Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741874D8532
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiCNMsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234819AbiCNMrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:47:42 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5465A59E;
        Mon, 14 Mar 2022 05:39:45 -0700 (PDT)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nTjzD-0000dE-1V; Mon, 14 Mar 2022 13:39:43 +0100
Message-ID: <ad06e7b6-19f5-c499-314b-a3b4a0e27089@leemhuis.info>
Date:   Mon, 14 Mar 2022 13:39:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Bisected regression: 4287509b4d21 causes HP Spectre 14t-ea100 to
 overheat while suspended #forregzbot
Content-Language: en-US
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     Philippe Troin <phil@fifi.org>
Cc:     linux-kernel@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <e1b3112fd6c8c889408915e9a849301d13acf2f1.camel@fifi.org>
 <6c119f2e-1bf8-60b8-ce32-113a30d29152@leemhuis.info>
In-Reply-To: <6c119f2e-1bf8-60b8-ce32-113a30d29152@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1647261585;3876a0ea;
X-HE-SMSGID: 1nTjzD-0000dE-1V
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

TWIMC: this mail is primarily send for documentation purposes and for
regzbot, my Linux kernel regression tracking bot. These mails usually
contain '#forregzbot' in the subject, to make them easy to spot and filter.

Just for the record: this should be fixed in 5.16.14

#regzbot fixed-by: cf6eae0facc6022

Ciao, Thorsten

On 09.03.22 09:03, Thorsten Leemhuis wrote:
> [TLDR: I'm adding the regression report below to regzbot, the Linux
> kernel regression tracking bot; all text you find below is compiled from
> a few templates paragraphs you might have encountered already already
> from similar mails.]
> 
> Hi, this is your Linux kernel regression tracker.
> 
> On 09.03.22 04:50, Philippe Troin wrote:
>> Linux 5.16.9 was working fine, but starting with 5.16.10 my main laptop
>> has been overheating while suspended.
>> I've also tried 5.16.11, 5.16.12 and 5.16.13 and they also show the
>> same issue (overheating while suspended).
>>
>> I could not spot any difference between the dmesg messages issued
>> during suspend between a working version (5.16.9) and the the broken
>> ones (5.16.1[0-3]).
>>
>> I've bisected the regression down to commit 4287509b4d21
>> https://lore.kernel.org/lkml/20220214092510.074083242@linuxfoundation.org/
>>
>> I have also tried reverting that change on top of 5.16.12, and the
>> overheating behavior is gone.
>>
>> lspci and other details below.
>>
>> Phil.
> 
> Thanks for the report.
> 
> CCing the stable and the regression mailing list
> 
> To be sure below issue doesn't fall through the cracks unnoticed, I'm
> adding it to regzbot, my Linux kernel regression tracking bot:
> 
> #regzbot ^introduced 4287509b4d21
> #regzbot title HP Spectre 14t-ea100 overheats while suspended
> #regzbot ignore-activity
> 
> If it turns out this isn't a regression, free free to remove it from the
> tracking by sending a reply to this thread containing a paragraph like
> "#regzbot invalid: reason why this is invalid" (without the quotes).
> 
> Reminder for developers: when fixing the issue, please add a 'Link:'
> tags pointing to the report (the mail quoted above) using
> lore.kernel.org/r/, as explained in
> 'Documentation/process/submitting-patches.rst' and
> 'Documentation/process/5.Posting.rst'. Regzbot needs them to
> automatically connect reports with fixes, but they are useful in
> general, too.
> 
> I'm sending this to everyone that got the initial report, to make
> everyone aware of the tracking. I also hope that messages like this
> motivate people to directly get at least the regression mailing list and
> ideally even regzbot involved when dealing with regressions, as messages
> like this wouldn't be needed then. And don't worry, if I need to send
> other mails regarding this regression only relevant for regzbot I'll
> send them to the regressions lists only (with a tag in the subject so
> people can filter them away). With a bit of luck no such messages will
> be needed anyway.
> 
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> 
> P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> reports on my table. I can only look briefly into most of them and lack
> knowledge about most of the areas they concern. I thus unfortunately
> will sometimes get things wrong or miss something important. I hope
> that's not the case here; if you think it is, don't hesitate to tell me
> in a public reply, it's in everyone's interest to set the public record
> straight.
> 
> 
> 
>> The laptop is a HP Spectre x360 Convertible 14t-ea100.
>>
>> CPU (/proc/cpuinfo): 11th Gen Intel(R) Core(TM) i7-1195G7 @ 2.90GHz
>>
>> # lspci -v
>> 0000:00:00.0 Host bridge: Intel Corporation 11th Gen Core Processor Host Bridge/DRAM Registers (rev 02)
>> 	Subsystem: Hewlett-Packard Company Device 89db
>> 	Flags: bus master, fast devsel, latency 0, IOMMU group 0
>> 	Capabilities: [e0] Vendor Specific Information: Len=14 <?>
>> 	Kernel modules: igen6_edac
>>
>> 0000:00:02.0 VGA compatible controller: Intel Corporation TigerLake-LP GT2 [Iris Xe Graphics] (rev 03) (prog-if 00 [VGA controller])
>> 	DeviceName:  Onboard IGD
>> 	Subsystem: Hewlett-Packard Company Device 89db
>> 	Flags: bus master, fast devsel, latency 0, IRQ 159, IOMMU group 1
>> 	Memory at 603e000000 (64-bit, non-prefetchable) [size=16M]
>> 	Memory at 4000000000 (64-bit, prefetchable) [size=256M]
>> 	I/O ports at 3000 [size=64]
>> 	Expansion ROM at 000c0000 [virtual] [disabled] [size=128K]
>> 	Capabilities: [40] Vendor Specific Information: Len=0c <?>
>> 	Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
>> 	Capabilities: [ac] MSI: Enable+ Count=1/1 Maskable+ 64bit-
>> 	Capabilities: [d0] Power Management version 2
>> 	Capabilities: [100] Process Address Space ID (PASID)
>> 	Capabilities: [200] Address Translation Service (ATS)
>> 	Capabilities: [300] Page Request Interface (PRI)
>> 	Capabilities: [320] Single Root I/O Virtualization (SR-IOV)
>> 	Kernel driver in use: i915
>> 	Kernel modules: i915
>>
>> 0000:00:04.0 Signal processing controller: Intel Corporation TigerLake-LP Dynamic Tuning Processor Participant (rev 02)
>> 	Subsystem: Hewlett-Packard Company Device 89db
>> 	Flags: fast devsel, IRQ 16, IOMMU group 2
>> 	Memory at 603f240000 (64-bit, non-prefetchable) [size=128K]
>> 	Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
>> 	Capabilities: [d0] Power Management version 3
>> 	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
>> 	Kernel driver in use: proc_thermal
>> 	Kernel modules: processor_thermal_device_pci_legacy
>>
>> 0000:00:07.0 PCI bridge: Intel Corporation Tiger Lake-LP Thunderbolt 4 PCI Express Root Port #0 (rev 02) (prog-if 00 [Normal decode])
>> 	Flags: bus master, fast devsel, latency 0, IRQ 124, IOMMU group 3
>> 	Bus: primary=00, secondary=01, subordinate=2b, sec-latency=0
>> 	I/O behind bridge: 00004000-00004fff [size=4K]
>> 	Memory behind bridge: 7a000000-861fffff [size=194M]
>> 	Prefetchable memory behind bridge: 0000006020000000-000000603bffffff [size=448M]
>> 	Capabilities: [40] Express Root Port (Slot+), MSI 00
>> 	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>> 	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 89da
>> 	Capabilities: [a0] Power Management version 3
>> 	Capabilities: [100] Null
>> 	Capabilities: [220] Access Control Services
>> 	Capabilities: [a00] Downstream Port Containment
>> 	Kernel driver in use: pcieport
>>
>> 0000:00:07.1 PCI bridge: Intel Corporation Tiger Lake-LP Thunderbolt 4 PCI Express Root Port #1 (rev 02) (prog-if 00 [Normal decode])
>> 	Flags: bus master, fast devsel, latency 0, IRQ 125, IOMMU group 4
>> 	Bus: primary=00, secondary=2c, subordinate=56, sec-latency=0
>> 	I/O behind bridge: 00005000-00005fff [size=4K]
>> 	Memory behind bridge: 6c000000-781fffff [size=194M]
>> 	Prefetchable memory behind bridge: 0000006000000000-000000601bffffff [size=448M]
>> 	Capabilities: [40] Express Root Port (Slot+), MSI 00
>> 	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>> 	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 89da
>> 	Capabilities: [a0] Power Management version 3
>> 	Capabilities: [100] Null
>> 	Capabilities: [220] Access Control Services
>> 	Capabilities: [a00] Downstream Port Containment
>> 	Kernel driver in use: pcieport
>>
>> 0000:00:08.0 System peripheral: Intel Corporation GNA Scoring Accelerator module (rev 02)
>> 	Subsystem: Hewlett-Packard Company Device 89db
>> 	Flags: fast devsel, IRQ 255, IOMMU group 5
>> 	Memory at 603f2a2000 (64-bit, non-prefetchable) [disabled] [size=4K]
>> 	Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
>> 	Capabilities: [a0] Vendor Specific Information: Len=14 <?>
>> 	Capabilities: [dc] Power Management version 2
>> 	Capabilities: [f0] PCI Advanced Features
>>
>> 0000:00:0d.0 USB controller: Intel Corporation Tiger Lake-LP Thunderbolt 4 USB Controller (rev 02) (prog-if 30 [XHCI])
>> 	Subsystem: Hewlett-Packard Company Device 89db
>> 	Flags: bus master, medium devsel, latency 0, IRQ 127, IOMMU group 6
>> 	Memory at 603f280000 (64-bit, non-prefetchable) [size=64K]
>> 	Capabilities: [70] Power Management version 2
>> 	Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
>> 	Capabilities: [90] Vendor Specific Information: Len=14 <?>
>> 	Capabilities: [b0] Vendor Specific Information: Len=00 <?>
>> 	Kernel driver in use: xhci_hcd
>>
>> 0000:00:0d.2 USB controller: Intel Corporation Tiger Lake-LP Thunderbolt 4 NHI #0 (rev 02) (prog-if 40 [USB4 Host Interface])
>> 	Subsystem: Device 2222:1111
>> 	Flags: bus master, fast devsel, latency 0, IRQ 16, IOMMU group 6
>> 	Memory at 603f200000 (64-bit, non-prefetchable) [size=256K]
>> 	Memory at 603f2a1000 (64-bit, non-prefetchable) [size=4K]
>> 	Capabilities: [80] Power Management version 3
>> 	Capabilities: [88] MSI: Enable- Count=1/1 Maskable- 64bit+
>> 	Capabilities: [a0] MSI-X: Enable+ Count=16 Masked-
>> 	Kernel driver in use: thunderbolt
>> 	Kernel modules: thunderbolt
>>
>> 0000:00:0e.0 RAID bus controller: Intel Corporation Volume Management Device NVMe RAID Controller
>> 	Subsystem: Intel Corporation Device 0000
>> 	Flags: bus master, fast devsel, latency 0, IOMMU group 7
>> 	Memory at 603c000000 (64-bit, non-prefetchable) [size=32M]
>> 	Memory at 6a000000 (32-bit, non-prefetchable) [size=32M]
>> 	Memory at 603f100000 (64-bit, non-prefetchable) [size=1M]
>> 	Capabilities: [80] MSI-X: Enable+ Count=19 Masked-
>> 	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
>> 	Capabilities: [e0] Power Management version 3
>> 	Kernel driver in use: vmd
>> 	Kernel modules: vmd
>>
>> 0000:00:12.0 Serial controller: Intel Corporation Tiger Lake-LP Integrated Sensor Hub (rev 30) (prog-if 00 [8250])
>> 	Subsystem: Hewlett-Packard Company Device 89db
>> 	Flags: bus master, fast devsel, latency 0, IRQ 16, IOMMU group 8
>> 	Memory at 603f270000 (64-bit, non-prefetchable) [size=64K]
>> 	Capabilities: [80] Power Management version 3
>> 	Capabilities: [90] Vendor Specific Information: Len=14 <?>
>> 	Kernel driver in use: intel_ish_ipc
>> 	Kernel modules: intel_ish_ipc
>>
>> 0000:00:14.0 USB controller: Intel Corporation Tiger Lake-LP USB 3.2 Gen 2x1 xHCI Host Controller (rev 30) (prog-if 30 [XHCI])
>> 	Subsystem: Hewlett-Packard Company Device 89db
>> 	Flags: bus master, medium devsel, latency 0, IRQ 128, IOMMU group 9
>> 	Memory at 603f260000 (64-bit, non-prefetchable) [size=64K]
>> 	Capabilities: [70] Power Management version 2
>> 	Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
>> 	Capabilities: [90] Vendor Specific Information: Len=14 <?>
>> 	Capabilities: [b0] Vendor Specific Information: Len=00 <?>
>> 	Kernel driver in use: xhci_hcd
>>
>> 0000:00:14.2 RAM memory: Intel Corporation Tiger Lake-LP Shared SRAM (rev 30)
>> 	Subsystem: Hewlett-Packard Company Device 89db
>> 	Flags: fast devsel, IOMMU group 9
>> 	Memory at 603f298000 (64-bit, non-prefetchable) [disabled] [size=16K]
>> 	Memory at 603f2a0000 (64-bit, non-prefetchable) [disabled] [size=4K]
>> 	Capabilities: [80] Power Management version 3
>>
>> 0000:00:14.3 Network controller: Intel Corporation Wi-Fi 6 AX201 (rev 30)
>> 	DeviceName: Intel Wi-Fi 6 AX201
>> 	Subsystem: Intel Corporation Device 0074
>> 	Flags: bus master, fast devsel, latency 0, IRQ 19, IOMMU group 10
>> 	Memory at 603f294000 (64-bit, non-prefetchable) [size=16K]
>> 	Capabilities: [c8] Power Management version 3
>> 	Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
>> 	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
>> 	Capabilities: [80] MSI-X: Enable+ Count=16 Masked-
>> 	Capabilities: [100] Latency Tolerance Reporting
>> 	Capabilities: [164] Vendor Specific Information: ID=0010 Rev=0 Len=014 <?>
>> 	Kernel driver in use: iwlwifi
>> 	Kernel modules: iwlwifi
>>
>> 0000:00:15.0 Serial bus controller: Intel Corporation Tiger Lake-LP Serial IO I2C Controller #0 (rev 30)
>> 	Subsystem: Hewlett-Packard Company Device 89db
>> 	Flags: bus master, fast devsel, latency 0, IRQ 27, IOMMU group 11
>> 	Memory at 4017000000 (64-bit, non-prefetchable) [virtual] [size=4K]
>> 	Capabilities: [80] Power Management version 3
>> 	Capabilities: [90] Vendor Specific Information: Len=14 <?>
>> 	Kernel driver in use: intel-lpss
>>
>> 0000:00:15.1 Serial bus controller: Intel Corporation Tiger Lake-LP Serial IO I2C Controller #1 (rev 30)
>> 	Subsystem: Hewlett-Packard Company Device 89db
>> 	Flags: bus master, fast devsel, latency 0, IRQ 40, IOMMU group 11
>> 	Memory at 4017001000 (64-bit, non-prefetchable) [virtual] [size=4K]
>> 	Capabilities: [80] Power Management version 3
>> 	Capabilities: [90] Vendor Specific Information: Len=14 <?>
>> 	Kernel driver in use: intel-lpss
>>
>> 0000:00:16.0 Communication controller: Intel Corporation Tiger Lake-LP Management Engine Interface (rev 30)
>> 	Subsystem: Hewlett-Packard Company Device 89db
>> 	Flags: bus master, fast devsel, latency 0, IRQ 186, IOMMU group 12
>> 	Memory at 603f29d000 (64-bit, non-prefetchable) [size=4K]
>> 	Capabilities: [50] Power Management version 3
>> 	Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
>> 	Capabilities: [a4] Vendor Specific Information: Len=14 <?>
>> 	Kernel driver in use: mei_me
>> 	Kernel modules: mei_me
>>
>> 0000:00:1c.0 PCI bridge: Intel Corporation Tigerlake PCH-LP PCI Express Root Port #6 (rev 30) (prog-if 00 [Normal decode])
>> 	Flags: bus master, fast devsel, latency 0, IRQ 126, IOMMU group 13
>> 	Bus: primary=00, secondary=57, subordinate=57, sec-latency=0
>> 	I/O behind bridge: [disabled]
>> 	Memory behind bridge: 86300000-863fffff [size=1M]
>> 	Prefetchable memory behind bridge: [disabled]
>> 	Capabilities: [40] Express Root Port (Slot-), MSI 00
>> 	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>> 	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 89db
>> 	Capabilities: [a0] Power Management version 3
>> 	Capabilities: [100] Advanced Error Reporting
>> 	Capabilities: [220] Access Control Services
>> 	Capabilities: [150] Precision Time Measurement
>> 	Capabilities: [200] L1 PM Substates
>> 	Capabilities: [a30] Secondary PCI Express
>> 	Capabilities: [a00] Downstream Port Containment
>> 	Kernel driver in use: pcieport
>>
>> 0000:00:1d.0 System peripheral: Intel Corporation Device 09ab
>> 	Subsystem: Hewlett-Packard Company Device 89da
>> 	Flags: fast devsel, IOMMU group 14
>>
>> 0000:00:1f.0 ISA bridge: Intel Corporation Tiger Lake-LP LPC Controller (rev 30)
>> 	Subsystem: Hewlett-Packard Company Device 89db
>> 	Flags: bus master, fast devsel, latency 0, IOMMU group 15
>>
>> 0000:00:1f.3 Multimedia audio controller: Intel Corporation Tiger Lake-LP Smart Sound Technology Audio Controller (rev 30)
>> 	Subsystem: Hewlett-Packard Company Device 89da
>> 	Flags: bus master, fast devsel, latency 32, IRQ 197, IOMMU group 15
>> 	Memory at 603f290000 (64-bit, non-prefetchable) [size=16K]
>> 	Memory at 603f000000 (64-bit, non-prefetchable) [size=1M]
>> 	Capabilities: [50] Power Management version 3
>> 	Capabilities: [80] Vendor Specific Information: Len=14 <?>
>> 	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
>> 	Kernel driver in use: sof-audio-pci-intel-tgl
>> 	Kernel modules: snd_hda_intel, snd_sof_pci_intel_tgl
>>
>> 0000:00:1f.4 SMBus: Intel Corporation Tiger Lake-LP SMBus Controller (rev 30)
>> 	Subsystem: Hewlett-Packard Company Device 89db
>> 	Flags: medium devsel, IRQ 16, IOMMU group 15
>> 	Memory at 603f29c000 (64-bit, non-prefetchable) [size=256]
>> 	I/O ports at efa0 [size=32]
>> 	Kernel driver in use: i801_smbus
>> 	Kernel modules: i2c_i801
>>
>> 0000:00:1f.5 Serial bus controller: Intel Corporation Tiger Lake-LP SPI Controller (rev 30)
>> 	Subsystem: Hewlett-Packard Company Device 89db
>> 	Flags: fast devsel, IOMMU group 15
>> 	Memory at 68400000 (32-bit, non-prefetchable) [size=4K]
>>
>> 0000:2c:00.0 PCI bridge: Intel Corporation Thunderbolt 4 Bridge [Goshen Ridge 2020] (rev 03) (prog-if 00 [Normal decode])
>> 	Physical Slot: 0-1
>> 	Flags: bus master, fast devsel, latency 0, IRQ 16, IOMMU group 17
>> 	Bus: primary=2c, secondary=2d, subordinate=56, sec-latency=0
>> 	I/O behind bridge: 00005000-00005fff [size=4K]
>> 	Memory behind bridge: 6c000000-781fffff [size=194M]
>> 	Prefetchable memory behind bridge: 0000006000000000-000000601bffffff [size=448M]
>> 	Capabilities: [80] Power Management version 3
>> 	Capabilities: [88] MSI: Enable- Count=1/1 Maskable- 64bit+
>> 	Capabilities: [ac] Subsystem: Intel Corporation Device 0000
>> 	Capabilities: [c0] Express Upstream Port, MSI 00
>> 	Capabilities: [50] Capability ID 0x15 [0000]
>> 	Capabilities: [100] Device Serial Number c2-d5-04-18-86-b7-d0-00
>> 	Capabilities: [200] Advanced Error Reporting
>> 	Capabilities: [300] Virtual Channel
>> 	Capabilities: [400] Power Budgeting <?>
>> 	Capabilities: [500] Vendor Specific Information: ID=1234 Rev=1 Len=100 <?>
>> 	Capabilities: [600] Vendor Specific Information: ID=8086 Rev=2 Len=04c <?>
>> 	Capabilities: [700] Secondary PCI Express
>> 	Capabilities: [800] Latency Tolerance Reporting
>> 	Capabilities: [a00] L1 PM Substates
>> 	Capabilities: [b00] Precision Time Measurement
>> 	Kernel driver in use: pcieport
>>
>> 0000:2d:00.0 PCI bridge: Intel Corporation Thunderbolt 4 Bridge [Goshen Ridge 2020] (rev 03) (prog-if 00 [Normal decode])
>> 	Flags: bus master, fast devsel, latency 0, IRQ 16, IOMMU group 18
>> 	Bus: primary=2d, secondary=2e, subordinate=2e, sec-latency=0
>> 	I/O behind bridge: 00005000-00005fff [size=4K]
>> 	Memory behind bridge: 6c000000-6c0fffff [size=1M]
>> 	Prefetchable memory behind bridge: 0000006000000000-00000060000fffff [size=1M]
>> 	Capabilities: [80] Power Management version 3
>> 	Capabilities: [88] MSI: Enable- Count=1/1 Maskable- 64bit+
>> 	Capabilities: [ac] Subsystem: Intel Corporation Device 0000
>> 	Capabilities: [c0] Express Downstream Port (Slot+), MSI 00
>> 	Capabilities: [50] Capability ID 0x15 [0000]
>> 	Capabilities: [100] Device Serial Number c2-d5-04-18-86-b7-d0-00
>> 	Capabilities: [200] Advanced Error Reporting
>> 	Capabilities: [300] Virtual Channel
>> 	Capabilities: [400] Power Budgeting <?>
>> 	Capabilities: [500] Vendor Specific Information: ID=1234 Rev=1 Len=100 <?>
>> 	Capabilities: [600] Vendor Specific Information: ID=8086 Rev=2 Len=04c <?>
>> 	Capabilities: [700] Secondary PCI Express
>> 	Capabilities: [900] Access Control Services
>> 	Capabilities: [c00] Designated Vendor-Specific: Vendor=8086 ID=0006 Rev=0 Len=16 <?>
>> 	Kernel driver in use: pcieport
>>
>> 0000:2d:01.0 PCI bridge: Intel Corporation Thunderbolt 4 Bridge [Goshen Ridge 2020] (rev 03) (prog-if 00 [Normal decode])
>> 	Flags: bus master, fast devsel, latency 0, IRQ 198, IOMMU group 19
>> 	Bus: primary=2d, secondary=2f, subordinate=3b, sec-latency=0
>> 	I/O behind bridge: [disabled]
>> 	Memory behind bridge: 6c100000-700fffff [size=64M]
>> 	Prefetchable memory behind bridge: 0000006000100000-00000060095fffff [size=149M]
>> 	Capabilities: [80] Power Management version 3
>> 	Capabilities: [88] MSI: Enable+ Count=1/1 Maskable- 64bit+
>> 	Capabilities: [ac] Subsystem: Intel Corporation Device 0000
>> 	Capabilities: [c0] Express Downstream Port (Slot+), MSI 00
>> 	Capabilities: [50] Capability ID 0x15 [0000]
>> 	Capabilities: [100] Device Serial Number c2-d5-04-18-86-b7-d0-00
>> 	Capabilities: [200] Advanced Error Reporting
>> 	Capabilities: [300] Virtual Channel
>> 	Capabilities: [400] Power Budgeting <?>
>> 	Capabilities: [500] Vendor Specific Information: ID=1234 Rev=1 Len=100 <?>
>> 	Capabilities: [600] Vendor Specific Information: ID=8086 Rev=2 Len=04c <?>
>> 	Capabilities: [700] Secondary PCI Express
>> 	Capabilities: [900] Access Control Services
>> 	Capabilities: [c00] Designated Vendor-Specific: Vendor=8086 ID=0006 Rev=0 Len=16 <?>
>> 	Kernel driver in use: pcieport
>>
>> 0000:2d:02.0 PCI bridge: Intel Corporation Thunderbolt 4 Bridge [Goshen Ridge 2020] (rev 03) (prog-if 00 [Normal decode])
>> 	Flags: bus master, fast devsel, latency 0, IRQ 199, IOMMU group 20
>> 	Bus: primary=2d, secondary=3c, subordinate=48, sec-latency=0
>> 	I/O behind bridge: [disabled]
>> 	Memory behind bridge: 70100000-740fffff [size=64M]
>> 	Prefetchable memory behind bridge: 0000006009600000-0000006012afffff [size=149M]
>> 	Capabilities: [80] Power Management version 3
>> 	Capabilities: [88] MSI: Enable+ Count=1/1 Maskable- 64bit+
>> 	Capabilities: [ac] Subsystem: Intel Corporation Device 0000
>> 	Capabilities: [c0] Express Downstream Port (Slot+), MSI 00
>> 	Capabilities: [50] Capability ID 0x15 [0000]
>> 	Capabilities: [100] Device Serial Number c2-d5-04-18-86-b7-d0-00
>> 	Capabilities: [200] Advanced Error Reporting
>> 	Capabilities: [300] Virtual Channel
>> 	Capabilities: [400] Power Budgeting <?>
>> 	Capabilities: [500] Vendor Specific Information: ID=1234 Rev=1 Len=100 <?>
>> 	Capabilities: [600] Vendor Specific Information: ID=8086 Rev=2 Len=04c <?>
>> 	Capabilities: [700] Secondary PCI Express
>> 	Capabilities: [900] Access Control Services
>> 	Capabilities: [c00] Designated Vendor-Specific: Vendor=8086 ID=0006 Rev=0 Len=16 <?>
>> 	Kernel driver in use: pcieport
>>
>> 0000:2d:03.0 PCI bridge: Intel Corporation Thunderbolt 4 Bridge [Goshen Ridge 2020] (rev 03) (prog-if 00 [Normal decode])
>> 	Flags: bus master, fast devsel, latency 0, IRQ 200, IOMMU group 21
>> 	Bus: primary=2d, secondary=49, subordinate=55, sec-latency=0
>> 	I/O behind bridge: [disabled]
>> 	Memory behind bridge: 74100000-780fffff [size=64M]
>> 	Prefetchable memory behind bridge: 0000006012b00000-000000601befffff [size=148M]
>> 	Capabilities: [80] Power Management version 3
>> 	Capabilities: [88] MSI: Enable+ Count=1/1 Maskable- 64bit+
>> 	Capabilities: [ac] Subsystem: Intel Corporation Device 0000
>> 	Capabilities: [c0] Express Downstream Port (Slot+), MSI 00
>> 	Capabilities: [50] Capability ID 0x15 [0000]
>> 	Capabilities: [100] Device Serial Number c2-d5-04-18-86-b7-d0-00
>> 	Capabilities: [200] Advanced Error Reporting
>> 	Capabilities: [300] Virtual Channel
>> 	Capabilities: [400] Power Budgeting <?>
>> 	Capabilities: [500] Vendor Specific Information: ID=1234 Rev=1 Len=100 <?>
>> 	Capabilities: [600] Vendor Specific Information: ID=8086 Rev=2 Len=04c <?>
>> 	Capabilities: [700] Secondary PCI Express
>> 	Capabilities: [900] Access Control Services
>> 	Capabilities: [c00] Designated Vendor-Specific: Vendor=8086 ID=0006 Rev=0 Len=16 <?>
>> 	Kernel driver in use: pcieport
>>
>> 0000:2d:04.0 PCI bridge: Intel Corporation Thunderbolt 4 Bridge [Goshen Ridge 2020] (rev 03) (prog-if 00 [Normal decode])
>> 	Flags: bus master, fast devsel, latency 0, IRQ 16, IOMMU group 22
>> 	Bus: primary=2d, secondary=56, subordinate=56, sec-latency=0
>> 	I/O behind bridge: [disabled]
>> 	Memory behind bridge: 78100000-781fffff [size=1M]
>> 	Prefetchable memory behind bridge: 000000601bf00000-000000601bffffff [size=1M]
>> 	Capabilities: [80] Power Management version 3
>> 	Capabilities: [88] MSI: Enable- Count=1/1 Maskable- 64bit+
>> 	Capabilities: [ac] Subsystem: Intel Corporation Device 0000
>> 	Capabilities: [c0] Express Downstream Port (Slot+), MSI 00
>> 	Capabilities: [50] Capability ID 0x15 [0000]
>> 	Capabilities: [100] Device Serial Number c2-d5-04-18-86-b7-d0-00
>> 	Capabilities: [200] Advanced Error Reporting
>> 	Capabilities: [300] Virtual Channel
>> 	Capabilities: [400] Power Budgeting <?>
>> 	Capabilities: [500] Vendor Specific Information: ID=1234 Rev=1 Len=100 <?>
>> 	Capabilities: [600] Vendor Specific Information: ID=8086 Rev=2 Len=04c <?>
>> 	Capabilities: [700] Secondary PCI Express
>> 	Capabilities: [900] Access Control Services
>> 	Capabilities: [c00] Designated Vendor-Specific: Vendor=8086 ID=0006 Rev=0 Len=16 <?>
>> 	Kernel driver in use: pcieport
>>
>> 0000:57:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS525A PCI Express Card Reader (rev 01)
>> 	DeviceName: Realtek PCIE CardReader
>> 	Subsystem: Hewlett-Packard Company Device 89db
>> 	Flags: bus master, fast devsel, latency 0, IRQ 149, IOMMU group 16
>> 	Memory at 86300000 (32-bit, non-prefetchable) [size=4K]
>> 	Capabilities: [80] Power Management version 3
>> 	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit+
>> 	Capabilities: [b0] Express Endpoint, MSI 00
>> 	Capabilities: [100] Advanced Error Reporting
>> 	Capabilities: [148] Device Serial Number 00-00-00-01-00-4c-e0-00
>> 	Capabilities: [158] Latency Tolerance Reporting
>> 	Capabilities: [160] L1 PM Substates
>> 	Kernel driver in use: rtsx_pci
>> 	Kernel modules: rtsx_pci
>>
>> 10000:e0:1d.0 PCI bridge: Intel Corporation Tiger Lake-LP PCI Express Root Port #9 (rev 30) (prog-if 00 [Normal decode])
>> 	Flags: bus master, fast devsel, latency 0, IRQ 148, IOMMU group 7
>> 	Bus: primary=00, secondary=e1, subordinate=e1, sec-latency=0
>> 	I/O behind bridge: [disabled]
>> 	Memory behind bridge: 6a000000-6a0fffff [size=1M]
>> 	Prefetchable memory behind bridge: [disabled]
>> 	Capabilities: [40] Express Root Port (Slot-), MSI 00
>> 	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>> 	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 89db
>> 	Capabilities: [a0] Power Management version 3
>> 	Capabilities: [100] Advanced Error Reporting
>> 	Capabilities: [220] Access Control Services
>> 	Capabilities: [150] Precision Time Measurement
>> 	Capabilities: [200] L1 PM Substates
>> 	Capabilities: [a30] Secondary PCI Express
>> 	Capabilities: [a00] Downstream Port Containment
>> 	Kernel driver in use: pcieport
>>
>> 10000:e1:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller SM981/PM981/PM983 (prog-if 02 [NVM Express])
>> 	Subsystem: Samsung Electronics Co Ltd SSD 970 EVO Plus 1TB
>> 	Flags: bus master, fast devsel, latency 0, IRQ -2147483648, NUMA node 0, IOMMU group 7
>> 	Memory at 6a000000 (64-bit, non-prefetchable) [size=16K]
>> 	Capabilities: [40] Power Management version 3
>> 	Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
>> 	Capabilities: [70] Express Endpoint, MSI 00
>> 	Capabilities: [b0] MSI-X: Enable+ Count=33 Masked-
>> 	Capabilities: [100] Advanced Error Reporting
>> 	Capabilities: [148] Device Serial Number 00-00-00-00-00-00-00-00
>> 	Capabilities: [158] Power Budgeting <?>
>> 	Capabilities: [168] Secondary PCI Express
>> 	Capabilities: [188] Latency Tolerance Reporting
>> 	Capabilities: [190] L1 PM Substates
>> 	Kernel driver in use: nvme
>> 	Kernel modules: nvme
>>
> 
