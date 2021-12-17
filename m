Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CC4478555
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 08:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbhLQHAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 02:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbhLQHAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 02:00:16 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866FAC061574;
        Thu, 16 Dec 2021 23:00:16 -0800 (PST)
Received: from ip4d173d4a.dynamic.kabel-deutschland.de ([77.23.61.74] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1my7Dx-0007dP-0K; Fri, 17 Dec 2021 08:00:13 +0100
Message-ID: <e4efbf13-bd8d-0370-629b-6c80c0044b15@leemhuis.info>
Date:   Fri, 17 Dec 2021 08:00:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-BS
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     tlinux@cebula.eu.org, linux-input@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: FWD: Holtek mouse stopped working after kernel upgrade from 5.15.7 to
 5.15.8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1639724416;0930b3b8;
X-HE-SMSGID: 1my7Dx-0007dP-0K
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking.

I noticed a bugreport from Tomasz C. (CCed) that sounds a lot like a
regression between v5.15.7..v5.15.8 and likely better dealt with by email:

To quote from: https://bugzilla.kernel.org/show_bug.cgi?id=215341

> After updating kernel from 5.15.7 to 5.15.8 on ArchLinux distribution, Holtek USB mouse stopped working.
> Exact model:
> 04d9:a067 Holtek Semiconductor, Inc. USB Gaming Mouse
> 
> The dmesg output for this device from kernel version 5.15.8:
> 
> [    2.501958] usb 2-1.2.3: new full-speed USB device number 6 using ehci-pci
> [    2.624369] usb 2-1.2.3: New USB device found, idVendor=04d9, idProduct=a067, bcdDevice= 1.16
> [    2.624376] usb 2-1.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    2.624379] usb 2-1.2.3: Product: USB Gaming Mouse
> [    2.624382] usb 2-1.2.3: Manufacturer: Holtek
> 
> After disconnecting and connecting the USB:
> 
> [   71.976731] usb 2-1.2.3: USB disconnect, device number 6
> [   75.013021] usb 2-1.2.3: new full-speed USB device number 8 using ehci-pci
> [   75.135865] usb 2-1.2.3: New USB device found, idVendor=04d9, idProduct=a067, bcdDevice= 1.16
> [   75.135873] usb 2-1.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [   75.135877] usb 2-1.2.3: Product: USB Gaming Mouse
> [   75.135880] usb 2-1.2.3: Manufacturer: Holtek
> 
> 
> On kernel version 5.15.7:
> 
> [    2.280515] usb 2-1.2.3: new full-speed USB device number 6 using ehci-pci
> [    2.379777] usb 2-1.2.3: New USB device found, idVendor=04d9, idProduct=a067, bcdDevice= 1.16
> [    2.379784] usb 2-1.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    2.379787] usb 2-1.2.3: Product: USB Gaming Mouse
> [    2.379790] usb 2-1.2.3: Manufacturer: Holtek
> [    2.398578] input: Holtek USB Gaming Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.3/2-1.2.3:1.0/0003:04D9:A067.0005/input/input11
> [    2.450977] holtek_mouse 0003:04D9:A067.0005: input,hidraw4: USB HID v1.10 Keyboard [Holtek USB Gaming Mouse] on usb-0000:00:1d.0-1.2.3/input0
> [    2.451013] holtek_mouse 0003:04D9:A067.0006: Fixing up report descriptor
> [    2.452189] input: Holtek USB Gaming Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.3/2-1.2.3:1.1/0003:04D9:A067.0006/input/input12
> [    2.468510] usb 2-1.2.4: new high-speed USB device number 7 using ehci-pci
> [    2.503913] holtek_mouse 0003:04D9:A067.0006: input,hiddev96,hidraw5: USB HID v1.10 Mouse [Holtek USB Gaming Mouse] on usb-0000:00:1d.0-1.2.3/input1
> [    2.504105] holtek_mouse 0003:04D9:A067.0007: hiddev97,hidraw6: USB HID v1.10 Device [Holtek USB Gaming Mouse] on usb-0000:00:1d.0-1.2.3/input2
> 
> Rolling back the kernel to version 5.15.7 solves the problem.

[TLDR for the rest of the mail: adding this regression to regzbot; most
text you find below is compiled from a few templates paragraphs some of
you might have seen already.]

To be sure this issue doesn't fall through the cracks unnoticed, I'm
adding it to regzbot, my Linux kernel regression tracking bot:

#regzbot introduced v5.15.7..v5.15.8
#regzbot title usb: Holtek mouse stopped working

Reminder: when fixing the issue, please add a 'Link:' tag with the URL
to this report and the bugzilla ticket, then regzbot will automatically
mark the regression as resolved once the fix lands in the appropriate
tree. For more details about regzbot see footer.

Ciao, Thorsten (wearing his 'Linux kernel regression tracker' hat).

P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
on my table. I can only look briefly into most of them. Unfortunately
therefore I sometimes will get things wrong or miss something important.
I hope that's not the case here; if you think it is, don't hesitate to
tell me about it in a public reply. That's in everyone's interest, as
what I wrote above might be misleading to everyone reading this; any
suggestion I gave thus might sent someone reading this down the wrong
rabbit hole, which none of us wants.

BTW, I have no personal interest in this issue, which is tracked using
regzbot, my Linux kernel regression tracking bot
(https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
this mail to get things rolling again and hence don't need to be CC on
all further activities wrt to this regression.
