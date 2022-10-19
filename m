Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62713604AFB
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 17:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbiJSPQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 11:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbiJSPQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 11:16:03 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5122A196082
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 08:09:07 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id u15so19563360oie.2
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 08:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ay+FMyDJ6mrCFfmDeqeDYg/OUapBZxlc0xVY9+qqxc=;
        b=UdOSJ/n8yfsYhzLSqIYsFOfh8GSjAaZhtcRzKDgVJWldd9wCjYvvKegxlJvJ7svK6G
         8Bd1VBPOy2xVIU7wItLjuIa0v9RCtzTb5UaU87AU5iarWSX/jeo0Q8Sju90E0S78bP36
         ytZboSINkcXkwmy8ZyQZLtaRAT6fkcXJmUg/QCSvrVGRuxF9Xlad0Pm6A5QJUwhe3RlN
         iXGFVpjKYYMeYW8C9dbzHxHn5xOz8Kldrn0rMjoWdD2G6VtZX8PoeFWNB9Yl8ocvMV2C
         n33/kIn5Ky1BTh442zAxwihjvojosOHQJzY6Kw+aJF6CGhpeKglEQnZA27Pt00Qd/BGt
         M8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ay+FMyDJ6mrCFfmDeqeDYg/OUapBZxlc0xVY9+qqxc=;
        b=Vb1SYELjr3wkzB3PmLbSs8QqNsfxW03AoTPlXj/q2N//eJR0BeO6DrGchvp3mOHGgj
         GFWj2vG1GZ229d6uRQ3h1ZVQIvmADIFoV9wxx25GOCkfD+vrN3e39IlQav1cJiY3h65f
         FP8Uge9ajISmVxrJDfqQQQU/WNKgViYpAwXsNW0uHxfbsxNZ61BPbH7wSvGxfbrpPzAJ
         xIwcCM0+/HNrGLJNIiLRrKSNwNEaZRP0cZ3yHcDjaO5H9YaFzAv+sGiKklE3zCQSFYer
         KD480QtkzPQKQm7XyptpdZM5PerzYYMQwNnaKwq99vtjTfBLyczOROhMK6DCCwjr42Sq
         pAhQ==
X-Gm-Message-State: ACrzQf3NkwUF/OMKYGy73vh23s8rlVdY0a0srQSioFpcnJ7oNGuF0Uc0
        Vm+h8BKeWWxtzLxxAZKq1SjQww==
X-Google-Smtp-Source: AMsMyM5vr3f8E3wG/TwBM0lhVIbvGK4VxAN1rNww5cccyMGDxuaUmlUxhVRCfTsIY2pkxFHLZLODBw==
X-Received: by 2002:aca:120e:0:b0:354:ae0d:e063 with SMTP id 14-20020aca120e000000b00354ae0de063mr4421804ois.250.1666191998315;
        Wed, 19 Oct 2022 08:06:38 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id k4-20020a9d7604000000b0066194b13fe9sm7041703otl.73.2022.10.19.08.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 08:06:37 -0700 (PDT)
Date:   Wed, 19 Oct 2022 08:06:26 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yu Kuai <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 6.0 479/862] sbitmap: fix possible io hung due to lost
 wakeup
In-Reply-To: <20221019083311.114449669@linuxfoundation.org>
Message-ID: <174a196-5473-4e93-a52a-5e26eb37949@google.com>
References: <20221019083249.951566199@linuxfoundation.org> <20221019083311.114449669@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Oct 2022, Greg Kroah-Hartman wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> [ Upstream commit 040b83fcecfb86f3225d3a5de7fd9b3fbccf83b4 ]
> 
> There are two problems can lead to lost wakeup:
> 
> 1) invalid wakeup on the wrong waitqueue:
> 
> For example, 2 * wake_batch tags are put, while only wake_batch threads
> are woken:
> 
> __sbq_wake_up
>  atomic_cmpxchg -> reset wait_cnt
> 			__sbq_wake_up -> decrease wait_cnt
> 			...
> 			__sbq_wake_up -> wait_cnt is decreased to 0 again
> 			 atomic_cmpxchg
> 			 sbq_index_atomic_inc -> increase wake_index
> 			 wake_up_nr -> wake up and waitqueue might be empty
>  sbq_index_atomic_inc -> increase again, one waitqueue is skipped
>  wake_up_nr -> invalid wake up because old wakequeue might be empty
> 
> To fix the problem, increasing 'wake_index' before resetting 'wait_cnt'.
> 
> 2) 'wait_cnt' can be decreased while waitqueue is empty
> 
> As pointed out by Jan Kara, following race is possible:
> 
> CPU1				CPU2
> __sbq_wake_up			 __sbq_wake_up
>  sbq_wake_ptr()			 sbq_wake_ptr() -> the same
>  wait_cnt = atomic_dec_return()
>  /* decreased to 0 */
>  sbq_index_atomic_inc()
>  /* move to next waitqueue */
>  atomic_set()
>  /* reset wait_cnt */
>  wake_up_nr()
>  /* wake up on the old waitqueue */
> 				 wait_cnt = atomic_dec_return()
> 				 /*
> 				  * decrease wait_cnt in the old
> 				  * waitqueue, while it can be
> 				  * empty.
> 				  */
> 
> Fix the problem by waking up before updating 'wake_index' and
> 'wait_cnt'.
> 
> With this patch, noted that 'wait_cnt' is still decreased in the old
> empty waitqueue, however, the wakeup is redirected to a active waitqueue,
> and the extra decrement on the old empty waitqueue is not handled.
> 
> Fixes: 88459642cba4 ("blk-mq: abstract tag allocation out into sbitmap library")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Link: https://lore.kernel.org/r/20220803121504.212071-1-yukuai1@huaweicloud.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I have no authority on linux-block, but I'll say NAK to this one
(and 517/862), and let Jens and Jan overrule me if they disagree.

