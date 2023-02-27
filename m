Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7EF26A3FBB
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 11:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjB0K5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 05:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjB0K5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 05:57:20 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAEB16AF0;
        Mon, 27 Feb 2023 02:57:18 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pWbBz-0007Bw-Rm; Mon, 27 Feb 2023 11:57:15 +0100
Message-ID: <2a381d6c-25d9-0027-4951-c0012d09b498@leemhuis.info>
Date:   Mon, 27 Feb 2023 11:57:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [PATCH 1/1] tpm: disable hwrng for fTPM on some AMD designs
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
References: <20230214201955.7461-1-mario.limonciello@amd.com>
 <20230214201955.7461-2-mario.limonciello@amd.com>
 <50b5498c-38fb-e2e8-63f0-3d5bbc047737@leemhuis.info>
 <Y/ABPhpMQrQgQ72l@kernel.org> <03c045b5-73f8-0522-9966-472404068949@amd.com>
 <Y/VLYxAqmlF8nbw3@kernel.org>
 <MN0PR12MB610146866686D09CBFEC7AA2E2A59@MN0PR12MB6101.namprd12.prod.outlook.com>
Content-Language: en-US, de-DE
In-Reply-To: <MN0PR12MB610146866686D09CBFEC7AA2E2A59@MN0PR12MB6101.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1677495438;e9c5d3f5;
X-HE-SMSGID: 1pWbBz-0007Bw-Rm
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker. Top-posting for once,
to make this easily accessible to everyone.

Jarkko (or James), what is needed to get this regression resolved? More
people showed up that are apparently affected by this. Sure, 6.2 is out,
but it's a regression in 6.1 it thus would be good to fix rather sooner
than later. Ideally this week, if you ask me.

FWIW, latest version of this patch is here, but it didn't get any
replies since it was posted last Tuesday (and the mail quoted below is
just one day younger):

https://lore.kernel.org/all/20230220180729.23862-1-mario.limonciello@amd.com/

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

#regzbot poke

On 22.02.23 00:10, Limonciello, Mario wrote:
> [Public]
> 
>> -----Original Message-----
>> From: Jarkko Sakkinen <jarkko@kernel.org>
>> Sent: Tuesday, February 21, 2023 16:53
>> To: Limonciello, Mario <Mario.Limonciello@amd.com>
>> Cc: Thorsten Leemhuis <regressions@leemhuis.info>; James Bottomley
>> <James.Bottomley@hansenpartnership.com>; Jason@zx2c4.com; linux-
>> integrity@vger.kernel.org; linux-kernel@vger.kernel.org;
>> stable@vger.kernel.org; Linus Torvalds <torvalds@linux-foundation.org>;
>> Linux kernel regressions list <regressions@lists.linux.dev>
>> Subject: Re: [PATCH 1/1] tpm: disable hwrng for fTPM on some AMD designs
>>
>> On Fri, Feb 17, 2023 at 08:25:56PM -0600, Limonciello, Mario wrote:
>>> On 2/17/2023 16:05, Jarkko Sakkinen wrote:
>>>
>>>> Perhaps tpm_amd_* ?
>>>
>>> When Jason first proposed this patch I feel the intent was it could cover
>>> multiple deficiencies.
>>> But as this is the only one for now, sure re-naming it is fine.
>>>
>>>>
>>>> Also, just a question: is there any legit use for fTPM's, which are not
>>>> updated? I.e. why would want tpm_crb to initialize with a dysfunctional
>>>> firmware?>
>>>> I.e. the existential question is: is it better to workaround the issue and
>>>> let pass through, or make the user aware that the firmware would really
>>>> need an update.
>>>>
>>>
>>> On 2/17/2023 16:35, Jarkko Sakkinen wrote:
>>>>>
>>>>> Hmm, no reply since Mario posted this.
>>>>>
>>>>> Jarkko, James, what's your stance on this? Does the patch look fine
>> from
>>>>> your point of view? And does the situation justify merging this on the
>>>>> last minute for 6.2? Or should we merge it early for 6.3 and then
>>>>> backport to stable?
>>>>>
>>>>> Ciao, Thorsten
>>>>
>>>> As I stated in earlier response: do we want to forbid tpm_crb in this case
>>>> or do we want to pass-through with a faulty firmware?
>>>>
>>>> Not weighting either choice here I just don't see any motivating points
>>>> in the commit message to pick either, that's all.
>>>>
>>>> BR, Jarkko
>>>
>>> Even if you're not using RNG functionality you can still do plenty of other
>>> things with the TPM.  The RNG functionality is what tripped up this issue
>>> though.  All of these issues were only raised because the kernel started
>>> using it by default for RNG and userspace wants random numbers all the
>> time.
>>>
>>> If the firmware was easily updatable from all the OEMs I would lean on
>>> trying to encourage people to update.  But alas this has been available for
>>> over a year and a sizable number of OEMs haven't distributed a fix.
>>>
>>> The major issue I see with forbidding tpm_crb is that users may have been
>>> using the fTPM for something and taking it away in an update could lead to
>> a
>>> no-boot scenario if they're (for example) tying a policy to PCR values and
>>> can no longer access those.
>>>
>>> If the consensus were to go that direction instead I would want to see a
>>> module parameter that lets users turn on the fTPM even knowing this
>> problem
>>> exists so they could recover.  That all seems pretty expensive to me for
>>> this problem.
>>
>> I agree with the last argument.
> 
> FYI, I did send out a v2 and folded in this argument to the commit message
> and adjusted for your feedback.  You might not have found it in your inbox
> yet.
> 
>>
>> I re-read the commit message and
>> https://www.amd.com/en/support/kb/faq/pa-410.
>>
>> Why this scopes down to only rng? Should TPM2_CC_GET_RANDOM also
>> blocked
>> from /dev/tpm0?
>>
> 
> The only reason that this commit was created is because the kernel utilized
> the fTPM for hwrng which triggered the problem.  If that never happened
> this probably wouldn't have been exposed either.
> 
> Yes; I would agree that if someone was to do other fTPM operations over
> an extended period of time it's plausible they can cause the problem too. 
> 
> But picking and choosing functionality to block seems quite arbitrary to me.
> 
