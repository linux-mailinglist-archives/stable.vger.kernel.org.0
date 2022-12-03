Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B33641978
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 23:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiLCWZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 17:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLCWZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 17:25:25 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC831E3C8
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 14:25:22 -0800 (PST)
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 3E1143F1C3
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 22:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1670106321;
        bh=gc49Z6JaG2s33Ug2HSFnslbb5RshcXcEpi4vFd6Oi7k=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=VvRH8/16rjA+DYj09tVDVqdnwvWdzSCmEedxr1oPuK5ytDwxhLa2LyLZpAQ7XMrBX
         hJvNk6GaLlU0Gj6N/VQplx7V6buKdsBSHwsaxLigDuneEESUpQe+F2jQoLh7TGiplq
         UtHFrT7qnC0TfgL89J0aOh7YQvRTUIQ7E5b160JCdGwSJT+nXKBB3/6bT1HGnlEEhg
         87qG/XP70ri4VhRdcvA5EezlZsk6N65mxHH0eWP2gQFKjx4EzszTrmxFX7OR4Jj37x
         QRzn3cIzT56A54QCPysmg8DmHY4DuQ3VCKJcZmFnL2sCsf96aWDGDbFYFA8nxRYBAC
         NjuvA69nHh9Yw==
Received: by mail-wm1-f72.google.com with SMTP id e8-20020a05600c218800b003cf634f5280so3100930wme.8
        for <stable@vger.kernel.org>; Sat, 03 Dec 2022 14:25:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gc49Z6JaG2s33Ug2HSFnslbb5RshcXcEpi4vFd6Oi7k=;
        b=Fz0xg4pGUAB3FmamabjGPwV9o6tiZATN0w0eNf4HzRSfHtfK9rr0bE/2rQ70eKFwqd
         5JMYP+uJ7BW5pWkmvOuPhJOwiROHnfXk4IES9Whf6zsV9XY93t9BGeP/6W2HUB0einTp
         Wk34kcUonok8Gn9tyy4V4gOEj5+JSGwdwFQWU5qtOkanayoOciKoyIMP6co7t1Opc/bH
         NLZwGVHMY0d9JfM7MZHe62qfbSY9GxFcGbQ6EJeNL3+iAki2ELFBJya6VBuwRmraWEoz
         MUHA7JGC5HtbYzou0la8M+9afA0T3hYydoDk/43L+ByWmR4VMeuRly01EN9Dq5KG+P38
         EcVA==
X-Gm-Message-State: ANoB5pln8wNnvUbcKSAUnjL34a7xZSlhHcYDLmG2CQhaVSN0oYUp8exM
        WPDrEjuQE+T4xxhGAFDaHz09AFSeu79w+HtIB9NTFy+a/4oKpNHn5Cx/FcNB8y/6T014R5KCNtk
        aKbVzZoTuzI2efNcMOI2hQYsNyUkzMaGsZA==
X-Received: by 2002:a05:600c:1ca6:b0:3d0:2476:5aad with SMTP id k38-20020a05600c1ca600b003d024765aadmr45345914wms.46.1670106320310;
        Sat, 03 Dec 2022 14:25:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf78aTNO/ELg3WcI5aRLbn0zhPe8HDF69StGCO/ohOMQtteB/Q7lPBUTCiB/f5DFF6GP1yguTA==
X-Received: by 2002:a05:600c:1ca6:b0:3d0:2476:5aad with SMTP id k38-20020a05600c1ca600b003d024765aadmr45345901wms.46.1670106319766;
        Sat, 03 Dec 2022 14:25:19 -0800 (PST)
Received: from localhost ([92.44.145.54])
        by smtp.gmail.com with ESMTPSA id e14-20020a05600c4e4e00b003b95ed78275sm12808061wmq.20.2022.12.03.14.25.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 14:25:19 -0800 (PST)
From:   Cengiz Can <cengiz.can@canonical.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 1/3] Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode
Date:   Sun,  4 Dec 2022 01:24:35 +0300
Message-Id: <20221203222434.669854-2-cengiz.can@canonical.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221203222434.669854-1-cengiz.can@canonical.com>
References: <20221203222434.669854-1-cengiz.can@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 15f02b91056253e8cdc592888f431da0731337b8 upstream

