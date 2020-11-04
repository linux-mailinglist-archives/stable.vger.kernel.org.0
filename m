Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504592A6191
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 11:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgKDK2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 05:28:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728841AbgKDK0n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 05:26:43 -0500
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF42020575;
        Wed,  4 Nov 2020 10:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604485601;
        bh=UmOoL2Hb9vp3rGiBuREXf8R7LGokFPjaEuDxJEW4zp4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2ZTT6V1CyRiQRN7OpLeL007v2xCA9A4g1ADinyDXyWPkv3J8ncsv4RMWmRvCMg9em
         n3eGDwEz2fj49/IxbHP9MLZGUz0hfd2OpeTYFB+QfgXxnG9l81+ru02ZJ8KssPLHUK
         XmyCNwn6FJm1NDmxR1M9M0b1+NJIRAUSmRq3yAL0=
Received: by pali.im (Postfix)
        id 1A06664E; Wed,  4 Nov 2020 11:26:39 +0100 (CET)
Date:   Wed, 4 Nov 2020 11:26:38 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     a.heider@gmail.com, andrew@lunn.ch, gregory.clement@bootlin.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: dts: marvell: espressobin: Add
 ethernet switch aliases" failed to apply to 5.4-stable tree
Message-ID: <20201104102638.6hpelqhcnkzy5juh@pali>
References: <160443111019694@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <160443111019694@kroah.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday 03 November 2020 20:18:30 gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Hello Greg! I will do it.

> ------------------ original commit in Linus's tree ------------------
> 
> From b64d814257b027e29a474bcd660f6372490138c7 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
> Date: Mon, 7 Sep 2020 13:27:17 +0200
> Subject: [PATCH] arm64: dts: marvell: espressobin: Add ethernet switch aliases
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Espressobin boards have 3 ethernet ports and some of them got assigned more
> then one MAC address. MAC addresses are stored in U-Boot environment.
> 
> Since commit a2c7023f7075c ("net: dsa: read mac address from DT for slave
> device") kernel can use MAC addresses from DT for particular DSA port.
> 
> Currently Espressobin DTS file contains alias just for ethernet0.
> 
> This patch defines additional ethernet aliases in Espressobin DTS files, so
> bootloader can fill correct MAC address for DSA switch ports if more MAC
> addresses were specified.
> 
> DT alias ethernet1 is used for wan port, DT aliases ethernet2 and ethernet3
> are used for lan ports for both Espressobin revisions (V5 and V7).
> 
> Fixes: 5253cb8c00a6f ("arm64: dts: marvell: espressobin: add ethernet alias")
> Cc: <stable@vger.kernel.org> # a2c7023f7075c: dsa: read mac address
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Andre Heider <a.heider@gmail.com>
> Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
> 
> diff --git a/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7-emmc.dts b/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7-emmc.dts
> index 03733fd92732..215d2f702623 100644
> --- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7-emmc.dts
> +++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7-emmc.dts
> @@ -20,17 +20,23 @@ / {
>  	compatible = "globalscale,espressobin-v7-emmc", "globalscale,espressobin-v7",
>  		     "globalscale,espressobin", "marvell,armada3720",
>  		     "marvell,armada3710";
> +
> +	aliases {
> +		/* ethernet1 is wan port */
> +		ethernet1 = &switch0port3;
> +		ethernet3 = &switch0port1;
> +	};
>  };
>  
>  &switch0 {
>  	ports {
> -		port@1 {
> +		switch0port1: port@1 {
>  			reg = <1>;
>  			label = "lan1";
>  			phy-handle = <&switch0phy0>;
>  		};
>  
> -		port@3 {
> +		switch0port3: port@3 {
>  			reg = <3>;
>  			label = "wan";
>  			phy-handle = <&switch0phy2>;
> diff --git a/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7.dts b/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7.dts
> index 8570c5f47d7d..b6f4af8ebafb 100644
> --- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7.dts
> +++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7.dts
> @@ -19,17 +19,23 @@ / {
>  	model = "Globalscale Marvell ESPRESSOBin Board V7";
>  	compatible = "globalscale,espressobin-v7", "globalscale,espressobin",
>  		     "marvell,armada3720", "marvell,armada3710";
> +
> +	aliases {
> +		/* ethernet1 is wan port */
> +		ethernet1 = &switch0port3;
> +		ethernet3 = &switch0port1;
> +	};
>  };
>  
>  &switch0 {
>  	ports {
> -		port@1 {
> +		switch0port1: port@1 {
>  			reg = <1>;
>  			label = "lan1";
>  			phy-handle = <&switch0phy0>;
>  		};
>  
> -		port@3 {
> +		switch0port3: port@3 {
>  			reg = <3>;
>  			label = "wan";
>  			phy-handle = <&switch0phy2>;
> diff --git a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi
> index b97218c72727..0775c16e0ec8 100644
> --- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi
> +++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi
> @@ -13,6 +13,10 @@
>  / {
>  	aliases {
>  		ethernet0 = &eth0;
> +		/* for dsa slave device */
> +		ethernet1 = &switch0port1;
> +		ethernet2 = &switch0port2;
> +		ethernet3 = &switch0port3;
>  		serial0 = &uart0;
>  		serial1 = &uart1;
>  	};
> @@ -120,7 +124,7 @@ ports {
>  			#address-cells = <1>;
>  			#size-cells = <0>;
>  
> -			port@0 {
> +			switch0port0: port@0 {
>  				reg = <0>;
>  				label = "cpu";
>  				ethernet = <&eth0>;
> @@ -131,19 +135,19 @@ fixed-link {
>  				};
>  			};
>  
> -			port@1 {
> +			switch0port1: port@1 {
>  				reg = <1>;
>  				label = "wan";
>  				phy-handle = <&switch0phy0>;
>  			};
>  
> -			port@2 {
> +			switch0port2: port@2 {
>  				reg = <2>;
>  				label = "lan0";
>  				phy-handle = <&switch0phy1>;
>  			};
>  
> -			port@3 {
> +			switch0port3: port@3 {
>  				reg = <3>;
>  				label = "lan1";
>  				phy-handle = <&switch0phy2>;
> 
