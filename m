Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57958604BC0
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 17:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiJSPjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 11:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbiJSPi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 11:38:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C49F1413AE;
        Wed, 19 Oct 2022 08:35:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE612617FF;
        Wed, 19 Oct 2022 15:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188A4C433D6;
        Wed, 19 Oct 2022 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666193602;
        bh=ZPiWXUi4EGYIEvCjOtZPl2msSfor/5aoQvmfCkr+4WI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NPkVm96Ik3Lq6PN0VKNU0YpxOi2RfgWWj9zozWANg2NHKfyVWVWwzBRJ+A+j/dNGx
         +lg/xBSl9bILedVIaKleidfWZjuk1/+U9A224bt7zU36qB01jq5iPeZC+qIdwPSxlW
         jlHbevQSg5IlJfrokCJYvi2FRe/Kug1JCy8WQc3Hu5W0DKEdWc879P41u1F+kmvIyr
         OsmrsodmVFkqIUnj8JDofBWGweOGbCvFW3jy7BD/nH++yxV9h5yEn+6FybHyjeS+AY
         Q1V1TBRr/MOnyEVU6qkX2TE73zo4C16T3FfTJr4y9KV+9fS+VzSl8pYAZs0fBLzU+l
         0NBpfcD68JFjA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1olB49-0003jN-Ol; Wed, 19 Oct 2022 17:33:10 +0200
Date:   Wed, 19 Oct 2022 17:33:09 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 438/862] arm64: dts: qcom: sc8280xp-pmics: Remove reg
 entry & use correct node name for pmc8280c_lpg node
Message-ID: <Y1AYtZVc5b7L+9Pj@hovoldconsulting.com>
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083309.338035619@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019083309.338035619@linuxfoundation.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 10:28:45AM +0200, Greg Kroah-Hartman wrote:
> From: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> 
> [ Upstream commit 7dac7991408f77b0b33ee5e6b729baa683889277 ]
> 
> Commit eeca7d46217c ("arm64: dts: qcom: pm8350c: Drop PWM reg declaration")
> dropped PWM reg declaration for pm8350c pwm(s), but there is a leftover
> 'reg' entry inside the lpg/pwm node in sc8280xp dts file. Remove the same.
> 
> While at it, also remove the unused unit address in the node
> label.
> 
> Also, since dt-bindings expect LPG/PWM node name to be "pwm",
> use correct node name as well, to fix the following
> error reported by 'make dtbs_check':
> 
>   'lpg' does not match any of the regexes
> 
> Fixes: eeca7d46217c ("arm64: dts: qcom: pm8350c: Drop PWM reg declaration")

Despite the Fixes tag, this is not a bug a fix but rather a cleanup for
compliance with the DT schema (for which there are thousands of similar
warnings).

Please drop.

> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Cc: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Bjorn Andersson <andersson@kernel.org>
> Link: https://lore.kernel.org/r/20220905070240.1634997-1-bhupesh.sharma@linaro.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi
> index ae90b97aecb8..24836b6b9bbc 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi
> @@ -60,9 +60,8 @@
>  			#interrupt-cells = <2>;
>  		};
>  
> -		pmc8280c_lpg: lpg@e800 {
> +		pmc8280c_lpg: pwm {
>  			compatible = "qcom,pm8350c-pwm";
> -			reg = <0xe800>;
>  
>  			#address-cells = <1>;
>  			#size-cells = <0>;

Johan
