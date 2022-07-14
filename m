Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96176574C6A
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 13:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbiGNLrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 07:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiGNLrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 07:47:09 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C175A2FF;
        Thu, 14 Jul 2022 04:47:08 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id cp18-20020a17090afb9200b001ef79e8484aso5919004pjb.1;
        Thu, 14 Jul 2022 04:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e1p4iWqYTDiJJX1SjzG6OUQNeqqxXrIsrs5LVx2398U=;
        b=cvtd9RydR5caM4Yd6au/ciII1Jd7ujf1/PB8NDYbwux8xheoc+quuM65MaZB/TnkcC
         NgYjtqrxoUhur1wdNPMXltKwvr/8myGlskVeteEkFcnCGA/oNlP7aOq8URIBwPO0P/ha
         DPYnYJwn1CRSN5cLJDs0OpSpUqz+hDgEoZQHJ5KD8K4F7YGXdBky+xU5D2SQILflBt0l
         +X8RDwFYEqlGTd1BW5LuKDdNggN1P3KHMSGoYYs7BEnbIDYoUVZaaf1GrUYog1Q5DkJy
         Suk0L9Q251XxuH5MqtcPEp6daYzPdUvC1NxIT/yGZYtrKDBsBErpXB54KsFx0o5tuhCk
         D5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e1p4iWqYTDiJJX1SjzG6OUQNeqqxXrIsrs5LVx2398U=;
        b=TXOj0jAFpxyYpu1oi2kwGSTLX6P9jWO44XXBugVSp3se19tqXBltbJ402tE1ROND2B
         phqTsXkKspBFruWdWpf4w7MPJdzHm1puLwIQDX/OIY5WgBuvFlDBZehSSCl0WoPfjHuk
         DI6X9yMr8IAB6VKd3+6RX+OBVqlv6Mr1V0FmoaJcJec0WgSb8DhHEs8TXbun25P8rWb2
         dPaEgl8AmKSFRrvvVK3f25ECFN+WAL8ARBnUxjNWCz8Cn6DEWEp9qZrfCnhcUbL1JFcz
         M2XZYk8l+bGxf21m4kjvMpQi+EAfRHqbFkipYaRgfjd/1FFln8hLYErDa3LUV41UZU6M
         do+g==
X-Gm-Message-State: AJIora+Cu7Xv02nkbpCkaavucXhSWfWBQbotIAYW1tgpY+rEJZGZtNft
        GiAiuuYuUdu/VlKh7RJiyuxrTjqP7bs=
X-Google-Smtp-Source: AGRyM1uF0tiHR6bXOLwtLHUm6xE5WxAmSz+jJFFIZ0U3PsFWoq/c0Fwr96qQ8ceAcM+kttc82Pv12g==
X-Received: by 2002:a17:902:edc7:b0:16b:e481:3af1 with SMTP id q7-20020a170902edc700b0016be4813af1mr7868804plk.8.1657799228069;
        Thu, 14 Jul 2022 04:47:08 -0700 (PDT)
Received: from localhost ([2406:7400:63:cb1d:811:33e9:9bc2:d40])
        by smtp.gmail.com with ESMTPSA id b6-20020a1709027e0600b0016c3f7b5b48sm1263199plm.256.2022.07.14.04.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 04:47:07 -0700 (PDT)
Date:   Thu, 14 Jul 2022 17:17:02 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 01/10] mbcache: Don't reclaim used entries
Message-ID: <20220714114702.wwd4o3zjdujd34kz@riteshh-domain>
References: <20220712104519.29887-1-jack@suse.cz>
 <20220712105436.32204-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712105436.32204-1-jack@suse.cz>
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
> Do not reclaim entries that are currently used by somebody from a
> shrinker. Firstly, these entries are likely useful. Secondly, we will
> need to keep such entries to protect pending increment of xattr block
> refcount.
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
>  			entry->e_referenced = 0;
>  			list_move_tail(&entry->e_list, &cache->c_list);
>  			continue;
> @@ -302,6 +302,14 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
>  		spin_unlock(&cache->c_list_lock);
>  		head = mb_cache_entry_head(cache, entry->e_key);
>  		hlist_bl_lock(head);
> +		/* Now a reliable check if the entry didn't get used... */
> +		if (atomic_read(&entry->e_refcnt) > 2) {

On taking a look at this patchset again. I think if we move this "if" condition
of checking refcnt to above i.e. before we delete the entry from c_list.
Then we can avoid =>
removing of the entry -> checking it's refcnt under lock -> adding it back
if the refcnt is elevated.

Thoughts?

-ritesh

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
