Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631F02E7EC2
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 09:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgLaIut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Dec 2020 03:50:49 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:35304 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgLaIut (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Dec 2020 03:50:49 -0500
Date:   Thu, 31 Dec 2020 11:49:56 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>,
        Mark Brown <broonie@kernel.org>, <linux-spi@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 134/717] spi: dw: fix build error by selecting
 MULTIPLEXER
Message-ID: <20201231084956.ckobqvr5mdpcdxkc@mobilestation>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125027.369952724@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201228125027.369952724@linuxfoundation.org>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,
The next patch has been created to supersede the one you've applied:
https://lore.kernel.org/linux-spi/20201127144612.4204-1-Sergey.Semin@baikalelectronics.ru/
Mark has already merged it in his repo.

-Sergey

On Mon, Dec 28, 2020 at 01:42:12PM +0100, Greg Kroah-Hartman wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> [ Upstream commit 1241f0787578136ab58f49adc52f2dcd2bbc4bf2 ]
> 
> Fix build error for spi-dw-bt1.o by selecting MULTIPLEXER.
> 
> hppa-linux-ld: drivers/spi/spi-dw-bt1.o: in function `dw_spi_bt1_sys_init':
> (.text+0x1ac): undefined reference to `devm_mux_control_get'
> 
> Fixes: abf00907538e ("spi: dw: Add Baikal-T1 SPI Controller glue driver")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> Cc: Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: linux-spi@vger.kernel.org
> Acked-by: Serge Semin <fancer.lancer@gmail.com>
> Link: https://lore.kernel.org/r/20201116040721.8001-1-rdunlap@infradead.org
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/spi/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> index 5cff60de8e834..3fd16b7f61507 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -255,6 +255,7 @@ config SPI_DW_MMIO
>  config SPI_DW_BT1
>  	tristate "Baikal-T1 SPI driver for DW SPI core"
>  	depends on MIPS_BAIKAL_T1 || COMPILE_TEST
> +	select MULTIPLEXER
>  	help
>  	  Baikal-T1 SoC is equipped with three DW APB SSI-based MMIO SPI
>  	  controllers. Two of them are pretty much normal: with IRQ, DMA,
> -- 
> 2.27.0
> 
> 
> 
