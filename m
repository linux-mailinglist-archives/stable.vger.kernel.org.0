Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238976D7BCA
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 13:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237747AbjDELok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 07:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237767AbjDELoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 07:44:39 -0400
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63AD259F5;
        Wed,  5 Apr 2023 04:44:11 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 406A35821F4;
        Wed,  5 Apr 2023 07:43:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 05 Apr 2023 07:43:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1680695018; x=1680698618; bh=BvuQB3YrSy/XsrAgLKIr85mggyxf9SOUTW/
        mTPUnfq4=; b=LZ4LiyiopyJetN+aebdKjNTWDrB9z3MuQ37R6s+1JQb5gXtaNQN
        TtQhZMyeysezVhbINrrJFtk72mPxyLMbtTcT8nY4NJblnwyc4+v/OBtCYPg81+bi
        ymd5P1rOrSJ0zA5X3Fpb+BpwI8+gVADE/wcwhD2Ceq4KwuMvKsbnIyP7lHZiFLaU
        zlhskDYauCnkwzoFgIEPqxYIS9AjngpQT58MaiZrQQChqEq4eu4E6nhS+9LknEq2
        1/NWfb6ub3JVhyTMl6WdFH9mZAqI8R0RHoHJTGVdZivz7WcTqVGxYnE6YBetGT8F
        yvPSGVoNJi03xFUc/NdB1m5aFYAdYBwdGOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=i3db14652.fm2;
         t=1680695018; x=1680698618; bh=BvuQB3YrSy/XsrAgLKIr85mggyxf9SOU
        TW/mTPUnfq4=; b=h+gPM1X9IKsm6KmPXyYAU3qKp1UfxUWsqjmDKWzTq74nL7bL
        WoqUWWrfo9cdC23acx1hgfoxK4dkgjmLN4NJ8nQAZWiYTn5WRhJ4W+IY6DqJRx5n
        oSd1RkQOw+ZZOy9+ImK+u9AGbK8ReBT58VyyOAlgeGzdThpcw+a3hPvLI4GexNcz
        0WatuUVno2t4+ITT6flCxcoDet/gTOG4DGx5y+C1Hd6VwIabzOii6zG9G6jR85QC
        li6Guiz8nhgIy7jhkaiK+gkTTYv0EhMaT9OCIPEAfkecwayrHLWIpIRNOPY0qcZb
        TtUnzyWQIm08wcgTHv5fo6y2K4rRvg5NILLT6w==
X-ME-Sender: <xms:6F4tZBkAKvRQYotVW5W-x7uzCqsuSajY1x8nguexPBFVaVpPKY8lPg>
    <xme:6F4tZM2c-r4dyXFleZcWw001GswYTm3k1vbzw1DcicZa2Qdv5Wg2eQQKi7m92zYjz
    YH0ZStBtWkxPB3Lud4>
X-ME-Received: <xmr:6F4tZHpJ8cNHM3Vi5MtZNc6jzgivDPcqSg8EBWFOgNuxfUmy4Gdzx40IEbspx5iVaStqvDjhNy74clDA92p8H-k5dVPHVm8X>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdejuddggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtfeejnecuhfhrohhmpeffrghm
    ihgvnhcunfgvucfoohgrlhcuoegulhgvmhhorghlsehfrghsthhmrghilhdrtghomheqne
    cuggftrfgrthhtvghrnhepteefiefhieetgfevhfegfeehffetteduieetudfgleetvdff
    udelveejfefhfeejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepughlvghmohgrlhesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:6F4tZBlRGwMdE5g9Juckwn8r_yQRaMjdZ_9hEglceZ1agmQFcWtosw>
    <xmx:6F4tZP3BzYrX33WZIrExKk-w12e6_gcnbLXIR3EcfMyjzyHfiXLpSA>
    <xmx:6F4tZAuDB7Lx5RR5Ae5fryAIKzTzNh7wetTs3Jy_3zfVrMTvH2uYXA>
    <xmx:6V4tZEX3FsEzIZpyLZiAICgyGPg2jht9wTVVVfgS4fn959nIXDbCqXzhz1g>
Feedback-ID: i3db14652:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Apr 2023 07:43:31 -0400 (EDT)
Message-ID: <43be59ed-fd35-b4d3-4dc4-99a6727632e2@fastmail.com>
Date:   Wed, 5 Apr 2023 20:43:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v3 08/11] PCI: rockchip: Fix window mapping and address
 translation for endpoint
