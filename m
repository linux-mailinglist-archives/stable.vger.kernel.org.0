Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A729F6B0C85
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 16:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCHPXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 10:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbjCHPWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 10:22:37 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5594B457F2;
        Wed,  8 Mar 2023 07:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1678288952; i=rwarsow@gmx.de;
        bh=//WpMSVek4JMww0Y/bC2cxhER6x89f73f6LCa4joSaw=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=j5xsNPtv42bv1N+WvOxOtMhG/5HpjUk/R/DNZJoIWt9szsFqhQprRY+pZVDsIABqT
         0sv+m7tF/7JRURw3QjazU9Ck6GAaf0e62OjRSMzrpovJSHCde1zhTKsvQhcYSjRHfo
         luSJ8I8v0DNpnW96X5eohFOPECnV15bdHd3hPEfmKCN8ImU6c8qXTUbr3x8TtqXFME
         ZhASCgEgYcc0K2DqAKXT/77GIvXqpEiC2piJ6QoEBFWInR/a3SmujVl2fEwA4dQvLn
         OF8z670CwT0PimJUuUvUunnuV0dsd5+cCJwiRNsve/s5ppexaQb0kw8Jduv8CQp3vZ
         xHYZ9AkuIRwSg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.32.138]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N17UQ-1qXlX02zne-012Zkd; Wed, 08
 Mar 2023 16:22:32 +0100
Message-ID: <e2167261-a31b-c31b-a025-39a26a46f2ff@gmx.de>
Date:   Wed, 8 Mar 2023 16:22:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.2 0000/1000] 6.2.3-rc2 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:dI97IwDuqStO0VI68Z+lb/y9UTwm+NmeR2mLEzL4LzX8fRarF9q
 uYvJPXtN8t3Dp+pBKZUJEhNlyDllqFAUKYZ7kikPL9WITyZvtsBxFoyajCgu/uOKF7hcBIA
 3zYfM8Y8Sh+DhRr6P2dzA9joKXVNYOJph+z6z1OMXICslRlEaDS0ywJfnf+QH12gVZ4VnsK
 0HI2Eu5E+v5AU1y46dffw==
UI-OutboundReport: notjunk:1;M01:P0:KIRkUVDfqfc=;FCom2vLbJNQNEfCDS9RVvQais/8
 939X9eb1uENUUx0NraHeRNIx9M/RpWF1hPjgfgNtwVr4HkOnQsWf76oGyVwsTxaTWHmahT//3
 7G5QeYy58VShFQFnZVsCqchOA4LnRvL4vOGvyERHGrdqC6BAKQNipMrTX2MUvR5xqkedr2t0G
 aUI/HW5UvUN3sEBZq88EdRlaKAj1mwIj/NJQmGSrx9oepf0pxiYWPUUxBnYKpnbrMP2MX1gXK
 HvDTvjnkAiLSxZo5SrgxlaZqXx/Cs2SC9cigb0ej2NZc60yG9f1uEOUb31Mol+UnfMWymgMhm
 84b7toymEFNaf7pQoQbFWCc4AcDX+NSLs1tE5J7oQgKZzT1I3C1/Evu/79TsGJGbakMInbqu+
 vTfzxyWGFVJUjIAie7gJJv7OFnWM1VIJmT+j8Eu2Bsgr3w7LSIM5Y4Io1IzK3YF6SIzSiaegl
 g0WqzuaP59V2KcVN9rP6R3BMBrKErmfj40rBoy+hO2kdkuDuml3PiOnf+Uq4zIgyRnhiVYmkJ
 /uVv6JbAr3QxrMqD6xNIGRctReYaSIvul6LupJ6/6xZUgWq9FgEHEdKXjF8/iNERnInTzoogk
 PMLBwZS6S1rZr9few32hXwkvgrYMiW6QFA7uP+RUMYXFTZwTHJLcLZSmc3ipJgsAhy4Re44mE
 Lc79cnwzF0lsJ/Od0TIOziuR5WvnRpugCobsgQTwbxgjkZhB3lJXz/7iixuom1yGENoDhQ/r9
 lIrUbBQj+OSRyu7551ACdU7G7h1SpmI0kKbQ1bkcoKLCT6H68FTlsYyOmacdJfbs996kt23sP
 ySVsya5x8UhBhFWUgjNQ2n5gEbABpXmbhmf4KQ1FDH2Ri9tfrZ2U2DOekaAmqcQ4ne+oCl74H
 sTalYSo2jypXE+mTgPVdtSPzH6y0LYm2/cEh6RIxsDUKQmCsOHiWi9fPue8mcHNBSSgZokGVq
 WmKZBA==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.2.3-rc2

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