This was the first of several 6.1-rc1 commits which had given me lost
wakeups never suffered before; was not tagged Cc stable; and (unless I've
missed it on lore) never had AUTOSEL posted to linux-block or linux-kernel.

Hugh

> ---
>  lib/sbitmap.c | 55 ++++++++++++++++++++++++++++++---------------------
>  1 file changed, 33 insertions(+), 22 deletions(-)
> 
> diff --git a/lib/sbitmap.c b/lib/sbitmap.c
> index 29eb0484215a..1f31147872e6 100644
> --- a/lib/sbitmap.c
> +++ b/lib/sbitmap.c
> @@ -611,32 +611,43 @@ static bool __sbq_wake_up(struct sbitmap_queue *sbq)
>  		return false;
>  
>  	wait_cnt = atomic_dec_return(&ws->wait_cnt);
> -	if (wait_cnt <= 0) {
> -		int ret;
> +	/*
> +	 * For concurrent callers of this, callers should call this function
> +	 * again to wakeup a new batch on a different 'ws'.
> +	 */
> +	if (wait_cnt < 0 || !waitqueue_active(&ws->wait))
> +		return true;
>  
> -		wake_batch = READ_ONCE(sbq->wake_batch);
> +	if (wait_cnt > 0)
> +		return false;
>  
> -		/*
> -		 * Pairs with the memory barrier in sbitmap_queue_resize() to
> -		 * ensure that we see the batch size update before the wait
> -		 * count is reset.
> -		 */
> -		smp_mb__before_atomic();
> +	wake_batch = READ_ONCE(sbq->wake_batch);
>  
> -		/*
> -		 * For concurrent callers of this, the one that failed the
> -		 * atomic_cmpxhcg() race should call this function again
> -		 * to wakeup a new batch on a different 'ws'.
> -		 */
> -		ret = atomic_cmpxchg(&ws->wait_cnt, wait_cnt, wake_batch);
> -		if (ret == wait_cnt) {
> -			sbq_index_atomic_inc(&sbq->wake_index);
> -			wake_up_nr(&ws->wait, wake_batch);
> -			return false;
> -		}
> +	/*
> +	 * Wake up first in case that concurrent callers decrease wait_cnt
> +	 * while waitqueue is empty.
> +	 */
> +	wake_up_nr(&ws->wait, wake_batch);
>  
> -		return true;
> -	}
> +	/*
> +	 * Pairs with the memory barrier in sbitmap_queue_resize() to
> +	 * ensure that we see the batch size update before the wait
> +	 * count is reset.
> +	 *
> +	 * Also pairs with the implicit barrier between decrementing wait_cnt
> +	 * and checking for waitqueue_active() to make sure waitqueue_active()
> +	 * sees result of the wakeup if atomic_dec_return() has seen the result
> +	 * of atomic_set().
> +	 */
> +	smp_mb__before_atomic();
> +
> +	/*
> +	 * Increase wake_index before updating wait_cnt, otherwise concurrent
> +	 * callers can see valid wait_cnt in old waitqueue, which can cause
> +	 * invalid wakeup on the old waitqueue.
> +	 */
> +	sbq_index_atomic_inc(&sbq->wake_index);
> +	atomic_set(&ws->wait_cnt, wake_batch);
>  
>  	return false;
>  }
> -- 
> 2.35.1
> 
> 
> 
> 
