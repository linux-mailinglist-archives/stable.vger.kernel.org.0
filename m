Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 979F7FA62D
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbfKMC1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:27:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727556AbfKMBvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:51:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D53222D4;
        Wed, 13 Nov 2019 01:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609861;
        bh=jYO8D5McdN9+Q6vkHg8beGmm5RMdUchnT+uUGGGrN10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdBdfcVM25lQu/N6Yxc8LvAv5JoS4YNsSSR+Ibpb4WMok98PQtREMYw4+LOFgeBG9
         6iukE57fRr2fuF4q+zLFZ/6Am8q9zxZcmn13BI3IffL4vuVUjwafPE3RuuG1qKH16f
         GZGBrwXH8J/IoaxtH59SGoxC89seVJYT6B9mP8lQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 027/209] ata: ahci_brcm: Match BCM63138 compatible strings
Date:   Tue, 12 Nov 2019 20:47:23 -0500
Message-Id: <20191113015025.9685-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
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
index f3d557777d829..898792d661e56 100644
--- a/drivers/ata/ahci_brcm.c
+++ b/drivers/ata/ahci_brcm.c
@@ -381,6 +381,7 @@ static struct scsi_host_template ahci_platform_sht = {
 static const struct of_device_id ahci_of_match[] = {
 	{.compatible = "brcm,bcm7425-ahci", .data = (void *)BRCM_SATA_BCM7425},
 	{.compatible = "brcm,bcm7445-ahci", .data = (void *)BRCM_SATA_BCM7445},
+	{.compatible = "brcm,bcm63138-ahci", .data = (void *)BRCM_SATA_BCM7445},
 	{.compatible = "brcm,bcm-nsp-ahci", .data = (void *)BRCM_SATA_NSP},
 	{},
 };
-- 
2.20.1

