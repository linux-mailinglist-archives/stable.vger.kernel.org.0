Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF21014E19F
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731114AbgA3Sp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:45:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731108AbgA3Sp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:45:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 948E320674;
        Thu, 30 Jan 2020 18:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409956;
        bh=lBIt9/xFGHH/1uosdk4MNrvUPEogcK/uMsAxinzRsXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOFFeiW46vPTIzupGhC5+Ljzhqer/4tyPWbFKgUSPd3ZKfjS7avroc20p3QI9QJUu
         /dYcNZ4ffwPLWwraETgnlDZk9hbYm0nXQ2QkFgXZAaLKpByY3Y6Vy+wuB7FkhjaLOn
         1PcoY8waxUUGRIZYQiX50Zx0MuGOaj9dT7usajpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/110] HID: intel-ish-hid: ipc: Add Tiger Lake PCI device ID
Date:   Thu, 30 Jan 2020 19:38:35 +0100
Message-Id: <20200130183622.018771768@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 1479a82d82df68dfac29c72c774cb8bdc17d4eb1 ]

Added Tiger Lake PCI device ID to the supported device list.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ipc/hw-ish.h  | 1 +
 drivers/hid/intel-ish-hid/ipc/pci-ish.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/intel-ish-hid/ipc/hw-ish.h b/drivers/hid/intel-ish-hid/ipc/hw-ish.h
index 905e1bc3f91db..1fb294ca463e5 100644
--- a/drivers/hid/intel-ish-hid/ipc/hw-ish.h
+++ b/drivers/hid/intel-ish-hid/ipc/hw-ish.h
@@ -26,6 +26,7 @@
 #define CML_LP_DEVICE_ID	0x02FC
 #define CMP_H_DEVICE_ID		0x06FC
 #define EHL_Ax_DEVICE_ID	0x4BB3
+#define TGL_LP_DEVICE_ID	0xA0FC
 
 #define	REVISION_ID_CHT_A0	0x6
 #define	REVISION_ID_CHT_Ax_SI	0x0
diff --git a/drivers/hid/intel-ish-hid/ipc/pci-ish.c b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
index 9c8cefe16af3e..f491d8b4e24c7 100644
--- a/drivers/hid/intel-ish-hid/ipc/pci-ish.c
+++ b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
@@ -36,6 +36,7 @@ static const struct pci_device_id ish_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, CML_LP_DEVICE_ID)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, CMP_H_DEVICE_ID)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, EHL_Ax_DEVICE_ID)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, TGL_LP_DEVICE_ID)},
 	{0, }
 };
 MODULE_DEVICE_TABLE(pci, ish_pci_tbl);
-- 
2.20.1



