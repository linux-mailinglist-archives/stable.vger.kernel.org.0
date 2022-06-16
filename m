Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5533354E58C
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 17:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377726AbiFPPB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 11:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377733AbiFPPBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 11:01:25 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801FA3DDFA;
        Thu, 16 Jun 2022 08:01:24 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y6so1719305pfr.13;
        Thu, 16 Jun 2022 08:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C8j6eMeb8kEOtOD5xX6PJC7ouZ7zvDeuk9RHJgxkNPQ=;
        b=OuvrIBKECsx9q7KwaDsIfOYnZJB0Y1097U0x6wDtBdCcgteESHA2IIbSJEXx6ySIm4
         x2s4d0tzPIXXITQa/91id9eCBx9KAaFqHAR2Nps43Rsh2LwVlO7ljo7ZB1yH44MO5e7a
         JAfb9wudS+tAsoRrFiSPLWKj+UBVClTkFBzbeM0idu7id4tf+ZpeuFr0vvr6Y1losGP4
         iFXdbpajPEBrmBqgY7RmSGoREcf34tYFUzlSVdPrTEgsGI7YE9h/JR21RKG6OqLgwKUh
         mm2Xha3jGOd2ZIsmKRsOqUY43IVJuj5HderGN59mwS7kxYLbIRHf87VbM9oocXwRtJ2U
         Gu0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C8j6eMeb8kEOtOD5xX6PJC7ouZ7zvDeuk9RHJgxkNPQ=;
        b=oSTEhLo1Le4Q2kpWMIifjFiObbUGBMAlVwE0I4wgYDIzNTcECDbYBc7GhRnFK+vHv5
         tYRrJ2HBzyS99szuErgn0X0WlyoGV9r3wU/9htjHXo849ly1s4iZ9G5K9dGG49csGbrb
         h3RO31y3F7n7JLvAL8tZTjQU93UrMZIwN0yCp5IvjRpUb8z+/jq3N6BscY6SAhh79ngs
         iz5UdICBPJVno9KhisadGrMnAZxPIV84AKul9lUkQMcJE8cVGjDGMseDOvpWIBNEzx0R
         jVoNRlHDdVuQIFtS8vSfJVMnE2Am+rttW9Prcomd8/hiHApvcEpVnGxfOKu2TkL3tHDE
         w5MA==
X-Gm-Message-State: AJIora8HhPmw/SIu8FyzssjXr9IeKj3IHigv3vj8SE4rtrNA1d0V7yzp
        4jQFdAi9zAl+T9lJf3s2JFM=
X-Google-Smtp-Source: AGRyM1sm2iLWj3EkhhHmu6DxVxvaM/9Tc339fcsEWb9Y8kO238R9Vc16cNxZxQVXbivJR4mFWUtLZQ==
X-Received: by 2002:a63:3d0b:0:b0:37f:ef34:1431 with SMTP id k11-20020a633d0b000000b0037fef341431mr4796592pga.547.1655391684027;
        Thu, 16 Jun 2022 08:01:24 -0700 (PDT)
Received: from localhost ([2406:7400:63:5d34:e6c2:4c64:12ae:aa11])
        by smtp.gmail.com with ESMTPSA id bj2-20020a056a00318200b0051c77027d7fsm1819696pfb.218.2022.06.16.08.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 08:01:23 -0700 (PDT)
Date:   Thu, 16 Jun 2022 20:31:18 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 03/10] ext4: Remove EA inode entry from mbcache on inode
 eviction
Message-ID: <20220616150118.bgwmibp6q7dy6wgi@riteshh-domain>
References: <20220614124146.21594-1-jack@suse.cz>
 <20220614160603.20566-3-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614160603.20566-3-jack@suse.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/06/14 06:05PM, Jan Kara wrote:
