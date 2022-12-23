Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3861465512F
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 15:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbiLWOJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 09:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiLWOJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 09:09:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F49C248C2;
        Fri, 23 Dec 2022 06:09:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BDFA6100A;
        Fri, 23 Dec 2022 14:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E96BC433EF;
        Fri, 23 Dec 2022 14:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671804567;
        bh=/faS2TA/UFNT5gRFa1SBNTgmSqPE0EN7xs34H8GrcqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qUMrZbj0niPvvbkxQJTaU+akV4SNzL6wHHfTtDp1RuUWM9YTOJWLNHr3VIbs/KGZh
         nnR6nRpuU/pWgl+WeTJOcXbfQEh3DiXkV0dk5+oJZw3vCeRFNntmhu5sCAxG/jVIzR
         MHShAMQW4V2+4KXeJyoFSqkSaGq0mcVMKSYs1lzrkiREQXYl5V4ek0RN6+vUcdmYAp
         RQUCGAd8h+0P/sP+KUUGmKpFZJatR+TFdbEdYXiy4O1Nmx5GSg95wEJloHq0T87EC0
         YqX6Q2ESUVNef/gNt1cXnO4j2A0PUyZ+9b18lHwW8r8jeEY6PaMmQO+qaMTgB7MALa
         wX/itAzNwJ9yg==
Date:   Fri, 23 Dec 2022 09:09:26 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Icenowy Zheng <uwu@icenowy.me>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jernej Skrabec <jernej.skrabec@gmail.com>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, wens@csie.org,
        samuel@sholland.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 6.1 8/9] arm64: dts: allwinner: h616: Add USB
 nodes
Message-ID: <Y6W2lp36Kog68Z98@sashalap>
References: <20221217000937.41115-1-sashal@kernel.org>
 <20221217000937.41115-8-sashal@kernel.org>
 <20221220000115.19c152fe@slackpad.lan>
 <671ce02325703fa3e4969ba66e014001e6b83314.camel@icenowy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <671ce02325703fa3e4969ba66e014001e6b83314.camel@icenowy.me>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 20, 2022 at 02:48:29PM +0800, Icenowy Zheng wrote:
>在 2022-12-20星期二的 00:01 +0000，Andre Przywara写道：
>> On Fri, 16 Dec 2022 19:09:35 -0500
>> Sasha Levin <sashal@kernel.org> wrote:
>>
>> > From: Andre Przywara <andre.przywara@arm.com>
>> >
>> > [ Upstream commit f40cf244c3feb4e1a442f8029b691add2c65b3ab ]
>>
>> This is not really a backport candidate:
>> - This is not a fix, but a new feature.
>> - This relies on the H616 USB PHY support patch, which will be only
>> in
>>   v6.2 (and won't be backported).

I'll go ahead and drop it.

>> - DT backports are generally not useful to begin with, and should
>>   actually not be necessary anyway.
>
>DT changes include fixes and new features. New features are not useful,
>but fixes are useful.
>
>This specific change is a new feature one, not a fix one though.

Right - this is a similar issue to PCI/USB/etc IDs, or quirks - we try
and backport patches that enable new hardware to work (proerly) with
drivers that already exist in the kernel.

-- 
Thanks,
Sasha
