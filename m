Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4B76DF231
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 12:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjDLKsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 06:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjDLKsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 06:48:03 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F7065A5;
        Wed, 12 Apr 2023 03:48:02 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pmY19-0004FO-MH; Wed, 12 Apr 2023 12:47:59 +0200
Message-ID: <949fc214-3216-c012-0ddd-b6e1745c35ae@leemhuis.info>
Date:   Wed, 12 Apr 2023 12:47:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] pinctrl: amd: Disable and mask interrupts on resume
Content-Language: en-US, de-DE
To:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Kornel_Dul=c4=99ba?= <korneld@chromium.org>
Cc:     Linux regressions mailing list <regressions@lists.linux.dev>,
        gregkh@linuxfoundation.org,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        upstream@semihalf.com, rad@semihalf.com, mattedavis@google.com,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        "Gong, Richard" <richard.gong@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230320093259.845178-1-korneld@chromium.org>
 <d1d39179-33a0-d35b-7593-e0a02aa3b10a@amd.com>
 <ed840be8-b27b-191e-4122-72f62d8f1b7b@amd.com>
 <37178398-497c-900b-361a-34b1b77517aa@leemhuis.info>
 <CAD=NsqzFiQBxtVDmCiJ24HD0YZiwZ4PQkojHHic775EKfeuiaQ@mail.gmail.com>
 <36c7638f-964b-bee6-b44b-c8406e71dfec@leemhuis.info>
 <CAD=Nsqx2Gy08HHzjRoWxS7u559hUgi_GGRis0UDFxrUqLYjTfg@mail.gmail.com>
 <CACRpkdYoALVKFPoxxac=c9x3vRhYge+VAUSqKdkqSvgvS+PiXw@mail.gmail.com>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <CACRpkdYoALVKFPoxxac=c9x3vRhYge+VAUSqKdkqSvgvS+PiXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1681296482;bd56f689;
X-HE-SMSGID: 1pmY19-0004FO-MH
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11.04.23 22:44, Linus Walleij wrote:
> On Tue, Apr 11, 2023 at 3:35 PM Kornel Dulęba <korneld@chromium.org> wrote:
>> On Tue, Apr 11, 2023 at 3:29 PM Linux regression tracking (Thorsten
>> Leemhuis) <regressions@leemhuis.info> wrote:
> 
>>> Linusw, what's your preferred course to realize this revert quickly?
>>>
>>>  * someone (Kornel?) sends a revert with a commit msg for review, which
>>> you then apply and pass on to the other Linus?
>>>
>>>  * someone (Kornel?) sends a revert with a commit msg for review that
>>> immediately asks the other Linus to pick this up directly?
>>>
>>>  * we ask the other Linus directly to revert this (who then has to come
>>> up with a commit msg on his own)?
>>
>> Would you like me to send a reverting change?
>> I can do this right away.
> 
> Yeah that is best.
> 
>> The commit message would contain something like:
>>
>> This patch introduces a regression on Lenovo Z13, which can't wake
>> from the lid with it applied.
> 
> Looks good!
> 
> Thorsten: thanks for watching over this issue, we'll have it
> resolved pronto.

Thx for saying that, in cases like this there is always something in my
head that says "maybe the developers and maintainers would have done
everything just the same way and just as quickly, even if I hadn't made
so much annoying noise". But well, better save that sorry.

Side note: I sometimes wonder if reverts like this maybe should be send
directly to LinusT for mainlining with a ACK from the maintainer (e.g.
you in this case) to speed things up. Sure, having things in next for at
least a day (and running it through subsystem specific CI) can help
finding unexpected problems, but it delays things, too -- which
sometimes might result in a revert coming to late for a new stable
release. And that easily can mean that our users have to face known
issues for about one more week. :-/

Ciao, Thorsten

/me meanwhile wonders if Greg will still pick the revert up for the next
stable releases (currently in rc), if the revert reaches mainline before
they are released on Friday

/me will wait for the revert to hit mainline before he'll prod Greg
about it