This adds the initial code for Enhanced Credit Based Mode which
introduces a new socket mode called L2CAP_MODE_EXT_FLOWCTL, which for
the most part work the same as L2CAP_MODE_LE_FLOWCTL but uses different
PDUs to setup the connections and also works over BR/EDR.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: stable@vger.kernel.org # 5.4.x
[CC: backport to 5.4: make l2cap_sock_setsockopt_old suitable for BT_DBG line.]
Signed-off-by: Cengiz Can <cengiz.can@canonical.com>
---
 include/net/bluetooth/l2cap.h |   4 +
 net/bluetooth/l2cap_core.c    | 545 +++++++++++++++++++++++++++++++++-
 net/bluetooth/l2cap_sock.c    |  24 +-
 3 files changed, 553 insertions(+), 20 deletions(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index b2046b02d11d..21744c30f546 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -290,6 +290,8 @@ struct l2cap_conn_rsp {
 #define L2CAP_CR_LE_ENCRYPTION		0x0008
 #define L2CAP_CR_LE_INVALID_SCID	0x0009
 #define L2CAP_CR_LE_SCID_IN_USE		0X000A
+#define L2CAP_CR_LE_UNACCEPT_PARAMS	0X000B
+#define L2CAP_CR_LE_INVALID_PARAMS	0X000C
 
 /* connect/create channel status */
 #define L2CAP_CS_NO_INFO	0x0000
@@ -926,6 +928,7 @@ void l2cap_cleanup_sockets(void);
 bool l2cap_is_socket(struct socket *sock);
 
 void __l2cap_le_connect_rsp_defer(struct l2cap_chan *chan);
+void __l2cap_ecred_conn_rsp_defer(struct l2cap_chan *chan);
 void __l2cap_connect_rsp_defer(struct l2cap_chan *chan);
 
 int l2cap_add_psm(struct l2cap_chan *chan, bdaddr_t *src, __le16 psm);
@@ -935,6 +938,7 @@ struct l2cap_chan *l2cap_chan_create(void);
 void l2cap_chan_close(struct l2cap_chan *chan, int reason);
 int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 		       bdaddr_t *dst, u8 dst_type);
+int l2cap_chan_reconfigure(struct l2cap_chan *chan, __u16 mtu);
 int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len);
 void l2cap_chan_busy(struct l2cap_chan *chan, int busy);
 int l2cap_chan_check_security(struct l2cap_chan *chan, bool initiator);
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index afa7fc55555e..d4d818f3caa7 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -568,6 +568,17 @@ static void l2cap_le_flowctl_init(struct l2cap_chan *chan, u16 tx_credits)
 	skb_queue_head_init(&chan->tx_q);
 }
 
+static void l2cap_ecred_init(struct l2cap_chan *chan, u16 tx_credits)
+{
+	l2cap_le_flowctl_init(chan, tx_credits);
+
+	/* L2CAP implementations shall support a minimum MPS of 64 octets */
+	if (chan->mps < L2CAP_ECRED_MIN_MPS) {
+		chan->mps = L2CAP_ECRED_MIN_MPS;
+		chan->rx_credits = (chan->imtu / chan->mps) + 1;
+	}
+}
+
 void __l2cap_chan_add(struct l2cap_conn *conn, struct l2cap_chan *chan)
 {
 	BT_DBG("conn %p, psm 0x%2.2x, dcid 0x%4.4x", conn,
@@ -674,6 +685,7 @@ void l2cap_chan_del(struct l2cap_chan *chan, int err)
 		break;
 
 	case L2CAP_MODE_LE_FLOWCTL:
+	case L2CAP_MODE_EXT_FLOWCTL:
 		skb_queue_purge(&chan->tx_q);
 		break;
 
@@ -740,6 +752,27 @@ static void l2cap_chan_le_connect_reject(struct l2cap_chan *chan)
 		       &rsp);
 }
 
