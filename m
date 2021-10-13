Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850FA42C1D2
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 15:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhJMN5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 09:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhJMN5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 09:57:18 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1109EC061570;
        Wed, 13 Oct 2021 06:55:15 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id w8so2575546qts.4;
        Wed, 13 Oct 2021 06:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Nc/mOiNJLNaOMagWEXdRvRhmAlubyMCJ7W+g+wZiRfY=;
        b=SdpzdspaSeYHxbqXCRty6tTo7SxseGJWtEuDo5Z8QOVUFqM7JnzD8wSSpUpma3My4C
         xZI2gEWDyRC6EBcX79xRMCgAM7UkQXU86Ibq1/GNPS1DV/+GU2gFxVphKzekZI3oRD7Z
         ZWcUQ5rp3aQKcqxxkShJyvQkmYpmlqR2Wts3MDwcdAkt9zwAgxrg5dVaP0gCAZIkWdR2
         SuODhcXF2sTp1bplHkfUZRTm6fT4IysJGsy5QtAI69Ho/7neyL78HjD2k6GLgAU8g2V6
         IL5oitl2kbse2lUCToAb6nBfIs1zu9UasiVEKgRrW7FKQ+5GW+ZMbrHEzXYoiBtmiUR6
         T+1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Nc/mOiNJLNaOMagWEXdRvRhmAlubyMCJ7W+g+wZiRfY=;
        b=XLIwMBy1MLhCIyRInoC7AowO9YIrByxf6oVb2XUFxqOyaOujo0WgYqhzhw0na1uba8
         HanCICEy0RJueMRi0pgmJET/FFHXxalejCB2KEQAfteRzeTTmTjvpdr9Tfju5yOzvqZy
         gpZQrGsEVICZI0czQS4Y43UzMRBHe7ZyNR0cSW3W5MWsjJJBjwbmpxr0uqz9Il8tgzJ2
         6isKAQbFuWyCFO5tMvBQzraclTnNYJJpNs5i3swZChcH608pvF9GpJed3DPvVbAHjsCL
         trrH12+gxfB9G8DY7bOw6/6zCoaZisb/1WgF2DaKtkyn0kWdWVfiQhgrrqFihZ27iRjv
         4KDA==
X-Gm-Message-State: AOAM5315ojAqNbfVBPNDy9XlXRq+t1cl76BGGF6KO1qOSaiS4ygDLdpm
        m33yAp+kwDWmx4FzbaXCkvk=
X-Google-Smtp-Source: ABdhPJxj8Uyrtr7QHMi60qkrzhqEfYUgeF8DDgkx0GqE2zO5dHH4bsEONYt+dzPPrQgbowkgyHYROw==
X-Received: by 2002:ac8:5a:: with SMTP id i26mr29794996qtg.269.1634133314256;
        Wed, 13 Oct 2021 06:55:14 -0700 (PDT)
Received: from localhost.localdomain (c-73-60-226-25.hsd1.nh.comcast.net. [73.60.226.25])
        by smtp.gmail.com with ESMTPSA id h66sm7337995qkc.5.2021.10.13.06.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 06:55:14 -0700 (PDT)
Date:   Wed, 13 Oct 2021 09:55:12 -0400
From:   Eric Whitney <enwlinux@gmail.com>
To:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     stable-commits@vger.kernel.org, enwlinux@gmail.com,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: Patch "ext4: enforce buffer head state assertion in
 ext4_da_map_blocks" has been added to the 5.4-stable tree
Message-ID: <20211013135512.GC8994@localhost.localdomain>
References: <20211013114054.728974-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013114054.728974-1-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Sasha Levin <sashal@kernel.org>:
> This is a note to let you know that I've just added the patch titled
> 
>     ext4: enforce buffer head state assertion in ext4_da_map_blocks
> 
> to the 5.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      ext4-enforce-buffer-head-state-assertion-in-ext4_da_.patch
> and it can be found in the queue-5.4 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
> 
> commit dd19180ca7482668952b8c51499e0676f825189b
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
> index dcbd8ac8d471..af594b5e4f9f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1869,13 +1869,16 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
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
