Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04556417370
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344757AbhIXM4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344788AbhIXMy3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:54:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5E7A61378;
        Fri, 24 Sep 2021 12:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487836;
        bh=JwazT0upXtaVCAO3l47ZXkhH6LyNxROHxQpNEN8phiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b//jsECk5FElx9VhX+LaxD5HGs7SB9pZ7HfjQWkvwyJl85BpeIoie/7nzFzzCgsH2
         3GD4R5dLPenkPjzt40Tr/uzzMfCehMvxWgBwM3j0WY20WfXeNxqo5MwVJPDc00V61i
         oJFLdi6TNuh005U6IG+weiK+wdS2kDa14ov3RqPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4 03/50] PCI: pci-bridge-emul: Add PCIe Root Capabilities Register
Date:   Fri, 24 Sep 2021 14:43:52 +0200
Message-Id: <20210924124332.345572713@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
User-Agent: quilt/0.66
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


