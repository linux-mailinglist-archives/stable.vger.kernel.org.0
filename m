Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94720148305
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404482AbgAXLcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:32:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:51800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404457AbgAXLco (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:32:44 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FC012077C;
        Fri, 24 Jan 2020 11:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865564;
        bh=l4Ses8rqDTCAA4Ztph6uswTprIih94TV2bALSpRD3ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TtYT9pXMHrNqusDe/A/i9eyzqb81j9HkVpbyDdTXlobdFRHK2UzxMeJsOD6MvLxyh
         tK+0AbVpRcwLZshuvCvxFwyJT6yd6+rT0afIrP1DixzoDwjVxYKHzhGJjz83UinuRa
         HNI+ouAgZX5soFSrEVR0E3jkVyEKYYLseioFkEC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gerd Rausch <gerd.rausch@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 564/639] net/rds: Fix ib_evt_handler_call element in rds_ib_stat_names
Date:   Fri, 24 Jan 2020 10:32:14 +0100
Message-Id: <20200124093159.995153880@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerd Rausch <gerd.rausch@oracle.com>

[ Upstream commit 05a82481a3024b94db00b8c816bb3d526b5209e0 ]

All entries in 'rds_ib_stat_names' are stringified versions
of the corresponding "struct rds_ib_statistics" element
without the "s_"-prefix.

Fix entry 'ib_evt_handler_call' to do the same.

Fixes: f4f943c958a2 ("RDS: IB: ack more receive completions to improve performance")
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/ib_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/ib_stats.c b/net/rds/ib_stats.c
index 9252ad1263359..ac46d8961b61a 100644
--- a/net/rds/ib_stats.c
+++ b/net/rds/ib_stats.c
@@ -42,7 +42,7 @@ DEFINE_PER_CPU_SHARED_ALIGNED(struct rds_ib_statistics, rds_ib_stats);
 static const char *const rds_ib_stat_names[] = {
 	"ib_connect_raced",
 	"ib_listen_closed_stale",
-	"s_ib_evt_handler_call",
+	"ib_evt_handler_call",
 	"ib_tasklet_call",
 	"ib_tx_cq_event",
 	"ib_tx_ring_full",
-- 
2.20.1



