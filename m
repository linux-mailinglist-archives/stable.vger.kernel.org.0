Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC434C6363
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 07:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbiB1GzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 01:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiB1GzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 01:55:09 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0C74839D
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 22:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646031270; x=1677567270;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=erJl9T6x12nVkiId2uwfll4XUiZZzjI9SqKdPGKg6Jk=;
  b=N384aggYsqaKT9EZwA2K6QcXC94k6KxIHoxaPbS/cIR1Q45qbdlBgXK1
   H75k5uoWVaGvfApN8pAZs9VQm3SJJ1+AioW8DwLscVWTl3HGM6LN4soe4
   WZwz1AAR1J77eQ3V+pPY7Aqgt0TU+Zh4Cdb4GcnY4gXTiAlHgsf6Gjb/5
   vSnsL75SVjxB5N2oROH9TaAb0nV4DrHDxm7AL8rhofm6YjtNhd30TGUS0
   8tjEMVuPEo9yOSJoOMmgJNv6q1Ls9/lConqo6L/kgCRJlzHaiyd19mSy3
   ruY/YRR1hu6TFuGNCUBc+N3i79EupaDeqSiSIaa4WYVGJnW+wnlS+sfdV
   g==;
X-IronPort-AV: E=Sophos;i="5.90,142,1643644800"; 
   d="scan'208";a="198918227"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2022 14:54:29 +0800
IronPort-SDR: LoUVMdp8ICP6l3z0+r8/W0DCEF+GmM5CLE2OnEsRr/HMvlCbLW/5ES1YM1I2JLzYs/phJchq5j
 DquHyHHwtMc17F0rt2qAGlsDWSlPDUTOwilALgWpLWTJ/yd3oQrD+MttJhqfUb8pRqYkAOqbiJ
 K5lmHA1yBNvjnJeI5XpspAfpsPS0SCGfyq05sVFsrFfu414cnMJ9gaUNZZamL2zvP/4I3QhlmX
 wF+kkd+PTKhRuME4hT2NHIzjl5K7moNAPi6omdojW8jIJVX1peuoWI26O1yogwYrFozI+2uCGd
 Vmhffe+QBQrfoCEwRKV+Y4xE
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 22:26:59 -0800
IronPort-SDR: O3tou0/aBnRiUYIPVAOnUhwM5an4x4CPIEleu3s/gACbXzKjfVewzETX4T2pyAwqaOBQn5f6vx
 D4lxuEW5aI/QfO8pNGUWmNZWQqj10mVq3JOaoedN0g3TaR/yfT5y9F/xojw89daF5gMpA1FRVU
 EulqO4vBPBOLczFfLo3cD3FO2eMfzeUeX5hqMM9BztM/5Pamm9zU2d5S/vCgKrn5PCxeJ4J/EK
 KJGUWWhUwQMWfvhsnFbeFxF6CpJcR4PlcP0anIbR+NjQVfn9plC2s9b5+r8ohWwxFRlySE09i2
 68c=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 22:54:31 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K6WMV0HSZz1SVnx
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 22:54:30 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1646031269; x=1648623270; bh=erJl9T6x12nVkiId2uwfll4XUiZZzjI9SqK
        dPGKg6Jk=; b=Iv7dO7PCeh6KBpNGWDcL+Pwop/jMaqPMWpSHLx98a51OkPdJl/C
        a5zSqMFWIVSnclOK2kg74hZ/Zl2N8ZunOaTHwGMrB8lJTpwyP8hciJefLFYcxRpd
        Af8x/mAN8qzkkEaSsTRAM6EwNn4EOILc+XoE/4LGHNsMESEG9YUYaYR6WJIVklpz
        99FH3ORjR5GWEAMlyZXxeBcIdhLKNt/pxPbzsj9QwRxsQ4N33IM06XVEWMD2OQ2K
        1WZB2lFPcK1Lp1mVIzxDts7YPF743t7NQaB3MOcnJ6Fre6rBK/ETWwpq+ndxgNQZ
        FXhVn23gw0VFDezb6V6Qd+wxX2LrutPa7NA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id KkzTo3lTm4gj for <stable@vger.kernel.org>;
        Sun, 27 Feb 2022 22:54:29 -0800 (PST)
Received: from [10.225.33.67] (unknown [10.225.33.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K6WMR5YZvz1Rvlx;
        Sun, 27 Feb 2022 22:54:27 -0800 (PST)
Message-ID: <496eb6a8-dac1-89bc-6342-d96a72815e95@opensource.wdc.com>
Date:   Mon, 28 Feb 2022 08:54:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: FAILED: patch "[PATCH] ata: pata_hpt37x: fix PCI clock detection"
 failed to apply to 5.15-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, s.shtylyov@omp.ru
Cc:     stable@vger.kernel.org
References: <164603025790250@kroah.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <164603025790250@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/02/28 8:37, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,

Sergey,

Can you send the proper backports to Greg ? I am traveling this week and will
not have time to do it.
Thanks.


> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 5f6b0f2d037c8864f20ff15311c695f65eb09db5 Mon Sep 17 00:00:00 2001
> From: Sergey Shtylyov <s.shtylyov@omp.ru>
> Date: Sat, 19 Feb 2022 23:04:29 +0300
> Subject: [PATCH] ata: pata_hpt37x: fix PCI clock detection
> 
> The f_CNT register (at the PCI config. address 0x78) is 16-bit, not
> 8-bit! The bug was there from the very start... :-(
> 
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> Fixes: 669a5db411d8 ("[libata] Add a bunch of PATA drivers.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
> index 7abc7e04f656..1baaca7b72ed 100644
> --- a/drivers/ata/pata_hpt37x.c
> +++ b/drivers/ata/pata_hpt37x.c
> @@ -950,14 +950,14 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
>  
>  	if ((freq >> 12) != 0xABCDE) {
>  		int i;
> -		u8 sr;
> +		u16 sr;
>  		u32 total = 0;
>  
>  		dev_warn(&dev->dev, "BIOS has not set timing clocks\n");
>  
>  		/* This is the process the HPT371 BIOS is reported to use */
>  		for (i = 0; i < 128; i++) {
> -			pci_read_config_byte(dev, 0x78, &sr);
> +			pci_read_config_word(dev, 0x78, &sr);
>  			total += sr & 0x1FF;
>  			udelay(15);
>  		}
> 


-- 
Damien Le Moal
Western Digital Research
