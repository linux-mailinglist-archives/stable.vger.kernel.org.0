Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C352D697371
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 02:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBOBVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 20:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbjBOBVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 20:21:17 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAC432CFA
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 17:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676424062; x=1707960062;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NfIdZ5I7BKY0oDk8dlf2XVu+GiEDtbmIPu92tWOZ/Rs=;
  b=UJb3ohp/0vb+PfI1B4gNj9tSgv/JN/KkAeZWVk7mk/A/O185msmuumXi
   Q5ZpklJEmRo1T1nUfohis8RxYZX3SA1wVt6Z952mzPFUOOwdFtmGI7bYw
   wFZrvHPQDrF3E6Ku68NKIDC97Hy3IcGEhFdtvsak1hETdWW/RMLIEg50e
   RbjHjoEMWzJ9Jz1MgIW0KFKozHMvdzaE9pS+P/qSFKeHQlDlknDAMI3At
   +MVk01AH72/x7hHeQW9m1SMwsbXgsn5Pxq1YuDexYsCL005P93K1bOCzR
   F+YhflTaaYZC0TYRBFrPzN7uGCKGQBSsREE6NtHUXIZY7UN6z2Ee4RLwx
   A==;
X-IronPort-AV: E=Sophos;i="5.97,298,1669046400"; 
   d="scan'208";a="221622012"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 Feb 2023 09:20:51 +0800
IronPort-SDR: tSjcZS0buI4f5Kdzq5m3IxS0v4Q002OcJDPALZMHbmB3iwhWVtGSG8qWZS+QElpNt4jlb/t0pF
 GgTkCBR/TGvQCwTIpXLFdVuoJj2ZijyvYe46zUlvgKQM9xEsHMwUnLkzYT7lrWslORt7kf1Oll
 p9JMY2XZbrp/ZDnipUVWGGSdiZ6ftTRI00nUYEKPlJHMXX2GygWZELFQh1QWeLrsV3OUYKXDaz
 uoXVYVHRrAV3ka2XrwQOWpI+N3KZq5NAV1EqKu2xfGZAsBQ4tIQn9X6NLW+cvpvas6pfB8Ih8w
 N7c=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Feb 2023 16:32:14 -0800
IronPort-SDR: VTB/hQ+cnpJarcoM6MvjDbi+pbSzzgp5tT4VD6cc2kq5kIZw0Mjpsbhky+wrOH6UCbA/MFhhUJ
 /VQJ3fqJYEX7TMslBpFt8awR77zUcE5b3v/+wpoGzP4EO2ZrrOEkvbip6n2bOQII8ZCbrkkRn8
 WWNOBZJBTxTfnLCs/tmbrFPeXHaVsPzDBTIZ1WYPZEgllSDHTM0Mma1oZM64ymSxMI34TLqSOd
 cM84DCVeytem6zf5nHJJfO+7D3OMF0UMUMutsTmQZSNSnizTCrFOQs5fefQO32GyoZWpwTWxFC
 PQ0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Feb 2023 17:20:50 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PGgJ31WfDz1Rwrq
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 17:20:51 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1676424049; x=1679016050; bh=NfIdZ5I7BKY0oDk8dlf2XVu+GiEDtbmIPu9
        2tWOZ/Rs=; b=K1B0EirwIoKgKhbEnMNa5QNIi+vZHdHlqkmYZQs9URPzgSj88cx
        O7bQ8W3IeiTmEPgzyT1bVIvM3BoZV5w9VXWqp+Y9qCUBStwSB2X4rUEx6hzTP74N
        R6abQBUTuQBHFqPYDQ5PdfYH4IcSN9R4CAh+BvrFIm4/6G9FrnuyzS5PB3P46Gqd
        AgTCJoYnqfTjmPvGK4nEGzCARcwfqEeVseqEU2QlXqN715aSRupN4jgOGGV3HgpS
        h8guMjqJM4JAzx9vQ9FGy7ViVomvkSqk9RZwKURAE7z44TUgi/95i9iJ1IP24r7N
        VAbBP3ixvrx7QOBNty11hTSHk/I2O4IXL/A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id CyUtbEQojO63 for <stable@vger.kernel.org>;
        Tue, 14 Feb 2023 17:20:49 -0800 (PST)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PGgHv3jj9z1RvLy;
        Tue, 14 Feb 2023 17:20:43 -0800 (PST)
