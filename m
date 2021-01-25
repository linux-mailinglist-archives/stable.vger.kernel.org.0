Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797BA302730
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 16:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbhAYPr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 10:47:59 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:42257 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730452AbhAYPrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 10:47:55 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 53808E0B;
        Mon, 25 Jan 2021 10:17:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 25 Jan 2021 10:17:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5jaDXP
        oigUVchXSke2tMO7JZ5pLWNvXTNZH5rrAGbvM=; b=B3IPOswUSc0dSxBe4HTYz6
        Y3Dyrq9/wYRyz8wC+hIkzfUUrSA4VH9tjsjR8XUcufDwKB+nqV6TBVgWxTAXnGT2
        H61msfkaJqP/4s9eF6SEhqThZJ6zfBbBDqvT4EX71rJsUysfSCRkZ7IDbl4lRbMt
        +TGcqN08AAo/PoqH+nGk9vjfXd+QBWo84lMUQonDe+zBT9ZUpcidsiF/CfldKh/B
        vnUz3aRLQueC5zB3Ga2CWnFsQiuO0omoZwa+PCOvSrJI9kHRHZPZa4qWbayiDjLa
        BwWhcEBWUKIPDZJA+xGZSBh/wVc+mQ9U9CS81LIcKWR/A/jXfUK5MvZ/xniA5KhQ
        ==
X-ME-Sender: <xms:IuEOYLhRoopyXvG8woMUklb3RArzIYVaaLMjlp_nzpTjIBXm7R_uzw>
    <xme:IuEOYIA3HgrTcVfR7TOgG6WYBPftsysSEE3Yh35V1ZCRdXDMKHVEuhbw56dQ8Kczm
    B63cENL-8WfNg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:IuEOYLH5GpZU6yBaofUDzYtZpdIJaKhvG8kibY1_-deSmgmYDGZFlg>
    <xmx:IuEOYITC4BcRheheTmHF4t2WYk2er6w4UNrIDOJDW8_GaiNCwwcHVQ>
    <xmx:IuEOYIwuaR8kqljifCHQ3lBs7T_5YNMPtA5XaIeZuhQxfNBAwSARPA>
    <xmx:IuEOYD8Bf8uFFZ410DipwOyzvX5l-83JtgnYaIlhxpCBMLRx0kIrYJMO_sM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9D3CF1080068;
        Mon, 25 Jan 2021 10:17:54 -0500 (EST)
Subject: FAILED: patch "[PATCH] net_sched: reject silly cell_log in qdisc_get_rtab()" failed to apply to 4.9-stable tree
To:     edumazet@google.com, cong.wang@bytedance.com, kuba@kernel.org,
        syzkaller@googlegroups.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 16:17:44 +0100
Message-ID: <1611587864135158@kroah.com>
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

From e4bedf48aaa5552bc1f49703abd17606e7e6e82a Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 14 Jan 2021 08:06:37 -0800
Subject: [PATCH] net_sched: reject silly cell_log in qdisc_get_rtab()

iproute2 probably never goes beyond 8 for the cell exponent,
but stick to the max shift exponent for signed 32bit.

UBSAN reported:
UBSAN: shift-out-of-bounds in net/sched/sch_api.c:389:22
shift exponent 130 is too large for 32-bit type 'int'
CPU: 1 PID: 8450 Comm: syz-executor586 Not tainted 5.11.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x183/0x22e lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:148 [inline]
 __ubsan_handle_shift_out_of_bounds+0x432/0x4d0 lib/ubsan.c:395
 __detect_linklayer+0x2a9/0x330 net/sched/sch_api.c:389
 qdisc_get_rtab+0x2b5/0x410 net/sched/sch_api.c:435
 cbq_init+0x28f/0x12c0 net/sched/sch_cbq.c:1180
 qdisc_create+0x801/0x1470 net/sched/sch_api.c:1246
 tc_modify_qdisc+0x9e3/0x1fc0 net/sched/sch_api.c:1662
 rtnetlink_rcv_msg+0xb1d/0xe60 net/core/rtnetlink.c:5564
 netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x7de/0x9b0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0xaa6/0xe90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x5a2/0x900 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x319/0x400 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Cong Wang <cong.wang@bytedance.com>
Link: https://lore.kernel.org/r/20210114160637.1660597-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 51cb553e4317..6fe4e5cc807c 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -412,7 +412,8 @@ struct qdisc_rate_table *qdisc_get_rtab(struct tc_ratespec *r,
 {
 	struct qdisc_rate_table *rtab;
 
-	if (tab == NULL || r->rate == 0 || r->cell_log == 0 ||
+	if (tab == NULL || r->rate == 0 ||
+	    r->cell_log == 0 || r->cell_log >= 32 ||
 	    nla_len(tab) != TC_RTAB_SIZE) {
 		NL_SET_ERR_MSG(extack, "Invalid rate table parameters for searching");
 		return NULL;

