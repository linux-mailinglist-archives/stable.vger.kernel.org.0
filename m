Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CF92260C1
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 15:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgGTNXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 09:23:40 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:53021 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726030AbgGTNXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 09:23:39 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4F3CB1940A23;
        Mon, 20 Jul 2020 09:23:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 09:23:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=P1ZNcM
        GluMmSHEVAzvL4jUu1ZanH3YZJjgl6puIndh4=; b=CJDNYEuJ10f+zfnS/oiV5w
        NvTNg4OOPm0v1ClAgN32QvoXLTlTezRCb976p7mnXclmWZGBAXViUXzhsujnYCek
        cWj4i4Q3fpBGsr1AU8ZM/+t92IDzZAII9Mrw27H7iFTyRVdwONpxBI2u5SRxgP6d
        sTLG0Xd54oJw8aWDpSkujJgR6I/PWDTBzUwYQ4yaqeWV8lWVDVztFix9D/tf+sGy
        IgJFme+VITnE8q3spI/paLnoMfOR1MFi8ghiD/ZSB8wLxG/BMWeSIth95zZBy5GY
        6w2Fpk+MT+rf0goiivJLx3XbsstqmaPG+o1JF1dFXOUPXpm6juNHPxc39hMw2pjQ
        ==
X-ME-Sender: <xms:2poVX49t8ovb8rhIWN3lfma_cqBK94Ntgovnlw7NkyZdQH_ryq2Tgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2poVXws8ca6nJzGOb_XGSmKwyTNStyrZoFE8SOPeX2oK2-GrEbfs7g>
    <xmx:2poVX-DKrN1Nt00EM2vAY8hX0CZFFoj-YiTGdPseBEoof5AbVPJK6Q>
    <xmx:2poVX4cNOyxWrh1CL0eKLaRZfCHijEK1Ys7dhHVft9ZRsmw29eEfPA>
    <xmx:2poVX0bFPsN5Di5ybnEgz_Afmx4x3Aotr2JLghTHDmUlv-Kz4QF0HA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D27DD306005F;
        Mon, 20 Jul 2020 09:23:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bpf: sockmap: Require attach_bpf_fd when detaching a program" failed to apply to 5.4-stable tree
To:     lmb@cloudflare.com, ast@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 15:23:44 +0200
Message-ID: <1595251424136174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bb0de3131f4c60a9bf976681e0fe4d1e55c7a821 Mon Sep 17 00:00:00 2001
From: Lorenz Bauer <lmb@cloudflare.com>
Date: Mon, 29 Jun 2020 10:56:28 +0100
Subject: [PATCH] bpf: sockmap: Require attach_bpf_fd when detaching a program

The sockmap code currently ignores the value of attach_bpf_fd when
detaching a program. This is contrary to the usual behaviour of
checking that attach_bpf_fd represents the currently attached
program.

Ensure that attach_bpf_fd is indeed the currently attached
program. It turns out that all sockmap selftests already do this,
which indicates that this is unlikely to cause breakage.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200629095630.7933-5-lmb@cloudflare.com

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 07052d44bca1..9750a1902ee5 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1543,13 +1543,16 @@ static inline void bpf_map_offload_map_free(struct bpf_map *map)
 #endif /* CONFIG_NET && CONFIG_BPF_SYSCALL */
 
 #if defined(CONFIG_BPF_STREAM_PARSER)
-int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog, u32 which);
+int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
+			 struct bpf_prog *old, u32 which);
 int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog);
+int sock_map_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype);
 void sock_map_unhash(struct sock *sk);
 void sock_map_close(struct sock *sk, long timeout);
 #else
 static inline int sock_map_prog_update(struct bpf_map *map,
-				       struct bpf_prog *prog, u32 which)
+				       struct bpf_prog *prog,
+				       struct bpf_prog *old, u32 which)
 {
 	return -EOPNOTSUPP;
 }
