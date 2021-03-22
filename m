Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44971343D41
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 10:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhCVJwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 05:52:50 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:49273 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229953AbhCVJws (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 05:52:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 2275ACB9;
        Mon, 22 Mar 2021 05:52:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 22 Mar 2021 05:52:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/FXqka
        QEASQkggHOaF0/bOUn1MaAhpIa7V2XWaTDFi0=; b=gNnVFd/3s07bT/6JUBhR4r
        wzD9+BmuyYAMNyZnRoN/NUy2oRRp5QQqD9v4ZCYI8Uhg4uidwuIFcFm12+IgB9YI
        RNWPfEgY5Y8sFWjq7DsWi6WcSDhQhTG7kPtaCAkAmYjgyJzm6S1Ye2HvuI2cue7b
        E2i0eVyfklJdvxoXJO0J8HFtPy2G/4kWWA/u45fFZl098c5Vple65AdIQnwftYi7
        9AGiKI7n4xuJbQqWk//OUxm8JyMdfsfpBTolYQJjKSpgRPth/Q/dwZdRHCIf1IE6
        WhN2dyw6lCZ12ufqbAx0dlOj9+OW4R31b5YFiFedTn0PIOzF1l3BDskZzSL0WbsA
        ==
X-ME-Sender: <xms:72hYYP4NBt7XwsNk1cy8Bl5FLvb-cvgEYFdi2LA_RpNE6sAaHyJw6A>
    <xme:72hYYE5FRGunSSL7kJfz6ZYu0l0LNPwkWp4VNpjMNGi-bCmhoROaiLB7vmhxFnPZ-
    cUQYYia_2o4xg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:72hYYGfunYHh4r-hLnbnO491vju__TQSIr7_cBASCoeEYnfb4WEE8w>
    <xmx:72hYYAJ4RnKjWOFRv7-XIMvKwyAomv9YZPz-FT0g6_nAQiZgRCBhVQ>
    <xmx:72hYYDKp7pGypNU_xqX5d3IJS4z7A7a6skanNWxnL4258Wv4JpDn8w>
    <xmx:72hYYJjBPzEX_FQ4FSEOEbQ7nCkakfLwH5CjUqpqWawFVn7e8KS-pPUS2SM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BE373108005F;
        Mon, 22 Mar 2021 05:52:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] static_call: Fix static_call_set_init()" failed to apply to 5.10-stable tree
To:     peterz@infradead.org, jarkko@kernel.org, sumit.garg@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Mar 2021 10:52:44 +0100
Message-ID: <161640676410891@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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
 

