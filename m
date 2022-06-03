Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D654853C290
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 04:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240823AbiFCBbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 21:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240896AbiFCBbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 21:31:11 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A235E3BA69
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 18:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654219828; x=1685755828;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4/XRBVJlrbde9LFq9lEMFNDMZHqrnKfROAx+/nN8uZw=;
  b=OcPzTol08soDuiqU6YL6bkHIXXPSOmV4Qxnp+uh+A64n5cQRVAFLOSgM
   +6grc9coITDmF7xqvQ6tPIaFj3EsTQodVvE35h+AX2G+QaKWM4b6OWlFz
   lsK2eiA+GD6Z+DqBZDWfgFYB5BjTZJEaEi73iREDjeJHWV/VGPKt6/HuC
   i/XAdtFqCYFpCQu2jFLVTUv8yQxPeO/wJ2/OfDWATlZcNn1QZXYtb0Q0W
   2wXGz+Aj1fPPweaMm7Ex0MT7tjoecTrwpQXv6SJc6Z4Z0CbFTuhkINRBF
   PC/dEaPE8Y8GvXLQ2IYtwsSAvTXDsMQkOFAjuhVIS75Rqv164Sk62V8ex
   g==;
X-IronPort-AV: E=Sophos;i="5.91,273,1647273600"; 
   d="scan'208";a="202947958"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jun 2022 09:30:18 +0800
IronPort-SDR: Ez2k+NTSjvZ/sInMjYQe0Zgp4FhTuwWuI8P6RnD1/RLDUib9oR4j3eCsFBvctWjh0773UKGFy0
 ogUO8dd4/NoV2O5qim+Wj4gIJQ5gTRyc80AKYPk3lxAFZMA1taRnG6ZG1VPkONP+KCUiIlW4/6
 yGQlL3FPZGJWMkC+UXPyXyObxNiJm1rPeg2yya+Mu59TJXn/UnNejtLW+aX3OxD0+kZIiwyObX
 p1+Uvv2mljCN2unkxE7iYViT20L9pNg8Nz3jVfJ0yqdj09pp/dD27lCsZWgOXRmQXk6PvH3ppv
 CxvCn877rnDseXk2x7NTHqgR
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Jun 2022 17:53:53 -0700
IronPort-SDR: iO+0V2267K2l1GP+dg5Loakeyx5tfQUlwd+6N1sNx8p9woNVdU464VOdq0fxBsIiI3f74bKLwZ
 fjttnWhDuAP8sIU6ecni1QW7Zluf0jdJoTbG7dOH1ZPFIyWkeOD39ASrdIuk2XpgfNUVi4QsNw
 OtLhxwsm0pU4JnLXR68LkN4Tv701zG7BZakVtn/BNstoC3llDEr3ygdtua6VCPR0r8GLrlQROM
 tOlwwplMuQa1aWENiv8fRJ6K50OmcQJZFGABiA0VeOAheLxw2Fdpkf1cPnVOA30L8ozmC2C71I
 xYA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Jun 2022 18:30:18 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LDlgY2QrLz1SVp2
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 18:30:17 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1654219816; x=1656811817; bh=4/XRBVJlrbde9LFq9lEMFNDMZHqrnKfROAx
        +/nN8uZw=; b=eBY8VQn1azy3OxgTB0joSiNzuxnCa56ZCh3ZD/Qab7XLle0sgEM
        TmIh/nKOxOkgDQAMwlaktPb94XXAUK982Rv0wJhPM2aygGbYtQiBT6HZnDRiPRCT
        fpSCREdQ/rlUqdPv2Id3L4NJa8jL6BCuqwbQSR1UuR8Pr2x8dSOXXANVRoqdoIuR
        09G84gMZyL0QtN4wVAQsiD+69MJA4NVHqcgqU+Q6+gfyh7xA4rQymnWmHBBn5F9W
        eoJFPZdmgTFF59YFnBaeh8kEB8ZnrQuLXq40HcsQRK5Al6mCAkLV0GBRns7GZUlk
        lV/wkMW1BWJAbpJYUnZYBfGBj7jEL4138sA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id YksTX-ADyHCK for <stable@vger.kernel.org>;
        Thu,  2 Jun 2022 18:30:16 -0700 (PDT)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LDlgW4xkbz1Rvlc;
        Thu,  2 Jun 2022 18:30:15 -0700 (PDT)
Message-ID: <fcef5536-a4aa-f6f2-5e9a-c39708a74a50@opensource.wdc.com>
Date:   Fri, 3 Jun 2022 10:30:14 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 3/3] scsi: sd: Fix interpretation of VPD B9h length
Content-Language: en-US
To:     Tyler Erickson <tyler.erickson@seagate.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        muhammad.ahmad@seagate.com, stable@vger.kernel.org
References: <20220602225113.10218-1-tyler.erickson@seagate.com>
 <20220602225113.10218-4-tyler.erickson@seagate.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220602225113.10218-4-tyler.erickson@seagate.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/3/22 07:51, Tyler Erickson wrote:
> Fixing the interpretation of the length of the B9h VPD page
> (concurrent positioning ranges). Adding 4 is necessary as
> the first 4 bytes of the page is the header with page number
> and length information. Adding 3 was likely a misinterpretation
> of the SBC-5 specification which sets all offsets starting at zero.
> 
> This fixes the error in dmesg:
> [ 9.014456] sd 1:0:0:0: [sda] Invalid Concurrent Positioning Ranges VPD page
> 
> Cc: stable@vger.kernel.org
> Fixes: e815d36548f0 ("scsi: sd: add concurrent positioning ranges support")
> Signed-off-by: Tyler Erickson <tyler.erickson@seagate.com>
> Reviewed-by: Muhammad Ahmad <muhammad.ahmad@seagate.com>
> Tested-by: Michael English <michael.english@seagate.com>
> ---
>  drivers/scsi/sd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 749316462075..f25b0cc5dd21 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3072,7 +3072,7 @@ static void sd_read_cpr(struct scsi_disk *sdkp)
>  		goto out;
>  
>  	/* We must have at least a 64B header and one 32B range descriptor */
> -	vpd_len = get_unaligned_be16(&buffer[2]) + 3;
> +	vpd_len = get_unaligned_be16(&buffer[2]) + 4;
>  	if (vpd_len > buf_len || vpd_len < 64 + 32 || (vpd_len & 31)) {
>  		sd_printk(KERN_ERR, sdkp,
>  			  "Invalid Concurrent Positioning Ranges VPD page\n");

Martin,

If you take this one:

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
