Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC36EFA35F
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbfKMB7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:59:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729317AbfKMB7r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:59:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04B4522474;
        Wed, 13 Nov 2019 01:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610386;
        bh=x0MvYd0gbLXS3k9ZgjNkV36oD44hq2GP9hNJk1Cizb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9RmuJFJ48x73FkUNTAcDJWGb82ySp7pOukPI6dVZ5KqWA/PLFdSpJgSzI1OxMQzd
         QWmVLXCNUQps7NbYEG8u+lZTn4LQ3gkMwXxJ/R5wuQBkFG4GYs5/H6l/JQ/vSkDE2P
         aRNnbvscJuZMaRC1tGWG1kuDGZnoRznHAk7i6os4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/68] ata: ahci_brcm: Match BCM63138 compatible strings
Date:   Tue, 12 Nov 2019 20:58:33 -0500
Message-Id: <20191113015932.12655-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit fb8506f15f2e394f5f648575cf48a26e8744390c ]

Match the "brcm,bcm63138-ahci" compatible string in order to allow this
driver to probe on such platforms.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci_brcm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/ahci_brcm.c b/drivers/ata/ahci_brcm.c
index 6f8a7341fa08a..e0efeccd9c118 100644
--- a/drivers/ata/ahci_brcm.c
+++ b/drivers/ata/ahci_brcm.c
@@ -302,6 +302,7 @@ static struct scsi_host_template ahci_platform_sht = {
 static const struct of_device_id ahci_of_match[] = {
 	{.compatible = "brcm,bcm7425-ahci", .data = (void *)BRCM_SATA_BCM7425},
 	{.compatible = "brcm,bcm7445-ahci", .data = (void *)BRCM_SATA_BCM7445},
+	{.compatible = "brcm,bcm63138-ahci", .data = (void *)BRCM_SATA_BCM7445},
 	{.compatible = "brcm,bcm-nsp-ahci", .data = (void *)BRCM_SATA_NSP},
 	{},
 };
-- 
2.20.1

