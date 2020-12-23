Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1F02E127F
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbgLWCVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:21:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729300AbgLWCVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C45602222D;
        Wed, 23 Dec 2020 02:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690061;
        bh=SQNednguxrm2iuf7rpcDAon7g61iexbjQdihHuPcsgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Njtr94jIlZdvp+0qyaUG97BaeCL9ho/8LUanMzmH0SqidI4gNnWP8ObP+1Otre0Wr
         f9+7WkUr8z7VNlMlU1agd3uopthUlrQ0ieryG+PnLKt2/JOeS0sYPS3mH4q/11ojFY
         jsVGMR/wTmdQF3OzSW4XjGGw2r24kOzkOq2qY9iUan2gmi30Mz69zTi06g2mPlbudL
         5Iuivu3m64c4TChwFp8gwSbKguiEyzLI1Giy4gebpDWfwvQHOKmbsfeK3sAe29rCjA
         Z8/5ExVRzkFgGl8bfPgGjO94FnlHr0JInVQcJrdvIcljvwpEidCfcG8rCmfcTjijIC
         gSphuBKFwPBGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        John Smith <LK7S2ED64JHGLKj75shg9klejHWG49h5hk@protonmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 130/130] PCI: Add function 1 DMA alias quirk for Marvell 9215 SATA controller
Date:   Tue, 22 Dec 2020 21:18:13 -0500
Message-Id: <20201223021813.2791612-130-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 059983790a4c963d92943e55a61fca55be427d55 ]

Add function 1 DMA alias quirk for Marvell 88SS9215 PCIe SSD Controller.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=42679#c135
Link: https://lore.kernel.org/r/20201110220516.697934-1-helgaas@kernel.org
Reported-by: John Smith <LK7S2ED64JHGLKj75shg9klejHWG49h5hk@protonmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index c98067579e9f3..53376bcda1f3f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4055,6 +4055,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9183,
 /* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c46 */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x91a0,
 			 quirk_dma_func1_alias);
+/* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c135 */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9215,
+			 quirk_dma_func1_alias);
 /* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c127 */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9220,
 			 quirk_dma_func1_alias);
-- 
2.27.0

