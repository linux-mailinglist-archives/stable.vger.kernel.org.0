Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F44318011B
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 16:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgCJPFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 11:05:30 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33464 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbgCJPFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 11:05:30 -0400
Received: by mail-lf1-f67.google.com with SMTP id c20so11215105lfb.0;
        Tue, 10 Mar 2020 08:05:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nGs6hNqIdCNeRbR5vUCyvgx5+Q9Q66N8OBeVEgAnrAo=;
        b=YCyUIV9Q7xxrdvOWcvzdslVEUn4OFNxn1gTLd2E1kWyWcNPwu3rm/rOtfXC9o8it+i
         Rey0HdO0C4LyFCe180L7brR+BP+YlGc0E+8v5cksNpxvL7tTjw6UT5uAaUqzP6MZFbo1
         cw5pPoCESwbHoS8YxKfSdg1nOJ1Q2sIRnwGRq2LJRHNww1c45pkiuc9ri5/Od4AJoWgf
         MQoUwsJOHi8E2rFVXqvhR48ChdX7cNFh/iuqQUhsGy+82UL6M+yQXg0yCyRWa2PUvZmw
         zHsFzKl8QuYdhUD1j63fBjqKgZ2atR9tNKSVTGVxqw2r42vL1+kdQOBg/AlCIIDwCIel
         hWeg==
X-Gm-Message-State: ANhLgQ122CQ0tiVDb45EJFD5AVIUXVogO8YpXWQypIYDwgD8Z1zYl5r7
        RgxoXb8ovgMfUXRjUbWsdpkKa3R2
X-Google-Smtp-Source: ADFU+vuBuM4zPc/6wYuFhHAnHTBcjlbbclKIPzGOiq3dwQLxr19m44rbYxz59tNcMVyLb1U1skDWtw==
X-Received: by 2002:a19:c20d:: with SMTP id l13mr7592026lfc.167.1583852727741;
        Tue, 10 Mar 2020 08:05:27 -0700 (PDT)
Received: from xi.terra (c-12aae455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.170.18])
        by smtp.gmail.com with ESMTPSA id w9sm8962394ljm.41.2020.03.10.08.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:05:27 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1jBgRU-0003Cj-Ko; Tue, 10 Mar 2020 16:05:12 +0100
Date:   Tue, 10 Mar 2020 16:05:12 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Subject: Re: [PATCH 5.5 175/189] ARM: dts: imx6dl-colibri-eval-v3: fix sram
 compatible properties
Message-ID: <20200310150512.GC14211@localhost>
References: <20200310123639.608886314@linuxfoundation.org>
 <20200310123657.443556491@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310123657.443556491@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 01:40:12PM +0100, Greg Kroah-Hartman wrote:
> From: Johan Hovold <johan@kernel.org>
> 
> commit bcbf53a0dab50980867476994f6079c1ec5bb3a3 upstream.
> 
> The sram-node compatible properties have mistakingly combined the
> model-specific string with the generic "mtd-ram" string.
> 
> Note that neither "cy7c1019dv33-10zsxi, mtd-ram" or
> "cy7c1019dv33-10zsxi" are used by any in-kernel driver and they are
> not present in any binding.
> 
> The physmap driver will however bind to platform devices that specify
> "mtd-ram".
> 
> Fixes: fc48e76489fd ("ARM: dts: imx6: Add support for Toradex Colibri iMX6 module")
> Cc: Sanchayan Maity <maitysanchayan@gmail.com>
> Cc: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> Cc: Shawn Guo <shawnguo@kernel.org>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Reviewed-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
> Signed-off-by: Shawn Guo <shawnguo@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This was never meant to go into stable so I didn't add a stable CC-tag.

It causes a driver to bind to the corresponding platform devices, which
have so far been unbound and may therefore have unwanted side-effects.

I don't think it's stable material either way.

> ---
>  arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts
> +++ b/arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts
> @@ -275,7 +275,7 @@
>  
>  	/* SRAM on Colibri nEXT_CS0 */
>  	sram@0,0 {
> -		compatible = "cypress,cy7c1019dv33-10zsxi, mtd-ram";
> +		compatible = "cypress,cy7c1019dv33-10zsxi", "mtd-ram";
>  		reg = <0 0 0x00010000>;
>  		#address-cells = <1>;
>  		#size-cells = <1>;
> @@ -286,7 +286,7 @@
>  
>  	/* SRAM on Colibri nEXT_CS1 */
>  	sram@1,0 {
> -		compatible = "cypress,cy7c1019dv33-10zsxi, mtd-ram";
> +		compatible = "cypress,cy7c1019dv33-10zsxi", "mtd-ram";
>  		reg = <1 0 0x00010000>;
>  		#address-cells = <1>;
>  		#size-cells = <1>;
> 
> 

Johan
