Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AD3343237
	for <lists+stable@lfdr.de>; Sun, 21 Mar 2021 13:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCUMEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Mar 2021 08:04:25 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:60673 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229941AbhCUMER (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Mar 2021 08:04:17 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 37E8D194074B;
        Sun, 21 Mar 2021 08:04:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 21 Mar 2021 08:04:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zUnYLr
        MgULwsbHgnTeP49K5YtWsnz8SH2sNR3qTNmiE=; b=E76sGJUe+g+4HE6Dr7q+zP
        DtJlnr/emW6qSHiRBtUKO26CWmf/pMKXuQLQZx8CW8OnVaJ+qj2crXfsoxiXXKBs
        n1/sR4EpvK6UZDDrLgZ1tRFP7bauLgG5JS2gJ/bp/H9yK73rHn84qHJyUmhzUl2t
        xlO7gzedRYg3kjOuaukemlXFpQM9I3bx7ef7cLPbgbVEN2WRmsD3k6QmE0CyMgiD
        e640bfZQHq3102AbtCkcCvDS3Uu4P1k2xYTV2OGQ7qv/STp4q7n2ESG65IIAxPT6
        0AsyMWmzmQ0QOIEtePzrYGg2gVAh6RgpjRP95YXl9vpDwsomzgtPP6MrcK/SAlLA
        ==
X-ME-Sender: <xms:QDZXYNevI1qHtFThhcNw3APFMN3AYRuNCyeWM7b0JNh3KJmS3ShajQ>
    <xme:QDZXYLMkV0VBx02vQOI6EB_d5W5_SVqBL3JLwAEfPXtliaRldw5sKRlX7XFi-p39u
    NU3jUKIawUufA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegvddgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:QDZXYGjKd9cq_yfamxgcP5bY__iSaMcQAcmN9imNGzpOob31iWvpSw>
    <xmx:QDZXYG8KnmqRGiGhG0rtASxZZJb5NHCkPH_sy2J6fz9BK1WB0lEQlg>
    <xmx:QDZXYJvvQX9ZP1VWzROR2JPxNPq1YnZ88i4K0okIxr-lEKE2EcTC1Q>
    <xmx:QTZXYKVUPHVWqt0igyJm_vDkFZ_QURDfjrZls2Vi9jmX0Xz-nArAig>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89246108005C;
        Sun, 21 Mar 2021 08:04:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] cifs: Fix preauth hash corruption" failed to apply to 5.11-stable tree
To:     vincent.whitchurch@axis.com, aaptel@suse.com,
        stable@vger.kernel.org, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 21 Mar 2021 13:04:14 +0100
Message-ID: <1616328254225233@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 05946d4b7a7349ae58bfa2d51ae832e64a394c2d Mon Sep 17 00:00:00 2001
From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Date: Wed, 10 Mar 2021 13:20:40 +0100
Subject: [PATCH] cifs: Fix preauth hash corruption

smb311_update_preauth_hash() uses the shash in server->secmech without
appropriate locking, and this can lead to sessions corrupting each
other's preauth hashes.

The following script can easily trigger the problem:

	#!/bin/sh -e

	NMOUNTS=10
	for i in $(seq $NMOUNTS);
		mkdir -p /tmp/mnt$i
		umount /tmp/mnt$i 2>/dev/null || :
	done
	while :; do
		for i in $(seq $NMOUNTS); do
			mount -t cifs //192.168.0.1/test /tmp/mnt$i -o ... &
		done
		wait
		for i in $(seq $NMOUNTS); do
			umount /tmp/mnt$i
		done
	done

Usually within seconds this leads to one or more of the mounts failing
with the following errors, and a "Bad SMB2 signature for message" is
seen in the server logs:

 CIFS: VFS: \\192.168.0.1 failed to connect to IPC (rc=-13)
 CIFS: VFS: cifs_mount failed w/return code = -13

Fix it by holding the server mutex just like in the other places where
the shashes are used.

Fixes: 8bd68c6e47abff34e4 ("CIFS: implement v3.11 preauth integrity")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
CC: <stable@vger.kernel.org>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 007d99437c77..c1725b55f364 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1196,9 +1196,12 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	/*
 	 * Compounding is never used during session establish.
 	 */
-	if ((ses->status == CifsNew) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP))
+	if ((ses->status == CifsNew) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
+		mutex_lock(&server->srv_mutex);
 		smb311_update_preauth_hash(ses, rqst[0].rq_iov,
 					   rqst[0].rq_nvec);
+		mutex_unlock(&server->srv_mutex);
+	}
 
 	for (i = 0; i < num_rqst; i++) {
 		rc = wait_for_response(server, midQ[i]);
@@ -1266,7 +1269,9 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			.iov_base = resp_iov[0].iov_base,
 			.iov_len = resp_iov[0].iov_len
 		};
+		mutex_lock(&server->srv_mutex);
 		smb311_update_preauth_hash(ses, &iov, 1);
+		mutex_unlock(&server->srv_mutex);
 	}
 
 out:

