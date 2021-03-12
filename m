Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A528338995
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 11:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhCLKEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 05:04:09 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:48249 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233039AbhCLKEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 05:04:06 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id D524A1940C27;
        Fri, 12 Mar 2021 05:04:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 12 Mar 2021 05:04:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=B3tzJp
        8zhmWvWJAzbpAAd+OFBWp7RqDu5O0i/6LvlpY=; b=tXZIZdCU0vs0s8/JgUSsQW
        QqeMNiytHU1138Ybr6dFV59yJ1ec1ijHbre/1JqHGNjPaBUHOCkUnbXY+OYJdJNu
        dpoF0Xx+IApHrtFvNNRlTwzWi3fpeYgGfsUqb0xTCrQr5XYvtNU1eSLVLSd94AAz
        Db4dq69zv90QXgJRuwn+lnx6d/3UQgd5q5SenIIuFDyah0pjb+7pGzL54xOHWIR9
        4zxtwvzyat4kfd5OX2Kp5GvKPIA7/Ez/ivxeBe6BcZ3A3C/nNmAhyzc26FUNM4QO
        qAMhKIKvK4W/+P4reuDXNJ39hFh9pTjGo6Z/FxMzT2SKxVJaS02Pu+3WMwCwvLyg
        ==
X-ME-Sender: <xms:lTxLYPUCG65AqBv2OdrFScV3Biq54S4SdVVSs9pKOD0xX8p6vbE0rg>
    <xme:lTxLYK1ogspuktbjP0J5RFwyvW0K6bSmrTAntUG2Uo9w_ws163sq4PJPYN9RhJhCi
    e_YHys3JsePtg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:lTxLYE2D2NHaknooFX0KdzWts3ZSKNtQYh2L4JH3joshSu_a2jD0Hw>
    <xmx:lTxLYF-RhBos4aRrvzRy4GiY_svWJpJnQ6N6PrfpM1cvNkM74V6tkw>
    <xmx:lTxLYJ3AMtVkoS7JBW--lMB7TSReKTQ55Hc8wK5CLkwq1rURuVX0CQ>
    <xmx:lTxLYKFPa0wBlT2-qrP01UwwdWDnRtiJDalD-gQ72nJUTK7qpEB3mg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4337424005C;
        Fri, 12 Mar 2021 05:04:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] cifs: fix credit accounting for extra channel" failed to apply to 5.10-stable tree
To:     aaptel@suse.com, sprasad@microsoft.com, stable@vger.kernel.org,
        stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 11:04:02 +0100
Message-ID: <161554344221530@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a249cc8bc2e2fed680047d326eb9a50756724198 Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel@suse.com>
Date: Thu, 4 Mar 2021 17:42:21 +0000
Subject: [PATCH] cifs: fix credit accounting for extra channel

With multichannel, operations like the queries
from "ls -lR" can cause all credits to be used and
errors to be returned since max_credits was not
being set correctly on the secondary channels and
thus the client was requesting 0 credits incorrectly
in some cases (which can lead to not having
enough credits to perform any operation on that
channel).

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
CC: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 112692300fb6..68642e3d4270 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1429,6 +1429,11 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx)
 	tcp_ses->min_offload = ctx->min_offload;
 	tcp_ses->tcpStatus = CifsNeedNegotiate;
 
+	if ((ctx->max_credits < 20) || (ctx->max_credits > 60000))
+		tcp_ses->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
+	else
+		tcp_ses->max_credits = ctx->max_credits;
+
 	tcp_ses->nr_targets = 1;
 	tcp_ses->ignore_signature = ctx->ignore_signature;
 	/* thread spawned, put it on the list */
@@ -2832,11 +2837,6 @@ static int mount_get_conns(struct smb3_fs_context *ctx, struct cifs_sb_info *cif
 
 	*nserver = server;
 
-	if ((ctx->max_credits < 20) || (ctx->max_credits > 60000))
-		server->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
-	else
-		server->max_credits = ctx->max_credits;
-
 	/* get a reference to a SMB session */
 	ses = cifs_get_smb_ses(server, ctx);
 	if (IS_ERR(ses)) {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 183a3a868d7b..63d517b9f2ff 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -230,6 +230,7 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 	ctx.noautotune = ses->server->noautotune;
 	ctx.sockopt_tcp_nodelay = ses->server->tcp_nodelay;
 	ctx.echo_interval = ses->server->echo_interval / HZ;
+	ctx.max_credits = ses->server->max_credits;
 
 	/*
 	 * This will be used for encoding/decoding user/domain/pw

