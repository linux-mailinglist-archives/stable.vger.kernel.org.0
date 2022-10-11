Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7395FBE7D
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 01:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJKXq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 19:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiJKXq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 19:46:56 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7459912D19
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 16:46:53 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 78so14070485pgb.13
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 16:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NXIZJTtVhqCpmyGjXMWK48RPmdnN8LgdLSZxMWzlW54=;
        b=VUROlRoYgzR70sQJFbpLvMSbh8bjmCg+iVdR7RSAsmc2GNvFxI/h4ESUYMGaloqv4Q
         O2zBYNVG+uyT7271G7zQNxrozKHUA+Tx6kZUdGKtLcddxNVFpHMIrU4ZQZLlv1LNzmXJ
         kGS4/EsrZ1wV18wXVjE3xThqiLKPUiPWTwBk5lbdzhfwrLp1Cs+L/gaRUtVL0cueFs/F
         ZX4sTamhLXAzfmNYbWFgQljACZ7/mn/+E5hysHFGLgE0NM7CpdXVZlOLl8SnZTZ8FuRT
         BghgxbWTKUJLUFAh2DEQqD1nJFvkll5hBCQ/nAYgV5yY+U+N87OhniNTIovWLG766DP3
         7Ubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NXIZJTtVhqCpmyGjXMWK48RPmdnN8LgdLSZxMWzlW54=;
        b=eauAzTLeVLl2TgqTmDFWYsRS/6sS6h1kvAaPHpYFr/KhiurMHNSq67X0R/YBuUx7yx
         Ko3sbfLXXBUE0uGW0gl2nxE38dS/OPaciFl672F5M01U21KdpJc4PcCb2F3ozECbkKIm
         Kvoz6pt+8V+lD+Y/mRUzTQbRE+3eVEGB/YqRlen2+PTgo37gr29RWq4fG2QY4JGXgl6P
         /KT8Eou00zMi/Xd3BS2yx6xa7Y/XGgEV8ifTr+vhltdHWb2ez4ui4zd1ZKcHzzts0FHg
         nbdl4qDKWkUaaC2QY6OBdPGhzjT25ZsT3tbK4XIYbOMmk9/2X+RB4borMoFka9GBtosg
         koow==
X-Gm-Message-State: ACrzQf30d9yks8wzVbOGE51fV+m5bebvD9L4wQPYLxJo7jHzmGFDeTD4
        bJ87KxbfuG/iYjAcqGJzwfQM5A==
X-Google-Smtp-Source: AMsMyM5Ch+o6zNkMhMyXMxtlm7R5W1U/84gENt06G22RZbktX34GcbWPf0GyyDfHQ3unvKWyC4NbRw==
X-Received: by 2002:a65:6b8e:0:b0:44f:ec0f:f684 with SMTP id d14-20020a656b8e000000b0044fec0ff684mr22336295pgw.25.1665532012852;
        Tue, 11 Oct 2022 16:46:52 -0700 (PDT)
Received: from relinquished.localdomain ([2600:380:8047:f466:3e42:98bc:71a6:f1b7])
        by smtp.gmail.com with ESMTPSA id r27-20020aa7963b000000b005636d8aa98dsm4543908pfg.141.2022.10.11.16.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 16:46:52 -0700 (PDT)
Date:   Tue, 11 Oct 2022 16:46:49 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 33/46] btrfs: get rid of block group caching
 progress logic
Message-ID: <Y0YAaXPzuSmSKwiG@relinquished.localdomain>
References: <20221011145015.1622882-1-sashal@kernel.org>
 <20221011145015.1622882-33-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011145015.1622882-33-sashal@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 11, 2022 at 10:50:01AM -0400, Sasha Levin wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> [ Upstream commit 48ff70830bec1ccc714f4e31059df737f17ec909 ]
> 
> struct btrfs_caching_ctl::progress and struct
> btrfs_block_group::last_byte_to_unpin were previously needed to ensure
> that unpin_extent_range() didn't return a range to the free space cache
> before the caching thread had a chance to cache that range. However, the
> commit "btrfs: fix space cache corruption and potential double
> allocations" made it so that we always synchronously cache the block
> group at the time that we pin the extent, so this machinery is no longer
> necessary.
> 
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/btrfs/block-group.c     | 13 ------------
>  fs/btrfs/block-group.h     |  2 --
>  fs/btrfs/extent-tree.c     |  9 ++-------
>  fs/btrfs/free-space-tree.c |  8 --------
>  fs/btrfs/transaction.c     | 41 --------------------------------------
>  fs/btrfs/zoned.c           |  1 -
>  6 files changed, 2 insertions(+), 72 deletions(-)

Hi, Sasha,

This commit is a cleanup. Please drop it from 6.0 and 5.19.

Thanks,
Omar
