Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558E945BE4A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243387AbhKXMqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:46:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345744AbhKXMoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:44:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8CCB61248;
        Wed, 24 Nov 2021 12:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756763;
        bh=c7yLRFh/qPO1cPe8F9ONeJjPdkrpsC5lpe94My3zLeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAFJxJ7HjUbN2S3OY/ZzmygYv+/RztCPJMgnYvEP8oHl+PHbt8C1eFZnPZTNlwB94
         6P1LwI93vJc03CshFsaUJ1y5MhKGHmygnsnzrNAjfs/U+JEmjiUnAez+Tu+YI0izov
         MC0K4kHwTyh+r9btmZNTNYl8Un1Y79tgudYzPN3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.14 197/251] PCI: Add PCI_EXP_DEVCTL_PAYLOAD_* macros
Date:   Wed, 24 Nov 2021 12:57:19 +0100
Message-Id: <20211124115717.119569852@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 460275f124fb072dca218a6b43b6370eebbab20d upstream.

Define a macro PCI_EXP_DEVCTL_PAYLOAD_* for every possible Max Payload
Size in linux/pci_regs.h, in the same style as PCI_EXP_DEVCTL_READRQ_*.

Link: https://lore.kernel.org/r/20211005180952.6812-2-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/pci_regs.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -497,6 +497,12 @@
 #define  PCI_EXP_DEVCTL_URRE	0x0008	/* Unsupported Request Reporting En. */
 #define  PCI_EXP_DEVCTL_RELAX_EN 0x0010 /* Enable relaxed ordering */
 #define  PCI_EXP_DEVCTL_PAYLOAD	0x00e0	/* Max_Payload_Size */
+#define  PCI_EXP_DEVCTL_PAYLOAD_128B 0x0000 /* 128 Bytes */
+#define  PCI_EXP_DEVCTL_PAYLOAD_256B 0x0020 /* 256 Bytes */
+#define  PCI_EXP_DEVCTL_PAYLOAD_512B 0x0040 /* 512 Bytes */
+#define  PCI_EXP_DEVCTL_PAYLOAD_1024B 0x0060 /* 1024 Bytes */
+#define  PCI_EXP_DEVCTL_PAYLOAD_2048B 0x0080 /* 2048 Bytes */
+#define  PCI_EXP_DEVCTL_PAYLOAD_4096B 0x00a0 /* 4096 Bytes */
 #define  PCI_EXP_DEVCTL_EXT_TAG	0x0100	/* Extended Tag Field Enable */
 #define  PCI_EXP_DEVCTL_PHANTOM	0x0200	/* Phantom Functions Enable */
 #define  PCI_EXP_DEVCTL_AUX_PME	0x0400	/* Auxiliary Power PM Enable */


