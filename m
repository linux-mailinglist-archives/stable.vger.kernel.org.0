Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EDB35E20E
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 16:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345326AbhDMO6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 10:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345311AbhDMO5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 10:57:40 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3DCC061574
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 07:57:19 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id w8so8115776pfn.9
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 07:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CSgRgzubmTxt/v88qdNcpZFeicX9rDyswIgEAQYYcss=;
        b=fQtJjAoJCntHet7/C4V7yKrYZknKDdR+yYNzxMoDR/+Z4P/RdDBleHKVfBauFWHSIj
         TjPz9Z6n1uMhnafygBFxpYiCFxkNhHtz7CHqzTrH0KpLbsSpJHnSBoPzs9Uiu+b0uwN8
         LeuI0Mcd1TFkJFLhe2fwEP6Px+zGg29/TPIECzusj2V/McN7Fc3mt/VNWOmp1B8MSDd2
         ZtTJG5JPauheaMzlpoHrTVmmohCk4/TYqtsgD2BOlIyecydjW5X02UgdpHdlgZbsuqCh
         oN4gmLY98tkvaz1QgX4oXawq1WPlxk3w7+ZdvXlUvpG1kZh+EJzrOTnnEElxFM8GfYkH
         gA5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CSgRgzubmTxt/v88qdNcpZFeicX9rDyswIgEAQYYcss=;
        b=Rb6n1Df7cuYEvzKYhmgji5CabTrS0QV/b0zHJI0VQrsScLHCwL89HUUGsHXOOTDJUW
         RmL1rN+d5cqSIODfqPIzbWMjmBMX7eN6hVJnuALfoijqADjoDLZuD8egEZTcRCbGqzfN
         MxnUTF4Z5rs55ExJMfGerY5eQG8xUi5Jz+txR00P7zibAk7UYMInl1VXPxPMqvfgnBUp
         /mT1uLVWyoYcReCp/BjuyjCGjM9FEeXNAOp+17vLYhg/TI2EEzopt59NrC/1VwxpaCbO
         CnL64fmXA2iyDGRh4MdXR4c84ec3EiLEFUUP1H2Mgb3mE73QPdMomiaXpGiYEKWEPj29
         nLTA==
X-Gm-Message-State: AOAM530ZRtfbdzJtfk0DtSYMaua9ryqrQy7Im1Fyh1uB5OJtL7VbkNvV
        Dl4ixHoTSglbIEeeBSrfiKGJ
X-Google-Smtp-Source: ABdhPJy771UybKC1Cj1hoQBu8uJnBZUdSXMGa2LZwyZv/Ed+wdAYBoggN9HYoI5RPskIp6gegJ/K0Q==
X-Received: by 2002:a63:4f08:: with SMTP id d8mr783253pgb.79.1618325839330;
        Tue, 13 Apr 2021 07:57:19 -0700 (PDT)
Received: from thinkpad ([2409:4072:188:336c:f8f0:1ccd:9421:e069])
        by smtp.gmail.com with ESMTPSA id x19sm13076406pff.14.2021.04.13.07.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 07:57:18 -0700 (PDT)
