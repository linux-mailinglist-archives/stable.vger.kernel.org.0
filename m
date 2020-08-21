Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2699624DDDE
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgHURXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbgHUQPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:15:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 101DC20FC3;
        Fri, 21 Aug 2020 16:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026540;
        bh=DdoQvatDqTZIoDRIfxcl76Ibbop5/KP36qPswZ8z1P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4RWoaWChSbPOQr/UzsTaLNnKfAGzcvdyQ+l20kCfd8jlqQ/YWHFhADLEQFPYqwkg
         whDBrrFvtKccc2fmCB3akc520DTltQTHikz50UdsK7HOzgOAJ9qaokd5LW0OybzegN
         hRKfecVwIcBtrgGBUmc30E7jl6ohFJ7YnbWkh3l4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 60/62] i2c: i801: Add support for Intel Tiger Lake PCH-H
Date:   Fri, 21 Aug 2020 12:14:21 -0400
Message-Id: <20200821161423.347071-60-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit f46efbcad97bfb2caded0397eccce7c71402868c ]

Add SMBus PCI ID on Intel Tiger Lake PCH-H.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index fea644921a768..f206e28af5831 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -67,6 +67,7 @@
  * Comet Lake-H (PCH)		0x06a3	32	hard	yes	yes	yes
  * Elkhart Lake (PCH)		0x4b23	32	hard	yes	yes	yes
  * Tiger Lake-LP (PCH)		0xa0a3	32	hard	yes	yes	yes
+ * Tiger Lake-H (PCH)		0x43a3	32	hard	yes	yes	yes
  * Jasper Lake (SOC)		0x4da3	32	hard	yes	yes	yes
  * Comet Lake-V (PCH)		0xa3a3	32	hard	yes	yes	yes
  *
@@ -221,6 +222,7 @@
 #define PCI_DEVICE_ID_INTEL_GEMINILAKE_SMBUS		0x31d4
 #define PCI_DEVICE_ID_INTEL_ICELAKE_LP_SMBUS		0x34a3
 #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS		0x3b30
+#define PCI_DEVICE_ID_INTEL_TIGERLAKE_H_SMBUS		0x43a3
 #define PCI_DEVICE_ID_INTEL_ELKHART_LAKE_SMBUS		0x4b23
 #define PCI_DEVICE_ID_INTEL_JASPER_LAKE_SMBUS		0x4da3
 #define PCI_DEVICE_ID_INTEL_BROXTON_SMBUS		0x5ad4
@@ -1074,6 +1076,7 @@ static const struct pci_device_id i801_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_COMETLAKE_V_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ELKHART_LAKE_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TIGERLAKE_LP_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TIGERLAKE_H_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_JASPER_LAKE_SMBUS) },
 	{ 0, }
 };
@@ -1748,6 +1751,7 @@ static int i801_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	case PCI_DEVICE_ID_INTEL_COMETLAKE_H_SMBUS:
 	case PCI_DEVICE_ID_INTEL_ELKHART_LAKE_SMBUS:
 	case PCI_DEVICE_ID_INTEL_TIGERLAKE_LP_SMBUS:
+	case PCI_DEVICE_ID_INTEL_TIGERLAKE_H_SMBUS:
 	case PCI_DEVICE_ID_INTEL_JASPER_LAKE_SMBUS:
 		priv->features |= FEATURE_BLOCK_PROC;
 		priv->features |= FEATURE_I2C_BLOCK_READ;
-- 
2.25.1

