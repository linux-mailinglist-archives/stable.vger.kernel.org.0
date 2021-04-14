Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC67935FB9A
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 21:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353377AbhDNTXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 15:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbhDNTXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 15:23:05 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495B0C061574;
        Wed, 14 Apr 2021 12:22:44 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id y2so16318239qtw.13;
        Wed, 14 Apr 2021 12:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gHlVQ8mH5RgXQlE1EAk79AxUsgtf+INyJ1bjKFyMNuI=;
        b=mFVh8VJWopJZ188/wDhg9yXpU2OevZuDsjqVlSwLBnpKk3Xb3KwV8QU6EY2YfXHhaw
         V+71QIvqIW5udbME2lF4od4gBb1WVjPcnV8AiuYxCb0uTomEh+yAroGQAo409vHWn1yi
         l2JKZWV21VthAwBO0KoeeR3cwVK6j6Vv0ne4dBEDiZLvb+VUrHfBmKx1O1pc1v3pxfDl
         eFAMeRqyF4gc2AuXqEIKUrbAWPwiLcSenBaZCOSXjnCOJ/ZTRDOES34PbrUabr0dTE1d
         hIYXSoq3KQ3eoQGB71JAz2To0dwQsbO+9NrRcO2ruYlR8wMofyc4J3/qNJ0ZC73pn6IJ
         fNXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gHlVQ8mH5RgXQlE1EAk79AxUsgtf+INyJ1bjKFyMNuI=;
        b=PXxEDGDC+i7jD9V5i3G+iX7JFwUx4aqr6bYuOhy4e2YwljtcKM9BVJWd6ta70U4Qhv
         jenkw0V3YHKQ+aZvUoH8QPWHCUO2WX91bkpRB981BaSJaGavfyOVwPWCe0irqPbjMPdC
         U/iAbRLVOI1OJ9SXorH3mgUGSjlFtMG0sbfm6/FdAAyi7RB7KYsR11qwUqfXq1WBz6eV
         Z4QdDCt32tjeaGlt77JOr1tUNvalcB2bbmjnceWiZ+NnJI8nXkO5LQkWJWree96obf/S
         ycr05dZidcqUcUYQ3nSXoIOIeBAEJfGrCEeHmnGcFy0HFUuZfbfCVHTUggLlB7MLpcwQ
         vEgQ==
X-Gm-Message-State: AOAM530J3APdlFo7qKMayYO8uwylYzKTipi6KzPOdN2SJE9nhbGlyvWQ
        kVG/1rbK8fblGkkv5UyjRZs=
X-Google-Smtp-Source: ABdhPJwUheHbacYyjV+F3MSha9BfEtEz6Gmx/fHMEl5RuFBsnAOBz+vAdP417BYyMVS2hOJ+x95aBg==
X-Received: by 2002:ac8:5f10:: with SMTP id x16mr37831795qta.6.1618428163409;
        Wed, 14 Apr 2021 12:22:43 -0700 (PDT)
Received: from localhost.localdomain (c-73-60-226-25.hsd1.nh.comcast.net. [73.60.226.25])
        by smtp.gmail.com with ESMTPSA id f12sm210932qtq.84.2021.04.14.12.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 12:22:42 -0700 (PDT)
Date:   Wed, 14 Apr 2021 15:22:41 -0400
From:   Eric Whitney <enwlinux@gmail.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Eric Whitney <enwlinux@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: Fix occasional generic/418 failure
Message-ID: <20210414192240.GA8420@localhost.localdomain>
References: <20210414131453.4945-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414131453.4945-1-jack@suse.cz>
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
> Reported-by: Eric Whitney <enwlinux@gmail.com>
> Fixes: 378f32bab371 ("ext4: introduce direct I/O write using iomap infrastructure")
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> Eric, can you please try whether this patch fixes the failures you are
> occasionally seeing?

Sure - the tests are running.  They'll need to run overnight to get us a big
enough sample to verify the fix with a high degree of confidence.  I'll report
when done.

Thanks for the patch!

Eric

> 
> Changes since v1:
> * Rewritten the fix to avoid the need for separate transaction handle for
>   orphan list update
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 194f5d00fa32..be1e80af61be 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -371,15 +371,27 @@ static ssize_t ext4_handle_inode_extension(struct inode *inode, loff_t offset,
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
