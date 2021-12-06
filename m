Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51655469B16
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355619AbhLFPMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:12:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43316 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355833AbhLFPKz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:10:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB890B8101B;
        Mon,  6 Dec 2021 15:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B766C341C2;
        Mon,  6 Dec 2021 15:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803244;
        bh=M9SV7/9eRzfq5uMQg3MK8XMMYH6S07CWt7cYXgLyi0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFVcVXZKiYIrpwrVn3nf/eEZtogctPDlOA8hYDhcrgHxjleJHaBaV/NuEgOkf/pes
         s1BRUc3msKHaLNgrdMS08YHJ6nQsdOHJNYRh5m6P70aVn6Fyuold3LnGOOuqYplxau
         4J/7DuA6GHM89FU16lJVPDP1fmMyeo93sfpGdubU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frederick Lawler <fred@fredlawl.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 048/106] PCI: Add PCI_EXP_LNKCTL2_TLS* macros
Date:   Mon,  6 Dec 2021 15:55:56 +0100
Message-Id: <20211206145557.086358213@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
User-Agent: quilt/0.66
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/pci_regs.h |    5 +++++
 1 file changed, 5 insertions(+)

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


