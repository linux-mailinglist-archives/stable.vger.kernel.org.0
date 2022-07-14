Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFC1574D44
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 14:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238354AbiGNMPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 08:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiGNMPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 08:15:39 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E98275D3;
        Thu, 14 Jul 2022 05:15:38 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id fz10so2717848pjb.2;
        Thu, 14 Jul 2022 05:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XpMOn6GHmpbn67dLURX5KQmmlMf+JtWjMyaO5NMuNA0=;
        b=hFPn5UlXDky5uKdnyyRZW7Ryj6M2C8b0tpXo3aq53nbNtfv2RQw2pmcz0NkTm5CIfF
         /fkK1juklP+/m9dqAdzNJQjboMpR7VDmYcvQtyqpqdnH96TuiBvnkco3KwKpr5CXX0+J
         nB7VirN6mllO989cwXczrRzFfrejllwyr0tIz3n9J9aBNzgQmIE0fquxbqIcO/KoAwqc
         5PFpxwTG/QC7Bgm3YFvlqN11KJc/m8cb/JorBKKlNFYwGiA8xo5XVUgchdXesIzQbACe
         wUehsYdU/uUki42bYNVvhl85yoHgPU/Q7a3DGvhlM7l0Iu6oygz5u+p0eOrcMLr6Y9YS
         U2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XpMOn6GHmpbn67dLURX5KQmmlMf+JtWjMyaO5NMuNA0=;
        b=a9IpUUCpl/tdLMIL33AsY19i7Je4wt7oz570JOVJPWwkhElYm4szqr9fXbVu7GV4WK
         q0HVCPutMKbfJdlFFPGL9T2JBtMlZCfzwognQcYkOaIIjFMD5/wdVNLNgDOhsJsM8oJK
         HXuBQuEOwGf91LMeDOdYOdzNh6oaOqjsDffZuI0BDF0IEy5HOSFatYCoXk3JLUWf7y0Z
         lT1Ev1hboJRbhEI8euhBIbqwkfXKlpthmYHGiuw0E/cllnxwbIB1xc9DOElbVZykO5Rt
         SfSlivFL+s1E1kj0vmaVzoMxqHcnd1oGDAeQQ1uOvTy710YV6X3Rn/M41xZM0n7YU0/V
         lpEw==
X-Gm-Message-State: AJIora+q03bm83SQxXi9U3oEUtli1sxIGx5RgKnl2bmCFgya+/rO5LWd
        UOyQE7QLLuqf3TQXH3VQR2zJTZDVc4A=
X-Google-Smtp-Source: AGRyM1vh3892D+nLD1T9HewwIjBPUf6QJ3X0Z0V+orXUeRT4shcRtJ+VZFRhMBYd8u3mhIJ3Dmaegg==
X-Received: by 2002:a17:903:1109:b0:16c:b5e7:652f with SMTP id n9-20020a170903110900b0016cb5e7652fmr1456156plh.142.1657800937621;
        Thu, 14 Jul 2022 05:15:37 -0700 (PDT)
Received: from localhost ([2406:7400:63:cb1d:811:33e9:9bc2:d40])
        by smtp.gmail.com with ESMTPSA id d7-20020a170902cec700b0016c4f0065b4sm1345759plg.84.2022.07.14.05.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 05:15:37 -0700 (PDT)
