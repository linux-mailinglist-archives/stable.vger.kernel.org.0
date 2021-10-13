Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C4742C1CF
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 15:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhJMN4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 09:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhJMN4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 09:56:45 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD82C061570;
        Wed, 13 Oct 2021 06:54:41 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id k19so1672358qvm.13;
        Wed, 13 Oct 2021 06:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nb6TZ/DirMgCKWGn9hSLaRC0RwHZQPM9afRb8Z/8+wA=;
        b=jHl2KvkmhZo2U/Ks4kWyBMzEYfFHUpj0pXfozMg38sGViBULXnf4jXAONpzh7q78Zf
         NSZNv3DJjBKK1x7c9zpVfM841FzA8/Z/bW3rfourSUsNQ7QHz8lGaKMLi1HJdlSVoKz2
         CNptzPQWdyutXFJHiNA9IZu74pfRbcdThxrLxgiOI9Y4Ug8CwRD2BJPMcrgD5Rz8fp3d
         uob89xR1yQ+w1OYF1KbQRL4aCST9HVqf3VhoCLsJD+eRghztqmIe9rqIO1PMusIaGdH9
         CiER9aBlpzfKrs32fAxAMyWZZbMIvFMVSb8jyG+R9BhPvM8/FIXJxVTzp/FDrVQj5yni
         CTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nb6TZ/DirMgCKWGn9hSLaRC0RwHZQPM9afRb8Z/8+wA=;
        b=WmVUHrWOo8bRPyoTkAgJfXriFgnYJFbvhIDAH0yrBGqfOSg67u9XpctjM8yG6b8mGG
         Ye4mfbhnXjd7iXk8JbyGNNYG4DnxnBaHDT4NKmqeBvmiaE4RmVKZPEzYh8K6vUkSMhaP
         weyEiP0P7WieyObv7v9h+0kHSQ5Bux52WFPQuSulk7GZ+ykpbfEWSlfzggdZDiQh1VVv
         hahQeN+IllPzHZKB+nZjivVbKVtZ4AWDtsvy2/Ky+joqgFEEp5Fn0BSIg/AnbABqX4Mr
         UPpWxKn8kyrq4FAvey5wrHCslUxvDrSbdXazcHoXZwhypYWAB5y/a4DowsKwETTTyLuL
         9DHw==
X-Gm-Message-State: AOAM53344SMraHisPAqFxnXzt9XjIdmfzdbREc5PVRg+niJG+P0QRWoO
        5rplDhfIP0LrO9Q+3ErPIVbZcuNtk44=
X-Google-Smtp-Source: ABdhPJxzMeyo/Ni+iBHcKC4RQaqS/sO1vgoYOyLwzq7QyuyAkqpMXadSOUckteobtjIA91stjyd+bQ==
X-Received: by 2002:ad4:4ee6:: with SMTP id dv6mr35707568qvb.5.1634133280400;
        Wed, 13 Oct 2021 06:54:40 -0700 (PDT)
Received: from localhost.localdomain (c-73-60-226-25.hsd1.nh.comcast.net. [73.60.226.25])
        by smtp.gmail.com with ESMTPSA id g1sm7353339qkd.89.2021.10.13.06.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 06:54:40 -0700 (PDT)
Date:   Wed, 13 Oct 2021 09:54:38 -0400
From:   Eric Whitney <enwlinux@gmail.com>
To:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     stable-commits@vger.kernel.org, enwlinux@gmail.com,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: Patch "ext4: enforce buffer head state assertion in
 ext4_da_map_blocks" has been added to the 5.10-stable tree
Message-ID: <20211013135438.GB8994@localhost.localdomain>
References: <20211013114005.728150-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013114005.728150-1-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Sasha Levin <sashal@kernel.org>:
> This is a note to let you know that I've just added the patch titled
> 
>     ext4: enforce buffer head state assertion in ext4_da_map_blocks
> 
> to the 5.10-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      ext4-enforce-buffer-head-state-assertion-in-ext4_da_.patch
> and it can be found in the queue-5.10 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
> 
> commit 38c3015b3b8b3a977ca7fa0da8de65c9d8cab2d2
> Author: Eric Whitney <enwlinux@gmail.com>
> Date:   Thu Aug 19 10:49:27 2021 -0400
> 
>     ext4: enforce buffer head state assertion in ext4_da_map_blocks
>     
>     [ Upstream commit 948ca5f30e1df0c11eb5b0f410b9ceb97fa77ad9 ]
>     
>     Remove the code that re-initializes a buffer head with an invalid block
>     number and BH_New and BH_Delay bits when a matching delayed and
>     unwritten block has been found in the extent status cache. Replace it
>     with assertions that verify the buffer head already has this state
>     correctly set.  The current code masked an inline data truncation bug
>     that left stale entries in the extent status cache.  With this change,
>     generic/130 can be used to reproduce and detect that bug.
>     
>     Signed-off-by: Eric Whitney <enwlinux@gmail.com>
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>     Link: https://lore.kernel.org/r/20210819144927.25163-3-enwlinux@gmail.com
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 317aa1b90fb9..fce4fccb8641 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1727,13 +1727,16 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
>  		}
>  
>  		/*
> -		 * Delayed extent could be allocated by fallocate.
> -		 * So we need to check it.
> +		 * the buffer head associated with a delayed and not unwritten
> +		 * block found in the extent status cache must contain an
> +		 * invalid block number and have its BH_New and BH_Delay bits
> +		 * set, reflecting the state assigned when the block was
> +		 * initially delayed allocated
>  		 */
> -		if (ext4_es_is_delayed(&es) && !ext4_es_is_unwritten(&es)) {
> -			map_bh(bh, inode->i_sb, invalid_block);
> -			set_buffer_new(bh);
> -			set_buffer_delay(bh);
> +		if (ext4_es_is_delonly(&es)) {
> +			BUG_ON(bh->b_blocknr != invalid_block);
> +			BUG_ON(!buffer_new(bh));
> +			BUG_ON(!buffer_delay(bh));
>  			return 0;
>  		}
>  

This patch should not be added to the stable tree, as it will be reverted in
5.15.

There have been two reports of unexpected kernel panics triggered by this code
in kernels derived from 5.15-rc4, and the code will be removed for the time
being until the root cause can be determined and corrected in a future release.

Thanks,
Eric

