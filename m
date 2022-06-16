Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0A754E346
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 16:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359791AbiFPOWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 10:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbiFPOWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 10:22:19 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB793B3EF;
        Thu, 16 Jun 2022 07:22:18 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id s37so1632173pfg.11;
        Thu, 16 Jun 2022 07:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J62eWHBm1JNFoiDxH6Ar0/JBxBaKgKeGtVLTQNkH49I=;
        b=NLfnQFzKtXZv8Xorzfs04lnAbj9Va00oDN4lA0sXxpAr4eDOsOV9DkyjjI6LXPDOtY
         XKn2wZo6Hc++qO8K/hHcQnepVHHNUmYVHMNevAlnSY0gwYHNrIx0O4hgZEt9ptlwULTg
         tuT5MQRW8uPE/Z21D4uTRowc+lqd3VZmnM23CRUhANvGK3AuxX7IMd1MIU6c3Q6bMZmj
         qGh6Km0oL1uhvWtxByAMmi0AaXfNJkoC2tUlQBE6Tdb+bMGdclAdEldiHSDgK6MCK8yp
         uXYhEBMKykHZ1QOCx5nX82smkQsaIpLp2QEbKwcW2tm3DEmKYXDMyl+2f+oMDfV39GiG
         b8bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J62eWHBm1JNFoiDxH6Ar0/JBxBaKgKeGtVLTQNkH49I=;
        b=grJ4izg4vM1W6DPbjOIHGeA76BoKUbHEQtAl8PCqc1qKW9Pp3IhF4ukeA+JdrmBgH3
         s5ei81QgezzkaSjNRNgbJkEYkOZwxRZgvs0aY5PeE0KssNy+rAtBv217sBDxSW/WBZQi
         MQ8ja7V+aOZcltMsm/5AK+us2HZXbEvMfnL9UTkOPwMdXPcXTB4Onw90XIagSrxkpWEG
         dsXWBfHCAtC4nFkQbakR7UpY8Vl8I73sELGL0nUhYsWB0EbJLRdFTlynjW5I6Cv/ZJ1b
         WoiCufMy6QsQfwxP8bvNCw7yVTK2cYSmArmai0LrwgXOImhlHlTh+ofYejaIfdGeeGsq
         EGLQ==
X-Gm-Message-State: AJIora+Ovx4Fv5pckN2O3FgH+nmMElc+HPY/AyZ/kEc1F+QpH6UlhRNK
        hP8NCCVOkMUcPD+qjPXazXGe3v2aI7M=
X-Google-Smtp-Source: AGRyM1s9zZfQUdfw5VRC9sAQTNZA4tuEgEerSEtCm9JMusC2xcNxA6lKka5z7ocCldwkdLYos0lMvg==
X-Received: by 2002:aa7:8e0b:0:b0:50d:6d7f:54d with SMTP id c11-20020aa78e0b000000b0050d6d7f054dmr5159906pfr.29.1655389337977;
        Thu, 16 Jun 2022 07:22:17 -0700 (PDT)
Received: from localhost ([2406:7400:63:5d34:e6c2:4c64:12ae:aa11])
        by smtp.gmail.com with ESMTPSA id jd12-20020a170903260c00b001640ab19773sm1728312plb.58.2022.06.16.07.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 07:22:17 -0700 (PDT)
Date:   Thu, 16 Jun 2022 19:52:12 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 01/10] mbcache: Don't reclaim used entries
Message-ID: <20220616142212.do5hdazjkuq5ayar@riteshh-domain>
References: <20220614124146.21594-1-jack@suse.cz>
 <20220614160603.20566-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614160603.20566-1-jack@suse.cz>
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
> Do not reclaim entries that are currently used by somebody from a
> shrinker. Firstly, these entries are likely useful. Secondly, we will
> need to keep such entries to protect pending increment of xattr block
> refcount.

Trying to review the patch series to best of my knowledge, so kindly excuse my
silly queries along the way.

>
> CC: stable@vger.kernel.org
> Fixes: 82939d7999df ("ext4: convert to mbcache2")
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/mbcache.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/mbcache.c b/fs/mbcache.c
> index 97c54d3a2227..cfc28129fb6f 100644
> --- a/fs/mbcache.c
> +++ b/fs/mbcache.c
> @@ -288,7 +288,7 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
>  	while (nr_to_scan-- && !list_empty(&cache->c_list)) {
>  		entry = list_first_entry(&cache->c_list,
>  					 struct mb_cache_entry, e_list);
> -		if (entry->e_referenced) {
> +		if (entry->e_referenced || atomic_read(&entry->e_refcnt) > 2) {

Sure, yes, the above "||" conditions looks good.
i.e. if the refcnt is above 2, then we should move the entry to the tail of LRU.
Because that means that there is another user of this entry which might have
incremented the refcnt.

>  			entry->e_referenced = 0;
>  			list_move_tail(&entry->e_list, &cache->c_list);
>  			continue;
> @@ -302,6 +302,14 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
>  		spin_unlock(&cache->c_list_lock);
>  		head = mb_cache_entry_head(cache, entry->e_key);
>  		hlist_bl_lock(head);
> +		/* Now a reliable check if the entry didn't get used... */

But not sure why this is more reliable? Anytime we add or remove the entry,
we first always do the list operation and then increment or decrement the
refcnt "atomically".

So could you please help in understanding why will this be more reliable?

-ritesh


> +		if (atomic_read(&entry->e_refcnt) > 2) {
> +			hlist_bl_unlock(head);
> +			spin_lock(&cache->c_list_lock);
> +			list_add_tail(&entry->e_list, &cache->c_list);
> +			cache->c_entry_count++;
> +			continue;
> +		}
>  		if (!hlist_bl_unhashed(&entry->e_hash_list)) {
>  			hlist_bl_del_init(&entry->e_hash_list);
>  			atomic_dec(&entry->e_refcnt);
> --
> 2.35.3
>
