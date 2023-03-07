Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C043B6AE005
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 14:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjCGNHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 08:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjCGNHV (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 7 Mar 2023 08:07:21 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7807B4AB
        for <Stable@vger.kernel.org>; Tue,  7 Mar 2023 05:05:53 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q31-20020a17090a17a200b0023750b69614so11779100pja.5
        for <Stable@vger.kernel.org>; Tue, 07 Mar 2023 05:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1678194352;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t+FdsTGZzqFZqYBTn3Ql+ChMDk8iUlybGRvDY8ZJ9VU=;
        b=RBo4mnr9UV/76xDxoNtIFvN1XW6fFx1PY1NBiBdZog7bPokCU7XM5kQUk6LQDiqV8U
         YrWsVdVwtGNZwuuLoYW6ov2pXHIYRzRFDStHthlQfInnIps8GwfB74TucjDdimqbaXWW
         jICL4WCdizqK/+1J5HKRHPrCGRMxzoIkWYkkUUTQ+oxVF0Ur3093L3wwZ0Q722cllW1B
         u0rzZ07flKCpWM59XBHvlep+JW4VRVWPp2BtO6W1ZUbEFwqU/rzxSNhpfst5RKm62J/6
         funSPnYuZXt/hBhouBzzFqflnpGbyAr/NuB79F3VqIawrzBMUqgALdIigjDFBKSL+HRe
         1SAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678194352;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t+FdsTGZzqFZqYBTn3Ql+ChMDk8iUlybGRvDY8ZJ9VU=;
        b=qVZG+28C9wADvtlOBVwPrFt0lktQbEduWLtwthAjOJyNIjTkDWSPysIYjs95FlndIo
         lCX2xdKWZdOQ4yQdT8GPNU8qAQ91IBAnqCjaohr5Qx8TmNkOMNgqWFxvZWeBs04EqENh
         xN0yLwAs4Zf1UGjjQfj7VdEaZ7CFwKwlv5T4kis2P497crmQh/HLoi+HW3TexiodfIqm
         DxeGinMpDBngUzSaY+2zgwfaIB3vnphQ3eD1k3kwhHEv1QSnL/Ljtn3Nvla8lAsC78Vr
         EGuT2DsGCmAFOBnwihd2D4qmp3kxv5yl/A85YnD5Ufv1orRvqqsKUTWiPgYDNZP84KB0
         aQcQ==
X-Gm-Message-State: AO0yUKX0+07N4owCytypfrQYBPYnWJSaucudEeguBRaGNGu87LuQpcuS
        XPBjHFnJB8BJpE3S2EF6Puu5Ug==
X-Google-Smtp-Source: AK7set9tOFhM95hUX3pEY5rK2bAommdGqvpRofEUa/4iWeTx414xIKOjt0Uc2cc+J9isMI7He9+sOg==
X-Received: by 2002:a17:902:d2c9:b0:19a:c4a0:5b1b with SMTP id n9-20020a170902d2c900b0019ac4a05b1bmr19927045plc.1.1678194351908;
        Tue, 07 Mar 2023 05:05:51 -0800 (PST)
Received: from [10.200.8.102] ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b00198fb25d09bsm8322729plp.237.2023.03.07.05.05.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 05:05:51 -0800 (PST)
Message-ID: <cec2dec7-818a-b32c-3ad4-8b23fc1351f3@bytedance.com>
Date:   Tue, 7 Mar 2023 21:05:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH 1/2] maple_tree: Fix mas_skip_node() end slot detection
To:     "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc:     Stable@vger.kernel.org, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Snild Dolkow <snild@sony.com>
References: <20230303021540.1056603-1-Liam.Howlett@oracle.com>
From:   Peng Zhang <zhangpeng.00@bytedance.com>
In-Reply-To: <20230303021540.1056603-1-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Liam,
> mas_skip_node() is used to move the maple state to the node with a
> higher limit.  It does this by walking up the tree and increasing the
> slot count.  Since slot count may not be able to be increased, it may
> need to walk up multiple times to find room to walk right to a higher
> limit node.  The limit of slots that was being used was the node limit
> and not the last location of data in the node.  This would cause the
> maple state to be shifted outside actual data and enter an error state,
> thus returning -EBUSY.
> 
> The result of the incorrect error state means that mas_awalk() would
> return an error instead of finding the allocation space.
> 
> The fix is to use mas_data_end() in mas_skip_node() to detect the nodes
> data end point and continue walking the tree up until it is safe to move
> to a node with a higher limit.
> 
> mas_skip_node() may also be passed a maple state in an error state from
> mas_anode_descend() when no allocations are available.  Return on such
> an error state immediately.
> 
> Reported-by: Snild Dolkow <snild@sony.com>
> Link: https://lore.kernel.org/linux-mm/cb8dc31a-fef2-1d09-f133-e9f7b9f9e77a@sony.com/
> Cc: <Stable@vger.kernel.org>
> Fixes: 54a611b60590 ("Maple Tree: add new data structure")
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Peng Zhang <zhangpeng.00@bytedance.com>
> ---
>   lib/maple_tree.c | 25 ++++++++++---------------
>   1 file changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 2be86368237d..2efe854946d6 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -5188,34 +5188,29 @@ static inline bool mas_rewind_node(struct ma_state *mas)
>    */
>   static inline bool mas_skip_node(struct ma_state *mas)
>   {
> -	unsigned char slot, slot_count;
>   	unsigned long *pivots;
>   	enum maple_type mt;
>   
> -	mt = mte_node_type(mas->node);
> -	slot_count = mt_slots[mt] - 1;
> +	if (mas_is_err(mas))
> +		return false;
> +
>   	do {
>   		if (mte_is_root(mas->node)) {
> -			slot = mas->offset;
> -			if (slot > slot_count) {
> +			if (mas->offset >= mas_data_end(mas)) {
>   				mas_set_err(mas, -EBUSY);
>   				return false;
>   			}
>   		} else {
>   			mas_ascend(mas);
> -			slot = mas->offset;
> -			mt = mte_node_type(mas->node);
> -			slot_count = mt_slots[mt] - 1;
>   		}
> -	} while (slot > slot_count);
> +	} while (mas->offset >= mas_data_end(mas));
>   
> -	mas->offset = ++slot;
> +	mt = mte_node_type(mas->node);
>   	pivots = ma_pivots(mas_mn(mas), mt);
> -	if (slot > 0)
> -		mas->min = pivots[slot - 1] + 1;
> -
> -	if (slot <= slot_count)
> -		mas->max = pivots[slot];
> +	mas->min = pivots[mas->offset] + 1;
> +	mas->offset++;
> +	if (mas->offset < mt_slots[mt])
> +		mas->max = pivots[mas->offset];
There is a bug here, the assignment of mas->min and mas->max is wrong.
The assignment will make them represent the range of a child node, but 
it should represent the range of the current node. After mas_ascend() 
returns, mas-min and mas->max already represent the range of the current 
node, so we should delete these assignments of mas->min and mas->max.
>   
>   	return true;
>   }

Sincerely yours,
Peng.
