Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3FA337C63
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhCKSWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:22:32 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:33853 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229806AbhCKSWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:22:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8B5D719419F6;
        Thu, 11 Mar 2021 13:22:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:22:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Q0ITY2
        Q+OyG/yTH70GfiZKdIG28cLOr1zZwHDfLvVmE=; b=Hwp7a2+uSPJ0WMavPxGvUk
        8Nu9Ic2ydHBTTGEHRMdmmZaH7FiLurI2JS/byCBU48/RbRie+UYDLr5H66aXSLzy
        Px7Kbze8yrcdB2oPit3FL2qezIWh3v8Xj5uaVXsSPv8u41bWdBxPdrkXT0powWmZ
        YqpoTMt8FjH+b/5v3oioIaSl58tEH5MjjXEUnF/DiI9I5cX+X1nj396cD5ER8log
        9ddieCAbFlghQ2IZ6pmIcKlWc3Rsjvv70BBNZpxOW9NmswlGvp0DWXiKk7YtfbMN
        6Fsasu6O4645ZKXMAx9nRMxV+GTEgjPlK4P5RMGK2gAaAg5jg5RavkIz52f/8+xA
        ==
X-ME-Sender: <xms:4F9KYJxCkas9lI3vncW6dZUKwnjtTpgx-dNRJk1UAUpVzM_18JE3wQ>
    <xme:4F9KYJSgd4aS5Ak9_mgVJeJADrisUn_mke1sn-pTuPk8Y_G6A8DaH5kRfdftBbrnr
    fcZU5uHhfIaOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:4F9KYDWvBBPTpkPO-VoH541mg7oq3f8DrSXDhHMQ4TnBvPJdoWJI3w>
    <xmx:4F9KYLijJw6duoHblGB7nmdUr1MSBCe-Ii02e1JdjQWQ0lLCZrfojw>
    <xmx:4F9KYLDJ21141znGSsrKO_zhbCOhiFWpTVU7ES_7rJ8wawgIUn7IPg>
    <xmx:4F9KYONc1M4irnReJGmdWhZzx1nqm94EiIsp9VuYRY1_C1ydRngqEw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2152124005B;
        Thu, 11 Mar 2021 13:22:24 -0500 (EST)
Subject: FAILED: patch "[PATCH] tcp: add sanity tests to TCP_QUEUE_SEQ" failed to apply to 4.14-stable tree
To:     edumazet@google.com, davem@davemloft.net,
        ieatmuttonchuan@gmail.com, xemul@parallels.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:22:20 +0100
Message-ID: <161548694018@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

