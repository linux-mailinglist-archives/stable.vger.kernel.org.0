Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4A124DC06
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 18:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgHUQwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727095AbgHUQTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:19:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E43A22B43;
        Fri, 21 Aug 2020 16:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026742;
        bh=OuV+Yg7SQ/XFYNzYVYiDcm9gkcEHndIfyGdnu1mh8bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otBbazev4lwa2IIqDX4JBwjmIeqFFArYKB0NTOw2yfiqw6z0avOSQ6MOz0NvYl3uQ
         7p6UrpN5fJ3G1Lec30+Q4yocbNq8JEh+uxDoeNwBZ7UFibYPSZ76k7kYRiEHm0QpYU
         QXfYFNhiI2UQHr0U4mtfACGGo4yM03AzG8H7O2bY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 03/30] mfd: intel-lpss: Add Intel Emmitsburg PCH PCI IDs
Date:   Fri, 21 Aug 2020 12:18:30 -0400
Message-Id: <20200821161857.348955-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161857.348955-1-sashal@kernel.org>
References: <20200821161857.348955-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 3ea2e4eab64cefa06055bb0541fcdedad4b48565 ]

Intel Emmitsburg PCH has the same LPSS than Intel Ice Lake.
Add the new IDs to the list of supported devices.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel-lpss-pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/intel-lpss-pci.c b/drivers/mfd/intel-lpss-pci.c
index 0504761516f7b..a12bb8ed20405 100644
--- a/drivers/mfd/intel-lpss-pci.c
+++ b/drivers/mfd/intel-lpss-pci.c
@@ -176,6 +176,9 @@ static const struct pci_device_id intel_lpss_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x1ac4), (kernel_ulong_t)&bxt_info },
 	{ PCI_VDEVICE(INTEL, 0x1ac6), (kernel_ulong_t)&bxt_info },
 	{ PCI_VDEVICE(INTEL, 0x1aee), (kernel_ulong_t)&bxt_uart_info },
+	/* EBG */
+	{ PCI_VDEVICE(INTEL, 0x1bad), (kernel_ulong_t)&bxt_uart_info },
+	{ PCI_VDEVICE(INTEL, 0x1bae), (kernel_ulong_t)&bxt_uart_info },
 	/* GLK */
 	{ PCI_VDEVICE(INTEL, 0x31ac), (kernel_ulong_t)&glk_i2c_info },
 	{ PCI_VDEVICE(INTEL, 0x31ae), (kernel_ulong_t)&glk_i2c_info },
-- 
2.25.1