+static void l2cap_chan_ecred_connect_reject(struct l2cap_chan *chan)
+{
+	struct l2cap_conn *conn = chan->conn;
+	struct l2cap_ecred_conn_rsp rsp;
+	u16 result;
+
+	if (test_bit(FLAG_DEFER_SETUP, &chan->flags))
+		result = L2CAP_CR_LE_AUTHORIZATION;
+	else
+		result = L2CAP_CR_LE_BAD_PSM;
+
+	l2cap_state_change(chan, BT_DISCONN);
+
+	memset(&rsp, 0, sizeof(rsp));
+
+	rsp.result  = cpu_to_le16(result);
+
+	l2cap_send_cmd(conn, chan->ident, L2CAP_LE_CONN_RSP, sizeof(rsp),
+		       &rsp);
+}
+
 static void l2cap_chan_connect_reject(struct l2cap_chan *chan)
 {
 	struct l2cap_conn *conn = chan->conn;
@@ -785,8 +818,16 @@ void l2cap_chan_close(struct l2cap_chan *chan, int reason)
 		if (chan->chan_type == L2CAP_CHAN_CONN_ORIENTED) {
 			if (conn->hcon->type == ACL_LINK)
 				l2cap_chan_connect_reject(chan);
-			else if (conn->hcon->type == LE_LINK)
-				l2cap_chan_le_connect_reject(chan);
+			else if (conn->hcon->type == LE_LINK) {
+				switch (chan->mode) {
+				case L2CAP_MODE_LE_FLOWCTL:
+					l2cap_chan_le_connect_reject(chan);
+					break;
+				case L2CAP_MODE_EXT_FLOWCTL:
+					l2cap_chan_ecred_connect_reject(chan);
+					break;
+				}
+			}
 		}
 
 		l2cap_chan_del(chan, reason);
@@ -1309,8 +1350,13 @@ static void l2cap_chan_ready(struct l2cap_chan *chan)
 	chan->conf_state = 0;
 	__clear_chan_timer(chan);
 
-	if (chan->mode == L2CAP_MODE_LE_FLOWCTL && !chan->tx_credits)
-		chan->ops->suspend(chan);
+	switch (chan->mode) {
+	case L2CAP_MODE_LE_FLOWCTL:
+	case L2CAP_MODE_EXT_FLOWCTL:
+		if (!chan->tx_credits)
+			chan->ops->suspend(chan);
+		break;
+	}
 
 	chan->state = BT_CONNECTED;
 
@@ -1339,6 +1385,31 @@ static void l2cap_le_connect(struct l2cap_chan *chan)
 		       sizeof(req), &req);
 }
 
+static void l2cap_ecred_connect(struct l2cap_chan *chan)
+{
+	struct l2cap_conn *conn = chan->conn;
+	struct {
+		struct l2cap_ecred_conn_req req;
+		__le16 scid;
+	} __packed pdu;
+
+	if (test_and_set_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags))
+		return;
+
+	l2cap_ecred_init(chan, 0);
+
+	pdu.req.psm     = chan->psm;
+	pdu.req.mtu     = cpu_to_le16(chan->imtu);
+	pdu.req.mps     = cpu_to_le16(chan->mps);
+	pdu.req.credits = cpu_to_le16(chan->rx_credits);
+	pdu.scid        = cpu_to_le16(chan->scid);
+
+	chan->ident = l2cap_get_ident(conn);
+
+	l2cap_send_cmd(conn, chan->ident, L2CAP_ECRED_CONN_REQ,
+		       sizeof(pdu), &pdu);
+}
+
 static void l2cap_le_start(struct l2cap_chan *chan)
 {
 	struct l2cap_conn *conn = chan->conn;
@@ -1351,8 +1422,12 @@ static void l2cap_le_start(struct l2cap_chan *chan)
 		return;
 	}
 
-	if (chan->state == BT_CONNECT)
-		l2cap_le_connect(chan);
+	if (chan->state == BT_CONNECT) {
+		if (chan->mode == L2CAP_MODE_EXT_FLOWCTL)
+			l2cap_ecred_connect(chan);
+		else
+			l2cap_le_connect(chan);
+	}
 }
 
 static void l2cap_start_connection(struct l2cap_chan *chan)
@@ -2540,6 +2615,7 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
 
 	switch (chan->mode) {
 	case L2CAP_MODE_LE_FLOWCTL:
+	case L2CAP_MODE_EXT_FLOWCTL:
 		/* Check outgoing MTU */
 		if (len > chan->omtu)
 			return -EMSGSIZE;
@@ -3758,6 +3834,45 @@ void __l2cap_le_connect_rsp_defer(struct l2cap_chan *chan)
 		       &rsp);
 }
 
