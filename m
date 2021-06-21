Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8883AE76C
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFUKpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:45:10 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:50437 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229804AbhFUKpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:45:10 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1948E194033D;
        Mon, 21 Jun 2021 06:42:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 21 Jun 2021 06:42:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=wYx/Bn
        XpuYRkfeOJg4g/hy60RfHZuwdE5C/yFePAwyk=; b=pyVSX8/qydRYgLUNLRO+Ku
        BkbndFJyP8eSg44uWJqnUDwMgH6A51t21oEYqiVIDbctmWIa2FAKejqtZEUnzBBl
        piZ9/Wzvi0gB1s78ho//fqjZF4NfgD3JI0qbXpFNfPX5CtvGQ+plS2VSK79hTheV
        Gx0p51VdjfSz2rwXNb/zKGUkdP2M2gzc4CnUj35ZHM/pqgRJNdZEoO0DMt0DTSCv
        s8EZ9jtlv3i4uv86ILS/P5eJ+3j2dVLdR85wTR9mZhsW6UNQGuW30Y2oQNkxfloR
        WowPgSvEmmh60AprgvJoTi0AfpzIhYpQ7hkHIk0LIJRwknXoyw41XD2Zh39zsmGg
        ==
X-ME-Sender: <xms:LG3QYPjw6SIKsznxmkH1mAIWxejOxHbTdcYOVdKPNgPeAbnLSTWYYQ>
    <xme:LG3QYMCFsIjY0ecRCge7M67S_xmvB7G1uFVeIzLkVK4_g7tCoCBvbhuu1NxwgjwQx
    tCxtx5wMLQXyg>
X-ME-Received: <xmr:LG3QYPHKs49s37Gz7b1dWAnVNQsaNLM9joBDIII7Mhw3785VejOg-bYrngw61rctjhBbMoH1GHD22AT-tn-1YMgfl_EDxCm->
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:LG3QYMRa8RBAwjioptcZ3W_EDPhMRunt9o9BIFd-Ga72gPuotlld3A>
    <xmx:LG3QYMyBQ-9u1hosONODSc4JsAV6ckkvNWcrySZTCnHdyV3lReFPvg>
    <xmx:LG3QYC4oUpfbCWmlZZ7sH1FME2jijSKFli46-M_D4E8FBiA9Je5xQw>
    <xmx:LW3QYI8l2s5nTJt0eCFpfKQSllH8QymdQQIR0T-C_gHrf40VKdjQzw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:42:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: Mark AMD Navi14 GPU ATS as broken" failed to apply to 5.4-stable tree
To:     evan.quan@amd.com, alexander.deucher@amd.com, bhelgaas@google.com,
        kw@linux.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:42:39 +0200
Message-ID: <162427215994137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

