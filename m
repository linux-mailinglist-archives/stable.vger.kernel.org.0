Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499FC333E5B
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhCJNZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232818AbhCJNZL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3273865004;
        Wed, 10 Mar 2021 13:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382711;
        bh=NjklJ3yAoGqKDJp/l/sp4yBdZclOgdyy27e1l2koeg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ap1KmRRL1FNv4JQ7RrrwtnOUAXap6vc3WfjzPBxaRbME+O9mWfs+/sqwHhIz2Auar
         7mtHv/k6CDqscC4x27Da56fwdG8ae2kHxZII68T/i+p+0gQFQJR3Us0ybCOihNPNeI
         5Eu6zCeST5C1AL65wdVOsacMFbxUke07NlGe+1ZY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        John Smith <LK7S2ED64JHGLKj75shg9klejHWG49h5hk@protonmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/24] PCI: Add function 1 DMA alias quirk for Marvell 9215 SATA controller
Date:   Wed, 10 Mar 2021 14:24:30 +0100
Message-Id: <20210310132321.103317261@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.550932445@linuxfoundation.org>
References: <20210310132320.550932445@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
index c98067579e9f..53376bcda1f3 100644
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
2.30.1



