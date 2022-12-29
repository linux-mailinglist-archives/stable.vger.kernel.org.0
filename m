Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2C4658D00
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 14:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiL2NFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 08:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiL2NFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 08:05:04 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70CDD78
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 05:04:55 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pAsab-0003m7-Qf; Thu, 29 Dec 2022 14:04:53 +0100
Message-ID: <e8d819e0-10c4-89c0-6b13-d1ceb01da0fc@leemhuis.info>
Date:   Thu, 29 Dec 2022 14:04:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Content-Language: en-US, de-DE
To:     Vlastimil Babka <vbabka@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Cc:     stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <20221228144330.180012208@linuxfoundation.org>
 <2bf086f8-aa9d-b576-ba8b-1fcfbc9a4ff1@applied-asynchrony.com>
 <Y6xkpmqxRQwDyLAb@kroah.com> <d5534922-0b33-268d-cfad-c175ff4f676e@suse.cz>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <d5534922-0b33-268d-cfad-c175ff4f676e@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1672319095;2dafd897;
X-HE-SMSGID: 1pAsab-0003m7-Qf
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28.12.22 19:57, Vlastimil Babka wrote:
> On 12/28/22 16:45, Greg Kroah-Hartman wrote:
>> On Wed, Dec 28, 2022 at 04:02:57PM +0100, Holger Hoffstätte wrote:
>>> On 2022-12-28 15:25, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 6.1.2 release.
>>>> There are 1146 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>
>>> I know this is already a large set of updates, but it would be great if
>>> commit 6f12be792fde994ed934168f93c2a0d2a0cf0bc5 ("mm, mremap: fix mremap()
>>> expanding vma with addr inside vma") could be added as well; it applies and
>>> works fine on top of 6.1.1.
>>> This fixes quite a few annoying mmap-related out-of-memory failures.
>>
>> It's set up for future releases.  If this was such a big issue for
>> 6.1-final, why wasn't it sent to Linus before 6.2-rc1?
> 
> Thorsten did question its upstreaming speed elsewhere. But it actually
> is in 6.2-rc1. Andrew sent the PR on 22th and Linus merged on 23th [1].
> I didn't try to accelerate it to stable as IIRC people already pointed
> it out and you acknowledged it's on your radar, and it was a tracked
> regression. Sucks that it didn't make it to 6.1.2.

Yup. I've been thinking somewhat what I could or should do to ensure
things work more smoothly when similar situations arise in the future;
ideally without me stepping on maintainer's toes too much. ;)

Currently I consider doing the following two things:

(1) if I notice something that looks like an important regression fix,
reply with a "how fast do you think this fix should process through the
ranks" inquiry to the developer. With such information I'd feel way more
comfortable sending a "Linus, could you maybe pick this up directly"
after some time in case the maintainer leaves the patch longer in -next.

(2) once Linus merged the fix, send a quick mail to Greg/the stable team
asking them to immediately queue it for the next release (in case
problems show up it can still be de-queued).

Does that sound sane? Or anyone any better idea?

Ciao, Thorsten
