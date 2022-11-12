Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B587626900
	for <lists+stable@lfdr.de>; Sat, 12 Nov 2022 12:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiKLLCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Nov 2022 06:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiKLLCd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Nov 2022 06:02:33 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13296417
        for <stable@vger.kernel.org>; Sat, 12 Nov 2022 03:02:31 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q71so6323108pgq.8
        for <stable@vger.kernel.org>; Sat, 12 Nov 2022 03:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=omnom-net.20210112.gappssmtp.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uRlNK9v6BYkfzDBVtN23Yf6EGX8OrvceNQAFFo1GN2Q=;
        b=KjFmrMWk4QFSB5J9T4TOgfjUgkDlWccPEezxBTP7GmIO/2hIhnHricGN8PFVsr+/WR
         +Z8yeEtjn034aXfKfxOS6xkX90J27Vi8v/v2qnOy9iRKuG5hpdlKRGHzR+BbjO3l2BJm
         fNhcc/o/O2D9m5xvN3XTeKdo5RigGqpsFNSz2hbGZQEwazk+kfk1WppH4GZGBRF8UUhl
         KERSM1GYQwkO5HGh4NYDTwRxQGwoA9kKgTwT2+ylyL4ac4C3cgYMwa12LaZpPAJnvqt/
         aRYCpzbunBtIiDhyeFk2yrMtFYEgI1ts4+e6mtAE5WMe4vf+vV+9PLLe/i6uogwADHBJ
         vv1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uRlNK9v6BYkfzDBVtN23Yf6EGX8OrvceNQAFFo1GN2Q=;
        b=JlH2K7LK/Oosxft3K+Ny372D+4S4JQSEJvKhdkh2rhFxupBq8Xf9fjz5+oo28Ety03
         MHTRQXlpDY+VYOIRMMcRji90qR2qV5KL+sN0puMNWAjWLe4L/ynABxb5b2LPBlm9UPN1
         8sPz3Z0ewFjkYiA+/vNDZr33zUz1/jtCu94j5oEV8xhDlwE3yZYKcTxLgdW2m4nZ/1LV
         DbjxVByXAv+m7qA+vd0KLrIukONL3YBl97TiQ8DsAUg53VOYxEKgz3Lv7+reJeZZbqb9
         77qteI3Nz2TFZ74nupFa9hhL+jYQR6bnGxsCBldjkG5ymuw6U/fwtqprbV7AIqMeVXLR
         wTEQ==
X-Gm-Message-State: ANoB5pnUAJbLEoJGXivszOpIcwPbGFPKzaU/vYn6MAOdyXS8HMsoa2uw
        Q10Kaw4akbFH8FCEvTl3kRSn/5ga7zS0Q4O+DJIRQtNAVnpBHg==
X-Google-Smtp-Source: AA0mqf7/w5V/5krTDgLeaAHld4UR9cu/hHPmSsO+VkRiZI0E4yiWu0B1ujITPtWHcmM4aYkGLh29Uo7oNHb/NkzqD40=
X-Received: by 2002:a05:6a00:440b:b0:56d:9eed:61eb with SMTP id
 br11-20020a056a00440b00b0056d9eed61ebmr6566373pfb.4.1668250950910; Sat, 12
 Nov 2022 03:02:30 -0800 (PST)
MIME-Version: 1.0
References: <20221112103606.1595375-1-aholmes@omnom.net> <20221112103606.1595375-2-aholmes@omnom.net>
In-Reply-To: <20221112103606.1595375-2-aholmes@omnom.net>
From:   Andrew Holmes <aholmes@omnom.net>
Date:   Sat, 12 Nov 2022 22:02:19 +1100
Message-ID: <CA+v68iBKY0oMr6UT-vKwZ=PkerjqHgDfkQW3bAsi4GrkzFefzw@mail.gmail.com>
Subject: Re: [PATCH 1/1] arm64: dts: rockchip: rk356x: Fix PCIe register and
 range mappings
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please ignore, sent this by mistake. My bad.