> Currently we remove EA inode from mbcache as soon as its xattr refcount
> drops to zero. However there can be pending attempts to reuse the inode
> and thus refcount handling code has to handle the situation when
> refcount increases from zero anyway. So save some work and just keep EA
> inode in mbcache until it is getting evicted. At that moment we are sure
> following iget() of EA inode will fail anyway (or wait for eviction to
> finish and load things from the disk again) and so removing mbcache
> entry at that moment is fine and simplifies the code a bit.
>
> CC: stable@vger.kernel.org
> Fixes: 82939d7999df ("ext4: convert to mbcache2")
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/inode.c |  2 ++
>  fs/ext4/xattr.c | 24 ++++++++----------------
>  fs/ext4/xattr.h |  1 +
>  3 files changed, 11 insertions(+), 16 deletions(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3dce7d058985..7450ee734262 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -177,6 +177,8 @@ void ext4_evict_inode(struct inode *inode)
>
>  	trace_ext4_evict_inode(inode);
>
> +	if (EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)
> +		ext4_evict_ea_inode(inode);
>  	if (inode->i_nlink) {
>  		/*
>  		 * When journalling data dirty buffers are tracked only in the
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 042325349098..7fc40fb1e6b3 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -436,6 +436,14 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
>  	return err;
>  }
>
> +/* Remove entry from mbcache when EA inode is getting evicted */
> +void ext4_evict_ea_inode(struct inode *inode)
> +{
> +	if (EA_INODE_CACHE(inode))
> +		mb_cache_entry_delete(EA_INODE_CACHE(inode),
> +			ext4_xattr_inode_get_hash(inode), inode->i_ino);
> +}
> +
>  static int
>  ext4_xattr_inode_verify_hashes(struct inode *ea_inode,
>  			       struct ext4_xattr_entry *entry, void *buffer,
> @@ -976,10 +984,8 @@ int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
>  static int ext4_xattr_inode_update_ref(handle_t *handle, struct inode *ea_inode,
>  				       int ref_change)
>  {
> -	struct mb_cache *ea_inode_cache = EA_INODE_CACHE(ea_inode);
>  	struct ext4_iloc iloc;
>  	s64 ref_count;
> -	u32 hash;
>  	int ret;
>
>  	inode_lock(ea_inode);
> @@ -1002,14 +1008,6 @@ static int ext4_xattr_inode_update_ref(handle_t *handle, struct inode *ea_inode,
>
>  			set_nlink(ea_inode, 1);
>  			ext4_orphan_del(handle, ea_inode);
> -
> -			if (ea_inode_cache) {
> -				hash = ext4_xattr_inode_get_hash(ea_inode);
> -				mb_cache_entry_create(ea_inode_cache,
> -						      GFP_NOFS, hash,
> -						      ea_inode->i_ino,
> -						      true /* reusable */);
> -			}

Ok, so if I understand this correctly, since we are not immediately removing the
ea_inode_cache entry when the recount reaches 0, hence when the refcount is
reaches 1 from 0, we need not create mb_cache entry is it?
Is this since the entry never got deleted in the first place?

But what happens when the entry is created the very first time?
I might need to study xattr code to understand how this condition is taken care.

-ritesh


>  		}
>  	} else {
>  		WARN_ONCE(ref_count < 0, "EA inode %lu ref_count=%lld",
> @@ -1022,12 +1020,6 @@ static int ext4_xattr_inode_update_ref(handle_t *handle, struct inode *ea_inode,
>
>  			clear_nlink(ea_inode);
>  			ext4_orphan_add(handle, ea_inode);
> -
> -			if (ea_inode_cache) {
> -				hash = ext4_xattr_inode_get_hash(ea_inode);
> -				mb_cache_entry_delete(ea_inode_cache, hash,
> -						      ea_inode->i_ino);
> -			}
>  		}
>  	}
>
> diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
> index 77efb9a627ad..060b7a2f485c 100644
> --- a/fs/ext4/xattr.h
> +++ b/fs/ext4/xattr.h
> @@ -178,6 +178,7 @@ extern void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *array);
>
>  extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
>  			    struct ext4_inode *raw_inode, handle_t *handle);
> +extern void ext4_evict_ea_inode(struct inode *inode);
>
>  extern const struct xattr_handler *ext4_xattr_handlers[];
>
> --
> 2.35.3
>
