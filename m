Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B9E3926F8
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 07:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbhE0FoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 01:44:12 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:20092 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbhE0FoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 01:44:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1622094159; x=1653630159;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XGoVdzDuaJkGaAkHeimE64vS9/bPYO+/f2Q2ME41/2g=;
  b=ODyhJ08zSMMIHzQTsyNzvOyJ/CQh/QbHBzzhk2EEzWVbl2ZBje3/zXVS
   L4YInIOqbWYFIsETfKIejiCMDtpanfc8ud1+o8a5Ktkd2algpoBK4Kewv
   ACYbT8RXutmjjK0+vPKOAM3Uj+st8gCJGD4awnfNdbQbxekadr4zzTiJN
   +iJU7YLERcLnSvtXQJpnJ9XUd4ZCyMqjcYw0z6YZYJiqECjRR4EI1x19W
   bMNL8FA1Wr7/Oj3cLD1ZZ40Lq+ChjmVKzdY4yNY9Y5q2a03O6l1Oea7E1
   Tl2Yn8mrtlQhQydtKOsYoFizZ1iTNqLxaSM2ebMQ5ZqYH7tDv5FkfjgTY
   Q==;
IronPort-SDR: TTFzrCYLMrY5OTCMC2XthIZXRhZO+lDgtAzU86ckudZHmjtGyjAL1jYR7tpYMv0wPyh5E4PYXL
 GDWa5wQQTYxDUbc1zHT7VJrTqliSW7rQIOuQ5GzP/yUVl2RKoE0WKUsjxSsAHccMD58ftulh/v
 n3G4QjRcgykNHQD0luJwJb79xB17Nhs49J2Mj2OnuNnhH8rs0dQoqBqileilhxMCBtVlnKTEV4
 SKCm41N6xhw/Q9Lhsd0zfJul2KuHnUAdg2xbboq5D9//vOpDPJn6cVMNpkH/ZP+BmVg0v1D45T
 +tg=
X-IronPort-AV: E=Sophos;i="5.82,333,1613404800"; 
   d="scan'208";a="169603258"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 May 2021 13:42:38 +0800
IronPort-SDR: Zyb4dvIy7jD6kHYqbltadIFwnklW5EtgRT5Pk5+ytxJ4kCHzjT00Ri7Rxli3VCpPgGyiCjj97q
 ODAqpUeSj3jcY7yqU6BJ7NPNYksXPQo1TYVCbTg1QiuP4AYKvUmRyes+SZVIoWqCSECy8okdKA
 32fr/vyXtmQzIOdiM0/F1gMxVBjLMYFkBgPr8cE0H7kMEtRNGlfOh5VUj4V4wCZT/zUN2LpiVX
 5wGaAe2rmJLO8tqG38PBV4miN+DaXM5uV9ry+sVwrBtMVLEFjcAVYCGA9ci72vdeNVYh0o3w38
 UjAj2j8noQOn6gFuiOsD621R
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 22:22:04 -0700
IronPort-SDR: /k4pXfBOIYla/zz2r9MDNZFrXmo7M+VWOJq+l3NjjO08wFnsFD0b8y3oKR02Bo17DFDDvw4Cub
 eey7fuo5iAR1G7C77XFivlMgfyNOzLxmKwKd7Zf4EU8ysH1AhQgu0Uajsu4kFdEop2qpHyION/
 VMngcdTrZwIWc7f0ahu1ajMZyI3VcVvYJBvCYHIiA4Mfrw+jWnsJx2Sitzj5vsgmKh3+viFwOt
 oUpNdIoGR2QxsrZemcajPtmpNZPNWQSO/Orf8WTTpl3E4c+Go1ucvVuY4nPWkdMbd8A85Dpczb
 pYQ=
WDCIronportException: Internal
Received: from wdmnc1592.ad.shared (HELO naota-xeon) ([10.225.51.161])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 22:42:38 -0700
Date:   Thu, 27 May 2021 14:42:35 +0900
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH] btrfs: zoned: fix zone number to sector/physical
 calculation
Message-ID: <20210527054235.oi7ckhoel65oeb53@naota-xeon>
References: <20210527014659.2222813-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527014659.2222813-1-naohiro.aota@wdc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 27, 2021 at 10:46:59AM +0900, Naohiro Aota wrote:
> In btrfs_get_dev_zone_info(), we have "u32 sb_zone" and calculate "sector_t
> sector" by shifting it. But, this "sector" is calculated in 32bit, leading
> it to be 0 for the 2nd superblock copy.
> 
> Since zone number is u32, shifting it to sector (sector_t) or physical
> address (u64) can easily trigger a missing cast bug like this.
> 
> This commit introduces helpers to convert zone number to sector/LBA, so we
> won't fall into the same pitfall again.
> 
> Fixes: 12659251ca5d ("btrfs: implement log-structured superblock for ZONED mode")
> Cc: stable@vger.kernel.org # 5.11+
> Reported-by: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
> ---
>  fs/btrfs/zoned.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 5feb76bdfc06..a7f77f0a5a86 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -153,6 +153,19 @@ static inline u32 sb_zone_number(int shift, int mirror)
>  	return (u32)zone;
>  }
>  
> +static inline sector_t zone_start_sector(u32 zone_number, struct block_device *bdev)
> +{
> +	sector_t zone_sectors = bdev_zone_sectors(bdev);
> +
> +	return (sector_t)zone_number << ilog2(zone_sectors);
> +}
> +
> +static inline u64 zone_start_physical(u32 zone_number,
> +			   struct btrfs_zoned_device_info *zone_info)
> +{
> +	return (u64)zone_number << zone_info->zone_size_shift;
> +}
> +

I just noticed an indentation fix missed the patch. I will resend
revised version.
