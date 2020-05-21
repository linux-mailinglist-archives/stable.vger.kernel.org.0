Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A161DDB6C
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbgEUX6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:11 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60047C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:10 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s8so7185620ybj.9
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=mFxUx7q186WrkWZuC/chJI4Cpzw3Q8QkSLDG6dh37bQ=;
        b=pr35M/0WVSJHwDbPTHIetAyVjNsgs04CH7WXkrRiKtEbjmlc8EvvNwm+b1TpFtnNwG
         ncokimhSDFbwEPOxSavx1Ykh/m3a77n3yvrQZQNQJcV0ShIADAwIP7R4ZtGzaUJMUMMd
         reTyy3ENNRGDvVK+glrosm+qC6GDI8kvOnrLCRiDb8iZIZu4JgYtBweo0cZyaO1cGsjz
         JTTR3EP4oKGFUCYEkuA50lgwMuCQNU4MQ/9NStUPZcIjMQEg2+VdoNGUiMUhtr3+dXBW
         DPdtKry3is6x1KWMYGLjF8hHL7kcvO500TVFg9qMSiVuE0vne0AhFKeD5uKcJo/q7Sdk
         lVJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=mFxUx7q186WrkWZuC/chJI4Cpzw3Q8QkSLDG6dh37bQ=;
        b=Ls6971h50ggoPuPErtAlCXyYQ0j7LFDgvdtJtpiYMY3gEuP6IjMUCf1+KoEsLtg/H+
         nW8U9iEqLeCr+Vjpzq5NqbNurCYKab32Z3Flotm0cdpUl0RdS3yVKU7EVRT/YYB/MJAH
         FYTLLiKfeuxz4JRHmNHIA7GHg9IdDPJNLAzEekVp3h4nnuLhDFDMc/IRCqx/jtSZDCPF
         1qzTpDIGg00wRPeDK+4G27TYu6ph9HuD4d1zioKQc/yyELWceSUCVdsnLXzycyItTvVR
         Pnjf/snpYsJGWPyeiVqE+SUjk7JbXrtE3s6a5nVSLWMQT8h0jU1uh6wAmYSxqmSyUBc9
         mE4A==
X-Gm-Message-State: AOAM530KezG6iLKvzs8IjELYoPeklw3+5pmza9vPYQCLddl9A6a4njkP
        SMSlxYgIzzJOjh6WsI2ksSyrilhjgfA7gQ==
