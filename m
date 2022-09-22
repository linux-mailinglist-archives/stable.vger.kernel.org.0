Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0AA5E614B
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 13:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiIVLij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 07:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbiIVLii (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 07:38:38 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAF58991B;
        Thu, 22 Sep 2022 04:38:37 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1obKXL-0000Le-JK; Thu, 22 Sep 2022 13:38:35 +0200
Message-ID: <ddec1a2f-1d55-ac42-9877-0d7119d087cd@leemhuis.info>
Date:   Thu, 22 Sep 2022 13:38:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US, de-DE
To:     Jason Wittlin-Cohen <jwittlincohen@gmail.com>
Cc:     stable@vger.kernel.org, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, Kiwoong Kim <kwmad.kim@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        regressions@lists.linux.dev
References: <CADy0EvLGJmZe-x9wzWSB6+tDKNuLHd8Km3J5MiWWYQRR2ctS3A@mail.gmail.com>
 <350ec615-ffe8-2e0e-149d-4bf45932a585@acm.org>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [REGRESSION] introduced in 5.10.140 causes drives to drop from
 LSI SAS controller (Bisected to 6d17a112e9a63ff6a5edffd1676b99e0ffbcd269)
In-Reply-To: <350ec615-ffe8-2e0e-149d-4bf45932a585@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1663846717;ef969561;
X-HE-SMSGID: 1obKXL-0000Le-JK
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

On 15.09.22 04:48, Bart Van Assche wrote:
> On 9/14/22 19:21, Jason Wittlin-Cohen wrote:
>> 8d5c106fe216bf16080d7070c37adf56a9227e60 is the first bad commit
>> commit 8d5c106fe216bf16080d7070c37adf56a9227e60
>> Author: Kiwoong Kim <kwmad.kim@samsung.com
>> <mailto:kwmad.kim@samsung.com>>
>> Date: Tue Aug 2 10:42:31 2022 +0900
>>
>> scsi: ufs: core: Enable link lost interrupt
>>
>> commit 6d17a112e9a63ff6a5edffd1676b99e0ffbcd269 upstream.
>>
>> Link lost is treated as fatal error with commit c99b9b230149 ("scsi: ufs:
>> Treat link loss as fatal error"), but the event isn't registered as
>> interrupt source. Enable it.
> 
> Something must have gone wrong during the bisection process. Commit
> 8d5c106fe216 ("scsi: ufs: core: Enable link lost interrupt") only
> affects the UFS driver and hence cannot change the behavior of a SAS
> controller. How about repeating the bisection process?

Hmm, nothing happened here for a week. :-/ That's not how this should be
when it comes to regressions...

Jason, any news on this? A answer to Greg's question ("Does this also
have problems in the latest 5.15 and 5.19 release)") would be helpful.
Also: when your wrote "Running [...] a bisected kernel with commit
6d17a112e9a63ff6a5edffd1676b99e0ffbcd269 removed, [...]" I assume you
tested this with 5.10.y?

Side note: Sure, a bisection can easily got wrong, as Bart outlined. But
you also wrote "Running [...] a bisected kernel with commit
6d17a112e9a63ff6a5edffd1676b99e0ffbcd269 removed, [...]" sounds a lot
like the bisection didn't go sideways. Are you sure you nothing went
wrong when you tested this revert?

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.

#regzbot introduced 8d5c106fe216bf1608
#regzbot poke