+void __l2cap_ecred_conn_rsp_defer(struct l2cap_chan *chan)
+{
+	struct {
+		struct l2cap_ecred_conn_rsp rsp;
+		__le16 dcid[5];
+	} __packed pdu;
+	struct l2cap_conn *conn = chan->conn;
+	u16 ident = chan->ident;
+	int i = 0;
+
+	if (!ident)
+		return;
+
+	BT_DBG("chan %p ident %d", chan, ident);
+
+	pdu.rsp.mtu     = cpu_to_le16(chan->imtu);
+	pdu.rsp.mps     = cpu_to_le16(chan->mps);
+	pdu.rsp.credits = cpu_to_le16(chan->rx_credits);
+	pdu.rsp.result  = cpu_to_le16(L2CAP_CR_LE_SUCCESS);
+
+	mutex_lock(&conn->chan_lock);
+
+	list_for_each_entry(chan, &conn->chan_l, list) {
+		if (chan->ident != ident)
+			continue;
+
+		/* Reset ident so only one response is sent */
+		chan->ident = 0;
+
+		/* Include all channels pending with the same ident */
+		pdu.dcid[i++] = cpu_to_le16(chan->scid);
+	}
+
+	mutex_unlock(&conn->chan_lock);
+
+	l2cap_send_cmd(conn, ident, L2CAP_ECRED_CONN_RSP,
+			sizeof(pdu.rsp) + i * sizeof(__le16), &pdu);
+}
+
 void __l2cap_connect_rsp_defer(struct l2cap_chan *chan)
 {
 	struct l2cap_conn_rsp rsp;
@@ -5717,6 +5832,351 @@ static inline int l2cap_le_credits(struct l2cap_conn *conn,
 	return 0;
 }
 
+static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
+				       struct l2cap_cmd_hdr *cmd, u16 cmd_len,
+				       u8 *data)
+{
+	struct l2cap_ecred_conn_req *req = (void *) data;
+	struct {
+		struct l2cap_ecred_conn_rsp rsp;
+		__le16 dcid[5];
+	} __packed pdu;
+	struct l2cap_chan *chan, *pchan;
+	u16 credits, mtu, mps;
+	__le16 psm;
+	u8 result, len = 0;
+	int i, num_scid;
+	bool defer = false;
+
+	if (cmd_len < sizeof(*req) || cmd_len - sizeof(*req) % sizeof(u16)) {
+		result = L2CAP_CR_LE_INVALID_PARAMS;
+		goto response;
+	}
+
+	mtu  = __le16_to_cpu(req->mtu);
+	mps  = __le16_to_cpu(req->mps);
+
+	if (mtu < L2CAP_ECRED_MIN_MTU || mps < L2CAP_ECRED_MIN_MPS) {
+		result = L2CAP_CR_LE_UNACCEPT_PARAMS;
+		goto response;
+	}
+
+	psm  = req->psm;
+	credits = 0;
+
+	BT_DBG("psm 0x%2.2x mtu %u mps %u", __le16_to_cpu(psm), mtu, mps);
+
+	memset(&pdu, 0, sizeof(pdu));
+
+	/* Check if we have socket listening on psm */
+	pchan = l2cap_global_chan_by_psm(BT_LISTEN, psm, &conn->hcon->src,
+					 &conn->hcon->dst, LE_LINK);
+	if (!pchan) {
+		result = L2CAP_CR_LE_BAD_PSM;
+		goto response;
+	}
+
+	mutex_lock(&conn->chan_lock);
+	l2cap_chan_lock(pchan);
+
+	if (!smp_sufficient_security(conn->hcon, pchan->sec_level,
+				     SMP_ALLOW_STK)) {
+		result = L2CAP_CR_LE_AUTHENTICATION;
+		goto unlock;
+	}
+
+	result = L2CAP_CR_LE_SUCCESS;
+	cmd_len -= sizeof(req);
+	num_scid = cmd_len / sizeof(u16);
+
+	for (i = 0; i < num_scid; i++) {
+		u16 scid = __le16_to_cpu(req->scid[i]);
+
+		BT_DBG("scid[%d] 0x%4.4x", i, scid);
+
+		pdu.dcid[i] = 0x0000;
+		len += sizeof(*pdu.dcid);
+
+		/* Check for valid dynamic CID range */
+		if (scid < L2CAP_CID_DYN_START || scid > L2CAP_CID_LE_DYN_END) {
+			result = L2CAP_CR_LE_INVALID_SCID;
+			continue;
+		}
+
+		/* Check if we already have channel with that dcid */
+		if (__l2cap_get_chan_by_dcid(conn, scid)) {
+			result = L2CAP_CR_LE_SCID_IN_USE;
+			continue;
+		}
+
+		chan = pchan->ops->new_connection(pchan);
+		if (!chan) {
+			result = L2CAP_CR_LE_NO_MEM;
+			continue;
+		}
+
+		bacpy(&chan->src, &conn->hcon->src);
+		bacpy(&chan->dst, &conn->hcon->dst);
+		chan->src_type = bdaddr_src_type(conn->hcon);
+		chan->dst_type = bdaddr_dst_type(conn->hcon);
+		chan->psm  = psm;
+		chan->dcid = scid;
+		chan->omtu = mtu;
+		chan->remote_mps = mps;
+
+		__l2cap_chan_add(conn, chan);
+
+		l2cap_ecred_init(chan, __le16_to_cpu(req->credits));
+
+		/* Init response */
+		if (!pdu.rsp.credits) {
+			pdu.rsp.mtu = cpu_to_le16(chan->imtu);
+			pdu.rsp.mps = cpu_to_le16(chan->mps);
+			pdu.rsp.credits = cpu_to_le16(chan->rx_credits);
+		}
+
+		pdu.dcid[i] = cpu_to_le16(chan->scid);
+
+		__set_chan_timer(chan, chan->ops->get_sndtimeo(chan));
+
+		chan->ident = cmd->ident;
+
+		if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
+			l2cap_state_change(chan, BT_CONNECT2);
+			defer = true;
+			chan->ops->defer(chan);
+		} else {
+			l2cap_chan_ready(chan);
+		}
+	}
+
+unlock:
+	l2cap_chan_unlock(pchan);
+	mutex_unlock(&conn->chan_lock);
+	l2cap_chan_put(pchan);
+
+response:
+	pdu.rsp.result = cpu_to_le16(result);
+
+	if (defer)
+		return 0;
+
+	l2cap_send_cmd(conn, cmd->ident, L2CAP_ECRED_CONN_RSP,
+		       sizeof(pdu.rsp) + len, &pdu);
+
+	return 0;
+}
+
+static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
+				       struct l2cap_cmd_hdr *cmd, u16 cmd_len,
+				       u8 *data)
+{
+	struct l2cap_ecred_conn_rsp *rsp = (void *) data;
+	struct hci_conn *hcon = conn->hcon;
+	u16 mtu, mps, credits, result;
+	struct l2cap_chan *chan;
+	int err = 0, sec_level;
+	int i = 0;
+
+	if (cmd_len < sizeof(*rsp))
+		return -EPROTO;
+
+	mtu     = __le16_to_cpu(rsp->mtu);
+	mps     = __le16_to_cpu(rsp->mps);
+	credits = __le16_to_cpu(rsp->credits);
+	result  = __le16_to_cpu(rsp->result);
+
+	BT_DBG("mtu %u mps %u credits %u result 0x%4.4x", mtu, mps, credits,
+	       result);
+
+	mutex_lock(&conn->chan_lock);
+
+	cmd_len -= sizeof(*rsp);
+
+	list_for_each_entry(chan, &conn->chan_l, list) {
+		u16 dcid;
+
+		if (chan->ident != cmd->ident ||
+		    chan->mode != L2CAP_MODE_EXT_FLOWCTL ||
+		    chan->state == BT_CONNECTED)
+			continue;
+
+		l2cap_chan_lock(chan);
+
+		/* Check that there is a dcid for each pending channel */
+		if (cmd_len < sizeof(dcid)) {
+			l2cap_chan_del(chan, ECONNREFUSED);
+			l2cap_chan_unlock(chan);
+			continue;
+		}
+
+		dcid = __le16_to_cpu(rsp->dcid[i++]);
+		cmd_len -= sizeof(u16);
+
+		BT_DBG("dcid[%d] 0x%4.4x", i, dcid);
+
+		/* Check if dcid is already in use */
+		if (dcid && __l2cap_get_chan_by_dcid(conn, dcid)) {
+			/* If a device receives a
+			 * L2CAP_CREDIT_BASED_CONNECTION_RSP packet with an
+			 * already-assigned Destination CID, then both the
+			 * original channel and the new channel shall be
+			 * immediately discarded and not used.
+			 */
+			l2cap_chan_del(chan, ECONNREFUSED);
+			l2cap_chan_unlock(chan);
+			chan = __l2cap_get_chan_by_dcid(conn, dcid);
+			l2cap_chan_lock(chan);
+			l2cap_chan_del(chan, ECONNRESET);
+			l2cap_chan_unlock(chan);
+			continue;
+		}
+
+		switch (result) {
+		case L2CAP_CR_LE_AUTHENTICATION:
+		case L2CAP_CR_LE_ENCRYPTION:
+			/* If we already have MITM protection we can't do
+			 * anything.
+			 */
+			if (hcon->sec_level > BT_SECURITY_MEDIUM) {
+				l2cap_chan_del(chan, ECONNREFUSED);
+				break;
+			}
+
+			sec_level = hcon->sec_level + 1;
+			if (chan->sec_level < sec_level)
+				chan->sec_level = sec_level;
+
+			/* We'll need to send a new Connect Request */
+			clear_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags);
+
+			smp_conn_security(hcon, chan->sec_level);
+			break;
+
+		case L2CAP_CR_LE_BAD_PSM:
+			l2cap_chan_del(chan, ECONNREFUSED);
+			break;
+
+		default:
+			/* If dcid was not set it means channels was refused */
+			if (!dcid) {
+				l2cap_chan_del(chan, ECONNREFUSED);
+				break;
+			}
+
+			chan->ident = 0;
+			chan->dcid = dcid;
+			chan->omtu = mtu;
+			chan->remote_mps = mps;
+			chan->tx_credits = credits;
+			l2cap_chan_ready(chan);
+			break;
+		}
+
+		l2cap_chan_unlock(chan);
+	}
+
+	mutex_unlock(&conn->chan_lock);
+
+	return err;
+}
+
+static inline int l2cap_ecred_reconf_req(struct l2cap_conn *conn,
+					 struct l2cap_cmd_hdr *cmd, u16 cmd_len,
+					 u8 *data)
+{
+	struct l2cap_ecred_reconf_req *req = (void *) data;
+	struct l2cap_ecred_reconf_rsp rsp;
+	u16 mtu, mps, result;
+	struct l2cap_chan *chan;
+	int i, num_scid;
+
+	if (cmd_len < sizeof(*req) || cmd_len - sizeof(*req) % sizeof(u16)) {
+		result = L2CAP_CR_LE_INVALID_PARAMS;
+		goto respond;
+	}
+
+	mtu = __le16_to_cpu(req->mtu);
+	mps = __le16_to_cpu(req->mps);
+
+	BT_DBG("mtu %u mps %u", mtu, mps);
+
+	if (mtu < L2CAP_ECRED_MIN_MTU) {
+		result = L2CAP_RECONF_INVALID_MTU;
+		goto respond;
+	}
+
+	if (mps < L2CAP_ECRED_MIN_MPS) {
+		result = L2CAP_RECONF_INVALID_MPS;
+		goto respond;
+	}
+
+	cmd_len -= sizeof(*req);
+	num_scid = cmd_len / sizeof(u16);
+	result = L2CAP_RECONF_SUCCESS;
+
+	for (i = 0; i < num_scid; i++) {
+		u16 scid;
+
+		scid = __le16_to_cpu(req->scid[i]);
+		if (!scid)
+			return -EPROTO;
+
+		chan = __l2cap_get_chan_by_dcid(conn, scid);
+		if (!chan)
+			continue;
+
+		/* If the MTU value is decreased for any of the included
+		 * channels, then the receiver shall disconnect all
+		 * included channels.
+		 */
+		if (chan->omtu > mtu) {
+			BT_ERR("chan %p decreased MTU %u -> %u", chan,
+			       chan->omtu, mtu);
+			result = L2CAP_RECONF_INVALID_MTU;
+		}
+
+		chan->omtu = mtu;
+		chan->remote_mps = mps;
+	}
+
+respond:
+	rsp.result = cpu_to_le16(result);
+
+	l2cap_send_cmd(conn, cmd->ident, L2CAP_ECRED_RECONF_RSP, sizeof(rsp),
+		       &rsp);
+
+	return 0;
+}
+
+static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
+					 struct l2cap_cmd_hdr *cmd, u16 cmd_len,
+					 u8 *data)
+{
+	struct l2cap_chan *chan;
+	struct l2cap_ecred_conn_rsp *rsp = (void *) data;
+	u16 result;
+
+	if (cmd_len < sizeof(*rsp))
+		return -EPROTO;
+
+	result = __le16_to_cpu(rsp->result);
+
+	BT_DBG("result 0x%4.4x", rsp->result);
+
+	if (!result)
+		return 0;
+
+	list_for_each_entry(chan, &conn->chan_l, list) {
+		if (chan->ident != cmd->ident)
+			continue;
+
+		l2cap_chan_del(chan, ECONNRESET);
+	}
+
+	return 0;
+}
+
 static inline int l2cap_le_command_rej(struct l2cap_conn *conn,
 				       struct l2cap_cmd_hdr *cmd, u16 cmd_len,
 				       u8 *data)
