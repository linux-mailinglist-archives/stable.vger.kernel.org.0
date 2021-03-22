Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801F6343D43
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 10:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhCVJxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 05:53:24 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:57727 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229870AbhCVJwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 05:52:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 0BBE9109E;
        Mon, 22 Mar 2021 05:52:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 22 Mar 2021 05:52:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YMDOAt
        6d+VgLnQKLrB3ekjnFvn+Sx9I9zNbAur89R4Q=; b=h0OqMhAVFl1Cr+CcqrJyyt
        oUl5f59zYer1yM3EQw7hUvNgDM4JREaZ2sVJRHF23I9/WXuRD2CaEUuJPkgZlB7J
        +XQ4+cnFrAxdhYOqqTs0oRM6nK2BqbQ0/Xd0ga2audiLKrkhQqN5HBa6BXumwQJe
        TeGIAPO60oQKZZIogF46g8/ySvZ0Tuy81dnzxDxrFBgAAtCgco9IU6O6R/oU8/88
        YQ7wyXWvI1QbfKdMojRZURaYDpNEavkFcgcn07RgqyFcKec5hQnvSLEsVvQBHMOX
        6XbIRX3V8TtWZ1XoBWWm+C6XEPuk0+KGO8NnJcUbkE8Acaco7TSo5C4sEOp8A0og
        ==
X-ME-Sender: <xms:9mhYYHAydiW6mJ-nKj_Xn9PGbZbb-0qnhrLyS7L89rYELsWJ5VQeTQ>
    <xme:9mhYYNg12gud3Q4n2W4qagEOfRbjKNmRvZzNUXto1b2Y6YApdgxEsM2q4ciqmi7st
    NRwh4XtQdYfrw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:9mhYYClVyQIMAJFonDZYou1OdlYyFd2XMjn2SdwMJcVL5R58FtIR6Q>
    <xmx:9mhYYJyE62Z0jkv4aA1xgyonCAPE4U9awyY4T569QxmL8x7-QzFGqA>
    <xmx:9mhYYMRify-l2447VBfM-qEMDRe7yYh7D-v4kIt0XWhYAVG3Px9e0Q>
    <xmx:9mhYYHIHnLVVJ1Gm3zolphU4EpMhvdmHEYqrdU3b-CPzC2ESElsoGMQ29gE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0CF67108005F;
        Mon, 22 Mar 2021 05:52:53 -0400 (EDT)
Subject: FAILED: patch "[PATCH] static_call: Fix static_call_set_init()" failed to apply to 5.11-stable tree
To:     peterz@infradead.org, jarkko@kernel.org, sumit.garg@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Mar 2021 10:52:44 +0100
Message-ID: <16164067648372@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 68b1eddd421d2b16c6655eceb48918a1e896bbbc Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 18 Mar 2021 11:27:19 +0100
Subject: [PATCH] static_call: Fix static_call_set_init()

It turns out that static_call_set_init() does not preserve the other
flags; IOW. it clears TAIL if it was set.

Fixes: 9183c3f9ed710 ("static_call: Add inline static call infrastructure")
Reported-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Sumit Garg <sumit.garg@linaro.org>
Link: https://lkml.kernel.org/r/20210318113610.519406371@infradead.org

diff --git a/kernel/static_call.c b/kernel/static_call.c
index ae825295cf68..080c8a9ddfaf 100644
--- a/kernel/static_call.c
+++ b/kernel/static_call.c
@@ -35,27 +35,30 @@ static inline void *static_call_addr(struct static_call_site *site)
 	return (void *)((long)site->addr + (long)&site->addr);
 }
 
+static inline unsigned long __static_call_key(const struct static_call_site *site)
+{
+	return (long)site->key + (long)&site->key;
+}
 
 static inline struct static_call_key *static_call_key(const struct static_call_site *site)
 {
-	return (struct static_call_key *)
-		(((long)site->key + (long)&site->key) & ~STATIC_CALL_SITE_FLAGS);
+	return (void *)(__static_call_key(site) & ~STATIC_CALL_SITE_FLAGS);
 }
 
 /* These assume the key is word-aligned. */
 static inline bool static_call_is_init(struct static_call_site *site)
 {
-	return ((long)site->key + (long)&site->key) & STATIC_CALL_SITE_INIT;
+	return __static_call_key(site) & STATIC_CALL_SITE_INIT;
 }
 
 static inline bool static_call_is_tail(struct static_call_site *site)
 {
-	return ((long)site->key + (long)&site->key) & STATIC_CALL_SITE_TAIL;
+	return __static_call_key(site) & STATIC_CALL_SITE_TAIL;
 }
 
 static inline void static_call_set_init(struct static_call_site *site)
 {
-	site->key = ((long)static_call_key(site) | STATIC_CALL_SITE_INIT) -
+	site->key = (__static_call_key(site) | STATIC_CALL_SITE_INIT) -
 		    (long)&site->key;
 }
 
@@ -190,7 +193,7 @@ void __static_call_update(struct static_call_key *key, void *tramp, void *func)
 			}
 
 			arch_static_call_transform(site_addr, NULL, func,
-				static_call_is_tail(site));
+						   static_call_is_tail(site));
 		}
 	}
 
@@ -349,7 +352,7 @@ static int static_call_add_module(struct module *mod)
 	struct static_call_site *site;
 
 	for (site = start; site != stop; site++) {
-		unsigned long s_key = (long)site->key + (long)&site->key;
+		unsigned long s_key = __static_call_key(site);
 		unsigned long addr = s_key & ~STATIC_CALL_SITE_FLAGS;
 		unsigned long key;
 

