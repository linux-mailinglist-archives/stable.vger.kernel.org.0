Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1B669739C
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 02:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbjBOB1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 20:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233601AbjBOB1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 20:27:22 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB6310E5
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 17:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676424437; x=1707960437;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rvloK5ngdtPCbJug6sOHC6AFBm+SqF5jOZbIHY27apo=;
  b=M91P0GY+TVNgIT6QSYw0Z0aSbk8PMGL7dbRHsc7MSJgHafIsww9YGf2L
   l5GeckeSG5xws79rRR7GtJfiPJ2YoExBA2t9oYdVafV4l3f1geJdfrk+u
   0irU9JQ89TJBVzgVRCb25dkfaFXMLoawweUfKJ8yV4RtHt1lLI90osvzH
   xYr5Z2hKp5Oq624iqgxsM1eXzYr6aK50ELPjAdc66Xti9p4x61DgK7LsF
   GjhHApEc5Q7lGiGQQyYXo4wDoLRZXCFMktG4Nl0eP5UiTZl2JIe3M1dcV
   wVwSznH5F8ea215yQha52dBd+fYT+lOe0RhUIz0bn2/rsMkDK50UycQf1
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,298,1669046400"; 
   d="scan'208";a="221622430"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Feb 2023 09:26:59 +0800
IronPort-SDR: ekXF9boOoWtCi8hpVC82si12LFWEPwxBLs4lVHLX/TuZ7mifEg93sbZJ6FcPH9u0iwPJNKxYcb
 RuXY3TZferjuG9DUKwavu1GMpRZsbnLcApL3gLKabKM6OoIS2ltKmQSuWe753TByQ185In4owc
 nXnwfdL/FAIvrimNfNld0X/ZQCJW0B6eqbnkw0bU/ivBpsUN+hIoQVJCwOZOFULdCT0zML8DkQ
 vbFaDcSLFMSBq0cT9mW7uILaw7sPOZ8HfxK/ZamDwFVuEQ3wGR83mDKWYcetKyuDUBbnYTYAAg
 61M=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Feb 2023 16:44:06 -0800
IronPort-SDR: KweVwnKxOKzzkyQ2dUpbi/bsKGXfsphVDMeCyXdF5Frc64sKfAFIpeiKtRKuwgEJYtXPtEWTCH
 GSk3dJ5QYoBzFPghMR82s+vJai82EapALzuM9JTckC8P7vLPRd0zNq6YLm7eDt+E+HsxIIc6CT
 LCEyMTGSS6btdO97JL9BaX13qz4Qf3+6o6VVOIz08HnAwKBTKDdUh1KYcAEVbxJ9TAWkmVeRI/
 SOlS30P+3qXaTbCGcpOHLZOL4ErLWtbE8+KPxJIF7QCbn+Ahg8eIFmqCWx4dn1AimFoM0sGtl9
 W5Q=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Feb 2023 17:26:59 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PGgR72nSHz1RwtC
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 17:26:59 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1676424418; x=1679016419; bh=rvloK5ngdtPCbJug6sOHC6AFBm+SqF5jOZb
        IHY27apo=; b=RiUGci4jJPLDnaL6Wz2odgJJGHVsbeJAK0Lls1IV8wbUr5jIpnH
        nIlPJUrM5ayO54B5P7U2fvAPYb3FLBkfykpJTHOj8+Pto9lUYh+JB9Wj75WsZr2O
        o2AxqpDBYOQ90GTYIt19/wqmbRl/z6LQxe4r2fTwRNibUudjSNZSkjL3SGt3tyme
        8nCGnzaeAunk2AYReIvEdSoPepM5Eak995J1ftaW1+/GybSjkjswI9tvGGeDgFiz
        dJKajljkserVn3kodNfDIyEGj0W7dQ2fI9RirWyJMb1KT70bd3kFtCrcRY2wPGsJ
        5ao8IwiT4NawfJpzR+rVwShVdNscy+zOaSA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LeO-GXB10uFm for <stable@vger.kernel.org>;
        Tue, 14 Feb 2023 17:26:58 -0800 (PST)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PGgR14p3Jz1RvLy;
        Tue, 14 Feb 2023 17:26:53 -0800 (PST)
