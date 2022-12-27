Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB23656C59
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 16:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiL0PMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 10:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbiL0PMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 10:12:46 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE8BF6E
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 07:12:44 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pABdD-0006fh-9z; Tue, 27 Dec 2022 16:12:43 +0100
Message-ID: <39289e9a-2afa-1d1e-dda0-7958c66c73c2@leemhuis.info>
Date:   Tue, 27 Dec 2022 16:12:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Possible regression with kernel 6.1.0 freezing (6.0.14 is fine)
 on haswell laptop (issue identified and patch already available)
Content-Language: en-US, de-DE
To:     Sergio Callegari <sergio.callegari@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
References: <cb697d4e-406b-169b-c595-6521f8481304@gmail.com>
 <Y6W6Qxwq94y9QGFl@kroah.com> <38cd1c38-b469-f25d-369e-57877865fdbb@gmail.com>
 <8c3034f1-bedd-0e43-46e5-1e1fdca238a5@leemhuis.info>
 <18216b2c-d5f8-ada5-6110-192895772cbf@gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <18216b2c-d5f8-ada5-6110-192895772cbf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1672153965;45967b47;
X-HE-SMSGID: 1pABdD-0006fh-9z
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27.12.22 15:46, Sergio Callegari wrote:
> My issue was

Likely not important, but FWIW: I assume you meant "will be" here, as
unless I'm missing something that patch is not even in mainline (and not
even marked explicitly for backporting to 6.1.y; sigh :-/)

> the one described in
> https://patchwork.kernel.org/project/linux-wireless/patch/20221217085624.52077-1-nbd@nbd.name/

Thx for letting us know. Ideally you want to rely to that mail (see
https://lore.kernel.org/all/20221217085624.52077-1-nbd@nbd.name/
) to let the developer know that their patch fixes your problem.

Ciao, Thorsten

#regzbot fix: wifi: mac80211: fix initialization of rx->link and
rx->link_sta

> On 24/12/2022 06:22, Thorsten Leemhuis wrote:
>> Hi, this is your Linux kernel regression tracker.
>>
>> On 23.12.22 20:51, Sergio Callegari wrote:
>>> On 23/12/2022 15:25, Greg KH wrote:
>>>
>>>> Reported to the distro, but seems serious enough to report here too.
>> Out of curiosity: where?
>>
>>>> Can you use 'git bisect' to find the offending commit?
>>> Must learn a bit more about the distro I am using and what it requires
>>> for a custom kernel but I may try.
>> I'm writing a document I plan to submit for inclusion that might be of
>> help for you:
>>
>> http://www.leemhuis.info/files/misc/How%20to%20quickly%20build%20a%20Linux%20kernel%20%e2%80%94%20The%20Linux%20Kernel%20documentation.html
>>
>> It doesn't cover bisection, I left that for later (and maybe separate
>> document), as I want this one reviewed and merged first.
>>
>> Ciao, Thorsten
> 
