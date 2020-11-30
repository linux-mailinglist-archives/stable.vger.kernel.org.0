Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921C42C86ED
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 15:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgK3Ohm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 09:37:42 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:55627 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgK3Ohm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 09:37:42 -0500
Received: from localhost (91-175-115-186.subs.proxad.net [91.175.115.186])
        (Authenticated sender: gregory.clement@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 55CA5240019;
        Mon, 30 Nov 2020 14:36:58 +0000 (UTC)
From:   Gregory CLEMENT <gregory.clement@bootlin.com>
To:     Tomasz Nowicki <tn@semihalf.com>, will@kernel.org,
        robin.murphy@arm.com, joro@8bytes.org, robh+dt@kernel.org,
        hannah@marvell.com
Cc:     linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        devicetree@vger.kernel.org, catalin.marinas@arm.com,
        nadavh@marvell.com, linux-arm-kernel@lists.infradead.org,
        mw@semihalf.com, d.odintsov@traviangames.com,
        stable@vger.kernel.org, Tomasz Nowicki <tn@semihalf.com>
Subject: Re: [PATCH 1/1] arm64: dts: marvell: keep SMMU disabled by default
 for Armada 7040 and 8040
In-Reply-To: <20201105112602.164739-1-tn@semihalf.com>
References: <20201105112602.164739-1-tn@semihalf.com>
Date:   Mon, 30 Nov 2020 15:36:57 +0100
Message-ID: <87tut6j4hi.fsf@BL-laptop>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> FW has to configure devices' StreamIDs so that SMMU is able to lookup
> context and do proper translation later on. For Armada 7040 & 8040 and
> publicly available FW, most of the devices are configured properly,
> but some like ap_sdhci0, PCIe, NIC still remain unassigned which
> results in SMMU faults about unmatched StreamID (assuming
> ARM_SMMU_DISABLE_BYPASS_BY_DEFAUL=y).
>
> Since there is dependency on custom FW let SMMU be disabled by default.
> People who still willing to use SMMU need to enable manually and
> use ARM_SMMU_DISABLE_BYPASS_BY_DEFAUL=n (or via kernel command line)
> with extra caution.
>
> Fixes: 83a3545d9c37 ("arm64: dts: marvell: add SMMU support")
> Cc: <stable@vger.kernel.org> # 5.9+
> Signed-off-by: Tomasz Nowicki <tn@semihalf.com>


Applied on mvebu/dt64

Thanks,

Gregory

> ---
>  arch/arm64/boot/dts/marvell/armada-7040.dtsi | 4 ----
>  arch/arm64/boot/dts/marvell/armada-8040.dtsi | 4 ----
>  2 files changed, 8 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/marvell/armada-7040.dtsi b/arch/arm64/boot/dts/marvell/armada-7040.dtsi
> index 7a3198cd7a07..2f440711d21d 100644
> --- a/arch/arm64/boot/dts/marvell/armada-7040.dtsi
> +++ b/arch/arm64/boot/dts/marvell/armada-7040.dtsi
> @@ -15,10 +15,6 @@ / {
>  		     "marvell,armada-ap806";
>  };
>  
> -&smmu {
> -	status = "okay";
> -};
> -
>  &cp0_pcie0 {
>  	iommu-map =
>  		<0x0   &smmu 0x480 0x20>,
> diff --git a/arch/arm64/boot/dts/marvell/armada-8040.dtsi b/arch/arm64/boot/dts/marvell/armada-8040.dtsi
> index 79e8ce59baa8..22c2d6ebf381 100644
> --- a/arch/arm64/boot/dts/marvell/armada-8040.dtsi
> +++ b/arch/arm64/boot/dts/marvell/armada-8040.dtsi
> @@ -15,10 +15,6 @@ / {
>  		     "marvell,armada-ap806";
>  };
>  
> -&smmu {
> -	status = "okay";
> -};
> -
>  &cp0_pcie0 {
>  	iommu-map =
>  		<0x0   &smmu 0x480 0x20>,
> -- 
> 2.25.1
>

-- 
Gregory Clement, Bootlin
Embedded Linux and Kernel engineering
http://bootlin.com
