Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F97A30955E
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 14:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhA3Nbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 08:31:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhA3Nbx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 08:31:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5915764E0C;
        Sat, 30 Jan 2021 13:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612013471;
        bh=BFAHtHR5IFSLTOfNrxRmKhi6iRXq1wz2DrzkLLluFxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HgwQyuW7yTnQCp4+WQ87tIBxNotWkHLmm2DqdvgDrMEn9d5fRoGcgHPElh+ycik64
         vCpwab319PeBFwQVAjBK1zxJPW9brnMMOtZFOXJei763bBsHKqEC0q4O7CAtHBfxho
         DRtiPA98ZNP/AbdkS4jwogGDdMzIvDwVVVl8VYRkzQluPk9kMMbreqgylZ3I/bFfdY
         6kiGlK9eHWW7adDaoMWIkbIF2OvVagWbQKFCIzMl3qEuGFmZeT19jj9SWUxm2wYPZy
         ujbMW1x5fs0JWqMNgU61pVzHZgScl44xG6Zams91PFj0h8hstHpwpFzO9CVaTr5zdZ
         WFYghVAWZ0ASw==
Date:   Sat, 30 Jan 2021 21:31:06 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Zyta Szpak <zr@semihalf.com>
Cc:     leoyang.li@nxp.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: freescale: fix dcfg address range
Message-ID: <20210130133106.GI907@dragon>
References: <20210121155237.15517-1-zr@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121155237.15517-1-zr@semihalf.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 21, 2021 at 04:52:37PM +0100, Zyta Szpak wrote:
> Dcfg was overlapping with clockgen address space which resulted
> in failure in memory allocation for dcfg. According regs description
> dcfg size should not be bigger than 4KB.
> 
> Signed-off-by: Zyta Szpak <zr@semihalf.com>

I changed subject prefix to 'arm64: dts: ls1046a: ...', and applied the
patch with Fixes tag below.

Fixes: 8126d88162a5 ("arm64: dts: add QorIQ LS1046A SoC support")

Shawn

> ---
>  arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
> index 025e1f587662..565934cbfa28 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
> @@ -385,7 +385,7 @@
>  
>  		dcfg: dcfg@1ee0000 {
>  			compatible = "fsl,ls1046a-dcfg", "syscon";
> -			reg = <0x0 0x1ee0000 0x0 0x10000>;
> +			reg = <0x0 0x1ee0000 0x0 0x1000>;
>  			big-endian;
>  		};
>  
> -- 
> 2.17.1
> 
