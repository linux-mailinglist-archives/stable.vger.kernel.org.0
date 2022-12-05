Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1276D642973
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 14:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiLENdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 08:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiLENdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 08:33:35 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23A31B78C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 05:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670247212; x=1701783212;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=brZP2Eehwy65iHt2g14GyYW5+nJrURIwIsnqJsB6bQA=;
  b=FW50F+8P3lcpWOh6mrP5SpxTcIVrTUY9pHmVhzlt6gBrC2KF2N279dYT
   RGaSjd6jaeptxg6eYfztP+k2rwzAK8zM1GAulBnZLDLW/4zrpCbsDgC6W
   jNXO6woBZIOGUYd2uGCa1iLixSdPv+ys/ISMiEe2iZJDurj/N2juWoyGN
   ed2YmLs09A6NP8sUvbp0CBB8f56P0vkLhxo1fuyx5Ueb7Xlkxote+cDxA
   C2l7qTbjrklKcpJCSn0L5aActY5Mc1RCrXr1NtjMRauQjuQNijJqljJJb
   2MGg2EEHUvNVSi9qcXeAHjvdLn/bAdoPMwyrzTMdeV5lh3ZW4u7MWdasw
   g==;
X-IronPort-AV: E=Sophos;i="5.96,219,1665417600"; 
   d="scan'208";a="216142953"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 05 Dec 2022 21:33:30 +0800
IronPort-SDR: z8jvUfI87Sx6PmFJ/ofrvX9UWx+hM+oO6v7wxphYBFlSkkGzw5OFWh1zN3KCHBx/BAuu8qpb9z
 Yg7e125ywGzf6lcF5+8ICAIIbIyqo4RH3KtisqRnyJdx2EwuVGqvty7+PDj66m2HJUZSWVN6GE
 0eyd9WfEGVYByJ2iY+DCmBukEFY9kgNRknddPgVDiDVnNq1LvSUaQUhfnumBgJlk/vVjggbowQ
 /J3LqRmKWBooy5fsWFzQwWdUDre95JEbPIpY3dBNxlOQs81EHKLEKuzwYrqD1eG7ApJpiN8jwa
 WCk=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Dec 2022 04:52:04 -0800
IronPort-SDR: sbJ7QhlqL7qzmdVaLZ06pObVbil8xFLfbjVcFsFoepJFmbdTAXhC9sC8MgbZ9h6SUNxZFUgC3V
 s1gEG3iDbxDKFiRW/Vsw086qZhMnsIVeBLRxoeMFMBqTbiBxZgKSaDpIx9Vw1Aa6oPG+L3dfer
 uiZefeF8sJkYTocymmhR6sQ4hAzDHpllTpKPzNtVpfYWfdn7XeJ9YMvnSxOqzTGyWKw7kGTRMs
 KIoRjnSiwMetT/J4BDExuKj3IPsyO6Atkb9QplEsROuuj3/+pYFqCppyYyakTorPdjV8AM75Wc
 4Ow=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Dec 2022 05:33:31 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NQkyf6N6lz1RwqL
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 05:33:30 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1670247208; x=1672839209; bh=brZP2Eehwy65iHt2g14GyYW5+nJrURIwIsn
        qJsB6bQA=; b=qLHiarRbxxEIqw2X2bDLlxEWvr1wSPHAzD6uzTsSDO2jKEXymT2
        MSB+K13I0rO2JbVsUM60h+mCHZGnsLQMiG87ZUHc5hQDk9jPpzCvoBCfB3mpzvrd
        7JFAe8vMJCtrIfqRZjkdWk/h1YbuWtluNY0ZAWnQDrOlZQ7LpVPpIsWbTuLvlK61
        iRoKIexAIXbrYPbxO+45tJKiKrskXCs763Fy0E5hVr2vuPppUiO6FXMojDFBEpnd
        O0bimIAB9WcSgY0xCLYpoFFsFSXv4NBHWY1qItT9gn6Z+1qJNsdxskiWZXJqfICN
        EjamRi+yP6YYe3jvt1XI56d4W+eO8RqShXw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jK8d3Rx4XAsX for <stable@vger.kernel.org>;
        Mon,  5 Dec 2022 05:33:28 -0800 (PST)
