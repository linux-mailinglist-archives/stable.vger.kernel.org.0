Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F4539E311
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbhFGQUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231984AbhFGQSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:18:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3910A61585;
        Mon,  7 Jun 2021 16:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082474;
        bh=nQEK1x9e3y2124hqECKJ2gGbWsIfNf0Y6BDmEwsR0N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGjXE40GwmxlG23yZvqNmQXSsO3Mm8v91dNkwRjV/IlKmfaK8OKXKycGiRUFuHq3i
         Vw8HDbKX5rKCYkwf2uCQ9DWyTXViXCpOOHMx0Cu3HKjJP1vBHYG7dtxy4NPCs3Q61R
         ORTLHJpj8Nz5znecqqSm04D+j42q3F5MaMWXGBjPnNPv63vCVfcyyNLGpncnW9CMHc
         88415TmWXnl9YyxM0dt2IC/RMpD5K7hOsWAUw/qAhEsGKKAdr3wVeDOacJork7nF3u
         1qNS/spnb2wgqR1LZ2noc9EEiMBXXX4Xv9pHbivsLBcKKMnwxLpr3ps79qqWfZAFOp
         zmUcdI0EWXYOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/29] scsi: scsi_devinfo: Add blacklist entry for HPE OPEN-V
Date:   Mon,  7 Jun 2021 12:14:00 -0400
Message-Id: <20210607161410.3584036-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
MIME-Version: 1.0
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
index fb5a7832353c..7f76bf5cc8a8 100644
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

