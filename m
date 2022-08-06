Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68E758B618
	for <lists+stable@lfdr.de>; Sat,  6 Aug 2022 16:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiHFOdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Aug 2022 10:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiHFOdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Aug 2022 10:33:22 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CC4DF4B
        for <stable@vger.kernel.org>; Sat,  6 Aug 2022 07:33:20 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id 13so3534886plo.12
        for <stable@vger.kernel.org>; Sat, 06 Aug 2022 07:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=hZsvYReDneXNRGD9Ri34paDQng4soD5qGv+2z4J+I+w=;
        b=BdBZ4Li3Y94+2gVjZ+pujBDNmGjjbCDMKXkFvYwiTEb8Ix5BRMQdNPuQ1P5WpuVGvo
         T+le9Aa3wkjezzc0VqshtWfp/4eGgMu5P9NNyT4ZbEs9yXueWZB1lN1sNXQfJpoQ8+DW
         pzwBzVsdOYf+gjRfbjNVV/jqoMmq6d1Rnsevf5FE7PDVIrHoMrume6P+gyY/1o5lzitr
         rkOcHK7xrr6sOrTP5LxKKkepkeSpc6OLDEs2pNETIMP+Z0gFDqkcz3z9hhTfeFiTuzHN
         KJBXn38JJu+tu1+RL02y8qxRzMIgWtRJ4GpOtWnue/5E/ZGyZH6J9rJpZRQRdbG49ybj
         /7Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hZsvYReDneXNRGD9Ri34paDQng4soD5qGv+2z4J+I+w=;
        b=kqDTi+VyqmTbfNcqc2ge7rcO/ElnbWdEAtqF1eVZOKJ0IZEZbnIJMj1jUza6fF3HMy
         cSXYlNM2Qtzb0QeQoZyvonS8cbVT8MNg5dQDkClOYBA45upggDZ4Iz5wFXfayn8e4r14
         xm2ffB31sFB8hFMJftFKgRfy9SJbntucPo3FOEsSwEppRtT/z3p2tjwigrPZG6kMCvmc
         EN0nad8Sa/N6bI9A+G97N48BYGsRPoRBoDuaf/RtCNWYr844E0CbcKF5Zqs2YgVHuMAN
         eDBqwlvp9uOEqcCR4XC1pIPSNzPPjoMHZAKmgUWgwzDDFUGXEtr8x5qfU01uOXx6LBkx
         rThA==
X-Gm-Message-State: ACgBeo3vvhmbyt2xSDNDY7fi/3CoX8N8WhOR+diM9dH9+zVoFYVj0YP7
        rF+Ts7GGlGl75dUlyuXLy94tTYarvqk0
X-Google-Smtp-Source: AA6agR7biwjrZH3fe7nViG6ekyA+bwZh0nAc43cXMOLRCFfNZu4KhPzA4sp8F60devRIaLBglDCOug==
X-Received: by 2002:a17:902:e94f:b0:16d:847b:3343 with SMTP id b15-20020a170902e94f00b0016d847b3343mr11470880pll.103.1659796400131;
        Sat, 06 Aug 2022 07:33:20 -0700 (PDT)
Received: from thinkpad ([117.202.188.20])
        by smtp.gmail.com with ESMTPSA id 134-20020a62198c000000b0052ab764fa78sm5048238pfz.185.2022.08.06.07.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Aug 2022 07:33:19 -0700 (PDT)
Date:   Sat, 6 Aug 2022 20:03:11 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Krishna Kurapati <quic_kriskura@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Pavankumar Kondeti <quic_pkondeti@quicinc.com>,
        quic_ppratap@quicinc.com, quic_vpulyala@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 4/9] usb: dwc3: qcom: fix use-after-free on runtime-PM
 wakeup
Message-ID: <20220806143311.GE14384@thinkpad>
References: <20220804151001.23612-1-johan+linaro@kernel.org>
 <20220804151001.23612-5-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220804151001.23612-5-johan+linaro@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 04, 2022 at 05:09:56PM +0200, Johan Hovold wrote:
> The Qualcomm dwc3 runtime-PM implementation checks the xhci
> platform-device pointer in the wakeup-interrupt handler to determine
> whether the controller is in host mode and if so triggers a resume.
> 
> After a role switch in OTG mode the xhci platform-device would have been
> freed and the next wakeup from runtime suspend would access the freed
> memory.
> 
> Note that role switching is executed from a freezable workqueue, which
> guarantees that the pointer is stable during suspend.
> 
> Also note that runtime PM has been broken since commit 2664deb09306
> ("usb: dwc3: qcom: Honor wakeup enabled/disabled state"), which
> incidentally also prevents this issue from being triggered.
> 
> Fixes: a4333c3a6ba9 ("usb: dwc3: Add Qualcomm DWC3 glue driver")
> Cc: stable@vger.kernel.org      # 4.18
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

It'd be good to mention the introduction of dwc3_qcom_is_host() function.
Initially I thought it is used in a single place, but going through the rest of
the patches reveals that it is used later on.

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
> 
> Changes in v2
>  - new patch
> 
>  drivers/usb/dwc3/dwc3-qcom.c | 14 +++++++++++++-
>  drivers/usb/dwc3/host.c      |  1 +
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
> index e9364141661b..6884026b9fad 100644
> --- a/drivers/usb/dwc3/dwc3-qcom.c
> +++ b/drivers/usb/dwc3/dwc3-qcom.c
> @@ -298,6 +298,14 @@ static void dwc3_qcom_interconnect_exit(struct dwc3_qcom *qcom)
>  	icc_put(qcom->icc_path_apps);
>  }
>  
> +/* Only usable in contexts where the role can not change. */
> +static bool dwc3_qcom_is_host(struct dwc3_qcom *qcom)
> +{
> +	struct dwc3 *dwc = platform_get_drvdata(qcom->dwc3);
> +
> +	return dwc->xhci;
> +}
> +
>  static enum usb_device_speed dwc3_qcom_read_usb2_speed(struct dwc3_qcom *qcom)
>  {
>  	struct dwc3 *dwc = platform_get_drvdata(qcom->dwc3);
> @@ -460,7 +468,11 @@ static irqreturn_t qcom_dwc3_resume_irq(int irq, void *data)
>  	if (qcom->pm_suspended)
>  		return IRQ_HANDLED;
>  
> -	if (dwc->xhci)
> +	/*
> +	 * This is safe as role switching is done from a freezable workqueue
> +	 * and the wakeup interrupts are disabled as part of resume.
> +	 */
> +	if (dwc3_qcom_is_host(qcom))
>  		pm_runtime_resume(&dwc->xhci->dev);
>  
>  	return IRQ_HANDLED;
> diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
> index f56c30cf151e..f6f13e7f1ba1 100644
> --- a/drivers/usb/dwc3/host.c
> +++ b/drivers/usb/dwc3/host.c
> @@ -135,4 +135,5 @@ int dwc3_host_init(struct dwc3 *dwc)
>  void dwc3_host_exit(struct dwc3 *dwc)
>  {
>  	platform_device_unregister(dwc->xhci);
> +	dwc->xhci = NULL;
>  }
> -- 
> 2.35.1
> 

-- 
மணிவண்ணன் சதாசிவம்
