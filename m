Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0012A337C70
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhCKSXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:23:05 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:55927 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230145AbhCKSXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:23:00 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 502931BF8;
        Thu, 11 Mar 2021 13:22:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:22:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/Wh1J7
        oLHXyceAuEFBmpUTM0TAwNAWz2S7geMYL+XZU=; b=RIKrD+E7E3h7FG4o2ZUp7l
        oBo8SYNzUb48igDY7aUKssjIRywuuM63GTLKHXLU+Ln+/0+xPD55Pdz40VyuDsEP
        3/ngpJqK8E0vHnAjnNWIYdNci6XHgZICmWRxUOiBN3jHXoHexHuDLbBXCpkyFmCF
        kcDgk1s4GE/FIoz/PcVioWEpNunGxL603x3u2G4Yld5GWGQ2mnf/qGBMRRylZ0TI
        N1YXXSn6C2EWyuShMgSiw+ukZTB4iGch5iMK2iey4/pS2sqQzNxP0DpZBlvaT8XK
        cvK34P14c/45G684Fuo8ezLjWUvj5YjVCvDVpignBZdu24Z9SN2Jhy3xDlSRxCRw
        ==
X-ME-Sender: <xms:AmBKYFZzwIxFM_lZQCKNnc6hnYrulMd_C9mwsijTjaP06Qd4yb3GeA>
    <xme:AmBKYMZ7zgTx6ZzgnYpTWK8F_01fEgxASka78anbQ3nf6A5ocbIt0pSzFLjRegWc4
    7PcCS0cmUCljA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeitdffteffuddvgfekvefgtdeikeeuudffhefffe
    dtgedvjeeuvddugeduledtieenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:AmBKYH_vBlXaY1or7bJs1vIEdFF5kI2lashUkQuPJcKJOyptvKqfSA>
    <xmx:AmBKYDp_F59F5ixNX91yJ_e7x7zziGv2wz0dAc7AtJ1WMWnLLpa7iw>
    <xmx:AmBKYAoMC6sUph2XK6IhYviR5zPQ-hjlH8pBIQlq3fQB8lvUow6wFw>
    <xmx:AmBKYH3QI5kgKHGC4EJPqCS9lFFEG0YEsWejV9fjkeWjXTuqxU21f_6C3d8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 87D631080057;
        Thu, 11 Mar 2021 13:22:58 -0500 (EST)
Subject: FAILED: patch "[PATCH] mptcp: fix missing wakeup" failed to apply to 5.11-stable tree
To:     pabeni@redhat.com, davem@davemloft.net,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:22:55 +0100
Message-ID: <1615486975179127@kroah.com>
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

From 417789df4a03bc820b082bcc503f0d4c5e4704b9 Mon Sep 17 00:00:00 2001
From: Paolo Abeni <pabeni@redhat.com>
Date: Thu, 4 Mar 2021 13:32:15 -0800
Subject: [PATCH] mptcp: fix missing wakeup

__mptcp_clean_una() can free write memory and should wake-up
user-space processes when needed.

When such function is invoked by the MPTCP receive path, the wakeup
is not needed, as the TCP stack will later trigger subflow_write_space
which will do the wakeup as needed.

Other __mptcp_clean_una() call sites need an additional wakeup check
Let's bundle the relevant code in a new helper and use it.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/165
Fixes: 6e628cd3a8f7 ("mptcp: use mptcp release_cb for delayed tasks")
Fixes: 64b9cea7a0af ("mptcp: fix spurious retransmissions")
Tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index d2a2169e6d9e..76958570ae7f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1061,6 +1061,12 @@ static void __mptcp_clean_una(struct sock *sk)
 	}
 }
 
+static void __mptcp_clean_una_wakeup(struct sock *sk)
+{
+	__mptcp_clean_una(sk);
+	mptcp_write_space(sk);
+}
+
 static void mptcp_enter_memory_pressure(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow;
@@ -2270,7 +2276,7 @@ static void __mptcp_retrans(struct sock *sk)
 	struct sock *ssk;
 	int ret;
 
-	__mptcp_clean_una(sk);
+	__mptcp_clean_una_wakeup(sk);
 	dfrag = mptcp_rtx_head(sk);
 	if (!dfrag)
 		return;
@@ -2983,7 +2989,7 @@ static void mptcp_release_cb(struct sock *sk)
 	}
 
 	if (test_and_clear_bit(MPTCP_CLEAN_UNA, &mptcp_sk(sk)->flags))
-		__mptcp_clean_una(sk);
+		__mptcp_clean_una_wakeup(sk);
 	if (test_and_clear_bit(MPTCP_ERROR_REPORT, &mptcp_sk(sk)->flags))
 		__mptcp_error_report(sk);
 

