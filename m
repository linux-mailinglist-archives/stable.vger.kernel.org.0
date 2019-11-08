Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA3A4F4A81
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388264AbfKHLkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:40:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:52878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732191AbfKHLkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9DDF21D7F;
        Fri,  8 Nov 2019 11:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213199;
        bh=HYdL5GQ3OQvT0aFNudvAPyRyi+SuJmdXbbSLSZAqU6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvTe288PSPznFlLA3mWEsffPt+x81Lu38kGyycD5lRZnMGBp7Yx0CFjlejmtfu/zU
         K2HzCFdqL+gYDyUprHqAvC04hkoJ5oqVhcZepurjWnXBEea/lHH9aVnsD4Psf0deT+
         21l4UMKg5i2EHgu/w17Lts1yfupC0yMZStthGFV0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-mtd@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 083/205] mtd: rawnand: qcom: don't include dma-direct.h
Date:   Fri,  8 Nov 2019 06:35:50 -0500
Message-Id: <20191108113752.12502-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit ab0fb17c7d46406e1aac2dda265874751946626d ]

A recent commit removed the incorrect use of phys_to_dma from this
driver, but failed to remove the dma-direct.h include, so do that
now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/qcom_nandc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/qcom_nandc.c b/drivers/mtd/nand/raw/qcom_nandc.c
index 880e75f63a19b..07d8750313fd6 100644
--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -23,7 +23,6 @@
 #include <linux/of_device.h>
 #include <linux/delay.h>
 #include <linux/dma/qcom_bam_dma.h>
-#include <linux/dma-direct.h> /* XXX: drivers shall never use this directly! */
 
 /* NANDc reg offsets */
 #define	NAND_FLASH_CMD			0x00
-- 
2.20.1

