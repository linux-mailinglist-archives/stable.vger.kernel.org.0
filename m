Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597A521F533
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgGNOoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:44:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728833AbgGNOjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 10:39:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AA5A2253A;
        Tue, 14 Jul 2020 14:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594737551;
        bh=cToFvjwH/rD41ff8mryTBGVqToQbljdz/cOulN4Cwqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yax5IgWc9zLyDzpAQqcPs/DTiQYX5tuu8qBCRx+IG37s3eG1w5Z1pFC/5NUAZUjmq
         JeEHIvko+pEguLnp+USNy0x0W0xYBtAWg3dPCc+gUlem/bMokntE3iI0Y5oRL609wl
         MIwLVy1btGz0EK0AQWejoDTKTRI5d3ihk+JNamqE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve Schremmer <steve.schremmer@netapp.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 17/19] scsi: dh: Add Fujitsu device to devinfo and dh lists
Date:   Tue, 14 Jul 2020 10:38:47 -0400
Message-Id: <20200714143849.4035283-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200714143849.4035283-1-sashal@kernel.org>
References: <20200714143849.4035283-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Schremmer <steve.schremmer@netapp.com>

[ Upstream commit e094fd346021b820f37188aaa6b502c7490ab5b5 ]

Add FUJITSU ETERNUS_AHB

Link: https://lore.kernel.org/r/DM6PR06MB5276CCA765336BD312C4282E8C660@DM6PR06MB5276.namprd06.prod.outlook.com
Signed-off-by: Steve Schremmer <steve.schremmer@netapp.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 drivers/scsi/scsi_dh.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index eed31021e7885..ba84244c1b4f6 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -239,6 +239,7 @@ static struct {
 	{"LSI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"ENGENIO", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"LENOVO", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"FUJITSU", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"SanDisk", "Cruzer Blade", NULL, BLIST_TRY_VPD_PAGES |
 		BLIST_INQUIRY_36},
 	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN | BLIST_INQUIRY_36},
diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 42f0550d6b11f..6f41e4b5a2b85 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -63,6 +63,7 @@ static const struct scsi_dh_blist scsi_dh_blist[] = {
 	{"LSI", "INF-01-00",		"rdac", },
 	{"ENGENIO", "INF-01-00",	"rdac", },
 	{"LENOVO", "DE_Series",		"rdac", },
+	{"FUJITSU", "ETERNUS_AHB",	"rdac", },
 	{NULL, NULL,			NULL },
 };
 
-- 
2.25.1

