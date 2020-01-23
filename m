Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EECE0146B06
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 15:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgAWOTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 09:19:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbgAWOTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 09:19:32 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E94720718;
        Thu, 23 Jan 2020 14:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579789171;
        bh=7Ehhr3RcKJp5rNbXCW0vgv3MFQ61Ixyk+/w7br8QJmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ck30PxMR219a4zqfvKd4pZH/W0pXpeM6HsUMaSYrapQJaqTeQ74QBD6nwm7Cx6YTj
         vffmkdId3V46x6gVqqZsYjuA8Gg84SIiF/EpOErte7d8xjV0Qce8UKgD7FSYUKaXj7
         Lkcta7GlBVGkGWU6j1FiBYhe4TisWB9piXZMdSz0=
Date:   Thu, 23 Jan 2020 09:19:30 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Biju Das <biju.das@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 104/671] ARM: dts: r8a7743: Fix sorting of
 rwdt node
Message-ID: <20200123141930.GD1706@sasha-vm>
References: <20200116165502.8838-1-sashal@kernel.org>
 <20200116165502.8838-104-sashal@kernel.org>
 <3a84e4dc-1d2a-3809-ffac-33d75eb73351@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3a84e4dc-1d2a-3809-ffac-33d75eb73351@cogentembedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 12:32:21PM +0300, Sergei Shtylyov wrote:
>Hello!
>
>On 16.01.2020 19:45, Sasha Levin wrote:
>
>>From: Biju Das <biju.das@bp.renesas.com>
>>
>>[ Upstream commit 383f6024981d32425fa453bf2e66b546fdbc1314 ]
>>
>>Watchdog node is incorrectly placed on r8a7743 SoC dtsi. This patch fixes
>>the sorting order.
>>
>>Fixes: b5beb5d4c81c358f50a8310108 ("ARM: dts: r8a7743: Add watchdog support to SoC dtsi")
>>
>>Signed-off-by: Biju Das <biju.das@bp.renesas.com>
>>Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
>>Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>>  arch/arm/boot/dts/r8a7743.dtsi | 20 ++++++++++----------
>>  1 file changed, 10 insertions(+), 10 deletions(-)
>
>   I doubt that the DT node reordering is worth merging into the 
>-stable kernels...

You're right, I'll drop it. Thanks!

-- 
Thanks,
Sasha
