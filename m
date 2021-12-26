Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7456F47F870
	for <lists+stable@lfdr.de>; Sun, 26 Dec 2021 18:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbhLZR5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Dec 2021 12:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbhLZR5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Dec 2021 12:57:22 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831B2C06173E;
        Sun, 26 Dec 2021 09:57:21 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id u13so30185683lff.12;
        Sun, 26 Dec 2021 09:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y/KMILrBq1hPy+xDvjqcSHV2HcfoucjLDA3+9/tMVT0=;
        b=F0t5qpmstEAZj0YEL1wM8elsvrt/rZJ0nL/KElvIKruFcShSjvtBudTODxDs7Tj/qg
         katgz/y/08xD5MWchIBOB5RfH6Z6CWi5jm91Fw3uVAxLX51s536922ajRdxqGeBIe3kP
         KTRsuzNPIf6iCUQNHSYB5RSnt2Wep0FMQ9h/R+/UiqlTvZK6CVxBinOZSrhu3f/et/f4
         03FWQaKDTC36HF73ay5n7cK2pAeJ7xqBDU7WaEQJbULp3AlG6i/8tDTuP+skXRIKykoV
         GOlWx8OvRDMqlb6LNjSwntdY+49NEXE0go3xeAfAq4uvZ7rH0Q5Jw/tqRpL54o+Gpr9k
         SgDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y/KMILrBq1hPy+xDvjqcSHV2HcfoucjLDA3+9/tMVT0=;
        b=r5Lr3V5r0hh/CDBWX+g10fgsXTNipljQlcGGnLhKd82wUn7pWjP2l8OijwpKn2lemx
         km39Cwq4f6z9Sr2/UsQFel546d6o+vzBd+0ZvXAjzUyD+LC13FkCZgGI9hYWRwxt5gbf
         dz9xy18KX2xLhHpLCRRIuWFVMdgeNIxO3AujukxbqR55cw9IaWfC7Q6EMNk4dKoVJ8Le
         8o4JG4RkNZgne3gjbQTr6vIlnVaRHeriKdRCCiYbMfRMa2SpKFBYlQQHPHAWwlm6C5lK
         +Oufjx0P8S9nV7uu34AMoHtiCjiFRujKFBJCCt87By42G8Ew/vuvgcVbkiP2hhg2PSfA
         NErA==
X-Gm-Message-State: AOAM533k6IX8pcopWIPDh5aRWSY8bueG/hflrxQL55rjEy2f7la7iBY8
        TN3uj6Kk2ByKEWRXjy6BYqs=
X-Google-Smtp-Source: ABdhPJxHdN9lbBkDQFqp2UaQueYrnTWdb/e/F2F1erX8MpQ5lc9Sq840sBcXsiifAnW2MXF/QdkS4w==
X-Received: by 2002:a05:6512:11cf:: with SMTP id h15mr12606157lfr.138.1640541439634;
        Sun, 26 Dec 2021 09:57:19 -0800 (PST)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id m13sm844312lfg.139.2021.12.26.09.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Dec 2021 09:57:18 -0800 (PST)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Sun, 26 Dec 2021 18:57:16 +0100
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Uladzislau Rezki <urezki@gmail.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasily Averin <vvs@virtuozzo.com>, cgel.zte@gmail.com,
        shakeelb@google.com, rdunlap@infradead.org, dbueso@suse.de,
        unixbhaskar@gmail.com, chi.minghao@zte.com.cn, arnd@arndb.de,
        Zeal Robot <zealci@zte.com.cn>, linux-mm@kvack.org,
        1vier1@web.de, stable@vger.kernel.org
Subject: Re: [PATCH] mm/util.c: Make kvfree() safe for calling while holding
 spinlocks
Message-ID: <Ycis/J1U2DB6Zx7j@pc638.lan>
References: <20211222194828.15320-1-manfred@colorfullife.com>
 <Ycdo1PHC9KDD8eGD@pc638.lan>
 <YceiFXyoGcgPaLeJ@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YceiFXyoGcgPaLeJ@casper.infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 25, 2021 at 10:58:29PM +0000, Matthew Wilcox wrote:
> On Sat, Dec 25, 2021 at 07:54:12PM +0100, Uladzislau Rezki wrote:
> > +static void drain_vmap_area(struct work_struct *work)
> > +{
> > +	if (mutex_trylock(&vmap_purge_lock)) {
> > +		__purge_vmap_area_lazy(ULONG_MAX, 0);
> > +		mutex_unlock(&vmap_purge_lock);
> > +	}
> > +}
> > +
> > +static DECLARE_WORK(drain_vmap_area_work, drain_vmap_area);
> 
> Presuambly if the worker fails to get the mutex, it should reschedule
> itself?  And should it even trylock or just always lock?
> 
mutex_trylock() has no sense here. It should just always get the lock.
Otherwise we can miss the point to purge. Agree with your opinion.

>
> This kind of ties into something I've been wondering about -- we have
> a number of places in the kernel which cache 'freed' vmalloc allocations
> in order to speed up future allocations of the same size.  Kind of like
> slab.  Would we be better off trying to cache frequent allocations
> inside vmalloc instead of always purging them?
>
Hm... Some sort of caching would be good. Though it will require some 
time to think over all details and design itself. We can cache VAs
instead of purging them until some point or threshold. So basically
we can keep it in our data structures, associate it with some cache,
based on size and reuse it later in the alloc_vmap_area(). 

All that is related to "vmap_area" caching. Another option is to cache
the "vm_struct". It includes "vmap_area" + pages to drive the mapping.
It is a higher level of caching and i am not sure if an implementation 
would be so straightforward.

--
Vlad Rezki
