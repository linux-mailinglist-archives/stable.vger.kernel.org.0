Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711B822109D
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 17:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgGOPNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 11:13:36 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:19630 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbgGOPNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 11:13:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594826014; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=SSjNXt42DQxpNXXA7N1+wh/xYOkbNXGPf32vrswsm9M=; b=gl5bB9+MCdIyLbHQ1mLkxPUsSR+mPKq+esIEeqpzhb3tSs8DN5vaGOWoLHcPV9tzxe04i94z
 ItpoWAxULysOmjOEVE7ZUlWDz6KC9widRS9kKRhDDh431zsyYBfB1buwA2yWZUa9lmtuw3/y
 PJN54FSg89VcTGEghpfWFnkxOpE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5f0f1d0df9ca681bd099b739 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 15 Jul 2020 15:13:17
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 19850C433AD; Wed, 15 Jul 2020 15:13:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 78FF5C433C6;
        Wed, 15 Jul 2020 15:13:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 78FF5C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Viktor =?utf-8?B?SsOkZ2Vyc2vDvHBwZXI=?= 
        <viktor_jaegerskuepper@freenet.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gabriel C <nix.or.die@googlemail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        angrypenguinpoland@gmail.com, Qiujun Huang <hqjagain@gmail.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k broken [was: Linux 5.7.3]
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
Date:   Wed, 15 Jul 2020 18:13:08 +0300
In-Reply-To: <07c8d8fa-8bbc-0b4e-191c-b2635214e8b9@freenet.de> ("Viktor
        \=\?utf-8\?Q\?J\=C3\=A4gersk\=C3\=BCpper\=22's\?\= message of "Tue, 7 Jul 2020
 22:20:41 +0200")
Message-ID: <87ft9sbym3.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Viktor J=C3=A4gersk=C3=BCpper <viktor_jaegerskuepper@freenet.de> writes:

> Greg Kroah-Hartman wrote:
>> On Fri, Jun 26, 2020 at 04:40:18PM +0200, Gabriel C wrote:
>>> Am Fr., 26. Juni 2020 um 15:51 Uhr schrieb Gabriel C
>>> <nix.or.die@googlemail.com>:
>>>>
>>>> Am Fr., 26. Juni 2020 um 15:40 Uhr schrieb Greg Kroah-Hartman
>>>> <gregkh@linuxfoundation.org>:
>>>>>
>>>>> On Fri, Jun 26, 2020 at 01:48:59PM +0200, Gabriel C wrote:
>>>>>> Am Do., 25. Juni 2020 um 12:52 Uhr schrieb Gabriel C
>>>>>> <nix.or.die@googlemail.com>:
>>>>>>>
>>>>>>> Am Do., 25. Juni 2020 um 12:48 Uhr schrieb Gabriel C
>>>>>>> <nix.or.die@googlemail.com>:
>>>>>>>>
>>>>>>>> Am Do., 25. Juni 2020 um 06:57 Uhr schrieb Jiri Slaby <jirislaby@k=
ernel.org>:
>>>>>>>>>
>>>>>>>>> On 25. 06. 20, 0:05, Gabriel C wrote:
>>>>>>>>>> Am Mi., 17. Juni 2020 um 18:13 Uhr schrieb Greg Kroah-Hartman
>>>>>>>>>> <gregkh@linuxfoundation.org>:
>>>>>>>>>>>
>>>>>>>>>>> I'm announcing the release of the 5.7.3 kernel.
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Hello Greg,
>>>>>>>>>>
>>>>>>>>>>> Qiujun Huang (5):
>>>>>>>>>>>       ath9k: Fix use-after-free Read in htc_connect_service
>>>>>>>>>>>       ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
>>>>>>>>>>>       ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
>>>>>>>>>>>       ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_=
cb
>>>>>>>>>>>       ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> We got a report on IRC about 5.7.3+ breaking a USB ath9k Wifi Do=
ngle,
>>>>>>>>>> while working fine on <5.7.3.
>>>>>>>>>>
>>>>>>>>>> I don't have myself such HW, and the reported doesn't have any e=
xperience
>>>>>>>>>> in bisecting the kernel, so we build kernels, each with one of t=
he
>>>>>>>>>> above commits reverted,
>>>>>>>>>> to find the bad commit.
>>>>>>>>>>
>>>>>>>>>> The winner is:
>>>>>>>>>>
>>>>>>>>>> commit 6602f080cb28745259e2fab1a4cf55eeb5894f93
>>>>>>>>>> Author: Qiujun Huang <hqjagain@gmail.com>
>>>>>>>>>> Date:   Sat Apr 4 12:18:38 2020 +0800
>>>>>>>>>>
>>>>>>>>>>     ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
>>>>>>>>>>
>>>>>>>>>>     commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 upstream.
>>>>>>>>>> ...
>>>>>>>>>>
>>>>>>>>>> Reverting this one fixed his problem.
>>>>>>>>>
>>>>>>>>> Obvious question: is 5.8-rc1 (containing the commit) broken too?
>>>>>>>>
>>>>>>>> Yes, it does, just checked.
>>>>>>>>
>>>>>>>> git tag --contains 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05
>>>>>>>> v5.8-rc1
>>>>>>>> v5.8-rc2
>>>>>>>>
>>>>>>>
>>>>>>> Sorry, I read the wrong, I just woke up.
>>>>>>>
>>>>>>> We didn't test 5.8-rc{1,2} yet but we will today and let you know.
>>>>>>>
>>>>>>
>>>>>> We tested 5.8-rc2 and it is broken too.
>>>>>>
>>>>>> The exact HW name is:
>>>>>>
>>>>>> TP-link tl-wn722n (Atheros AR9271 chip)
>>>>>
>>>>> Great!
>>>>>
>>>>> Can you work with the developers to fix this in Linus's tree first?
>>>>
>>>> I'm the man in the middle, but sure we will try patches or any suggest=
ions
>>>> from developers to identify and fix the problem.
>>>>
>>>>>
>>>>> I bet they want to see the output of 'lsusb -v' for this device to see
>>>>> if the endpoint calculations are correct...
>>>>>
>>>>
>>>> Working on it. As soon the reporter gives me the output, I will post i=
t here.
>>>> I've told him to run it on a broken and one working kernel.
>>>
>>> That is from a good kernel with reverted commit
>>> https://gist.github.com/AngryPenguinPL/07c8e2abd3b103eaf8978a39ad8577d1
>>>
>>> That is from the broken kernel without the commit reverted
>>> https://gist.github.com/AngryPenguinPL/5cdc0dd16ce5e59ff3c32c048e2f5111
>>>
>>> This is from 5.7.5 kernel, I don't have yet a 5.8-rc2 package with the
>>> reverted commit.
>>=20
>> Did this ever get resolved?
>>=20
>> thanks,
>>=20
>> greg k-h
>>=20
>
> This bug was also reported on the thread where it had been posted origina=
lly:
> https://lore.kernel.org/linux-wireless/20200621020428.6417d6fb@natsu/
>
> I am waiting for Kalle Valo to accept my patch (v2) which reverts the abo=
ve
> mentioned commit and which looks correct according to him. He wrote that =
he
> would take a closer look at this as soon as he could.

Mark posted a patch which I'm hoping to fix the issue:

[1/1] ath9k: Fix regression with Atheros 9271

https://patchwork.kernel.org/patch/11657669/

Can someone confirm this, please? I would rather take Mark's fix than
the revert.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
