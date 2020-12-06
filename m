Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840612D0240
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 10:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgLFJbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 04:31:40 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:35267 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbgLFJbk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 04:31:40 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id D29151943BDC;
        Sun,  6 Dec 2020 04:30:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 06 Dec 2020 04:30:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ueAYmI
        7pKWR41x1efgQz9ZmRasEvXqpxa+4CesAYUls=; b=DKrjJYIbDfXIku9roeKHVl
        7jSZfh1EoBauWz71g2nsnWZxMFrdbwq+wiB9sUvJ9gCdr7A4a3ZwhU2w+S7WcdRs
        FXNJYw4auk8Cexr23Zr0sb3aDxAohPwT5bj9zvZdihmot9t7nTsfoMTZl7fJeCFL
        OvEta320npLpcyzQ3LE0wKhBxJbTOliLEJuQQlJCUcg23jifCj5hS6oqLlpfbH1t
        FBFOD9FzGo4AYIJTz4Ep2Ie6AoMuZFL5z+Pw+uPV+DGrn2XeqTyTOv61EBKk5VcV
        n1d54AGcx4W7FE0JO6iVoPJkyE+hQ4W/DhDCD4VLamp3EI9W66gxw575owTK8d8A
        ==
X-ME-Sender: <xms:zaTMX9V_T7A_bBlXC-4TpmtdDS7bXI_9m2k9rf-vKuQFpfrHQLSH4w>
    <xme:zaTMX9nnBFX7QHe-b7r9MJbDxH5UIPJVfQT3y1OOeVg0m0jGzTpijjQadt4hMbFya
    NaiwWp_Ndtxqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejvddgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:zaTMX5YF0HwG7bbsfwV_iqI6VGgSohBL9ghFwGwcwu1l4HrhODFhGQ>
    <xmx:zaTMXwWRwogDx9MtQtDTPBx9OhC5rUNk__BG1EkamrpoiABE3_lS2Q>
    <xmx:zaTMX3kBAkxC3wOFPNhqFe7VdKm9ENG5tmrvznBgV-4sAg2X385ARA>
    <xmx:zaTMX_vXNqVNn5rFMuOvJRINXtr5lyeWHZngJcdx4wEA0zSsr7p9pg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EB925108005B;
        Sun,  6 Dec 2020 04:30:52 -0500 (EST)
Subject: FAILED: patch "[PATCH] geneve: pull IP header before ECN decapsulation" failed to apply to 4.9-stable tree
To:     edumazet@google.com, kuba@kernel.org, syzkaller@googlegroups.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 06 Dec 2020 10:32:06 +0100
Message-ID: <16072471265931@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4179b00c04d18ea7013f68d578d80f3c9d13150a Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 1 Dec 2020 01:05:07 -0800
Subject: [PATCH] geneve: pull IP header before ECN decapsulation

IP_ECN_decapsulate() and IP6_ECN_decapsulate() assume
IP header is already pulled.

geneve does not ensure this yet.

Fixing this generically in IP_ECN_decapsulate() and
IP6_ECN_decapsulate() is not possible, since callers
pass a pointer that might be freed by pskb_may_pull()

syzbot reported :

BUG: KMSAN: uninit-value in __INET_ECN_decapsulate include/net/inet_ecn.h:238 [inline]
BUG: KMSAN: uninit-value in INET_ECN_decapsulate+0x345/0x1db0 include/net/inet_ecn.h:260
CPU: 1 PID: 8941 Comm: syz-executor.0 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 __INET_ECN_decapsulate include/net/inet_ecn.h:238 [inline]
 INET_ECN_decapsulate+0x345/0x1db0 include/net/inet_ecn.h:260
 geneve_rx+0x2103/0x2980 include/net/inet_ecn.h:306
 geneve_udp_encap_recv+0x105c/0x1340 drivers/net/geneve.c:377
 udp_queue_rcv_one_skb+0x193a/0x1af0 net/ipv4/udp.c:2093
 udp_queue_rcv_skb+0x282/0x1050 net/ipv4/udp.c:2167
 udp_unicast_rcv_skb net/ipv4/udp.c:2325 [inline]
 __udp4_lib_rcv+0x399d/0x5880 net/ipv4/udp.c:2394
 udp_rcv+0x5c/0x70 net/ipv4/udp.c:2564
 ip_protocol_deliver_rcu+0x572/0xc50 net/ipv4/ip_input.c:204
 ip_local_deliver_finish net/ipv4/ip_input.c:231 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_local_deliver+0x583/0x8d0 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:449 [inline]
 ip_rcv_finish net/ipv4/ip_input.c:428 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_rcv+0x5c3/0x840 net/ipv4/ip_input.c:539
 __netif_receive_skb_one_core net/core/dev.c:5315 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5429
 process_backlog+0x523/0xc10 net/core/dev.c:6319
 napi_poll+0x420/0x1010 net/core/dev.c:6763
 net_rx_action+0x35c/0xd40 net/core/dev.c:6833
 __do_softirq+0x1a9/0x6fa kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0x6e/0x90 arch/x86/kernel/irq_64.c:77
 do_softirq kernel/softirq.c:343 [inline]
 __local_bh_enable_ip+0x184/0x1d0 kernel/softirq.c:195
 local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
 rcu_read_unlock_bh include/linux/rcupdate.h:730 [inline]
 __dev_queue_xmit+0x3a9b/0x4520 net/core/dev.c:4167
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4173
 packet_snd net/packet/af_packet.c:2992 [inline]
 packet_sendmsg+0x86f9/0x99d0 net/packet/af_packet.c:3017
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 __sys_sendto+0x9dc/0xc80 net/socket.c:1992
 __do_sys_sendto net/socket.c:2004 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:2000
 __x64_sys_sendto+0x6e/0x90 net/socket.c:2000
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 2d07dc79fe04 ("geneve: add initial netdev driver for GENEVE tunnels")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20201201090507.4137906-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 1426bfc009bc..8ae9ce2014a4 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -257,11 +257,21 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
 		skb_dst_set(skb, &tun_dst->dst);
 
 	/* Ignore packet loops (and multicast echo) */
-	if (ether_addr_equal(eth_hdr(skb)->h_source, geneve->dev->dev_addr)) {
-		geneve->dev->stats.rx_errors++;
-		goto drop;
-	}
+	if (ether_addr_equal(eth_hdr(skb)->h_source, geneve->dev->dev_addr))
+		goto rx_error;
 
+	switch (skb_protocol(skb, true)) {
+	case htons(ETH_P_IP):
+		if (pskb_may_pull(skb, sizeof(struct iphdr)))
+			goto rx_error;
+		break;
+	case htons(ETH_P_IPV6):
+		if (pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+			goto rx_error;
+		break;
+	default:
+		goto rx_error;
+	}
 	oiph = skb_network_header(skb);
 	skb_reset_network_header(skb);
 
@@ -298,6 +308,8 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
 		dev_sw_netstats_rx_add(geneve->dev, len);
 
 	return;
+rx_error:
+	geneve->dev->stats.rx_errors++;
 drop:
 	/* Consume bad packet */
 	kfree_skb(skb);

