Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F98B2D45FC
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731342AbgLIPyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:54:44 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:55771 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731260AbgLIPye (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:54:34 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 04BC619433CC;
        Wed,  9 Dec 2020 04:12:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 04:12:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=OXZzs5
        Ws6aPUcrwa0fzdl8hJ4HYkMcqyhXKhHR2btZ0=; b=EitZDfxNKX8JItSLa6Ns8t
        lVxnsa9Z/4AbIDiqIEfIWC7ZkPB1vzV1GSM65Qq/YGQ7m3it2LStYRhkn5acvCfj
        cr8dqmb0LmhoaWw16gE/aKfIHZpP4o6aMiQTf37EcODvJCV1T7cIiwzyaC7QcQlt
        X6kszSZ1FAbvmkuGoam/L6pt23Ul1cw/VVxgijlsFeoN5uBC5bP3px+mPz24wSkL
        bdcPekfIyeueHUJqNyjtIFJF92nTffO8dBszF6OnfU3RcnVgZCNbNj6IgPoi2DSd
        co/hQ8Cn5x3N3y8NnEIPNulb10RpIvUzKd98PtvoyB2qWnzwuRg8o3Svlq6DCLSg
        ==
X-ME-Sender: <xms:BpXQXz67Olwae-nZdRHy131euCeTt43gaBbauX1RpGftP3HKyShWiA>
    <xme:BpXQX46JWbJqPoT9W6If7IW32HTlk_DSF79LHulpYQ2iMYBMReJ78TLc1rMKNMczX
    lSB1_aWDt1JJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejkedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:BpXQX6d9_UsNJJaNi08xovwS0_Xr77h1xDLQ2l2UMkCQuWxabxJUvQ>
    <xmx:BpXQX0L2qQbQbXCWGTlU4hYepn1L0vlcqCrL0GdDJ4Pd3eEk4nKi4A>
    <xmx:BpXQX3LquAb32tS2s11E93NOvkET2cdQZQql4DSIDGAeHEeonAmiPg>
    <xmx:B5XQX-UTuCR0md3c4CMM1hf_XQjJ6wuP1IvriPXo32LcWKyc1wL3PA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8720F108005F;
        Wed,  9 Dec 2020 04:12:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc/pseries: Pass MSI affinity to irq_create_mapping()" failed to apply to 4.19-stable tree
To:     lvivier@redhat.com, groug@kaod.org, mpe@ellerman.id.au,
        tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 10:13:56 +0100
Message-ID: <160750523681135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

