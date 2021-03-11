Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8998337C6F
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhCKSXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:23:04 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:59321 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229809AbhCKSW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:22:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 90C5A1C00;
        Thu, 11 Mar 2021 13:22:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:22:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hfoct4
        vI6PdI9NU3z+Y761FKeacY+v9pc4LXN29EI6s=; b=Ie90X22G2xbvk3ohNi/D8t
        UeOKC0ExEA9GAt66xeyIfsQRxxiqMV26IuRP/3yu9TxaIzT1stZkzqkn+CeqjE5e
        voKowiy2ZD4gMJnC8hyqT+QtxQLxIGISyd30bAqzfVpHL2O/2P0NG1ELXrK/kE7f
        0/BxAVuPS/v4FtCMX66EqhfhCF9acbf+UfZUVv1Ay+4CqvXzIS3hMANhJYJRoEre
        SAL7w8gANrO29Z+ouCfnBHsDrc0cHKUtDBoqgQl4/co6kJuQIRuwqUatVkI9vxcW
        coUeOfOjC23U2j6NPPmGAACeFjr7uQVFFVBOaF7wx5tFjY2Is2Dvs9A3/kg/gx2g
        ==
X-ME-Sender: <xms:AWBKYJeGo3zy94vccrWAf9vERJzquPg1QVNuH_WY4HK_DQi9QNZHWg>
    <xme:AWBKYHMUtkmYFmoEUOTl7da9Ak3EyF3yvlx4y3m192yWKCofCDKPDGIU7ej00y8fh
    0lVDBE1xuu9bg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeitdffteffuddvgfekvefgtdeikeeuudffhefffe
    dtgedvjeeuvddugeduledtieenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:AWBKYChfSoT3aiE5C_rjNEbJwNHun1zC7nqByEZFF5K00N7jRcw8QQ>
    <xmx:AWBKYC_g69ISPjTte3XRQAkjiX08IOP0tj6eK_AKzr8vzH9FygC5Ow>
    <xmx:AWBKYFtycGPXmegtKAGdlYdWQ3F9d0lMhs1kI-q4msq1MzqIbPU-2A>
    <xmx:AWBKYPIlTyine7R8bL-4oczXQGD5LTJpG9EKlRiPc11y9NinhRoYs7I4yuY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C0BDB240054;
        Thu, 11 Mar 2021 13:22:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] mptcp: reset last_snd on subflow close" failed to apply to 5.11-stable tree
To:     fw@strlen.de, cpaasch@apple.com, davem@davemloft.net,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        pabeni@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:22:48 +0100
Message-ID: <1615486968151191@kroah.com>
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

