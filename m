Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F856E8CD8
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 10:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbjDTIeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 04:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbjDTIeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 04:34:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEA649FF;
        Thu, 20 Apr 2023 01:34:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69ADE64604;
        Thu, 20 Apr 2023 08:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC7CC433D2;
        Thu, 20 Apr 2023 08:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681979639;
        bh=p68YF0iYq39u8mcdb3L4PElD/b/BAr1fk8jEY+LKNmA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q3jLy97NWxsjnm7tzijQqGdWwjoWjWEWXhQHVCKCO/TQpjkSg6xTh0ivIJ1B0Cq6Z
         VeBxDNSNQVI+9HYXp1/sslS8ZdFYK9B3o1Pt/1DFNgX5MDyiKYJLKM36uDW4cZPFO7
         UAHnm9Z0SiJD9DGz6HiaLpZHyh/+pSYvijQkPnbVddCn1k/Ej3pwXn2lzt2i8Ph9l1
         VBWNi6n9GwTzT2cKEQC4jZLp5C+aYUtNtCslWBIiuij8AQbKe9bgNB91qih/nRM2lx
         dpoRLMKo1KlqxylmoqdEKNUY/rLY5BrqPh90UaQM2lx2RsP2phAYp4UYsPcwtaQXjS
         oKk6wVpnTytgg==
Date:   Thu, 20 Apr 2023 14:03:45 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: qcom: ipq4019: fix broken NAND controller
 properties override
Message-ID: <20230420083345.GC6308@thinkpad>
References: <20230420072811.36947-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230420072811.36947-1-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 20, 2023 at 09:28:11AM +0200, Krzysztof Kozlowski wrote:
> After renaming NAND controller node name from "qpic-nand" to
> "nand-controller", the board DTS/DTSI also have to be updated:
> 
>   Warning (unit_address_vs_reg): /soc/qpic-nand@79b0000: node has a unit name, but no reg or ranges property
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 9e1e00f18afc ("ARM: dts: qcom: Fix node name for NAND controller node")
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
>  arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1-c1.dts |  8 ++++----
>  arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1.dtsi   | 10 +++++-----
>  arch/arm/boot/dts/qcom-ipq4019-ap.dk07.1.dtsi   | 12 ++++++------
>  3 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1-c1.dts b/arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1-c1.dts
> index 79b0c6318e52..0993f840d1fc 100644
> --- a/arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1-c1.dts
> +++ b/arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1-c1.dts
> @@ -11,9 +11,9 @@ soc {
>  		dma-controller@7984000 {
>  			status = "okay";
>  		};
> -
> -		qpic-nand@79b0000 {
> -			status = "okay";
> -		};
>  	};
>  };
> +
> +&nand {
> +	status = "okay";
> +};
> diff --git a/arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1.dtsi b/arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1.dtsi
> index a63b3778636d..468ebc40d2ad 100644
> --- a/arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1.dtsi
> +++ b/arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1.dtsi
> @@ -102,10 +102,10 @@ pci@40000000 {
>  			status = "okay";
>  			perst-gpios = <&tlmm 38 GPIO_ACTIVE_LOW>;
>  		};
> -
> -		qpic-nand@79b0000 {
> -			pinctrl-0 = <&nand_pins>;
> -			pinctrl-names = "default";
> -		};
>  	};
>  };
> +
> +&nand {
> +	pinctrl-0 = <&nand_pins>;
> +	pinctrl-names = "default";
> +};
> diff --git a/arch/arm/boot/dts/qcom-ipq4019-ap.dk07.1.dtsi b/arch/arm/boot/dts/qcom-ipq4019-ap.dk07.1.dtsi
> index 0107f552f520..7ef635997efa 100644
> --- a/arch/arm/boot/dts/qcom-ipq4019-ap.dk07.1.dtsi
> +++ b/arch/arm/boot/dts/qcom-ipq4019-ap.dk07.1.dtsi
> @@ -65,11 +65,11 @@ i2c@78b7000 { /* BLSP1 QUP2 */
>  		dma-controller@7984000 {
>  			status = "okay";
>  		};
> -
> -		qpic-nand@79b0000 {
> -			pinctrl-0 = <&nand_pins>;
> -			pinctrl-names = "default";
> -			status = "okay";
> -		};
>  	};
>  };
> +
> +&nand {
> +	pinctrl-0 = <&nand_pins>;
> +	pinctrl-names = "default";
> +	status = "okay";
> +};
> -- 
> 2.34.1
> 

-- 
மணிவண்ணன் சதாசிவம்
