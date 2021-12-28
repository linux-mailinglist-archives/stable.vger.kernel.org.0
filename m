Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C954480CD4
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 20:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbhL1Tp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 14:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbhL1Tp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 14:45:28 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A864C061574;
        Tue, 28 Dec 2021 11:45:28 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id k27so32229984ljc.4;
        Tue, 28 Dec 2021 11:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o9olEKFlA55ZJTj6pGz1teXDqC+Puxhe5pQT53/VCPs=;
        b=Kn/7lVydah5hdVCDnM9++24rhnnD/RpyVA5cDmQXgdbL5QYG/ZKA+uPseckR1p+ovP
         TyK6yc0YJ38MUDQfuC6s/uIwk9Kjv0sCWPVx1R22NQxxmoo027NoYH+ta8VTDldyNf7c
         AVdBlp4/GQZ0j81cWnq8Zxr/TuALjTjOAE8y8wQ+XCTpUks+9HWptE7H3K195MG+X9qk
         kk1Sj0J4XtxEpufFE8yzuZisPPITLGFMIrhwaRcI9dLXhSdG7b3RpH/HiU9ujZjMM3qB
         73v2SygW+AcRbXUpin6rEtPHSS5AS4eEjpUwyYb0Jn70ztd6mntcbCjXXcIkhgpaDYyt
         1zrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o9olEKFlA55ZJTj6pGz1teXDqC+Puxhe5pQT53/VCPs=;
        b=IfY/+o58P5KlSByv3GU835507ozDuHDYE7kHJO66bK8JuIbl417GEqfHrk0guP3cEI
         7yyeqTMfuaVjwhWAJ9BuPgKpneLj8PPcf3wQY8v0U6V04/7t0slQcDys4NDB1jV+KX5Z
         wA8dCWcanKVKJJE2MSgkxZby6397bv88RYTVsQz77Z/NLiBCn/GyPsM0C+uS2SyST/sh
         2QL6lruMDeBiQOl6QPAvb2LVzLeg6MqIWISJA62EuuiQakjvfIA2nVBwbyVdqS3rMcH4
         KS8I9OsByMzWcdXlsHORZKmYpTKxaehlIypG6yuvFhz+EKzlUKSbBPD8rbA5Y9OTM5U0
         2ZMA==
X-Gm-Message-State: AOAM5325n2hrNrxvP5pkpkGNEecwItPh3TLakwXfzuTk8l92Ns4gJdc5
        asNceQ8QZmFJo79sYV2SJZgN/lYej2UkTw==
X-Google-Smtp-Source: ABdhPJwU1p9x7xu7xLETwDkQJPqmjQWGEmx5dGeUsx32iiTom8PhIXwjFUHSt1qG6HBRxmBYFlUe0A==
X-Received: by 2002:a05:651c:481:: with SMTP id s1mr3689346ljc.385.1640720726214;
        Tue, 28 Dec 2021 11:45:26 -0800 (PST)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id s21sm1778797ljg.131.2021.12.28.11.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 11:45:25 -0800 (PST)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Tue, 28 Dec 2021 20:45:22 +0100
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
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
Message-ID: <YctpUurav74Ir5YS@pc638.lan>
References: <20211222194828.15320-1-manfred@colorfullife.com>
 <Ycdo1PHC9KDD8eGD@pc638.lan>
 <YceiFXyoGcgPaLeJ@casper.infradead.org>
 <Ycis/J1U2DB6Zx7j@pc638.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ycis/J1U2DB6Zx7j@pc638.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 26, 2021 at 06:57:16PM +0100, Uladzislau Rezki wrote:
> On Sat, Dec 25, 2021 at 10:58:29PM +0000, Matthew Wilcox wrote:
> > On Sat, Dec 25, 2021 at 07:54:12PM +0100, Uladzislau Rezki wrote:
> > > +static void drain_vmap_area(struct work_struct *work)
> > > +{
> > > +	if (mutex_trylock(&vmap_purge_lock)) {
> > > +		__purge_vmap_area_lazy(ULONG_MAX, 0);
> > > +		mutex_unlock(&vmap_purge_lock);
> > > +	}
> > > +}
> > > +
> > > +static DECLARE_WORK(drain_vmap_area_work, drain_vmap_area);
> > 
> > Presuambly if the worker fails to get the mutex, it should reschedule
> > itself?  And should it even trylock or just always lock?
> > 
> mutex_trylock() has no sense here. It should just always get the lock.
> Otherwise we can miss the point to purge. Agree with your opinion.
> 
Below the patch that address Matthew's points:

<snip>
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d2a00ad4e1dd..b82db44fea60 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1717,17 +1717,10 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end)
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
+static void purge_vmap_area_lazy(void);
+static void drain_vmap_area(struct work_struct *work);
+static DECLARE_WORK(drain_vmap_area_work, drain_vmap_area);
+static atomic_t drain_vmap_area_work_in_progress;
 
 /*
  * Kick off a purge of the outstanding lazy areas.
@@ -1740,6 +1733,22 @@ static void purge_vmap_area_lazy(void)
 	mutex_unlock(&vmap_purge_lock);
 }
 
+static void drain_vmap_area(struct work_struct *work)
+{
+	mutex_lock(&vmap_purge_lock);
+	__purge_vmap_area_lazy(ULONG_MAX, 0);
+	mutex_unlock(&vmap_purge_lock);
+
+	/*
+	 * Check if rearming is still required. If not, we are
+	 * done and can let a next caller to initiate a new drain.
+	 */
+	if (atomic_long_read(&vmap_lazy_nr) > lazy_max_pages())
+		schedule_work(&drain_vmap_area_work);
+	else
+		atomic_set(&drain_vmap_area_work_in_progress, 0);
+}
+
 /*
  * Free a vmap area, caller ensuring that the area has been unmapped
  * and flush_cache_vunmap had been called for the correct range
@@ -1766,7 +1775,8 @@ static void free_vmap_area_noflush(struct vmap_area *va)
 
 	/* After this point, we may free va at any time */
 	if (unlikely(nr_lazy > lazy_max_pages()))
-		try_purge_vmap_area_lazy();
+		if (!atomic_xchg(&drain_vmap_area_work_in_progress, 1))
+			schedule_work(&drain_vmap_area_work);
 }
 
 /*
<snip>

Manfred, could you please have a look and if you have a time test it?
I mean if it solves your issue. You can take over this patch and resend
it, otherwise i can send it myself later if we all agree with it.

--
Vlad Rezki
