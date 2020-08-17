Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC6E2475DE
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbgHQPcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730049AbgHQPb4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:31:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C6802313F;
        Mon, 17 Aug 2020 15:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678315;
        bh=IVjjFA0DYsoC7bTosHCMh3WCsr8pULJgQQr7kWsxjpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqC6EB6r1mtwyb/0kKAs0xkCACm4QrFGpWZkDB98jaurdLZ8p8wttkqSWHPpqoSnV
         xUguA4ZMeAiSr3Hj3VJPxPuaaAZSVzhZC5u04eeBR+UqRCtwnCKJ1g/PMinF21UMwP
         vQ/bmFSAMpteRyffTq2ADuLC/snhZfujWjK9Ys5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 284/464] thermal: int340x: processor_thermal: fix: update Jasper Lake PCI id
Date:   Mon, 17 Aug 2020 17:13:57 +0200
Message-Id: <20200817143847.359016888@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>

[ Upstream commit 287d959558357e155c889bc35579eb35691a8fcb ]

Update PCI device id for Jasper Lake processor thermal device.
With this proc_thermal driver is getting loaded and processor
thermal functionality works on Jasper Lake system.

Fixes: f64a6583d3f5 ("thermal: int340x: processor_thermal: Add Jasper Lake support")
Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/1595577146-1221-1-git-send-email-sumeet.r.pawnikar@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../thermal/intel/int340x_thermal/processor_thermal_device.c    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
index 297db1d2d960c..81e8b15ef405d 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -43,7 +43,7 @@
 #define PCI_DEVICE_ID_PROC_ICL_THERMAL	0x8a03
 
 /* JasperLake thermal reporting device */
-#define PCI_DEVICE_ID_PROC_JSL_THERMAL	0x4503
+#define PCI_DEVICE_ID_PROC_JSL_THERMAL	0x4E03
 
 /* TigerLake thermal reporting device */
 #define PCI_DEVICE_ID_PROC_TGL_THERMAL	0x9A03
-- 
2.25.1



