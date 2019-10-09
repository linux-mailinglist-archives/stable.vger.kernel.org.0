Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD89D0E5C
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 14:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbfJIMIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 08:08:21 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41078 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729566AbfJIMIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 08:08:21 -0400
Received: by mail-wr1-f68.google.com with SMTP id q9so2628029wrm.8;
        Wed, 09 Oct 2019 05:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JhfXuvTocSOOADPa6XnIM/jkBN52oSbETxTvK9+NuWA=;
        b=gfaNQInkt2HkBhIF/m5lj5kBr2Fhi9UOXgBNg6wRypoY7AR47klPq+JEfsZknfycLU
         hCPc+7wliM3ZQ5YhcGjeFEGFvV6W4R+TLriHT3MetoCcIfMCtpXHIgF5Xoxsk1/qvXUy
         4MTbA3aqYRP31WKuXgEdWyHVJXafN4T2UD5M2M/O+QenWBjMAwWx8bZbEWcWCMmNBYni
         zDwoX3Jo23cUH/6OPR+IpKid+RJAc4Qw5doasVb0U48YNavQhy1/Bi0OagRLl+8v8SmH
         G1BbtIT0Mjl5KhMFV4JC56Ib2LYwMI+MSZk3nP37jw5mgewh8+CgCkvQWl5iFosmtc1W
         HUIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JhfXuvTocSOOADPa6XnIM/jkBN52oSbETxTvK9+NuWA=;
        b=adg+k+up30Y2WJqZsoiRePqOpfcIkzmtCwTavmMoDDe1Vl4HVH8a04pSXtt0Mm3m+3
         emKQt0y6KzAYE+79rTDZewKLaS6rMTrQfqn47PtMWSHthBP/H30ItMnNmbEvZqnblVNH
         0nK5zD8fQc7G+oPIVG0GjB2eeTDytOVQCrrCxC069nU7Vc9gOj5Ef4sIYfyUlvwka8s+
         4I4TIQQ9Xyjd9Eb5KHCE4MXtSYwb39zqdhZhGQp5AT1XsAsYBr7IfSbB/2PYYkkOCk5P
         HU64+nciWLpXphf066wnAte5lO/5UozrB4Y9gJLc55kUG2vl8eWJcHe+/X1GqVD2/d0w
         xwtA==
X-Gm-Message-State: APjAAAULWlZgZJyTSXbjqltm5usAyB2JXZ924VBzdMKg5QEgSi0PtEAW
        3AErLeIYfvKqZWmBm+pBTyw=
X-Google-Smtp-Source: APXvYqz7paT7mj8d8xLlvmA20Bu2nJielivY3fjEo4X5R5EYyDhFUKZY7NB2DLK4BLCF6tim/yrhog==
X-Received: by 2002:adf:ed03:: with SMTP id a3mr2579425wro.282.1570622897158;
        Wed, 09 Oct 2019 05:08:17 -0700 (PDT)
Received: from andrea.guest.corp.microsoft.com ([2a01:110:8012:1010:e0e:643a:f61b:5721])
        by smtp.gmail.com with ESMTPSA id z5sm3353181wrs.54.2019.10.09.05.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 05:08:16 -0700 (PDT)
Date:   Wed, 9 Oct 2019 14:08:10 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     bsingharora@gmail.com, dvyukov@google.com, elver@google.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH v5] taskstats: fix data-race
Message-ID: <20191009120800.GB4941@andrea.guest.corp.microsoft.com>
References: <20191009113134.5171-1-christian.brauner@ubuntu.com>
 <20191009114809.8643-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009114809.8643-1-christian.brauner@ubuntu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 01:48:09PM +0200, Christian Brauner wrote:
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
> The tasks reads sig->stats without holding sighand lock seeing garbage.
> 
> cpu1:
> task calls exit_group()
>  do_exit()
>  do_group_exit()
>  taskstats_exit()
>  taskstats_tgid_alloc()
> The task takes sighand lock and assigns new stats to sig->stats.
> 
> Fix this by using smp_load_acquire() and smp_store_release().
> 
> Reported-by: syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com
> Fixes: 34ec12349c8a ("taskstats: cleanup ->signal->stats allocation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> Reviewed-by: Dmitry Vyukov <dvyukov@google.com>

Reviewed-by: Andrea Parri <parri.andrea@gmail.com>

Thanks,
  Andrea


> ---
> /* v1 */
> Link: https://lore.kernel.org/r/20191005112806.13960-1-christian.brauner@ubuntu.com
> 
> /* v2 */
> Link: https://lore.kernel.org/r/20191006235216.7483-1-christian.brauner@ubuntu.com
> - Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>:
>   - fix the original double-checked locking using memory barriers
> 
> /* v3 */
> Link: https://lore.kernel.org/r/20191007110117.1096-1-christian.brauner@ubuntu.com
> - Andrea Parri <parri.andrea@gmail.com>:
>   - document memory barriers to make checkpatch happy
> 
> /* v4 */
> Link: https://lore.kernel.org/r/20191009113134.5171-1-christian.brauner@ubuntu.com
> - Andrea Parri <parri.andrea@gmail.com>:
>   - use smp_load_acquire(), not READ_ONCE()
>   - update commit message
> 
> /* v5 */
> - Andrea Parri <parri.andrea@gmail.com>:
>   - fix typo in smp_load_acquire()
> ---
>  kernel/taskstats.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> index 13a0f2e6ebc2..6e18fdc4f7c8 100644
> --- a/kernel/taskstats.c
> +++ b/kernel/taskstats.c
> @@ -554,24 +554,30 @@ static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
>  static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
>  {
>  	struct signal_struct *sig = tsk->signal;
> -	struct taskstats *stats;
> +	struct taskstats *stats_new, *stats;
>  
> -	if (sig->stats || thread_group_empty(tsk))
> -		goto ret;
> +	/* Pairs with smp_store_release() below. */
> +	stats = smp_load_acquire(&sig->stats);
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
> +		/*
> +		 * Pairs with smp_store_release() above and order the
> +		 * kmem_cache_zalloc().
> +		 */
> +		smp_store_release(&sig->stats, stats_new);
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