Content-Language: en-US
To:     Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        alberto.dassatti@heig-vd.ch
Cc:     damien.lemoal@opensource.wdc.com, xxm@rock-chips.com,
        stable@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Johan Jonker <jbx6244@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Caleb Connolly <kc@postmarketos.org>,
        Arnaud Ferraris <arnaud.ferraris@collabora.com>,
        Judy Hsiao <judyhsiao@chromium.org>,
        Lin Huang <hl@rock-chips.com>,
        Hugh Cole-Baker <sigmaris@gmail.com>,
        linux-pci@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20230404082426.3880812-1-rick.wertenbroek@gmail.com>
 <20230404082426.3880812-9-rick.wertenbroek@gmail.com>
From:   Damien Le Moal <dlemoal@fastmail.com>
In-Reply-To: <20230404082426.3880812-9-rick.wertenbroek@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/4/23 17:24, Rick Wertenbroek wrote:
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
>  drivers/pci/controller/pcie-rockchip-ep.c | 110 +++++++++-------------
>  drivers/pci/controller/pcie-rockchip.h    |  30 +++---
>  2 files changed, 64 insertions(+), 76 deletions(-)
> 
> diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
> index 7591a7be78e0..f366846ad77c 100644
> --- a/drivers/pci/controller/pcie-rockchip-ep.c
> +++ b/drivers/pci/controller/pcie-rockchip-ep.c
> @@ -64,52 +64,30 @@ static void rockchip_pcie_clear_ep_ob_atu(struct rockchip_pcie *rockchip,
>  }
>  
>  static void rockchip_pcie_prog_ep_ob_atu(struct rockchip_pcie *rockchip, u8 fn,
> -					 u32 r, u32 type, u64 cpu_addr,
> -					 u64 pci_addr, size_t size)
> +					 u32 r, u64 cpu_addr, u64 pci_addr,
> +					 size_t size)
>  {
>  	u64 sz = 1ULL << fls64(size - 1);
>  	int num_pass_bits = ilog2(sz);
> -	u32 addr0, addr1, desc0, desc1;
> -	bool is_nor_msg = (type == AXI_WRAPPER_NOR_MSG);
> +	u32 addr0, addr1, desc0;
>  
> -	/* The minimal region size is 1MB */
>  	if (num_pass_bits < 8)
>  		num_pass_bits = 8;
>  
> -	cpu_addr -= rockchip->mem_res->start;
> -	addr0 = ((is_nor_msg ? 0x10 : (num_pass_bits - 1)) &
> -		PCIE_CORE_OB_REGION_ADDR0_NUM_BITS) |
> -		(lower_32_bits(cpu_addr) & PCIE_CORE_OB_REGION_ADDR0_LO_ADDR);
> -	addr1 = upper_32_bits(is_nor_msg ? cpu_addr : pci_addr);
> -	desc0 = ROCKCHIP_PCIE_AT_OB_REGION_DESC0_DEVFN(fn) | type;
> -	desc1 = 0;
> -
> -	if (is_nor_msg) {
> -		rockchip_pcie_write(rockchip, 0,
> -				    ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0(r));
> -		rockchip_pcie_write(rockchip, 0,
> -				    ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR1(r));
> -		rockchip_pcie_write(rockchip, desc0,
> -				    ROCKCHIP_PCIE_AT_OB_REGION_DESC0(r));
> -		rockchip_pcie_write(rockchip, desc1,
> -				    ROCKCHIP_PCIE_AT_OB_REGION_DESC1(r));
> -	} else {
> -		/* PCI bus address region */
> -		rockchip_pcie_write(rockchip, addr0,
> -				    ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0(r));
> -		rockchip_pcie_write(rockchip, addr1,
> -				    ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR1(r));
> -		rockchip_pcie_write(rockchip, desc0,
> -				    ROCKCHIP_PCIE_AT_OB_REGION_DESC0(r));
> -		rockchip_pcie_write(rockchip, desc1,
> -				    ROCKCHIP_PCIE_AT_OB_REGION_DESC1(r));
> -
> -		addr0 =
> -		    ((num_pass_bits - 1) & PCIE_CORE_OB_REGION_ADDR0_NUM_BITS) |
> -		    (lower_32_bits(cpu_addr) &
> -		     PCIE_CORE_OB_REGION_ADDR0_LO_ADDR);
> -		addr1 = upper_32_bits(cpu_addr);
> -	}
> +	addr0 = ((num_pass_bits - 1) & PCIE_CORE_OB_REGION_ADDR0_NUM_BITS) |
> +		(lower_32_bits(pci_addr) & PCIE_CORE_OB_REGION_ADDR0_LO_ADDR);
> +	addr1 = upper_32_bits(pci_addr);
> +	desc0 = ROCKCHIP_PCIE_AT_OB_REGION_DESC0_DEVFN(fn) | AXI_WRAPPER_MEM_WRITE;
> +
> +	/* PCI bus address region */
> +	rockchip_pcie_write(rockchip, addr0,
> +			    ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0(r));
> +	rockchip_pcie_write(rockchip, addr1,
> +			    ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR1(r));
> +	rockchip_pcie_write(rockchip, desc0,
> +			    ROCKCHIP_PCIE_AT_OB_REGION_DESC0(r));
> +	rockchip_pcie_write(rockchip, 0,
> +			    ROCKCHIP_PCIE_AT_OB_REGION_DESC1(r));
>  }
>  
>  static int rockchip_pcie_ep_write_header(struct pci_epc *epc, u8 fn, u8 vfn,
> @@ -248,6 +226,11 @@ static void rockchip_pcie_ep_clear_bar(struct pci_epc *epc, u8 fn, u8 vfn,
>  			    ROCKCHIP_PCIE_AT_IB_EP_FUNC_BAR_ADDR1(fn, bar));
>  }
>  
> +static inline u32 rockchip_ob_region(phys_addr_t addr)
> +{
> +	return (addr >> ilog2(SZ_1M)) & 0x1f;
> +}
> +
>  static int rockchip_pcie_ep_map_addr(struct pci_epc *epc, u8 fn, u8 vfn,
>  				     phys_addr_t addr, u64 pci_addr,
>  				     size_t size)
> @@ -256,18 +239,9 @@ static int rockchip_pcie_ep_map_addr(struct pci_epc *epc, u8 fn, u8 vfn,
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
> +	r = rockchip_ob_region(addr);

Nit: you can move this together with the decalration:

	u32 r = rockchip_ob_region(addr);

>  
> -	rockchip_pcie_prog_ep_ob_atu(pcie, fn, r, AXI_WRAPPER_MEM_WRITE, addr,
> -				     pci_addr, size);
> +	rockchip_pcie_prog_ep_ob_atu(pcie, fn, r, addr, pci_addr, size);
>  
>  	set_bit(r, &ep->ob_region_map);
>  	ep->ob_addr[r] = addr;
> @@ -282,15 +256,11 @@ static void rockchip_pcie_ep_unmap_addr(struct pci_epc *epc, u8 fn, u8 vfn,
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
> @@ -388,6 +358,7 @@ static int rockchip_pcie_ep_send_msi_irq(struct rockchip_pcie_ep *ep, u8 fn,
>  	u16 flags, mme, data, data_mask;
>  	u8 msi_count;
>  	u64 pci_addr, pci_addr_mask = 0xff;

Nit: pci_addr_mask is constant and never changed, so we could get rid of this
variable and use a macro instead.

> +	u32 r;
>  
>  	/* Check MSI enable bit */
>  	flags = rockchip_pcie_read(&ep->rockchip,
> @@ -421,13 +392,12 @@ static int rockchip_pcie_ep_send_msi_irq(struct rockchip_pcie_ep *ep, u8 fn,
>  				       ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
>  				       ROCKCHIP_PCIE_EP_MSI_CTRL_REG +
>  				       PCI_MSI_ADDRESS_LO);
> -	pci_addr &= GENMASK_ULL(63, 2);
>  
>  	/* Set the outbound region if needed. */
>  	if (unlikely(ep->irq_pci_addr != (pci_addr & ~pci_addr_mask) ||
>  		     ep->irq_pci_fn != fn)) {
> -		rockchip_pcie_prog_ep_ob_atu(rockchip, fn, ep->max_regions - 1,
> -					     AXI_WRAPPER_MEM_WRITE,
> +		r = rockchip_ob_region(ep->irq_phys_addr);
> +		rockchip_pcie_prog_ep_ob_atu(rockchip, fn, r,
>  					     ep->irq_phys_addr,
>  					     pci_addr & ~pci_addr_mask,
>  					     pci_addr_mask + 1);
> @@ -516,6 +486,8 @@ static int rockchip_pcie_parse_ep_dt(struct rockchip_pcie *rockchip,
>  	if (err < 0 || ep->max_regions > MAX_REGION_LIMIT)
>  		ep->max_regions = MAX_REGION_LIMIT;
>  
> +	ep->ob_region_map = 0;
> +
>  	err = of_property_read_u8(dev->of_node, "max-functions",
>  				  &ep->epc->max_functions);
>  	if (err < 0)
> @@ -536,7 +508,8 @@ static int rockchip_pcie_ep_probe(struct platform_device *pdev)
>  	struct rockchip_pcie *rockchip;
>  	struct pci_epc *epc;
>  	size_t max_regions;
> -	int err;
> +	struct pci_epc_mem_window *windows = NULL;
> +	int err, i;
>  
>  	ep = devm_kzalloc(dev, sizeof(*ep), GFP_KERNEL);
>  	if (!ep)
> @@ -583,15 +556,26 @@ static int rockchip_pcie_ep_probe(struct platform_device *pdev)
>  	/* Only enable function 0 by default */
>  	rockchip_pcie_write(rockchip, BIT(0), PCIE_CORE_PHY_FUNC_CFG);
>  
> -	err = pci_epc_mem_init(epc, rockchip->mem_res->start,
> -			       resource_size(rockchip->mem_res), PAGE_SIZE);
> +	windows = devm_kcalloc(dev, ep->max_regions, sizeof(struct pci_epc_mem_window), GFP_KERNEL);

Nit: long line. Please split it at sizeof(...).

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
>  	if (!ep->irq_cpu_addr) {
>  		dev_err(dev, "failed to reserve memory space for MSI\n");
>  		err = -ENOMEM;
> diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
> index ffc68a3a5fee..5797ba73bb6b 100644
> --- a/drivers/pci/controller/pcie-rockchip.h
> +++ b/drivers/pci/controller/pcie-rockchip.h
> @@ -139,6 +139,7 @@
>  
>  #define PCIE_RC_RP_ATS_BASE		0x400000
>  #define PCIE_RC_CONFIG_NORMAL_BASE	0x800000
> +#define PCIE_EP_PF_CONFIG_REGS_BASE	0x800000
>  #define PCIE_RC_CONFIG_BASE		0xa00000
>  #define PCIE_EP_CONFIG_BASE		0xa00000
>  #define PCIE_EP_CONFIG_DID_VID		(PCIE_EP_CONFIG_BASE + 0x00)
> @@ -232,13 +233,15 @@
>  #define   ROCKCHIP_PCIE_EP_MSI_CTRL_ME				BIT(16)
>  #define   ROCKCHIP_PCIE_EP_MSI_CTRL_MASK_MSI_CAP	BIT(24)
>  #define ROCKCHIP_PCIE_EP_DUMMY_IRQ_ADDR				0x1
> -#define ROCKCHIP_PCIE_EP_FUNC_BASE(fn)	(((fn) << 12) & GENMASK(19, 12))
> +#define ROCKCHIP_PCIE_EP_PCI_LEGACY_IRQ_ADDR		0x3
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
> @@ -246,20 +249,21 @@
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
> -#define ROCKCHIP_PCIE_AT_OB_REGION_DESC1(r)	\
> -		(PCIE_RC_RP_ATS_BASE + 0x000c + ((r) & 0x1f) * 0x0020)
> -#define ROCKCHIP_PCIE_AT_OB_REGION_CPU_ADDR0(r) \
> -		(PCIE_RC_RP_ATS_BASE + 0x0018 + ((r) & 0x1f) * 0x0020)
> -#define ROCKCHIP_PCIE_AT_OB_REGION_CPU_ADDR1(r) \
> -		(PCIE_RC_RP_ATS_BASE + 0x001c + ((r) & 0x1f) * 0x0020)
> +		(PCIE_RC_EP_ATR_OB_REGIONS_1_32 + 0x0008 + ((r) & 0x1f) * 0x0020)
> +#define ROCKCHIP_PCIE_AT_OB_REGION_DESC1(r) \
> +		(PCIE_RC_EP_ATR_OB_REGIONS_1_32 + 0x000c + ((r) & 0x1f) * 0x0020)
> +#define ROCKCHIP_PCIE_AT_OB_REGION_DESC2(r) \
> +		(PCIE_RC_EP_ATR_OB_REGIONS_1_32 + 0x0010 + ((r) & 0x1f) * 0x0020)
>  
>  #define ROCKCHIP_PCIE_CORE_EP_FUNC_BAR_CFG0(fn) \
>  		(PCIE_CORE_CTRL_MGMT_BASE + 0x0240 + (fn) * 0x0008)