Received: from [10.225.163.74] (unknown [10.225.163.74])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NQkyb2Cv5z1RvLy;
        Mon,  5 Dec 2022 05:33:27 -0800 (PST)
Message-ID: <caa0e7a8-f222-b190-12a6-a36996affee2@opensource.wdc.com>
Date:   Mon, 5 Dec 2022 22:33:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] [v2] ata: ahci: fix enum constants for gcc-13
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luis Machado <luis.machado@arm.com>, linux-ide@vger.kernel.org,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
References: <20221203105425.180641-1-arnd@kernel.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221203105425.180641-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/3/22 19:54, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc-13 slightly changes the type of constant expressions that are defined
> in an enum, which triggers a compile time sanity check in libata:
> 
> linux/drivers/ata/libahci.c: In function 'ahci_led_store':
> linux/include/linux/compiler_types.h:357:45: error: call to '__compiletime_assert_302' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
> 357 | _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> 
> The new behavior is that sizeof() returns the same value for the
> constant as it does for the enum type, which is generally more sensible
> and consistent.
> 
> The problem in libata is that it contains a single enum definition for
> lots of unrelated constants, some of which are large positive (unsigned)
> integers like 0xffffffff, while others like (1<<31) are interpreted as
> negative integers, and this forces the enum type to become 64 bit wide
> even though most constants would still fit into a signed 32-bit 'int'.
> 
> Fix this by changing the entire enum definition to use BIT(x) in place
> of (1<<x), which results in all values being seen as 'unsigned' and
> fitting into an unsigned 32-bit type.
> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=107917
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=107405
> Reported-by: Luis Machado <luis.machado@arm.com>
> Cc: linux-ide@vger.kernel.org
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: stable@vger.kernel.org
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks all good to me. One nit: for the PORT_CMD_ICC_XXX definitions, we
could use GENMASK() to be consistant with the use of BIT(), no ? Not a big
deal though.

> ---
> Luis, I don't have gcc-13 installed on the machine I used for
> creating this patch, can you give this a spin and see if it
> addresses the build failure?

Luis, if you test/review, please send Tested-by/Reviewed-by tags !

