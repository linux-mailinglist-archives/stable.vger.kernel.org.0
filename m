Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDD54CB195
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 22:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbiCBVts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 16:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245148AbiCBVts (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 16:49:48 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA30E377CE
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 13:49:03 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 19so1749856wmy.3
        for <stable@vger.kernel.org>; Wed, 02 Mar 2022 13:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0EZ0ZZDKbttmMuQr6HS5DuLcIcw8xKbIn9si6rbczYk=;
        b=g+0bJZfRrtScbRJ7xdxOUfx06tNLKDbSsu0nTGITIKlTY8Jve8MnvPQJtxMAOZ+h3n
         UfkHyAC9KLr9zoeCR/GrGVW3NbJaqPEoDj5frX+Sl2XANVAVXIz1pJW1V5xLeP+Nxfep
         KplewcpgMjYFCEg2V6rDYI0Bw4i6R42BwgW5blDB18yJYasiJ0ipK17az1u6+vvZK33E
         94H1VaOAZ+qptp0ol2JhfUXVHWOLrZa4jWxZfYMWdP4b1cT3Nt++7j/vqSo+fzpF8gDj
         e5wDkQTT9JUA3iBMsl2+OBoLS4g4e58QZUCdfOQ+tLI9SM9/TaKxCX+kbK7dY+taTOCQ
         zG6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0EZ0ZZDKbttmMuQr6HS5DuLcIcw8xKbIn9si6rbczYk=;
        b=ZEXUzekgr0DRAlb4dgj7bpscVPX1uFwfqfK1qFAjtrA+H1k3ovBr4lG0IkCh250n/g
         7jK2aDbPwIOIMMfSw6hmpcn+3bNfbjRSglZVkl0COp5T/IRZ7+ywe4jaX9Lv57HnrXiI
         erJ0nDYkBlZeXhCC1ptnYt/LnFgG1cpDFldGTUxiY2VOIjLSVx5etiDMRWS87eWdqwLl
         G8yLFcrD6WAheO9AkbsmFq3qtm+BhhC7LxMxxZgzzgSBICysldO3ShQmq1bqqHU6YLM4
         OWbrawmkWcUqOL4Ptf6/O0YgKv92zzSoKQtuC7FEgj3tdIkmT+mJQvoR23bTr1us1rEC
         NkhA==
X-Gm-Message-State: AOAM530O9DWN4nR76C8Cs03JtzMG+8bcvTw8kWMOJNo0D9RYAnnNczTl
        Apz2B80OO8xcN1W1Wg1EokE=
X-Google-Smtp-Source: ABdhPJyr9c+dDMQTC4Em2peKMH+3xxXEsRMmDw93pyOaAPD/Rbct3LO/b0FgA5DmHEnUsJ7+3QxnQA==
X-Received: by 2002:a7b:c001:0:b0:381:1afd:5caa with SMTP id c1-20020a7bc001000000b003811afd5caamr1466781wmb.35.1646257742325;
        Wed, 02 Mar 2022 13:49:02 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id r188-20020a1c2bc5000000b00387c81c32e7sm235211wmr.8.2022.03.02.13.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 13:49:01 -0800 (PST)
Date:   Wed, 2 Mar 2022 21:49:00 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     lukas@wunner.de, bhelgaas@google.com, joseph.bao@intel.com,
        stuart.w.hayes@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: pciehp: Fix infinite loop in IRQ
 handler upon power" failed to apply to 4.19-stable tree
Message-ID: <Yh/mTMhOb9BgYtPg@debian>
References: <16429572572420@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NH7bZ4GS4JoitxZV"
Content-Disposition: inline
In-Reply-To: <16429572572420@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NH7bZ4GS4JoitxZV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sun, Jan 23, 2022 at 06:00:57PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--NH7bZ4GS4JoitxZV
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-PCI-pciehp-Fix-infinite-loop-in-IRQ-handler-upon-pow.patch"

From 971a38d2511fabcc73a38b51c368a8bfb5959658 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Wed, 17 Nov 2021 23:22:09 +0100
Subject: [PATCH] PCI: pciehp: Fix infinite loop in IRQ handler upon power
 fault

commit 23584c1ed3e15a6f4bfab8dc5a88d94ab929ee12 upstream.

The Power Fault Detected bit in the Slot Status register differs from
all other hotplug events in that it is sticky:  It can only be cleared
after turning off slot power.  Per PCIe r5.0, sec. 6.7.1.8:

  If a power controller detects a main power fault on the hot-plug slot,
  it must automatically set its internal main power fault latch [...].
  The main power fault latch is cleared when software turns off power to
  the hot-plug slot.

The stickiness used to cause interrupt storms and infinite loops which
were fixed in 2009 by commits 5651c48cfafe ("PCI pciehp: fix power fault
interrupt storm problem") and 99f0169c17f3 ("PCI: pciehp: enable
software notification on empty slots").

Unfortunately in 2020 the infinite loop issue was inadvertently
reintroduced by commit 8edf5332c393 ("PCI: pciehp: Fix MSI interrupt
race"):  The hardirq handler pciehp_isr() clears the PFD bit until
pciehp's power_fault_detected flag is set.  That happens in the IRQ
thread pciehp_ist(), which never learns of the event because the hardirq
handler is stuck in an infinite loop.  Fix by setting the
power_fault_detected flag already in the hardirq handler.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=214989
Link: https://lore.kernel.org/linux-pci/DM8PR11MB5702255A6A92F735D90A4446868B9@DM8PR11MB5702.namprd11.prod.outlook.com
Fixes: 8edf5332c393 ("PCI: pciehp: Fix MSI interrupt race")
Link: https://lore.kernel.org/r/66eaeef31d4997ceea357ad93259f290ededecfd.1637187226.git.lukas@wunner.de
Reported-by: Joseph Bao <joseph.bao@intel.com>
Tested-by: Joseph Bao <joseph.bao@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org # v4.19+
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/pci/hotplug/pciehp_hpc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 005817e40ad3..53227232243f 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -576,6 +576,8 @@ static irqreturn_t pciehp_isr(int irq, void *dev_id)
 	 */
 	if (ctrl->power_fault_detected)
 		status &= ~PCI_EXP_SLTSTA_PFD;
+	else if (status & PCI_EXP_SLTSTA_PFD)
+		ctrl->power_fault_detected = true;
 
 	events |= status;
 	if (!events) {
@@ -585,7 +587,7 @@ static irqreturn_t pciehp_isr(int irq, void *dev_id)
 	}
 
 	if (status) {
-		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, events);
+		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, status);
 
 		/*
 		 * In MSI mode, all event bits must be zero before the port
@@ -660,8 +662,7 @@ static irqreturn_t pciehp_ist(int irq, void *dev_id)
 	}
 
 	/* Check Power Fault Detected */
-	if ((events & PCI_EXP_SLTSTA_PFD) && !ctrl->power_fault_detected) {
-		ctrl->power_fault_detected = 1;
+	if (events & PCI_EXP_SLTSTA_PFD) {
 		ctrl_err(ctrl, "Slot(%s): Power fault\n", slot_name(slot));
 		pciehp_set_attention_status(slot, 1);
 		pciehp_green_led_off(slot);
-- 
2.30.2


--NH7bZ4GS4JoitxZV--
