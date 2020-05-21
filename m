Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F351DDB28
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbgEUXkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgEUXkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:40:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3205C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:04 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 207so7266527ybl.2
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fHM87A8cPmXp8J3W/6Emhjx8aJh4qVxvMgnyUKUNC+I=;
        b=N+2cXT7u9+YN/XTgVYQVHXIxGPBIb+bFzrF75dbtNfCS9r2VDFGWX5kQVCohosDuf/
         0AOlDyhfGljLynFyiNJ/4G2e+ltX97+GYT65j5HP7zJQ3TX8T4Zb4kyoXwNWxuEwGw2K
         iuVUGb3om40kZJ/A/2p1ZeeQ11btrGEr7YcAGQqnEHIqw3NIkqhgH5Tiy2UqXwqoP5mt
         9gwtph0JvLzKMdy+WPEaTQvkTpBUnV/2KJt8oWbSybI69CHBt/dHrtzfVkhnM4IhDSnU
         CPpbX/2+r5N7gzEwtZ8UvriiSuSSyYTxDGLw4g+YrzO+ex/BGv6R4CMuK7tuxwBP6dec
         VNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fHM87A8cPmXp8J3W/6Emhjx8aJh4qVxvMgnyUKUNC+I=;
        b=WY83SyDrf3n1LCnF0OIhES0en9NQvjDiPGg/3jNT2xCpEmBuAwsS1L5PC1/Y1+4i/l
         7eBSs3sFGflWo3dDDnpD10B5wxPOLhnkXarRMexXBnnkBRXXKY841fe7nenh7z9UXL7Z
         2+izpPS4g8zUfL44MyT1/yWrbS+RjYyn/uDOhCadgC4/lq1gbiIYtUpW428kHfmvwcY8
         wPEB0J8vWOY5jIZOewVSzqpeeQWbs1ZxbEBPjV0w+dr+Jo92DnkcfvmNJbWxKtHauj6X
         cLsQgofhHrQwX36aHb5XH2qBA5OQyR3N4lTIdrCoeTHWlHN2DZwnvQPnQXNURUXVBZPf
         1/Lw==
X-Gm-Message-State: AOAM5338w3IbP3dP23bY9xeJf5m3NG4Wz5juHR+7gqOvl05cOCY4OqjJ
        811zTcFIctKLV82uiOzcg6NRtQY1b+mVhQ==
X-Google-Smtp-Source: ABdhPJzXiX1anOJPA/+ST814tkrQOTWM6/U5JOENjCi8WXMmkGSExwtrGMQSS1cM/3RcRDdvN6M1zlpbTo3OHQ==
X-Received: by 2002:a25:8391:: with SMTP id t17mr8073292ybk.516.1590104403972;
 Thu, 21 May 2020 16:40:03 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:24 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-10-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 09/22] l2tp: define parameters of l2tp_tunnel_find*() as "const"
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

commit 2f858b928bf5a8174911aaec76b8b72a9ca0533d upstream.

l2tp_tunnel_find() and l2tp_tunnel_find_nth() don't modify "net".

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_core.c | 4 ++--
 net/l2tp/l2tp_core.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index be8d7b2b8790..a9d4d42e2ef6 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -378,7 +378,7 @@ static int l2tp_session_add_to_tunnel(struct l2tp_tunnel *tunnel,
 
 /* Lookup a tunnel by id
  */
-struct l2tp_tunnel *l2tp_tunnel_find(struct net *net, u32 tunnel_id)
+struct l2tp_tunnel *l2tp_tunnel_find(const struct net *net, u32 tunnel_id)
 {
 	struct l2tp_tunnel *tunnel;
 	struct l2tp_net *pn = l2tp_pernet(net);
@@ -396,7 +396,7 @@ struct l2tp_tunnel *l2tp_tunnel_find(struct net *net, u32 tunnel_id)
 }
 EXPORT_SYMBOL_GPL(l2tp_tunnel_find);
 
-struct l2tp_tunnel *l2tp_tunnel_find_nth(struct net *net, int nth)
+struct l2tp_tunnel *l2tp_tunnel_find_nth(const struct net *net, int nth)
 {
 	struct l2tp_net *pn = l2tp_pernet(net);
 	struct l2tp_tunnel *tunnel;
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 3a3d96df6071..2f9a09097e30 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -239,8 +239,8 @@ struct l2tp_session *l2tp_session_get_nth(struct l2tp_tunnel *tunnel, int nth,
 struct l2tp_session *l2tp_session_get_by_ifname(const struct net *net,
 						const char *ifname,
 						bool do_ref);
-struct l2tp_tunnel *l2tp_tunnel_find(struct net *net, u32 tunnel_id);
-struct l2tp_tunnel *l2tp_tunnel_find_nth(struct net *net, int nth);
+struct l2tp_tunnel *l2tp_tunnel_find(const struct net *net, u32 tunnel_id);
+struct l2tp_tunnel *l2tp_tunnel_find_nth(const struct net *net, int nth);
 
 int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id,
 		       u32 peer_tunnel_id, struct l2tp_tunnel_cfg *cfg,
-- 
2.27.0.rc0.183.gde8f92d652-goog

