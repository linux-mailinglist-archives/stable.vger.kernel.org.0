Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FCE36133D
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 21:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbhDOT7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 15:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbhDOT7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 15:59:17 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0629DC061574;
        Thu, 15 Apr 2021 12:58:54 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id x27so12359494qvd.2;
        Thu, 15 Apr 2021 12:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=awd1ERb/pc00DKswh6Utn9qSQ60M4TGoVLVADWukN/g=;
        b=FJ7GPf6VVf6evCpoJQqwk0xsizsVxZoo6SXBcFPMGQdAFIwuGVyHRKw61m03BKODMw
         sxAhrnoQR8Li4AfWZzi+aWZyof3nE8xIx7egtpHW6bUrpoKf2uujv//fW9SOlpc7KR7c
         kLg/J7BKlvfZ+3Buqdbxm3tf1YhKjBPDsSg3ZfxCxRJUsq3Pwa6nTdJaPRL2EjgzSVZi
         bYRE/OP4gEEViYg2Tx6OWuAZ89muXOPuCNhNIkNlg/3ftZg888/tmDWug7VDjbV5TkKY
         rJhtaLXDzWou+CzvZzpjFLdh86VkYcn7Ov5lenVk8zOvZQi5vICiUbAq3YIsIiKhXVLa
         n2Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=awd1ERb/pc00DKswh6Utn9qSQ60M4TGoVLVADWukN/g=;
        b=lh0Ly/l5l8OuXmPFIg4jwbKueZR7CWFKKmRgxBEOOGMnsm8Z1CQ4owCld1109K47eh
         FFI9gpmA+oARtlz7sM9zBYFFKt4Dr/wdi+jPzzhl2dbwB4zju285cwJ1Cxz7kp+qaQ9/
         TqKAO8GAsckqHAOsjfOoBHwSmAZse6hPkezbH7uLBrHaKUoQ5PuDARh72p9XiZ+meMCf
         NbRNaWcphATj4DtifG/UqTJvkfnt9cMFEg5+UdrSwEazD6SVTBigPch9rud/EpvsGnrc
         uUU1G51ixYchcypuTbI80L+kf/EGYptX0y8Y2KoBxKRaigiqgh0JSo+tM3sdnJLxyIbS
         ICQQ==
X-Gm-Message-State: AOAM530NYMIyenzoA9eea52QGoe39bmaITHYEzDcW7GMRYp0qsMoFvLl
        YeouwHLa7SPoe2dmm7871dw=
X-Google-Smtp-Source: ABdhPJy/1urDbWA6vw4XCwkn+o9ASpUjMQOTB6CpD7EB2Vl2ABulU88ZWPnriwrVS7tB4FT3IF4IEw==
X-Received: by 2002:a05:6214:165:: with SMTP id y5mr4876742qvs.59.1618516733305;
        Thu, 15 Apr 2021 12:58:53 -0700 (PDT)
Received: from localhost.localdomain (c-73-60-226-25.hsd1.nh.comcast.net. [73.60.226.25])
        by smtp.gmail.com with ESMTPSA id q15sm2364377qtx.47.2021.04.15.12.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 12:58:52 -0700 (PDT)
Date:   Thu, 15 Apr 2021 15:58:50 -0400
From:   Eric Whitney <enwlinux@gmail.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Eric Whitney <enwlinux@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] ext4: Fix occasional generic/418 failure
Message-ID: <20210415195850.GA16226@localhost.localdomain>
References: <20210415155417.4734-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415155417.4734-1-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Jan Kara <jack@suse.cz>:
> Eric has noticed that after pagecache read rework, generic/418 is
> occasionally failing for ext4 when blocksize < pagesize. In fact, the
> pagecache rework just made hard to hit race in ext4 more likely. The
> problem is that since ext4 conversion of direct IO writes to iomap
> framework (commit 378f32bab371), we update inode size after direct IO
> write only after invalidating page cache. Thus if buffered read sneaks
> at unfortunate moment like:
> 
> CPU1 - write at offset 1k                       CPU2 - read from offset 0
> iomap_dio_rw(..., IOMAP_DIO_FORCE_WAIT);
>                                                 ext4_readpage();
> ext4_handle_inode_extension()
> 
> the read will zero out tail of the page as it still sees smaller inode
> size and thus page cache becomes inconsistent with on-disk contents with
> all the consequences.
> 
> Fix the problem by moving inode size update into end_io handler which
> gets called before the page cache is invalidated.
> 
> Reported-and-tested-by: Eric Whitney <enwlinux@gmail.com>
> Fixes: 378f32bab371 ("ext4: introduce direct I/O write using iomap infrastructure")
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 194f5d00fa32..7924634ab0bf 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -371,15 +371,32 @@ static ssize_t ext4_handle_inode_extension(struct inode *inode, loff_t offset,
>  static int ext4_dio_write_end_io(struct kiocb *iocb, ssize_t size,
>  				 int error, unsigned int flags)
>  {
> -	loff_t offset = iocb->ki_pos;
> +	loff_t pos = iocb->ki_pos;
>  	struct inode *inode = file_inode(iocb->ki_filp);
>  
>  	if (error)
>  		return error;
>  
> -	if (size && flags & IOMAP_DIO_UNWRITTEN)
> -		return ext4_convert_unwritten_extents(NULL, inode,
> -						      offset, size);
> +	if (size && flags & IOMAP_DIO_UNWRITTEN) {
> +		error = ext4_convert_unwritten_extents(NULL, inode, pos, size);
> +		if (error < 0)
> +			return error;
> +	}
> +	/*
> +	 * If we are extending the file, we have to update i_size here before
> +	 * page cache gets invalidated in iomap_dio_rw(). Otherwise racing
> +	 * buffered reads could zero out too much from page cache pages. Update
> +	 * of on-disk size will happen later in ext4_dio_write_iter() where
> +	 * we have enough information to also perform orphan list handling etc.
> +	 * Note that we perform all extending writes synchronously under
> +	 * i_rwsem held exclusively so i_size update is safe here in that case.
> +	 * If the write was not extending, we cannot see pos > i_size here
> +	 * because operations reducing i_size like truncate wait for all
> +	 * outstanding DIO before updating i_size.
> +	 */
> +	pos += size;
> +	if (pos > i_size_read(inode))
> +		i_size_write(inode, pos);
>  
>  	return 0;
>  }
> -- 
> 2.26.2
> 


With additional data, the generic/068 failure I saw on the data=journal test
configuration when testing the v2 version of this patch doesn't appear to be
a regression.  100 runs of 068 on a v2 patched -rc7 kernel failed five times,
and it failed three times on an unpatched -rc7 kernel.  So, that failure is
most likely a latent problem unrelated to this patch.

Thanks,
Eric
