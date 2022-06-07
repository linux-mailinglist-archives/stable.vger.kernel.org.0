Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CE453F591
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 07:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiFGFhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 01:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiFGFg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 01:36:58 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E988B716C
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 22:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654580217; x=1686116217;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=S6HIgdnvpJEWTDlxWOiam3cuHdffLiZsVVXwO1alQts=;
  b=ncUMLnBRjy5rY+y31IwKdffjoKLCNgWaHZvfsVVCltmnRsFrGGfTDsFm
   XANGbP5ypuBXXCflfV9YXo89SAjrm36i2XmItP6VA6xn8Kjizsld2h4AQ
   Lqy37W/clg7toOO1WdRkc+mydFyosGVPKnsRF4mjfpn26qjQ8H5zm2uzz
   6oCB76n/pXm01oyikGoLYoyVqg4hQ2OL9dAfQ0XreDUJJyggBvaDS/PyS
   STo9jPUZverE+T0PGXdLH1lRjsuy2OSmLc13OwyFnPwQ6d1sVQSH9Kril
   SpqHb6A1hLJFSIXeCeNDFjl3FGFB2CiNzDTrmYvNcMpLGSzkCNWLaY96j
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,282,1647273600"; 
   d="scan'208";a="201183869"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2022 13:36:56 +0800
IronPort-SDR: C0YbbB3f6AnUdV3b4FWcsiKoHIpXhCHTjn/iSvh3zaoIzJroLzduvuB8+I9HKWXkFpJmrsAlfq
 pEJEtHHpSEGya6nF2TSyjJg/U7fTLFx9J7imAhRADIYzH27fQfTA6wBVBfAaDJX8sMXOk7NoCL
 RwV6y7YbhNwiRS41T431oRBBnd2+WjMSeEOEB394lI2AnoO/Cej8JOzZ/dNSTbqklcQX2SW6+K
 xIVF2Vv5LFH6fMWGDwLqEXJ7OmnvfF1N5/Wlb3KsoT3JJQY+Ki4BnvtHkB502eaKThZ3akyto5
 YqjFWIOkMxlv28v4IyGBONON
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jun 2022 22:00:12 -0700
IronPort-SDR: pnx8pXO88ZVKskWUA8AioiK+FxwjDDbxwnBvFYS5Z/gm9gqZJ+BqBh47/PgBrAsHagFiAqMHWJ
 qkaFPaqi1GFWoG4TTGadxF4JcY7xq8r7bZIPb0lL8mWElDzrw6j3iPCWOglIDFa395gg0Aaw3p
 wmm5ZCG2qBaDNi7mAEJXK1hvIfSqHHL5iPCmkseh3G026Yc28/3g3Nl6yScwrhgv+eRH8Z2sKS
 v1qysnfjhKzR8RmR9qgbEkXGSx7lWgvSmUF5erX+y0NePNkNq7UjGkRQjWq32y7LRLcb1Q6nz3
 r/U=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jun 2022 22:36:56 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LHJyH6KcKz1SVnx
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 22:36:55 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1654580215; x=1657172216; bh=S6HIgdnvpJEWTDlxWOiam3cuHdffLiZsVVX
        wO1alQts=; b=LA3zvfHm1HsVw2iXa4NgHY7LwQKJhTDpK2c/p7i8mjPUQ9uE1L7
        ukU6VXnlCY9sDdGgbN3QFDMGxSzRy+t/G5qZgjGAwq0VGsw0uMOobaKXFqHWq7fK
        AKpV/2WYi2xO0N2/It9Znp9micK+xcn7iLHmhmlJT+1H+OOra4ABX9rLVmF6m+5z
        xWY9Vz+LfWJGvL+8ich5hhQMfjayr3B+3mushEs7MYJuXrGTfY3NjKCtylvGw7rM
        /AJSVM5/RiOiboYMl1V81eCGgnFXNr60an1oehK9vWkL4TLtg9ulY6FIlln2lMiP
        lMk3VPDkcj+DIZAYpZ3Ycv0tYVwmzkBq8ww==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Ck6al_4y-btW for <stable@vger.kernel.org>;
        Mon,  6 Jun 2022 22:36:55 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LHJyG4mymz1Rvlc;
        Mon,  6 Jun 2022 22:36:54 -0700 (PDT)
Message-ID: <8d37c287-a669-d25b-0241-32e5ef0a6f57@opensource.wdc.com>
Date:   Tue, 7 Jun 2022 14:36:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: FAILED: patch "[PATCH] zonefs: Fix management of open zones"
 failed to apply to 5.18-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, hans.holmberg@wdc.com,
        johannes.thumshirn@wdc.com, stable@vger.kernel.org
References: <1654518480188221@kroah.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1654518480188221@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/6/22 21:28, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.18-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Greg,

This patch is already applied to 5.18, 5.17, 5.15 and 5.10. I think that 
your bot picked it up again because of the bad PR I sent to Linus for 
5.19 which had these patches included again.

My apologies for the noise.

Thanks !