@@ -5772,6 +6232,22 @@ static inline int l2cap_le_sig_cmd(struct l2cap_conn *conn,
 		err = l2cap_le_credits(conn, cmd, cmd_len, data);
 		break;
 
+	case L2CAP_ECRED_CONN_REQ:
+		err = l2cap_ecred_conn_req(conn, cmd, cmd_len, data);
+		break;
+
+	case L2CAP_ECRED_CONN_RSP:
+		err = l2cap_ecred_conn_rsp(conn, cmd, cmd_len, data);
+		break;
+
+	case L2CAP_ECRED_RECONF_REQ:
+		err = l2cap_ecred_reconf_req(conn, cmd, cmd_len, data);
+		break;
+
+	case L2CAP_ECRED_RECONF_RSP:
+		err = l2cap_ecred_reconf_rsp(conn, cmd, cmd_len, data);
+		break;
+
 	case L2CAP_DISCONN_REQ:
 		err = l2cap_disconnect_req(conn, cmd, cmd_len, data);
 		break;
@@ -6852,11 +7328,13 @@ static void l2cap_chan_le_send_credits(struct l2cap_chan *chan)
 	struct l2cap_le_credits pkt;
 	u16 return_credits;
 
-	return_credits = ((chan->imtu / chan->mps) + 1) - chan->rx_credits;
+	return_credits = (chan->imtu / chan->mps) + 1;
 
-	if (!return_credits)
+	if (chan->rx_credits >= return_credits)
 		return;
 
+	return_credits -= chan->rx_credits;
+
 	BT_DBG("chan %p returning %u credits to sender", chan, return_credits);
 
 	chan->rx_credits += return_credits;
@@ -6869,7 +7347,7 @@ static void l2cap_chan_le_send_credits(struct l2cap_chan *chan)
 	l2cap_send_cmd(conn, chan->ident, L2CAP_LE_CREDITS, sizeof(pkt), &pkt);
 }
 
