Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 615BF147DAE
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388947AbgAXKCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:02:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388944AbgAXKCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:02:45 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB429206D5;
        Fri, 24 Jan 2020 10:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860164;
        bh=n7Dxbm6t548y2aRIJm/87HDLAthkUP1D6Haxu98aAJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UYwqs0QzDQ+x6aTNu9jcczFnZ8MVKcwWdstTgTMCVp425HLeXPeTOPtY+VwkXWgN9
         Px0jOt6FFDtvO+tgeognGEJEpP/GUA9PM7gMcWZTnyoRKAXfBhMWQCouUkErRag4Bg
         LhlLPZI2xJqxLqVl54svpgYyxItG0oqDC+2pkzok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gerd Rausch <gerd.rausch@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 273/343] net/rds: Add a few missing rds_stat_names entries
Date:   Fri, 24 Jan 2020 10:31:31 +0100
Message-Id: <20200124092955.815143020@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerd Rausch <gerd.rausch@oracle.com>

[ Upstream commit 55c70ca00c982fbc0df4c4d3e31747fb73f4ddb5 ]

In a previous commit, fields were added to "struct rds_statistics"
but array "rds_stat_names" was not updated accordingly.

Please note the inconsistent naming of the string representations
that is done in the name of compatibility
with the Oracle internal code-base.

s_recv_bytes_added_to_socket     -> "recv_bytes_added_to_sock"
s_recv_bytes_removed_from_socket -> "recv_bytes_freed_fromsock"

Fixes: 192a798f5299 ("RDS: add stat for socket recv memory usage")
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/stats.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rds/stats.c b/net/rds/stats.c
index 73be187d389ed..6bbab4d74c4fe 100644
--- a/net/rds/stats.c
+++ b/net/rds/stats.c
@@ -76,6 +76,8 @@ static const char *const rds_stat_names[] = {
 	"cong_update_received",
 	"cong_send_error",
 	"cong_send_blocked",
+	"recv_bytes_added_to_sock",
+	"recv_bytes_freed_fromsock",
 };
 
 void rds_stats_info_copy(struct rds_info_iterator *iter,
-- 
2.20.1



