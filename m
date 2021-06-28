Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BBF3B6220
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhF1OmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235532AbhF1OkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:40:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 758FB61C7D;
        Mon, 28 Jun 2021 14:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890798;
        bh=19gHSXIC60dW7zaarG7N+n9aQV6RB3qn7dlkVnqB2sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9MWrheZUIT5pZ7X1WWBmdBh0YaBp3nvlaxoxX/nLIQTIev3fIF4cDTyTd1R26s2A
         B6+8gxSQcx79IBwYyem7SiMh66jkejBbXGyqHBn8YcSBiyptUeMd4CVtRAmjEMGuXg
         N1nGVuFjrp2ludKkmetpQSYGZi7mOlwLGS537quB1T2Bu+pOBhi9SYJ1SaR99NuW95
         KY2dTJuPBGEY9q7u2TIi4lUk6HpO2m8yRekArKhdjsoN6WVTibjusxpDsbTxxtjIrE
         5E82jPYTicLlc2uzRPl+WaugST4fwkjh9BoIHkCYIQ3R7eroVrBmqlMQI+GcpxkxXf
         fj4vsQIQW9AEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 012/109] scsi: scsi_devinfo: Add blacklist entry for HPE OPEN-V
Date:   Mon, 28 Jun 2021 10:31:28 -0400
Message-Id: <20210628143305.32978-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

[ Upstream commit e57f5cd99ca60cddf40201b0f4ced9f1938e299c ]

Apparently some arrays are now returning "HPE" as the vendor.

Link: https://lore.kernel.org/r/20210601175214.25719-1-emilne@redhat.com
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index a08ff3bd6310..6a2a413cc97e 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -184,6 +184,7 @@ static struct {
 	{"HP", "C3323-300", "4269", BLIST_NOTQ},
 	{"HP", "C5713A", NULL, BLIST_NOREPORTLUN},
 	{"HP", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
+	{"HPE", "OPEN-", "*", BLIST_REPORTLUN2 | BLIST_TRY_VPD_PAGES},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
-- 
2.30.2

