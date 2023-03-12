Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA236B64FD
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 11:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjCLKko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 06:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCLKkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 06:40:43 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844062B2A5;
        Sun, 12 Mar 2023 03:40:42 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pbJ81-0003if-4E; Sun, 12 Mar 2023 11:40:37 +0100
Message-ID: <a685eb86-ca78-6dd2-5c61-b6a217fe784a@leemhuis.info>
Date:   Sun, 12 Mar 2023 11:40:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v3] tpm: disable hwrng for fTPM on some AMD designs
Content-Language: en-US, de-DE
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        reach622@mailcuk.com, Bell <1138267643@qq.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>
References: <20230228024439.27156-1-mario.limonciello@amd.com>
 <Y/1wuXbaPcG9olkt@kernel.org>
 <5e535bf9-c662-c133-7837-308d67dfac94@leemhuis.info>
 <85df6dda-c1c9-f08e-9e64-2007d44f6683@leemhuis.info>
 <ZA0sScO47IMKPhtG@kernel.org> <ZA0t/8Tz1Lbz25BZ@kernel.org>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <ZA0t/8Tz1Lbz25BZ@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1678617642;9e6e5250;
X-HE-SMSGID: 1pbJ81-0003if-4E
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12.03.23 02:42, Jarkko Sakkinen wrote:
> On Sun, Mar 12, 2023 at 03:35:08AM +0200, Jarkko Sakkinen wrote:
>> On Fri, Mar 10, 2023 at 06:43:47PM +0100, Thorsten Leemhuis wrote:
>>> [adding Linux to the list of recipients]
>>>
>>> On 08.03.23 10:42, Linux regression tracking (Thorsten Leemhuis) wrote:
>>>> Hi, Thorsten here, the Linux kernel's regression tracker. Top-posting
>>>> for once, to make this easily accessible to everyone.
>>>>
>>>> Jarkko, thx for reviewing and picking below fix up. Are you planning to
>>>> send this to Linus anytime soon, now that the patch was a few days in
>>>> next? It would be good to get this 6.1 regression finally fixed, it
>>>> already took way longer then the time frame
>>>> Documentation/process/handling-regressions.rst outlines for a case like
>>>> this. But well, that's how it is sometimes...
>>>
>>> Linus, would you consider picking this fix up directly from here or from
>>> linux-next (8699d5244e37)? It's been in the latter for 9 days now
>>> afaics. And the issue seems to bug more than just one or two users, so
>>> it IMHO would be good to get this finally resolved.
>>>
>>> Jarkko didn't reply to my inquiry, guess something else keeps him busy.
>>
>> That's a bit arrogant. You emailed only 4 days ago.
>>
>> I'm open to do PR for rc3 with the fix, if it cannot wait to v6.4 pr.
> 
> If this is about slow response with kernel bugzilla: [...]

Not at all, I don't care if developers use bugzilla or ignore it, as
long as the regression itself it dealt with.

Fun fact: I actually wanted to get rid of bugzilla for developers/
subsystems that didn't opt-in, but then another plan came up. See
https://lwn.net/Articles/910740/

Ciao, Thorsten
