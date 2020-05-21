Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92431DD044
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgEUOl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729670AbgEUOl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEF0C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:25 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e14so5514475ybh.16
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=23BPNjrd0NijNQ6rAC62AycGy9QnxzEit89UTG1+TO4=;
        b=IsX43Hd2gvzFx1TiKhK27pgwmAbEq8JCDbPHXuhISjj9EXCsNQt31U85Hud18hGgIZ
         dr1UD2K8mYR/zmKSMw5l1lVqdzp7n9h7vV/RjzG1Wh2gbhhVDbS/9sE1k2U0Py7SRz3W
         mtiT7Q+95es/2Tc6Ew55eQoAIJslnoeB5GtCCpZCyvthz62UpvBPzux6czqtmK7ahVWG
         is/Xct8Aiz8uTA9EObwe+vSAvkjSozah8Wux3gFdTGHyDjEXFhPcbC3JCh5M3wwWzs9s
         tdYjfX6YL5Namn/g6d73AAfyzol/497d77IPMwfmLjYYt5PA5Hmud9VrkAJYDvpigT8j
         JVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=23BPNjrd0NijNQ6rAC62AycGy9QnxzEit89UTG1+TO4=;
        b=n2aCWePis2DRcxLSMg+MlARVEfKGfIr2Sa1HOWw/eZSpco41lPvYkNzp+1buVGHpgM
         x7PIZPoKtdDLdsIKp7eNTyUZrhrRmA8x1+4R+l8rOJgNRpo/7Ads0espObitS89sUqaF
         Kh+8KRdkSWf4W3w/vo7hAr10/IueojjMeTFGBLS+mMnceJPBRo2y7Ri2shv6okB5Q2v6
         JS4CS3tHWKQCjGjxbNGYSlCnChjD8As8wrO2vjxgHgvp1nlnR2ImX/umjr1rwtWDJPEl
         w5KT4oTItw5nolqtcd8co/fZ0lBq7jlQcyobgShyVcbo5Pji8BJXPkx+ZcxE7S3mWnTO
         EFlA==
X-Gm-Message-State: AOAM530Lc/kTlXzddnVKP8bdopaO89UPnTMPvGoY3U/72NHkNgF7ACCj
        +1s5JNMXW2/Ac9Woa4hb30Xp/zRcsHTtGg==
X-Google-Smtp-Source: ABdhPJwFB/X2LJ/a0EqZws7lKf86tDdCbJs40wOsTSwarIGSPPqy7wjiidUAIWgjqTVvHu0TWW8HfAj8SZrdSA==
X-Received: by 2002:a25:ce01:: with SMTP id x1mr4170286ybe.241.1590072084890;
 Thu, 21 May 2020 07:41:24 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:45 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-8-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 07/22] l2tp: remove l2tp_session_find()
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

commit 55a3ce3b9d98f752df9e2cfb1cba7e715522428a uptream.

This function isn't used anymore.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_core.c | 51 +-------------------------------------------
 net/l2tp/l2tp_core.h |  3 ---
 2 files changed, 1 insertion(+), 53 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7c3da29fad8e..440065462a69 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -216,27 +216,6 @@ static void l2tp_tunnel_sock_put(struct sock *sk)
 	sock_put(sk);
 }
 
-/* Lookup a session by id in the global session list
- */
-static struct l2tp_session *l2tp_session_find_2(struct net *net, u32 session_id)
-{
-	struct l2tp_net *pn = l2tp_pernet(net);
-	struct hlist_head *session_list =
-		l2tp_session_id_hash_2(pn, session_id);
-	struct l2tp_session *session;
-
-	rcu_read_lock_bh();
-	hlist_for_each_entry_rcu(session, session_list, global_hlist) {
-		if (session->session_id == session_id) {
-			rcu_read_unlock_bh();
-			return session;
-		}
-	}
-	rcu_read_unlock_bh();
-
-	return NULL;
-}
-
 /* Session hash list.
  * The session_id SHOULD be random according to RFC2661, but several
  * L2TP implementations (Cisco and Microsoft) use incrementing
@@ -249,35 +228,7 @@ l2tp_session_id_hash(struct l2tp_tunnel *tunnel, u32 session_id)
 	return &tunnel->session_hlist[hash_32(session_id, L2TP_HASH_BITS)];
 }
 
-/* Lookup a session by id
- */
-struct l2tp_session *l2tp_session_find(struct net *net, struct l2tp_tunnel *tunnel, u32 session_id)
-{
-	struct hlist_head *session_list;
-	struct l2tp_session *session;
-
-	/* In L2TPv3, session_ids are unique over all tunnels and we
-	 * sometimes need to look them up before we know the
-	 * tunnel.
-	 */
-	if (tunnel == NULL)
-		return l2tp_session_find_2(net, session_id);
-
-	session_list = l2tp_session_id_hash(tunnel, session_id);
-	read_lock_bh(&tunnel->hlist_lock);
-	hlist_for_each_entry(session, session_list, hlist) {
-		if (session->session_id == session_id) {
-			read_unlock_bh(&tunnel->hlist_lock);
-			return session;
-		}
-	}
-	read_unlock_bh(&tunnel->hlist_lock);
-
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(l2tp_session_find);
-
-/* Like l2tp_session_find() but takes a reference on the returned session.
+/* Lookup a session. A new reference is held on the returned session.
  * Optionally calls session->ref() too if do_ref is true.
  */
 struct l2tp_session *l2tp_session_get(struct net *net,
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 092698a8f74b..e38db6a807f5 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -234,9 +234,6 @@ static inline struct l2tp_tunnel *l2tp_sock_to_tunnel(struct sock *sk)
 struct l2tp_session *l2tp_session_get(struct net *net,
 				      struct l2tp_tunnel *tunnel,
 				      u32 session_id, bool do_ref);
-struct l2tp_session *l2tp_session_find(struct net *net,
-				       struct l2tp_tunnel *tunnel,
-				       u32 session_id);
 struct l2tp_session *l2tp_session_get_nth(struct l2tp_tunnel *tunnel, int nth,
 					  bool do_ref);
 struct l2tp_session *l2tp_session_get_by_ifname(struct net *net, char *ifname,
-- 
2.26.2.761.g0e0b3e54be-goog

