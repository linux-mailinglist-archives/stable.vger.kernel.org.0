Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856F22E137B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730379AbgLWCag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:30:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:55618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730536AbgLWCZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E927B22273;
        Wed, 23 Dec 2020 02:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690315;
        bh=AxMcaJjczOkJq7gpCldK4NQcNxvqxLsSI/qLEBUcQeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ac+pdMBu+lFEctRoFERCW4oOWzjplXPi7FUqJv6yPtw+h1PxTWxDEP68YxrdmqT6e
         fhS+1xvZchmprNpjHmDMq0+ylxy2yiTFnzHpmJbgaJQhKSl1+EiGSSRNRGYmM5ay32
         218eQPD4WxxrKuQviDGXGlMFgBxdQLBemN5aa5flFcDArUBwQMtRnJTB4yWCITjFu2
         orH/x5RCoTzjuzi2QDFabtZW2y7vQJTJLB773HSilw47mo63Bxyj7J8TL5sG814J7f
         kXk3Boii3D9I/dnYXjgul/LLBKzl0yLWnm4fj95EjJ6PWYZqaC5oZiT8D3MzSansmR
         fK00JBZoiSX7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        John Smith <LK7S2ED64JHGLKj75shg9klejHWG49h5hk@protonmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 48/48] PCI: Add function 1 DMA alias quirk for Marvell 9215 SATA controller
Date:   Tue, 22 Dec 2020 21:24:16 -0500
Message-Id: <20201223022417.2794032-48-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
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
index 1fdb1ef5eaaeb..0ebf7500e171e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3911,6 +3911,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9182,
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

