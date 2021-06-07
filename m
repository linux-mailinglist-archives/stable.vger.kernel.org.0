Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DE339E28B
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhFGQRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232291AbhFGQQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:16:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21A5461463;
        Mon,  7 Jun 2021 16:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082430;
        bh=0pX1k/xoHWn6byGeiRZWcn55c8+q9SC9H4ofULQgfKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3Kp2GOtvgIlV38IECf6tPvnXnWmX44HQP4PlFcgikni24PxTxetGQ8EhIRB25dwH
         1xwePLJfWKwetow4KB4jd9dxLCB19S1ZVS3s1ftxdZe3XTch+3SMT3BWr9mBboz85n
         zdwO35jw+Z4e+G5UF1aqeVYO9XXW01AwhxQ9JOjm+DnBYIuCHtrGSj7xPo37QMkUVb
         TPGWRISe9/1Nux83QowzlsOOQGM8GuFd4WErXUngMCaxr0WMeTZd7wbUAeC72gQQ83
         EV/+kLfKwMwciUvnct4jabHX1e8U9gms/ZdCUquEyM9WFRv5Iz10pFGMQ/gHFB6Kxp
         yUq98fnxgFBog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 25/39] scsi: scsi_devinfo: Add blacklist entry for HPE OPEN-V
Date:   Mon,  7 Jun 2021 12:13:04 -0400
Message-Id: <20210607161318.3583636-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
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
index ba84244c1b4f..9a8f9f902f3b 100644
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

