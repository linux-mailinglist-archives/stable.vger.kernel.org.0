Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1104337C6D
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhCKSXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:23:04 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:45497 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229796AbhCKSWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:22:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 13C7F1B7B;
        Thu, 11 Mar 2021 13:22:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:22:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=U3r86M
        7K/kvzHjQQzWsGr3MKS+mUWKihgcwiRYu7SY4=; b=gkQdNOl5atVbj4FkG66ouO
        h29/D+4e6+ybjqBcKOjvxDz5mSxisQRmQPaGt0meIcS52S0qu6/dS3DZuZCCigZR
        GabOa6NZHnbUi0yOYaygdjKtQnqZA5LEli+TA9sSKp7FAASXpC2FCtSvGt2Az7/f
        7E6fn/xOlB3TG8pmF7jGO5CPpHsgf5AeUVtP5wjhrsQPOfnYabcZnoZEBtqh+aBP
        FUvTBXLVD/doedArnezIqJB1VOeXU72VSjLORlzXY4HmnnG2bYgwjz7NAY9C750O
        Z1RXZh/Qx+I4owh/cZdz5QCGxamCkZOSFlGGtYlPqIqDyug5B/2CV5FTR3FYPAnA
        ==
X-ME-Sender: <xms:-V9KYChVtWNPxM6hg3IGph8CiXjUtyBeZPE8gFBgyvwjLZegWEJ0_w>
    <xme:-V9KYDBOjddhCPAai_tCk6WmJMNXVRWyMpZSg40JcZBQ6J0hrfrz2Jt_mGOpuNBmm
    k4cIlylhi0P_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeitdffteffuddvgfekvefgtdeikeeuudffhefffe
    dtgedvjeeuvddugeduledtieenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:-V9KYKHCCWfh-DdB2IgbAZbDCXv-a7t4leSsHGFpZNMOf6OrLh9pZQ>
    <xmx:-V9KYLTwU_Obk0B5EorsvKC73RVqNXfM74f1oKHTFn6oJBpla4vv4w>
    <xmx:-V9KYPz4Mj_MQKtuioTdETflJpvqbq2Jx5a15hR_FJ3GICbJpQPu4Q>
    <xmx:-l9KYBuAO0o8TTx5_R-9KY5feSbEydWhzBzQVgORzyMBv-HW-2LA6wf_ES8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8D198108005C;
        Thu, 11 Mar 2021 13:22:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] mptcp: reset last_snd on subflow close" failed to apply to 5.10-stable tree
To:     fw@strlen.de, cpaasch@apple.com, davem@davemloft.net,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        pabeni@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:22:48 +0100
Message-ID: <16154869687150@kroah.com>
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

From e0be4931f3fee2e04dec4013ea4f27ec2db8556f Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Thu, 4 Mar 2021 13:32:08 -0800
Subject: [PATCH] mptcp: reset last_snd on subflow close

Send logic caches last active subflow in the msk, so it needs to be
cleared when the cached subflow is closed.

Fixes: d5f49190def61c ("mptcp: allow picking different xmit subflows")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/155
Reported-by: Christoph Paasch <cpaasch@apple.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c5d5e68940ea..7362a536cbc0 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2126,6 +2126,8 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
 static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 			      struct mptcp_subflow_context *subflow)
 {
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
 	list_del(&subflow->node);
 
 	lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
@@ -2154,6 +2156,9 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	release_sock(ssk);
 
 	sock_put(ssk);
+
+	if (ssk == msk->last_snd)
+		msk->last_snd = NULL;
 }
 
 void mptcp_close_ssk(struct sock *sk, struct sock *ssk,

