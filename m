Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9813444B9B6
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 01:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhKJArc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 19:47:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230457AbhKJArc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 19:47:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 612F361181;
        Wed, 10 Nov 2021 00:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636505085;
        bh=tBqFQiiw9vqZZssoZ0S0NgR+UhV7SYeIaE17u5h2RS4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FK+Ut5ifG886KM7+bhYz5EJbVFYjcr7/oRrSuTnJAc2yk/DlDdzOt6MgPitvbhU58
         37sFE9Bm/Gbifg2KU1KAr9MBXbcGUTp3yuVxru/nSBvC+QYfC5eNhb36UCQ3mPWBaY
         cvZ0+3H149wGy0B+mKVXvCZHs101U/TR1D42GED4nCcPA3SzesjQ1v1vpuxCl+tSFP
         gqi3QhhlW2nSofytRoZU55h9peYdOQlxL8cZkro7h50GjqxI/stXbgps10x1Lz7z1O
         I6agWthX2Bdd9P1LijBuYSkoUBW64gBLA9jHSY95cuHA/Fl8K8vrIZ6f+1T+N3KCTL
         PK2VddGMhY2nw==
Date:   Tue, 9 Nov 2021 19:44:44 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Leo Yan <leo.yan@linaro.org>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.15 17/82] arm64: dts: rockchip: add Coresight
 debug range for RK3399
Message-ID: <YYsV/OU47QlolwOx@sashalap>
References: <20211109221641.1233217-1-sashal@kernel.org>
 <20211109221641.1233217-17-sashal@kernel.org>
 <CA+ASDXNcC4_MpURRjbeXsyXsQ9Qte_YgoXFCJUKtrSWpZsHn-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+ASDXNcC4_MpURRjbeXsyXsQ9Qte_YgoXFCJUKtrSWpZsHn-g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 09, 2021 at 03:25:39PM -0800, Brian Norris wrote:
>On Tue, Nov 9, 2021 at 2:17 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Brian Norris <briannorris@chromium.org>
>>
>> [ Upstream commit 75dccea503b8e176ad044175e891d7bb291b6ba0 ]
>>
>> Per Documentation/devicetree/bindings/arm/coresight-cpu-debug.txt.
>>
>> This IP block can be used for sampling the PC of any given CPU, which is
>> useful in certain panic scenarios where you can't get the CPU to stop
>> cleanly (e.g., hard lockup).
>
>I don't understand why this is being backported to -stable. First of
>all, it won't work because it's missing dependencies (specifically,
>around the RK3399 clock driver). But even if it did, I don't see how
>this is a candidate for -stable.
>
>Methinks the AI has gone too far again.

Possibly.

We try to take patches that enable existing hardware (or hardware
features) where the logic is already in the kernel but it's missing
something like adding a new PCI ID or a quirk.

This also seems to happen with devicetree files which is why this patch
got pulled in.

I'll drop it if it depends on patches that didn't make it in. Thanks!

-- 
Thanks,
Sasha
