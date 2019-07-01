Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 577195B570
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 08:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfGAG7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 02:59:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfGAG7P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 02:59:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5375D205F4;
        Mon,  1 Jul 2019 06:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561964354;
        bh=RukBlqV7ZtThErCx8+0Q3nv/JJbPxuUCVKhZxxVFFYw=;
        h=Subject:To:From:Date:From;
        b=VoNloH4HSes5v34qecpUXUUogw+38GCJTnC3eRxtnFSSUwdL3EdYXFdfNJZQTAVqk
         3G2Gn+e0+9y3z8KGzuvPnoGGUNwEtUPZ1bCtFp95n/rmxITknsdnIZDHC99qM/vaiz
         q820GBfvphK6L+yHeUkcz8w0xWeRPdr4Hw8LB22E=
Subject: patch "staging: mt7621-pci: fix PCIE_FTS_NUM_LO macro" added to staging-testing
To:     sergio.paracuellos@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Jul 2019 08:59:04 +0200
Message-ID: <156196434418672@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: mt7621-pci: fix PCIE_FTS_NUM_LO macro

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 0ae0cf509d28d8539b88b5f7f24558f5bfe57cdf Mon Sep 17 00:00:00 2001
From: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date: Wed, 26 Jun 2019 14:43:18 +0200
Subject: staging: mt7621-pci: fix PCIE_FTS_NUM_LO macro

Add missing parenthesis to PCIE_FTS_NUM_LO macro to do the
same it was being done in original code.

Fixes: a4b2eb912bb1 ("staging: mt7621-pci: rewrite RC FTS configuration")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/mt7621-pci/pci-mt7621.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/mt7621-pci/pci-mt7621.c b/drivers/staging/mt7621-pci/pci-mt7621.c
index a981f4f0ed03..89fa813142ab 100644
--- a/drivers/staging/mt7621-pci/pci-mt7621.c
+++ b/drivers/staging/mt7621-pci/pci-mt7621.c
@@ -42,7 +42,7 @@
 /* MediaTek specific configuration registers */
 #define PCIE_FTS_NUM			0x70c
 #define PCIE_FTS_NUM_MASK		GENMASK(15, 8)
-#define PCIE_FTS_NUM_L0(x)		((x) & 0xff << 8)
+#define PCIE_FTS_NUM_L0(x)		(((x) & 0xff) << 8)
 
 /* rt_sysc_membase relative registers */
 #define RALINK_CLKCFG1			0x30
-- 
2.22.0


