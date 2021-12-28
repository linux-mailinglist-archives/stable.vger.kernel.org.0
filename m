Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7957E480D02
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 21:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236218AbhL1U0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 15:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236101AbhL1U0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 15:26:22 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8920FC061574;
        Tue, 28 Dec 2021 12:26:21 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id o12so43678012lfk.1;
        Tue, 28 Dec 2021 12:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x9H1jwZuw47RIqVS8FsoYJoRzz2cUXj5zvjpJ6npwgc=;
        b=B+d9lyKIiZ7AIGDnhbu3YYirNZTBqKOuNocTRQpIRr9GQXgBEaCAqhYnrQQ9Nhfjhh
         FM4K0O+L5cYhUJxZEcjDAvJqqyhRbSUDKygvgdH3BTKNK0A7K1tABK5WNvDa85jjNNjo
         cDZupRlNJsQPBeQG37nmEQbyE3SdiMorm95gPenZIlmWNP4YM7HIzH35MpB4J5k+qZxT
         HmOD4XiCMPyKtJk5N9iu9tuIqomOldoaQYPfAjc1yK9YYtjfigvicozY7PonDhjk0lJL
         YJXtnR12Ok4xfwpaRxgtViHbuCy+9OUibj9vcTkZF32I9nZZHxAgRqquggLsQUd4mMb1
         AFkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x9H1jwZuw47RIqVS8FsoYJoRzz2cUXj5zvjpJ6npwgc=;
        b=Bdd2ohcSTJmZ9s8HEutNssGfHh2tN616GfY4QUDTCKPlrWz8waG6i8gYtz7e+AgP5O
         Q+eWVVsUJOFVnsiXdgYvsxEXFNzgJDzqL0H/Wm74pNUjgesArzUzdBYFPp42N5mJeXGR
         dOEDTD0q1vcYbdJs2hN0VhP3VqwmaKXZSnLvqzuQCS5bUtvdL+z30wzgNOgLB+zJBStJ
         i+bwvq0tD+X8Zhpms/7rOO6nc6mAbZ2WRPlckgVKatbp+1eHb4RMoKJp8gwQdbfxfqTO
         rOBSZVk4H8obvtuDGZuf2GjIk3RkeLaf6pvLZuUaU4NjYQ9dhs6BA6o/g4uxkNcHan0i
         ThOg==
X-Gm-Message-State: AOAM532XG0pLfgvzIU+UhTsyb0dDuZvVbnltw2FVjO0Z8jt8ZUebyFyL
        kyvu7YuzzrvBflU2STh3RVQ=
X-Google-Smtp-Source: ABdhPJyo56MvrHZq/Ljfy8VHLlMtXo4FFR1WW8OtjsDsiosKJ4zawuypX3wIdN7EpaAZHFZ9F3tL3w==
X-Received: by 2002:ac2:455c:: with SMTP id j28mr19927816lfm.667.1640723179633;
        Tue, 28 Dec 2021 12:26:19 -0800 (PST)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id s21sm1788114ljg.131.2021.12.28.12.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 12:26:18 -0800 (PST)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Tue, 28 Dec 2021 21:26:16 +0100
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     Uladzislau Rezki <urezki@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasily Averin <vvs@virtuozzo.com>, cgel.zte@gmail.com,
        shakeelb@google.com, rdunlap@infradead.org, dbueso@suse.de,
        unixbhaskar@gmail.com, chi.minghao@zte.com.cn, arnd@arndb.de,
        Zeal Robot <zealci@zte.com.cn>, linux-mm@kvack.org,
        1vier1@web.de, stable@vger.kernel.org
Subject: Re: [PATCH] mm/util.c: Make kvfree() safe for calling while holding
 spinlocks
Message-ID: <Ycty6NHpYHNeDyxg@pc638.lan>
References: <20211222194828.15320-1-manfred@colorfullife.com>
 <Ycdo1PHC9KDD8eGD@pc638.lan>
 <YceiFXyoGcgPaLeJ@casper.infradead.org>
 <Ycis/J1U2DB6Zx7j@pc638.lan>
 <YctpUurav74Ir5YS@pc638.lan>
 <18b6afe8-43b1-4159-0ddd-eca08f175f0a@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18b6afe8-43b1-4159-0ddd-eca08f175f0a@colorfullife.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Hello Vlad,
