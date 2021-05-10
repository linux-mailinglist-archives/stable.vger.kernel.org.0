Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113743787DD
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235433AbhEJLTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236697AbhEJLIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4F44619D0;
        Mon, 10 May 2021 11:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644612;
        bh=RP6tE1K3C9GzFFgIhxEA6F1aJaimRLG6qRLFZk578i8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTM0A89nALRwxCgJ9hpL0bi0rRRGTUY3um7m6/Mj9+0cSmxt8Fnu75xCfCMGfG7oE
         kEIwcYtWTOI6kGRY6kOd3nMKzabnvGfOFPoKTnE/durd5lf8W+fKkxH9yd+DL3XXrK
         9VhlEfbAsiwRTWpf4fUUzm8Jsz6333c92xTHeTh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 117/384] usb: dwc3: pci: add support for the Intel Alder Lake-M
Date:   Mon, 10 May 2021 12:18:26 +0200
Message-Id: <20210510102018.749909424@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit 782de5e7190de0a773417708e17d9461d9109bf9 ]

This patch adds the necessary PCI ID for Intel Alder Lake-M
devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20210408083144.69350-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 4c5c6972124a..95f954a1d7be 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -41,6 +41,7 @@
 #define PCI_DEVICE_ID_INTEL_TGPH		0x43ee
 #define PCI_DEVICE_ID_INTEL_JSP			0x4dee
 #define PCI_DEVICE_ID_INTEL_ADLP		0x51ee
+#define PCI_DEVICE_ID_INTEL_ADLM		0x54ee
 #define PCI_DEVICE_ID_INTEL_ADLS		0x7ae1
 #define PCI_DEVICE_ID_INTEL_TGL			0x9a15
 
@@ -388,6 +389,9 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ADLP),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ADLM),
+	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
+
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ADLS),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
-- 
2.30.2



