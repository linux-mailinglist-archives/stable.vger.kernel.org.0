Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036AD3FB4DF
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 13:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236527AbhH3MAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236577AbhH3MAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 08:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4676861154;
        Mon, 30 Aug 2021 11:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324786;
        bh=h4s6S/fKS1X94ZYE2zRjyE0IgdC/3AncBjqqAi/i0PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMq9BkpmNIslECyhlrESf6tz4fQEk1iM/eVDiLifuWPnA7/XOg3LkmbtiiyAjOKOj
         6ynp/qp76LZ70KNqbWCbJguZ9CJRK5eKJeUsqlAQ+NI/dUqtHykDPvMk6XCfi0UHZZ
         Qpfsg/1Fc0Xw54UgeIsz0GKOujLEkdhISVJFJE62XwJKi22WhrGQOLyDD80aQid071
         wSg0/46JTjVU0hHI7sGA2ouu+PtlXJPNjIchMUJbdqKprKhfnwpd9tHTZXz5RBb4l8
         Pu2MZxcX+MRmDaDV7lYYywlS2jhtVbR1lqDO9UoeyMBCcNbYhLNnFJH3iFfOjhGaUC
         EQ2uQAaZzbUQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 02/14] reset: reset-zynqmp: Fixed the argument data type
Date:   Mon, 30 Aug 2021 07:59:30 -0400
Message-Id: <20210830115942.1017300-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830115942.1017300-1-sashal@kernel.org>
References: <20210830115942.1017300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>

[ Upstream commit ed104ca4bd9c405b41e968ad4ece51f6462e90b6 ]

This patch changes the data type of the variable 'val' from
int to u32.

Addresses-Coverity: argument of type "int *" is incompatible with parameter of type "u32 *"
Signed-off-by: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/925cebbe4eb73c7d0a536da204748d33c7100d8c.1624448778.git.michal.simek@xilinx.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-zynqmp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/reset/reset-zynqmp.c b/drivers/reset/reset-zynqmp.c
index ebd433fa09dd..8c51768e9a72 100644
--- a/drivers/reset/reset-zynqmp.c
+++ b/drivers/reset/reset-zynqmp.c
@@ -53,7 +53,8 @@ static int zynqmp_reset_status(struct reset_controller_dev *rcdev,
 			       unsigned long id)
 {
 	struct zynqmp_reset_data *priv = to_zynqmp_reset_data(rcdev);
-	int val, err;
+	int err;
+	u32 val;
 
 	err = zynqmp_pm_reset_get_status(priv->data->reset_id + id, &val);
 	if (err)
-- 
2.30.2