> 
> On 12/28/21 20:45, Uladzislau Rezki wrote:
> > [...]
> > Manfred, could you please have a look and if you have a time test it?
> > I mean if it solves your issue. You can take over this patch and resend
> > it, otherwise i can send it myself later if we all agree with it.
> 
> I think we mix tasks: We have a bug in ipc/sem.c, thus we need a solution
> suitable for stable.
> 
> Fixes: fc37a3b8b438 ("[PATCH] ipc sem: use kvmalloc for sem_undo
> allocation")
> Cc: stable@vger.kernel.org
> 
> I think for stable, there are only two options:
> 
> - change ipc/sem.c, call kvfree() after dropping the spinlock
> 
> - change kvfree() to use vfree_atomic().
> 
> From my point of view, both approaches are fine.
> 
> I.e. I'm waiting for feedback from an mm maintainer.
> 
> As soon as it is agreed, I will retest the chosen solution.
> 
Here for me it anyway looks like a change and it is hard to judge
if the second solution is stable or not, because it is a new change
and the kvfree() interface is changed internally.

> 
> Now you propose to redesign vfree(), so that vfree() is safe to be called
> while holding spinlocks:
> 
> > <snip>
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index d2a00ad4e1dd..b82db44fea60 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -1717,17 +1717,10 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end)
> >   	return true;
> >   }
> > -/*
> > - * Kick off a purge of the outstanding lazy areas. Don't bother if somebody
> > - * is already purging.
> > - */
> > -static void try_purge_vmap_area_lazy(void)
> > -{
> > -	if (mutex_trylock(&vmap_purge_lock)) {
> > -		__purge_vmap_area_lazy(ULONG_MAX, 0);
> > -		mutex_unlock(&vmap_purge_lock);
> > -	}
> > -}
> > +static void purge_vmap_area_lazy(void);
> > +static void drain_vmap_area(struct work_struct *work);
> > +static DECLARE_WORK(drain_vmap_area_work, drain_vmap_area);
> > +static atomic_t drain_vmap_area_work_in_progress;
> >   /*
> >    * Kick off a purge of the outstanding lazy areas.
> > @@ -1740,6 +1733,22 @@ static void purge_vmap_area_lazy(void)
> >   	mutex_unlock(&vmap_purge_lock);
> >   }
> > +static void drain_vmap_area(struct work_struct *work)
> > +{
> > +	mutex_lock(&vmap_purge_lock);
> > +	__purge_vmap_area_lazy(ULONG_MAX, 0);
> > +	mutex_unlock(&vmap_purge_lock);
> > +
> > +	/*
> > +	 * Check if rearming is still required. If not, we are
> > +	 * done and can let a next caller to initiate a new drain.
> > +	 */
> > +	if (atomic_long_read(&vmap_lazy_nr) > lazy_max_pages())
> > +		schedule_work(&drain_vmap_area_work);
> > +	else
> > +		atomic_set(&drain_vmap_area_work_in_progress, 0);
> > +}
> > +
> >   /*
> >    * Free a vmap area, caller ensuring that the area has been unmapped
> >    * and flush_cache_vunmap had been called for the correct range
> > @@ -1766,7 +1775,8 @@ static void free_vmap_area_noflush(struct vmap_area *va)
> >   	/* After this point, we may free va at any time */
> >   	if (unlikely(nr_lazy > lazy_max_pages()))
> > -		try_purge_vmap_area_lazy();
> > +		if (!atomic_xchg(&drain_vmap_area_work_in_progress, 1))
> > +			schedule_work(&drain_vmap_area_work);
> >   }
> >   /*
> > <snip>
> I do now know the mm code well enough to understand the side effects of the
> change. And doubt that it is suitable for stable, i.e. we need the simple
> patch first.
> 
Well, it is as simple as it could be :)

--
Vlad Rezki