> 
> ------------------ original commit in Linus's tree ------------------
> 
>  From 19139539207934aef6335bdef09c9e4bd70d1808 Mon Sep 17 00:00:00 2001
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Date: Tue, 12 Apr 2022 17:41:37 +0900
> Subject: [PATCH] zonefs: Fix management of open zones
> 
> The mount option "explicit_open" manages the device open zone
> resources to ensure that if an application opens a sequential file for
> writing, the file zone can always be written by explicitly opening
> the zone and accounting for that state with the s_open_zones counter.
> 
> However, if some zones are already open when mounting, the device open
> zone resource usage status will be larger than the initial s_open_zones
> value of 0. Ensure that this inconsistency does not happen by closing
> any sequential zone that is open when mounting.
> 
> Furthermore, with ZNS drives, closing an explicitly open zone that has
> not been written will change the zone state to "closed", that is, the
> zone will remain in an active state. Since this can then cause failures
> of explicit open operations on other zones if the drive active zone
> resources are exceeded, we need to make sure that the zone is not
> active anymore by resetting it instead of closing it. To address this,
> zonefs_zone_mgmt() is modified to change a REQ_OP_ZONE_CLOSE request
> into a REQ_OP_ZONE_RESET for sequential zones that have not been
> written.
> 
> Fixes: b5c00e975779 ("zonefs: open/close zone on file open/close")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index 75d8dabe0807..e20e7c841489 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -35,6 +35,17 @@ static inline int zonefs_zone_mgmt(struct inode *inode,
>   
>   	lockdep_assert_held(&zi->i_truncate_mutex);
>   
> +	/*
> +	 * With ZNS drives, closing an explicitly open zone that has not been
> +	 * written will change the zone state to "closed", that is, the zone
> +	 * will remain active. Since this can then cause failure of explicit
> +	 * open operation on other zones if the drive active zone resources
> +	 * are exceeded, make sure that the zone does not remain active by
> +	 * resetting it.
> +	 */
> +	if (op == REQ_OP_ZONE_CLOSE && !zi->i_wpoffset)
> +		op = REQ_OP_ZONE_RESET;
> +
>   	trace_zonefs_zone_mgmt(inode, op);
>   	ret = blkdev_zone_mgmt(inode->i_sb->s_bdev, op, zi->i_zsector,
>   			       zi->i_zone_size >> SECTOR_SHIFT, GFP_NOFS);
> @@ -1294,12 +1305,13 @@ static void zonefs_init_dir_inode(struct inode *parent, struct inode *inode,
>   	inc_nlink(parent);
>   }
>   
> -static void zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
> -				   enum zonefs_ztype type)
> +static int zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
> +				  enum zonefs_ztype type)
>   {
>   	struct super_block *sb = inode->i_sb;
>   	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
>   	struct zonefs_inode_info *zi = ZONEFS_I(inode);
> +	int ret = 0;
>   
>   	inode->i_ino = zone->start >> sbi->s_zone_sectors_shift;
>   	inode->i_mode = S_IFREG | sbi->s_perm;
> @@ -1324,6 +1336,22 @@ static void zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
>   	sb->s_maxbytes = max(zi->i_max_size, sb->s_maxbytes);
>   	sbi->s_blocks += zi->i_max_size >> sb->s_blocksize_bits;
>   	sbi->s_used_blocks += zi->i_wpoffset >> sb->s_blocksize_bits;
> +
> +	/*
> +	 * For sequential zones, make sure that any open zone is closed first
> +	 * to ensure that the initial number of open zones is 0, in sync with
> +	 * the open zone accounting done when the mount option
> +	 * ZONEFS_MNTOPT_EXPLICIT_OPEN is used.
> +	 */
> +	if (type == ZONEFS_ZTYPE_SEQ &&
> +	    (zone->cond == BLK_ZONE_COND_IMP_OPEN ||
> +	     zone->cond == BLK_ZONE_COND_EXP_OPEN)) {
> +		mutex_lock(&zi->i_truncate_mutex);
> +		ret = zonefs_zone_mgmt(inode, REQ_OP_ZONE_CLOSE);
> +		mutex_unlock(&zi->i_truncate_mutex);
> +	}
> +
> +	return ret;
>   }
>   
>   static struct dentry *zonefs_create_inode(struct dentry *parent,
> @@ -1333,6 +1361,7 @@ static struct dentry *zonefs_create_inode(struct dentry *parent,
>   	struct inode *dir = d_inode(parent);
>   	struct dentry *dentry;
>   	struct inode *inode;
> +	int ret;
>   
>   	dentry = d_alloc_name(parent, name);
>   	if (!dentry)
> @@ -1343,10 +1372,16 @@ static struct dentry *zonefs_create_inode(struct dentry *parent,
>   		goto dput;
>   
>   	inode->i_ctime = inode->i_mtime = inode->i_atime = dir->i_ctime;
> -	if (zone)
> -		zonefs_init_file_inode(inode, zone, type);
> -	else
> +	if (zone) {
> +		ret = zonefs_init_file_inode(inode, zone, type);
> +		if (ret) {
> +			iput(inode);
> +			goto dput;
> +		}
> +	} else {
>   		zonefs_init_dir_inode(dir, inode, type);
> +	}
> +
>   	d_add(dentry, inode);
>   	dir->i_size++;
>   
> 


-- 
Damien Le Moal
Western Digital Research
