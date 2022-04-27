Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489E5511303
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 09:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359138AbiD0H6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 03:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359142AbiD0H6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 03:58:01 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701AB1467DC
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 00:54:49 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id i62so842235pgd.6
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 00:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l5ta2NcdLy0veXom7gBreHDrt/omYROMofUj/QJzRM8=;
        b=ub4kODAFuZCRDRKfYL+qD4Qo+CC5tdnSwxRYRCnqEO3KEIulaZ3NT6zyxPTxYR3u8A
         dOtfrONzD2vym+sFJDS/tX41It6KoWXVffaoqU0cE7O5+VkRzqsaX9k1qBtfGxATMByD
         gSkQzbOUdRhfiDTmAmeg6SzkOa+NiiSfXwSpfl+UwxNmKNEPSfHCnPPuqWtEVLpDK0j/
         3dS4myD7J6mzDYPihhrmBm+0TsowSjHsSrrz4Oldum0dffE+ru1b6Pug0+LLNPRlRJka
         NzF/pj2Jan4AeVL99wU/WnsilnC7Q/83/Zo7qETXoIiWTHsJ/SwTJS9YG0Jy/EmTDq2S
         fNsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l5ta2NcdLy0veXom7gBreHDrt/omYROMofUj/QJzRM8=;
        b=qy6rKl16zlL9prUrJavL2ILigJNkbispstdjzFq81lREDg5cjDqy79POgCPadTWAmi
         nZ4tq5yBbR7anZSc0yLysIDR/VkNS27ATgStY4+r9DgfpyGYmSwTWBObluJYVQbU4JzI
         p+NcWiRkI1cxfgmt8PKvQI/iUWmfwkpgHx1d1aAaxgBxJ3FuGMnzQzeG2AoOBNjswn+v
         THpaJLoqLjbmyLzVgbf+Xzvqa3LfRIszVysQJLlwihuk6GEAXbMepkWgtwl8Z+ehYLJ9
         O3e839FVrDD4SxcqIROPCAE8Ewo+7+YaidoRXop6jar+wRNeioiLgWnP3jY0GFeOylPg
         ng+g==
X-Gm-Message-State: AOAM5316YbK11qx2mw0q03HRr6gXSJwKIrKcsRNquDYqHChsgt88JWOh
        R8whJQqtyBDu+QduKYHWPY8T
X-Google-Smtp-Source: ABdhPJyldkjQ5JNmLeZGK1hjdo7V7D2TILQ767NfRf8ugq3VZL7555wG2pVU843qNVyDD+GX22SS0Q==
X-Received: by 2002:a65:5b84:0:b0:398:fd62:6497 with SMTP id i4-20020a655b84000000b00398fd626497mr22570602pgr.179.1651046088864;
        Wed, 27 Apr 2022 00:54:48 -0700 (PDT)
Received: from thinkpad ([117.207.26.174])
        by smtp.gmail.com with ESMTPSA id h6-20020a056a00218600b004f65315bb37sm18792509pfi.13.2022.04.27.00.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 00:54:48 -0700 (PDT)
Date:   Wed, 27 Apr 2022 13:24:41 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-pci@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] PCI: qcom: Fix runtime PM imbalance on probe
 errors
Message-ID: <20220427075441.GA2182@thinkpad>
References: <20220401133854.10421-1-johan+linaro@kernel.org>
 <20220401133854.10421-2-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401133854.10421-2-johan+linaro@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 01, 2022 at 03:38:53PM +0200, Johan Hovold wrote:
> Drop the leftover pm_runtime_disable() calls from the late probe error
> paths that would, for example, prevent runtime PM from being reenabled
> after a probe deferral.
> 
> Fixes: 6e5da6f7d824 ("PCI: qcom: Fix error handling in runtime PM support")
> Cc: stable@vger.kernel.org      # 4.20
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
>  drivers/pci/controller/dwc/pcie-qcom.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> index 20a0e6533a1c..0b0bd71f1bd2 100644
> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> @@ -1616,17 +1616,14 @@ static int qcom_pcie_probe(struct platform_device *pdev)
>  	pp->ops = &qcom_pcie_dw_ops;
>  
>  	ret = phy_init(pcie->phy);
> -	if (ret) {
> -		pm_runtime_disable(&pdev->dev);
> +	if (ret)
>  		goto err_pm_runtime_put;
> -	}
>  
>  	platform_set_drvdata(pdev, pcie);
>  
>  	ret = dw_pcie_host_init(pp);
>  	if (ret) {
>  		dev_err(dev, "cannot initialize host\n");
> -		pm_runtime_disable(&pdev->dev);
>  		goto err_pm_runtime_put;
>  	}
>  
> -- 
> 2.35.1
> 
