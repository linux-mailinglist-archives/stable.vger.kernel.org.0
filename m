Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C7917172E
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 13:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgB0M2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 07:28:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56646 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgB0M2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 07:28:37 -0500
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1j7IHL-0004ws-2c; Thu, 27 Feb 2020 12:28:35 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     axboe@kernel.dk
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        stable@vger.kernel.org,
        linux-ide@vger.kernel.org (open list:LIBATA SUBSYSTEM (Serial and
        Parallel ATA drivers)), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ahci: Add Intel Comet Lake H RAID PCI ID
Date:   Thu, 27 Feb 2020 20:28:22 +0800
Message-Id: <20200227122822.14059-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add the PCI ID to the driver list to support this new device.

Cc: stable@vger.kernel.org
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/ata/ahci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 11ea1aff40db..8c6f8c83dd6f 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -401,6 +401,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0xa252), board_ahci }, /* Lewisburg RAID*/
 	{ PCI_VDEVICE(INTEL, 0xa256), board_ahci }, /* Lewisburg RAID*/
 	{ PCI_VDEVICE(INTEL, 0xa356), board_ahci }, /* Cannon Lake PCH-H RAID */
+	{ PCI_VDEVICE(INTEL, 0x06d7), board_ahci }, /* Comet Lake-H RAID */
 	{ PCI_VDEVICE(INTEL, 0x0f22), board_ahci_mobile }, /* Bay Trail AHCI */
 	{ PCI_VDEVICE(INTEL, 0x0f23), board_ahci_mobile }, /* Bay Trail AHCI */
 	{ PCI_VDEVICE(INTEL, 0x22a3), board_ahci_mobile }, /* Cherry Tr. AHCI */
-- 
2.17.1

