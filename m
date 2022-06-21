Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5055528E0
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 03:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239169AbiFUBHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 21:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234162AbiFUBHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 21:07:00 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D36312D32
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 18:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1655773618; x=1687309618;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HKbsMi1e0RfSuUdisGItsG4oZOz3RHqOp1hCHMhh6qU=;
  b=Nw8FQHkhgtktRhzrtQWh9bqQ+4z0Kjq/O99lL3Wcyt23eExh4asY8FLB
   oCoMTA1fOTPRk3odzHhCUL9TXAf3QH02QKOZxwaKlIRiTV7g/64Uz8EBO
   R8lXy/6wXtBDat2rkgX8cF0RMVw+DLNmvY+LUCjIo2rTaaXrvF3OwO7kR
   OCgW8+NcZnLPeNZmNHy7mxHUCD1xy1tSRBQ4q4qpohe9XtrJvY8VfHTDL
   1rug0caOaktYBEddiQHjeT1vMBK3v1b2X+kcMBZ1g4S8Zglx9g8ytNM75
   Tkbi1Cj3P0itexX+yYc4yMXKkGnNCSXCSrdLpOSTNeF97M3P4FwFCMFQc
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,207,1650902400"; 
   d="scan'208";a="307988855"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jun 2022 09:06:57 +0800
IronPort-SDR: 2TYuYRIaLcua2l9ysGY40a3IVpJ44tezAM5Tmj+SyDxRYJgdXHswCuMG8nW8viyPMiKrsAi4Hs
 Dz7aUSfIi7SNe8/dQPUXyB1vJIQoxOcWhHa7YkdB07m9ma9lJ0h+4NlKA2EK1eNOeUVVJFOTvA
 UiQijh9dmpoTkEQNWkLDU22Y6sXLdBfG8g0apItaRiag/0b9rFmaoJo9/t8VArKa6VeLqJjlri
 yFm1MXPO01ZO+mFXF+RVdZ6T08GBkA5jS13GsYCpYZETK7nK3tppsFuCA2l38qjKjZb+nl42ii
 JuzAn48iKEE1WmkF4USn4VSg
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jun 2022 17:25:05 -0700
IronPort-SDR: zWFPfdfzOvZXXf0MDyproXsK8aFa9tHlNrhlDe3m8XTQlL/UAkHR7+jbimJLe7F0xWUoeAQzZC
 JWgUhHZE+jVmhDBZQBUl1KDU37H+V98KO82GfaarWrj2vCcWYX5qyhPP11X++rnX1LUJ+QBBIv
 ITMvPbnLOdrPnoJUyHMhPFRGeOhBz3kotIValFKJQma1p99O80lOJ7vJeC3US8R3HV/F0b2SZk
 gEWpXIReaMlhlwpUwSWi0tQICYYZC+neXRJnJHiyF9KLE7Z5nkC+x0mtKggrzgeuJpGwo3cDDi
 N9c=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jun 2022 18:06:58 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LRpJK2fHkz1SVny
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 18:06:57 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1655773616; x=1658365617; bh=HKbsMi1e0RfSuUdisGItsG4oZOz3RHqOp1h
        CHMhh6qU=; b=VigmMNZ22xCkcLxJ6kKxlc9IPJfLBHDJQ+tB0rn7fiGSH7e/xsy
        X1rNAI7RMcmjIQJY/jVmqcuNXbzSrOVoqYVHtnbzWMk7BB/vtOc2VLBChHfUjl7v
        9TyOnul5QXkWo+gzjnclcvl9rcZx2/rXakDCr+3znOUb4UD1OESC5Sx8K+HbMhLs
        KhBsdB9ued7FrrBnCQgXVKRnLil+8T8SMb4KCgYAZeBcpdoVm+NCj9BGgpMhW/q+
        3BdQ3HQ+QxIWaj/Pn4Ts401PBWWNEHrsp6aD4RR22aEYZdKhodT79X0xFOfZkT0q
        P1ytq7c0bjLOpIw/CL4u/EqLSVbBWvfDg4A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id iEsEPZc1QexI for <stable@vger.kernel.org>;
        Mon, 20 Jun 2022 18:06:56 -0700 (PDT)
Received: from [10.225.163.87] (unknown [10.225.163.87])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LRpJH5n98z1SVnx;
        Mon, 20 Jun 2022 18:06:55 -0700 (PDT)
