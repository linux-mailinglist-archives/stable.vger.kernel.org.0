Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7527E2A3F62
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 09:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgKCIzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 03:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgKCIzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 03:55:36 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18176C0617A6
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 00:55:35 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id 205so4197479wma.4
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 00:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:autocrypt:organization:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kuYtgCpIKch8L3KdMYqCnVDWB/+/69UJrXOkwHI9/a8=;
        b=PO9nvJP5d9o/g7+8Usmpy1ldpGR3/BVgq+/D9Vg7awdpKYmbFt2QSD3HS0oeA8Vdmt
         PGBC0ZdHfdkWTiNzR/jQWgm5Ciq7zZNx2E3GCJFDyj9QBwm6Qsl+XnNr/0y3mepHanTX
         rX40wYLNWSFc04CrCDdhfbCH5mSjG1Hyr7hcTknWr+WWFW/sVB3mTPgkSJwathU+vG7m
         194oKsC6yyF5jKguAG1kisFnlmm2uxbsDIEo/A0gDfhGIa9tjI90gckwfObwowVe9n4P
         sth+3t8++cjus7RLysEOXAJv+eTVkCyO9bnYc+Vla1Un3954Duy3LR8Tax8ikkrnTUoA
         Xprg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kuYtgCpIKch8L3KdMYqCnVDWB/+/69UJrXOkwHI9/a8=;
        b=KNSyFKpE7P2f5iTFAqwyMaqhE3aB7db4dFJOjQFu9JM5Q/5kRPVcP1ahRlvipWVfEb
         iV55cUGA1XyMZYrcZRSKfWHO1drECIKDarQJdGPEOUnWn469hRTMnLzgfRgmXul/+8Ft
         vXCbrnXRjsQFA6HTKH4ZP7hpLPWnht5ws4z1qQfhtuIG3e2m5Q9741nw84dPayNj6/kX
         Cx4shqgz8mqIgdIjE5aD8Mkc2BtP3IgsfFRSnTSG7vZtg51T5DQlVR7iEp2ylD8SoBex
         YyglFCUy69DjW7npzPQazRC6JpF3uTEwC9/jlz9jZuDDgxbJSZRS5U4dcOffwZwX3S+X
         JYrw==
X-Gm-Message-State: AOAM531xZHQRTMBC5UL+/TxJULTxGG18E3OdLOgoS7P6guth9ayTZdSn
        UgwSwO66bVxx6gwb/iZ94sv5+ld3aavY/VCO
X-Google-Smtp-Source: ABdhPJyRi4bNNlz1RWZnfyvpWtdQzso7c9176gkHynUg3N3j3iHMDYxx3ufibQCDbV214nsMsgI67w==
X-Received: by 2002:a1c:c906:: with SMTP id f6mr2514741wmb.9.1604393733604;
        Tue, 03 Nov 2020 00:55:33 -0800 (PST)
Received: from ?IPv6:2a01:e35:2ec0:82b0:3d8d:fb08:21c9:faa3? ([2a01:e35:2ec0:82b0:3d8d:fb08:21c9:faa3])
        by smtp.gmail.com with ESMTPSA id t19sm2332982wmi.26.2020.11.03.00.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 00:55:32 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 5.4 02/24] arm64: dts: meson-axg: add USB nodes
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
References: <20201103012007.183429-1-sashal@kernel.org>
 <20201103012007.183429-2-sashal@kernel.org>
From:   Neil Armstrong <narmstrong@baylibre.com>
Autocrypt: addr=narmstrong@baylibre.com; prefer-encrypt=mutual; keydata=
 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
 ZaTUOEkgIor5losDrePdPgE=
Organization: Baylibre
Message-ID: <454088be-6ff1-4fae-e0e3-a26211001d20@baylibre.com>
Date:   Tue, 3 Nov 2020 09:55:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201103012007.183429-2-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/11/2020 02:19, Sasha Levin wrote:
> From: Neil Armstrong <narmstrong@baylibre.com>
> 
> [ Upstream commit 1b208bab34dc3f4ef8f408105017d4a7b72b2a2f ]
> 
> This adds the USB Glue node, with the USB2 & USB3 controllers along the single
> USB2 PHY node.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> Reviewed-by: Kevin Hilman <khilman@baylibre.com>
> Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 50 ++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
> index 502c4ac45c29e..af1c50428eb7e 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
> @@ -170,6 +170,46 @@ soc {
>  		#size-cells = <2>;
>  		ranges;
>  
> +		usb: usb@ffe09080 {
> +			compatible = "amlogic,meson-axg-usb-ctrl";
> +			reg = <0x0 0xffe09080 0x0 0x20>;
> +			interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
> +			#address-cells = <2>;
> +			#size-cells = <2>;
> +			ranges;
> +
> +			clocks = <&clkc CLKID_USB>, <&clkc CLKID_USB1_DDR_BRIDGE>;
> +			clock-names = "usb_ctrl", "ddr";
> +			resets = <&reset RESET_USB_OTG>;
> +
> +			dr_mode = "otg";
> +
> +			phys = <&usb2_phy1>;
> +			phy-names = "usb2-phy1";
> +
> +			dwc2: usb@ff400000 {
> +				compatible = "amlogic,meson-g12a-usb", "snps,dwc2";
> +				reg = <0x0 0xff400000 0x0 0x40000>;
> +				interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&clkc CLKID_USB1>;
> +				clock-names = "otg";
> +				phys = <&usb2_phy1>;
> +				dr_mode = "peripheral";
> +				g-rx-fifo-size = <192>;
> +				g-np-tx-fifo-size = <128>;
> +				g-tx-fifo-size = <128 128 16 16 16>;
> +			};
> +
> +			dwc3: usb@ff500000 {
> +				compatible = "snps,dwc3";
> +				reg = <0x0 0xff500000 0x0 0x100000>;
> +				interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
> +				dr_mode = "host";
> +				maximum-speed = "high-speed";
> +				snps,dis_u2_susphy_quirk;
> +			};
> +		};
> +
>  		ethmac: ethernet@ff3f0000 {
>  			compatible = "amlogic,meson-axg-dwmac",
>  				     "snps,dwmac-3.70a",
> @@ -1725,6 +1765,16 @@ sd_emmc_c: mmc@7000 {
>  				clock-names = "core", "clkin0", "clkin1";
>  				resets = <&reset RESET_SD_EMMC_C>;
>  			};
> +
> +			usb2_phy1: phy@9020 {
> +				compatible = "amlogic,meson-gxl-usb2-phy";
> +				#phy-cells = <0>;
> +				reg = <0x0 0x9020 0x0 0x20>;
> +				clocks = <&clkc CLKID_USB>;
> +				clock-names = "phy";
> +				resets = <&reset RESET_USB_OTG>;
> +				reset-names = "phy";
> +			};
>  		};
>  
>  		sram: sram@fffc0000 {
> 


Hi Sasha,

This needs also support in the dwc3-meson-g12a driver, you can drop it from backport.

Neil
