Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FC86E1DE0
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 10:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjDNIPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 04:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjDNIPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 04:15:13 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A652738;
        Fri, 14 Apr 2023 01:15:11 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pnEaK-0007W3-UA; Fri, 14 Apr 2023 10:15:08 +0200
Message-ID: <b2edf1ed-2777-03ef-4d5e-e355a6074f78@leemhuis.info>
Date:   Fri, 14 Apr 2023 10:15:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [REGRESSION] Asus X541UAK hangs on suspend and poweroff (v6.1.6
 onward)
Content-Language: en-US, de-DE
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Acid Bong <acidbong@tilde.cafe>, regressions@lists.linux.dev
Cc:     stable@vger.kernel.org, linux-acpi@vger.kernel.org
References: <CRVU11I7JJWF.367PSO4YAQQEI@bong>
 <5f445dab-a152-bcaa-4462-1665998c3e2e@gmail.com>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <5f445dab-a152-bcaa-4462-1665998c3e2e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1681460111;2a3dfd93;
X-HE-SMSGID: 1pnEaK-0007W3-UA
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14.04.23 09:51, Bagas Sanjaya wrote:
> On 4/14/23 02:35, Acid Bong wrote:
>> The issue appeared when I was using pf-kernel with genpatches and
>> updated from 6.1-pf2 to 6.1-pf3 (corresponding to vanilla versions 6.1.3
>> -> 6.1.6). I used that fork until 6.2-pf2, but since then (early March)
>> moved to vanilla sources and started following the 6.1.y branch when it
>> was declared LTS. And the issue was present on all of them.
>>
>> The hang was last detected 3 days ago on 6.1.22 and today on 6.1.23.
> 
> Have you tried testing latest mainline to see if commits which are
> backported to 6.1.y cause your regression?

Well, if it something that started between v6.1.3 and v6.1.6 it must be
a backported commit from mainline that causes the regression.

But yeah, testing mainline would be wise to differentiate between "this
is something that is caused by a change in mainline" and "this is
something stable specific and might be caused by a bad or incomplete
backport".

It's not totally clear to me, but it seems 6.2 is affected as well?
Well, then it's a mainline issue. Testing latest mainline nevertheless
would be good to know if this maybe was fixed already.

But first something else: acidbong, why do you pass "pci=nomsi" to your
kernel? Maybe that makes your machine run in a unusual configuration
that directly or indirectly leads to your problem (which only worked by
chance earlier).

>> # regzbot introduced v6.1.3..v6.1.6
> 
> Anyway, I'm adding this to regzbot:

Well, the quoted string above already did that. But whatever, a...

> #regzbot ^introduced v6.1.3..v6.1.6

...should do no harm and this...

> #regzbot title Asus X541UAK hangs on suspend and poweroff

... has improved the title (which was derived from the subject
beforehand) somewhat. :-D

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
