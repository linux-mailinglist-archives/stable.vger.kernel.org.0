Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA933AE76A
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhFUKpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:45:05 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:54183 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229890AbhFUKpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:45:05 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8C3881940218;
        Mon, 21 Jun 2021 06:42:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 21 Jun 2021 06:42:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uSf0w7
        dowZVpV5yqBqNwsr+4jOT8oFK11Zha1d0b/3I=; b=YSeot6Z82KjyUbz6GUMa5o
        X3AZism7nq1aerxj1VMzkRFYNV4gcIm6FBkn+ITpdrwy0R2T5rPbxJNPKaSurl/w
        N6eRa393+HnzI10jOzi2bLgh/puWGVfmhFqETjJ8e21Z4uszR2tuQ8Izxk/+WanI
        dd8EbK9dtmOzrCpB4ma/sRHYXyBqIsOobRDfRITcHEmXpMmKph3TaBfeWacJdvgl
        ywG0nj6U8vB8QaciKMgeUjwu3VHVNdKnWrnw9erMxb3f6J4OSsUfhwU8OYYR4XtN
        J6/2tOoNV4wFO0SBxnD8Hz8G/dyzBxClUMF8DYEVth1vSSeOvb50AZUdxFK8pvSA
        ==
X-ME-Sender: <xms:Km3QYEqoNiuqFYJq500i2VgFTqTiPVsAImfRLUvkhZw9-aXS17rMAA>
    <xme:Km3QYKo_phmSx5mXY8iNEzk8aEvqL3wGYjUR5-XOZbM2qoBjidgYiLqFczSyqyyCa
    sN-b5PvQOa57g>
X-ME-Received: <xmr:Km3QYJMvFF0fkZOgmsQx8qYeOxjvMiU5TB4nC-6dtIx3chhfWeHBQ3xXH7iCodRdVbDT9GvwshXWHBWzA9ShptDmiuEEYSWJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:Km3QYL6_vV6JMsMm1Qs314kSQnhkXlS6L9V_neCAuz8djh5BIsVt9w>
    <xmx:Km3QYD4ce5QJG62sM03Ke-jwPcn-70nX9Oeozllzc25gtk7TYHd6RQ>
    <xmx:Km3QYLhW2SFMTsFBAk-EXy_0ELV_j1fWEl5k4Pn0DlVCnef1GyyT8A>
    <xmx:Km3QYFnbIBBgMv0tG-ZrLci2zDT4xT4uLl4LjwecagZcLhA7MGWNmw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:42:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: Mark AMD Navi14 GPU ATS as broken" failed to apply to 5.10-stable tree
To:     evan.quan@amd.com, alexander.deucher@amd.com, bhelgaas@google.com,
        kw@linux.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:42:39 +0200
Message-ID: <1624272159224240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

