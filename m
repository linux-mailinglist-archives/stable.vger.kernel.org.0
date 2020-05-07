Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B0D1C9867
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 19:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgEGRyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 13:54:11 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35619 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgEGRyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 13:54:11 -0400
Received: by mail-oi1-f194.google.com with SMTP id o7so6022320oif.2;
        Thu, 07 May 2020 10:54:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=g8REV0kLr+byzHuvO4ibHyw5i1CzypXIkPjjQmmKtfU=;
        b=J8nxmyPzy/4gmrLgDtoh/l0QVEYmY7JAyOusSmf/eOMZIJkDjnD8UkPdoWeFBokjOF
         lNzxXBbxk11hZKmPVHtwy2cZvqwBj1yd25lVTV6QWpnKIRfDXiSwq3i3QhA/mnSgGtGW
         70kwvz+FoZXjyJQdp+eeEbCW1gERRhJcgHI8Y+cL8Kn+zik8BnT2dCzZuI5Rh8j5An4s
         uGX12T47duLKsJ9f/4I8diDMhOsGNNtKg5n4E/AHwObGuEziOQ20uEIBtYfgiAVTbeUE
         y1u/Y2GjfRof+Ct24b4Pa0IA79YCos5b2e5lypILK8ewqKDmIt069Dy6PwV/fFKQAoHw
         zrsQ==
X-Gm-Message-State: AGi0PuYSFYhHpUR8kGxSEt37vd3Kx4csTq8+By5kFfXHSo2lD1oVkAeY
        oGt6AqTnMAcvrjFG9h9UTw==
X-Google-Smtp-Source: APiQypICrRGa77xwpC1Feh+IttYD29SZ7QVuZ9F9xIn6Psb5EV7p01JImSfl45fb5o//MUBvzn7aqg==
X-Received: by 2002:aca:57c4:: with SMTP id l187mr7744976oib.155.1588874050050;
        Thu, 07 May 2020 10:54:10 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id q3sm1637241oom.12.2020.05.07.10.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 10:54:09 -0700 (PDT)
Received: (nullmailer pid 18070 invoked by uid 1000);
        Thu, 07 May 2020 17:54:08 -0000
Date:   Thu, 7 May 2020 12:54:08 -0500
From:   Rob Herring <robh@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sham Muthayyan <smuthayy@codeaurora.org>,
        stable@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/11] PCI: qcom: add missing ipq806x clocks in PCIe
 driver
Message-ID: <20200507175408.GA2029@bogus>
References: <20200430220619.3169-1-ansuelsmth@gmail.com>
 <20200430220619.3169-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430220619.3169-2-ansuelsmth@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 01, 2020 at 12:06:08AM +0200, Ansuel Smith wrote:
> Aux and Ref clk are missing in PCIe qcom driver.
> Add support in the driver to fix PCIe initialization in ipq806x.
> 
> Fixes: 82a823833f4e PCI: qcom: Add Qualcomm PCIe controller driver
> Signed-off-by: Sham Muthayyan <smuthayy@codeaurora.org>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Cc: stable@vger.kernel.org # v4.5+

Doesn't strike me as stable material. Looks like new h/w enablement.

> ---
>  drivers/pci/controller/dwc/pcie-qcom.c | 44 ++++++++++++++++++++++----
>  1 file changed, 38 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> index 5ea527a6bd9f..2a39dfdccfc8 100644
> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> @@ -88,6 +88,8 @@ struct qcom_pcie_resources_2_1_0 {
>  	struct clk *iface_clk;
>  	struct clk *core_clk;
>  	struct clk *phy_clk;
> +	struct clk *aux_clk;
> +	struct clk *ref_clk;
>  	struct reset_control *pci_reset;
>  	struct reset_control *axi_reset;
>  	struct reset_control *ahb_reset;
> @@ -246,6 +248,14 @@ static int qcom_pcie_get_resources_2_1_0(struct qcom_pcie *pcie)
>  	if (IS_ERR(res->phy_clk))
>  		return PTR_ERR(res->phy_clk);
>  
> +	res->aux_clk = devm_clk_get_optional(dev, "aux");
> +	if (IS_ERR(res->aux_clk))
> +		return PTR_ERR(res->aux_clk);
> +
> +	res->ref_clk = devm_clk_get_optional(dev, "ref");
> +	if (IS_ERR(res->ref_clk))
> +		return PTR_ERR(res->ref_clk);

Seems like you'd want to report an error for ipq608x? Based on the 
commit msg, they aren't optional.

> +
>  	res->pci_reset = devm_reset_control_get_exclusive(dev, "pci");
>  	if (IS_ERR(res->pci_reset))
>  		return PTR_ERR(res->pci_reset);
> @@ -278,6 +288,8 @@ static void qcom_pcie_deinit_2_1_0(struct qcom_pcie *pcie)
>  	clk_disable_unprepare(res->iface_clk);
>  	clk_disable_unprepare(res->core_clk);
>  	clk_disable_unprepare(res->phy_clk);
> +	clk_disable_unprepare(res->aux_clk);
> +	clk_disable_unprepare(res->ref_clk);
>  	regulator_bulk_disable(ARRAY_SIZE(res->supplies), res->supplies);
>  }
>  
> @@ -307,16 +319,32 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
>  		goto err_assert_ahb;
>  	}
>  
> +	ret = clk_prepare_enable(res->core_clk);

Perhaps use the bulk api.

> +	if (ret) {
> +		dev_err(dev, "cannot prepare/enable core clock\n");
> +		goto err_clk_core;
> +	}
> +
>  	ret = clk_prepare_enable(res->phy_clk);
>  	if (ret) {
>  		dev_err(dev, "cannot prepare/enable phy clock\n");
>  		goto err_clk_phy;
>  	}
>  
> -	ret = clk_prepare_enable(res->core_clk);
> -	if (ret) {
> -		dev_err(dev, "cannot prepare/enable core clock\n");
> -		goto err_clk_core;
> +	if (res->aux_clk) {
> +		ret = clk_prepare_enable(res->aux_clk);
> +		if (ret) {
> +			dev_err(dev, "cannot prepare/enable aux clock\n");
> +			goto err_clk_aux;
> +		}
> +	}
> +
> +	if (res->ref_clk) {
> +		ret = clk_prepare_enable(res->ref_clk);
> +		if (ret) {
> +			dev_err(dev, "cannot prepare/enable ref clock\n");
> +			goto err_clk_ref;
> +		}
>  	}
>  
>  	ret = reset_control_deassert(res->ahb_reset);
> @@ -372,10 +400,14 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
>  	return 0;
>  
>  err_deassert_ahb:
> -	clk_disable_unprepare(res->core_clk);
> -err_clk_core:
> +	clk_disable_unprepare(res->ref_clk);
> +err_clk_ref:
> +	clk_disable_unprepare(res->aux_clk);
> +err_clk_aux:
>  	clk_disable_unprepare(res->phy_clk);
>  err_clk_phy:
> +	clk_disable_unprepare(res->core_clk);
> +err_clk_core:
>  	clk_disable_unprepare(res->iface_clk);
>  err_assert_ahb:
>  	regulator_bulk_disable(ARRAY_SIZE(res->supplies), res->supplies);
> -- 
> 2.25.1
> 