On Sat, Nov 12, 2022 at 9:38 PM Andrew Powers-Holmes <aholmes@omnom.net> wrote:
>
> The register and range mappings for the PCIe controller in Rockchip's
> RK356x SoCs are incorrect. Replace them with corrected values from the
> vendor BSP sources, updated to match current DT schema.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrew Powers-Holmes <aholmes@omnom.net>
> ---
>  arch/arm64/boot/dts/rockchip/rk3568.dtsi | 14 ++++++++------
>  arch/arm64/boot/dts/rockchip/rk356x.dtsi |  7 ++++---
>  2 files changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
> index ba67b58f05b7..c1128d0c4406 100644
> --- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
> +++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
> @@ -94,9 +94,10 @@ pcie3x1: pcie@fe270000 {
>                 power-domains = <&power RK3568_PD_PIPE>;
>                 reg = <0x3 0xc0400000 0x0 0x00400000>,
>                       <0x0 0xfe270000 0x0 0x00010000>,
> -                     <0x3 0x7f000000 0x0 0x01000000>;
> -               ranges = <0x01000000 0x0 0x3ef00000 0x3 0x7ef00000 0x0 0x00100000>,
> -                        <0x02000000 0x0 0x00000000 0x3 0x40000000 0x0 0x3ef00000>;
> +                     <0x0 0xf2000000 0x0 0x00100000>;
> +               ranges = <0x01000000 0x0 0xf2100000 0x0 0xf2100000 0x0 0x00100000>,
> +                        <0x02000000 0x0 0xf2200000 0x0 0xf2200000 0x0 0x01e00000>,
> +                        <0x03000000 0x0 0x40000000 0x3 0x40000000 0x0 0x40000000>;
>                 reg-names = "dbi", "apb", "config";
>                 resets = <&cru SRST_PCIE30X1_POWERUP>;
>                 reset-names = "pipe";
> @@ -146,9 +147,10 @@ pcie3x2: pcie@fe280000 {
>                 power-domains = <&power RK3568_PD_PIPE>;
>                 reg = <0x3 0xc0800000 0x0 0x00400000>,
>                       <0x0 0xfe280000 0x0 0x00010000>,
> -                     <0x3 0xbf000000 0x0 0x01000000>;
> -               ranges = <0x01000000 0x0 0x3ef00000 0x3 0xbef00000 0x0 0x00100000>,
> -                        <0x02000000 0x0 0x00000000 0x3 0x80000000 0x0 0x3ef00000>;
> +                     <0x0 0xf2000000 0x0 0x01000000>;
> +               ranges = <0x01000000 0x0 0xf0100000 0x0 0xf0100000 0x0 0x00100000>,
> +                        <0x02000000 0x0 0xf0200000 0x0 0xf0200000 0x0 0x01e00000>,
> +                        <0x03000000 0x0 0x40000000 0x3 0x80000000 0x0 0x40000000>;
>                 reg-names = "dbi", "apb", "config";
>                 resets = <&cru SRST_PCIE30X2_POWERUP>;
>                 reset-names = "pipe";
> diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
> index 164708f1eb67..eec1d496c617 100644
> --- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
> +++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
> @@ -951,7 +951,7 @@ pcie2x1: pcie@fe260000 {
>                 compatible = "rockchip,rk3568-pcie";
>                 reg = <0x3 0xc0000000 0x0 0x00400000>,
>                       <0x0 0xfe260000 0x0 0x00010000>,
> -                     <0x3 0x3f000000 0x0 0x01000000>;
> +                     <0x0 0xf4000000 0x0 0x00100000>;
>                 reg-names = "dbi", "apb", "config";
>                 interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>,
>                              <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>,
> @@ -980,8 +980,9 @@ pcie2x1: pcie@fe260000 {
>                 phys = <&combphy2 PHY_TYPE_PCIE>;
>                 phy-names = "pcie-phy";
>                 power-domains = <&power RK3568_PD_PIPE>;
> -               ranges = <0x01000000 0x0 0x3ef00000 0x3 0x3ef00000 0x0 0x00100000
> -                         0x02000000 0x0 0x00000000 0x3 0x00000000 0x0 0x3ef00000>;
> +               ranges = <0x01000000 0x0 0xf4100000 0x0 0xf4100000 0x0 0x00100000>,
> +                        <0x02000000 0x0 0xf4200000 0x0 0xf4200000 0x0 0x01e00000>,
> +                        <0x03000000 0x0 0x40000000 0x3 0x00000000 0x0 0x40000000>;
>                 resets = <&cru SRST_PCIE20_POWERUP>;
>                 reset-names = "pipe";
>                 #address-cells = <3>;
> --
> 2.38.0
>
