Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 762CBCE313
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 15:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfJGNSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 09:18:12 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37964 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfJGNSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 09:18:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id 3so12308043wmi.3;
        Mon, 07 Oct 2019 06:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Lvbiovo34sbcPGsBmiq1Qy97fup2BnoiwtVZlbVjSGQ=;
        b=W5R84jvAFVa4k/eE7K/BQiTfZVF3QzirWTst5VDVb0+ef7p1k2xDL6pVJUeJvuVj+F
         qWJK25c0rBszEiDrqHbaTfFYq7m0WXmEhKd+UrTx6DD04IbAyE9xqB5cPBKZiDhm436o
         qDBUoqeVPCdWdQ8IjAzYf2/hA4nLj/I25DNLh6+0FLBIkT4q/Hgb+BkeBMZQO4LM8LYG
         +kDNvaXUr3pDOxI4WLfTwQAjQKve+Y43J33Twi91qu8+92uxfXaRYJunQm8lq5iJjyxC
         JzstWwLiFZXX4XTS2gddT9qu6FW5sPEOfA9Upk6+e2mB1HUfI0nbzKD3+aHICD6l/wkC
         Q1oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Lvbiovo34sbcPGsBmiq1Qy97fup2BnoiwtVZlbVjSGQ=;
        b=RSD92n7Qofy9akdvzrnF1+RuSzCHQcOYycuBauoYodLU9ZYawJ8HNxhX4BhhCcWlNC
         EmioGoA9oprhnZ//Dmi+plfdWuop2CSA5uHAmqcYU5izW+tD+j0F5KQtI5rUtLyImk7w
         am40cWQ9pXcU9FjdyWldsEJ206dq7YECJgiZs1tcpHo28gdvZbbHfTuvrQC0mBP03q2y
         PCnl7LZxfnQ8dwp+Nfb6lJxgEPtCzlkiLciR6jyVwcPFwKvBMfzSuAqVFrc2C10DJFmc
         1i9BN712fBSksHzirikVHVabvqpi+UOh0MaRbh86AHm95pqNSj90u3qe+AM3Vvk8oUfd
         4pwQ==
X-Gm-Message-State: APjAAAWhgIIG/d3Q6H3BfcGJGyI1sb7xmdh0z9yf7ujujIllzwSAaar3
        wp5tCnflUk10PLZEEbSp+PU=
X-Google-Smtp-Source: APXvYqy5FKq/arq9suAylL8FCDD31yWal4T1+5SMCI8jKldI7qcarOQyqJJrccvJnsIPc0PrlGqw6g==
X-Received: by 2002:a1c:4108:: with SMTP id o8mr21745194wma.129.1570454290392;
        Mon, 07 Oct 2019 06:18:10 -0700 (PDT)
Received: from andrea.guest.corp.microsoft.com ([2a01:110:8012:1012:69a4:816:a2c:e717])
        by smtp.gmail.com with ESMTPSA id o9sm35726857wrh.46.2019.10.07.06.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 06:18:09 -0700 (PDT)
Date:   Mon, 7 Oct 2019 15:18:04 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     bsingharora@gmail.com, dvyukov@google.com, elver@google.com,
        linux-kernel@vger.kernel.org,
        syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] taskstats: fix data-race
Message-ID: <20191007131804.GA19242@andrea.guest.corp.microsoft.com>
References: <20191007104039.GA16085@andrea.guest.corp.microsoft.com>
 <20191007110117.1096-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007110117.1096-1-christian.brauner@ubuntu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 07, 2019 at 01:01:17PM +0200, Christian Brauner wrote:
> When assiging and testing taskstats in taskstats_exit() there's a race
> when writing and reading sig->stats when a thread-group with more than
> one thread exits:
> 
> cpu0:
> thread catches fatal signal and whole thread-group gets taken down
>  do_exit()
>  do_group_exit()
>  taskstats_exit()
>  taskstats_tgid_alloc()
> The tasks reads sig->stats holding sighand lock seeing garbage.

You meant "without holding sighand lock" here, right?


> 
> cpu1:
> task calls exit_group()
>  do_exit()
>  do_group_exit()
>  taskstats_exit()
>  taskstats_tgid_alloc()
> The task takes sighand lock and assigns new stats to sig->stats.
> 
> Fix this by using READ_ONCE() and smp_store_release().
> 
> Reported-by: syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com
> Fixes: 34ec12349c8a ("taskstats: cleanup ->signal->stats allocation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
> Link: https://lore.kernel.org/r/20191006235216.7483-1-christian.brauner@ubuntu.com
> ---
> /* v1 */
> Link: https://lore.kernel.org/r/20191005112806.13960-1-christian.brauner@ubuntu.com
> 
> /* v2 */
> - Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>:
>   - fix the original double-checked locking using memory barriers
> 
> /* v3 */
> - Andrea Parri <parri.andrea@gmail.com>:
>   - document memory barriers to make checkpatch happy
> ---
>  kernel/taskstats.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> index 13a0f2e6ebc2..978d7931fb65 100644
> --- a/kernel/taskstats.c
> +++ b/kernel/taskstats.c
> @@ -554,24 +554,27 @@ static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
>  static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
>  {
>  	struct signal_struct *sig = tsk->signal;
> -	struct taskstats *stats;
> +	struct taskstats *stats_new, *stats;
>  
> -	if (sig->stats || thread_group_empty(tsk))
> -		goto ret;
> +	/* Pairs with smp_store_release() below. */
> +	stats = READ_ONCE(sig->stats);

This pairing suggests that the READ_ONCE() is heading an address
dependency, but I fail to identify it: what is the target memory
access of such a (putative) dependency?


> +	if (stats || thread_group_empty(tsk))
> +		return stats;
>  
>  	/* No problem if kmem_cache_zalloc() fails */
> -	stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
> +	stats_new = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
>  
>  	spin_lock_irq(&tsk->sighand->siglock);
>  	if (!sig->stats) {
> -		sig->stats = stats;
> -		stats = NULL;
> +		/* Pairs with READ_ONCE() above. */
> +		smp_store_release(&sig->stats, stats_new);

This is intended to 'order' the _zalloc()  (zero initializazion)
before the update of sig->stats, right?  what else am I missing?

Thanks,
  Andrea


> +		stats_new = NULL;
>  	}
>  	spin_unlock_irq(&tsk->sighand->siglock);
>  
> -	if (stats)
> -		kmem_cache_free(taskstats_cache, stats);
> -ret:
> +	if (stats_new)
> +		kmem_cache_free(taskstats_cache, stats_new);
> +
>  	return sig->stats;
>  }
>  
> -- 
> 2.23.0
> 
