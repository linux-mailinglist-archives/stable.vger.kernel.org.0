Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC8032D594
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 15:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbhCDOl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 09:41:56 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:41475 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232172AbhCDOlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 09:41:31 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 4A2BE15AB;
        Thu,  4 Mar 2021 09:40:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 04 Mar 2021 09:40:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VwliJK
        iPbX1jdO1/KzrxSb6FQZ9uFXq/FWnWlB8OyGU=; b=Ne81HBhagdJPp1heYgEh2W
        hmaBadOHWjyDefWBrelIZWiXQ1Mhv2Pf/THMqTZRqcLaY2skdXwKDF2p53RyNccY
        12c6/SdsshzD1p/HtzfWBDHsnc7KxJj05qu6iAQQ0GlpyN2fKQVBaKyb+CzjXJfV
        Tj9dQ6CRQ5GohXxMolsYhR+09IihKifjaKUqMxgP3PbuhkWysB7GMKvqwaIsl6Fi
        9VtygqCOf/MGOPOxyJ2QDDVxLDU2C5FMunq+4noSH0hFtB+gccUeIkOFJKzfNN4P
        QmV2fveLTSCGraD+km0MPiMrVlEBWt7ndjfGHPLGxH/sO+wGeGuWari5/fzXGIDg
        ==
X-ME-Sender: <xms:bPFAYGKgrHKcN2mX9nFmRRNGbjGpFB9QObXhdL4i0GcX22LQahzd2A>
    <xme:bPFAYHwIhZ0lhvD_YOuuk_s0s5-DCgqRxjagSqXVkKBjQe8CwP61MlClNBOLO_01_
    tbHIyos1hSsMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:bPFAYGv8ZaOXhEl38LfmQ2_y2Y0ZKEtDHL4cNxqBIvJhZJdxaYysYg>
    <xmx:bPFAYOujVuS1HQ51C8aOf72CER2XXvpqEX10sX4RCu18cR5S1erUSg>
    <xmx:bPFAYLNwl99ixoUu76H-RGUCnmPUvoxxPG0Vac8irWnciocKRpUviw>
    <xmx:bPFAYK7nSfTzin7XI737XY-SnjFyvirpAsgEBLdHVivuoN1T_faoICcEAek>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EB9BE24005E;
        Thu,  4 Mar 2021 09:40:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] mptcp: fix DATA_FIN generation on early shutdown" failed to apply to 5.10-stable tree
To:     pabeni@redhat.com, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Mar 2021 15:40:42 +0100
Message-ID: <1614868842161253@kroah.com>
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

From d87903b63e3ce1eafaa701aec5cc1d0ecd0d84dc Mon Sep 17 00:00:00 2001
From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 19 Feb 2021 18:35:38 +0100
Subject: [PATCH] mptcp: fix DATA_FIN generation on early shutdown

If the msk is closed before sending or receiving any data,
no DATA_FIN is generated, instead an MPC ack packet is
crafted out.

In the above scenario, the MPTCP protocol creates and sends a
pure ack and such packets matches also the criteria for an
MPC ack and the protocol tries first to insert MPC options,
leading to the described error.

This change addresses the issue by avoiding the insertion of an
MPC option for DATA_FIN packets or if the sub-flow is not
established.

To avoid doing multiple times the same test, fetch the data_fin
flag in a bool variable and pass it to both the interested
helpers.

Fixes: 6d0060f600ad ("mptcp: Write MPTCP DSS headers to outgoing data packets")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index b63574d6b812..444a38681e93 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -411,6 +411,7 @@ static void clear_3rdack_retransmission(struct sock *sk)
 }
 
 static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
+					 bool snd_data_fin_enable,
 					 unsigned int *size,
 					 unsigned int remaining,
 					 struct mptcp_out_options *opts)
@@ -428,9 +429,10 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 	if (!skb)
 		return false;
 
-	/* MPC/MPJ needed only on 3rd ack packet */
-	if (subflow->fully_established ||
-	    subflow->snd_isn != TCP_SKB_CB(skb)->seq)
+	/* MPC/MPJ needed only on 3rd ack packet, DATA_FIN and TCP shutdown take precedence */
+	if (subflow->fully_established || snd_data_fin_enable ||
+	    subflow->snd_isn != TCP_SKB_CB(skb)->seq ||
+	    sk->sk_state != TCP_ESTABLISHED)
 		return false;
 
 	if (subflow->mp_capable) {
@@ -502,20 +504,20 @@ static void mptcp_write_data_fin(struct mptcp_subflow_context *subflow,
 }
 
 static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
+					  bool snd_data_fin_enable,
 					  unsigned int *size,
 					  unsigned int remaining,
 					  struct mptcp_out_options *opts)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
-	u64 snd_data_fin_enable, ack_seq;
 	unsigned int dss_size = 0;
 	struct mptcp_ext *mpext;
 	unsigned int ack_size;
 	bool ret = false;
+	u64 ack_seq;
 
 	mpext = skb ? mptcp_get_ext(skb) : NULL;
-	snd_data_fin_enable = mptcp_data_fin_enabled(msk);
 
 	if (!skb || (mpext && mpext->use_map) || snd_data_fin_enable) {
 		unsigned int map_size;
@@ -717,12 +719,15 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 			       unsigned int *size, unsigned int remaining,
 			       struct mptcp_out_options *opts)
 {
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	unsigned int opt_size = 0;
+	bool snd_data_fin;
 	bool ret = false;
 
 	opts->suboptions = 0;
 
-	if (unlikely(mptcp_check_fallback(sk)))
+	if (unlikely(__mptcp_check_fallback(msk)))
 		return false;
 
 	/* prevent adding of any MPTCP related options on reset packet
@@ -731,10 +736,10 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 	if (unlikely(skb && TCP_SKB_CB(skb)->tcp_flags & TCPHDR_RST))
 		return false;
 
-	if (mptcp_established_options_mp(sk, skb, &opt_size, remaining, opts))
+	snd_data_fin = mptcp_data_fin_enabled(msk);
+	if (mptcp_established_options_mp(sk, skb, snd_data_fin, &opt_size, remaining, opts))
 		ret = true;
-	else if (mptcp_established_options_dss(sk, skb, &opt_size, remaining,
-					       opts))
+	else if (mptcp_established_options_dss(sk, skb, snd_data_fin, &opt_size, remaining, opts))
 		ret = true;
 
 	/* we reserved enough space for the above options, and exceeding the

