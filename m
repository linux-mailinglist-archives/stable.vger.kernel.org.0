Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAA11DD046
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbgEUOlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729670AbgEUOlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:31 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CD9C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:29 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id p5so2499523qkg.12
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zWZ14g3wmYf+0hGckUYMw4Jt5cJKxL9KuoFGcp3Ep2s=;
        b=vzVutMm9l6wBlOKxOv0tzPmXWCm5M8Z4jn2JkVMLPdWlNNuthpSx7Qgl+Y2kxRHiK6
         +MEhuzkPuQh793D+X6XBZ9HuJ5RD+MU9285E3sHxYMv3ht5k3vLZYKGO73XE4QQTlDxH
         dHfg7r+EX+Vi2u8jK49IcMxyxw5jsFVUacBlTsxy9D+8rKAKA2XFWs4UrPoy/NOsfjL8
         oRClURWRycWXDfAz3A+1HwCpgNJERqGjgWHAofQ9V8Yg96d5VT53W1mBJPAo9BKmOjQZ
         j3IxsdgrefapwXvA3dWcHaUGylIBNJKPbtaGM5G3O87XQ9/2+UPvtGLY1LNk9dCHPZMU
         hJEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zWZ14g3wmYf+0hGckUYMw4Jt5cJKxL9KuoFGcp3Ep2s=;
        b=jfEYXCB1OY4eImhfxjAJF3eV/FH6kMtk+NOa1wuYqw8iDW9QQFvzeDWorZWWnr6pix
         zHK/f3NnXiTHz3Kbrco3/kbVEsD1TMVonpX7Q15VrMJNUlRjng6Yum8do998df3Dqck4
         tlTfENdqcB33pe480PoL3sH9GrXiVrlKxDJBz0AqxCCd30FEwpHjLH5iTF0noXEIyqHv
         pF0z3UVO2px2rojDgRVWuQvP59yqgLC//5RvZG1e1udVsF48v9Ii8ZcKzYJSo4NGMTY+
         CWykXbLkUGogez/PVH0qVsUXd1YlFBelxvfSQTUk6twhyQgwOsKeRs9MP5k8vAf1JTj7
         HUwQ==
X-Gm-Message-State: AOAM533Lt8Ol0iQQXJURS4ZvYcFfuWzmqVczngNlnm3FLtQWK1/O+A4U
        QYV3ROcO8hXqE/RP/4uFMgPlDsR6TWZrTQ==
X-Google-Smtp-Source: ABdhPJz06Eoqc00G3vJx1Zsg8bgoHpo7EujWE6oBxfuXLeV2KHhA+LdBCJsHXMTmXa9W9pMxS8TKTcVhGGxMRw==
X-Received: by 2002:a05:6214:42f:: with SMTP id a15mr9975601qvy.170.1590072089034;
 Thu, 21 May 2020 07:41:29 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:47 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-10-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 09/22] l2tp: define parameters of l2tp_tunnel_find*() as "const"
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

commit 2f858b928bf5a8174911aaec76b8b72a9ca0533d uptream.

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
2.26.2.761.g0e0b3e54be-goog

