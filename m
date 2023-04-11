Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7826DE182
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 18:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjDKQxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 12:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjDKQxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 12:53:09 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25599E5E;
        Tue, 11 Apr 2023 09:53:05 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pmHEs-00051b-Qy; Tue, 11 Apr 2023 18:53:02 +0200
Message-ID: <10076b2c-1f20-378d-6eb0-d7c352b4660e@leemhuis.info>
Date:   Tue, 11 Apr 2023 18:53:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 1/3] ARM: dts: meson: Fix the UART compatible strings
Content-Language: en-US, de-DE
To:     =?UTF-8?Q?Ricardo_Ca=c3=b1uelo?= <ricardo.canuelo@collabora.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20211227180026.4068352-1-martin.blumenstingl@googlemail.com>
 <20211227180026.4068352-2-martin.blumenstingl@googlemail.com>
 <20230405132900.ci35xji3xbb3igar@rcn-XPS-13-9305>
 <fdffc009-47cf-e88d-5b9e-d6301f7f73f2@leemhuis.info>
 <44556911-e56e-6171-07dd-05cc0e30c732@collabora.com>
 <71816e38-f919-11a4-1ac9-71416b54b243@leemhuis.info>
 <2023040604-washtub-undivided-5763@gregkh>
 <d7f389ab-914b-c48e-dc8e-290fb72f345e@collabora.com>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <d7f389ab-914b-c48e-dc8e-290fb72f345e@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1681231986;901f67e3;
X-HE-SMSGID: 1pmHEs-00051b-Qy
X-Spam-Status: No, score=-2.2 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.04.23 08:09, Ricardo Cañuelo wrote:
> 
> I sent the original report to stable@vger.kernel.org. 

thx! let me tell regzbot about it:

#regzbot monitor:
https://lore.kernel.org/all/1fcff522-337a-c334-42a7-bc9b4f0daec4@collabora.com/
#regzbot ignore-activity

> Sorry for
> the confusion, I'm still learning about how report regressions
> properly using regzbot, specially for stable branches. Thorsten's
> guidelines are being very helpful here.

Great to hear! But FWIW, I really should try to find some time to fine
tune reporting-issues.rst, reporting-regressions.rst, and
handling-regressions.rst some more, as there are quite a few things that
afaics could or need to be improved. Especially the aspect
"stable/longterm is handled by different set of people (but regular
developers might help)" is something that needs to become clearer afaics.

But there is still this "there are only 24 hours in a day, but so many
things to do" problem...

Ciao, Thorsten