@@ -1559,6 +1562,12 @@ static inline int sock_map_get_from_fd(const union bpf_attr *attr,
 {
 	return -EINVAL;
 }
+
+static inline int sock_map_prog_detach(const union bpf_attr *attr,
+				       enum bpf_prog_type ptype)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_BPF_STREAM_PARSER */
 
 #if defined(CONFIG_INET) && defined(CONFIG_BPF_SYSCALL)
diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 08674cd14d5a..1e9ed840b9fc 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -430,6 +430,19 @@ static inline void psock_set_prog(struct bpf_prog **pprog,
 		bpf_prog_put(prog);
 }
 
+static inline int psock_replace_prog(struct bpf_prog **pprog,
+				     struct bpf_prog *prog,
+				     struct bpf_prog *old)
+{
+	if (cmpxchg(pprog, old, prog) != old)
+		return -ENOENT;
+
+	if (old)
+		bpf_prog_put(old);
+
+	return 0;
+}
+
 static inline void psock_progs_drop(struct sk_psock_progs *progs)
 {
 	psock_set_prog(&progs->msg_parser, NULL);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 28c6ef759037..a74fce8ce043 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2893,7 +2893,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	switch (ptype) {
 	case BPF_PROG_TYPE_SK_MSG:
 	case BPF_PROG_TYPE_SK_SKB:
-		return sock_map_get_from_fd(attr, NULL);
+		return sock_map_prog_detach(attr, ptype);
 	case BPF_PROG_TYPE_LIRC_MODE2:
 		return lirc_prog_detach(attr);
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 58016a5c63ff..0971f17e8e54 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -77,7 +77,42 @@ int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog)
 	map = __bpf_map_get(f);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
-	ret = sock_map_prog_update(map, prog, attr->attach_type);
+	ret = sock_map_prog_update(map, prog, NULL, attr->attach_type);
+	fdput(f);
+	return ret;
+}
+
+int sock_map_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype)
+{
+	u32 ufd = attr->target_fd;
+	struct bpf_prog *prog;
+	struct bpf_map *map;
+	struct fd f;
+	int ret;
+
+	if (attr->attach_flags || attr->replace_bpf_fd)
+		return -EINVAL;
+
+	f = fdget(ufd);
+	map = __bpf_map_get(f);
+	if (IS_ERR(map))
+		return PTR_ERR(map);
+
+	prog = bpf_prog_get(attr->attach_bpf_fd);
+	if (IS_ERR(prog)) {
+		ret = PTR_ERR(prog);
+		goto put_map;
+	}
+
+	if (prog->type != ptype) {
+		ret = -EINVAL;
+		goto put_prog;
+	}
+
+	ret = sock_map_prog_update(map, NULL, prog, attr->attach_type);
+put_prog:
+	bpf_prog_put(prog);
+put_map:
 	fdput(f);
 	return ret;
 }
@@ -1206,27 +1241,32 @@ static struct sk_psock_progs *sock_map_progs(struct bpf_map *map)
 }
 
 int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
-			 u32 which)
+			 struct bpf_prog *old, u32 which)
 {
 	struct sk_psock_progs *progs = sock_map_progs(map);
+	struct bpf_prog **pprog;
 
 	if (!progs)
 		return -EOPNOTSUPP;
 
 	switch (which) {
 	case BPF_SK_MSG_VERDICT:
-		psock_set_prog(&progs->msg_parser, prog);
+		pprog = &progs->msg_parser;
 		break;
 	case BPF_SK_SKB_STREAM_PARSER:
-		psock_set_prog(&progs->skb_parser, prog);
+		pprog = &progs->skb_parser;
 		break;
 	case BPF_SK_SKB_STREAM_VERDICT:
-		psock_set_prog(&progs->skb_verdict, prog);
+		pprog = &progs->skb_verdict;
 		break;
 	default:
 		return -EOPNOTSUPP;
 	}
 
+	if (old)
+		return psock_replace_prog(pprog, prog, old);
+
+	psock_set_prog(pprog, prog);
 	return 0;
 }
 

