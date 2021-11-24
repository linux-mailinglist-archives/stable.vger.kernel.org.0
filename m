Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E4045D074
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352279AbhKXWx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352275AbhKXWxZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:53:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6145961074;
        Wed, 24 Nov 2021 22:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794215;
        bh=tNw7IXH2ATiwBDBvEVhHXTTO+EmYp5CodJ+RQSvMjZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXJ/q/sX3MkO6CO4aupJYTMrgPAO4xEGHPHDnM1vJ6qKPj02bJJR5GrhI0MrqebnQ
         P+xdvtSXC6FsaB2GKQBI1ONUNECrJ3G7Pa1orYRPTZDD9yhSB1u5oOp/9//6DYRABP
         3lZgKfbv2fSCxZv0OlDou2TxSMS+2XjpAr7krRwGiYG3wpLUm3mF8rlT41LtQlr+Pm
         UsOX9/UUPRzxHZatiH6gWpo327qAlcB0l8ALYtEaKO2NgQpwRxQ0vAWrkux1w3i0VU
         eOydnvAGWhUnazO0ToxSGMnmdWncOX9KadAme91i9Z618Qp70uf2hfljZs9YNe9zkL
         cXmAbEyLrSjeQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Frederick Lawler <fred@fredlawl.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 17/24] PCI: Add PCI_EXP_LNKCTL2_TLS* macros
Date:   Wed, 24 Nov 2021 23:49:26 +0100
Message-Id: <20211124224933.24275-18-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124224933.24275-1-kabel@kernel.org>
References: <20211124224933.24275-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederick Lawler <fred@fredlawl.com>

commit c80851f6ce63a6e313f8c7b4b6eb82c67aa4497b upstream.

The Link Control 2 register is missing macros for Target Link Speeds.  Add
those in.

Signed-off-by: Frederick Lawler <fred@fredlawl.com>
[bhelgaas: use "GT" instead of "GB"]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 include/uapi/linux/pci_regs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index c843929e0c4f..5db024aa00e9 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -654,6 +654,11 @@
 #define  PCI_EXP_LNKCAP2_SLS_8_0GB	0x00000008 /* Supported Speed 8.0GT/s */
 #define  PCI_EXP_LNKCAP2_CROSSLINK	0x00000100 /* Crosslink supported */
 #define PCI_EXP_LNKCTL2		48	/* Link Control 2 */
+#define PCI_EXP_LNKCTL2_TLS		0x000f
+#define PCI_EXP_LNKCTL2_TLS_2_5GT	0x0001 /* Supported Speed 2.5GT/s */
+#define PCI_EXP_LNKCTL2_TLS_5_0GT	0x0002 /* Supported Speed 5GT/s */
+#define PCI_EXP_LNKCTL2_TLS_8_0GT	0x0003 /* Supported Speed 8GT/s */
+#define PCI_EXP_LNKCTL2_TLS_16_0GT	0x0004 /* Supported Speed 16GT/s */
 #define PCI_EXP_LNKSTA2		50	/* Link Status 2 */
 #define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	52	/* v2 endpoints with link end here */
 #define PCI_EXP_SLTCAP2		52	/* Slot Capabilities 2 */
-- 
2.32.0

