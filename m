Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56702EF3A9
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 03:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbfKECsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 21:48:14 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:43264 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728351AbfKECsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 21:48:14 -0500
X-IronPort-AV: E=Sophos;i="5.68,269,1569250800"; 
   d="scan'208";a="30832174"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 05 Nov 2019 11:48:13 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 10BD54151FA1;
        Tue,  5 Nov 2019 11:48:13 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     marek.vasut+renesas@gmail.com, linux-pci@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v3 0/2] PCI: rcar: Fix missing MACCTLR register setting (take2)
Date:   Tue,  5 Nov 2019 11:48:10 +0900
Message-Id: <1572922092-12323-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch series is based on the latest pci/rcar branch of Lorenzo's pci.git.
The commit 175cc093888e ("PCI: rcar: Fix missing MACCTLR register setting
in rcar_pcie_hw_init()") description/code don't follow the manual
accurately, so that it's difficult to understand. So, this patch
series reverts the commit at first, and then applies a new fixed patch.

Reference:
https://marc.info/?l=linux-renesas-soc&m=157242422327368&w=2

Changes from v2:
 - Rebase on the latest pcir/rcar branch.
 - Add Euguniu-san's Reported-by in the patch 2/2.
 - Add the bits definitions instead of magic number to make the initial value
   so that I don't add Euguniu-san's Reviewed-by tag in the patch 2/2.
 https://patchwork.kernel.org/project/linux-renesas-soc/list/?series=196557

Changes from v1:
 - Follow -stable rule in patch 1/2.
 - Add some comments about SPCHG bit of MACCTLR register.
https://patchwork.kernel.org/project/linux-renesas-soc/list/?series=195717

Yoshihiro Shimoda (2):
  Revert "PCI: rcar: Fix missing MACCTLR register setting in
    rcar_pcie_hw_init()"
  PCI: rcar: Fix missing MACCTLR register setting in initialize sequence

 drivers/pci/controller/pcie-rcar.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
2.7.4

