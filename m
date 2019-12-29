Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37C5112C33A
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 16:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfL2PzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 10:55:20 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58647 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfL2PzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 10:55:20 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 45AE321D46;
        Sun, 29 Dec 2019 10:55:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 10:55:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=B9OefY
        DlURlzMD1o2ZRc+TedS/g3KP0Q3qRoNnhtBiI=; b=i7K4rXXkB2WuTI6myv/JUs
        jDPtJVSy+HfGdUr7hI98UGvM336O5qjXBSWm1y90oHXID1YzRMdFGoHeXOV4FnV/
        0QbhPmMMIb97QDDFRkNBF8MGsuZ8Xz3BYhUFkHZTpItzyvw74HjMnnyY+7RB8xVR
        u9b0jUOD1LhGH5es446gdphIaWIemJphlyJSohvIwhd/e440TSlNnzxIhfaaWa2Q
        W/1j41gUjbNdvh+JbSF3fKWSDL3qmEq/cq4K7kd3bHrs43L+2a0nbeHYUqKzvn2b
        QRZikFpsJo4ffrCc1leqCKUMRkBg3K8srpGs/c/XEUKOmCULHkAbBBme77q8QueA
        ==
X-ME-Sender: <xms:ZswIXlo7PFV_KMIG-snriPeKM23B4a_9VYyB5KQeCNUAdmlYgGZ9eg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:ZswIXvVQtVg99opnVtxtLlH-yT4o61T-TSQP9jO_Y8OZ_ei0yJe_rw>
    <xmx:ZswIXoAsagnyE8fkrrSh0-rkAK9CZPPKt77xds7Zc-2lPxZGERFbjg>
    <xmx:ZswIXiQ1AkfLUm6D8Pd3blCu76SB1QZUCNXNLxWSfyy2PJ5D1wEsBQ>
    <xmx:Z8wIXtaqpAHOzG63BKd7CCUzxvuD_ntZjzKVF2_Rmq4Ead4OpWRMDQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0208130608D7;
        Sun, 29 Dec 2019 10:55:17 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/mce: Fix possibly incorrect severity calculation on AMD" failed to apply to 4.19-stable tree
To:     jschoenh@amazon.de, Yazen.Ghannam@amd.com, bp@suse.de,
        hpa@zytor.com, linux-edac@vger.kernel.org, mingo@kernel.org,
        stable@vger.kernel.org, tglx@linutronix.de, tony.luck@intel.com,
        x86@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 16:55:16 +0100
Message-ID: <157763491612458@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From a3a57ddad061acc90bef39635caf2b2330ce8f21 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>
Date: Tue, 10 Dec 2019 01:07:30 +0100
Subject: [PATCH] x86/mce: Fix possibly incorrect severity calculation on AMD
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The function mce_severity_amd_smca() requires m->bank to be initialized
for correct operation. Fix the one case, where mce_severity() is called
without doing so.

Fixes: 6bda529ec42e ("x86/mce: Grade uncorrected errors for SMCA-enabled systems")
Fixes: d28af26faa0b ("x86/MCE: Initialize mce.bank in the case of a fatal error in mce_no_way_out()")
Signed-off-by: Jan H. Schönherr <jschoenh@amazon.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Cc: Yazen Ghannam <Yazen.Ghannam@amd.com>
Link: https://lkml.kernel.org/r/20191210000733.17979-4-jschoenh@amazon.de

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 5f42f25bac8f..2e2a421c8528 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -819,8 +819,8 @@ static int mce_no_way_out(struct mce *m, char **msg, unsigned long *validp,
 		if (quirk_no_way_out)
 			quirk_no_way_out(i, m, regs);
 
+		m->bank = i;
 		if (mce_severity(m, mca_cfg.tolerant, &tmp, true) >= MCE_PANIC_SEVERITY) {
-			m->bank = i;
 			mce_read_aux(m, i);
 			*msg = tmp;
 			return 1;

