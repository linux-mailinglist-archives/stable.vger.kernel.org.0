Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D79640DF2E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbhIPQHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232048AbhIPQGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:06:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E398B61241;
        Thu, 16 Sep 2021 16:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808333;
        bh=n3O600CWMTqKdQtCf31lofjSYy+DdA8rmYBZUQfBTrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXPzehe+EESkTkK+yHID0A6Xg8sFAspg3jqTEw6J7af7wOa4wau+6Y1bVCpSi2vvJ
         DHBgAT1yD3wEBL6Ygp/1c87CfD0J8zMl0elcZHM+FsmHgF9JmmA35sCuPrlEl/dqxs
         xBTpytgff5IHS4xBNzj08s8R1i4vZaTpPZE/5acM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianjun Wang <jianjun.wang@mediatek.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.10 051/306] PCI: Export pci_pio_to_address() for module use
Date:   Thu, 16 Sep 2021 17:56:36 +0200
Message-Id: <20210916155755.684590141@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianjun Wang <jianjun.wang@mediatek.com>

commit 9cc742078c9a90cdd4cf131e9f760e6965df9048 upstream.

This interface will be used by PCI host drivers for PIO translation,
export it to support compiling those drivers as kernel modules.

Link: https://lore.kernel.org/r/20210420061723.989-3-jianjun.wang@mediatek.com
Signed-off-by: Jianjun Wang <jianjun.wang@mediatek.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4043,6 +4043,7 @@ phys_addr_t pci_pio_to_address(unsigned
 
 	return address;
 }
+EXPORT_SYMBOL_GPL(pci_pio_to_address);
 
 unsigned long __weak pci_address_to_pio(phys_addr_t address)
 {


