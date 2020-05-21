Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C441DDB22
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgEUXjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgEUXjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:39:52 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53DFC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:39:51 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id a14so9654036qto.6
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=51IoQhDTW38O4lLs5NvklB3zEWvBmDNqEyUW/HUKE2E=;
        b=cIrElcSjpJoi4siOgZbXXfHusAZjQjbJrf1u8hHID7P8fS1QItnAgG4kgeZyQyxxez
         ZhRCEOzEqSqAB4SWlCEJIocBMR1d+oB3BHkXiikPlFjWvZLuP2JfoK/Bjp9z92sKNH+b
         0eWG7Ho6I2Xi6Z1tHxji0lx4SjY/P43gdVj0T2T/bjrKD4ULd7kmd1jPbF/B2bTihL37
         EgXp34tu05mV/2XqpKzzaSpi2lbt/Z/DW2Cqh5Y/8kGaH52LF+McvS8FkFb9P4SrExyY
         hqJMbY4oCbuISPOaKo65zUePmusR7dBeXEzueB5F1xpR5W1lmCN/IReDRDLkeDiJAD/X
         DqqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=51IoQhDTW38O4lLs5NvklB3zEWvBmDNqEyUW/HUKE2E=;
        b=s24NX0v6sp3Xatw06o354JWt5GVPh1iQnIWN8PnVr5Qb2k1xEij7TWi+Rmc5mgm/Vv
         xdbBa4HY1oBpPx7Q3eUvPxnuNMx28tIvvqsZXZn2M666IZESJkGkP2t6bU5EzmN0bRyK
         1JQRKlp2NCnwXxwspuETrwXMKdPn8eDM54eIK8ILO4zdgaItBGuIwzf0eSzIifup+5XI
         jNFCCw1HWwuKAQpPonGd0cNYBMlGmeH8JxfT/TdMylz1wlTcktoX+MM0WclGk9Ild7Jr
         DfOeg3GR1JOAYUAkdYYwrxuYwalhc9OpsUlvG2Pmosm5pygY3IqB+EowEARrTBKwMpfN
         Oyaw==
X-Gm-Message-State: AOAM530TgqmiyAmdymeyMGS/xSLCtyZp7K7bpW+hH7qCSVG0tSbY5WYb
        mJ5foNawAJ6sgYj7oJaUEi2tX1uOWzFWQw==
X-Google-Smtp-Source: ABdhPJziWmVuG8Ifbi0m/c2rLmRqNnYKesC90dhL7I7S3wq4wEu2wa54tjjUOZugP0KApzoHe2WRlzcBjrpSUA==
X-Received: by 2002:a05:6214:ca:: with SMTP id f10mr1218480qvs.185.1590104391151;
 Thu, 21 May 2020 16:39:51 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:18 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-4-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 03/22] net: l2tp: ppp: change PPPOL2TP_MSG_* => L2TP_MSG_*
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org,
        "=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?=" 
        <asbjorn@asbjorn.st>, "David S . Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Asbj=C3=B8rn Sloth T=C3=B8nnesen <asbjorn@asbjorn.st>

