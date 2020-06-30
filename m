Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BAD20F0F1
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 10:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731678AbgF3IyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 04:54:19 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:35455 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731485AbgF3IyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 04:54:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1593507257; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=DD08zVA7L6yqX9qQqZj+3xFCE1Sx2ordzHijj44rZ3g=;
 b=p+vWTRk70oa2TIyk75YnQpnNoQGePh/5zILC2/iDUxyJSt+mHj9yxYb0wURW1unJOwXWpNCo
 jLdrChADtRcJRGul0YHRxMIuOtM8/xYsvGLX8f5SCgaC1oATg+zhOoeD4vkVo3/M0s02uxs7
 W6IkSQc9ip+02mXyt7WGUl9jLLA=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n14.prod.us-west-2.postgun.com with SMTP id
 5efafdac4c9690533ae2d1ff (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 30 Jun 2020 08:54:04
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0B109C433C6; Tue, 30 Jun 2020 08:54:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: saiprakash.ranjan)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4D83EC433C6;
        Tue, 30 Jun 2020 08:54:03 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 30 Jun 2020 14:24:03 +0530
From:   Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
To:     Sibi Sankar <sibis@codeaurora.org>
Cc:     bjorn.andersson@linaro.org, agross@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        will@kernel.org, robh+dt@kernel.org, evgreen@chromium.org,
        dianders@chromium.org, mka@chromium.org,
        devicetree@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: qcom: sc7180: Drop the unused non-MSA SID
In-Reply-To: <20200630081938.8131-1-sibis@codeaurora.org>
References: <20200630081938.8131-1-sibis@codeaurora.org>
Message-ID: <76bab0c2f6b63bd436cb316d1c6c9184@codeaurora.org>
X-Sender: saiprakash.ranjan@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-06-30 13:49, Sibi Sankar wrote:
> Having a non-MSA (Modem Self-Authentication) SID bypassed breaks modem
> sandboxing i.e if a transaction were to originate from it, the hardware
> memory protections units (XPUs) would fail to flag them (any 
> transaction
> originating from modem are historically termed as an MSA transaction).
> Drop the unused non-MSA modem SID on SC7180 SoCs and cheza so that SMMU
> continues to block them.
> 
> Fixes: bec71ba243e95 ("arm64: dts: qcom: sc7180: Update Q6V5 MSS node")
> Fixes: 68aee4af5f620 ("arm64: dts: qcom: sdm845-cheza: Add iommus 
> property")
> Cc: stable@vger.kernel.org
> Reported-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
> Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
> ---
>  arch/arm64/boot/dts/qcom/sc7180-idp.dts    | 2 +-
>  arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc7180-idp.dts
> b/arch/arm64/boot/dts/qcom/sc7180-idp.dts
> index 39dbfc89689e8..141de49a1b7d6 100644
> --- a/arch/arm64/boot/dts/qcom/sc7180-idp.dts
> +++ b/arch/arm64/boot/dts/qcom/sc7180-idp.dts
> @@ -312,7 +312,7 @@ &qupv3_id_1 {
>  &remoteproc_mpss {
>  	status = "okay";
>  	compatible = "qcom,sc7180-mss-pil";
> -	iommus = <&apps_smmu 0x460 0x1>, <&apps_smmu 0x444 0x3>;
> +	iommus = <&apps_smmu 0x461 0x0>, <&apps_smmu 0x444 0x3>;
>  	memory-region = <&mba_mem &mpss_mem>;
>  };
> 
> diff --git a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
> b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
> index 70466cc4b4055..64fc1bfd66fad 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
> @@ -634,7 +634,7 @@ &mdss_mdp {
>  };
> 
>  &mss_pil {
> -	iommus = <&apps_smmu 0x780 0x1>,
> +	iommus = <&apps_smmu 0x781 0x0>,
>  		 <&apps_smmu 0x724 0x3>;
>  };

Reviewed-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a 
member
of Code Aurora Forum, hosted by The Linux Foundation
