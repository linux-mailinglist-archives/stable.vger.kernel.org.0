Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC523574D4E
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 14:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238846AbiGNMUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 08:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiGNMUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 08:20:05 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A545D1FCC8;
        Thu, 14 Jul 2022 05:20:04 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so8449407pjl.5;
        Thu, 14 Jul 2022 05:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZOVjcdt9wEMFP8TEqOCpAFX4T/nzoeDiNa12y9FfkJ0=;
        b=eXQ9JaehgvFOp6AVRKUS8z+2L6GcbXS20TD90h1haT9zxFMhs5eCr/woSQdaxLuywV
         P4rK6nh3A5fGaki0rmKB6SgMzRkI8pSCZJsc1/RKOpSrDXZgFekQkOGXeT35XS/T6lot
         3lxUGQ5WzLHFS5f8D/Hl9rXik1t+WAyrXF6VDfClB0PoK2QN3M51+xhbabrxgSfj6jq8
         ChlOVw5/19Beqt6Bd6CDR4w7lfuws0WHteVYOIVFjE/dE6sc6/GdAAlcHcenNhmWLFJI
         himHc9bUrcLc6rDSZul8r1O0bPku/xqzv+nYKu98i2fXkweDmUQMKZ0iWkTWytq0RJhe
         uoRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZOVjcdt9wEMFP8TEqOCpAFX4T/nzoeDiNa12y9FfkJ0=;
        b=hZ5RDThr5XEk1LELcRJL0NUNDS1yApPzLt5aqUHcc+2UfCS8xPD8MxmSqiybd+eiyU
         +UcpIt9aMeT0KVEsTbBRvHAMWobTcva+KB1L+lgA5pTI5STtA4jbZ1ypFgDFx+1AyPkw
         /b1yzG+gnBEWMrI3i7IutjNQxD1h4/RdvRU+9Y+JonF7NRuZKG1mpRIy1ka17HyHSTsx
         LxAgH4/UkW0cWJiDIput4mO7imYzH9XandTUG6yOokoYhyLD1N+y4GzUcCGEtu8UyIcC
         kdj5cruS7xZIUnYK7dzr+afdGo8OwO4NspVN4pLqMKYmd716HBTsc25mPa3+gpj6G3U0
         Hdxg==
X-Gm-Message-State: AJIora8v9Dt/0akh78OCmvKhnm6S8byxmG4gltegr7YsbhBU8Xt7YWM5
        kEVz6XQsM7NdUaY3RbeKNJA=
X-Google-Smtp-Source: AGRyM1t0+N5Le2Rf9fiCU5cSchb3BdUi3MbJhf+yDXLrZC9Qc+SabGlpnW5YekS80WlBF54RFAlVzA==
X-Received: by 2002:a17:90b:1b51:b0:1f0:3350:6854 with SMTP id nv17-20020a17090b1b5100b001f033506854mr16296686pjb.52.1657801204153;
        Thu, 14 Jul 2022 05:20:04 -0700 (PDT)
Received: from localhost ([2406:7400:63:cb1d:811:33e9:9bc2:d40])
        by smtp.gmail.com with ESMTPSA id e4-20020aa79804000000b0051b9ecb53e6sm1498467pfl.105.2022.07.14.05.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 05:20:03 -0700 (PDT)
Date:   Thu, 14 Jul 2022 17:49:59 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 04/10] ext4: Unindent codeblock in ext4_xattr_block_set()
Message-ID: <20220714121959.kiyxjv7uorjup5qo@riteshh-domain>
References: <20220712104519.29887-1-jack@suse.cz>
 <20220712105436.32204-4-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712105436.32204-4-jack@suse.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/07/12 12:54PM, Jan Kara wrote:
> Remove unnecessary else (and thus indentation level) from a code block
> in ext4_xattr_block_set(). It will also make following code changes
> easier. No functional changes.

The patch looks good to me. Just a note, while applying this patch on ext4-dev
tree, I found a minor conflict with below patch.

ext4: use kmemdup() to replace kmalloc + memcpy

Replace kmalloc + memcpy with kmemdup()

-ritesh

