Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022F93A95D8
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 11:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbhFPJTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 05:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbhFPJTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 05:19:10 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4579FC061574;
        Wed, 16 Jun 2021 02:17:04 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id hq2so2751459ejc.2;
        Wed, 16 Jun 2021 02:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LqKUd7jpWI45dwJktjSkPLrqSZglJAQGDy+xWdh0jXY=;
        b=VaTZhGozIGkXk1Fk0y6lm3uqIM9EpHbCZOsKTehQDM6cFZ10wcgvVXrXpoFZCdGCSV
         TAlGhae+WPmKjAJ+YMBg4uCBJkgnfubNNxrFmlgfrLDCYMxMEWwqRMpFaqzL3RH57NVa
         gHTq24s1oRuRMxSn/pwtAEzNIowqYwsRrkERtfIp4ri+Qk35Nge4rDGcRWFCuHAEYRw/
         TMfRr3g3bMoPfLOVFowcYXZHRUwCbXYROl3X/1Ci1vPYccBRPa2enjDZxjSAnBvVYaKJ
         WbINiqVIIpIUeZEqYW1/9dV0NR6VoirJVClzxf9HQZuVKZN6KPPHbLwpk+14d+VVYTDt
         yrHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LqKUd7jpWI45dwJktjSkPLrqSZglJAQGDy+xWdh0jXY=;
        b=iAtLX6pMM+lZfZSq7DO7Gs1/6nLQoz+meWCntTMBoieaL8ETsz0ZZuKHL1kkFLtUkM
         T5XFBrv5EBS1hiDKUqPTxDFZsZpY/cQM/396NfRo0wcEO2JQgrviZRDWrclg5Lcrade2
         6XX+l61IA+dAdVQDsRNukCk6bh6JAdEN8c5xQls9Enl6UeM4EiAisF76sVkSzymb+/43
         166T/iXaRZVEgDR0nOYctaGClCcSHR6vbs6ny++caT5CWkAOayOjE9e351JKn8huydiC
         1Ifc2kbHoguzGDVBWPH9C9X0YKolC//d/m3nJF7XqZeWaGgs+xPxS+RmBt8+UDhJgpH0
         /Jkw==
X-Gm-Message-State: AOAM532aZOVIpdUai6axUfp9JT55NY1/MSy84oJ0PxAtdMtC0GsC9wJc
        Fs6LJwGTxAevxGBZkMBI3b+6402xCyB8DHZ3ZT8=
X-Google-Smtp-Source: ABdhPJybOgsSRMZfoEFaLEQxyeTtpNPDMN0fthWKyW6dAjnJmPwYFo1Zwf/q4os4LkGIYg6EhzdwsZuL8iZ047roZLY=
X-Received: by 2002:a17:906:994d:: with SMTP id zm13mr4149388ejb.427.1623835022871;
 Wed, 16 Jun 2021 02:17:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144743.039977287@linuxfoundation.org> <20210512144748.600206118@linuxfoundation.org>
 <CANEQ_++O0XVVdvynGtf37YCHSBT8CYHnUkK+VsFkOTqeqwOUtA@mail.gmail.com> <YMmlPHMn/+EPdbvm@kroah.com>
In-Reply-To: <YMmlPHMn/+EPdbvm@kroah.com>
From:   Amit Klein <aksecurity@gmail.com>
Date:   Wed, 16 Jun 2021 12:16:52 +0300
Message-ID: <CANEQ_++gbwU2Rvcqg5KtngZC1UX1XcjOKfPKRr3Pvxi+VyQX+Q@mail.gmail.com>
Subject: Re: [PATCH 5.4 175/244] inet: use bigger hash table for IP ID generation
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Here is the patch (minus headers, description, etc. - I believe these
can be copied as is from the 5.x patch, but not sure about the
rules...). It can be applied to 4.14.236. If this is OK, I can move on
to 4.9 and 4.4.


 net/ipv4/route.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 78d6bc61a1d8..022a2b748da3 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -70,6 +70,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/memblock.h>
 #include <linux/string.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
@@ -485,8 +486,10 @@ static void ipv4_confirm_neigh(const struct
dst_entry *dst, const void *daddr)
     __ipv4_confirm_neigh(dev, *(__force u32 *)pkey);
 }

-#define IP_IDENTS_SZ 2048u
-
+/* Hash tables of size 2048..262144 depending on RAM size.
+ * Each bucket uses 8 bytes.
+ */
+static u32 ip_idents_mask __read_mostly;
 static atomic_t *ip_idents __read_mostly;
 static u32 *ip_tstamps __read_mostly;

@@ -496,12 +499,16 @@ static u32 *ip_tstamps __read_mostly;
  */
 u32 ip_idents_reserve(u32 hash, int segs)
 {
-    u32 *p_tstamp = ip_tstamps + hash % IP_IDENTS_SZ;
-    atomic_t *p_id = ip_idents + hash % IP_IDENTS_SZ;
-    u32 old = ACCESS_ONCE(*p_tstamp);
-    u32 now = (u32)jiffies;
+    u32 bucket, old, now = (u32)jiffies;
+    atomic_t *p_id;
+    u32 *p_tstamp;
     u32 delta = 0;

+    bucket = hash & ip_idents_mask;
+    p_tstamp = ip_tstamps + bucket;
+    p_id = ip_idents + bucket;
+    old = READ_ONCE(*p_tstamp);
+
     if (old != now && cmpxchg(p_tstamp, old, now) == old)
         delta = prandom_u32_max(now - old);

@@ -3099,17 +3106,25 @@ struct ip_rt_acct __percpu *ip_rt_acct __read_mostly;
 int __init ip_rt_init(void)
 {
     int rc = 0;
+    void *idents_hash;
     int cpu;

-    ip_idents = kmalloc(IP_IDENTS_SZ * sizeof(*ip_idents), GFP_KERNEL);
-    if (!ip_idents)
-        panic("IP: failed to allocate ip_idents\n");
+    /* For modern hosts, this will use 2 MB of memory */
+    idents_hash = alloc_large_system_hash("IP idents",
+                          sizeof(*ip_idents) + sizeof(*ip_tstamps),
+                          0,
+                          16, /* one bucket per 64 KB */
+                          HASH_ZERO,
+                          NULL,
+                          &ip_idents_mask,
+                          2048,
+                          256*1024);
+
+    ip_idents = idents_hash;

-    prandom_bytes(ip_idents, IP_IDENTS_SZ * sizeof(*ip_idents));
+    prandom_bytes(ip_idents, (ip_idents_mask + 1) * sizeof(*ip_idents));

-    ip_tstamps = kcalloc(IP_IDENTS_SZ, sizeof(*ip_tstamps), GFP_KERNEL);
-    if (!ip_tstamps)
-        panic("IP: failed to allocate ip_tstamps\n");
+    ip_tstamps = idents_hash + (ip_idents_mask + 1) * sizeof(*ip_idents);

     for_each_possible_cpu(cpu) {
         struct uncached_list *ul = &per_cpu(rt_uncached_list, cpu);

On Wed, Jun 16, 2021 at 10:16 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jun 16, 2021 at 10:02:44AM +0300, Amit Klein wrote:
> >  Hi Greg et al.
> >
> > I see that you backported this patch (increasing the IP ID hash table size)
> > to the newer LTS branches more than a month ago. But I don't see that it
> > was backported to older LTS branches (4.19, 4.14, 4.9, 4.4). Is this
> > intentional?
>
> It applies cleanly to 4.19, but not the older ones.  If you think it is
> needed there for those kernels, please provide a working backport that
> we can apply.
>
> thanks,
>
> greg k-h
