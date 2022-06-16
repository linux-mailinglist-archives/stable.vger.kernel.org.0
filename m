Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6560754E548
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 16:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbiFPOrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 10:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbiFPOra (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 10:47:30 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33787318;
        Thu, 16 Jun 2022 07:47:29 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id f8so1451053plo.9;
        Thu, 16 Jun 2022 07:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q3NqvmkLoRVUIuRTtGTkdGRsrahqwSig2ClJkmUrkOQ=;
        b=IqrOjnIHu37DZgY+WD3bEMrFGpXQL7ISF6gUozrbpcowJ+m6zDsaf57K1Cm7T4sfGS
         5Ud+nEFKQMdldOJMBuZb9swjcyvEHNbz9Fsc5DrLoDqENTOSwCvW6kMrXaoi0dDApJLu
         WCGHqT/LPhpJHwjew0ALspcQrJHB7MUyoPSwWNGNkXUtARIbX77HzDp590Js6+Qavbex
         xsuhx6Xl7zOJFaZ9gnfMfnjKYEou+uPUhgTqrDztDmPuj57OSbAdqNeGGcd3ZCTUEdeu
         zUPMhn++LXM3OZ92Ti/2G03kHoD/QMdJJohHWx0uZ0fB41uUzH5d5SnFMmzuN86ec6e/
         rnTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q3NqvmkLoRVUIuRTtGTkdGRsrahqwSig2ClJkmUrkOQ=;
        b=ctYe/Kc1KShAQaRr9r+WjDG6e1W775fGt0kr6zyOelIwQLbsRBMItDJWcu8H79o3kV
         TJvXnL1pCyfsQagtKeWt2M/Cnmz7ZWrG4Fj5srBkJNRCU1AialJM0nnV2Ld0GhHIZIC1
         R+2yR1OBwC3l10SqmY9GPYlzoUy72rNMxaUOHOn374eF1pfBet5Ry4M5UUZydVujlmUf
         oTrIbLRRT1sBUNVRVTCqIsCfl2zNxncfFA71wddBX8G4F9hlmS2At7Qg6/gpMVyRJ9GY
         EjFJdsqq2fDhIYhE9tUdm0PBSUe1DigFRkw297ott7SJZlVtBNpwUvYI5GzQT/HaEdtk
         1q9Q==
X-Gm-Message-State: AJIora8NWAUH0YR7jkxhQ7wd5rjcq5FJw+qR3NET/+E5pS3DQy4FdCPj
        9UM39GnRe8ksY2MJr7cgiJDgNntvrDI=
X-Google-Smtp-Source: AGRyM1sb8Rkx0N43/VJkRGWdQnzx+TZ7kC2qzA+qWE2u4QOX4bJiND/CJmmBx7OF57cKXFvmfiBN7Q==
X-Received: by 2002:a17:903:1013:b0:163:e8b9:2429 with SMTP id a19-20020a170903101300b00163e8b92429mr5014841plb.74.1655390847866;
        Thu, 16 Jun 2022 07:47:27 -0700 (PDT)
Received: from localhost ([2406:7400:63:5d34:e6c2:4c64:12ae:aa11])
        by smtp.gmail.com with ESMTPSA id h3-20020a170902680300b001637529493esm1759515plk.66.2022.06.16.07.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 07:47:27 -0700 (PDT)
Date:   Thu, 16 Jun 2022 20:17:22 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 02/10] mbcache: Add functions to delete entry if unused
Message-ID: <20220616144722.of7v2rgd76y3gsv5@riteshh-domain>
References: <20220614124146.21594-1-jack@suse.cz>
 <20220614160603.20566-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614160603.20566-2-jack@suse.cz>
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
> Add function mb_cache_entry_try_delete() to delete mbcache entry if it
> is unused and also add a function to wait for entry to become unused -
> mb_cache_entry_wait_unused(). We do not share code between the two
> deleting function as one of them will go away soon.
>
> CC: stable@vger.kernel.org
> Fixes: 82939d7999df ("ext4: convert to mbcache2")
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/mbcache.c            | 63 ++++++++++++++++++++++++++++++++++++++++-
>  include/linux/mbcache.h | 10 ++++++-
>  2 files changed, 71 insertions(+), 2 deletions(-)
>
> diff --git a/fs/mbcache.c b/fs/mbcache.c
> index cfc28129fb6f..1ae66b2c75f4 100644
> --- a/fs/mbcache.c
> +++ b/fs/mbcache.c
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
> @@ -254,6 +267,54 @@ void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value)
>  }
>  EXPORT_SYMBOL(mb_cache_entry_delete);
>
> +/* mb_cache_entry_try_delete - try to remove a cache entry
> + * @cache - cache we work with
> + * @key - key
> + * @value - value
> + *
> + * Remove entry from cache @cache with key @key and value @value. The removal
> + * happens only if the entry is unused. The function returns NULL in case the
> + * entry was successfully removed or there's no entry in cache. Otherwise the
> + * function returns the entry that we failed to delete because it has users.

"...Also increment it's refcnt in case if the entry is returned. So the caller
is responsible to call for mb_cache_entry_put() later."

Do you think comment should be added too? And the api naming should be
mb_cache_entry_try_delete_or_get().

Looks like e_refcnt increment is done quitely in case of the entry is found
where as the api just says mb_cache_entry_try_delete().

Other than that, all other code logic looks right to me.

-ritesh

> + */
> +struct mb_cache_entry *mb_cache_entry_try_delete(struct mb_cache *cache,
> +						 u32 key, u64 value)
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
> +EXPORT_SYMBOL(mb_cache_entry_try_delete);
> +
>  /* mb_cache_entry_touch - cache entry got used
>   * @cache - cache the entry belongs to
>   * @entry - entry that got used
> diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
> index 20f1e3ff6013..1176fdfb8d53 100644
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
> +struct mb_cache_entry *mb_cache_entry_try_delete(struct mb_cache *cache,
> +						 u32 key, u64 value);
>  void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value);
>  struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 key,
>  					  u64 value);
> --
> 2.35.3
>