-static int l2cap_le_recv(struct l2cap_chan *chan, struct sk_buff *skb)
+static int l2cap_ecred_recv(struct l2cap_chan *chan, struct sk_buff *skb)
 {
 	int err;
 
@@ -6884,7 +7362,7 @@ static int l2cap_le_recv(struct l2cap_chan *chan, struct sk_buff *skb)
 	return err;
 }
 
-static int l2cap_le_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
+static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 {
 	int err;
 
@@ -6932,7 +7410,7 @@ static int l2cap_le_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 		}
 
 		if (skb->len == sdu_len)
-			return l2cap_le_recv(chan, skb);
+			return l2cap_ecred_recv(chan, skb);
 
 		chan->sdu = skb;
 		chan->sdu_len = sdu_len;
@@ -6964,7 +7442,7 @@ static int l2cap_le_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 	skb = NULL;
 
 	if (chan->sdu->len == chan->sdu_len) {
-		err = l2cap_le_recv(chan, chan->sdu);
+		err = l2cap_ecred_recv(chan, chan->sdu);
 		if (!err) {
 			chan->sdu = NULL;
 			chan->sdu_last_frag = NULL;
@@ -7026,7 +7504,8 @@ static void l2cap_data_channel(struct l2cap_conn *conn, u16 cid,
 
 	switch (chan->mode) {
 	case L2CAP_MODE_LE_FLOWCTL:
-		if (l2cap_le_data_rcv(chan, skb) < 0)
+	case L2CAP_MODE_EXT_FLOWCTL:
+		if (l2cap_ecred_data_rcv(chan, skb) < 0)
 			goto drop;
 
 		goto done;
@@ -7254,8 +7733,8 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 	struct hci_dev *hdev;
 	int err;
 
-	BT_DBG("%pMR -> %pMR (type %u) psm 0x%2.2x", &chan->src, dst,
-	       dst_type, __le16_to_cpu(psm));
+	BT_DBG("%pMR -> %pMR (type %u) psm 0x%4.4x mode 0x%2.2x", &chan->src,
+	       dst, dst_type, __le16_to_cpu(psm), chan->mode);
 
 	hdev = hci_get_route(dst, &chan->src, chan->src_type);
 	if (!hdev)
@@ -7283,6 +7762,7 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 	case L2CAP_MODE_BASIC:
 		break;
 	case L2CAP_MODE_LE_FLOWCTL:
+	case L2CAP_MODE_EXT_FLOWCTL:
 		break;
 	case L2CAP_MODE_ERTM:
 	case L2CAP_MODE_STREAMING:
@@ -7408,6 +7888,38 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 }
 EXPORT_SYMBOL_GPL(l2cap_chan_connect);
 
+static void l2cap_ecred_reconfigure(struct l2cap_chan *chan)
+{
+	struct l2cap_conn *conn = chan->conn;
+	struct {
+		struct l2cap_ecred_reconf_req req;
+		__le16 scid;
+	} pdu;
+
+	pdu.req.mtu = cpu_to_le16(chan->imtu);
+	pdu.req.mps = cpu_to_le16(chan->mps);
+	pdu.scid    = cpu_to_le16(chan->scid);
+
+	chan->ident = l2cap_get_ident(conn);
+
+	l2cap_send_cmd(conn, chan->ident, L2CAP_ECRED_RECONF_REQ,
+		       sizeof(pdu), &pdu);
+}
+
+int l2cap_chan_reconfigure(struct l2cap_chan *chan, __u16 mtu)
+{
+	if (chan->imtu > mtu)
+		return -EINVAL;
+
+	BT_DBG("chan %p mtu 0x%4.4x", chan, mtu);
+
+	chan->imtu = mtu;
+
+	l2cap_ecred_reconfigure(chan);
+
+	return 0;
+}
+
 /* ---- L2CAP interface with lower layer (HCI) ---- */
 
 int l2cap_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr)
@@ -7619,7 +8131,8 @@ static void l2cap_security_cfm(struct hci_conn *hcon, u8 status, u8 encrypt)
 			else
 				__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
 		} else if (chan->state == BT_CONNECT2 &&
-			   chan->mode != L2CAP_MODE_LE_FLOWCTL) {
+			   !(chan->mode == L2CAP_MODE_EXT_FLOWCTL ||
+			     chan->mode == L2CAP_MODE_LE_FLOWCTL)) {
 			struct l2cap_conn_rsp rsp;
 			__u16 res, stat;
 
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 08e9f332adad..703a6b961fd1 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -240,7 +240,7 @@ static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr,
 			return -EINVAL;
 	}
 
-	if (chan->psm && bdaddr_type_is_le(chan->src_type))
+	if (chan->psm && bdaddr_type_is_le(chan->src_type) && !chan->mode)
 		chan->mode = L2CAP_MODE_LE_FLOWCTL;
 
 	err = l2cap_chan_connect(chan, la.l2_psm, __le16_to_cpu(la.l2_cid),
@@ -281,6 +281,7 @@ static int l2cap_sock_listen(struct socket *sock, int backlog)
 	switch (chan->mode) {
 	case L2CAP_MODE_BASIC:
 	case L2CAP_MODE_LE_FLOWCTL:
+	case L2CAP_MODE_EXT_FLOWCTL:
 		break;
 	case L2CAP_MODE_ERTM:
 	case L2CAP_MODE_STREAMING:
@@ -449,6 +450,8 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 		opts.max_tx   = chan->max_tx;
 		opts.txwin_size = chan->tx_win;
 
+		BT_DBG("mode 0x%2.2x", chan->mode);
+
 		len = min_t(unsigned int, len, sizeof(opts));
 		if (copy_to_user(optval, (char *) &opts, len))
 			err = -EFAULT;
@@ -718,6 +721,9 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 			break;
 
 		chan->mode = opts.mode;
+
+		BT_DBG("mode 0x%2.2x", chan->mode);
+
 		chan->imtu = opts.imtu;
 		chan->omtu = opts.omtu;
 		chan->fcs  = opts.fcs;
@@ -950,7 +956,8 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
-		if (sk->sk_state == BT_CONNECTED) {
+		if (chan->mode == L2CAP_MODE_LE_FLOWCTL &&
+		    sk->sk_state == BT_CONNECTED) {
 			err = -EISCONN;
 			break;
 		}
@@ -960,7 +967,12 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
-		chan->imtu = opt;
+		if (chan->mode == L2CAP_MODE_EXT_FLOWCTL &&
+		    sk->sk_state == BT_CONNECTED)
+			err = l2cap_chan_reconfigure(chan, opt);
+		else
+			chan->imtu = opt;
+
 		break;
 
 	default:
@@ -1015,7 +1027,11 @@ static int l2cap_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	if (sk->sk_state == BT_CONNECT2 && test_bit(BT_SK_DEFER_SETUP,
 						    &bt_sk(sk)->flags)) {
-		if (bdaddr_type_is_le(pi->chan->src_type)) {
+		if (pi->chan->mode == L2CAP_MODE_EXT_FLOWCTL) {
+			sk->sk_state = BT_CONNECTED;
+			pi->chan->state = BT_CONNECTED;
+			__l2cap_ecred_conn_rsp_defer(pi->chan);
+		} if (bdaddr_type_is_le(pi->chan->src_type)) {
 			sk->sk_state = BT_CONNECTED;
 			pi->chan->state = BT_CONNECTED;
 			__l2cap_le_connect_rsp_defer(pi->chan);
-- 
2.37.2

