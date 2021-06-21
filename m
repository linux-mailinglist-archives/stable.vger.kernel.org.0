Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DBB3AE76D
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhFUKpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:45:11 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:34683 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229661AbhFUKpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:45:10 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id E94B31940218;
        Mon, 21 Jun 2021 06:42:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 21 Jun 2021 06:42:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uggCml
        +BhZW8hrPMFiT6mKMkTMfLOnGn+58bQ/ZysyU=; b=FyRHsljpA7xU5Zspz8+Izo
        no8RUNeGepeMgxnvcodB1LO05ifdXzk3nD/L1Fg4v0plt/Fcg1PZfMt1weo+rxPg
        YlZoncgft4CNZ8X4n3JXz71AXlAINp1ogqktbIPeQqF7ieO28YauSWQjs5Oj3hbU
        A1iOR6+bjRDdkr+9PwTYoqv3n+SDD+KKigIrgFTrPZhU/bWanIEd6EfpCYWpLBXw
        pUy7aTMj4YziVZqQpNXQB/Pey1N6XKc5o8oqQHPT2hxAXZrD+IYccS8ihuv0BwE0
        K+LiTb3+fiI1Ho99lMHd2f1VjJ0IPKEywA1rp4M2yxF6X3VVBeguZ0NvHqd6VZyw
        ==
X-ME-Sender: <xms:L23QYJTb0AL-AxCgum10eL7eoELSXkUA0eLYoyoU2sdz-YdY38BM3w>
    <xme:L23QYCySmuTGwkGtz1Gw0cr_zZOaFKRUmKW14fmvmHxTDHCx8uSWpD0AHJalqjziv
    B9yLOsP7hweqQ>
X-ME-Received: <xmr:L23QYO0cFBVMmxu2rueFgIDOA0W6NS1CDpjqs4hLw06thpmL5FPJkFzswl5o7PdY38VUmv_LJEIE9rz6wTHfko-rSL8qvKU_>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:L23QYBCr7IBiXCUUGH0foyh-JGfzLDViydIqbui0MwCdRsuef6FixA>
    <xmx:L23QYCj6eFXWlTcnfdfF4XaMx46FdobS9SoKPUPxc_sOIywD-Uw2qg>
    <xmx:L23QYFoPCeOeu6HsaN63oIGVmTS_gXManMsc5dqh86qEXWebvgLBzA>
    <xmx:L23QYDtGXuh5n4E4_j_WMgeUnuf0QKqc7XqqcXUXncOQH_B1M3NJ_A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:42:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: Mark AMD Navi14 GPU ATS as broken" failed to apply to e8946a53e2a698c148b3b3ed732f43c7747fbeb6-stable tree
To:     evan.quan@amd.com, alexander.deucher@amd.com, bhelgaas@google.com,
        kw@linux.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:42:40 +0200
Message-ID: <162427216018533@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the e8946a53e2a698c148b3b3ed732f43c7747fbeb6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e8946a53e2a698c148b3b3ed732f43c7747fbeb6 Mon Sep 17 00:00:00 2001
From: Evan Quan <evan.quan@amd.com>
Date: Wed, 2 Jun 2021 10:12:55 +0800
Subject: [PATCH] PCI: Mark AMD Navi14 GPU ATS as broken
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Observed unexpected GPU hang during runpm stress test on 0x7341 rev 0x00.
Further debugging shows broken ATS is related.

Disable ATS on this part.  Similar issues on other devices:

  a2da5d8cc0b0 ("PCI: Mark AMD Raven iGPU ATS as broken in some platforms")
  45beb31d3afb ("PCI: Mark AMD Navi10 GPU rev 0x00 ATS as broken")
  5e89cd303e3a ("PCI: Mark AMD Navi14 GPU rev 0xc5 ATS as broken")

Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20210602021255.939090-1-evan.quan@amd.com
Signed-off-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Krzysztof Wilczyński <kw@linux.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index dda0b1018162..877ce61619ca 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5241,7 +5241,8 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0422, quirk_no_ext_tags);
 static void quirk_amd_harvest_no_ats(struct pci_dev *pdev)
 {
 	if ((pdev->device == 0x7312 && pdev->revision != 0x00) ||
-	    (pdev->device == 0x7340 && pdev->revision != 0xc5))
+	    (pdev->device == 0x7340 && pdev->revision != 0xc5) ||
+	    (pdev->device == 0x7341 && pdev->revision != 0x00))
 		return;
 
 	if (pdev->device == 0x15d8) {
@@ -5268,6 +5269,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x6900, quirk_amd_harvest_no_ats);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7312, quirk_amd_harvest_no_ats);
 /* AMD Navi14 dGPU */
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7340, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7341, quirk_amd_harvest_no_ats);
 /* AMD Raven platform iGPU */
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x15d8, quirk_amd_harvest_no_ats);
 #endif /* CONFIG_PCI_ATS */