Date:   Tue, 13 Apr 2021 20:27:09 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh@kernel.org>, stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] PCI: dwc: Move iATU detection earlier
Message-ID: <20210413145709.GA2967@thinkpad>
References: <20210413142219.2301430-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413142219.2301430-1-dmitry.baryshkov@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 13, 2021 at 05:22:19PM +0300, Dmitry Baryshkov wrote:
> From: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
> 
> dw_pcie_ep_init() depends on the detected iATU region numbers to allocate
> the in/outbound window management bitmap.  It fails after 281f1f99cf3a
> ("PCI: dwc: Detect number of iATU windows").
> 
> Move the iATU region detection into a new function, move the detection to
> the very beginning of dw_pcie_host_init() and dw_pcie_ep_init().  Also
> remove it from the dw_pcie_setup(), since it's more like a software
> initialization step than hardware setup.
> 
> Fixes: 281f1f99cf3a ("PCI: dwc: Detect number of iATU windows")
> Link: https://lore.kernel.org/r/20210125044803.4310-1-Zhiqiang.Hou@nxp.com
> Tested-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Cc: stable@vger.kernel.org	# v5.11+
> [DB: moved dw_pcie_iatu_detect to happen after host_init callback]
> Link: https://lore.kernel.org/linux-pci/20210407131255.702054-1-dmitry.baryshkov@linaro.org
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
>  drivers/pci/controller/dwc/pcie-designware-ep.c   |  2 ++
>  drivers/pci/controller/dwc/pcie-designware-host.c |  1 +
>  drivers/pci/controller/dwc/pcie-designware.c      | 11 ++++++++---
>  drivers/pci/controller/dwc/pcie-designware.h      |  1 +
>  4 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
> index 1c25d8337151..8d028a88b375 100644
> --- a/drivers/pci/controller/dwc/pcie-designware-ep.c
> +++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
> @@ -705,6 +705,8 @@ int dw_pcie_ep_init(struct dw_pcie_ep *ep)
>  		}
>  	}
>  
> +	dw_pcie_iatu_detect(pci);
> +
>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "addr_space");
>  	if (!res)
>  		return -EINVAL;
> diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
> index 7e55b2b66182..24192b40e3a2 100644
> --- a/drivers/pci/controller/dwc/pcie-designware-host.c
> +++ b/drivers/pci/controller/dwc/pcie-designware-host.c
> @@ -398,6 +398,7 @@ int dw_pcie_host_init(struct pcie_port *pp)
>  		if (ret)
>  			goto err_free_msi;
>  	}
> +	dw_pcie_iatu_detect(pci);
>  
>  	dw_pcie_setup_rc(pp);
>  	dw_pcie_msi_init(pp);
> diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
> index 004cb860e266..a945f0c0e73d 100644
> --- a/drivers/pci/controller/dwc/pcie-designware.c
> +++ b/drivers/pci/controller/dwc/pcie-designware.c
> @@ -660,11 +660,9 @@ static void dw_pcie_iatu_detect_regions(struct dw_pcie *pci)
>  	pci->num_ob_windows = ob;
>  }
>  
> -void dw_pcie_setup(struct dw_pcie *pci)
> +void dw_pcie_iatu_detect(struct dw_pcie *pci)
>  {
> -	u32 val;
>  	struct device *dev = pci->dev;
> -	struct device_node *np = dev->of_node;
>  	struct platform_device *pdev = to_platform_device(dev);
>  
>  	if (pci->version >= 0x480A || (!pci->version &&
> @@ -693,6 +691,13 @@ void dw_pcie_setup(struct dw_pcie *pci)
>  
>  	dev_info(pci->dev, "Detected iATU regions: %u outbound, %u inbound",
>  		 pci->num_ob_windows, pci->num_ib_windows);
> +}
> +
> +void dw_pcie_setup(struct dw_pcie *pci)
> +{
> +	u32 val;
> +	struct device *dev = pci->dev;
> +	struct device_node *np = dev->of_node;
>  
>  	if (pci->link_gen > 0)
>  		dw_pcie_link_set_max_speed(pci, pci->link_gen);
> diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
> index 7247c8b01f04..7d6e9b7576be 100644
> --- a/drivers/pci/controller/dwc/pcie-designware.h
> +++ b/drivers/pci/controller/dwc/pcie-designware.h
> @@ -306,6 +306,7 @@ int dw_pcie_prog_inbound_atu(struct dw_pcie *pci, u8 func_no, int index,
>  void dw_pcie_disable_atu(struct dw_pcie *pci, int index,
>  			 enum dw_pcie_region_type type);
>  void dw_pcie_setup(struct dw_pcie *pci);
> +void dw_pcie_iatu_detect(struct dw_pcie *pci);
>  
>  static inline void dw_pcie_writel_dbi(struct dw_pcie *pci, u32 reg, u32 val)
>  {
> -- 
> 2.30.2
> 
