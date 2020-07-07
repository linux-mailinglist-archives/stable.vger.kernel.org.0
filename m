Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2747217960
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 22:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgGGU3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 16:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727908AbgGGU3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 16:29:06 -0400
X-Greylist: delayed 359 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Jul 2020 13:29:06 PDT
Received: from mout3.freenet.de (mout3.freenet.de [IPv6:2001:748:100:40::2:5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6610C061755
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 13:29:06 -0700 (PDT)
Received: from [195.4.92.165] (helo=mjail2.freenet.de)
        by mout3.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (port 25) (Exim 4.92 #3)
        id 1jsu7K-0000A1-Nx; Tue, 07 Jul 2020 22:23:02 +0200
Received: from [::1] (port=52196 helo=mjail2.freenet.de)
        by mjail2.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (Exim 4.92 #3)
        id 1jsu7K-000585-Jf; Tue, 07 Jul 2020 22:23:02 +0200
Received: from sub3.freenet.de ([195.4.92.122]:43090)
        by mjail2.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (Exim 4.92 #3)
        id 1jsu5B-0004K3-Rf; Tue, 07 Jul 2020 22:20:49 +0200
Received: from p200300e707178b006cb2a2fb62f37f24.dip0.t-ipconnect.de ([2003:e7:717:8b00:6cb2:a2fb:62f3:7f24]:58184 helo=[127.0.0.1])
        by sub3.freenet.de with esmtpsa (ID viktor.jaegerskuepper@freenet.de) (TLSv1.2:ECDHE-RSA-CHACHA20-POLY1305:256) (port 465) (Exim 4.92 #3)
        id 1jsu5B-0001wA-Mf; Tue, 07 Jul 2020 22:20:49 +0200
Subject: Re: ath9k broken [was: Linux 5.7.3]
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gabriel C <nix.or.die@googlemail.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        angrypenguinpoland@gmail.com, Qiujun Huang <hqjagain@gmail.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
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
From:   =?UTF-8?B?VmlrdG9yIErDpGdlcnNrw7xwcGVy?= 
        <viktor_jaegerskuepper@freenet.de>
Message-ID: <07c8d8fa-8bbc-0b4e-191c-b2635214e8b9@freenet.de>
Date:   Tue, 7 Jul 2020 22:20:41 +0200
MIME-Version: 1.0
In-Reply-To: <20200707141100.GE4064836@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Originated-At: 2003:e7:717:8b00:6cb2:a2fb:62f3:7f24!58184
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman wrote:
> On Fri, Jun 26, 2020 at 04:40:18PM +0200, Gabriel C wrote:
>> Am Fr., 26. Juni 2020 um 15:51 Uhr schrieb Gabriel C
>> <nix.or.die@googlemail.com>:
>>>
>>> Am Fr., 26. Juni 2020 um 15:40 Uhr schrieb Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org>:
>>>>
>>>> On Fri, Jun 26, 2020 at 01:48:59PM +0200, Gabriel C wrote:
>>>>> Am Do., 25. Juni 2020 um 12:52 Uhr schrieb Gabriel C
>>>>> <nix.or.die@googlemail.com>:
>>>>>>
>>>>>> Am Do., 25. Juni 2020 um 12:48 Uhr schrieb Gabriel C
>>>>>> <nix.or.die@googlemail.com>:
>>>>>>>
>>>>>>> Am Do., 25. Juni 2020 um 06:57 Uhr schrieb Jiri Slaby <jirislaby@kernel.org>:
>>>>>>>>
>>>>>>>> On 25. 06. 20, 0:05, Gabriel C wrote:
>>>>>>>>> Am Mi., 17. Juni 2020 um 18:13 Uhr schrieb Greg Kroah-Hartman
>>>>>>>>> <gregkh@linuxfoundation.org>:
>>>>>>>>>>
>>>>>>>>>> I'm announcing the release of the 5.7.3 kernel.
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Hello Greg,
>>>>>>>>>
>>>>>>>>>> Qiujun Huang (5):
>>>>>>>>>>       ath9k: Fix use-after-free Read in htc_connect_service
>>>>>>>>>>       ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
>>>>>>>>>>       ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
>>>>>>>>>>       ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
>>>>>>>>>>       ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> We got a report on IRC about 5.7.3+ breaking a USB ath9k Wifi Dongle,
>>>>>>>>> while working fine on <5.7.3.
>>>>>>>>>
>>>>>>>>> I don't have myself such HW, and the reported doesn't have any experience
>>>>>>>>> in bisecting the kernel, so we build kernels, each with one of the
>>>>>>>>> above commits reverted,
>>>>>>>>> to find the bad commit.
>>>>>>>>>
>>>>>>>>> The winner is:
>>>>>>>>>
>>>>>>>>> commit 6602f080cb28745259e2fab1a4cf55eeb5894f93
>>>>>>>>> Author: Qiujun Huang <hqjagain@gmail.com>
>>>>>>>>> Date:   Sat Apr 4 12:18:38 2020 +0800
>>>>>>>>>
>>>>>>>>>     ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
>>>>>>>>>
>>>>>>>>>     commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 upstream.
>>>>>>>>> ...
>>>>>>>>>
>>>>>>>>> Reverting this one fixed his problem.
>>>>>>>>
>>>>>>>> Obvious question: is 5.8-rc1 (containing the commit) broken too?
>>>>>>>
>>>>>>> Yes, it does, just checked.
>>>>>>>
>>>>>>> git tag --contains 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05
>>>>>>> v5.8-rc1
>>>>>>> v5.8-rc2
>>>>>>>
>>>>>>
>>>>>> Sorry, I read the wrong, I just woke up.
>>>>>>
>>>>>> We didn't test 5.8-rc{1,2} yet but we will today and let you know.
>>>>>>
>>>>>
>>>>> We tested 5.8-rc2 and it is broken too.
>>>>>
>>>>> The exact HW name is:
>>>>>
>>>>> TP-link tl-wn722n (Atheros AR9271 chip)
>>>>
>>>> Great!
>>>>
>>>> Can you work with the developers to fix this in Linus's tree first?
>>>
>>> I'm the man in the middle, but sure we will try patches or any suggestions
>>> from developers to identify and fix the problem.
>>>
>>>>
>>>> I bet they want to see the output of 'lsusb -v' for this device to see
>>>> if the endpoint calculations are correct...
>>>>
>>>
>>> Working on it. As soon the reporter gives me the output, I will post it here.
>>> I've told him to run it on a broken and one working kernel.
>>
>> That is from a good kernel with reverted commit
>> https://gist.github.com/AngryPenguinPL/07c8e2abd3b103eaf8978a39ad8577d1
>>
>> That is from the broken kernel without the commit reverted
>> https://gist.github.com/AngryPenguinPL/5cdc0dd16ce5e59ff3c32c048e2f5111
>>
>> This is from 5.7.5 kernel, I don't have yet a 5.8-rc2 package with the
>> reverted commit.
> 
> Did this ever get resolved?
> 
> thanks,
> 
> greg k-h
> 

This bug was also reported on the thread where it had been posted originally:
https://lore.kernel.org/linux-wireless/20200621020428.6417d6fb@natsu/

I am waiting for Kalle Valo to accept my patch (v2) which reverts the above
mentioned commit and which looks correct according to him. He wrote that he
would take a closer look at this as soon as he could.

I don't know how busy Kalle is, especially under the current circumstances.
I will remind him on Thursday (one week after his last e-mail). At the latest
I want this to be fixed with the 5.8 release. I think that the patch has to land
in several networking trees before it reaches the mainline kernel, so if I can
do anything to speed things up, just tell me.

Thanks,
Viktor
