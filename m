Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8A91DDB70
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgEUX6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:20 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13887C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:19 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id z5so9655364qtz.16
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lKuPBwGi2VcIAk+NIcy/+cQ4pCWW3nRg7fiWTop1he8=;
        b=jvkAj2Ngg4iSrbc7aIQ0ah+1iS39D3KkwNbZFqPeYF+L4d7Yy4JKqpI17sDKwQoxWJ
         inlDb+/u3aOV0zZF6TGRlXn6YVXR2Nx+9dGiGFmCbAwCnyAT8aO4E1ceP61fJBZVq/yj
         zASmTZ9zlzqsa2uKcfOdzVwBZfHztSPLqT6txFuiac7HuFyT++UBoenvY750Ln+aAyGU
         begauNmI2e8NphapCK3o4P7fEUu7/ycpH+VzH1EC6Hb2B10G0RDm2tzFJxv7Dopo/SDt
         iaZ/uJ1hs4747cID6/dhtosqJDE/APUmXoT58UhmFFs1pN29Ymw42aWh00M78ktevyVs
         vwyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lKuPBwGi2VcIAk+NIcy/+cQ4pCWW3nRg7fiWTop1he8=;
        b=iStzfHfzwghAR+la4IgnXw3Q5kE+JOh3XqF3sShHu+MnDCai4sOLUCt7dYHW2LwtIQ
         qz4JpGhAnt4dnGDn0yvXFTSOJeQ4sfeEXrT/aoXTgydZ+ozpnSqL6tp83+ts+aBeVuGv
         jwzJn73tLz7kPTuJvINXSvskS9CE9tggWPNFZBN8nsCswRjUPS6sGr+B9/caPkCf1GHC
         g+rs6d8QMD43knq/fsCbYF5AsqqlKmQvsoW3YnjyoDjGmttfpVAo0OCFN3Ju0q/jBYMa
         kmNHf4TqlUZVtlOhOWNkbl6Vx97Pdf7FFogRtGsFTnXJeuNTnbeJQvyg5r8DwzEkXdrD
         C71g==
X-Gm-Message-State: AOAM531/bDU/PhC8t8xtwRRMr6RKxAvlGkl1Arbh0xgsfa0r18SJyvd9
        EHbJiLW81/zK45h8N2UGoYJ1lRu1QrU2Ag==
X-Google-Smtp-Source: ABdhPJzJXmS01I8bAPEnwTckiojkHiYyEoLns3JLfu612VE/ZeJSJcFyCzKH/gqZaEBcAuEljQCRW3TWY7YD+w==
X-Received: by 2002:a05:6214:14a2:: with SMTP id bo2mr1289676qvb.106.1590105498245;
 Thu, 21 May 2020 16:58:18 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:25 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-13-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 12/27] l2tp: remove l2tp_session_find()
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

commit 55a3ce3b9d98f752df9e2cfb1cba7e715522428a upstream.

This function isn't used anymore.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_core.c | 51 +-------------------------------------------
 net/l2tp/l2tp_core.h |  3 ---
 2 files changed, 1 insertion(+), 53 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 08377af93552..95fa01b4edc6 100644
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
index 2469f63649bb..7dc70f73a083 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -237,9 +237,6 @@ out:
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
2.27.0.rc0.183.gde8f92d652-goog

