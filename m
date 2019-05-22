Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD0AD271D1
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 23:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730075AbfEVVoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 17:44:46 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:42930 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729752AbfEVVoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 17:44:46 -0400
Received: by mail-yw1-f66.google.com with SMTP id s5so1438580ywd.9
        for <stable@vger.kernel.org>; Wed, 22 May 2019 14:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=omnibond-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+U25ugincLLIJzKVGUO4d13q2ofk13rCni/NM43MthE=;
        b=wvIeLbs8tXj/V+7dlsuremfP54xMre97ghIYRAw2d80LxF7Prs6jbpJ7qGIblN5DaQ
         fzfHrfnOkUwUjWSiM6g04vId8nMdZaINNerfjXFSZ8B5K9Y3t5nkhSvUrzDJT8TH6/uc
         PrcanSUgxv6jFO1Tejr9Fpp5L6RPFKVZ3B4tjFtE2P7m/1d7cJY+oQBHxoFHVHMSahLE
         KJKJ4OiE0FZmlkjyVq8R7a8UXBpQdnS+AykXYcdy3kAPTpQRv9cUwbCsGkpR6Pp2ebzp
         ALax8ChcW1STMNollaxZPG/xFxaPgszasu52tqkIADBQpKhg0NLCwJ9zr+DpGJMM1OZg
         fjIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+U25ugincLLIJzKVGUO4d13q2ofk13rCni/NM43MthE=;
        b=c/SsymH6ecJNh/xzEeZgzpov8+2P2R9O1VW4uFXYB64CjdMpTiEtVUn1SXoxhq948Z
         ICPI7W0LZ01jdISPOi7bA7eM7GBp32zIfkh4akSHkuUfzPGgIgLmodlvwsXlO+tddebx
         dcAPupC8Ptsl1gEG3bMqImpjSQoOhqPosOGwQXb2airvUyRui42B9OPQbHLoM0Rp5NsN
         hcycDFgppLDcOluZnIzoISichxeYXlHTrZqZ9L+REFgtqTXeu5WYBIONvWzJonGfhojD
         mPbMV2Cx+FKL15X2DcSyMitG0f49lNdOZ4VQbMRnEZsSE8OeZZGCan/T6ZVsETSEnY7I
         9SKg==
X-Gm-Message-State: APjAAAWXlatWXamim1Cp5r6thtoKmanmndP68AGnM7LgiIJXDvKJIrr7
        uCpvcH6Gc9612rjh0ORGrShwPrHukJtr/g==
X-Google-Smtp-Source: APXvYqwd42palRiYNvvsXAgQvmQ8qs/chUXHybI4l4rSQdA0/uaMWee5epSYw38d2XETjIEwM0IOJg==
X-Received: by 2002:a0d:e544:: with SMTP id o65mr44187293ywe.382.1558561485696;
        Wed, 22 May 2019 14:44:45 -0700 (PDT)
Received: from t480s.mkb.name (047-049-164-163.biz.spectrum.com. [47.49.164.163])
        by smtp.gmail.com with ESMTPSA id x125sm9892550ywx.47.2019.05.22.14.44.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 14:44:44 -0700 (PDT)
Date:   Wed, 22 May 2019 17:44:37 -0400
From:   martin@omnibond.com
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Marshall <hubcap@omnibond.com>, devel@lists.orangefs.org
Subject: Re: [PATCH AUTOSEL 5.1 025/375] orangefs: truncate before updating
 size
Message-ID: <20190522214437.GA87137@t480s.mkb.name>
References: <20190522192115.22666-1-sashal@kernel.org>
 <20190522192115.22666-25-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522192115.22666-25-sashal@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I don't think it makes much sense to put this one in stable.  Without
the rest of the pagecache patches the race doesn't exist.

Martin

On Wed, May 22, 2019 at 03:15:25PM -0400, Sasha Levin wrote:
> From: Martin Brandenburg <martin@omnibond.com>
> 
> [ Upstream commit 33713cd09ccdc1e01b10d0782ae60200d4989553 ]
> 
> Otherwise we race with orangefs_writepage/orangefs_writepages
> which and does not expect i_size < page_offset.
> 
> Fixes xfstests generic/129.
> 
> Signed-off-by: Martin Brandenburg <martin@omnibond.com>
> Signed-off-by: Mike Marshall <hubcap@omnibond.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/orangefs/inode.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
> index c3334eca18c7e..3260f757c0803 100644
> --- a/fs/orangefs/inode.c
> +++ b/fs/orangefs/inode.c
> @@ -172,7 +172,11 @@ static int orangefs_setattr_size(struct inode *inode, struct iattr *iattr)
>  	}
>  	orig_size = i_size_read(inode);
>  
> -	truncate_setsize(inode, iattr->ia_size);
> +	/* This is truncate_setsize in a different order. */
> +	truncate_pagecache(inode, iattr->ia_size);
> +	i_size_write(inode, iattr->ia_size);
> +	if (iattr->ia_size > orig_size)
> +		pagecache_isize_extended(inode, orig_size, iattr->ia_size);
>  
>  	new_op = op_alloc(ORANGEFS_VFS_OP_TRUNCATE);
>  	if (!new_op)
> -- 
> 2.20.1
> 
