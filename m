Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81AB4F1682
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 15:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377281AbiDDNxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 09:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359251AbiDDNwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 09:52:49 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909882A706
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 06:50:52 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-d39f741ba0so10653103fac.13
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 06:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UJ7ifLL/vt7TzqWMHfr/T5EroEWr8e059AicCh65jwE=;
        b=XdBxqwZ6hlXamq+EWOsWwZc2zeRgoCwCqOUQwsgb5NTwPspoxxb1w0Onbn4/IwsWXN
         oBhYY2EniOXswlpd6EFCV4DGAHPIQoHZ4DR9HBGivSxgA1BXhRRqli935/RvYWgb2xGu
         wKKnsPEUP/7Be2RBiFDzI2nwvmjM4sKPcBRZVZE/WeAQnxANwpd002AeQ5K8cbw+HO8t
         YP+jzRVuWISNKa0QLHasAEGOQSW1OHcw16BCf77kPpieQPPywEnX0F5Ea/fD/sdno8B3
         0sQ6zqlIs0nnhgLJgZtSec5Ze8eEOxP/sIVmHUuseH9VJYI5LkYMD2Aq/496qBPfXQm5
         gzDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UJ7ifLL/vt7TzqWMHfr/T5EroEWr8e059AicCh65jwE=;
        b=ZNpVd7vC9wDuiSz9wzDccN8EoPVUAoyDhfezoIPUwvUdWu0nzgZypI4wkspuiBHWn+
         W3ZfeKnbKFzj3941FmNRRDcPISoBmm1ICjuhswgx9AE2lh0wsLADVCExbD0driF/R3sj
         5ElRZgz9PcaY5fncuHL+EP3GkeJxj+B01I4pnWWLP6nzN+iJ9yEHmoCdoJOf2YHqx1z9
         ROQbnBZdbggq5tfybqFjsZeloLi+ejzZsEiLC9USgDcfUWR3CQHlofL2r70UWi72zV0a
         YGbGfwEQrwyfvffxrmeW2KTTl+VOdVXRL6O34iobUDIdogSdFWEvvnD0J4+VcUm0dfT/
         08Qg==
X-Gm-Message-State: AOAM5305RHWwg+dwbjQi2JWfeUTCglFD442950Z18YSQggHTDQhwQ4Za
        TF9gP6DieMkqDvTsbVTzaWAv3w==
X-Google-Smtp-Source: ABdhPJz20MpJx7LSy5moQ816FyGIBvEreDKN4HMKOHtNCOu/4APRQAt0B1hh6o4oY3S/Sn+csHU31g==
X-Received: by 2002:a05:6870:3113:b0:d3:473b:3f1d with SMTP id v19-20020a056870311300b000d3473b3f1dmr3732oaa.116.1649080251783;
        Mon, 04 Apr 2022 06:50:51 -0700 (PDT)
Received: from ripper ([2600:1700:a0:3dc8:205:1bff:fec0:b9b3])
        by smtp.gmail.com with ESMTPSA id 14-20020a056870134e00b000ddaf3927b1sm4218569oac.32.2022.04.04.06.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 06:50:51 -0700 (PDT)
Date:   Mon, 4 Apr 2022 06:53:16 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Andy Gross <agross@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Wilczy??ski <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-pci@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] PCI: qcom: Fix pipe clock imbalance
Message-ID: <Ykr4TOYYh4X8o02E@ripper>
References: <20220401133351.10113-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401133351.10113-1-johan+linaro@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 01 Apr 06:33 PDT 2022, Johan Hovold wrote:

> Commit ed8cc3b1fc84 ("PCI: qcom: Add support for SDM845 PCIe
> controller") introduced a clock imbalance by enabling the pipe clock
> both in init() and in post_init() but only disabling in post_deinit().
> 
> Note that the pipe clock was also never disabled in the init() error
> paths and that enabling the clock before powering up the PHY looks
> questionable.
> 
> Fixes: ed8cc3b1fc84 ("PCI: qcom: Add support for SDM845 PCIe controller")
> Cc: stable@vger.kernel.org      # 5.6
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
> 
> Changes in v2
>  - Capitalise "Fix" in subject line according to PCI subsystem
>    convention
> 
> 
>  drivers/pci/controller/dwc/pcie-qcom.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> index b79d98e5e228..20a0e6533a1c 100644
> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> @@ -1238,12 +1238,6 @@ static int qcom_pcie_init_2_7_0(struct qcom_pcie *pcie)
>  		goto err_disable_clocks;
>  	}
>  
> -	ret = clk_prepare_enable(res->pipe_clk);
> -	if (ret) {
> -		dev_err(dev, "cannot prepare/enable pipe clock\n");
> -		goto err_disable_clocks;
> -	}
> -
>  	/* Wait for reset to complete, required on SM8450 */
>  	usleep_range(1000, 1500);
>  
> -- 
> 2.35.1
> 
