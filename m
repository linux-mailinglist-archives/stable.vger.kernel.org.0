Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E026972FC
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 02:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjBOBBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 20:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjBOBBN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 20:01:13 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB7D2CC7D
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 17:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676422872; x=1707958872;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XOcFePDBSO8jCjv36R6D31rgCgrBpc9VWxAmEMfwpY4=;
  b=lD9CbTvhFZ2QSaECtzY02pgJzM+prUnU/ikAj5DkFoTUsROnfCPGcI9L
   fcbu2A140NsRzzculROqnzD/AqObmMCm+nGGYlQwUlnRz2tksdORjTCX4
   wMGi05SXE+fH/E0voMUB8HjPBNEGUIN1nffxfhzV0x8enBOHQfslIgIr7
   l58JJRtjnUix300eR7ryuRPf8iQymzD4EVUsXY/JeEEOqSR3ESOAilpPk
   0J1ensvGATPqaqMN02/hZ807UxYioyj73Zjbx21zSFo2+jiC+XQZFsMce
   UVsz4DMcfXlPWl664YcccGTSbG1KIdsHi0cpJ/ZUilwPqyGM1cxls90za
   g==;
X-IronPort-AV: E=Sophos;i="5.97,298,1669046400"; 
   d="scan'208";a="327619726"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 Feb 2023 09:01:10 +0800
IronPort-SDR: OcDkt2FTmlsxrA0XoEk6bddrVMGUVjK/zlyJUaMu5/1/1D+7t6Dne0McG0VheH0o8KxBWKqzQT
 FERk32x8YKLqM0RGnrjaMnMvaU54Beo8qnZIdtXW8fLbUWdvjUFG871YTe8lt6UAEQ10ZUMpM2
 cQEAJ7qg1G7ECULqD37n10xV9WMN80uiJfZ0iJv7XF93fbwu7zk05xLIUHku6Je10uEYU2nUFv
 SiYM4PhLSxYydo9HEHrSiJpVNyWTXme9E0tloB2YPLlDVohyPmGVy4uG6j6mjT9MVtehWIG+fW
 WJU=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Feb 2023 16:12:33 -0800
IronPort-SDR: APOeJCxWKANdxdidGZVtDrNG/Ufa6AXbgVealUkfH+5PDvs28rvkRTm6eKBf5U64dv+EjlH+Zc
 NDRE3zzWnvXUH+pTmEFcKsG/IRnSogefgIY6PyO38G+3i6I9xJNn1jfwC+bvTslzuIcgyCjdYP
 kRHlfNE7JrkHM22OsARQzx9kYGRlIQ3fqSKoECYlncUUDz4nqUyFWBkzbWfr1O44786Xw3F8eT
 HMMrnF6883UYpkK4yTbN7QrSfORJ6gt82Q0/31uL5VVDQCTLwJrv322edHmK+8GHstM1MdRaX0
 coc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Feb 2023 17:01:11 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PGfsL0F66z1RvTr
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 17:01:10 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1676422869; x=1679014870; bh=XOcFePDBSO8jCjv36R6D31rgCgrBpc9VWxA
        mEMfwpY4=; b=g9OAh1PTS4j+gfOKiSens72909lxwsdQLYgCJAKgZx5btvjzMpv
        xBtobrS5T4zpeiJgXrHCBwU8q3Q1/LbPI4fbuOn84IlfJt5fFDCzCuOX9GYLIhiL
        nuSF5xbe5srz5coiwv4GHRvfVxoNyj1Ya45OOCgPSam16BMcP47Lcw9egmopZ2Ow
        swDZgkgeyBK99EzAkPJspzdaf91BrU3cNQcG6MD2GY6yDARx9HGRCDiWaMhrwjPq
        EOogCKcKEiRV32r9stdMMoxyOSsrDcget1gte/MhnliKo5bE/m9oDSlu3gPYw2vG
        8O9D8xZI6qL6LnkbzmI1ZQZ//ZcthZf4LFg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Qs39Oj24GoLR for <stable@vger.kernel.org>;
        Tue, 14 Feb 2023 17:01:09 -0800 (PST)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PGfsD4tpXz1RvLy;
        Tue, 14 Feb 2023 17:01:04 -0800 (PST)
Message-ID: <adfcf9a9-8607-9778-1c83-de0092c70e0b@opensource.wdc.com>
Date:   Wed, 15 Feb 2023 10:01:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 4/9] PCI: rockchip: Add poll and timeout to wait for
 PHY PLLs to be locked
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Mikko Kovanen <mikko.kovanen@aavamobile.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20230214140858.1133292-1-rick.wertenbroek@gmail.com>
 <20230214140858.1133292-5-rick.wertenbroek@gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230214140858.1133292-5-rick.wertenbroek@gmail.com>
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
> The RK3399 PCIe controller should wait until the PHY PLLs are locked.
> Add poll and timeout to wait for PHY PLLs to be locked. If they cannot
> be locked generate error message and jump to error handler. Accessing
> registers in the PHY clock domain when PLLs are not locked causes hang
> The PHY PLLs status is checked through a side channel register.
> This is documented in the TRM section 17.5.8.1 "PCIe Initialization
> Sequence".
> 
> Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>

A couple of nits below. Otherwise:

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/pci/controller/pcie-rockchip.c | 16 ++++++++++++++++
>  drivers/pci/controller/pcie-rockchip.h |  2 ++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/drivers/pci/controller/pcie-rockchip.c b/drivers/pci/controller/pcie-rockchip.c
> index 990a00e08..5f2e2dd5d 100644
> --- a/drivers/pci/controller/pcie-rockchip.c
> +++ b/drivers/pci/controller/pcie-rockchip.c

[...]

> +	err = readx_poll_timeout(rockchip_pcie_read_addr, PCIE_CLIENT_SIDE_BAND_STATUS,

Nit: long line. Split it after the first comma.

> +		regs, !(regs & PCIE_CLIENT_PHY_ST), RK_PHY_PLL_LOCK_SLEEP_US,
> +		RK_PHY_PLL_LOCK_TIMEOUT_US);
> +

Nit: no need for this blank line.

> +	if (err) {
> +		dev_err(dev, "PHY PLLs could not lock, %d\n", err);
> +		goto err_power_off_phy;
> +	}
> +

-- 
Damien Le Moal
Western Digital Research

