Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267541DD045
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbgEUOl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729670AbgEUOl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:27 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AE2C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:27 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s8so5467503ybj.9
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5/3n9EeQqKQR1sIRKV8GdJgPuOtEOEdrjmgfEB5mlJ0=;
        b=qLim/uZJQtT3MkGYB7mVBbKI2+M49HWb4YPOw83xpHJsAsWe12Sn+cqg0KhBCcnctz
         Yn/mRPXEqKgFSDfcD1Y5zbDtRGvd0i5XiGiKTsYN4ICRr4KzuNMNkm2rMZvxW1VM6e48
         inJCDKetMmAYQU/lqI8rcf08BdLI1ROSacN/KNpJ9p16PIiuqKjpWI1gyuNsX7BXrrAf
         DdQvqDwbRhX7w3gzAyqam9yCwMSLyR+xxBtgcOJev0MrXUcLxFFuiANv3vOqDS8mTJuu
         ibA17rzzWD0xN/MYokD1wf04IMUpBu7sFNqxnp/lqcKHolMflFHc5pqo/NSHQciLuD8Z
         +DJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5/3n9EeQqKQR1sIRKV8GdJgPuOtEOEdrjmgfEB5mlJ0=;
        b=AJ3A3dkpOWoIDONkKs2ujHEKEOFP4XgIwmdWyjUQU/N5nO1XuKF8Li2kT4jKB3tK2t
         dVMH+/TPVmeQHCgx+dlLtSHR4yS+WYuNxI4QnEI4H/aC22LKpffYrrKceETkQnYixqZL
         45J1WjcmMsIMHZYsHX2pGNdZht2ATeC9k/E7uYKPMwMbe3+kzh4PBNdZffBVyagivPRJ
         1A9xWQgT45uBsh6i/Rup2eGfKJXm4vHdu0wggLuUvQhKLmguvQWa7uIxdWI5oiAGHTmz
         PaL2Xy54Urpvhb7e4cWL0oJ5N/raFi4Pld4+nZd/5p0cWmG86XEOATLn+ZZ5NGdDr0rb
         Uwcw==
X-Gm-Message-State: AOAM532UHvnjXEbcJ5wmiRbHAOJwop3EGEX2vIWE+wC46JmO+/jzYNmk
        +Ivg1EKdcUuFwW4DoiVdXQyVTP2vHIwwaw==
X-Google-Smtp-Source: ABdhPJzZbSD2C8ldazEQoozm1my3rC9s8VXWGw3O1C+FWinidiqlRUv/tCXtSXdbe2vhp5LutJBfpFU+2AD6Jg==
X-Received: by 2002:a25:8b83:: with SMTP id j3mr15062633ybl.450.1590072086952;
 Thu, 21 May 2020 07:41:26 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:46 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-9-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 08/22] l2tp: define parameters of l2tp_session_get*() as "const"
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

commit 9aaef50c44f132e040dcd7686c8e78a3390037c5 uptream.

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
2.26.2.761.g0e0b3e54be-goog