Message-ID: <30849079-b431-5b06-4008-fb329d16b0cb@opensource.wdc.com>
Date:   Tue, 21 Jun 2022 10:06:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: FAILED: patch "[PATCH] zonefs: fix zonefs_iomap_begin() for
 reads" failed to apply to 5.10-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, Jorgen.Hansen@wdc.com, hch@lst.de,
        johannes.thumshirn@wdc.com
Cc:     stable@vger.kernel.org
References: <165572740383253@kroah.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <165572740383253@kroah.com>
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

On 6/20/22 21:16, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Greg,

I sent you the backported patch in reply to this email.
Thanks !

> 
> ------------------ original commit in Linus's tree ------------------
> 
> From c1c1204c0d0c1dccc1310b9277fb2bd8b663d8fe Mon Sep 17 00:00:00 2001
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Date: Mon, 23 May 2022 16:29:10 +0900
> Subject: [PATCH] zonefs: fix zonefs_iomap_begin() for reads
> 
> If a readahead is issued to a sequential zone file with an offset
> exactly equal to the current file size, the iomap type is set to
> IOMAP_UNWRITTEN, which will prevent an IO, but the iomap length is
> calculated as 0. This causes a WARN_ON() in iomap_iter():
> 
> [17309.548939] WARNING: CPU: 3 PID: 2137 at fs/iomap/iter.c:34 iomap_iter+0x9cf/0xe80
> [...]
> [17309.650907] RIP: 0010:iomap_iter+0x9cf/0xe80
> [...]
> [17309.754560] Call Trace:
> [17309.757078]  <TASK>
> [17309.759240]  ? lock_is_held_type+0xd8/0x130
> [17309.763531]  iomap_readahead+0x1a8/0x870
> [17309.767550]  ? iomap_read_folio+0x4c0/0x4c0
> [17309.771817]  ? lockdep_hardirqs_on_prepare+0x400/0x400
> [17309.778848]  ? lock_release+0x370/0x750
> [17309.784462]  ? folio_add_lru+0x217/0x3f0
> [17309.790220]  ? reacquire_held_locks+0x4e0/0x4e0
> [17309.796543]  read_pages+0x17d/0xb60
> [17309.801854]  ? folio_add_lru+0x238/0x3f0
> [17309.807573]  ? readahead_expand+0x5f0/0x5f0
> [17309.813554]  ? policy_node+0xb5/0x140
> [17309.819018]  page_cache_ra_unbounded+0x27d/0x450
> [17309.825439]  filemap_get_pages+0x500/0x1450
> [17309.831444]  ? filemap_add_folio+0x140/0x140
> [17309.837519]  ? lock_is_held_type+0xd8/0x130
> [17309.843509]  filemap_read+0x28c/0x9f0
> [17309.848953]  ? zonefs_file_read_iter+0x1ea/0x4d0 [zonefs]
> [17309.856162]  ? trace_contention_end+0xd6/0x130
> [17309.862416]  ? __mutex_lock+0x221/0x1480
> [17309.868151]  ? zonefs_file_read_iter+0x166/0x4d0 [zonefs]
> [17309.875364]  ? filemap_get_pages+0x1450/0x1450
> [17309.881647]  ? __mutex_unlock_slowpath+0x15e/0x620
> [17309.888248]  ? wait_for_completion_io_timeout+0x20/0x20
> [17309.895231]  ? lock_is_held_type+0xd8/0x130
> [17309.901115]  ? lock_is_held_type+0xd8/0x130
> [17309.906934]  zonefs_file_read_iter+0x356/0x4d0 [zonefs]
> [17309.913750]  new_sync_read+0x2d8/0x520
> [17309.919035]  ? __x64_sys_lseek+0x1d0/0x1d0
> 
> Furthermore, this causes iomap_readahead() to loop forever as
> iomap_readahead_iter() always returns 0, making no progress.
> 
> Fix this by treating reads after the file size as access to holes,
> setting the iomap type to IOMAP_HOLE, the iomap addr to IOMAP_NULL_ADDR
> and using the length argument as is for the iomap length. To simplify
> the code with this change, zonefs_iomap_begin() is split into the read
> variant, zonefs_read_iomap_begin() and zonefs_read_iomap_ops, and the
> write variant, zonefs_write_iomap_begin() and zonefs_write_iomap_ops.
> 
> Reported-by: Jorgen Hansen <Jorgen.Hansen@wdc.com>
> Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Jorgen Hansen <Jorgen.Hansen@wdc.com>
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index 123464d2145a..053299758deb 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -110,15 +110,51 @@ static inline void zonefs_i_size_write(struct inode *inode, loff_t isize)
>  	}
>  }
>  
> -static int zonefs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
> -			      unsigned int flags, struct iomap *iomap,
> -			      struct iomap *srcmap)
> +static int zonefs_read_iomap_begin(struct inode *inode, loff_t offset,
> +				   loff_t length, unsigned int flags,
> +				   struct iomap *iomap, struct iomap *srcmap)
>  {
>  	struct zonefs_inode_info *zi = ZONEFS_I(inode);
>  	struct super_block *sb = inode->i_sb;
>  	loff_t isize;
>  
> -	/* All I/Os should always be within the file maximum size */
> +	/*
> +	 * All blocks are always mapped below EOF. If reading past EOF,
> +	 * act as if there is a hole up to the file maximum size.
> +	 */
> +	mutex_lock(&zi->i_truncate_mutex);
> +	iomap->bdev = inode->i_sb->s_bdev;
> +	iomap->offset = ALIGN_DOWN(offset, sb->s_blocksize);
> +	isize = i_size_read(inode);
> +	if (iomap->offset >= isize) {
> +		iomap->type = IOMAP_HOLE;
> +		iomap->addr = IOMAP_NULL_ADDR;
> +		iomap->length = length;
> +	} else {
> +		iomap->type = IOMAP_MAPPED;
> +		iomap->addr = (zi->i_zsector << SECTOR_SHIFT) + iomap->offset;
> +		iomap->length = isize - iomap->offset;
> +	}
> +	mutex_unlock(&zi->i_truncate_mutex);
> +
> +	trace_zonefs_iomap_begin(inode, iomap);
> +
> +	return 0;
> +}
> +
> +static const struct iomap_ops zonefs_read_iomap_ops = {
> +	.iomap_begin	= zonefs_read_iomap_begin,
> +};
> +
> +static int zonefs_write_iomap_begin(struct inode *inode, loff_t offset,
> +				    loff_t length, unsigned int flags,
> +				    struct iomap *iomap, struct iomap *srcmap)
> +{
> +	struct zonefs_inode_info *zi = ZONEFS_I(inode);
> +	struct super_block *sb = inode->i_sb;
> +	loff_t isize;
> +
> +	/* All write I/Os should always be within the file maximum size */
>  	if (WARN_ON_ONCE(offset + length > zi->i_max_size))
>  		return -EIO;
>  
> @@ -128,7 +164,7 @@ static int zonefs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	 * operation.
>  	 */
>  	if (WARN_ON_ONCE(zi->i_ztype == ZONEFS_ZTYPE_SEQ &&
> -			 (flags & IOMAP_WRITE) && !(flags & IOMAP_DIRECT)))
> +			 !(flags & IOMAP_DIRECT)))
>  		return -EIO;
>  
>  	/*
> @@ -137,47 +173,44 @@ static int zonefs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	 * write pointer) and unwriten beyond.
>  	 */
>  	mutex_lock(&zi->i_truncate_mutex);
> +	iomap->bdev = inode->i_sb->s_bdev;
> +	iomap->offset = ALIGN_DOWN(offset, sb->s_blocksize);
> +	iomap->addr = (zi->i_zsector << SECTOR_SHIFT) + iomap->offset;
>  	isize = i_size_read(inode);
> -	if (offset >= isize)
> +	if (iomap->offset >= isize) {
>  		iomap->type = IOMAP_UNWRITTEN;
> -	else
> +		iomap->length = zi->i_max_size - iomap->offset;
> +	} else {
>  		iomap->type = IOMAP_MAPPED;
> -	if (flags & IOMAP_WRITE)
> -		length = zi->i_max_size - offset;
> -	else
> -		length = min(length, isize - offset);
> +		iomap->length = isize - iomap->offset;
> +	}
>  	mutex_unlock(&zi->i_truncate_mutex);
>  
> -	iomap->offset = ALIGN_DOWN(offset, sb->s_blocksize);
> -	iomap->length = ALIGN(offset + length, sb->s_blocksize) - iomap->offset;
> -	iomap->bdev = inode->i_sb->s_bdev;
> -	iomap->addr = (zi->i_zsector << SECTOR_SHIFT) + iomap->offset;
> -
>  	trace_zonefs_iomap_begin(inode, iomap);
>  
>  	return 0;
>  }
>  
> -static const struct iomap_ops zonefs_iomap_ops = {
> -	.iomap_begin	= zonefs_iomap_begin,
> +static const struct iomap_ops zonefs_write_iomap_ops = {
> +	.iomap_begin	= zonefs_write_iomap_begin,
>  };
>  
>  static int zonefs_read_folio(struct file *unused, struct folio *folio)
>  {
> -	return iomap_read_folio(folio, &zonefs_iomap_ops);
> +	return iomap_read_folio(folio, &zonefs_read_iomap_ops);
>  }
>  
>  static void zonefs_readahead(struct readahead_control *rac)
>  {
> -	iomap_readahead(rac, &zonefs_iomap_ops);
> +	iomap_readahead(rac, &zonefs_read_iomap_ops);
>  }
>  
>  /*
>   * Map blocks for page writeback. This is used only on conventional zone files,
>   * which implies that the page range can only be within the fixed inode size.
>   */
> -static int zonefs_map_blocks(struct iomap_writepage_ctx *wpc,
> -			     struct inode *inode, loff_t offset)
> +static int zonefs_write_map_blocks(struct iomap_writepage_ctx *wpc,
> +				   struct inode *inode, loff_t offset)
>  {
>  	struct zonefs_inode_info *zi = ZONEFS_I(inode);
>  
> @@ -191,12 +224,12 @@ static int zonefs_map_blocks(struct iomap_writepage_ctx *wpc,
>  	    offset < wpc->iomap.offset + wpc->iomap.length)
>  		return 0;
>  
> -	return zonefs_iomap_begin(inode, offset, zi->i_max_size - offset,
> -				  IOMAP_WRITE, &wpc->iomap, NULL);
> +	return zonefs_write_iomap_begin(inode, offset, zi->i_max_size - offset,
> +					IOMAP_WRITE, &wpc->iomap, NULL);
>  }
>  
>  static const struct iomap_writeback_ops zonefs_writeback_ops = {
> -	.map_blocks		= zonefs_map_blocks,
> +	.map_blocks		= zonefs_write_map_blocks,
>  };
>  
>  static int zonefs_writepage(struct page *page, struct writeback_control *wbc)
> @@ -226,7 +259,8 @@ static int zonefs_swap_activate(struct swap_info_struct *sis,
>  		return -EINVAL;
>  	}
>  
> -	return iomap_swapfile_activate(sis, swap_file, span, &zonefs_iomap_ops);
> +	return iomap_swapfile_activate(sis, swap_file, span,
> +				       &zonefs_read_iomap_ops);
>  }
>  
>  static const struct address_space_operations zonefs_file_aops = {
> @@ -647,7 +681,7 @@ static vm_fault_t zonefs_filemap_page_mkwrite(struct vm_fault *vmf)
>  
>  	/* Serialize against truncates */
>  	filemap_invalidate_lock_shared(inode->i_mapping);
> -	ret = iomap_page_mkwrite(vmf, &zonefs_iomap_ops);
> +	ret = iomap_page_mkwrite(vmf, &zonefs_write_iomap_ops);
>  	filemap_invalidate_unlock_shared(inode->i_mapping);
>  
>  	sb_end_pagefault(inode->i_sb);
> @@ -899,7 +933,7 @@ static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
>  	if (append)
>  		ret = zonefs_file_dio_append(iocb, from);
>  	else
> -		ret = iomap_dio_rw(iocb, from, &zonefs_iomap_ops,
> +		ret = iomap_dio_rw(iocb, from, &zonefs_write_iomap_ops,
>  				   &zonefs_write_dio_ops, 0, NULL, 0);
>  	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ &&
>  	    (ret > 0 || ret == -EIOCBQUEUED)) {
> @@ -948,7 +982,7 @@ static ssize_t zonefs_file_buffered_write(struct kiocb *iocb,
>  	if (ret <= 0)
>  		goto inode_unlock;
>  
> -	ret = iomap_file_buffered_write(iocb, from, &zonefs_iomap_ops);
> +	ret = iomap_file_buffered_write(iocb, from, &zonefs_write_iomap_ops);
>  	if (ret > 0)
>  		iocb->ki_pos += ret;
>  	else if (ret == -EIO)
> @@ -1041,7 +1075,7 @@ static ssize_t zonefs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  			goto inode_unlock;
>  		}
>  		file_accessed(iocb->ki_filp);
> -		ret = iomap_dio_rw(iocb, to, &zonefs_iomap_ops,
> +		ret = iomap_dio_rw(iocb, to, &zonefs_read_iomap_ops,
>  				   &zonefs_read_dio_ops, 0, NULL, 0);
>  	} else {
>  		ret = generic_file_read_iter(iocb, to);
> 


-- 
Damien Le Moal
Western Digital Research
