Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216756BCB2C
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 10:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjCPJkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 05:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCPJko (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 05:40:44 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E48D23C77;
        Thu, 16 Mar 2023 02:40:42 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pck6C-0006hK-2D; Thu, 16 Mar 2023 10:40:40 +0100
Message-ID: <b5186e47-d448-9706-d0b6-45c49d03f4a2@leemhuis.info>
Date:   Thu, 16 Mar 2023 10:40:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [REGRESSION] External mic not working on Lenovo Ideapad U310,
 ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model
Content-Language: en-US, de-DE
To:     tangmeng <tangmeng@uniontech.com>, Takashi Iwai <tiwai@suse.de>,
        Jetro Jormalainen <jje-lxkl@jetro.fi>
Cc:     regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20230308215009.4d3e58a6@mopti> <87o7ou9jfi.wl-tiwai@suse.de>
 <927A9CC7D19E5BD6+6758c124-1a86-a981-d3cf-fa0da9ab589e@uniontech.com>
From:   "Linux regression tracking #update (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <927A9CC7D19E5BD6+6758c124-1a86-a981-d3cf-fa0da9ab589e@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1678959642;d356dde0;
X-HE-SMSGID: 1pck6C-0006hK-2D
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[TLDR: This mail in primarily relevant for Linux kernel regression
tracking. See link in footer if these mails annoy you.]

On 16.03.23 03:01, tangmeng wrote:
> 
> On 2023/3/15 22:29, Takashi Iwai wrote:
> 
>>
>> Sounds like multiple models using the same PCI SSID.
>> Could you share the alsa-info.sh output?
>> Meng, also could you give alsa-info.sh output of Lenovo 20149, too?
>>
>>
> Sorry, because the environment used before belongs to the customer's
> environment, the environment has been returned to the customer after the
> verification is completed.
> Output information is no longer available.

#regzbot inconclusive: unsolved, but reporter has no access to device
anymore
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.