Date:   Thu, 14 Jul 2022 17:45:32 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 02/10] mbcache: Add functions to delete entry if unused
Message-ID: <20220714121532.xwh72dnys3ngg37k@riteshh-domain>
References: <20220712104519.29887-1-jack@suse.cz>
 <20220712105436.32204-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712105436.32204-2-jack@suse.cz>
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
> Add function mb_cache_entry_delete_or_get() to delete mbcache entry if
> it is unused and also add a function to wait for entry to become unused
> - mb_cache_entry_wait_unused(). We do not share code between the two
> deleting function as one of them will go away soon.
>
> CC: stable@vger.kernel.org
> Fixes: 82939d7999df ("ext4: convert to mbcache2")
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/mbcache.c            | 66 +++++++++++++++++++++++++++++++++++++++--
>  include/linux/mbcache.h | 10 ++++++-
>  2 files changed, 73 insertions(+), 3 deletions(-)
>
> diff --git a/fs/mbcache.c b/fs/mbcache.c
> index cfc28129fb6f..2010bc80a3f2 100644
> --- a/fs/mbcache.c
> +++ b/fs/mbcache.c
> @@ -11,7 +11,7 @@
>  /*
>   * Mbcache is a simple key-value store. Keys need not be unique, however
>   * key-value pairs are expected to be unique (we use this fact in
> - * mb_cache_entry_delete()).
> + * mb_cache_entry_delete_or_get()).
>   *
>   * Ext2 and ext4 use this cache for deduplication of extended attribute blocks.
>   * Ext4 also uses it for deduplication of xattr values stored in inodes.
> @@ -125,6 +125,19 @@ void __mb_cache_entry_free(struct mb_cache_entry *entry)
>  }
>  EXPORT_SYMBOL(__mb_cache_entry_free);
>
> +/*
> + * mb_cache_entry_wait_unused - wait to be the last user of the entry
> + *
> + * @entry - entry to work on
> + *
> + * Wait to be the last user of the entry.
> + */
> +void mb_cache_entry_wait_unused(struct mb_cache_entry *entry)
> +{
> +	wait_var_event(&entry->e_refcnt, atomic_read(&entry->e_refcnt) <= 3);

It's not very intuitive of why we check for refcnt <= 3.
A small note at top of this function might be helpful.
IIUC, it is because by default when anyone creates an entry we start with
a refcnt of 2 (in mb_cache_entry_create.
- Now when the user of the entry wants to delete this, it will try and call
  mb_cache_entry_delete_or_get(). If during this function call it sees that the
  refcnt is elevated more than 2, that means there is another user of this entry
  currently active and hence we should wait before we remove this entry from the
  cache. So it will take an extra refcnt and return.
- So then this caller will call mb_cache_entry_wait_unused() for the refcnt to
  be <= 3, so that the entry can be deleted.

Quick qn -
So now is the design like, ext4_evict_ea_inode() will be waiting indefinitely
until the other user of this mb_cache entry releases the reference right?
And that will not happen until,
- either the shrinker removes this entry from the cache during which we are
  checking if the refcnt <= 3, then we call a wakeup event
- Or the user removes/deletes the xattr entry
Is the above understanding correct?

-ritesh


> +}
> +EXPORT_SYMBOL(mb_cache_entry_wait_unused);
> +
>  static struct mb_cache_entry *__entry_find(struct mb_cache *cache,
>  					   struct mb_cache_entry *entry,
>  					   u32 key)
> @@ -217,7 +230,7 @@ struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 key,
>  }
>  EXPORT_SYMBOL(mb_cache_entry_get);
>
> -/* mb_cache_entry_delete - remove a cache entry
> +/* mb_cache_entry_delete - try to remove a cache entry
>   * @cache - cache we work with
>   * @key - key
>   * @value - value
> @@ -254,6 +267,55 @@ void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value)
>  }
>  EXPORT_SYMBOL(mb_cache_entry_delete);
>
> +/* mb_cache_entry_delete_or_get - remove a cache entry if it has no users
> + * @cache - cache we work with
> + * @key - key
> + * @value - value
> + *
> + * Remove entry from cache @cache with key @key and value @value. The removal
> + * happens only if the entry is unused. The function returns NULL in case the
> + * entry was successfully removed or there's no entry in cache. Otherwise the
> + * function grabs reference of the entry that we failed to delete because it
> + * still has users and return it.
> + */
> +struct mb_cache_entry *mb_cache_entry_delete_or_get(struct mb_cache *cache,
> +						    u32 key, u64 value)
> +{
> +	struct hlist_bl_node *node;
> +	struct hlist_bl_head *head;
> +	struct mb_cache_entry *entry;
> +
> +	head = mb_cache_entry_head(cache, key);
> +	hlist_bl_lock(head);
> +	hlist_bl_for_each_entry(entry, node, head, e_hash_list) {
> +		if (entry->e_key == key && entry->e_value == value) {
> +			if (atomic_read(&entry->e_refcnt) > 2) {
> +				atomic_inc(&entry->e_refcnt);
> +				hlist_bl_unlock(head);
> +				return entry;
> +			}
> +			/* We keep hash list reference to keep entry alive */
> +			hlist_bl_del_init(&entry->e_hash_list);
> +			hlist_bl_unlock(head);
> +			spin_lock(&cache->c_list_lock);
> +			if (!list_empty(&entry->e_list)) {
> +				list_del_init(&entry->e_list);
> +				if (!WARN_ONCE(cache->c_entry_count == 0,
> +		"mbcache: attempt to decrement c_entry_count past zero"))
> +					cache->c_entry_count--;
> +				atomic_dec(&entry->e_refcnt);
> +			}
> +			spin_unlock(&cache->c_list_lock);
> +			mb_cache_entry_put(cache, entry);
> +			return NULL;
> +		}
> +	}
> +	hlist_bl_unlock(head);
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL(mb_cache_entry_delete_or_get);
> +
>  /* mb_cache_entry_touch - cache entry got used
>   * @cache - cache the entry belongs to
>   * @entry - entry that got used
> diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
> index 20f1e3ff6013..8eca7f25c432 100644
> --- a/include/linux/mbcache.h
> +++ b/include/linux/mbcache.h
> @@ -30,15 +30,23 @@ void mb_cache_destroy(struct mb_cache *cache);
>  int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
>  			  u64 value, bool reusable);
>  void __mb_cache_entry_free(struct mb_cache_entry *entry);
> +void mb_cache_entry_wait_unused(struct mb_cache_entry *entry);
>  static inline int mb_cache_entry_put(struct mb_cache *cache,
>  				     struct mb_cache_entry *entry)
>  {
> -	if (!atomic_dec_and_test(&entry->e_refcnt))
> +	unsigned int cnt = atomic_dec_return(&entry->e_refcnt);
> +
> +	if (cnt > 0) {
> +		if (cnt <= 3)
> +			wake_up_var(&entry->e_refcnt);
>  		return 0;
> +	}
>  	__mb_cache_entry_free(entry);
>  	return 1;
>  }
>
> +struct mb_cache_entry *mb_cache_entry_delete_or_get(struct mb_cache *cache,
> +						    u32 key, u64 value);
>  void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value);
>  struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 key,
>  					  u64 value);
> --
> 2.35.3
>
