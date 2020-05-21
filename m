Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBC01DDB27
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729933AbgEUXkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgEUXkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:40:02 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6032C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:02 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id r18so7208824ybg.10
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IFcm8MEdHgn+QY+GN6cVVt/3O5tmQDZSQsUvMgNilag=;
        b=ENsA5hlc1ayPpny8iisUbMHHR6aWs5MGhfvgaD54enLz9KWlQekL9ELT3lU/ztykrX
         8L9ZBqLX46vJGocyCVrUKGC4zsQM8/I7HQu5gI0CgxEhdyb8V/7pBrg4HaUArrA9VFIo
         AMvEKXpXruaWDTcOSUPykifcA1cLYiaihRpdAYlJ4Nqglt9vcSIKtsVXokYycs2Y7Qiz
         XvSGGFz4lsJmvvYpPw3NJCkscj2v6k6jrWm54KzIzeXOXUMDn3pXC955XVmatcGucLOu
         kFn52ATk9FqS1peX06LYBTA7r/g0hLomodbe68JaKHUbgccrrt64Kz766rbxCSYdEEAe
         w8KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IFcm8MEdHgn+QY+GN6cVVt/3O5tmQDZSQsUvMgNilag=;
        b=R1vYZRXi2ur83SSw5KtD7RTe/ujOIqPC8g3oP5kr34lh5Xhsez5T4GZOLS0olMbDGJ
         62t9c2Rpbq0rdGz8l9n86npYLW34jSTGqtCcCqCq9TByRnMqKDbx1RzkchdnCUCEb5wA
         CXLruQsPG5liYHboQtUMyQMPtheGFMfrnGF+HDonTh2+uKd2Pu9yp/q5h7R+mnHvfW7a
         KKRq9z9OdYorn+XKGN1V0xwk/IxrT7P6W4zWEClqvPfkRASz9QEG5L2yWKMYNY+LCBh2
         yxaiiTQOXvYVTLfiJHOI9iizgbgqBu5jFGOjVHQIbH0emYVJlbTFRaY302EoI25DZkB/
         9zcA==
X-Gm-Message-State: AOAM532CWJIXQUUd9WobrqTujhwqAMpeyzMGYGx9xwQeil9r6XIoUXRG
        wt/JXHPMzazgqmcFma17f5Eggrgd/AdIQg==
X-Google-Smtp-Source: ABdhPJzg9CpOmlzEPxhCnpI/efDA5ETgpGsosxj1sBwvF38HS0YPfL8Tp9tGh2uD44UVQ4gxDjjTwTj1EwJmTw==
X-Received: by 2002:a25:354:: with SMTP id 81mr16539266ybd.257.1590104401900;
 Thu, 21 May 2020 16:40:01 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:23 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-9-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 08/22] l2tp: define parameters of l2tp_session_get*() as "const"
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit 9aaef50c44f132e040dcd7686c8e78a3390037c5 upstream.

Make l2tp_pernet()'s parameter constant, so that l2tp_session_get*() can
declare their "net" variable as "const".
Also constify "ifname" in l2tp_session_get_by_ifname().

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_core.c | 7 ++++---
 net/l2tp/l2tp_core.h | 5 +++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 440065462a69..be8d7b2b8790 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -119,7 +119,7 @@ static inline struct l2tp_tunnel *l2tp_tunnel(struct sock *sk)
 	return sk->sk_user_data;
 }
 
-static inline struct l2tp_net *l2tp_pernet(struct net *net)
+static inline struct l2tp_net *l2tp_pernet(const struct net *net)
 {
 	BUG_ON(!net);
 
@@ -231,7 +231,7 @@ l2tp_session_id_hash(struct l2tp_tunnel *tunnel, u32 session_id)
 /* Lookup a session. A new reference is held on the returned session.
  * Optionally calls session->ref() too if do_ref is true.
  */
-struct l2tp_session *l2tp_session_get(struct net *net,
+struct l2tp_session *l2tp_session_get(const struct net *net,
 				      struct l2tp_tunnel *tunnel,
 				      u32 session_id, bool do_ref)
 {
@@ -306,7 +306,8 @@ EXPORT_SYMBOL_GPL(l2tp_session_get_nth);
 /* Lookup a session by interface name.
  * This is very inefficient but is only used by management interfaces.
  */
-struct l2tp_session *l2tp_session_get_by_ifname(struct net *net, char *ifname,
+struct l2tp_session *l2tp_session_get_by_ifname(const struct net *net,
+						const char *ifname,
 						bool do_ref)
 {
 	struct l2tp_net *pn = l2tp_pernet(net);
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index e38db6a807f5..3a3d96df6071 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -231,12 +231,13 @@ static inline struct l2tp_tunnel *l2tp_sock_to_tunnel(struct sock *sk)
 	return tunnel;
 }
 
-struct l2tp_session *l2tp_session_get(struct net *net,
+struct l2tp_session *l2tp_session_get(const struct net *net,
 				      struct l2tp_tunnel *tunnel,
 				      u32 session_id, bool do_ref);
 struct l2tp_session *l2tp_session_get_nth(struct l2tp_tunnel *tunnel, int nth,
 					  bool do_ref);
-struct l2tp_session *l2tp_session_get_by_ifname(struct net *net, char *ifname,
+struct l2tp_session *l2tp_session_get_by_ifname(const struct net *net,
+						const char *ifname,
 						bool do_ref);
 struct l2tp_tunnel *l2tp_tunnel_find(struct net *net, u32 tunnel_id);
 struct l2tp_tunnel *l2tp_tunnel_find_nth(struct net *net, int nth);
-- 
2.27.0.rc0.183.gde8f92d652-goog

