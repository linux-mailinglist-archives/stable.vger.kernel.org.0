Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B953E62C4
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 14:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfJ0NyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 09:54:11 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39801 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbfJ0NyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 09:54:10 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B87EC21C48;
        Sun, 27 Oct 2019 09:54:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 27 Oct 2019 09:54:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zRSD0P
        ockE+vyphVio4fd2aiKmUln9G1w2WoeBJAzIM=; b=c5lv0I/Fq71pKESuia5fb1
        hzujnMGv3Amh5HnphNkPwW42Wd1is7NdnCV5AmM5KzPiENnCkbnle6Cf5tbQSd6M
        vI7uyIPk/Xv5PHfwfV/TRhsYtDm6kdM6dAAhhQ3KJxGoRMMXaA/p1yuAPec1szbE
        PE9S3aGzCubuoAtOWF1gkegMwv19LtYIsxfukDeUvCmOmLj2xt0hjTlGIqf1XXQw
        pvdOqKAxatS3Pd8dE7hyCC97obqGXCBvqDk1/CgJgejoPwnnd8WWT8Q8RVsduc28
        wSAdrTwQa+M77N++UWODYCvqC4FyChaFAGg3KyDPmbeEDAOuUPb9goQCcxIgpQPw
        ==
X-ME-Sender: <xms:gaG1XVsk951o4sCl4cT8-G7FbTBwva__frjHI5QJJMuauMFonmFBmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleejgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepjeejrddvgedurddvvdelrddvfedvnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:gaG1XYQXGAltnI6rZOEwXPnatY4toGdYp5ylJeumEjiC7mqxB-YOfg>
    <xmx:gaG1XUOY1X0ZHnEJOk_Craoy6lwWUiJ_H_ln2PoA1_OsS9f73H4A9A>
    <xmx:gaG1XYmRNw_mcTGvm8-CsIWJirA9idWyZ8IbefMMa2iqIAt87w3F6w>
    <xmx:gaG1XcHeyDUzWHnxSIQyf6Rq0OWmQ4qvWBSRYPMMS-H0_sZCM7rPwA>
Received: from localhost (unknown [77.241.229.232])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46B078005B;
        Sun, 27 Oct 2019 09:54:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: Allow CAVIUM_TX2_ERRATUM_219 to be selected" failed to apply to 4.14-stable tree
To:     maz@kernel.org, marc.zyngier@arm.com, stable@vger.kernel.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Oct 2019 14:54:06 +0100
Message-ID: <1572184446145105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 603afdc9438ac546181e843f807253d75d3dbc45 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Fri, 13 Sep 2019 10:57:50 +0100
Subject: [PATCH] arm64: Allow CAVIUM_TX2_ERRATUM_219 to be selected

Allow the user to select the workaround for TX2-219, and update
the silicon-errata.rst file to reflect this.

Cc: <stable@vger.kernel.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 17ea3fecddaa..ab7ed2fd072f 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -107,6 +107,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Cavium         | ThunderX2 SMMUv3| #126            | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
+| Cavium         | ThunderX2 Core  | #219            | CAVIUM_TX2_ERRATUM_219      |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585         |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 41a9b4257b72..7d36fd95ae5a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -617,6 +617,23 @@ config CAVIUM_ERRATUM_30115
 
 	  If unsure, say Y.
 
+config CAVIUM_TX2_ERRATUM_219
+	bool "Cavium ThunderX2 erratum 219: PRFM between TTBR change and ISB fails"
+	default y
+	help
+	  On Cavium ThunderX2, a load, store or prefetch instruction between a
+	  TTBR update and the corresponding context synchronizing operation can
+	  cause a spurious Data Abort to be delivered to any hardware thread in
+	  the CPU core.
+
+	  Work around the issue by avoiding the problematic code sequence and
+	  trapping KVM guest TTBRx_EL1 writes to EL2 when SMT is enabled. The
+	  trap handler performs the corresponding register access, skips the
+	  instruction and ensures context synchronization by virtue of the
+	  exception return.
+
+	  If unsure, say Y.
+
 config QCOM_FALKOR_ERRATUM_1003
 	bool "Falkor E1003: Incorrect translation due to ASID change"
 	default y

