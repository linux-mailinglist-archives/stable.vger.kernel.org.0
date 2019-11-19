Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4BA101924
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfKSFU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:20:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:35352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbfKSFU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:20:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD72522319;
        Tue, 19 Nov 2019 05:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140857;
        bh=avfu55Y2iDIi0f8VzZAaA4QFY5w/y4Xlk4OEvEcrJ1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nL9TYp91LFnRAGc3ia74XrlWj0qqeNzEF2AN3aJGc5coT+Hr5ZyWa2BVhvxeaprnH
         i/wg/tcEEwpDoS0rJQA69KhuKsw2+qG+0rSTGDHPqjkvNxrwhSV7EzI/O4eUC820Vh
         a31PP/cOiTIJjkvGX6WSAluTy7SuSkkcJQRAqSsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 10/48] tcp: remove redundant new line from tcp_event_sk_skb
Date:   Tue, 19 Nov 2019 06:19:30 +0100
Message-Id: <20191119050956.866669523@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lu <tonylu@linux.alibaba.com>

[ Upstream commit dd3d792def0d4f33bbf319982b1878b0c8aaca34 ]

This removes '\n' from trace event class tcp_event_sk_skb to avoid
redundant new blank line and make output compact.

Fixes: af4325ecc24f ("tcp: expose sk_state in tcp_retransmit_skb tracepoint")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/tcp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -86,7 +86,7 @@ DECLARE_EVENT_CLASS(tcp_event_sk_skb,
 			      sk->sk_v6_rcv_saddr, sk->sk_v6_daddr);
 	),
 
-	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c state=%s\n",
+	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c state=%s",
 		  __entry->sport, __entry->dport, __entry->saddr, __entry->daddr,
 		  __entry->saddr_v6, __entry->daddr_v6,
 		  show_tcp_state_name(__entry->state))


