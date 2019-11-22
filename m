Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD50106403
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbfKVGOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:14:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729187AbfKVGOU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:14:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE58A20707;
        Fri, 22 Nov 2019 06:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403259;
        bh=v2yq6QuBQJWjhwP+bGg0C5drFr5wc3WHgW3vI2tG9V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9G61iSVM2qLV2TX+OVljOYZomPg/5KVEbfGJZJQ2e8zbSqvS7tZl2kl8ilkjVBhr
         pXIi+CqI3bk+t65h/jR2rr/ESmARhHA4ptOo/dhb5NJg0yYzuvzmTma4P7utWrVgzV
         L1rPXhOslnOQkvE2puOOhidLaJZ1bvdHJaMO97Io=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-mtd@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 68/68] mtd: Remove a debug trace in mtdpart.c
Date:   Fri, 22 Nov 2019 01:13:01 -0500
Message-Id: <20191122061301.4947-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <bbrezillon@kernel.org>

[ Upstream commit bda2ab56356b9acdfab150f31c4bac9846253092 ]

Commit 2b6f0090a333 ("mtd: Check add_mtd_device() ret code") contained
a leftover of the debug session that led to this bug fix. Remove this
pr_info().

Fixes: 2b6f0090a333 ("mtd: Check add_mtd_device() ret code")
Signed-off-by: Boris Brezillon <bbrezillon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdpart.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 9b48be05cd1af..59772510452a5 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -624,7 +624,6 @@ int mtd_add_partition(struct mtd_info *master, const char *name,
 	mutex_unlock(&mtd_partitions_mutex);
 
 	free_partition(new);
-	pr_info("%s:%i\n", __func__, __LINE__);
 
 	return ret;
 }
-- 
2.20.1

