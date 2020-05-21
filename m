Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9921DDB71
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729904AbgEUX6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:21 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365F7C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:21 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id d11so8857610qvv.10
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NwYuFW/Davgu6yg+PTdQ2BZfaJXuhvD0Ti2cpme4TNQ=;
        b=dJMhUgQkP4OHKMinyQ0ykcYTN5ZTIKrZIgkd9T7Qzc58Q7SPVnTJVLpbOvc1CBjGfW
         sFv2OQtbK3imdNhWkZINyhai/mq9MZMjRpz1q1GhMZGLSXAhrl5fLsfcmlCN97NXE3ur
         pINbcjDBVBQH3ll1KJCs6u8z1BEEqXvPIfVO+Xg+IBPNUZLbhtMcJuucQLiEHJQuDH+J
         hOdhZB4XK5GIXh9bRITqkvYLO6zNhJZKyLlxEHhKP7zDVZWxP0O1yjxJttSVlRaWrDvu
         D87TqvMWzwaU6iHhCl1ndfBkCO9RS1n+ZdRbU4M1eecFaiZza+iC2W5up1zzPR0b/yuh
         LTjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NwYuFW/Davgu6yg+PTdQ2BZfaJXuhvD0Ti2cpme4TNQ=;
        b=sEEW8gswmvrGqBHsPGYvg+K+D4DG7RJ72tawsgr5Cb5DNv+CZ8ESDN48oqBjwTS7kd
         4dYBEE6mESIyf4m+WaRZBwSaWDpZQOFKOcjRNzHUeN8TJ2QqerXkitW/bGDUN34Ldcu3
         WtAk5d/Sr5Lc7+T+6u4vr4auTl+wtNVKNb6Pod8hJ7KNfpUjVIGfibAuy48rENYA0MUi
         YMyI+h1+6hnnjdWH+HOdf0f28iOh+4/pttxYbm1U3JJ0djS6H/yPtAVR6mjclWHiG9QO
         xPySroPXL2Y5A1him9mJfZoeGMTRBoNYUjrM4NAwp7BYxMaFZL1jnpmGXTKm7fCmZYt1
         2qkw==
X-Gm-Message-State: AOAM531lNie3ndQDwf5G/JuUPwCxLWbj+ZWg/M2hlRjjoG7hEyIKBZ7f
        FDi2cs51s/JxdQ6Rt5pW0Q2QhBOzyftRwA==
X-Google-Smtp-Source: ABdhPJz5IHidReJytAupVnI1MkrAPVhwTUPUXpSD5y8JH+JiYV5YFp+vx2pNIU9Onf4VMgxcMTqNcrT/MhdNLQ==
X-Received: by 2002:ad4:536a:: with SMTP id e10mr1232763qvv.246.1590105500376;
 Thu, 21 May 2020 16:58:20 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:26 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-14-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 13/27] l2tp: define parameters of l2tp_session_get*() as "const"
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
index 95fa01b4edc6..4e2859d72167 100644
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
index 7dc70f73a083..dab75dc4ea48 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -234,12 +234,13 @@ out:
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

