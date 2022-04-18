Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E08505A87
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 17:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238377AbiDRPIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 11:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240134AbiDRPHG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 11:07:06 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDEE8BE3C;
        Mon, 18 Apr 2022 06:58:33 -0700 (PDT)
Received: from [2a02:8108:963f:de38:6624:6d8d:f790:d5c]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1ngRtf-0001hG-3m; Mon, 18 Apr 2022 15:58:31 +0200
Message-ID: <49dceaa1-7e8a-671a-0601-2ee92a5d3818@leemhuis.info>
Date:   Mon, 18 Apr 2022 15:58:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] gpio: Request interrupts after IRQ is initialized
Content-Language: en-US
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Cc:     firew4lker <firew4lker@gmail.com>,
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
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <CAHp75VceVwAq68s_hnpXt8VvLBHVUMxFTJR+_Tnph_mvpxGVPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1650290313;1fd021c4;
X-HE-SMSGID: 1ngRtf-0001hG-3m
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.04.22 13:42, Andy Shevchenko wrote:
> On Mon, Apr 18, 2022 at 7:34 AM Mario Limonciello
> <mario.limonciello@amd.com> wrote:
>> On 4/17/22 07:24, firew4lker wrote:
> 
> ...
> 
>> Linus Walleij,
>>
>> As this is backported to 5.15.y, 5.16.y, 5.17.y and those all had point
>> releases a bunch of people are hitting it now.  If you choose to adopt
>> this patch instead of revert the broken one, you can add to the commit
>> message too:
>>
>> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1976
> 
> I prefer to explicitly tell that this is a link to a bug report, hence BugLink:.
> But this is just my 2 cents.

Please use "Link:" as explained by the kernel's documentation in
Documentation/process/submitting-patches.rst
Documentation/process/5.Posting.rst (disclaimer: I recently made this
more explicit, but the concept it old). That's important, as people have
tools that rely on it -- I for example run one to track regressions, but
I might not be the only one running a tool that relies on proper tags.

And FWIW: I'm all for making this more explicit, but people already use
various different tags (BugLink is just one of them) for that and that
just results in a mess. I proposed consistent tags, but that didn't get
much feedback. Maybe I should try again. Makes me wonder: where does
BugLink come from? Is that something that people are used to from
GitLab, GitHub, or something?

Ciao, Thorsten