>
> CC: stable@vger.kernel.org
> Fixes: 82939d7999df ("ext4: convert to mbcache2")
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/xattr.c | 79 ++++++++++++++++++++++++-------------------------
>  1 file changed, 39 insertions(+), 40 deletions(-)
>
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 7fc40fb1e6b3..aadfae53d055 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1850,6 +1850,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  #define header(x) ((struct ext4_xattr_header *)(x))
>
>  	if (s->base) {
> +		int offset = (char *)s->here - bs->bh->b_data;
> +
>  		BUFFER_TRACE(bs->bh, "get_write_access");
>  		error = ext4_journal_get_write_access(handle, sb, bs->bh,
>  						      EXT4_JTR_NONE);
> @@ -1882,50 +1884,47 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  			if (error)
>  				goto cleanup;
>  			goto inserted;
> -		} else {
> -			int offset = (char *)s->here - bs->bh->b_data;
> +		}
> +		unlock_buffer(bs->bh);
> +		ea_bdebug(bs->bh, "cloning");
> +		s->base = kmalloc(bs->bh->b_size, GFP_NOFS);
> +		error = -ENOMEM;
> +		if (s->base == NULL)
> +			goto cleanup;
> +		memcpy(s->base, BHDR(bs->bh), bs->bh->b_size);
> +		s->first = ENTRY(header(s->base)+1);
> +		header(s->base)->h_refcount = cpu_to_le32(1);
> +		s->here = ENTRY(s->base + offset);
> +		s->end = s->base + bs->bh->b_size;
>
> -			unlock_buffer(bs->bh);
> -			ea_bdebug(bs->bh, "cloning");
> -			s->base = kmalloc(bs->bh->b_size, GFP_NOFS);
> -			error = -ENOMEM;
> -			if (s->base == NULL)
> +		/*
> +		 * If existing entry points to an xattr inode, we need
> +		 * to prevent ext4_xattr_set_entry() from decrementing
> +		 * ref count on it because the reference belongs to the
> +		 * original block. In this case, make the entry look
> +		 * like it has an empty value.
> +		 */
> +		if (!s->not_found && s->here->e_value_inum) {
> +			ea_ino = le32_to_cpu(s->here->e_value_inum);
> +			error = ext4_xattr_inode_iget(inode, ea_ino,
> +				      le32_to_cpu(s->here->e_hash),
> +				      &tmp_inode);
> +			if (error)
>  				goto cleanup;
> -			memcpy(s->base, BHDR(bs->bh), bs->bh->b_size);
> -			s->first = ENTRY(header(s->base)+1);
> -			header(s->base)->h_refcount = cpu_to_le32(1);
> -			s->here = ENTRY(s->base + offset);
> -			s->end = s->base + bs->bh->b_size;
>
> -			/*
> -			 * If existing entry points to an xattr inode, we need
> -			 * to prevent ext4_xattr_set_entry() from decrementing
> -			 * ref count on it because the reference belongs to the
> -			 * original block. In this case, make the entry look
> -			 * like it has an empty value.
> -			 */
> -			if (!s->not_found && s->here->e_value_inum) {
> -				ea_ino = le32_to_cpu(s->here->e_value_inum);
> -				error = ext4_xattr_inode_iget(inode, ea_ino,
> -					      le32_to_cpu(s->here->e_hash),
> -					      &tmp_inode);
> -				if (error)
> -					goto cleanup;
> -
> -				if (!ext4_test_inode_state(tmp_inode,
> -						EXT4_STATE_LUSTRE_EA_INODE)) {
> -					/*
> -					 * Defer quota free call for previous
> -					 * inode until success is guaranteed.
> -					 */
> -					old_ea_inode_quota = le32_to_cpu(
> -							s->here->e_value_size);
> -				}
> -				iput(tmp_inode);
> -
> -				s->here->e_value_inum = 0;
> -				s->here->e_value_size = 0;
> +			if (!ext4_test_inode_state(tmp_inode,
> +					EXT4_STATE_LUSTRE_EA_INODE)) {
> +				/*
> +				 * Defer quota free call for previous
> +				 * inode until success is guaranteed.
> +				 */
> +				old_ea_inode_quota = le32_to_cpu(
> +						s->here->e_value_size);
>  			}
> +			iput(tmp_inode);
> +
> +			s->here->e_value_inum = 0;
> +			s->here->e_value_size = 0;
>  		}
>  	} else {
>  		/* Allocate a buffer where we construct the new block. */
> --
> 2.35.3
>
