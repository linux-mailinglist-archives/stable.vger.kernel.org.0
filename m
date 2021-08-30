Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732D43FB51A
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbhH3MBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236821AbhH3MB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 08:01:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4141161152;
        Mon, 30 Aug 2021 12:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324821;
        bh=uVG2v8bfcSk5/pw52dsj3vnO+YA9NzC4WrsjQDWfGwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrVcWtYOwmEONtY0N4LGYCWvHtVUgSgT0rAJj7VxacRrOG1mWlrhtl7kNm/sBrH0J
         iOAnQracQGg4ox1CivkWf7uYfAfSLIvnv1Bwwo0G9GFgtrVaxFxQl1Gq082mN1RwzI
         cMI8k/Ge/6RbzkDjPILM84/J2MEFMkrHpK6mo0iVNPbICuGTYjfhiSh02iunhHmRxq
         wLz3NNC5+UvCxYu4dHcHu/+/s1CM54LhMA57YbipDy6wBs3SkEnWjjk0k7niBqweWD
         5mIJBSLqcfV5Qft6sh5ml5hxMgRePzU/BAECHsRQpld9VEooc/+1CYPhLNVSseL3wq
         JqwyoAaMdjYHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 02/10] reset: reset-zynqmp: Fixed the argument data type
Date:   Mon, 30 Aug 2021 08:00:09 -0400
Message-Id: <20210830120018.1017841-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830120018.1017841-1-sashal@kernel.org>
References: <20210830120018.1017841-1-sashal@kernel.org>
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
index 99e75d92dada..8a7473b6ba58 100644
--- a/drivers/reset/reset-zynqmp.c
+++ b/drivers/reset/reset-zynqmp.c
@@ -46,7 +46,8 @@ static int zynqmp_reset_status(struct reset_controller_dev *rcdev,
 			       unsigned long id)
 {
 	struct zynqmp_reset_data *priv = to_zynqmp_reset_data(rcdev);
-	int val, err;
+	int err;
+	u32 val;
 
 	err = priv->eemi_ops->reset_get_status(ZYNQMP_RESET_ID + id, &val);
 	if (err)
-- 
2.30.2

