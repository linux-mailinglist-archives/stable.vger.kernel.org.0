Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC002248CF6
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 19:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgHRRaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 13:30:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726715AbgHRRaQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 13:30:16 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E94C20658
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 17:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597771815;
        bh=sXmnP60QExctYC+E9tNphL2pFCDrWGarkkTPBt8qRAs=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=a0TOASz0JKvtvbe2xwukG/WQQncY+jowzrCwC3locufLtLXzomL0Ebkw1aZjdic3N
         +AONx+HCjDqkGQZxzO4esCiqi3P34G9slDtBbh3FRHyxiok8/MWb5eIgk0IpFfR/4k
         FFjgponMJwhqApbJubu6n+25ZgpHTttv5KGYKF4c=
Received: by pali.im (Postfix)
        id D387CEF5; Tue, 18 Aug 2020 19:30:13 +0200 (CEST)
Date:   Tue, 18 Aug 2020 19:30:13 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     stable@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: marvell: espressobin: add ethernet alias
Message-ID: <20200818173013.n6pgdvawy5dyekz6@pali>
References: <20200805094333.12503-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200805094333.12503-1-pali@kernel.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday 05 August 2020 11:43:33 Pali Rohár wrote:
> From: Tomasz Maciej Nowak <tmn505@gmail.com>
> 
> commit 5253cb8c00a6f4356760efb38bca0e0393aa06de upstream.
> 
> The maker of this board and its variants, stores MAC address in U-Boot
> environment. Add alias for bootloader to recognise, to which ethernet
> node inject the factory MAC address.
> 
> Signed-off-by: Tomasz Maciej Nowak <tmn505@gmail.com>
> Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
> [pali: Backported to 5.4 and older versions]
> Signed-off-by: Pali Rohár <pali@kernel.org>

Hello! I should have been more explicit, that this patch is backport for
stable releases: 5.4 4.19 4.14

> ---
>  arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
> index fbcf03f86c96..05dc58c13fa4 100644
> --- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
> +++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
> @@ -19,6 +19,12 @@
>  	model = "Globalscale Marvell ESPRESSOBin Board";
>  	compatible = "globalscale,espressobin", "marvell,armada3720", "marvell,armada3710";
>  
> +	aliases {
> +		ethernet0 = &eth0;
> +		serial0 = &uart0;
> +		serial1 = &uart1;
> +	};
> +
>  	chosen {
>  		stdout-path = "serial0:115200n8";
>  	};
> -- 
> 2.20.1
> 
