Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B512E1313
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgLWC1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:27:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730856AbgLWC0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:26:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA4B322482;
        Wed, 23 Dec 2020 02:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690364;
        bh=/BtB7X0mFViLHPMe49bObwfi69oqmf3DXJFj3M85d+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UtIdjM2uJHwWphQa9NdhKnwb3XHY6li24nmGCWC+U4rpq7EcrlnfMY+bmjA3GSAk8
         RHpEPtfHAVHGuQydN2GspjORMZnQV9eswwuLAbM7Nze+4vv7NJu77stMAYspY9LvVv
         4whQkAxwHEUFhjwHRI0+q36w9PCZezrRsoaI6QB855xISECn6IFTLFGaxgBV8y4e80
         9xSaYLpDMMv0gV13kGxLiHrNPGQboN7FapOKqGMvY0VQs5U0T36gNanHphuLkrN3vE
         9buun2bMXxc3ByS/RdGJ3sZJshwEGmyp8fQyU+b/JV3N4sJexeq0m6IWepRK+Rcv2w
         U0tDz2LQtFdpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        John Smith <LK7S2ED64JHGLKj75shg9klejHWG49h5hk@protonmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 38/38] PCI: Add function 1 DMA alias quirk for Marvell 9215 SATA controller
Date:   Tue, 22 Dec 2020 21:25:16 -0500
Message-Id: <20201223022516.2794471-38-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022516.2794471-1-sashal@kernel.org>
References: <20201223022516.2794471-1-sashal@kernel.org>
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
index bdaeccafa261b..bc0aa0849e72e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3649,6 +3649,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x917a,
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