Message-ID: <67d08dce-4610-5e34-853a-1d09c5389607@opensource.wdc.com>
Date:   Wed, 15 Feb 2023 10:26:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 7/9] PCI: rockchip: Fix legacy IRQ generation for
 RK3399 PCIe endpoint core
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
        Mikko Kovanen <mikko.kovanen@aavamobile.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20230214140858.1133292-1-rick.wertenbroek@gmail.com>
 <20230214140858.1133292-8-rick.wertenbroek@gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230214140858.1133292-8-rick.wertenbroek@gmail.com>
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
> Fix legacy IRQ generation for RK3399 PCIe endpoint core according to
> the technical reference manual (TRM). Assert and deassert legacy
> interrupt (INTx) through the legacy interrupt control register
> ("PCIE_CLIENT_LEGACY_INT_CTRL") instead of manually generating a PCIe
> message. The generation of the legacy interrupt was tested and validated
> with the PCIe endpoint test driver.
> 
> Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>

Some nits below. But otherwise works fine for me.

> ---
>  drivers/pci/controller/pcie-rockchip-ep.c | 38 +++++------------------
>  drivers/pci/controller/pcie-rockchip.h    |  6 ++++
>  2 files changed, 14 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
> index cbc281a6a..ca5b363ba 100644
> --- a/drivers/pci/controller/pcie-rockchip-ep.c
> +++ b/drivers/pci/controller/pcie-rockchip-ep.c
> @@ -328,45 +328,23 @@ static void rockchip_pcie_ep_assert_intx(struct rockchip_pcie_ep *ep, u8 fn,
>  					 u8 intx, bool is_asserted)
>  {
>  	struct rockchip_pcie *rockchip = &ep->rockchip;
> -	u32 r = ep->max_regions - 1;
> -	u32 offset;
> -	u32 status;
> -	u8 msg_code;
> -
> -	if (unlikely(ep->irq_pci_addr != ROCKCHIP_PCIE_EP_PCI_LEGACY_IRQ_ADDR ||
> -		     ep->irq_pci_fn != fn)) {
> -		rockchip_pcie_prog_ep_ob_atu(rockchip, fn, r,
> -					     AXI_WRAPPER_NOR_MSG,
> -					     ep->irq_phys_addr, 0, 0);
> -		ep->irq_pci_addr = ROCKCHIP_PCIE_EP_PCI_LEGACY_IRQ_ADDR;
> -		ep->irq_pci_fn = fn;
> -	}
>  
>  	intx &= 3;
>  	if (is_asserted) {
>  		ep->irq_pending |= BIT(intx);
> -		msg_code = ROCKCHIP_PCIE_MSG_CODE_ASSERT_INTA + intx;
>  	} else {
>  		ep->irq_pending &= ~BIT(intx);
> -		msg_code = ROCKCHIP_PCIE_MSG_CODE_DEASSERT_INTA + intx;
>  	}
>  
> -	status = rockchip_pcie_read(rockchip,
> -				    ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
> -				    ROCKCHIP_PCIE_EP_CMD_STATUS);
> -	status &= ROCKCHIP_PCIE_EP_CMD_STATUS_IS;
> -
> -	if ((status != 0) ^ (ep->irq_pending != 0)) {
> -		status ^= ROCKCHIP_PCIE_EP_CMD_STATUS_IS;
> -		rockchip_pcie_write(rockchip, status,
> -				    ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
> -				    ROCKCHIP_PCIE_EP_CMD_STATUS);
> +	if (is_asserted) {
> +		rockchip_pcie_write(rockchip,
> +			PCIE_CLIENT_INT_IN_ASSERT | PCIE_CLIENT_INT_PEND_ST_PEND,
> +			PCIE_CLIENT_LEGACY_INT_CTRL);
> +	} else {
> +		rockchip_pcie_write(rockchip,
> +			PCIE_CLIENT_INT_IN_DEASSERT | PCIE_CLIENT_INT_PEND_ST_NORMAL,
> +			PCIE_CLIENT_LEGACY_INT_CTRL);
>  	}

With this change, you have now twice "if (is_asserted) {", which is not
necessary. You can simplify the code a bit:

static void rockchip_pcie_ep_assert_intx(struct rockchip_pcie_ep *ep,
					 u8 fn, u8 intx, bool do_assert)
{

        u8 msg_code;



        intx &= 3;

        if (do_assert) {

                ep->irq_pending |= BIT(intx);

                msg_code = ROCKCHIP_PCIE_MSG_CODE_ASSERT_INTA + intx;

                rockchip_pcie_write(&ep->rockchip,

                        PCIE_CLIENT_INT_IN_ASSERT |

                        PCIE_CLIENT_INT_PEND_ST_PEND,

                        PCIE_CLIENT_LEGACY_INT_CTRL);

                return;

        }



        ep->irq_pending &= ~BIT(intx);

        msg_code = ROCKCHIP_PCIE_MSG_CODE_DEASSERT_INTA + intx;

        rockchip_pcie_write(&ep->rockchip,

                            PCIE_CLIENT_INT_IN_DEASSERT |

                            PCIE_CLIENT_INT_PEND_ST_NORMAL,

                            PCIE_CLIENT_LEGACY_INT_CTRL);

}

Note also the renaming of the argument "is_asserted" to "do_assert". The
name is_asserted is badly misleading considering the english meaning given
that it is true when we *must* do the assert and false when we must
deassert. So do_assert as a name better match the use of that argument I
think.

> -
> -	offset =
> -	   ROCKCHIP_PCIE_MSG_ROUTING(ROCKCHIP_PCIE_MSG_ROUTING_LOCAL_INTX) |
> -	   ROCKCHIP_PCIE_MSG_CODE(msg_code) | ROCKCHIP_PCIE_MSG_NO_DATA;
> -	writel(0, ep->irq_cpu_addr + offset);
>  }
>  
>  static int rockchip_pcie_ep_send_legacy_irq(struct rockchip_pcie_ep *ep, u8 fn,
> diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
> index 72e427a0f..e90c2a2b8 100644
> --- a/drivers/pci/controller/pcie-rockchip.h
> +++ b/drivers/pci/controller/pcie-rockchip.h
> @@ -39,6 +39,12 @@
>  #define   PCIE_CLIENT_GEN_SEL_1		  HIWORD_UPDATE(0x0080, 0)
>  #define   PCIE_CLIENT_GEN_SEL_2		  HIWORD_UPDATE_BIT(0x0080)
>  #define PCIE_CLIENT_SIDE_BAND_STATUS	(PCIE_CLIENT_BASE + 0x20)
> +#define PCIE_CLIENT_LEGACY_INT_CTRL		(PCIE_CLIENT_BASE + 0x0c)
> +#define   PCIE_CLIENT_INT_IN_ASSERT		HIWORD_UPDATE_BIT(0x0002)
> +#define   PCIE_CLIENT_INT_IN_DEASSERT	HIWORD_UPDATE(0x0002, 0)
> +#define   PCIE_CLIENT_INT_PEND_ST_PEND	HIWORD_UPDATE_BIT(0x0001)
> +#define   PCIE_CLIENT_INT_PEND_ST_NORMAL	HIWORD_UPDATE(0x0001, 0)
> +#define PCIE_CLIENT_SIDE_BAND_STATUS	(PCIE_CLIENT_BASE + 0x20)
>  #define   PCIE_CLIENT_PHY_ST			BIT(12)
>  #define PCIE_CLIENT_DEBUG_OUT_0		(PCIE_CLIENT_BASE + 0x3c)
>  #define   PCIE_CLIENT_DEBUG_LTSSM_MASK		GENMASK(5, 0)

-- 
Damien Le Moal
Western Digital Research