commit fba40c632c6473fa89660e870a6042c0fe733f8c upstream.

Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.st>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_ppp.c | 54 ++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index d919b3e6b548..809606f2d54a 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -231,14 +231,14 @@ static void pppol2tp_recv(struct l2tp_session *sessio=
n, struct sk_buff *skb, int
 	if (sk->sk_state & PPPOX_BOUND) {
 		struct pppox_sock *po;
=20
-		l2tp_dbg(session, PPPOL2TP_MSG_DATA,
+		l2tp_dbg(session, L2TP_MSG_DATA,
 			 "%s: recv %d byte data frame, passing to ppp\n",
 			 session->name, data_len);
=20
 		po =3D pppox_sk(sk);
 		ppp_input(&po->chan, skb);
 	} else {
-		l2tp_dbg(session, PPPOL2TP_MSG_DATA,
+		l2tp_dbg(session, L2TP_MSG_DATA,
 			 "%s: recv %d byte data frame, passing to L2TP socket\n",
 			 session->name, data_len);
=20
@@ -251,7 +251,7 @@ static void pppol2tp_recv(struct l2tp_session *session,=
 struct sk_buff *skb, int
 	return;
=20
 no_sock:
-	l2tp_info(session, PPPOL2TP_MSG_DATA, "%s: no socket\n", session->name);
+	l2tp_info(session, L2TP_MSG_DATA, "%s: no socket\n", session->name);
 	kfree_skb(skb);
 }
=20
@@ -782,7 +782,7 @@ static int pppol2tp_connect(struct socket *sock, struct=
 sockaddr *uservaddr,
 	/* This is how we get the session context from the socket. */
 	sk->sk_user_data =3D session;
 	sk->sk_state =3D PPPOX_CONNECTED;
-	l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: created\n",
+	l2tp_info(session, L2TP_MSG_CONTROL, "%s: created\n",
 		  session->name);
=20
 end:
@@ -833,7 +833,7 @@ static int pppol2tp_session_create(struct net *net, u32=
 tunnel_id, u32 session_i
 	ps =3D l2tp_session_priv(session);
 	ps->tunnel_sock =3D tunnel->sock;
=20
-	l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: created\n",
+	l2tp_info(session, L2TP_MSG_CONTROL, "%s: created\n",
 		  session->name);
=20
 	error =3D 0;
@@ -995,7 +995,7 @@ static int pppol2tp_session_ioctl(struct l2tp_session *=
session,
 	struct l2tp_tunnel *tunnel =3D session->tunnel;
 	struct pppol2tp_ioc_stats stats;
=20
-	l2tp_dbg(session, PPPOL2TP_MSG_CONTROL,
+	l2tp_dbg(session, L2TP_MSG_CONTROL,
 		 "%s: pppol2tp_session_ioctl(cmd=3D%#x, arg=3D%#lx)\n",
 		 session->name, cmd, arg);
=20
@@ -1018,7 +1018,7 @@ static int pppol2tp_session_ioctl(struct l2tp_session=
 *session,
 		if (copy_to_user((void __user *) arg, &ifr, sizeof(struct ifreq)))
 			break;
=20
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: get mtu=3D%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: get mtu=3D%d\n",
 			  session->name, session->mtu);
 		err =3D 0;
 		break;
@@ -1034,7 +1034,7 @@ static int pppol2tp_session_ioctl(struct l2tp_session=
 *session,
=20
 		session->mtu =3D ifr.ifr_mtu;
=20
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: set mtu=3D%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: set mtu=3D%d\n",
 			  session->name, session->mtu);
 		err =3D 0;
 		break;
@@ -1048,7 +1048,7 @@ static int pppol2tp_session_ioctl(struct l2tp_session=
 *session,
 		if (put_user(session->mru, (int __user *) arg))
 			break;
=20
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: get mru=3D%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: get mru=3D%d\n",
 			  session->name, session->mru);
 		err =3D 0;
 		break;
@@ -1063,7 +1063,7 @@ static int pppol2tp_session_ioctl(struct l2tp_session=
 *session,
 			break;
=20
 		session->mru =3D val;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: set mru=3D%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: set mru=3D%d\n",
 			  session->name, session->mru);
 		err =3D 0;
 		break;
@@ -1073,7 +1073,7 @@ static int pppol2tp_session_ioctl(struct l2tp_session=
 *session,
 		if (put_user(ps->flags, (int __user *) arg))
 			break;
=20
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: get flags=3D%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: get flags=3D%d\n",
 			  session->name, ps->flags);
 		err =3D 0;
 		break;
@@ -1083,7 +1083,7 @@ static int pppol2tp_session_ioctl(struct l2tp_session=
 *session,
 		if (get_user(val, (int __user *) arg))
 			break;
 		ps->flags =3D val;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: set flags=3D%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: set flags=3D%d\n",
 			  session->name, ps->flags);
 		err =3D 0;
 		break;
@@ -1100,7 +1100,7 @@ static int pppol2tp_session_ioctl(struct l2tp_session=
 *session,
 		if (copy_to_user((void __user *) arg, &stats,
 				 sizeof(stats)))
 			break;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: get L2TP stats\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: get L2TP stats\n",
 			  session->name);
 		err =3D 0;
 		break;
@@ -1128,7 +1128,7 @@ static int pppol2tp_tunnel_ioctl(struct l2tp_tunnel *=
tunnel,
 	struct sock *sk;
 	struct pppol2tp_ioc_stats stats;
=20
-	l2tp_dbg(tunnel, PPPOL2TP_MSG_CONTROL,
+	l2tp_dbg(tunnel, L2TP_MSG_CONTROL,
 		 "%s: pppol2tp_tunnel_ioctl(cmd=3D%#x, arg=3D%#lx)\n",
 		 tunnel->name, cmd, arg);
=20
@@ -1171,7 +1171,7 @@ static int pppol2tp_tunnel_ioctl(struct l2tp_tunnel *=
tunnel,
 			err =3D -EFAULT;
 			break;
 		}
-		l2tp_info(tunnel, PPPOL2TP_MSG_CONTROL, "%s: get L2TP stats\n",
+		l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: get L2TP stats\n",
 			  tunnel->name);
 		err =3D 0;
 		break;
@@ -1261,7 +1261,7 @@ static int pppol2tp_tunnel_setsockopt(struct sock *sk=
,
 	switch (optname) {
 	case PPPOL2TP_SO_DEBUG:
 		tunnel->debug =3D val;
-		l2tp_info(tunnel, PPPOL2TP_MSG_CONTROL, "%s: set debug=3D%x\n",
+		l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: set debug=3D%x\n",
 			  tunnel->name, tunnel->debug);
 		break;
=20
@@ -1289,7 +1289,7 @@ static int pppol2tp_session_setsockopt(struct sock *s=
k,
 			break;
 		}
 		session->recv_seq =3D val ? -1 : 0;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: set recv_seq=3D%d\n",
 			  session->name, session->recv_seq);
 		break;
@@ -1307,7 +1307,7 @@ static int pppol2tp_session_setsockopt(struct sock *s=
k,
 				PPPOL2TP_L2TP_HDR_SIZE_NOSEQ;
 		}
 		l2tp_session_set_header_len(session, session->tunnel->version);
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: set send_seq=3D%d\n",
 			  session->name, session->send_seq);
 		break;
@@ -1318,20 +1318,20 @@ static int pppol2tp_session_setsockopt(struct sock =
*sk,
 			break;
 		}
 		session->lns_mode =3D val ? -1 : 0;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: set lns_mode=3D%d\n",
 			  session->name, session->lns_mode);
 		break;
=20
 	case PPPOL2TP_SO_DEBUG:
 		session->debug =3D val;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: set debug=3D%x\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: set debug=3D%x\n",
 			  session->name, session->debug);
 		break;
=20
 	case PPPOL2TP_SO_REORDERTO:
 		session->reorder_timeout =3D msecs_to_jiffies(val);
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: set reorder_timeout=3D%d\n",
 			  session->name, session->reorder_timeout);
 		break;
@@ -1412,7 +1412,7 @@ static int pppol2tp_tunnel_getsockopt(struct sock *sk=
,
 	switch (optname) {
 	case PPPOL2TP_SO_DEBUG:
 		*val =3D tunnel->debug;
-		l2tp_info(tunnel, PPPOL2TP_MSG_CONTROL, "%s: get debug=3D%x\n",
+		l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: get debug=3D%x\n",
 			  tunnel->name, tunnel->debug);
 		break;
=20
@@ -1435,31 +1435,31 @@ static int pppol2tp_session_getsockopt(struct sock =
*sk,
 	switch (optname) {
 	case PPPOL2TP_SO_RECVSEQ:
 		*val =3D session->recv_seq;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: get recv_seq=3D%d\n", session->name, *val);
 		break;
=20
 	case PPPOL2TP_SO_SENDSEQ:
 		*val =3D session->send_seq;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: get send_seq=3D%d\n", session->name, *val);
 		break;
=20
 	case PPPOL2TP_SO_LNSMODE:
 		*val =3D session->lns_mode;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: get lns_mode=3D%d\n", session->name, *val);
 		break;
=20
 	case PPPOL2TP_SO_DEBUG:
 		*val =3D session->debug;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: get debug=3D%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: get debug=3D%d\n",
 			  session->name, *val);
 		break;
=20
 	case PPPOL2TP_SO_REORDERTO:
 		*val =3D (int) jiffies_to_msecs(session->reorder_timeout);
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: get reorder_timeout=3D%d\n", session->name, *val);
 		break;
=20
--=20
2.27.0.rc0.183.gde8f92d652-goog

