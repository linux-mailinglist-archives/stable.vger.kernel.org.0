Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3DA53FAD4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 12:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239925AbiFGKHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 06:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240640AbiFGKHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 06:07:21 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C8626F2
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 03:07:17 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nyW7H-0003y7-Pb; Tue, 07 Jun 2022 12:07:15 +0200
Message-ID: <cad76252-ec94-779e-aa31-b487526a2154@leemhuis.info>
Date:   Tue, 7 Jun 2022 12:07:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Eric Schikschneit <eric.schikschneit@novatechautomation.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
References: <CY1PR07MB2700E81609B0967127D0773381DF9@CY1PR07MB2700.namprd07.prod.outlook.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [REGRESSION] gpio: omap: ensure irq is enabled before wakeup
In-Reply-To: <CY1PR07MB2700E81609B0967127D0773381DF9@CY1PR07MB2700.namprd07.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1654596438;91c99077;
X-HE-SMSGID: 1nyW7H-0003y7-Pb
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

On 01.06.22 17:56, Eric Schikschneit wrote:
> Summary: OMAP patch causes SPI bus transaction failure on TI CPU 
> Commit: c859e0d479b3b4f6132fc12637c51e01492f31f6 Kernel version:
> 5.10.87
> 
> The detailed description:
> 
> I know this is a old commit at this point,

That shouldn't be a problem at all, but it raises one question that
would be good to get answered: does this problem still occur with the
latest code? This issue for example might have been fixed in between,
but maybe the fix was to complex to get backported or something like
that. Hence it would be ideal if you could quickly give 5.19-rc1 a shot;
5.18.y is not ideal, but will do as well.

> but we have observed a
> regression caused by this commit. It causes improper toggle during a
> SPI transaction with a microcontroller. The CPU in use is Texas
> Instruments AM3352BZCZA80. The microcontroller in use is a PIC based
> micro. I have logic capture images available to show the signal
> difference that is causing confusion on the SPI bus.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
