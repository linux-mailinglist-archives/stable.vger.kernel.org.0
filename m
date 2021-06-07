Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA7A39E360
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhFGQXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232288AbhFGQVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:21:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F34886140C;
        Mon,  7 Jun 2021 16:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082505;
        bh=19gHSXIC60dW7zaarG7N+n9aQV6RB3qn7dlkVnqB2sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZbCkgu9SOwh9ILZX+TYDCQYlEbt74nkNqZcH4Zr27kf/lD8quwXTSMETVy9ZQPk4b
         YkOfFAUb3xVrKpF3sM7OAyCUcSsDfWfmWVmt64RfxTGJZPX/Jz2GNkESCwFuH7yUCT
         QWB7SdAfeyciHAFv3EZ21WeKp9UwMDO5Yz1FakS53KJXonE6MMhc7yx5z7AX4zEreY
         OBnKcoHkYZt56DTMY3sVNrzMY5ew8AaTRaV+inqlZoPStukMDG1cCWAQ631mZES3UI
         y0XKaqRRrWdLlLtv0xU9ipIcO+jBR50cFdcFo51iQx/hJgsGHakgbf0azZF/jjS563
         JB/vI/1O2eRPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/21] scsi: scsi_devinfo: Add blacklist entry for HPE OPEN-V
Date:   Mon,  7 Jun 2021 12:14:40 -0400
Message-Id: <20210607161448.3584332-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161448.3584332-1-sashal@kernel.org>
References: <20210607161448.3584332-1-sashal@kernel.org>
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

