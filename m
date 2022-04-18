Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82AC505BE8
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 17:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345660AbiDRPvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 11:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345834AbiDRPvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 11:51:21 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A634DF9B;
        Mon, 18 Apr 2022 08:29:40 -0700 (PDT)
Received: from [2a02:8108:963f:de38:6624:6d8d:f790:d5c]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1ngTJp-00046e-Rp; Mon, 18 Apr 2022 17:29:37 +0200
Message-ID: <d61f561c-cccd-6d48-cc2a-2eb83df6925a@leemhuis.info>
Date:   Mon, 18 Apr 2022 17:29:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] gpio: Request interrupts after IRQ is initialized
Content-Language: en-US
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        firew4lker <firew4lker@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Richard.Gong@amd.com, Stable <stable@vger.kernel.org>
References: <20220414025705.598-1-mario.limonciello@amd.com>
 <20966c6b-9045-9f8b-ba35-bf44091ce380@gmail.com>
 <67df4178-5943-69d8-0d61-f533671a1248@amd.com>
 <CAHp75VceVwAq68s_hnpXt8VvLBHVUMxFTJR+_Tnph_mvpxGVPw@mail.gmail.com>
 <49dceaa1-7e8a-671a-0601-2ee92a5d3818@leemhuis.info>
 <CAHp75Vd1VKeGx2EJnKnSBf-DvnPPajDNs=+kQ1f6j5JU8hNLMg@mail.gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <CAHp75Vd1VKeGx2EJnKnSBf-DvnPPajDNs=+kQ1f6j5JU8hNLMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1650295780;d9270d2e;
X-HE-SMSGID: 1ngTJp-00046e-Rp
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.04.22 16:17, Andy Shevchenko wrote:
> On Mon, Apr 18, 2022 at 4:58 PM Thorsten Leemhuis
> <regressions@leemhuis.info> wrote:
>>
>> On 18.04.22 13:42, Andy Shevchenko wrote:
>>> On Mon, Apr 18, 2022 at 7:34 AM Mario Limonciello
>>> <mario.limonciello@amd.com> wrote:
>>>> On 4/17/22 07:24, firew4lker wrote:
>>>
>>> ...
>>>
>>>> Linus Walleij,
>>>>
>>>> As this is backported to 5.15.y, 5.16.y, 5.17.y and those all had point
>>>> releases a bunch of people are hitting it now.  If you choose to adopt
>>>> this patch instead of revert the broken one, you can add to the commit
>>>> message too:
>>>>
>>>> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1976
>>>
>>> I prefer to explicitly tell that this is a link to a bug report, hence BugLink:.
>>> But this is just my 2 cents.
>>
>> Please use "Link:" as explained by the kernel's documentation in
>> Documentation/process/submitting-patches.rst
>> Documentation/process/5.Posting.rst (disclaimer: I recently made this
>> more explicit, but the concept it old). That's important, as people have
>> tools that rely on it -- I for example run one to track regressions, but
>> I might not be the only one running a tool that relies on proper tags.
> 
> To me it looks like a documentation confusion since Link is what is
> added automatically by `b4` tool.

Since some time now, yes, but the "Link:" tags are way older and used to
 link to all sorts of places that are relevant.

> Having Link from the patch thread
> (and not always the one with the discussion) as well as link to the
> issue will be confusing.

Yup, but that's how it is for years already (and in the muscle memory of
some -- that's why I might make sense to teach b4 to set something else,
but that's a different story). Linus himself does it like that. Recent
commits showing that are for example 901c7280ca0d or 0313bc278dac. And
for links bug trackers, too, as 80d47f5de5e3 or 14e3e989f6a5 show.

>> And FWIW: I'm all for making this more explicit, but people already use
>> various different tags (BugLink is just one of them) for that and that
>> just results in a mess.
> Nope, it results otherwise. The Link is Link to the thread, which you
> may find a lot in the kernel history. Making bug report links and
> links to the patch threads that's what results in a mess.

Yeah, but we are in that mess already and people inventing different
tags; some of the DRM people for example use(d?) "References", but there
were others iirc.

>> I proposed consistent tags, but that didn't get
>> much feedback. Maybe I should try again. Makes me wonder: where does
>> BugLink come from? Is that something that people are used to from
>> GitLab, GitHub, or something?
> It comes from kernel history :-)

Okay, thx, had just been wondering if people are used to it from some
platform.

Ciao, Thorsten
