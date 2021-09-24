Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76586417497
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345720AbhIXNIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345977AbhIXNFz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:05:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F558614C8;
        Fri, 24 Sep 2021 12:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488163;
        bh=JwazT0upXtaVCAO3l47ZXkhH6LyNxROHxQpNEN8phiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAQ/jeuzK3HgXuRXjWXe19uSVd+wHJxrr9hVudbVODgX4McgnVQcJO6Kh9d5Dbteu
         1KT9GD6zmUnVNzvkf3b9XYbgMX8MVJQambRrNbSO7ibA/zIumR9IpNdvIVLzBHyKAJ
         kieqGq/vRRGnPiRCoMPu8Zhj1ncrS9FM5myrp3aE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.10 01/63] PCI: pci-bridge-emul: Add PCIe Root Capabilities Register
Date:   Fri, 24 Sep 2021 14:44:01 +0200
Message-Id: <20210924124334.277543764@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit e902bb7c24a7099d0eb0eb4cba06f2d91e9299f3 upstream.

The 16-bit Root Capabilities register is at offset 0x1e in the PCIe
Capability. Rename current 'rsvd' struct member to 'rootcap'.

Link: https://lore.kernel.org/r/20210722144041.12661-4-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-bridge-emul.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/pci-bridge-emul.h
+++ b/drivers/pci/pci-bridge-emul.h
@@ -54,7 +54,7 @@ struct pci_bridge_emul_pcie_conf {
 	__le16 slotctl;
 	__le16 slotsta;
 	__le16 rootctl;
-	__le16 rsvd;
+	__le16 rootcap;
 	__le32 rootsta;
 	__le32 devcap2;
 	__le16 devctl2;


