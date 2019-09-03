Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65217A6EE1
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbfICQ3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:29:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730090AbfICQ3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:29:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 506C8238CD;
        Tue,  3 Sep 2019 16:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528151;
        bh=sCWWtZ/2SA16IOUYZsBLM7a63wm5H+Q88Mz4isz8S1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYxWfVaoW4rQTaMlLyJWuB6lwJEuapdmTqjmxK2U8zz5mk6Pv0PAFx/JHhTJzyoRi
         jjgmcZnsOPDNLm4YNLibQ5oIrOgwopC6r8NAga6HSF3yjI9DXQEZMPebRHcxXPYAMh
         TWOCulwaDscvPEuMide68EZD23neaY/AbZ6gpPTc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Sergey Gorenko <sergeygo@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Laurence Oberman <loberman@redhat.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 139/167] RDMA/srp: Document srp_parse_in() arguments
Date:   Tue,  3 Sep 2019 12:24:51 -0400
Message-Id: <20190903162519.7136-139-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit e37df2d5b569390e3b80ebed9a73fd5b9dcda010 ]

This patch avoids that a warning is reported when building with W=1.

Cc: Sergey Gorenko <sergeygo@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2c1114ee0c6da..9da30d88a615e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3401,6 +3401,9 @@ static const match_table_t srp_opt_tokens = {
 
 /**
  * srp_parse_in - parse an IP address and port number combination
+ * @net:	   [in]  Network namespace.
+ * @sa:		   [out] Address family, IP address and port number.
+ * @addr_port_str: [in]  IP address and port number.
  *
  * Parse the following address formats:
  * - IPv4: <ip_address>:<port>, e.g. 1.2.3.4:5.
-- 
2.20.1

