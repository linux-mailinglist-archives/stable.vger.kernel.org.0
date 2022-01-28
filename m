Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA0749F2C0
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 06:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbiA1FIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 00:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiA1FIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 00:08:34 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88967C061714;
        Thu, 27 Jan 2022 21:08:34 -0800 (PST)
Received: from ip4d173d02.dynamic.kabel-deutschland.de ([77.23.61.2] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nDJUu-0005CF-Lq; Fri, 28 Jan 2022 06:08:32 +0100
Message-ID: <fa65eabe-4ef8-69bc-1788-7e3757a15c47@leemhuis.info>
Date:   Fri, 28 Jan 2022 06:08:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [Bug 215540] New: mvebu: no pcie devices detected on turris omnia
 (5.16.3 regression)
Content-Language: en-BS
To:     Bjorn Helgaas <helgaas@kernel.org>, linux-pci@vger.kernel.org
Cc:     Jan Palus <jpalus@fastmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220127234917.GA150851@bhelgaas>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220127234917.GA150851@bhelgaas>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1643346514;bd9eaa56;
X-HE-SMSGID: 1nDJUu-0005CF-Lq
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


[TLDR: I'm adding this regression to regzbot, the Linux kernel
regression tracking bot; most text you find below is compiled from a few
templates paragraphs some of you might have seen already.]

Hi, this is your Linux kernel regression tracker speaking.

Adding the regression mailing list to the list of recipients, as it
should be in the loop for all regressions, as explained here:
https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html

On 28.01.22 00:49, Bjorn Helgaas wrote:
> [+cc Thomas, Pali]

CCing also Greg and the stable list, as this is a issue in a stable kernel.

Anyway:

> On Thu, Jan 27, 2022 at 10:52:43PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=215540
>>
>>             Bug ID: 215540
>>            Summary: mvebu: no pcie devices detected on turris omnia
>>                     (5.16.3 regression)
>>            Product: Drivers
>>            Version: 2.5
>>     Kernel Version: 5.16.3
>>           Hardware: ARM
>>                 OS: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: PCI
>>           Assignee: drivers_pci@kernel-bugs.osdl.org
>>           Reporter: jpalus@fastmail.com
>>         Regression: No
>>
>> After kernel upgrade from 5.16.1 to 5.16.3 Turris Omnia (Armada 385)
>> no longer detects pcie devices (wifi/msata). Haven't tried 5.16.2
>> but it doesn't seem to have any relevant changes, while 5.16.3
>> carries a few.


To be sure this issue doesn't fall through the cracks unnoticed, I'm
adding it to regzbot, my Linux kernel regression tracking bot:

#regzbot ^introduced v5.16.1..v5.16.3
#regzbot title  mvebu: no pcie devices detected on turris omnia
#regzbot from: Jan Palus <jpalus@fastmail.com>
#regzbot ignore-activity
#regzbot link: https://bugzilla.kernel.org/show_bug.cgi?id=215540

Ciao, Thorsten (wearing his 'Linux kernel regression tracker' hat)

P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
on my table. I can only look briefly into most of them. Unfortunately
therefore I sometimes will get things wrong or miss something important.
I hope that's not the case here; if you think it is, don't hesitate to
tell me about it in a public reply, that's in everyone's interest.

BTW, I have no personal interest in this issue, which is tracked using
regzbot, my Linux kernel regression tracking bot
(https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
this mail to get things rolling again and hence don't need to be CC on
all further activities wrt to this regression.

> Here are some of the dmesg diffs between v5.16.1 (good) and v5.16.3
> (bad):
> 
>    pci 0000:00:01.0: [11ab:6820] type 01 class 0x060400
>   -pci 0000:00:01.0: reg 0x38: [mem 0x00000000-0x000007ff pref]
>    pci 0000:00:02.0: [11ab:6820] type 01 class 0x060400
>   -pci 0000:00:02.0: reg 0x38: [mem 0x00000000-0x000007ff pref]
>    pci 0000:00:03.0: [11ab:6820] type 01 class 0x060400
>   -pci 0000:00:03.0: reg 0x38: [mem 0x00000000-0x000007ff pref]
> 
> That means both kernels *discovered* the devices, but v5.16.3 couldn't
> size the BARs.
> 
> Between v5.16.1 and v5.16.3, there were several changes to mvebu and
> the root port emulation it uses (though the devices above are on the
> root bus and shouldn't be below a root port):
> 
>   71ceae67ef9b ("PCI: pci-bridge-emul: Set PCI_STATUS_CAP_LIST for PCIe device")
>   2c8683fbf143 ("PCI: pci-bridge-emul: Correctly set PCIe capabilities")
>   6863f571a546 ("PCI: pci-bridge-emul: Fix definitions of reserved bits")
>   9e6e6e641f26 ("PCI: pci-bridge-emul: Properly mark reserved PCIe bits in PCI config space")
>   174a6ab8722e ("PCI: pci-bridge-emul: Make expansion ROM Base Address register read-only")
>   ce16d4b7e5f6 ("PCI: mvebu: Fix support for DEVCAP2, DEVCTL2 and LNKCTL2 registers on emulated bridge")
>   004408c5b7b4 ("PCI: mvebu: Fix support for PCI_EXP_RTSTA on emulated bridge")
>   e9dd0d0efece ("PCI: mvebu: Fix support for PCI_EXP_DEVCTL on emulated bridge")
>   802d9ee9cbd3 ("PCI: mvebu: Fix support for PCI_BRIDGE_CTL_BUS_RESET on emulated bridge")
>   4523e727c349 ("PCI: mvebu: Setup PCIe controller to Root Complex mode")
>   7cde9bf07316 ("PCI: mvebu: Fix configuring secondary bus of PCIe Root Port via emulated bridge")
>   3de91c80b70a ("PCI: mvebu: Fix support for bus mastering and PCI_COMMAND on emulated bridge")
>   d9bfeaab65b3 ("PCI: mvebu: Do not modify PCI IO type bits in conf_write")
>   e7e52bc07021 ("PCI: mvebu: Check for errors from pci_bridge_emul_init() call")
> 
> I think these are all from Pali (cc'd), so he'll likely see the
> problem.
> 
>> 5.16.3:
>> $ dmesg|grep -i pci 
>> [    0.075893] PCI: CLS 0 bytes, default 64
>> [    0.127393] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4 
>> [    0.127679] mvebu-pcie soc:pcie: host bridge /soc/pcie ranges:
>> [    0.127723] mvebu-pcie soc:pcie:      MEM 0x00f1080000..0x00f1081fff ->
>> 0x0000080000
>> [    0.127743] mvebu-pcie soc:pcie:      MEM 0x00f1040000..0x00f1041fff ->
>> 0x0000040000
>> [    0.127760] mvebu-pcie soc:pcie:      MEM 0x00f1044000..0x00f1045fff ->
>> 0x0000044000
>> [    0.127775] mvebu-pcie soc:pcie:      MEM 0x00f1048000..0x00f1049fff ->
>> 0x0000048000
>> [    0.127790] mvebu-pcie soc:pcie:      MEM 0xffffffffffffffff..0x00fffffffe
>> -> 0x0100000000
>> [    0.127804] mvebu-pcie soc:pcie:       IO 0xffffffffffffffff..0x00fffffffe
>> -> 0x0100000000
>> [    0.127819] mvebu-pcie soc:pcie:      MEM 0xffffffffffffffff..0x00fffffffe
>> -> 0x0200000000
>> [    0.127833] mvebu-pcie soc:pcie:       IO 0xffffffffffffffff..0x00fffffffe
>> -> 0x0200000000
>> [    0.127847] mvebu-pcie soc:pcie:      MEM 0xffffffffffffffff..0x00fffffffe
>> -> 0x0300000000
>> [    0.127861] mvebu-pcie soc:pcie:       IO 0xffffffffffffffff..0x00fffffffe
>> -> 0x0300000000
>> [    0.127875] mvebu-pcie soc:pcie:      MEM 0xffffffffffffffff..0x00fffffffe
>> -> 0x0400000000
>> [    0.127886] mvebu-pcie soc:pcie:       IO 0xffffffffffffffff..0x00fffffffe
>> -> 0x0400000000
>> [    0.128145] mvebu-pcie soc:pcie: PCI host bridge to bus 0000:00
>> [    0.128162] pci_bus 0000:00: root bus resource [bus 00-ff]
>> [    0.128174] pci_bus 0000:00: root bus resource [mem 0xf1080000-0xf1081fff]
>> (bus address [0x00080000-0x00081fff])
>> [    0.128183] pci_bus 0000:00: root bus resource [mem 0xf1040000-0xf1041fff]
>> (bus address [0x00040000-0x00041fff])
>> [    0.128191] pci_bus 0000:00: root bus resource [mem 0xf1044000-0xf1045fff]
>> (bus address [0x00044000-0x00045fff])
>> [    0.128199] pci_bus 0000:00: root bus resource [mem 0xf1048000-0xf1049fff]
>> (bus address [0x00048000-0x00049fff])
>> [    0.128206] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xe7ffffff]
>> [    0.128212] pci_bus 0000:00: root bus resource [io  0x1000-0xeffff]
>> [    0.128354] pci 0000:00:01.0: [11ab:6820] type 01 class 0x060400
>> [    0.128634] pci 0000:00:02.0: [11ab:6820] type 01 class 0x060400
>> [    0.128866] pci 0000:00:03.0: [11ab:6820] type 01 class 0x060400
>> [    0.129958] PCI: bus0: Fast back to back transfers disabled
>> [    0.129979] pci 0000:00:01.0: bridge configuration invalid ([bus 00-00]),
>> reconfiguring
>> [    0.129994] pci 0000:00:02.0: bridge configuration invalid ([bus 00-00]),
>> reconfiguring
>> [    0.130004] pci 0000:00:03.0: bridge configuration invalid ([bus 01-00]),
>> reconfiguring
>> [    0.131172] PCI: bus1: Fast back to back transfers enabled
>> [    0.131198] pci_bus 0000:01: busn_res: [bus 01-ff] end is updated to 01
>> [    0.131363] pci 0000:02:00.0: [11ab:6820] type 00 class 0x058000
>> [    0.131386] pci 0000:02:00.0: reg 0x10: [mem 0xf1000000-0xf10fffff]
>> [    0.131401] pci 0000:02:00.0: reg 0x18: [mem 0x00000000-0x7fffffff]
>> [    0.131459] pci 0000:02:00.0: supports D1 D2
>> [    0.132655] PCI: bus2: Fast back to back transfers disabled
>> [    0.132681] pci_bus 0000:02: busn_res: [bus 02-ff] end is updated to 02
>> [    0.132831] pci 0000:03:00.0: [11ab:6820] type 00 class 0x058000
>> [    0.132853] pci 0000:03:00.0: reg 0x10: [mem 0xf1000000-0xf10fffff]
>> [    0.132868] pci 0000:03:00.0: reg 0x18: [mem 0x00000000-0x7fffffff]
>> [    0.132926] pci 0000:03:00.0: supports D1 D2
>> [    0.134166] PCI: bus3: Fast back to back transfers disabled
>> [    0.134194] pci_bus 0000:03: busn_res: [bus 03-ff] end is updated to 03
>> [    0.134303] pci 0000:00:02.0: BAR 14: no space for [mem size 0xc0000000]
>> [    0.134318] pci 0000:00:02.0: BAR 14: failed to assign [mem size 0xc0000000]
>> [    0.134329] pci 0000:00:03.0: BAR 14: no space for [mem size 0xc0000000]
>> [    0.134337] pci 0000:00:03.0: BAR 14: failed to assign [mem size 0xc0000000]
>> [    0.134348] pci 0000:00:01.0: PCI bridge to [bus 01] 
>> [    0.134364] pci 0000:02:00.0: BAR 2: no space for [mem size 0x80000000]
>> [    0.134372] pci 0000:02:00.0: BAR 2: failed to assign [mem size 0x80000000]
>> [    0.134379] pci 0000:02:00.0: BAR 0: no space for [mem size 0x00100000]
>> [    0.134385] pci 0000:02:00.0: BAR 0: failed to assign [mem size 0x00100000]
>> [    0.134393] pci 0000:00:02.0: PCI bridge to [bus 02] 
>> [    0.134406] pci 0000:03:00.0: BAR 2: no space for [mem size 0x80000000]
>> [    0.134413] pci 0000:03:00.0: BAR 2: failed to assign [mem size 0x80000000]
>> [    0.134420] pci 0000:03:00.0: BAR 0: no space for [mem size 0x00100000]
>> [    0.134426] pci 0000:03:00.0: BAR 0: failed to assign [mem size 0x00100000]
>> [    0.134433] pci 0000:00:03.0: PCI bridge to [bus 03] 
>>
>> 5.16.1:
>> [    0.127673] mvebu-pcie soc:pcie: host bridge /soc/pcie ranges:
>> [    0.127717] mvebu-pcie soc:pcie:      MEM 0x00f1080000..0x00f1081fff ->
>> 0x0000080000
>> [    0.127737] mvebu-pcie soc:pcie:      MEM 0x00f1040000..0x00f1041fff ->
>> 0x0000040000
>> [    0.127753] mvebu-pcie soc:pcie:      MEM 0x00f1044000..0x00f1045fff ->
>> 0x0000044000
>> [    0.127768] mvebu-pcie soc:pcie:      MEM 0x00f1048000..0x00f1049fff ->
>> 0x0000048000
>> [    0.127783] mvebu-pcie soc:pcie:      MEM 0xffffffffffffffff..0x00fffffffe
>> -> 0x0100000000
>> [    0.127798] mvebu-pcie soc:pcie:       IO 0xffffffffffffffff..0x00fffffffe
>> -> 0x0100000000
>> [    0.127812] mvebu-pcie soc:pcie:      MEM 0xffffffffffffffff..0x00fffffffe
>> -> 0x0200000000
>> [    0.127826] mvebu-pcie soc:pcie:       IO 0xffffffffffffffff..0x00fffffffe
>> -> 0x0200000000
>> [    0.127839] mvebu-pcie soc:pcie:      MEM 0xffffffffffffffff..0x00fffffffe
>> -> 0x0300000000
>> [    0.127853] mvebu-pcie soc:pcie:       IO 0xffffffffffffffff..0x00fffffffe
>> -> 0x0300000000
>> [    0.127867] mvebu-pcie soc:pcie:      MEM 0xffffffffffffffff..0x00fffffffe
>> -> 0x0400000000
>> [    0.127877] mvebu-pcie soc:pcie:       IO 0xffffffffffffffff..0x00fffffffe
>> -> 0x0400000000
>> [    0.128140] mvebu-pcie soc:pcie: PCI host bridge to bus 0000:00
>> [    0.128157] pci_bus 0000:00: root bus resource [bus 00-ff]
>> [    0.128170] pci_bus 0000:00: root bus resource [mem 0xf1080000-0xf1081fff]
>> (bus address [0x00080000-0x00081fff])
>> [    0.128179] pci_bus 0000:00: root bus resource [mem 0xf1040000-0xf1041fff]
>> (bus address [0x00040000-0x00041fff])
>> [    0.128187] pci_bus 0000:00: root bus resource [mem 0xf1044000-0xf1045fff]
>> (bus address [0x00044000-0x00045fff])
>> [    0.128196] pci_bus 0000:00: root bus resource [mem 0xf1048000-0xf1049fff]
>> (bus address [0x00048000-0x00049fff])
>> [    0.128203] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xe7ffffff]
>> [    0.128210] pci_bus 0000:00: root bus resource [io  0x1000-0xeffff]
>> [    0.128341] pci 0000:00:01.0: [11ab:6820] type 01 class 0x060400
>> [    0.128362] pci 0000:00:01.0: reg 0x38: [mem 0x00000000-0x000007ff pref]
>> [    0.128631] pci 0000:00:02.0: [11ab:6820] type 01 class 0x060400
>> [    0.128655] pci 0000:00:02.0: reg 0x38: [mem 0x00000000-0x000007ff pref]
>> [    0.128871] pci 0000:00:03.0: [11ab:6820] type 01 class 0x060400
>> [    0.128893] pci 0000:00:03.0: reg 0x38: [mem 0x00000000-0x000007ff pref]
>> [    0.129975] pci 0000:00:01.0: bridge configuration invalid ([bus 00-00]),
>> reconfiguring
>> [    0.129989] pci 0000:00:02.0: bridge configuration invalid ([bus 00-00]),
>> reconfiguring
>> [    0.129999] pci 0000:00:03.0: bridge configuration invalid ([bus 00-00]),
>> reconfiguring
>> [    0.131184] pci_bus 0000:01: busn_res: [bus 01-ff] end is updated to 01
>> [    0.131344] pci 0000:02:00.0: [168c:003c] type 00 class 0x028000
>> [    0.131375] pci 0000:02:00.0: reg 0x10: [mem 0x00000000-0x001fffff 64bit]
>> [    0.131408] pci 0000:02:00.0: reg 0x30: [mem 0x00000000-0x0000ffff pref]
>> [    0.131507] pci 0000:02:00.0: supports D1
>> [    0.131515] pci 0000:02:00.0: PME# supported from D0 D1 D3hot
>> [    0.131734] pci 0000:00:02.0: ASPM: current common clock configuration is
>> inconsistent, reconfiguring
>> [    0.131753] pci 0000:00:02.0: ASPM: Bridge does not support changing Link
>> Speed to 2.5 GT/s
>> [    0.131759] pci 0000:00:02.0: ASPM: Retrain Link at higher speed is
>> disallowed by quirk
>> [    0.131765] pci 0000:00:02.0: ASPM: Could not configure common clock
>> [    0.132832] pci_bus 0000:02: busn_res: [bus 02-ff] end is updated to 02
>> [    0.132993] pci 0000:03:00.0: [168c:002e] type 00 class 0x028000
>> [    0.133027] pci 0000:03:00.0: reg 0x10: [mem 0x00000000-0x0000ffff 64bit]
>> [    0.133152] pci 0000:03:00.0: supports D1
>> [    0.133161] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
>> [    0.133396] pci 0000:00:03.0: ASPM: current common clock configuration is
>> inconsistent, reconfiguring
>> [    0.133413] pci 0000:00:03.0: ASPM: Bridge does not support changing Link
>> Speed to 2.5 GT/s
>> [    0.133421] pci 0000:00:03.0: ASPM: Retrain Link at higher speed is
>> disallowed by quirk
>> [    0.133427] pci 0000:00:03.0: ASPM: Could not configure common clock
>> [    0.134545] pci_bus 0000:03: busn_res: [bus 03-ff] end is updated to 03
>> [    0.134655] pci 0000:00:02.0: BAR 14: assigned [mem 0xe0000000-0xe02fffff]
>> [    0.134673] pci 0000:00:03.0: BAR 14: assigned [mem 0xe0300000-0xe03fffff]
>> [    0.134685] pci 0000:00:01.0: BAR 6: assigned [mem 0xe0400000-0xe04007ff
>> pref]
>> [    0.134696] pci 0000:00:02.0: BAR 6: assigned [mem 0xe0500000-0xe05007ff
>> pref]
>> [    0.134706] pci 0000:00:03.0: BAR 6: assigned [mem 0xe0600000-0xe06007ff
>> pref]
>> [    0.134717] pci 0000:00:01.0: PCI bridge to [bus 01] 
>> [    0.134737] pci 0000:02:00.0: BAR 0: assigned [mem 0xe0000000-0xe01fffff
>> 64bit]
>> [    0.134755] pci 0000:02:00.0: BAR 6: assigned [mem 0xe0200000-0xe020ffff
>> pref]
>> [    0.134764] pci 0000:00:02.0: PCI bridge to [bus 02] 
>> [    0.134772] pci 0000:00:02.0:   bridge window [mem 0xe0000000-0xe02fffff]
>> [    0.134784] pci 0000:03:00.0: BAR 0: assigned [mem 0xe0300000-0xe030ffff
>> 64bit]
>> [    0.134798] pci 0000:00:03.0: PCI bridge to [bus 03] 
>> [    0.134806] pci 0000:00:03.0:   bridge window [mem 0xe0300000-0xe03fffff]
>> [    0.134997] pcieport 0000:00:02.0: enabling device (0140 -> 0142)
>> [    0.135084] pcieport 0000:00:03.0: enabling device (0140 -> 0142)
>>
>> -- 
>> You may reply to this email to add a comment.
>>
>> You are receiving this mail because:
>> You are watching the assignee of the bug.

---
Additional information about regzbot:

If you want to know more about regzbot, check out its web-interface, the
getting start guide, and/or the references documentation:

https://linux-regtracking.leemhuis.info/regzbot/
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md

The last two documents will explain how you can interact with regzbot
yourself if your want to.

Hint for reporters: when reporting a regression it's in your interest to
tell #regzbot about it in the report, as that will ensure the regression
gets on the radar of regzbot and the regression tracker. That's in your
interest, as they will make sure the report won't fall through the
cracks unnoticed.

Hint for developers: you normally don't need to care about regzbot once
it's involved. Fix the issue as you normally would, just remember to
include a 'Link:' tag to the report in the commit message, as explained
in Documentation/process/submitting-patches.rst
That aspect was recently was made more explicit in commit 1f57bd42b77c:
https://git.kernel.org/linus/1f57bd42b77c
