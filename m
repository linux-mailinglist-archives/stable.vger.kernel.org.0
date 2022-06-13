Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929FE548336
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 11:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbiFMJ3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 05:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234858AbiFMJ3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 05:29:19 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE0D186DF
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 02:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1655112556; x=1686648556;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=tKWtAeNizUK82N5e+0YRX0haxYaNw59kZsWPURYTltA=;
  b=RwdnCSWNPk6W53/FoKFndxHL8jIjzIvwb+TbmfC4+mMqKR2MYZ2GEfew
   B5W4Ljom6k+CRgU4MrXQzktC2rLyZph0QIebbjeRj3OY/cxu3gzd5VgK8
   imfxHbnhitnzKH7RvYvcr4E/k8LBGy9iskhlmffcKtfAXicLm+dOtZNBr
   JPmscd8ft4zbyOtwHwj3ffu9OOdXMYvjUWq8jTPpi+xLWLO2REgsevwMA
   nudO8xPXwBVfrzgqpCxKWolbCxDxCZyPBBsxGtN9OxjWjvjLKAs6rd3NQ
   wxPNnfRGT4rr/dTfsqlv4AGKS4l/BM433hntyJ63kmbGCZkSv2ieFcNJ5
   w==;
X-IronPort-AV: E=Sophos;i="5.91,297,1647273600"; 
   d="scan'208";a="307270804"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2022 17:29:15 +0800
IronPort-SDR: 6R6U8XwN8WiXwJbwqC47C4R/in5HKn3EgvR7mL3XHUmFRgEK7bKLJo0kiyXK+Adzyww6DfW6/K
 Z6JdEvzq9fA6d/NwytAZpYVGmZ9JIaF+hpkgeEBBV/5SF++m3/98j9hqjW6i2oqvOz9JhmIQOh
 lmcjMCmBj10bP/lyVaE2duMMtEOf3FS+adN4PTr4+CT8XQmPMk0pT4yqXHF8YYJzNoDh84cgYi
 lHME5cd2qluCgQuR6cqZmXI9O5cziPn+W0vQIteT+GQIYfEHdxiapkNHmiFisKEtYXdq5RDRxF
 xdHAZYDXwN1MvakcQ0CwFX3p
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jun 2022 01:52:19 -0700
IronPort-SDR: G3uH7QvSLcxiQKnR06ydhh8ink/4Fn1NPjwK+YBz7++LOHeapm4y3ezG642/opnXKaMTVkEvhA
 s70lXQIRlW3cclU8FAjORMgQ+dbId7N6qPeDLHlTm0tJMlIH2i5UkxRrzLZ1ZQW1ehb4TIQd+Y
 kVb9CErBcFbolUJAQ54Slu46+Tc5T9oL6leE9hVVdnSBvP20odqpx5w84a0uGZNsYLR5Y/cNPP
 s1qiGbtpJy3MJCwljScWdBLPCulxbcRAiUq+iXnnJyJMzH3jpJ1a/+cMYmWEidcSYlHxF37VUM
 aik=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jun 2022 02:29:15 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LM5qb3CMXz1SVnx
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 02:29:15 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1655112555; x=1657704556; bh=tKWtAeNizUK82N5e+0YRX0haxYaNw59kZsW
        PURYTltA=; b=H3b6FBaaeRqY23udNzGiRu5b0jpgoMRaIcDpFYhQdqJs8MVXKBC
        +IRb0yuJAjx89IJ8Go0hq0ACuzW7pyJzoelrEYWfucaSZIHLw9X/Y12CQEDJ0PMJ
        WLV0n7qsunAf/k7n7AmI/N/hPDJcKdUAuL0M94m8QrtRiagBdcdJapa0WyRWsr4K
        biUV4e3Y9Sq8cy7ykHuCmW7NHhX8E9YaUs3FzRO7uz69bdoEFwFrHKz7M3tZXWIC
        +f5O1WI5anlU828fL4xw6EoYfc3WSxc6IDefMdE8hn8rU2DZVD9p0m1W4F6ycoMm
        Dahx9HUbM/DDS2MUaBThI7PWxfc8uT925Uw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id MwTr5V0Yoh-n for <stable@vger.kernel.org>;
        Mon, 13 Jun 2022 02:29:15 -0700 (PDT)
Received: from [10.225.163.77] (unknown [10.225.163.77])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LM5qZ2H3Bz1Rvlc;
        Mon, 13 Jun 2022 02:29:14 -0700 (PDT)
Message-ID: <29a5f5c5-54a8-a77a-a3d2-2585fe411c44@opensource.wdc.com>
Date:   Mon, 13 Jun 2022 18:29:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: FAILED: patch "[PATCH] zonefs: fix handling of explicit_open
 option on mount" failed to apply to 5.18-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, hch@lst.de, johannes.thumshirn@wdc.com,
        stable@vger.kernel.org
References: <165510578298165@kroah.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <165510578298165@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/22 16:36, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.18-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Hi Greg,

I sent you the fixed backported patch in reply to this email. The same
patch also applies as-is to 5.17, 5.15 and 5.10.

Thanks !

> 
> ------------------ original commit in Linus's tree ------------------
> 
> From a2a513be7139b279f1b5b2cee59c6c4950c34346 Mon Sep 17 00:00:00 2001
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Date: Thu, 2 Jun 2022 23:16:57 +0900
> Subject: [PATCH] zonefs: fix handling of explicit_open option on mount
> 
> Ignoring the explicit_open mount option on mount for devices that do not
> have a limit on the number of open zones must be done after the mount
> options are parsed and set in s_mount_opts. Move the check to ignore
> the explicit_open option after the call to zonefs_parse_options() in
> zonefs_fill_super().
> 
> Fixes: b5c00e975779 ("zonefs: open/close zone on file open/close")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index bcb21aea990a..ecce84909ca1 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -1760,12 +1760,6 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	atomic_set(&sbi->s_wro_seq_files, 0);
>  	sbi->s_max_wro_seq_files = bdev_max_open_zones(sb->s_bdev);
> -	if (!sbi->s_max_wro_seq_files &&
> -	    sbi->s_mount_opts & ZONEFS_MNTOPT_EXPLICIT_OPEN) {
> -		zonefs_info(sb, "No open zones limit. Ignoring explicit_open mount option\n");
> -		sbi->s_mount_opts &= ~ZONEFS_MNTOPT_EXPLICIT_OPEN;
> -	}
> -
>  	atomic_set(&sbi->s_active_seq_files, 0);
>  	sbi->s_max_active_seq_files = bdev_max_active_zones(sb->s_bdev);
>  
> @@ -1790,6 +1784,12 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
>  	zonefs_info(sb, "Mounting %u zones",
>  		    blkdev_nr_zones(sb->s_bdev->bd_disk));
>  
> +	if (!sbi->s_max_wro_seq_files &&
> +	    sbi->s_mount_opts & ZONEFS_MNTOPT_EXPLICIT_OPEN) {
> +		zonefs_info(sb, "No open zones limit. Ignoring explicit_open mount option\n");
> +		sbi->s_mount_opts &= ~ZONEFS_MNTOPT_EXPLICIT_OPEN;
> +	}
> +
>  	/* Create root directory inode */
>  	ret = -ENOMEM;
>  	inode = new_inode(sb);
> 


-- 
Damien Le Moal
Western Digital Research
