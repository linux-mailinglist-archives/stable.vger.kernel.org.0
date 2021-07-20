Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2962B3D00EF
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 19:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhGTRLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 13:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbhGTRJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 13:09:55 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4013C061574
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 10:50:33 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c1so119538pfc.13
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 10:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bVpGcCJNxzJz4xn8B9EL3oLPPEWacI7v/ruWv61Q000=;
        b=Y7yJNDAFs6xZpBBXdJ+56blM+/eQeYeXvl3vCk27oQKpwXjLGQFEex3+MqziTV6Vnm
         tl7NccrMvXMiBGQJsXgEHwOM/ulY1UcrE3JhwUI6MS6X64+cZ49wJM30wPAMobI4ixp0
         XnSx8G0Jo/6dmBGnCj0wFAKIKTa/DS35E7vlg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bVpGcCJNxzJz4xn8B9EL3oLPPEWacI7v/ruWv61Q000=;
        b=tqhpMThNPB9xGXY7fUx+CPg9HNmXhMGubwCg42u4RdqzqdebEeKIKKIQ1+yaQZWWrj
         BEQTScYUkFDz6iAAeilxvfCX+LsrrBmNIhRXIbjLrrNCeHotftQljzfQnp2I/hEU17rD
         NMSYGXZVdEv3vU7EzvDLwhimJRbKZkjRiJ7Jw5EicQiCqvJJZfDm0lBN0HqhdNddrArV
         OVPpFTrBLSn/gIJiM8AkteuBGchTtrZVrdDSJZXMoePgU0y4dfoJmdQYDhxsxTzuGMjf
         OnX2VmnaY8di2/3zuCfG9UGWsYfuaU+U+C2skQ+HJ8ZaiVlEQ4MJtEbLfER0wfOQRdjV
         uImw==
X-Gm-Message-State: AOAM5322VSA2kt2I5qoNN4q2bMPKOjB5Ezb0aXV6qki6POVVQirpJ+Fv
        /X1GZ9um5XtSglyDi4ZmEhvVwQ==
X-Google-Smtp-Source: ABdhPJw+3aILAs44wxCIgv56bChOz7Y3d9mZXQ9GF5TniuDGef+oZzkVcX6tuZc4Va86+BDDWA3x6A==
X-Received: by 2002:a63:d757:: with SMTP id w23mr5870300pgi.434.1626803433510;
        Tue, 20 Jul 2021 10:50:33 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:4d0:bf5f:b8cd:2d67])
        by smtp.gmail.com with UTF8SMTPSA id d191sm28036023pga.27.2021.07.20.10.50.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jul 2021 10:50:33 -0700 (PDT)
Date:   Tue, 20 Jul 2021 10:50:31 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Sibi Sankar <sibis@codeaurora.org>
Cc:     bjorn.andersson@linaro.org, tdas@codeaurora.org, agross@kernel.org,
        robh+dt@kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: qcom: sc7280: Fixup cpufreq domain info for
 cpu7
Message-ID: <YPcM5w60c5s+mZ4Y@google.com>
References: <1626800953-613-1-git-send-email-sibis@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1626800953-613-1-git-send-email-sibis@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 20, 2021 at 10:39:13PM +0530, Sibi Sankar wrote:
> The SC7280 SoC supports a 4-Silver/3-Gold/1-Gold+ configuration and hence
> the cpu7 node should point to cpufreq domain 2 instead.
> 
> Fixes: 7dbd121a2c58 ("arm64: dts: qcom: sc7280: Add cpufreq hw node")
> Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
> index a8c274ad74c4..188c5768a55a 100644
> --- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
> @@ -200,7 +200,7 @@
>  					   &BIG_CPU_SLEEP_1
>  					   &CLUSTER_SLEEP_0>;
>  			next-level-cache = <&L2_700>;
> -			qcom,freq-domain = <&cpufreq_hw 1>;
> +			qcom,freq-domain = <&cpufreq_hw 2>;
>  			#cooling-cells = <2>;
>  			L2_700: l2-cache {
>  				compatible = "cache";

Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
