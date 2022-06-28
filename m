Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454E355F044
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 23:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiF1VUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 17:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiF1VUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 17:20:37 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB4233360;
        Tue, 28 Jun 2022 14:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1656451231;
        bh=2COHy7/Y0JvOG8VhPu09qwrobpJDf/F8NdpGhDlbaKs=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=MF6gFXSTbegGDe3Ot/SZwzcS9wYPMKH1Q0I7ncTWccszkkQrTg/jU1AAX0FkJEJQG
         NR4dlYs4J8ADpcRhNjrbUeovbsRJ6N4QH/OWKZ3x5suLd5pDv2dMFQFePiKn9O3cHJ
         /v06LKlRAKyp3vRdgZCR6kR9vh7X7OWXzxyPfCSY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.33.115]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1McYCb-1nVsTy12lh-00d2eO; Tue, 28
 Jun 2022 23:20:31 +0200
Message-ID: <d54fe0fa-fa02-cc27-d523-938f8c5edd9c@gmx.de>
Date:   Tue, 28 Jun 2022 23:20:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.18 000/181] 5.18.8-rc1 review
Content-Language: de-DE
To:     Thomas Backlund <tmb@tmb.nu>, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <f0cdac2a-79f3-af1c-eac9-698b0c8196a3@tmb.nu>
From:   Ronald Warsow <rwarsow@gmx.de>
In-Reply-To: <f0cdac2a-79f3-af1c-eac9-698b0c8196a3@tmb.nu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UmCBgeXxFhHYLU6f1F7rf8WJu+FfcqHbRXLJ+iuGNv+YLBiWo/q
 z2d6HCOfgJMcX69+gQ6zCuQibJ5oR+JrmZBrtV2bukLQlAmbEthZTq/jd9gg/37kqql48rL
 vNewKF0Pfx6YftLu2AytSHhjPD8nxnONmh244nWHAgD5c85q4gl6+2ze4/QiirIdU361Fe3
 VgJEOwVtpFYnHb4RNk0Eg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:XyQuI1/X5KY=:FsveJ85JWVh8ni6TWcA+y8
 4rL+yD1+7FNa1x8b9p7F+Wq1xqaWKpUIIbibZT8ONwC89y9G7QkvAYssb5hhpZ44mO1576dE9
 MpwIFZs6L3CX71P5FJIta9Mv37hl76/aWLwzqyBkYMfz/25fzxL2kL2kBOpjXSDzALcloqEGv
 yKZpF41EqcA4TzjyfMoeJwiu+LN6Dfoy6GjZ+rm7zjZwskClV66iu5k7Ne4rFpRD5LiUA+8Bh
 uv+jGPd5hKXRSAIsYomA0cTawgtV5wxCgefshwVx17mzyjj8K62X4XhpkQCyoe6Yl+u+SU6s3
 6X6+a+G/B5oUG2k35AM7VhBk76ajAGuIFDdLKBtv903PkZqd1nDAewpSqfv6FdWxK7s2zx9Mj
 1q7avLmjsQbDSM7dtcppziaqrfH9cFO5P8AYG10cqxLBBTEHdquT4aT7XLSlL34PZwtbhhRjL
 HC+DQB6p9K+7kg3uVxTl2wnriN46Q9IFGJpJo5MN2+wozIWuHnl7kyWioAVAkijfEbltrOPSN
 z7Qy3ElmLMQHM7t2JN3ssh0nMmX4iYGeF+okrfb1XWkXIMXhs6ggWTamfcO+N2GpcBJxzKEOP
 ACNrtxfoCaqmX1ynTvx65X7BxE5PT74j/mqYB8h8oJt8ntRXK9mYvUP7S22e/xeX4n1bYlNG3
 GUY1w85eSxhlx2/r3wQMv7W7e8JOlixujKRja860eDFI836d1CsQ97SiNYwtuh50L1N/Iw/uB
 FpEb8ZTEuSwXn7jLDVHENfxgKpsFv0BDbbUjAh6CP5jWATcBqiCUmRzdgy1fvp7kGzsqAOtcp
 z+O7Fhq1e6fA+kT4OK4mosjqNvSB+wrRY7PwssFWuuqEfGlHmV3VhQ5ByLZHSRcLf9mOVgvkX
 HY3EC2uZBq+UFxBR22m+eLt1cf6J8D4IHEWA3QXaeHGhE5c0shP4Wr9L5CFk9LK2iSFPG9tjL
 oSKc7d1B8KrmPZFnCanmla52VtlzC1+FS2S6Rus+Nk89xa6xwdYqMeP1K6JMQ2yNvHpqEuP9u
 cO4aaoOHmYK2EXVDtWEGqmdMx+EP+s0njn6KBu2jBbeR7L84vV74VFziB9FXHBLLbWi8f15Sq
 p403AzW6K9CaJYU1UzKoh1fjr3/gzY7c4b8FUKN01pxVRb81mVFnV1y33mnrvY6rWZu/0AMfY
 eG8jQyvpmMz0NX5GgyK6ujrd1yrZkh997CtE1PNr/GY77+mMmOXQA7quoLe9POME5g9Oc=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28.06.22 22:18, Thomas Backlund wrote:
> Den 2022-06-27 kl. 19:38, skrev Ronald Warsow:
>> hallo Greg
>>
>> 5.18.8-rc1
>>
>> compiles (see [1]), boots and runs here on x86_64
>> (Intel i5-11400, Fedora 36)
>>
>> [1]
>> a regression against 5.18.7:
>>
>> ...
>>
>> LD=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vmlinux.o
>>   =C2=A0 MODPOST vmlinux.symvers
>> WARNING: modpost: vmlinux.o(___ksymtab_gpl+tick_nohz_full_setup+0x0):
>> Section mismatch in reference from the variable
>> __ksymtab_tick_nohz_full_setup to the function
>> .init.text:tick_nohz_full_setup()
>> The symbol tick_nohz_full_setup is exported and annotated __init
>> Fix this by removing the __init annotation of tick_nohz_full_setup or
>> drop the export.
>
>
> Should be fixed by:
>
>
>   From 2390095113e98fc52fffe35c5206d30d9efe3f78 Mon Sep 17 00:00:00 2001
> From: Masahiro Yamada <masahiroy@kernel.org>
> Date: Mon, 27 Jun 2022 12:22:09 +0900
> Subject: [PATCH] tick/nohz: unexport __init-annotated tick_nohz_full_set=
up()
>
> --
> Thomas
>

Thanks Thomas
=2D-
Ronald

