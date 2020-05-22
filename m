Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876261DEABD
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730724AbgEVO4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730891AbgEVOvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:51:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EAE8222E7;
        Fri, 22 May 2020 14:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159065;
        bh=wCEJW245dxBO726etQLlIpRtTbaTWQv+YPDCCDn2mbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nmtcJU2YJfDre/+Ad6GkFDHoHVvtoMv18xZWjaam2GXzcyE1pBHBGm8NVc8Li3Pzq
         5nPtTkTAYCBg02QYkezWRu2X700Ax8XJbEx6TEMpf7DNJyXPHo4ZaOiRN4U0zRn41d
         xbk6lSnVmx6y/cdSQYuqeKzXDGJcGsPJFHV2AKW0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/32] usb: dwc3: pci: Enable extcon driver for Intel Merrifield
Date:   Fri, 22 May 2020 10:50:30 -0400
Message-Id: <20200522145044.434677-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145044.434677-1-sashal@kernel.org>
References: <20200522145044.434677-1-sashal@kernel.org>
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

