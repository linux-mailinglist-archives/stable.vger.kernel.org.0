Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C721018B5
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfKSF20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:28:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727389AbfKSF2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:28:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF28A208C3;
        Tue, 19 Nov 2019 05:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141304;
        bh=HYdL5GQ3OQvT0aFNudvAPyRyi+SuJmdXbbSLSZAqU6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUbEQjgZsoEltFQeZ86X5v76hPtuvHa4e2YxUZDPvqsqpTUlCl/y54lWYsM9JvE/W
         iw4OahG/7AgFEtU1/bZJEdr4pCLVN99H3c7ee5ajipGRHcidZ2D6Xy704JU3TJrv03
         eRtQiQgB2FVZuox/9ZpUzmIY3MfpFhdniWC+IBbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 115/422] mtd: rawnand: qcom: dont include dma-direct.h
Date:   Tue, 19 Nov 2019 06:15:12 +0100
Message-Id: <20191119051406.540796298@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