Message-ID: <4dd920dd-5e2c-2a00-17ae-61cf4d154ddd@opensource.wdc.com>
Date:   Wed, 15 Feb 2023 10:20:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 6/9] PCI: rockchip: Fix window mapping and address
 translation for endpoint
Content-Language: en-US
To:     Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        alberto.dassatti@heig-vd.ch
Cc:     xxm@rock-chips.com, rick.wertenbroek@heig-vd.ch,
        stable@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Mikko Kovanen <mikko.kovanen@aavamobile.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20230214140858.1133292-1-rick.wertenbroek@gmail.com>
 <20230214140858.1133292-7-rick.wertenbroek@gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230214140858.1133292-7-rick.wertenbroek@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/23 23:08, Rick Wertenbroek wrote:
> The RK3399 PCI endpoint core has 33 windows for PCIe space, now in the
> driver up to 32 fixed size (1M) windows are used and pages are allocated
> and mapped accordingly. The driver first used a single window and allocated
> space inside which caused translation issues (between CPU space and PCI
> space) because a window can only have a single translation at a given
> time, which if multiple pages are allocated inside will cause conflicts.
> Now each window is a single region of 1M which will always guarantee that
> the translation is not in conflict.
> 
> Set the translation register addresses for physical function. As documented
> in the technical reference manual (TRM) section 17.5.5 "PCIe Address
> Translation" and section 17.6.8 "Address Translation Registers Description"
> 
> Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
> ---
>  drivers/pci/controller/pcie-rockchip-ep.c | 67 ++++++++++++-----------
>  drivers/pci/controller/pcie-rockchip.h    | 25 +++++----
>  2 files changed, 49 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
> index 4c84e403e..cbc281a6a 100644
> --- a/drivers/pci/controller/pcie-rockchip-ep.c
> +++ b/drivers/pci/controller/pcie-rockchip-ep.c
> @@ -76,11 +76,17 @@ static void rockchip_pcie_prog_ep_ob_atu(struct rockchip_pcie *rockchip, u8 fn,
>  	if (num_pass_bits < 8)
>  		num_pass_bits = 8;
>  
> -	cpu_addr -= rockchip->mem_res->start;
> -	addr0 = ((is_nor_msg ? 0x10 : (num_pass_bits - 1)) &
> -		PCIE_CORE_OB_REGION_ADDR0_NUM_BITS) |
> -		(lower_32_bits(cpu_addr) & PCIE_CORE_OB_REGION_ADDR0_LO_ADDR);
> -	addr1 = upper_32_bits(is_nor_msg ? cpu_addr : pci_addr);
> +	if (is_nor_msg) {
> +		dev_warn(rockchip->dev, "NOR MSG\n");

I do not think this warning is needed.
In fact, if you move your patch 7 before this one, we could probably drop
the is_nor_msg == true case entirely since with your patch 7, only the
host driver uses AXI_WRAPPER_NOR_MSG. So warning and returning for that
case should be enough.

> +		cpu_addr -= rockchip->mem_res->start;

This needs to be done for the !is_nor_msg case too.

> +		addr0 = (0x10 & PCIE_CORE_OB_REGION_ADDR0_NUM_BITS) |
> +			(lower_32_bits(cpu_addr) & PCIE_CORE_OB_REGION_ADDR0_LO_ADDR);
> +		addr1 = upper_32_bits(cpu_addr);
> +	} else {
> +		addr0 = (num_pass_bits & PCIE_CORE_OB_REGION_ADDR0_NUM_BITS) |
> +			(lower_32_bits(pci_addr) & PCIE_CORE_OB_REGION_ADDR0_LO_ADDR);
> +		addr1 = upper_32_bits(pci_addr);
> +	}
>  	desc0 = ROCKCHIP_PCIE_AT_OB_REGION_DESC0_DEVFN(fn) | type;
>  	desc1 = 0;
>  
> @@ -103,12 +109,6 @@ static void rockchip_pcie_prog_ep_ob_atu(struct rockchip_pcie *rockchip, u8 fn,
>  				    ROCKCHIP_PCIE_AT_OB_REGION_DESC0(r));
>  		rockchip_pcie_write(rockchip, desc1,
>  				    ROCKCHIP_PCIE_AT_OB_REGION_DESC1(r));
> -
> -		addr0 =
> -		    ((num_pass_bits - 1) & PCIE_CORE_OB_REGION_ADDR0_NUM_BITS) |
> -		    (lower_32_bits(cpu_addr) &
> -		     PCIE_CORE_OB_REGION_ADDR0_LO_ADDR);
> -		addr1 = upper_32_bits(cpu_addr);

This hunk should have been removed in patch 1. But as commented, this is
needed, at least for me. Without setting the cpu addr to OB region cpu
addr register, mmio/dma does not work for me, despite the TRM saying that
these registers are unused.

>  	}
>  }
>  
> @@ -256,15 +256,7 @@ static int rockchip_pcie_ep_map_addr(struct pci_epc *epc, u8 fn, u8 vfn,
>  	struct rockchip_pcie *pcie = &ep->rockchip;
>  	u32 r;
>  
> -	r = find_first_zero_bit(&ep->ob_region_map, BITS_PER_LONG);
> -	/*
> -	 * Region 0 is reserved for configuration space and shouldn't
> -	 * be used elsewhere per TRM, so leave it out.
> -	 */
> -	if (r >= ep->max_regions - 1) {
> -		dev_err(&epc->dev, "no free outbound region\n");
> -		return -EINVAL;
> -	}
> +	r = (addr >> ilog2(SZ_1M)) & 0x1f;

Locally, I added a smal helper:

static inline int rockchip_ob_region(u64 addr)
{
        return (addr >> ilog2(SZ_1M)) & 0x1f;
}

That makes the code nicer and avoids having this open coded repeatedly in
different places.

>  
>  	rockchip_pcie_prog_ep_ob_atu(pcie, fn, r, AXI_WRAPPER_MEM_WRITE, addr,
>  				     pci_addr, size);
> @@ -282,15 +274,11 @@ static void rockchip_pcie_ep_unmap_addr(struct pci_epc *epc, u8 fn, u8 vfn,
>  	struct rockchip_pcie *rockchip = &ep->rockchip;
>  	u32 r;
>  
> -	for (r = 0; r < ep->max_regions - 1; r++)
> +	for (r = 0; r < ep->max_regions; r++)
>  		if (ep->ob_addr[r] == addr)
>  			break;
>  
> -	/*
> -	 * Region 0 is reserved for configuration space and shouldn't
> -	 * be used elsewhere per TRM, so leave it out.
> -	 */
> -	if (r == ep->max_regions - 1)
> +	if (r == ep->max_regions)
>  		return;
>  
>  	rockchip_pcie_clear_ep_ob_atu(rockchip, r);
> @@ -411,6 +399,7 @@ static int rockchip_pcie_ep_send_msi_irq(struct rockchip_pcie_ep *ep, u8 fn,
>  	u16 flags, mme, data, data_mask;
>  	u8 msi_count;
>  	u64 pci_addr, pci_addr_mask = 0xff;
> +	u32 r;
>  
>  	/* Check MSI enable bit */
>  	flags = rockchip_pcie_read(&ep->rockchip,
> @@ -444,12 +433,12 @@ static int rockchip_pcie_ep_send_msi_irq(struct rockchip_pcie_ep *ep, u8 fn,
>  				       ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
>  				       ROCKCHIP_PCIE_EP_MSI_CTRL_REG +
>  				       PCI_MSI_ADDRESS_LO);
> -	pci_addr &= GENMASK_ULL(63, 2);
>  
>  	/* Set the outbound region if needed. */
>  	if (unlikely(ep->irq_pci_addr != (pci_addr & ~pci_addr_mask) ||
>  		     ep->irq_pci_fn != fn)) {
> -		rockchip_pcie_prog_ep_ob_atu(rockchip, fn, ep->max_regions - 1,
> +		r = (ep->irq_phys_addr >> ilog2(SZ_1M)) & 0x1f;
> +		rockchip_pcie_prog_ep_ob_atu(rockchip, fn, r,
>  					     AXI_WRAPPER_MEM_WRITE,
>  					     ep->irq_phys_addr,
>  					     pci_addr & ~pci_addr_mask,
> @@ -539,6 +528,8 @@ static int rockchip_pcie_parse_ep_dt(struct rockchip_pcie *rockchip,
>  	if (err < 0 || ep->max_regions > MAX_REGION_LIMIT)
>  		ep->max_regions = MAX_REGION_LIMIT;
>  
> +	ep->ob_region_map = 0;
> +
>  	err = of_property_read_u8(dev->of_node, "max-functions",
>  				  &ep->epc->max_functions);
>  	if (err < 0)
> @@ -559,7 +550,10 @@ static int rockchip_pcie_ep_probe(struct platform_device *pdev)
>  	struct rockchip_pcie *rockchip;
>  	struct pci_epc *epc;
>  	size_t max_regions;
> +	struct pci_epc_mem_window *windows = NULL;
>  	int err;
> +	u32 cfg;
> +	int i;

Nit: instead of declaring this with another line, you could declare it
together with "err" above.

>  
>  	ep = devm_kzalloc(dev, sizeof(*ep), GFP_KERNEL);
>  	if (!ep)
> @@ -606,15 +600,26 @@ static int rockchip_pcie_ep_probe(struct platform_device *pdev)
>  	/* Only enable function 0 by default */
>  	rockchip_pcie_write(rockchip, BIT(0), PCIE_CORE_PHY_FUNC_CFG);
>  
> -	err = pci_epc_mem_init(epc, rockchip->mem_res->start,
> -			       resource_size(rockchip->mem_res), PAGE_SIZE);
> +	windows = devm_kcalloc(dev, ep->max_regions, sizeof(struct pci_epc_mem_window), GFP_KERNEL);
> +	if (!windows) {
> +		err = -ENOMEM;
> +		goto err_uninit_port;
> +	}
> +	for (i = 0; i < ep->max_regions; i++) {
> +		windows[i].phys_base = rockchip->mem_res->start + (SZ_1M * i);
> +		windows[i].size = SZ_1M;
> +		windows[i].page_size = SZ_1M;
> +	}
> +	err = pci_epc_multi_mem_init(epc, windows, ep->max_regions);
> +	devm_kfree(dev, windows);
> +
>  	if (err < 0) {
>  		dev_err(dev, "failed to initialize the memory space\n");
>  		goto err_uninit_port;
>  	}
>  
>  	ep->irq_cpu_addr = pci_epc_mem_alloc_addr(epc, &ep->irq_phys_addr,
> -						  SZ_128K);
> +						  SZ_1M);

The region for this needs to be marked as allocated in the ob_region_map. So:

	set_bit(rockchip_ob_region(ep->irq_phys_addr),
		&ep->ob_region_map);

Of note though is that this ob_region_bitmap is used to set and clear bits
*only*, it is actually never checked at all to see if there is a bug and a
mapped region is being remapped without an unmap first. Not sure it is
very useful in the end.

>  	if (!ep->irq_cpu_addr) {
>  		dev_err(dev, "failed to reserve memory space for MSI\n");
>  		err = -ENOMEM;
> diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
> index f3a5ff1cf..72e427a0f 100644
> --- a/drivers/pci/controller/pcie-rockchip.h
> +++ b/drivers/pci/controller/pcie-rockchip.h
> @@ -134,6 +134,7 @@
>  
>  #define PCIE_RC_RP_ATS_BASE		0x400000
>  #define PCIE_RC_CONFIG_NORMAL_BASE	0x800000
> +#define PCIE_EP_PF_CONFIG_REGS_BASE	0x800000
>  #define PCIE_RC_CONFIG_BASE		0xa00000
>  #define PCIE_EP_CONFIG_BASE		0xa00000
>  #define PCIE_EP_CONFIG_DID_VID		(PCIE_EP_CONFIG_BASE + 0x00)
> @@ -228,13 +229,14 @@
>  #define   ROCKCHIP_PCIE_EP_MSI_CTRL_MASK_MSI_CAP	BIT(24)
>  #define ROCKCHIP_PCIE_EP_DUMMY_IRQ_ADDR				0x1
>  #define ROCKCHIP_PCIE_EP_PCI_LEGACY_IRQ_ADDR		0x3
> -#define ROCKCHIP_PCIE_EP_FUNC_BASE(fn)	(((fn) << 12) & GENMASK(19, 12))
> +#define ROCKCHIP_PCIE_EP_FUNC_BASE(fn) \
> +	(PCIE_EP_PF_CONFIG_REGS_BASE + (((fn) << 12) & GENMASK(19, 12)))
> +#define ROCKCHIP_PCIE_EP_VIRT_FUNC_BASE(fn) \
> +	(PCIE_EP_PF_CONFIG_REGS_BASE + 0x10000 + (((fn) << 12) & GENMASK(19, 12)))
>  #define ROCKCHIP_PCIE_AT_IB_EP_FUNC_BAR_ADDR0(fn, bar) \
> -	(PCIE_RC_RP_ATS_BASE + 0x0840 + (fn) * 0x0040 + (bar) * 0x0008)
> +	(PCIE_CORE_AXI_CONF_BASE + 0x0828 + (fn) * 0x0040 + (bar) * 0x0008)
>  #define ROCKCHIP_PCIE_AT_IB_EP_FUNC_BAR_ADDR1(fn, bar) \
> -	(PCIE_RC_RP_ATS_BASE + 0x0844 + (fn) * 0x0040 + (bar) * 0x0008)
> -#define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0(r) \
> -	(PCIE_RC_RP_ATS_BASE + 0x0000 + ((r) & 0x1f) * 0x0020)
> +	(PCIE_CORE_AXI_CONF_BASE + 0x082c + (fn) * 0x0040 + (bar) * 0x0008)
>  #define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0_DEVFN_MASK	GENMASK(19, 12)
>  #define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0_DEVFN(devfn) \
>  	(((devfn) << 12) & \
> @@ -242,20 +244,19 @@
>  #define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0_BUS_MASK	GENMASK(27, 20)
>  #define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0_BUS(bus) \
>  		(((bus) << 20) & ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0_BUS_MASK)
> +#define PCIE_RC_EP_ATR_OB_REGIONS_1_32 (PCIE_CORE_AXI_CONF_BASE + 0x0020)
> +#define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0(r) \
> +		(PCIE_RC_EP_ATR_OB_REGIONS_1_32 + 0x0000 + ((r) & 0x1f) * 0x0020)
>  #define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR1(r) \
> -		(PCIE_RC_RP_ATS_BASE + 0x0004 + ((r) & 0x1f) * 0x0020)
> +		(PCIE_RC_EP_ATR_OB_REGIONS_1_32 + 0x0004 + ((r) & 0x1f) * 0x0020)
>  #define ROCKCHIP_PCIE_AT_OB_REGION_DESC0_HARDCODED_RID	BIT(23)
>  #define ROCKCHIP_PCIE_AT_OB_REGION_DESC0_DEVFN_MASK	GENMASK(31, 24)
>  #define ROCKCHIP_PCIE_AT_OB_REGION_DESC0_DEVFN(devfn) \
>  		(((devfn) << 24) & ROCKCHIP_PCIE_AT_OB_REGION_DESC0_DEVFN_MASK)
>  #define ROCKCHIP_PCIE_AT_OB_REGION_DESC0(r) \
> -		(PCIE_RC_RP_ATS_BASE + 0x0008 + ((r) & 0x1f) * 0x0020)
> +		(PCIE_RC_EP_ATR_OB_REGIONS_1_32 + 0x0008 + ((r) & 0x1f) * 0x0020)
>  #define ROCKCHIP_PCIE_AT_OB_REGION_DESC1(r)	\
> -		(PCIE_RC_RP_ATS_BASE + 0x000c + ((r) & 0x1f) * 0x0020)
> -#define ROCKCHIP_PCIE_AT_OB_REGION_CPU_ADDR0(r) \
> -		(PCIE_RC_RP_ATS_BASE + 0x0018 + ((r) & 0x1f) * 0x0020)
> -#define ROCKCHIP_PCIE_AT_OB_REGION_CPU_ADDR1(r) \
> -		(PCIE_RC_RP_ATS_BASE + 0x001c + ((r) & 0x1f) * 0x0020)
> +		(PCIE_RC_EP_ATR_OB_REGIONS_1_32 + 0x000c + ((r) & 0x1f) * 0x0020)
>  
>  #define ROCKCHIP_PCIE_CORE_EP_FUNC_BAR_CFG0(fn) \
>  		(PCIE_CORE_CTRL_MGMT_BASE + 0x0240 + (fn) * 0x0008)

-- 
Damien Le Moal
Western Digital Research

