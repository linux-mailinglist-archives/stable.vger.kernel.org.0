Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27158333E87
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbhCJN0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233437AbhCJNZh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8EF264FE8;
        Wed, 10 Mar 2021 13:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382737;
        bh=OctZPrjf1w5alyumA+uoEY3wZaAx5WEFxCqiv4l6Aek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMAvakMh05B/LqDY/HztrkCVKhFOEzSA9cJ9e0bAPvO9cNSLXfbci5WKVS8W//4ye
         r1Y16fNmgGjFrPPLV2k/9vFinZTXIHANwe/t6pBK3Rp4wJ57xurVfcMIpQpRuj/wf/
         wRgdB+NzebbAwyr6BYaS+baWkkf10m6hgiSjDjUQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        John Smith <LK7S2ED64JHGLKj75shg9klejHWG49h5hk@protonmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 7/7] PCI: Add function 1 DMA alias quirk for Marvell 9215 SATA controller
Date:   Wed, 10 Mar 2021 14:25:20 +0100
Message-Id: <20210310132319.418631499@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.155338551@linuxfoundation.org>
References: <20210310132319.155338551@linuxfoundation.org>
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
index bdaeccafa261..bc0aa0849e72 100644
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
2.30.1



