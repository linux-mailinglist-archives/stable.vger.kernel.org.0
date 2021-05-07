Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DA5376683
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 15:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237332AbhEGN70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 09:59:26 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:48789 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232056AbhEGN7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 09:59:25 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id D308C19418B8;
        Fri,  7 May 2021 09:58:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 07 May 2021 09:58:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=R/sJBT
        a0rhfob10bz44P+/hCCZxb4f5isspaFTy0Y84=; b=o3wH/Jzr+VWKvoXk4pAKkZ
        S5zQ7N4iiKsyZ1rJ5Fvxj+/2hqMQenFlNqGhNGD7tVMkPC/Vo2bsOc9wQIHR1C1C
        DRlzMazO9FOXLYRArjwWAU0y1b5nsm4U7TQiAjnMOPdvCQVqhNa9GXlFhNkb+ORY
        gaiEMZu18jtlVVq7Cfh7KSEXjPIFdrBrUM0G+AUlcdklVLSYO9BhZHr92nu65YGO
        EPt092TRIhgQdwQTGkAF78eR4ebxF2hf4y8Ij2Z0mpmiUa2JlTzz4+53wc8BRrNE
        VxHc3uojeuSYxl8mNGFYdNZv+i6Y2RuW805o8NxkCR+XOb4RtDUeoZ/twluctZ3A
        ==
X-ME-Sender: <xms:gUeVYM-eNWZrnddufC_Y0LL3GuxmTJfGMZ84KUYMAS-TOQt4184ZQQ>
    <xme:gUeVYEu0TOJ42SYinTicYRIvc_DWnt-C5DEcXqVGbfvgesvlkAFtF4fQeGFEtdJqZ
    ndSSn3b4f-n_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegvddgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:gUeVYCB-KHu57wVhEauycFyAVg_4-xL2gCgub1izMghiY7aYqgM6PA>
    <xmx:gUeVYMff8RupKzgs9uC9MitrtrWHte9vEzL1tFSSr3KaSVDyl4SP0A>
    <xmx:gUeVYBPWwE5jFy3EXc6kR73IoaAyfoTD7j9KaVZY1x3II4uIFsD5sg>
    <xmx:gUeVYDU_e0nY0URXquZNbNjmY75tE8D9tO8kKhETVPG6epRBcqy-Rw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri,  7 May 2021 09:58:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] libceph: don't set global_id until we get an auth ticket" failed to apply to 5.4-stable tree
To:     idryomov@gmail.com, sage@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 May 2021 15:58:14 +0200
Message-ID: <1620395894989@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 61ca49a9105faefa003b37542cebad8722f8ae22 Mon Sep 17 00:00:00 2001
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 26 Apr 2021 19:11:37 +0200
Subject: [PATCH] libceph: don't set global_id until we get an auth ticket

With the introduction of enforcing mode, setting global_id as soon
as we get it in the first MAuth reply will result in EACCES if the
connection is reset before we get the second MAuth reply containing
an auth ticket -- because on retry we would attempt to reclaim that
global_id with no auth ticket at hand.

Neither ceph_auth_client nor ceph_mon_client depend on global_id
being set ealy, so just delay the setting until we get and process
the second MAuth reply.  While at it, complain if the monitor sends
a zero global_id or changes our global_id as the session is likely
to fail after that.

Cc: stable@vger.kernel.org # needs backporting for < 5.11
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Sage Weil <sage@redhat.com>

diff --git a/net/ceph/auth.c b/net/ceph/auth.c
index eb261aa5fe18..de407e8feb97 100644
--- a/net/ceph/auth.c
+++ b/net/ceph/auth.c
@@ -36,6 +36,20 @@ static int init_protocol(struct ceph_auth_client *ac, int proto)
 	}
 }
 
+static void set_global_id(struct ceph_auth_client *ac, u64 global_id)
+{
+	dout("%s global_id %llu\n", __func__, global_id);
+
+	if (!global_id)
+		pr_err("got zero global_id\n");
+
+	if (ac->global_id && global_id != ac->global_id)
+		pr_err("global_id changed from %llu to %llu\n", ac->global_id,
+		       global_id);
+
+	ac->global_id = global_id;
+}
+
 /*
  * setup, teardown.
  */
@@ -222,11 +236,6 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
 
 	payload_end = payload + payload_len;
 
-	if (global_id && ac->global_id != global_id) {
-		dout(" set global_id %lld -> %lld\n", ac->global_id, global_id);
-		ac->global_id = global_id;
-	}
-
 	if (ac->negotiating) {
 		/* server does not support our protocols? */
 		if (!protocol && result < 0) {
@@ -253,11 +262,16 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
 
 	ret = ac->ops->handle_reply(ac, result, payload, payload_end,
 				    NULL, NULL, NULL, NULL);
-	if (ret == -EAGAIN)
+	if (ret == -EAGAIN) {
 		ret = build_request(ac, true, reply_buf, reply_len);
-	else if (ret)
+		goto out;
+	} else if (ret) {
 		pr_err("auth protocol '%s' mauth authentication failed: %d\n",
 		       ceph_auth_proto_name(ac->protocol), result);
+		goto out;
+	}
+
+	set_global_id(ac, global_id);
 
 out:
 	mutex_unlock(&ac->mutex);
@@ -484,15 +498,11 @@ int ceph_auth_handle_reply_done(struct ceph_auth_client *ac,
 	int ret;
 
 	mutex_lock(&ac->mutex);
-	if (global_id && ac->global_id != global_id) {
-		dout("%s global_id %llu -> %llu\n", __func__, ac->global_id,
-		     global_id);
-		ac->global_id = global_id;
-	}
-
 	ret = ac->ops->handle_reply(ac, 0, reply, reply + reply_len,
 				    session_key, session_key_len,
 				    con_secret, con_secret_len);
+	if (!ret)
+		set_global_id(ac, global_id);
 	mutex_unlock(&ac->mutex);
 	return ret;
 }