X-Google-Smtp-Source: ABdhPJxBP5Gb7EgTmK1zUtlaWhAVIJAUBwM16MKPzdNmdyJA9yHthw9o7wW3G7ZCHuPh37wg2EdpgiUeQpJ0tQ==
X-Received: by 2002:a25:80c3:: with SMTP id c3mr21385931ybm.33.1590105489617;
 Thu, 21 May 2020 16:58:09 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:21 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-9-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 08/27] net: l2tp: ppp: change PPPOL2TP_MSG_* => L2TP_MSG_*
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
index bc5d6b8f8ede..5738456b3b58 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -230,7 +230,7 @@ static void pppol2tp_recv(struct l2tp_session *session,=
 struct sk_buff *skb, int
=20
 	if (sk->sk_state & PPPOX_BOUND) {
 		struct pppox_sock *po;
-		l2tp_dbg(session, PPPOL2TP_MSG_DATA,
+		l2tp_dbg(session, L2TP_MSG_DATA,
 			 "%s: recv %d byte data frame, passing to ppp\n",
 			 session->name, data_len);
=20
@@ -253,7 +253,7 @@ static void pppol2tp_recv(struct l2tp_session *session,=
 struct sk_buff *skb, int
 		po =3D pppox_sk(sk);
 		ppp_input(&po->chan, skb);
 	} else {
-		l2tp_dbg(session, PPPOL2TP_MSG_DATA,
+		l2tp_dbg(session, L2TP_MSG_DATA,
 			 "%s: recv %d byte data frame, passing to L2TP socket\n",
 			 session->name, data_len);
=20
@@ -266,7 +266,7 @@ static void pppol2tp_recv(struct l2tp_session *session,=
 struct sk_buff *skb, int
 	return;
=20
 no_sock:
-	l2tp_info(session, PPPOL2TP_MSG_DATA, "%s: no socket\n", session->name);
+	l2tp_info(session, L2TP_MSG_DATA, "%s: no socket\n", session->name);
 	kfree_skb(skb);
 }
=20
@@ -797,7 +797,7 @@ out_no_ppp:
 	/* This is how we get the session context from the socket. */
 	sk->sk_user_data =3D session;
 	sk->sk_state =3D PPPOX_CONNECTED;
-	l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: created\n",
+	l2tp_info(session, L2TP_MSG_CONTROL, "%s: created\n",
 		  session->name);
=20
 end:
@@ -848,7 +848,7 @@ static int pppol2tp_session_create(struct net *net, u32=
 tunnel_id, u32 session_i
 	ps =3D l2tp_session_priv(session);
 	ps->tunnel_sock =3D tunnel->sock;
=20
-	l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: created\n",
+	l2tp_info(session, L2TP_MSG_CONTROL, "%s: created\n",
 		  session->name);
=20
 	error =3D 0;
@@ -1010,7 +1010,7 @@ static int pppol2tp_session_ioctl(struct l2tp_session=
 *session,
 	struct l2tp_tunnel *tunnel =3D session->tunnel;
 	struct pppol2tp_ioc_stats stats;
=20
-	l2tp_dbg(session, PPPOL2TP_MSG_CONTROL,
+	l2tp_dbg(session, L2TP_MSG_CONTROL,
 		 "%s: pppol2tp_session_ioctl(cmd=3D%#x, arg=3D%#lx)\n",
 		 session->name, cmd, arg);
=20
@@ -1033,7 +1033,7 @@ static int pppol2tp_session_ioctl(struct l2tp_session=
 *session,
 		if (copy_to_user((void __user *) arg, &ifr, sizeof(struct ifreq)))
 			break;
=20
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: get mtu=3D%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: get mtu=3D%d\n",
 			  session->name, session->mtu);
 		err =3D 0;
 		break;
@@ -1049,7 +1049,7 @@ static int pppol2tp_session_ioctl(struct l2tp_session=
 *session,
=20
 		session->mtu =3D ifr.ifr_mtu;
=20
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: set mtu=3D%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: set mtu=3D%d\n",
 			  session->name, session->mtu);
 		err =3D 0;
 		break;
@@ -1063,7 +1063,7 @@ static int pppol2tp_session_ioctl(struct l2tp_session=
 *session,
 		if (put_user(session->mru, (int __user *) arg))
 			break;
=20
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: get mru=3D%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: get mru=3D%d\n",
 			  session->name, session->mru);
 		err =3D 0;
 		break;
@@ -1078,7 +1078,7 @@ static int pppol2tp_session_ioctl(struct l2tp_session=
 *session,
 			break;
=20
 		session->mru =3D val;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: set mru=3D%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: set mru=3D%d\n",
 			  session->name, session->mru);
 		err =3D 0;
 		break;
@@ -1088,7 +1088,7 @@ static int pppol2tp_session_ioctl(struct l2tp_session=
 *session,
 		if (put_user(ps->flags, (int __user *) arg))
 			break;
=20
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: get flags=3D%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: get flags=3D%d\n",
 			  session->name, ps->flags);
 		err =3D 0;
 		break;
@@ -1098,7 +1098,7 @@ static int pppol2tp_session_ioctl(struct l2tp_session=
 *session,
 		if (get_user(val, (int __user *) arg))
 			break;
 		ps->flags =3D val;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: set flags=3D%d\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: set flags=3D%d\n",
 			  session->name, ps->flags);
 		err =3D 0;
 		break;
@@ -1115,7 +1115,7 @@ static int pppol2tp_session_ioctl(struct l2tp_session=
 *session,
 		if (copy_to_user((void __user *) arg, &stats,
 				 sizeof(stats)))
 			break;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL, "%s: get L2TP stats\n",
+		l2tp_info(session, L2TP_MSG_CONTROL, "%s: get L2TP stats\n",
 			  session->name);
 		err =3D 0;
 		break;
@@ -1143,7 +1143,7 @@ static int pppol2tp_tunnel_ioctl(struct l2tp_tunnel *=
tunnel,
 	struct sock *sk;
 	struct pppol2tp_ioc_stats stats;
=20
-	l2tp_dbg(tunnel, PPPOL2TP_MSG_CONTROL,
+	l2tp_dbg(tunnel, L2TP_MSG_CONTROL,
 		 "%s: pppol2tp_tunnel_ioctl(cmd=3D%#x, arg=3D%#lx)\n",
 		 tunnel->name, cmd, arg);
=20
@@ -1186,7 +1186,7 @@ static int pppol2tp_tunnel_ioctl(struct l2tp_tunnel *=
tunnel,
 			err =3D -EFAULT;
 			break;
 		}
-		l2tp_info(tunnel, PPPOL2TP_MSG_CONTROL, "%s: get L2TP stats\n",
+		l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: get L2TP stats\n",
 			  tunnel->name);
 		err =3D 0;
 		break;
@@ -1276,7 +1276,7 @@ static int pppol2tp_tunnel_setsockopt(struct sock *sk=
,
 	switch (optname) {
 	case PPPOL2TP_SO_DEBUG:
 		tunnel->debug =3D val;
-		l2tp_info(tunnel, PPPOL2TP_MSG_CONTROL, "%s: set debug=3D%x\n",
+		l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: set debug=3D%x\n",
 			  tunnel->name, tunnel->debug);
 		break;
=20
@@ -1304,7 +1304,7 @@ static int pppol2tp_session_setsockopt(struct sock *s=
k,
 			break;
 		}
 		session->recv_seq =3D val ? -1 : 0;
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: set recv_seq=3D%d\n",
 			  session->name, session->recv_seq);
 		break;
@@ -1322,7 +1322,7 @@ static int pppol2tp_session_setsockopt(struct sock *s=
k,
 				PPPOL2TP_L2TP_HDR_SIZE_NOSEQ;
 		}
 		l2tp_session_set_header_len(session, session->tunnel->version);
-		l2tp_info(session, PPPOL2TP_MSG_CONTROL,
+		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: set send_seq=3D%d\n",
 			  session->name, session->send_seq);
 		break;
@@ -1333,20 +1333,20 @@ static int pppol2tp_session_setsockopt(struct sock =
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
@@ -1427,7 +1427,7 @@ static int pppol2tp_tunnel_getsockopt(struct sock *sk=
,
 	switch (optname) {
 	case PPPOL2TP_SO_DEBUG:
 		*val =3D tunnel->debug;
-		l2tp_info(tunnel, PPPOL2TP_MSG_CONTROL, "%s: get debug=3D%x\n",
+		l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: get debug=3D%x\n",
 			  tunnel->name, tunnel->debug);
 		break;
=20
@@ -1450,31 +1450,31 @@ static int pppol2tp_session_getsockopt(struct sock =
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

