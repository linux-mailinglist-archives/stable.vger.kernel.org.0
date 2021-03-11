Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC02337C6E
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhCKSXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:23:03 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:43267 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229928AbhCKSWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:22:31 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id CFC6719419F4;
        Thu, 11 Mar 2021 13:22:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 11 Mar 2021 13:22:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yCctpw
        c4XRGTuKWDgMMK38seRVYBa9z5iJ9fjh7tOe0=; b=JUaJKFOrYognw/DIVHKMbF
        sij585F5s3bq1jLFgmQq+m1ajI4Ak1GTfo9NrrlsshCPpKVpTxS+YkHShff47cVv
        rt1YSTWXE/DEg9fwxFZUrBdCVpZeYP828KuF22Jcrp/KVohHrljCbHVhm2zRARWB
        socHYu/vDiZLYgC5ppxJprnU1YfqsbMEhtcnl+6GWwKAWvqneQxJDGuqZnufO9s0
        f8NCpz2Z9fKd21fG4BSYJCpNbTpfADyaMvTJkpoxV4S4jabLDCloPc3ct4CEgSaQ
        SHYArtVJFcEBrQ2LCVGYQ/GrRK3r2XHqykxwAxtiEOehm2MI9X5g+BqYhiqf7gNA
        ==
X-ME-Sender: <xms:419KYJ1N2z0kO1Fzz3KqWdRHTsAvzSlSqM7SGh8RRXvuO1i0Q8cIhg>
    <xme:419KYCGF-YzZu6C4nfhHAeFuRdOYcIesRkNegT9sGUNVY7_9cOlp23XyAIFq3mhzd
    5GnYZdLnxt-rQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:419KYDTWuvTyINLcE4NJrJ1XiYzU3Rf9IpQ6Es4qJsGKwuncJVgUyQ>
    <xmx:419KYJDhFEHtT3MpoBcpWSes46bT9vtYFsNSCe0bvUXhIlUuPtrenw>
    <xmx:419KYD1X9gpcHwowUEpSRPAY_65VryCHMkRAirhlYpXMvEUKYG_6Aw>
    <xmx:419KYJhTaXCWZ1FB7nwdrN_3IK-3irNLP56lZw7uDtBHT3eauKJR9A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8287124005B;
        Thu, 11 Mar 2021 13:22:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] tcp: add sanity tests to TCP_QUEUE_SEQ" failed to apply to 4.4-stable tree
To:     edumazet@google.com, davem@davemloft.net,
        ieatmuttonchuan@gmail.com, xemul@parallels.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:22:22 +0100
Message-ID: <16154869425242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8811f4a9836e31c14ecdf79d9f3cb7c5d463265d Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 1 Mar 2021 10:29:17 -0800
Subject: [PATCH] tcp: add sanity tests to TCP_QUEUE_SEQ

Qingyu Li reported a syzkaller bug where the repro
changes RCV SEQ _after_ restoring data in the receive queue.

mprotect(0x4aa000, 12288, PROT_READ)    = 0
mmap(0x1ffff000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x1ffff000
mmap(0x20000000, 16777216, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x20000000
mmap(0x21000000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x21000000
socket(AF_INET6, SOCK_STREAM, IPPROTO_IP) = 3
setsockopt(3, SOL_TCP, TCP_REPAIR, [1], 4) = 0
connect(3, {sa_family=AF_INET6, sin6_port=htons(0), sin6_flowinfo=htonl(0), inet_pton(AF_INET6, "::1", &sin6_addr), sin6_scope_id=0}, 28) = 0
setsockopt(3, SOL_TCP, TCP_REPAIR_QUEUE, [1], 4) = 0
sendmsg(3, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="0x0000000000000003\0\0", iov_len=20}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 20
setsockopt(3, SOL_TCP, TCP_REPAIR, [0], 4) = 0
setsockopt(3, SOL_TCP, TCP_QUEUE_SEQ, [128], 4) = 0
recvfrom(3, NULL, 20, 0, NULL, NULL)    = -1 ECONNRESET (Connection reset by peer)

syslog shows:
[  111.205099] TCP recvmsg seq # bug 2: copied 80, seq 0, rcvnxt 80, fl 0
[  111.207894] WARNING: CPU: 1 PID: 356 at net/ipv4/tcp.c:2343 tcp_recvmsg_locked+0x90e/0x29a0

This should not be allowed. TCP_QUEUE_SEQ should only be used
when queues are empty.

This patch fixes this case, and the tx path as well.

Fixes: ee9952831cfd ("tcp: Initial repair mode")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=212005
Reported-by: Qingyu Li <ieatmuttonchuan@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index dfb6f286c1de..de7cc8445ac0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3469,16 +3469,23 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case TCP_QUEUE_SEQ:
-		if (sk->sk_state != TCP_CLOSE)
+		if (sk->sk_state != TCP_CLOSE) {
 			err = -EPERM;
-		else if (tp->repair_queue == TCP_SEND_QUEUE)
-			WRITE_ONCE(tp->write_seq, val);
-		else if (tp->repair_queue == TCP_RECV_QUEUE) {
-			WRITE_ONCE(tp->rcv_nxt, val);
-			WRITE_ONCE(tp->copied_seq, val);
-		}
-		else
+		} else if (tp->repair_queue == TCP_SEND_QUEUE) {
+			if (!tcp_rtx_queue_empty(sk))
+				err = -EPERM;
+			else
+				WRITE_ONCE(tp->write_seq, val);
+		} else if (tp->repair_queue == TCP_RECV_QUEUE) {
+			if (tp->rcv_nxt != tp->copied_seq) {
+				err = -EPERM;
+			} else {
+				WRITE_ONCE(tp->rcv_nxt, val);
+				WRITE_ONCE(tp->copied_seq, val);
+			}
+		} else {
 			err = -EINVAL;
+		}
 		break;
 
 	case TCP_REPAIR_OPTIONS:

