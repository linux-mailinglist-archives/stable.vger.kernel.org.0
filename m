Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BFD674026
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 18:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjASRkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 12:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjASRkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 12:40:18 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7468F7C6
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 09:40:15 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id t10so2964886vsr.3
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 09:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eeuukOKJ+v76G3XCHdrhKdumLe6It98OJosMQGHmHAc=;
        b=m/n40kEfZwk8dFbLpzgM8gTe/WEbqcbdhx2sLztNe+FhgPHjjI0z1GrSB/dmXN/XPM
         PHMiQUlh5UdnTclg2Uvy8O7JoFeHGV+X8F4lwuPyhn4S3Cq5r2I2qd3pZY2i7TTYz/n/
         9W38zVj2nnN42iZPYZk7qhmkdDyc+y0gxQ/yjRYnXSSCdTtprietNZv7Gch8aUrrMhjI
         /5MjxalWePc4rqWjdt4YJE++srheFg1VPdOHGl5fHevz/CpU0Eb5BGxEwp38xFJouCig
         niVdnELDk9MsNVEowg2GXNHfhIunHEscXb1NHROx3Pfp/lJ3OjQE5AbUpp5SW5cIysfW
         hk4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eeuukOKJ+v76G3XCHdrhKdumLe6It98OJosMQGHmHAc=;
        b=Q6HeQNDPmi6nhp+2jY8RuCyWj+qB2dCKShQ/OzqxP/NXFCtFuVliYcCxAaDE5LVYQZ
         ZZbkMSj/R2deNX/g/iXGqzjOCyYkyfXnuICCcY/6MHpRnY80GZyfbglvrMHvvarDmuYE
         WvJ7MlBNVjCwbeIc4/PwciGTvNLZ7wqvUfyaPGzoiG18Q/GVgSazWNpK6/Js0+KGhEoO
         1LKRHvgm3jOovsWnjZJ2tRlgVtP/smHGWHigdz/KTgbFdJ2sQslaO4hgE4qZj8p3vC+u
         3tLVsttUUEyNYfzh28n/85vdMjXedWRKWT+VF1Mh749xMYWrlElrKAoIe/WS0gS2jvUz
         NBcw==
X-Gm-Message-State: AFqh2krVdtd0bxZfgGWY1jjIbi9oGIkl5VjmzFipdyQGv9388pz1C++Q
        CqSQSVKzKWfEVTo3sB4mgj0=
X-Google-Smtp-Source: AMrXdXuKdthUK6SO5H32TpWAuohGOwM82yIcJB8OVzuFtOHBiR57KXMUy/sVvLPOOT6ltqJXlN7VHw==
X-Received: by 2002:a05:6102:2744:b0:3d0:d7cf:18ca with SMTP id p4-20020a056102274400b003d0d7cf18camr7530299vsu.27.1674150014247;
        Thu, 19 Jan 2023 09:40:14 -0800 (PST)
Received: from debian-BULLSEYE-live-builder-AMD64 (h64-35-202-119.cntcnh.broadband.dynamic.tds.net. [64.35.202.119])
        by smtp.gmail.com with ESMTPSA id f8-20020a05620a408800b0070543181468sm24876277qko.57.2023.01.19.09.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 09:40:13 -0800 (PST)
Date:   Thu, 19 Jan 2023 12:40:11 -0500
From:   Eric Whitney <enwlinux@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Eric Whitney <enwlinux@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 499/521] ext4: fix delayed allocation bug in
 ext4_clu_mapped for bigalloc + inline
Message-ID: <Y8mAe1SlcLD5fykg@debian-BULLSEYE-live-builder-AMD64>
References: <20230116154847.246743274@linuxfoundation.org>
 <20230116154909.507815847@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154909.507815847@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi:

I recommend not backporting this patch or the other three patches apparently
intended to support it to 4.19 stable.  All these patches are related to
ext4's bigalloc feature, which was experimental as of 4.19 (expressly noted by
contemporary versions of e2fsprogs) and also suffered from a number of bugs.
A significant number of additional patches that were applied to 5.X kernels
over time would have to be backported to 4.19 for the patch below to function
correctly. It's really not worth doing that given bigalloc's experimental
status as of 4.19 and the very rare combination of the bigalloc and inline
features.

Thanks,
Eric


* Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> From: Eric Whitney <enwlinux@gmail.com>
> 
> [ Upstream commit 131294c35ed6f777bd4e79d42af13b5c41bf2775 ]
> 
> When converting files with inline data to extents, delayed allocations
> made on a file system created with both the bigalloc and inline options
> can result in invalid extent status cache content, incorrect reserved
> cluster counts, kernel memory leaks, and potential kernel panics.
> 
> With bigalloc, the code that determines whether a block must be
> delayed allocated searches the extent tree to see if that block maps
> to a previously allocated cluster.  If not, the block is delayed
> allocated, and otherwise, it isn't.  However, if the inline option is
> also used, and if the file containing the block is marked as able to
> store data inline, there isn't a valid extent tree associated with
> the file.  The current code in ext4_clu_mapped() calls
> ext4_find_extent() to search the non-existent tree for a previously
> allocated cluster anyway, which typically finds nothing, as desired.
> However, a side effect of the search can be to cache invalid content
> from the non-existent tree (garbage) in the extent status tree,
> including bogus entries in the pending reservation tree.
> 
> To fix this, avoid searching the extent tree when allocating blocks
> for bigalloc + inline files that are being converted from inline to
> extent mapped.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> Link: https://lore.kernel.org/r/20221117152207.2424-1-enwlinux@gmail.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@kernel.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/ext4/extents.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 0bb772cd7f88..1ad4c8eb82c1 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5984,6 +5984,14 @@ int ext4_clu_mapped(struct inode *inode, ext4_lblk_t lclu)
>  	struct ext4_extent *extent;
>  	ext4_lblk_t first_lblk, first_lclu, last_lclu;
>  
> +	/*
> +	 * if data can be stored inline, the logical cluster isn't
> +	 * mapped - no physical clusters have been allocated, and the
> +	 * file has no extents
> +	 */
> +	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> +		return 0;
> +
>  	/* search for the extent closest to the first block in the cluster */
>  	path = ext4_find_extent(inode, EXT4_C2B(sbi, lclu), NULL, 0);
>  	if (IS_ERR(path)) {
> -- 
> 2.35.1
> 
> 
> 
