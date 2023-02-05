Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF65868B0E6
	for <lists+stable@lfdr.de>; Sun,  5 Feb 2023 17:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBEQTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Feb 2023 11:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBEQTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Feb 2023 11:19:45 -0500
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEF5386A8;
        Sun,  5 Feb 2023 08:19:44 -0800 (PST)
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1pOhjy-0000RS-01; Sun, 05 Feb 2023 17:19:42 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 2C46FC265A; Sun,  5 Feb 2023 17:02:50 +0100 (CET)
Date:   Sun, 5 Feb 2023 17:02:50 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?utf-8?B?5ZGo55Cw5p2w?= <zhouyanjie@wanyeetech.com>,
        linux-mips@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] MIPS: DTS: CI20: fix otg power gpio
Message-ID: <20230205160250.GB4459@alpha.franken.de>
References: <8bcf9311284b4cab8be36922d6027813bfdf2bae.1675018624.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bcf9311284b4cab8be36922d6027813bfdf2bae.1675018624.git.hns@goldelico.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 29, 2023 at 07:57:04PM +0100, H. Nikolaus Schaller wrote:
> According to schematics it is PF15 and not PF14 (MIC_SW_EN).
> Seems as if it was hidden and not noticed during testing since
> there is no sound DT node.
> 
> Fixes: 158c774d3c64 ("MIPS: Ingenic: Add missing nodes for Ingenic SoCs and boards.")
> Cc: stable@vger.kernel.org
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> Acked-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  arch/mips/boot/dts/ingenic/ci20.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/mips/boot/dts/ingenic/ci20.dts b/arch/mips/boot/dts/ingenic/ci20.dts
> index 9819abb2465dd..a276488c0f752 100644
> --- a/arch/mips/boot/dts/ingenic/ci20.dts
> +++ b/arch/mips/boot/dts/ingenic/ci20.dts
> @@ -115,7 +115,7 @@ otg_power: fixedregulator@2 {
>  		regulator-min-microvolt = <5000000>;
>  		regulator-max-microvolt = <5000000>;
>  
> -		gpio = <&gpf 14 GPIO_ACTIVE_LOW>;
> +		gpio = <&gpf 15 GPIO_ACTIVE_LOW>;
>  		enable-active-high;
>  	};
>  };
> -- 
> 2.38.1

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
