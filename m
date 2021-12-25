Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804D647F442
	for <lists+stable@lfdr.de>; Sat, 25 Dec 2021 19:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhLYSyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Dec 2021 13:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbhLYSyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Dec 2021 13:54:18 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6F9C061401;
        Sat, 25 Dec 2021 10:54:18 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id g13so6569526ljj.10;
        Sat, 25 Dec 2021 10:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y2+/qiNo/lc2hZbvIk7mkHcn43TlT7O3oJDxcDPiMEI=;
        b=frX9AN8+9X+gKKNK1hZQBCLJFeFH1XlmlYjyJMZxRWtsj1UYQxRZ/pjahJc8KacK6O
         2EC4B3Ij7ZEP5T/tM0UkdEf+Wp0z0fhgt2xcQWAH7rCVERG2yHatrfj+cPxhU9jiI08p
         b6OgwbE1cYkuodxyK6HuHqvlufNveBAHNX9AwXMdQ13+6QH1q8dWsbR5JvyinVYFqnom
         yTUqwMFxR1nQGQJbOg+eOStpGMAKmw2niFkk2WtlAHrV5kdGbJdFnIaJS3Z0HUQfYKN/
         tkJPK9eNyJVkulkFiTrLUU6LVH1H4LxxPHfk9giZhAp3yaV860gbY4Sh2oaXB75VmwBP
         QCYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y2+/qiNo/lc2hZbvIk7mkHcn43TlT7O3oJDxcDPiMEI=;
        b=TrM9pD+6TZgluZOmO4Y1dg0jD78wMkM11hnNkZELpLXUgq97BT8a/XUHQT2BWdLBFL
         XmAANeZQfZRNJr0gMHKxRDUv0bEzSV4/GV7Hcr+ab/SNkHJ8z0w04IlCdJ2VFynU2+OA
         qGaC3Wxy9XRqi7dAkK4Xq0yeA/sXb1K/KFiewagfCjwaHHWqIEYiwzGn7g7FGO6ofRUW
         kJqBppVnG2IFm+IYMadg5n8m8PJDGwhi7ZTlzdJJhlz9IqsfGjRJeHq+/6CB7kJS5pT7
         AuWzoBnSF5vRYjOZ+Go1vOhZU0//DEQs9JTSUZxywYMEQQmExkIcquzKtVM9vNkcrluO
         AesQ==
X-Gm-Message-State: AOAM532CnBNizWS4QIhfPN8gBenENsU8QKhy7zSnPpfSiYLBG/7u2+xl
        zQD74HC82/1Zd1lXH1+ySD0=
X-Google-Smtp-Source: ABdhPJwfjV5Sod80kgtYBDoTlDwfpRGA+vXrfMsjNnrTDPxSfJH838WXHq9IQP/awkpLxr9WQz1Biw==
X-Received: by 2002:a2e:b88c:: with SMTP id r12mr8315292ljp.294.1640458455562;
        Sat, 25 Dec 2021 10:54:15 -0800 (PST)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id z23sm1106539ljn.23.2021.12.25.10.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Dec 2021 10:54:14 -0800 (PST)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Sat, 25 Dec 2021 19:54:12 +0100
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasily Averin <vvs@virtuozzo.com>, cgel.zte@gmail.com,
        shakeelb@google.com, rdunlap@infradead.org, dbueso@suse.de,
        unixbhaskar@gmail.com, chi.minghao@zte.com.cn, arnd@arndb.de,
        Zeal Robot <zealci@zte.com.cn>, linux-mm@kvack.org,
        1vier1@web.de, stable@vger.kernel.org
Subject: Re: [PATCH] mm/util.c: Make kvfree() safe for calling while holding
 spinlocks
Message-ID: <Ycdo1PHC9KDD8eGD@pc638.lan>
References: <20211222194828.15320-1-manfred@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211222194828.15320-1-manfred@colorfullife.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> One codepath in find_alloc_undo() calls kvfree() while holding a spinlock.
> Since vfree() can sleep this is a bug.
> 
> Previously, the code path used kfree(), and kfree() is safe to be called
> while holding a spinlock.
> 
> Minghao proposed to fix this by updating find_alloc_undo().
> 
> Alternate proposal to fix this: Instead of changing find_alloc_undo(),
> change kvfree() so that the same rules as for kfree() apply:
> Having different rules for kfree() and kvfree() just asks for bugs.
> 
> Disadvantage: Releasing vmalloc'ed memory will be delayed a bit.
> 
I guess the issues is with "vmap_purge_lock" mutex? I think it is better
to make the vfree() call as non-blocking one, i.e. the current design is
is suffering from one drawback. It is related to purging the outstanding
lazy areas from caller context. The drain process can be time consuming
and if it is done from high-prio or RT contexts it can hog a CPU. Another
issue is what you have reported that is about calling the schedule() and
holding spinlock. The proposal is to perform a drain in a separate work:

<snip>
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d2a00ad4e1dd..7c5d9b148fa4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1717,18 +1717,6 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end)
 	return true;
 }
 
-/*
- * Kick off a purge of the outstanding lazy areas. Don't bother if somebody
- * is already purging.
- */
-static void try_purge_vmap_area_lazy(void)
-{
-	if (mutex_trylock(&vmap_purge_lock)) {
-		__purge_vmap_area_lazy(ULONG_MAX, 0);
-		mutex_unlock(&vmap_purge_lock);
-	}
-}
-
 /*
  * Kick off a purge of the outstanding lazy areas.
  */
@@ -1740,6 +1728,16 @@ static void purge_vmap_area_lazy(void)
 	mutex_unlock(&vmap_purge_lock);
 }
 
+static void drain_vmap_area(struct work_struct *work)
+{
+	if (mutex_trylock(&vmap_purge_lock)) {
+		__purge_vmap_area_lazy(ULONG_MAX, 0);
+		mutex_unlock(&vmap_purge_lock);
+	}
+}
+
+static DECLARE_WORK(drain_vmap_area_work, drain_vmap_area);
+
 /*
  * Free a vmap area, caller ensuring that the area has been unmapped
  * and flush_cache_vunmap had been called for the correct range
@@ -1766,7 +1764,7 @@ static void free_vmap_area_noflush(struct vmap_area *va)
 
 	/* After this point, we may free va at any time */
 	if (unlikely(nr_lazy > lazy_max_pages()))
-		try_purge_vmap_area_lazy();
+		schedule_work(&drain_vmap_area_work);
 }
 
 /*
<snip>


--
Vlad Rezki
