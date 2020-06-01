Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFC51EA9F2
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbgFASDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730105AbgFASDs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:03:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 286E8206E2;
        Mon,  1 Jun 2020 18:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034626;
        bh=cqq9J3dfNq+Ie1BItPFqWY/z22jFqRMxoInw3wpatS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Khl7L+gdkCQNKxTl/RbEfhLuSm5OTmBbIhX2fps85GRbplrfd7hfRUluaDfTAvXde
         oIyVsO2fAmkYThhTXuGFvzNdwFlaIF4JpkuC8wBb4fjVkEMP5FG7A075xOJJ6BFfY+
         x5DUhIz8YGlZnjB78icO7nLKBzhx/U+1QS+Zb1/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/95] usb: dwc3: pci: Enable extcon driver for Intel Merrifield
Date:   Mon,  1 Jun 2020 19:53:30 +0200
Message-Id: <20200601174025.564443221@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index edf7984707b7..b2fd505938a0 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -112,6 +112,7 @@ static const struct property_entry dwc3_pci_intel_properties[] = {
 
 static const struct property_entry dwc3_pci_mrfld_properties[] = {
 	PROPERTY_ENTRY_STRING("dr_mode", "otg"),
+	PROPERTY_ENTRY_STRING("linux,extcon-name", "mrfld_bcove_pwrsrc"),
 	PROPERTY_ENTRY_BOOL("linux,sysdev_is_parent"),
 	{}
 };
-- 
2.25.1



