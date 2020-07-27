Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D96822F1B3
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730850AbgG0OQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:16:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730846AbgG0OQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:16:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0A8820825;
        Mon, 27 Jul 2020 14:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859380;
        bh=o0bUSa9r+WlA838mzYXVW27gR8YIWsM5ux2NTn9EUyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9QUaX9tU1rQmqhsPONVxvfqxBQ7TABXPW17JJsu8OmCFySTsvicZcOtBMsedhY0V
         iU6bg8npcflj1kdTu+DIt0dCaCWoyW503ziIwHokL+hgyQxaijOPp07+Kfmk4ixm9E
         HE3AwnaredNKO8bU7J7og0DSfTzTcY4T1HB3KWIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/138] usb: dwc3: pci: add support for the Intel Jasper Lake
Date:   Mon, 27 Jul 2020 16:04:41 +0200
Message-Id: <20200727134929.669025996@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit e25d1e8532c3d84f075deca1580a7d61e0f43ce6 ]

This patch adds the necessary PCI ID for Intel Jasper Lake
devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 47b7e83d90626..139474c3e77b1 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -39,6 +39,7 @@
 #define PCI_DEVICE_ID_INTEL_EHLLP		0x4b7e
 #define PCI_DEVICE_ID_INTEL_TGPLP		0xa0ee
 #define PCI_DEVICE_ID_INTEL_TGPH		0x43ee
+#define PCI_DEVICE_ID_INTEL_JSP			0x4dee
 
 #define PCI_INTEL_BXT_DSM_GUID		"732b85d5-b7a7-4a1b-9ba0-4bbd00ffd511"
 #define PCI_INTEL_BXT_FUNC_PMU_PWR	4
@@ -362,6 +363,9 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_TGPH),
 	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_JSP),
+	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
+
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_NL_USB),
 	  (kernel_ulong_t) &dwc3_pci_amd_properties, },
 	{  }	/* Terminating Entry */
-- 
2.25.1



