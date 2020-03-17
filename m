Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64AE1188170
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbgCQLCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727963AbgCQLCf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:02:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0780B205ED;
        Tue, 17 Mar 2020 11:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442954;
        bh=aOI3kToA5wIagAX34AwDpXjvrcob4bMDHwZGfFJ9VXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsEh6s4F3M6ybvojw0AIcYLx/XCmkpmaEK0cq0Rk2d+hcU57s+Me5MmrVMu/1rj16
         DrdLPCiDPuMjCsvHeWQeSDAtoP/L5ZupK36TYfZyhUeY3UzVusmP8tYIjIwqGw2MPG
         xeZvkjSpJ7kHuhbupC/XwItQFUabchuWf4PQp1vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 047/123] tipc: add missing attribute validation for MTU property
Date:   Tue, 17 Mar 2020 11:54:34 +0100
Message-Id: <20200317103312.576687018@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 213320a67962ff6e7b83b704d55cbebc341426db ]

Add missing attribute validation for TIPC_NLA_PROP_MTU
to the netlink policy.

Fixes: 901271e0403a ("tipc: implement configuration of UDP media MTU")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/netlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/tipc/netlink.c
+++ b/net/tipc/netlink.c
@@ -111,6 +111,7 @@ const struct nla_policy tipc_nl_prop_pol
 	[TIPC_NLA_PROP_PRIO]		= { .type = NLA_U32 },
 	[TIPC_NLA_PROP_TOL]		= { .type = NLA_U32 },
 	[TIPC_NLA_PROP_WIN]		= { .type = NLA_U32 },
+	[TIPC_NLA_PROP_MTU]		= { .type = NLA_U32 },
 	[TIPC_NLA_PROP_BROADCAST]	= { .type = NLA_U32 },
 	[TIPC_NLA_PROP_BROADCAST_RATIO]	= { .type = NLA_U32 }
 };


