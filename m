Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1640221E0D
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 10:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgGPISI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 04:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgGPISH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 04:18:07 -0400
Received: from mout2.freenet.de (mout2.freenet.de [IPv6:2001:748:100:40::2:4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE46C061755;
        Thu, 16 Jul 2020 01:18:07 -0700 (PDT)
Received: from [195.4.92.164] (helo=mjail1.freenet.de)
        by mout2.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (port 25) (Exim 4.92 #3)
        id 1jvz5f-0002ek-UX; Thu, 16 Jul 2020 10:18:03 +0200
Received: from localhost ([::1]:41380 helo=mjail1.freenet.de)
        by mjail1.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (Exim 4.92 #3)
        id 1jvz5f-0007YJ-Sw; Thu, 16 Jul 2020 10:18:03 +0200
Received: from sub7.freenet.de ([195.4.92.126]:39256)
        by mjail1.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (Exim 4.92 #3)
        id 1jvz3E-000508-Cc; Thu, 16 Jul 2020 10:15:32 +0200
Received: from p200300e707002e000785056b8e3c0b45.dip0.t-ipconnect.de ([2003:e7:700:2e00:785:56b:8e3c:b45]:51182 helo=[127.0.0.1])
        by sub7.freenet.de with esmtpsa (ID viktor.jaegerskuepper@freenet.de) (TLSv1.2:ECDHE-RSA-CHACHA20-POLY1305:256) (port 465) (Exim 4.92 #3)
        id 1jvz3E-0003y2-7Q; Thu, 16 Jul 2020 10:15:32 +0200
Subject: Re: ath9k broken [was: Linux 5.7.3]
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gabriel C <nix.or.die@googlemail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        angrypenguinpoland@gmail.com, Qiujun Huang <hqjagain@gmail.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Roman Mamedov <rm@romanrm.net>
References: <1592410366125160@kroah.com>
 <CAEJqkgjV8p6LtBV8YUGbNb0vYzKOQt4-AMAvYw5mzFr3eicyTg@mail.gmail.com>
 <b7993e83-1df7-0c93-f6dd-dba9dc10e27a@kernel.org>
 <CAEJqkggG2ZB8De_zbP2W7Z9eRYve2br8jALaLRhjC33ksLZpTw@mail.gmail.com>
 <CAEJqkgj4LS7M3zYK51Vagt4rWC9A7uunA+7CvX0Qv=57Or3Ngg@mail.gmail.com>
 <CAEJqkghJWGsLCj2Wvt-yhzMewjXwrXhSEDpar6rbDpbSA6R8kQ@mail.gmail.com>
 <20200626133959.GA4024297@kroah.com>
 <CAEJqkgiACMar-iWsWQgJPAViBBURaNpcOD4FKtp6M8Aw_D4FOw@mail.gmail.com>
 <CAEJqkgg4Ka8oNL7ELoJrR0-Abz3=caLns48KyDC=DQcym6SRvA@mail.gmail.com>
 <20200707141100.GE4064836@kroah.com>
 <07c8d8fa-8bbc-0b4e-191c-b2635214e8b9@freenet.de>
 <87ft9sbym3.fsf@tynnyri.adurom.net>
From:   =?UTF-8?B?VmlrdG9yIErDpGdlcnNrw7xwcGVy?= 
        <viktor_jaegerskuepper@freenet.de>
Message-ID: <20eec98e-960c-cece-21e4-01e26b44233e@freenet.de>
Date:   Thu, 16 Jul 2020 10:15:30 +0200
MIME-Version: 1.0
In-Reply-To: <87ft9sbym3.fsf@tynnyri.adurom.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
X-Originated-At: 2003:e7:700:2e00:785:56b:8e3c:b45!51182
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[CC'ed Roman]

Kalle Valo:
> Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de> writes:
> 
>> Greg Kroah-Hartman wrote:
>>> On Fri, Jun 26, 2020 at 04:40:18PM +0200, Gabriel C wrote:
>>>> Am Fr., 26. Juni 2020 um 15:51 Uhr schrieb Gabriel C
>>>> <nix.or.die@googlemail.com>:
>>>>>
>>>>> Am Fr., 26. Juni 2020 um 15:40 Uhr schrieb Greg Kroah-Hartman
>>>>> <gregkh@linuxfoundation.org>:
>>>>>>
>>>>>> On Fri, Jun 26, 2020 at 01:48:59PM +0200, Gabriel C wrote:
>>>>>>> Am Do., 25. Juni 2020 um 12:52 Uhr schrieb Gabriel C
>>>>>>> <nix.or.die@googlemail.com>:
>>>>>>>>
>>>>>>>> Am Do., 25. Juni 2020 um 12:48 Uhr schrieb Gabriel C
>>>>>>>> <nix.or.die@googlemail.com>:
>>>>>>>>>
>>>>>>>>> Am Do., 25. Juni 2020 um 06:57 Uhr schrieb Jiri Slaby <jirislaby@kernel.org>:
>>>>>>>>>>
>>>>>>>>>> On 25. 06. 20, 0:05, Gabriel C wrote:
>>>>>>>>>>> Am Mi., 17. Juni 2020 um 18:13 Uhr schrieb Greg Kroah-Hartman
>>>>>>>>>>> <gregkh@linuxfoundation.org>:
>>>>>>>>>>>>
>>>>>>>>>>>> I'm announcing the release of the 5.7.3 kernel.
>>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Hello Greg,
>>>>>>>>>>>
>>>>>>>>>>>> Qiujun Huang (5):
>>>>>>>>>>>>       ath9k: Fix use-after-free Read in htc_connect_service
>>>>>>>>>>>>       ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
>>>>>>>>>>>>       ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
>>>>>>>>>>>>       ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
>>>>>>>>>>>>       ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
>>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> We got a report on IRC about 5.7.3+ breaking a USB ath9k Wifi Dongle,
>>>>>>>>>>> while working fine on <5.7.3.
>>>>>>>>>>>
>>>>>>>>>>> I don't have myself such HW, and the reported doesn't have any experience
>>>>>>>>>>> in bisecting the kernel, so we build kernels, each with one of the
>>>>>>>>>>> above commits reverted,
>>>>>>>>>>> to find the bad commit.
>>>>>>>>>>>
>>>>>>>>>>> The winner is:
>>>>>>>>>>>
>>>>>>>>>>> commit 6602f080cb28745259e2fab1a4cf55eeb5894f93
>>>>>>>>>>> Author: Qiujun Huang <hqjagain@gmail.com>
>>>>>>>>>>> Date:   Sat Apr 4 12:18:38 2020 +0800
>>>>>>>>>>>
>>>>>>>>>>>     ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
>>>>>>>>>>>
>>>>>>>>>>>     commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 upstream.
>>>>>>>>>>> ...
>>>>>>>>>>>
>>>>>>>>>>> Reverting this one fixed his problem.
>>>>>>>>>>
>>>>>>>>>> Obvious question: is 5.8-rc1 (containing the commit) broken too?
>>>>>>>>>
>>>>>>>>> Yes, it does, just checked.
>>>>>>>>>
>>>>>>>>> git tag --contains 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05
>>>>>>>>> v5.8-rc1
>>>>>>>>> v5.8-rc2
>>>>>>>>>
>>>>>>>>
>>>>>>>> Sorry, I read the wrong, I just woke up.
>>>>>>>>
>>>>>>>> We didn't test 5.8-rc{1,2} yet but we will today and let you know.
>>>>>>>>
>>>>>>>
>>>>>>> We tested 5.8-rc2 and it is broken too.
>>>>>>>
>>>>>>> The exact HW name is:
>>>>>>>
>>>>>>> TP-link tl-wn722n (Atheros AR9271 chip)
>>>>>>
>>>>>> Great!
>>>>>>
>>>>>> Can you work with the developers to fix this in Linus's tree first?
>>>>>
>>>>> I'm the man in the middle, but sure we will try patches or any suggestions
>>>>> from developers to identify and fix the problem.
>>>>>
>>>>>>
>>>>>> I bet they want to see the output of 'lsusb -v' for this device to see
>>>>>> if the endpoint calculations are correct...
>>>>>>
>>>>>
>>>>> Working on it. As soon the reporter gives me the output, I will post it here.
>>>>> I've told him to run it on a broken and one working kernel.
>>>>
>>>> That is from a good kernel with reverted commit
>>>> https://gist.github.com/AngryPenguinPL/07c8e2abd3b103eaf8978a39ad8577d1
>>>>
>>>> That is from the broken kernel without the commit reverted
>>>> https://gist.github.com/AngryPenguinPL/5cdc0dd16ce5e59ff3c32c048e2f5111
>>>>
>>>> This is from 5.7.5 kernel, I don't have yet a 5.8-rc2 package with the
>>>> reverted commit.
>>>
>>> Did this ever get resolved?
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> This bug was also reported on the thread where it had been posted originally:
>> https://lore.kernel.org/linux-wireless/20200621020428.6417d6fb@natsu/
>>
>> I am waiting for Kalle Valo to accept my patch (v2) which reverts the above
>> mentioned commit and which looks correct according to him. He wrote that he
>> would take a closer look at this as soon as he could.
> 
> Mark posted a patch which I'm hoping to fix the issue:
> 
> [1/1] ath9k: Fix regression with Atheros 9271
> 
> https://patchwork.kernel.org/patch/11657669/
> 
> Can someone confirm this, please? I would rather take Mark's fix than
> the revert.
> 

12345678901234567890123456789012345678901234567890123456789012345678901234567890
This fixes the issue for me. Unfortunately the revert landed in 5.7.9 (it was
also queued for the older releases, but I didn't check them) because Hans de
Goede requested it since he didn't know about Mark's patch. So if you want to
fix the stable and longterm kernels properly, we need another patch which
includes a re-revert and Mark's patch. But Mark's patch should definitely land
in the mainline kernel first.