> 
> v2 changes:
>  - fix typos in changelog
>  - change PORT_CMD_ICC_* constants as well
>  - include linux/bits.h
> ---
>  drivers/ata/ahci.h | 245 +++++++++++++++++++++++----------------------
>  1 file changed, 123 insertions(+), 122 deletions(-)
> 
> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index 7add8e79912b..ff8e6ae1c636 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
> @@ -24,6 +24,7 @@
>  #include <linux/libata.h>
>  #include <linux/phy/phy.h>
>  #include <linux/regulator/consumer.h>
> +#include <linux/bits.h>
>  
>  /* Enclosure Management Control */
>  #define EM_CTRL_MSG_TYPE              0x000f0000
> @@ -53,12 +54,12 @@ enum {
>  	AHCI_PORT_PRIV_FBS_DMA_SZ	= AHCI_CMD_SLOT_SZ +
>  					  AHCI_CMD_TBL_AR_SZ +
>  					  (AHCI_RX_FIS_SZ * 16),
> -	AHCI_IRQ_ON_SG		= (1 << 31),
> -	AHCI_CMD_ATAPI		= (1 << 5),
> -	AHCI_CMD_WRITE		= (1 << 6),
> -	AHCI_CMD_PREFETCH	= (1 << 7),
> -	AHCI_CMD_RESET		= (1 << 8),
> -	AHCI_CMD_CLR_BUSY	= (1 << 10),
> +	AHCI_IRQ_ON_SG		= BIT(31),
> +	AHCI_CMD_ATAPI		= BIT(5),
> +	AHCI_CMD_WRITE		= BIT(6),
> +	AHCI_CMD_PREFETCH	= BIT(7),
> +	AHCI_CMD_RESET		= BIT(8),
> +	AHCI_CMD_CLR_BUSY	= BIT(10),
>  
>  	RX_FIS_PIO_SETUP	= 0x20,	/* offset of PIO Setup FIS data */
>  	RX_FIS_D2H_REG		= 0x40,	/* offset of D2H Register FIS data */
> @@ -76,37 +77,37 @@ enum {
>  	HOST_CAP2		= 0x24, /* host capabilities, extended */
>  
>  	/* HOST_CTL bits */
> -	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
> -	HOST_IRQ_EN		= (1 << 1),  /* global IRQ enable */
> -	HOST_MRSM		= (1 << 2),  /* MSI Revert to Single Message */
> -	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
> +	HOST_RESET		= BIT(0),  /* reset controller; self-clear */
> +	HOST_IRQ_EN		= BIT(1),  /* global IRQ enable */
> +	HOST_MRSM		= BIT(2),  /* MSI Revert to Single Message */
> +	HOST_AHCI_EN		= BIT(31), /* AHCI enabled */
>  
>  	/* HOST_CAP bits */
> -	HOST_CAP_SXS		= (1 << 5),  /* Supports External SATA */
> -	HOST_CAP_EMS		= (1 << 6),  /* Enclosure Management support */
> -	HOST_CAP_CCC		= (1 << 7),  /* Command Completion Coalescing */
> -	HOST_CAP_PART		= (1 << 13), /* Partial state capable */
> -	HOST_CAP_SSC		= (1 << 14), /* Slumber state capable */
> -	HOST_CAP_PIO_MULTI	= (1 << 15), /* PIO multiple DRQ support */
> -	HOST_CAP_FBS		= (1 << 16), /* FIS-based switching support */
> -	HOST_CAP_PMP		= (1 << 17), /* Port Multiplier support */
> -	HOST_CAP_ONLY		= (1 << 18), /* Supports AHCI mode only */
> -	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
> -	HOST_CAP_LED		= (1 << 25), /* Supports activity LED */
> -	HOST_CAP_ALPM		= (1 << 26), /* Aggressive Link PM support */
> -	HOST_CAP_SSS		= (1 << 27), /* Staggered Spin-up */
> -	HOST_CAP_MPS		= (1 << 28), /* Mechanical presence switch */
> -	HOST_CAP_SNTF		= (1 << 29), /* SNotification register */
> -	HOST_CAP_NCQ		= (1 << 30), /* Native Command Queueing */
> -	HOST_CAP_64		= (1 << 31), /* PCI DAC (64-bit DMA) support */
> +	HOST_CAP_SXS		= BIT(5),  /* Supports External SATA */
> +	HOST_CAP_EMS		= BIT(6),  /* Enclosure Management support */
> +	HOST_CAP_CCC		= BIT(7),  /* Command Completion Coalescing */
> +	HOST_CAP_PART		= BIT(13), /* Partial state capable */
> +	HOST_CAP_SSC		= BIT(14), /* Slumber state capable */
> +	HOST_CAP_PIO_MULTI	= BIT(15), /* PIO multiple DRQ support */
> +	HOST_CAP_FBS		= BIT(16), /* FIS-based switching support */
> +	HOST_CAP_PMP		= BIT(17), /* Port Multiplier support */
> +	HOST_CAP_ONLY		= BIT(18), /* Supports AHCI mode only */
> +	HOST_CAP_CLO		= BIT(24), /* Command List Override support */
> +	HOST_CAP_LED		= BIT(25), /* Supports activity LED */
> +	HOST_CAP_ALPM		= BIT(26), /* Aggressive Link PM support */
> +	HOST_CAP_SSS		= BIT(27), /* Staggered Spin-up */
> +	HOST_CAP_MPS		= BIT(28), /* Mechanical presence switch */
> +	HOST_CAP_SNTF		= BIT(29), /* SNotification register */
> +	HOST_CAP_NCQ		= BIT(30), /* Native Command Queueing */
> +	HOST_CAP_64		= BIT(31), /* PCI DAC (64-bit DMA) support */
>  
>  	/* HOST_CAP2 bits */
> -	HOST_CAP2_BOH		= (1 << 0),  /* BIOS/OS handoff supported */
> -	HOST_CAP2_NVMHCI	= (1 << 1),  /* NVMHCI supported */
> -	HOST_CAP2_APST		= (1 << 2),  /* Automatic partial to slumber */
> -	HOST_CAP2_SDS		= (1 << 3),  /* Support device sleep */
> -	HOST_CAP2_SADM		= (1 << 4),  /* Support aggressive DevSlp */
> -	HOST_CAP2_DESO		= (1 << 5),  /* DevSlp from slumber only */
> +	HOST_CAP2_BOH		= BIT(0),  /* BIOS/OS handoff supported */
> +	HOST_CAP2_NVMHCI	= BIT(1),  /* NVMHCI supported */
> +	HOST_CAP2_APST		= BIT(2),  /* Automatic partial to slumber */
> +	HOST_CAP2_SDS		= BIT(3),  /* Support device sleep */
> +	HOST_CAP2_SADM		= BIT(4),  /* Support aggressive DevSlp */
> +	HOST_CAP2_DESO		= BIT(5),  /* DevSlp from slumber only */
>  
>  	/* registers for each SATA port */
>  	PORT_LST_ADDR		= 0x00, /* command list DMA addr */
> @@ -128,24 +129,24 @@ enum {
>  	PORT_DEVSLP		= 0x44, /* device sleep */
>  
>  	/* PORT_IRQ_{STAT,MASK} bits */
> -	PORT_IRQ_COLD_PRES	= (1 << 31), /* cold presence detect */
> -	PORT_IRQ_TF_ERR		= (1 << 30), /* task file error */
> -	PORT_IRQ_HBUS_ERR	= (1 << 29), /* host bus fatal error */
> -	PORT_IRQ_HBUS_DATA_ERR	= (1 << 28), /* host bus data error */
> -	PORT_IRQ_IF_ERR		= (1 << 27), /* interface fatal error */
> -	PORT_IRQ_IF_NONFATAL	= (1 << 26), /* interface non-fatal error */
> -	PORT_IRQ_OVERFLOW	= (1 << 24), /* xfer exhausted available S/G */
> -	PORT_IRQ_BAD_PMP	= (1 << 23), /* incorrect port multiplier */
> -
> -	PORT_IRQ_PHYRDY		= (1 << 22), /* PhyRdy changed */
> -	PORT_IRQ_DMPS		= (1 << 7), /* mechanical presence status */
> -	PORT_IRQ_CONNECT	= (1 << 6), /* port connect change status */
> -	PORT_IRQ_SG_DONE	= (1 << 5), /* descriptor processed */
> -	PORT_IRQ_UNK_FIS	= (1 << 4), /* unknown FIS rx'd */
> -	PORT_IRQ_SDB_FIS	= (1 << 3), /* Set Device Bits FIS rx'd */
> -	PORT_IRQ_DMAS_FIS	= (1 << 2), /* DMA Setup FIS rx'd */
> -	PORT_IRQ_PIOS_FIS	= (1 << 1), /* PIO Setup FIS rx'd */
> -	PORT_IRQ_D2H_REG_FIS	= (1 << 0), /* D2H Register FIS rx'd */
> +	PORT_IRQ_COLD_PRES	= BIT(31), /* cold presence detect */
> +	PORT_IRQ_TF_ERR		= BIT(30), /* task file error */
> +	PORT_IRQ_HBUS_ERR	= BIT(29), /* host bus fatal error */
> +	PORT_IRQ_HBUS_DATA_ERR	= BIT(28), /* host bus data error */
> +	PORT_IRQ_IF_ERR		= BIT(27), /* interface fatal error */
> +	PORT_IRQ_IF_NONFATAL	= BIT(26), /* interface non-fatal error */
> +	PORT_IRQ_OVERFLOW	= BIT(24), /* xfer exhausted available S/G */
> +	PORT_IRQ_BAD_PMP	= BIT(23), /* incorrect port multiplier */
> +
> +	PORT_IRQ_PHYRDY		= BIT(22), /* PhyRdy changed */
> +	PORT_IRQ_DMPS		= BIT(7),  /* mechanical presence status */
> +	PORT_IRQ_CONNECT	= BIT(6),  /* port connect change status */
> +	PORT_IRQ_SG_DONE	= BIT(5),  /* descriptor processed */
> +	PORT_IRQ_UNK_FIS	= BIT(4),  /* unknown FIS rx'd */
> +	PORT_IRQ_SDB_FIS	= BIT(3),  /* Set Device Bits FIS rx'd */
> +	PORT_IRQ_DMAS_FIS	= BIT(2),  /* DMA Setup FIS rx'd */
> +	PORT_IRQ_PIOS_FIS	= BIT(1),  /* PIO Setup FIS rx'd */
> +	PORT_IRQ_D2H_REG_FIS	= BIT(0),  /* D2H Register FIS rx'd */
>  
>  	PORT_IRQ_FREEZE		= PORT_IRQ_HBUS_ERR |
>  				  PORT_IRQ_IF_ERR |
> @@ -161,27 +162,27 @@ enum {
>  				  PORT_IRQ_PIOS_FIS | PORT_IRQ_D2H_REG_FIS,
>  
>  	/* PORT_CMD bits */
> -	PORT_CMD_ASP		= (1 << 27), /* Aggressive Slumber/Partial */
> -	PORT_CMD_ALPE		= (1 << 26), /* Aggressive Link PM enable */
> -	PORT_CMD_ATAPI		= (1 << 24), /* Device is ATAPI */
> -	PORT_CMD_FBSCP		= (1 << 22), /* FBS Capable Port */
> -	PORT_CMD_ESP		= (1 << 21), /* External Sata Port */
> -	PORT_CMD_CPD		= (1 << 20), /* Cold Presence Detection */
> -	PORT_CMD_MPSP		= (1 << 19), /* Mechanical Presence Switch */
> -	PORT_CMD_HPCP		= (1 << 18), /* HotPlug Capable Port */
> -	PORT_CMD_PMP		= (1 << 17), /* PMP attached */
> -	PORT_CMD_LIST_ON	= (1 << 15), /* cmd list DMA engine running */
> -	PORT_CMD_FIS_ON		= (1 << 14), /* FIS DMA engine running */
> -	PORT_CMD_FIS_RX		= (1 << 4), /* Enable FIS receive DMA engine */
> -	PORT_CMD_CLO		= (1 << 3), /* Command list override */
> -	PORT_CMD_POWER_ON	= (1 << 2), /* Power up device */
> -	PORT_CMD_SPIN_UP	= (1 << 1), /* Spin up device */
> -	PORT_CMD_START		= (1 << 0), /* Enable port DMA engine */
> -
> -	PORT_CMD_ICC_MASK	= (0xf << 28), /* i/f ICC state mask */
> -	PORT_CMD_ICC_ACTIVE	= (0x1 << 28), /* Put i/f in active state */
> -	PORT_CMD_ICC_PARTIAL	= (0x2 << 28), /* Put i/f in partial state */
> -	PORT_CMD_ICC_SLUMBER	= (0x6 << 28), /* Put i/f in slumber state */
> +	PORT_CMD_ASP		= BIT(27), /* Aggressive Slumber/Partial */
> +	PORT_CMD_ALPE		= BIT(26), /* Aggressive Link PM enable */
> +	PORT_CMD_ATAPI		= BIT(24), /* Device is ATAPI */
> +	PORT_CMD_FBSCP		= BIT(22), /* FBS Capable Port */
> +	PORT_CMD_ESP		= BIT(21), /* External Sata Port */
> +	PORT_CMD_CPD		= BIT(20), /* Cold Presence Detection */
> +	PORT_CMD_MPSP		= BIT(19), /* Mechanical Presence Switch */
> +	PORT_CMD_HPCP		= BIT(18), /* HotPlug Capable Port */
> +	PORT_CMD_PMP		= BIT(17), /* PMP attached */
> +	PORT_CMD_LIST_ON	= BIT(15), /* cmd list DMA engine running */
> +	PORT_CMD_FIS_ON		= BIT(14), /* FIS DMA engine running */
> +	PORT_CMD_FIS_RX		= BIT(4),  /* Enable FIS receive DMA engine */
> +	PORT_CMD_CLO		= BIT(3),  /* Command list override */
> +	PORT_CMD_POWER_ON	= BIT(2),  /* Power up device */
> +	PORT_CMD_SPIN_UP	= BIT(1),  /* Spin up device */
> +	PORT_CMD_START		= BIT(0),  /* Enable port DMA engine */
> +
> +	PORT_CMD_ICC_MASK	= (0xfu << 28), /* i/f ICC state mask */
> +	PORT_CMD_ICC_ACTIVE	= (0x1u << 28), /* Put i/f in active state */
> +	PORT_CMD_ICC_PARTIAL	= (0x2u << 28), /* Put i/f in partial state */
> +	PORT_CMD_ICC_SLUMBER	= (0x6u << 28), /* Put i/f in slumber state */
>  
>  	/* PORT_CMD capabilities mask */
>  	PORT_CMD_CAP		= PORT_CMD_HPCP | PORT_CMD_MPSP |
> @@ -192,9 +193,9 @@ enum {
>  	PORT_FBS_ADO_OFFSET	= 12, /* FBS active dev optimization offset */
>  	PORT_FBS_DEV_OFFSET	= 8,  /* FBS device to issue offset */
>  	PORT_FBS_DEV_MASK	= (0xf << PORT_FBS_DEV_OFFSET),  /* FBS.DEV */
> -	PORT_FBS_SDE		= (1 << 2), /* FBS single device error */
> -	PORT_FBS_DEC		= (1 << 1), /* FBS device error clear */
> -	PORT_FBS_EN		= (1 << 0), /* Enable FBS */
> +	PORT_FBS_SDE		= BIT(2), /* FBS single device error */
> +	PORT_FBS_DEC		= BIT(1), /* FBS device error clear */
> +	PORT_FBS_EN		= BIT(0), /* Enable FBS */
>  
>  	/* PORT_DEVSLP bits */
>  	PORT_DEVSLP_DM_OFFSET	= 25,             /* DITO multiplier offset */
> @@ -202,50 +203,50 @@ enum {
>  	PORT_DEVSLP_DITO_OFFSET	= 15,             /* DITO offset */
>  	PORT_DEVSLP_MDAT_OFFSET	= 10,             /* Minimum assertion time */
>  	PORT_DEVSLP_DETO_OFFSET	= 2,              /* DevSlp exit timeout */
> -	PORT_DEVSLP_DSP		= (1 << 1),       /* DevSlp present */
> -	PORT_DEVSLP_ADSE	= (1 << 0),       /* Aggressive DevSlp enable */
> +	PORT_DEVSLP_DSP		= BIT(1),         /* DevSlp present */
> +	PORT_DEVSLP_ADSE	= BIT(0),         /* Aggressive DevSlp enable */
>  
>  	/* hpriv->flags bits */
>  
>  #define AHCI_HFLAGS(flags)		.private_data	= (void *)(flags)
>  
> -	AHCI_HFLAG_NO_NCQ		= (1 << 0),
> -	AHCI_HFLAG_IGN_IRQ_IF_ERR	= (1 << 1), /* ignore IRQ_IF_ERR */
> -	AHCI_HFLAG_IGN_SERR_INTERNAL	= (1 << 2), /* ignore SERR_INTERNAL */
> -	AHCI_HFLAG_32BIT_ONLY		= (1 << 3), /* force 32bit */
> -	AHCI_HFLAG_MV_PATA		= (1 << 4), /* PATA port */
> -	AHCI_HFLAG_NO_MSI		= (1 << 5), /* no PCI MSI */
> -	AHCI_HFLAG_NO_PMP		= (1 << 6), /* no PMP */
> -	AHCI_HFLAG_SECT255		= (1 << 8), /* max 255 sectors */
> -	AHCI_HFLAG_YES_NCQ		= (1 << 9), /* force NCQ cap on */
> -	AHCI_HFLAG_NO_SUSPEND		= (1 << 10), /* don't suspend */
> -	AHCI_HFLAG_SRST_TOUT_IS_OFFLINE	= (1 << 11), /* treat SRST timeout as
> -							link offline */
> -	AHCI_HFLAG_NO_SNTF		= (1 << 12), /* no sntf */
> -	AHCI_HFLAG_NO_FPDMA_AA		= (1 << 13), /* no FPDMA AA */
> -	AHCI_HFLAG_YES_FBS		= (1 << 14), /* force FBS cap on */
> -	AHCI_HFLAG_DELAY_ENGINE		= (1 << 15), /* do not start engine on
> -						        port start (wait until
> -						        error-handling stage) */
> -	AHCI_HFLAG_NO_DEVSLP		= (1 << 17), /* no device sleep */
> -	AHCI_HFLAG_NO_FBS		= (1 << 18), /* no FBS */
> +	AHCI_HFLAG_NO_NCQ		= BIT(0),
> +	AHCI_HFLAG_IGN_IRQ_IF_ERR	= BIT(1), /* ignore IRQ_IF_ERR */
> +	AHCI_HFLAG_IGN_SERR_INTERNAL	= BIT(2), /* ignore SERR_INTERNAL */
> +	AHCI_HFLAG_32BIT_ONLY		= BIT(3), /* force 32bit */
> +	AHCI_HFLAG_MV_PATA		= BIT(4), /* PATA port */
> +	AHCI_HFLAG_NO_MSI		= BIT(5), /* no PCI MSI */
> +	AHCI_HFLAG_NO_PMP		= BIT(6), /* no PMP */
> +	AHCI_HFLAG_SECT255		= BIT(8), /* max 255 sectors */
> +	AHCI_HFLAG_YES_NCQ		= BIT(9), /* force NCQ cap on */
> +	AHCI_HFLAG_NO_SUSPEND		= BIT(10), /* don't suspend */
> +	AHCI_HFLAG_SRST_TOUT_IS_OFFLINE	= BIT(11), /* treat SRST timeout as
> +						      link offline */
> +	AHCI_HFLAG_NO_SNTF		= BIT(12), /* no sntf */
> +	AHCI_HFLAG_NO_FPDMA_AA		= BIT(13), /* no FPDMA AA */
> +	AHCI_HFLAG_YES_FBS		= BIT(14), /* force FBS cap on */
> +	AHCI_HFLAG_DELAY_ENGINE		= BIT(15), /* do not start engine on
> +						      port start (wait until
> +						      error-handling stage) */
> +	AHCI_HFLAG_NO_DEVSLP		= BIT(17), /* no device sleep */
> +	AHCI_HFLAG_NO_FBS		= BIT(18), /* no FBS */
>  
>  #ifdef CONFIG_PCI_MSI
> -	AHCI_HFLAG_MULTI_MSI		= (1 << 20), /* per-port MSI(-X) */
> +	AHCI_HFLAG_MULTI_MSI		= BIT(20), /* per-port MSI(-X) */
>  #else
>  	/* compile out MSI infrastructure */
>  	AHCI_HFLAG_MULTI_MSI		= 0,
>  #endif
> -	AHCI_HFLAG_WAKE_BEFORE_STOP	= (1 << 22), /* wake before DMA stop */
> -	AHCI_HFLAG_YES_ALPM		= (1 << 23), /* force ALPM cap on */
> -	AHCI_HFLAG_NO_WRITE_TO_RO	= (1 << 24), /* don't write to read
> -							only registers */
> -	AHCI_HFLAG_USE_LPM_POLICY	= (1 << 25), /* chipset that should use
> -							SATA_MOBILE_LPM_POLICY
> -							as default lpm_policy */
> -	AHCI_HFLAG_SUSPEND_PHYS		= (1 << 26), /* handle PHYs during
> -							suspend/resume */
> -	AHCI_HFLAG_NO_SXS		= (1 << 28), /* SXS not supported */
> +	AHCI_HFLAG_WAKE_BEFORE_STOP	= BIT(22), /* wake before DMA stop */
> +	AHCI_HFLAG_YES_ALPM		= BIT(23), /* force ALPM cap on */
> +	AHCI_HFLAG_NO_WRITE_TO_RO	= BIT(24), /* don't write to read
> +						      only registers */
> +	AHCI_HFLAG_USE_LPM_POLICY	= BIT(25), /* chipset that should use
> +						      SATA_MOBILE_LPM_POLICY
> +						      as default lpm_policy */
> +	AHCI_HFLAG_SUSPEND_PHYS		= BIT(26), /* handle PHYs during
> +						      suspend/resume */
> +	AHCI_HFLAG_NO_SXS		= BIT(28), /* SXS not supported */
>  
>  	/* ap->flags bits */
>  
> @@ -261,22 +262,22 @@ enum {
>  	EM_MAX_RETRY			= 5,
>  
>  	/* em_ctl bits */
> -	EM_CTL_RST		= (1 << 9), /* Reset */
> -	EM_CTL_TM		= (1 << 8), /* Transmit Message */
> -	EM_CTL_MR		= (1 << 0), /* Message Received */
> -	EM_CTL_ALHD		= (1 << 26), /* Activity LED */
> -	EM_CTL_XMT		= (1 << 25), /* Transmit Only */
> -	EM_CTL_SMB		= (1 << 24), /* Single Message Buffer */
> -	EM_CTL_SGPIO		= (1 << 19), /* SGPIO messages supported */
> -	EM_CTL_SES		= (1 << 18), /* SES-2 messages supported */
> -	EM_CTL_SAFTE		= (1 << 17), /* SAF-TE messages supported */
> -	EM_CTL_LED		= (1 << 16), /* LED messages supported */
> +	EM_CTL_RST		= BIT(9), /* Reset */
> +	EM_CTL_TM		= BIT(8), /* Transmit Message */
> +	EM_CTL_MR		= BIT(0), /* Message Received */
> +	EM_CTL_ALHD		= BIT(26), /* Activity LED */
> +	EM_CTL_XMT		= BIT(25), /* Transmit Only */
> +	EM_CTL_SMB		= BIT(24), /* Single Message Buffer */
> +	EM_CTL_SGPIO		= BIT(19), /* SGPIO messages supported */
> +	EM_CTL_SES		= BIT(18), /* SES-2 messages supported */
> +	EM_CTL_SAFTE		= BIT(17), /* SAF-TE messages supported */
> +	EM_CTL_LED		= BIT(16), /* LED messages supported */
>  
>  	/* em message type */
> -	EM_MSG_TYPE_LED		= (1 << 0), /* LED */
> -	EM_MSG_TYPE_SAFTE	= (1 << 1), /* SAF-TE */
> -	EM_MSG_TYPE_SES2	= (1 << 2), /* SES-2 */
> -	EM_MSG_TYPE_SGPIO	= (1 << 3), /* SGPIO */
> +	EM_MSG_TYPE_LED		= BIT(0), /* LED */
> +	EM_MSG_TYPE_SAFTE	= BIT(1), /* SAF-TE */
> +	EM_MSG_TYPE_SES2	= BIT(2), /* SES-2 */
> +	EM_MSG_TYPE_SGPIO	= BIT(3), /* SGPIO */
>  };
>  
>  struct ahci_cmd_hdr {

-- 
Damien Le Moal
Western Digital Research

