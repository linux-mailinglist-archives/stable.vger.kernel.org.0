Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3728B4B20AB
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 09:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348288AbiBKIxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 03:53:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344530AbiBKIxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 03:53:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9650DF12;
        Fri, 11 Feb 2022 00:53:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31C5161E55;
        Fri, 11 Feb 2022 08:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA238C340E9;
        Fri, 11 Feb 2022 08:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644569625;
        bh=gaHK5RtMuv1FvIcw+jHuwdlVbQIrk+1c1D5Xu5fxr+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJOccb0o6XjHTV0xCrYl68wJZUBAFofV7DRbNADoyaDD25QzJuTRDQYhWNvtvxUXP
         3XmxSNWMqbz+djN520D/YosIJ07mCKzgLDX6aN2pbQt61knYP5P1keqS8Ei+Th55Oy
         1hG5nJvmnFw6a2IZufGC5D8pPOa5k6TDax841oHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.23
Date:   Fri, 11 Feb 2022 09:53:32 +0100
Message-Id: <1644569612183140@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <1644569611153233@kroah.com>
References: <1644569611153233@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 5bddd6195484..74eafb2e60ab 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 22
+SUBLEVEL = 23
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 6231e1f0abe7..27dd084c9a2a 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -73,6 +73,7 @@
 #define ARM_CPU_PART_CORTEX_A76		0xD0B
 #define ARM_CPU_PART_NEOVERSE_N1	0xD0C
 #define ARM_CPU_PART_CORTEX_A77		0xD0D
+#define ARM_CPU_PART_CORTEX_A510	0xD46
 
 #define APM_CPU_PART_POTENZA		0x000
 
@@ -113,6 +114,7 @@
 #define MIDR_CORTEX_A76	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A76)
 #define MIDR_NEOVERSE_N1 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N1)
 #define MIDR_CORTEX_A77	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A77)
+#define MIDR_CORTEX_A510 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A510)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 24e42bd7d3b7..9a8c086528f5 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4708,6 +4708,8 @@ static long kvm_s390_guest_sida_op(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	if (mop->size + mop->sida_offset > sida_size(vcpu->arch.sie_block))
 		return -E2BIG;
+	if (!kvm_s390_pv_cpu_is_protected(vcpu))
+		return -EINVAL;
 
 	switch (mop->op) {
 	case KVM_S390_MEMOP_SIDA_READ:
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 43f999dba4dc..f3d95af3e428 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1277,3 +1277,4 @@ module_exit(crypto_algapi_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Cryptographic algorithms API");
+MODULE_SOFTDEP("pre: cryptomgr");
diff --git a/crypto/api.c b/crypto/api.c
index c4eda56cff89..5ffcd3ab4a75 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -603,4 +603,3 @@ EXPORT_SYMBOL_GPL(crypto_req_done);
 
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
-MODULE_SOFTDEP("pre: cryptomgr");
diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index 16d1c7a43d33..b6eb75f4bbfc 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -705,12 +705,12 @@ static int moxart_remove(struct platform_device *pdev)
 	if (!IS_ERR_OR_NULL(host->dma_chan_rx))
 		dma_release_channel(host->dma_chan_rx);
 	mmc_remove_host(mmc);
-	mmc_free_host(mmc);
 
 	writel(0, host->base + REG_INTERRUPT_MASK);
 	writel(0, host->base + REG_POWER_CONTROL);
 	writel(readl(host->base + REG_CLOCK_CONTROL) | CLK_OFF,
 	       host->base + REG_CLOCK_CONTROL);
+	mmc_free_host(mmc);
 
 	return 0;
 }
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index f694ee10a0bc..70685cbbec8c 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2690,7 +2690,7 @@ int smb2_open(struct ksmbd_work *work)
 					(struct create_posix *)context;
 				if (le16_to_cpu(context->DataOffset) +
 				    le32_to_cpu(context->DataLength) <
-				    sizeof(struct create_posix)) {
+				    sizeof(struct create_posix) - 4) {
 					rc = -EINVAL;
 					goto err_out1;
 				}
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 09ae8448f394..4e7936d9b442 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -2199,7 +2199,7 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	struct tipc_msg *hdr = buf_msg(skb);
 	struct tipc_gap_ack_blks *ga = NULL;
 	bool reply = msg_probe(hdr), retransmitted = false;
-	u16 dlen = msg_data_sz(hdr), glen = 0;
+	u32 dlen = msg_data_sz(hdr), glen = 0;
 	u16 peers_snd_nxt =  msg_next_sent(hdr);
 	u16 peers_tol = msg_link_tolerance(hdr);
 	u16 peers_prio = msg_linkprio(hdr);
@@ -2213,6 +2213,10 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	void *data;
 
 	trace_tipc_proto_rcv(skb, false, l->name);
+
+	if (dlen > U16_MAX)
+		goto exit;
+
 	if (tipc_link_is_blocked(l) || !xmitq)
 		goto exit;
 
@@ -2308,7 +2312,8 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 
 		/* Receive Gap ACK blocks from peer if any */
 		glen = tipc_get_gap_ack_blks(&ga, l, hdr, true);
-
+		if(glen > dlen)
+			break;
 		tipc_mon_rcv(l->net, data + glen, dlen - glen, l->addr,
 			     &l->mon_state, l->bearer_id);
 
diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 407619697292..2f4d23238a7e 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -496,6 +496,8 @@ void tipc_mon_rcv(struct net *net, void *data, u16 dlen, u32 addr,
 	state->probing = false;
 
 	/* Sanity check received domain record */
+	if (new_member_cnt > MAX_MON_DOMAIN)
+		return;
 	if (dlen < dom_rec_len(arrv_dom, 0))
 		return;
 	if (dlen != dom_rec_len(arrv_dom, new_member_cnt))
