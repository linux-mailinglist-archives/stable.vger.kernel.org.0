Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78082221F51
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 11:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgGPJC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 05:02:58 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:47976 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728337AbgGPJC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 05:02:57 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594890176; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=7CyfaApRY22qfhxW5ZVfuZTLhmfeSWKVhmQOnb67Jk8=; b=cT1CLHEIYxWqBW5CQokAI3y45gN1HhanICCAs/m/Oo45smBG/t2aRZZU32wOxTpgmQl4Wgoi
 QNhsarjsWqa2fLVkhE7WjwVAj/9detJpCy9LJPFTFVoSB3JxCUufB/sy3LZ6uLYmX+ZbK12c
 MYnCbYQE6ptTYxMyN90ChpLkt30=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5f1017c0ee6926bb4f75dd00 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 16 Jul 2020 09:02:56
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9F5FDC433C9; Thu, 16 Jul 2020 09:02:55 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5E1E1C433CB;
        Thu, 16 Jul 2020 09:02:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5E1E1C433CB
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
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Roman Mamedov <rm@romanrm.net>
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
        <87ft9sbym3.fsf@tynnyri.adurom.net>
        <20eec98e-960c-cece-21e4-01e26b44233e@freenet.de>
Date:   Thu, 16 Jul 2020 12:02:49 +0300
In-Reply-To: <20eec98e-960c-cece-21e4-01e26b44233e@freenet.de> ("Viktor
        \=\?utf-8\?Q\?J\=C3\=A4gersk\=C3\=BCpper\=22's\?\= message of "Thu, 16 Jul 2020
 10:15:30 +0200")
Message-ID: <87365r96iu.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Viktor J=C3=A4gersk=C3=BCpper <viktor_jaegerskuepper@freenet.de> writes:

>>> This bug was also reported on the thread where it had been posted origi=
nally:
>>> https://lore.kernel.org/linux-wireless/20200621020428.6417d6fb@natsu/
>>>
>>> I am waiting for Kalle Valo to accept my patch (v2) which reverts the a=
bove
>>> mentioned commit and which looks correct according to him. He wrote tha=
t he
>>> would take a closer look at this as soon as he could.
>>=20
>> Mark posted a patch which I'm hoping to fix the issue:
>>=20
>> [1/1] ath9k: Fix regression with Atheros 9271
>>=20
>> https://patchwork.kernel.org/patch/11657669/
>>=20
>> Can someone confirm this, please? I would rather take Mark's fix than
>> the revert.
>>=20
>
> This fixes the issue for me.

Great, thanks for testing. I'll wait at least another day for more
comments and then queue it for v5.8.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
