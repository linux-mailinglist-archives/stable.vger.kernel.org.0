Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFE7DE9AC1
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 12:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfJ3L1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 07:27:06 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:16210 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726065AbfJ3L1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Oct 2019 07:27:06 -0400
X-IronPort-AV: E=Sophos;i="5.68,247,1569250800"; 
   d="scan'208";a="30414671"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 30 Oct 2019 20:27:04 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id A07A4400C442;
        Wed, 30 Oct 2019 20:27:04 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     horms@verge.net.au, linux-pci@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 0/2] PCI: rcar: Fix missing MACCTLR register setting (take2)
Date:   Wed, 30 Oct 2019 20:27:02 +0900
Message-Id: <1572434824-1850-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
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


Yoshihiro Shimoda (2):
  Revert "PCI: rcar: Fix missing MACCTLR register setting in
    rcar_pcie_hw_init()"
  PCI: rcar: Fix missing MACCTLR register setting in initialize sequence

 drivers/pci/controller/pcie-rcar.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.7.4

