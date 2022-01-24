Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B55499A7C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573128AbiAXVo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53508 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352232AbiAXVeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:34:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 193CF614DE;
        Mon, 24 Jan 2022 21:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9C1C340EF;
        Mon, 24 Jan 2022 21:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060056;
        bh=MFtwOZJoi2PSl+FnzFMrWI/ufCULKuJqp+VQy1Dt5CY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lf4D3wqpHO8qD53Ow7K1utZ3OZhA1ZjjW4CTKHgRMj4hhp16kV2UDF5TVmBDqHsgP
         FgMke566ierCfOemFRPEkfgXxNQAAik0mmfxOcYNQ1tc0R0xzZtETbLsdvCsmLkQf+
         lnbw4MErIP3qCmMtyEq8pIl1j3KYU4WqXotb3pPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yanteng Si <siyanteng@loongson.cn>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0824/1039] PCI: mt7621: Add missing MODULE_LICENSE()
Date:   Mon, 24 Jan 2022 19:43:33 +0100
Message-Id: <20220124184152.990526795@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit e4b1cd02dc8d7967a79edccd510724831e5cdee8 ]

The MT7621 PCIe host controller driver can be built as a module, but it
lacks a MODULE_LICENSE(), which causes a build error:

  ERROR: modpost: missing MODULE_LICENSE() in drivers/pci/controller/pcie-mt7621.o

Add MODULE_LICENSE() to the driver.

Fixes: 2bdd5238e756 ("PCI: mt7621: Add MediaTek MT7621 PCIe host controller driver")
Link: https://lore.kernel.org/r/20211207104924.21327-5-sergio.paracuellos@gmail.com
Signed-off-by: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Krzysztof Wilczyński <kw@linux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mt7621.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-mt7621.c b/drivers/pci/controller/pcie-mt7621.c
index b60dfb45ef7bd..73b91315c1656 100644
--- a/drivers/pci/controller/pcie-mt7621.c
+++ b/drivers/pci/controller/pcie-mt7621.c
@@ -598,3 +598,5 @@ static struct platform_driver mt7621_pci_driver = {
 	},
 };
 builtin_platform_driver(mt7621_pci_driver);
+
+MODULE_LICENSE("GPL v2");
-- 
2.34.1



