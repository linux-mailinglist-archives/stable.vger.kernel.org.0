Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0023542C1CC
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 15:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhJMNzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 09:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhJMNzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 09:55:49 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100C1C061570;
        Wed, 13 Oct 2021 06:53:46 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id b12so2575695qtq.3;
        Wed, 13 Oct 2021 06:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qLP3FkcbQrP8905JiIIhkRnwbLSYE8OuU6XnZIgVhgQ=;
        b=SOWXQL8zIN0bUKlCGxIRz0aBPBugYGip5SkaDuXBvQkB7k8Q1nCJPnz4kv6qw43T8i
         9ldTcZzzJid7lwWlTWuolPKBJ72U8C0B7kDTMOt8a9CECdU0xiaqAxRWDqORqLARWVvT
         DN0U/Lj447DNNakmK3Trs/idWtw9Cngl1PaKjqlVwsW8EEM6S65s9dskJGcSZQsf9WZd
         CyoKn2fvV+F377UoDDfvj/8B4HAByebVYpf5E6l3CzFBbVWVKJzmTpDBJZ6WFs6ivM81
         6du5WsmuA0uGGcyfif86CVuH0SCik4B6FvySAgkhWef2jTXUADYJJti0mO4y5HgSm0SZ
         IZ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qLP3FkcbQrP8905JiIIhkRnwbLSYE8OuU6XnZIgVhgQ=;
        b=PJzeQc1Ub1CZL3Q41X7nVFT87GrRbdom2r6aRSv7mx/MHwwll3DwvPFK0aSkdhzyHx
         ZwJuA20OWQYreSeSH9Gms3q6Keq4+kUDIwuCxFWKcA1A5Ae4AL0drvS5mhAmh05wClqU
         h17e9nK9jPqhpRKYSE0lhif//2tPOkbHb1VcNPvAXW8HXwbfctNGQkBKigthbKpIKlNV
         vepgQWH3wW4ZZEduhoW0tGvgUNCe7azu0dfwFBbObnM9ISMKBhodP8zhKCn4aHeOPzrx
         hfRZPSkJbhbiEeJosgeI7JxgMBSgShH9pp8wtr6okXRIcM/znNSh1R5zpLJfbRvitVk2
         ChDw==
X-Gm-Message-State: AOAM5306T+6yWm/Pu1OlCKBQI8hDh1SUo0ESC55pcbxhBIvHPdIxHET6
        RlGq/oJ1AtVLbdc7yq0tscywuorQWoM=
X-Google-Smtp-Source: ABdhPJyRqUuY+40c/2sfXTq7HcSFjRh8SFIV+6zKi9eOi3PlnrYHLUO0ojek+lVIu5Xv8Yze7XyMaQ==
X-Received: by 2002:ac8:5f82:: with SMTP id j2mr29995999qta.75.1634133225276;
        Wed, 13 Oct 2021 06:53:45 -0700 (PDT)
Received: from localhost.localdomain (c-73-60-226-25.hsd1.nh.comcast.net. [73.60.226.25])
        by smtp.gmail.com with ESMTPSA id k8sm5035844qkk.37.2021.10.13.06.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 06:53:45 -0700 (PDT)
Date:   Wed, 13 Oct 2021 09:53:43 -0400
From:   Eric Whitney <enwlinux@gmail.com>
To:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     stable-commits@vger.kernel.org, enwlinux@gmail.com,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: Patch "ext4: enforce buffer head state assertion in
 ext4_da_map_blocks" has been added to the 5.14-stable tree
Message-ID: <20211013135343.GA8994@localhost.localdomain>
References: <20211013113653.726356-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013113653.726356-1-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Sasha Levin <sashal@kernel.org>:
> This is a note to let you know that I've just added the patch titled
> 
>     ext4: enforce buffer head state assertion in ext4_da_map_blocks
> 
> to the 5.14-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      ext4-enforce-buffer-head-state-assertion-in-ext4_da_.patch
> and it can be found in the queue-5.14 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
> 
> commit b2838e02c515366e8452370fcda5baa2dcc8be68
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
> index fc6ea56de77c..d204688b32a3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1726,13 +1726,16 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
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
