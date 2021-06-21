Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC103AE769
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhFUKo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:44:57 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:49521 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229661AbhFUKo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:44:56 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5B8F819402BF;
        Mon, 21 Jun 2021 06:42:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 21 Jun 2021 06:42:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Ih9iv+
        av7DO3iFAKNGsm2ffd8DasBgDE7sLOWn4r1DQ=; b=IqaxWlrPjlxsqnMtlB1TXa
        w6XJFrxVkxAxGiQxNSxh9efu+XKLsad+33qZ8Mxf12uL9qNDZIzDYW02sLyDTxef
        0+o6iI/WEKktuoeNyF7KNsOa7KyuoYk7WBcjvDEJ60fozXrpdncVJKQIBEOYJR1U
        p3gd8IlumnI8xMicLfLisMzSmUSpgn9fVxzjkr4jf5RzWsGVe4HtAJ4CqPKxRMLO
        zuoHaFLtjZtbc+26Zqi0/gfR/ZqUXX1TcsoRBwjxS677oPu9UpDzJPE8KsxGkXtX
        EtQxJfp10+YFl4c7ebUD2b1XcstukiWhp532YCkPD/QjBhjMe9kw0N0FVwHvMESQ
        ==
X-ME-Sender: <xms:IW3QYD8OacIZGmYo5KrR02DGKfzHUeCn5csJR_QFZlV6ao15k26C7w>
    <xme:IW3QYPvGkTU9kpCX0ezAAN5bJg4O7LjNgiPxfSkNAGYslzwo4Q5dmhydgieukxOS1
    PvuNDJSzJ0p0g>
X-ME-Received: <xmr:IW3QYBCTm9isSfS9Ew7P4qG6be6yRAA6VfMsSOEE8692LmvmYhjD0EzX2W388sU9NnxT4kYT1mdC2OqKj-FQKcncaTfrhZYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:IW3QYPdpAbh73vwhdo6SgSItIMxXMhU1UgAxW3Or4jixNsroPZhKVg>
    <xmx:IW3QYIPMxbsr3p-rwJUFoqRTgHu8hU9fUfIvfqnxdfMGzQ3xQ1JO6Q>
    <xmx:IW3QYBlioEwmPl3RhbCajMXg8nTHLViq_Thyr6f9NIuRIuShsGalsQ>
    <xmx:IW3QYNqR3xfxWefTwuHfnTrpWKx86wrWmbGMzoJ3pFdK7h0XTOpIuQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:42:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: Mark AMD Navi14 GPU ATS as broken" failed to apply to 4.19-stable tree
To:     evan.quan@amd.com, alexander.deucher@amd.com, bhelgaas@google.com,
        kw@linux.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:42:38 +0200
Message-ID: <162427215818042@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

