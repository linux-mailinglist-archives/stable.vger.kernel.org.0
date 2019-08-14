Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A37818C8C8
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbfHNCdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728581AbfHNCOJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:14:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AD2A2084D;
        Wed, 14 Aug 2019 02:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748848;
        bh=gTQZNypoxKrs9nJZOnS/RtkPS1UQz5Xglt6IxmR8qRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsv6EjKvakR0kX5NUi1v14WPrTHCT7KHQRggyS9ItVEEKnjDIVTn0iw6zx/w3+nVd
         EB/inq2YO4Ur+V0zTKClpIxGbl1GOtTdNNnzglOWk6Ugct2boqA+KX4yqgSuYc5F1r
         fWZf8Pg/gyLu4C/vqaq3OSCYA9wuvUYM1xE8zGrg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 100/123] ata: rb532_cf: Fix unused variable warning in rb532_pata_driver_probe
Date:   Tue, 13 Aug 2019 22:10:24 -0400
Message-Id: <20190814021047.14828-100-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

[ Upstream commit db341a049ec7e87053c91008cb452d0bfa6dde72 ]

Fix the following warning (Building: rb532_defconfig mips):

drivers/ata/pata_rb532_cf.c: In function ‘rb532_pata_driver_remove’:
drivers/ata/pata_rb532_cf.c:161:24: warning: unused variable ‘info’ [-Wunused-variable]
  struct rb532_cf_info *info = ah->private_data;
                        ^~~~

Fixes: cd56f35e52d9 ("ata: rb532_cf: Convert to use GPIO descriptors")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_rb532_cf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
index 7c37f2ff09e41..deae466395de1 100644
--- a/drivers/ata/pata_rb532_cf.c
+++ b/drivers/ata/pata_rb532_cf.c
@@ -158,7 +158,6 @@ static int rb532_pata_driver_probe(struct platform_device *pdev)
 static int rb532_pata_driver_remove(struct platform_device *pdev)
 {
 	struct ata_host *ah = platform_get_drvdata(pdev);
-	struct rb532_cf_info *info = ah->private_data;
 
 	ata_host_detach(ah);
 
-- 
2.20.1

