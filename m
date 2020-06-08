Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764601F23E5
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbgFHXRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729715AbgFHXRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8F1D20842;
        Mon,  8 Jun 2020 23:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658261;
        bh=wCEJW245dxBO726etQLlIpRtTbaTWQv+YPDCCDn2mbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1UkBcXG8ArJ+9s86p4YuzC3qm2pn9aholPVhj4mxd0OxHMgUwyI4NQjaMBeK+U9G9
         J6cguCDuRH500cWK65jQgiImCqr9fbr0y6wm8TbK1G5/GukK3g9wRUaixus4pQLf7f
         nggxuzhB8nvO83QCuUGoACOSVBBupd1mXl7RUaAU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 269/606] usb: dwc3: pci: Enable extcon driver for Intel Merrifield
Date:   Mon,  8 Jun 2020 19:06:34 -0400
Message-Id: <20200608231211.3363633-269-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 066c09593454e89bc605ffdff1c9810061f9b1e1 ]

Intel Merrifield provides a DR support via PMIC which has its own
extcon driver.

Add a property string to link to that driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 7051611229c9..b67372737dc9 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -114,6 +114,7 @@ static const struct property_entry dwc3_pci_intel_properties[] = {
 
 static const struct property_entry dwc3_pci_mrfld_properties[] = {
 	PROPERTY_ENTRY_STRING("dr_mode", "otg"),
+	PROPERTY_ENTRY_STRING("linux,extcon-name", "mrfld_bcove_pwrsrc"),
 	PROPERTY_ENTRY_BOOL("linux,sysdev_is_parent"),
 	{}
 };
-- 
2.25.1

