Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E9A2D45F4
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731130AbgLIPy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:54:29 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:43427 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731241AbgLIPy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:54:29 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 802441943AE3;
        Wed,  9 Dec 2020 04:10:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 09 Dec 2020 04:10:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=1N8Dkk
        swWdinb1rivHMLaE7FFj18syoWrBo5ch11pfI=; b=Vd8ulbj2F0mY3gVIgkzuRo
        7CDRhmbA9OU+wsgHJuUibU01wohAgNIdkNWa04tvzJQ9PetzegG9hqMGQwYA+pRq
        Af+qP8B2MSZr3+FfiUhWy6bvr63ecYrBSA4jCca4R31lCM5IcivM8AK9dvTavamq
        rlkQVkNZ+RrgcBoEyG9syoubRwJ9wjk2e4OJoc9nZa9sMzbFVI7sFdNlgKXpQP0l
        Get7nKlkTCpL5QtrmH2IVDj/fX0qcZ8f0TsiVnq06qcLn4iHVNUiQYo/wGrMxpH2
        yBcGCBlVkTra71/0obxKEcWE4ryDi2H7G64N72aUCiGF6vBguGY3gxqikaprVsAQ
        ==
X-ME-Sender: <xms:jZTQX5Et1Kphd2CB7ig-3OlqwSVMDepM_NjB9312_wT1SyH1yWx2fg>
    <xme:jZTQX39fiPhyLSYIT14ZUrXSnGoWDHLE0te2uUcRsqRUxwBkM2K-wZFJaeDNg_gqA
    W4Y4dmVeGTWpg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejkedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:jZTQX7K6wjQijp4-SIEKDwebtUlqHs9ios7xV2LT34CkZl9NmQupCA>
    <xmx:jZTQXyZyOxdxv7SYH5sHam2sNXWFIuTZeWk8FqMa3BJ1-7zxnTKiDA>
    <xmx:jZTQX9JBsGTao4vM3Kqg4tIemGlMzYPvP8jJluypubgA4NqRQ8AgTQ>
    <xmx:jpTQX_R8LD3FlKO9p4y59xiWjx1vbtgALP3kDrfBopyxZbTTU1hVsg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F6B824005B;
        Wed,  9 Dec 2020 04:10:37 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc/pseries: Pass MSI affinity to irq_create_mapping()" failed to apply to 4.9-stable tree
To:     lvivier@redhat.com, groug@kaod.org, mpe@ellerman.id.au,
        tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 10:11:55 +0100
Message-ID: <16075051153207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9ea69a55b3b9a71cded9726af591949c1138f235 Mon Sep 17 00:00:00 2001
From: Laurent Vivier <lvivier@redhat.com>
Date: Thu, 26 Nov 2020 09:28:52 +0100
Subject: [PATCH] powerpc/pseries: Pass MSI affinity to irq_create_mapping()

With virtio multiqueue, normally each queue IRQ is mapped to a CPU.

Commit 0d9f0a52c8b9f ("virtio_scsi: use virtio IRQ affinity") exposed
an existing shortcoming of the arch code by moving virtio_scsi to
the automatic IRQ affinity assignment.

The affinity is correctly computed in msi_desc but this is not applied
to the system IRQs.

It appears the affinity is correctly passed to rtas_setup_msi_irqs() but
lost at this point and never passed to irq_domain_alloc_descs()
(see commit 06ee6d571f0e ("genirq: Add affinity hint to irq allocation"))
because irq_create_mapping() doesn't take an affinity parameter.

Use the new irq_create_mapping_affinity() function, which allows to forward
the affinity setting from rtas_setup_msi_irqs() to irq_domain_alloc_descs().

With this change, the virtqueues are correctly dispatched between the CPUs
on pseries.

Fixes: e75eafb9b039 ("genirq/msi: Switch to new irq spreading infrastructure")
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Greg Kurz <groug@kaod.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201126082852.1178497-3-lvivier@redhat.com

diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index 133f6adcb39c..b3ac2455faad 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -458,7 +458,8 @@ static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec_in, int type)
 			return hwirq;
 		}
 
-		virq = irq_create_mapping(NULL, hwirq);
+		virq = irq_create_mapping_affinity(NULL, hwirq,
+						   entry->affinity);
 
 		if (!virq) {
 			pr_debug("rtas_msi: Failed mapping hwirq %d\n", hwirq);

