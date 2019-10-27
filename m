Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 373F8E62C8
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 14:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfJ0Nyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 09:54:55 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40973 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726736AbfJ0Nyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 09:54:55 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8251421C57;
        Sun, 27 Oct 2019 09:54:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 27 Oct 2019 09:54:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zRSD0P
        ockE+vyphVio4fd2aiKmUln9G1w2WoeBJAzIM=; b=Rqlk+cxBLhHJI+TEZU0iXp
        5Ery+fVe55ZHvzj4aGaOCAzb4JG+f0ha4Nllt3MubO478h+IC5YxhuByT994Myhs
        sVDvQcmmAAdPvIwEkOp3exfEmVUQwDJmb+QQVqSVHTekJMTU6GnyhJT9fDPxh78q
        vXCeraBdXnND9tvyZtk5vJ5dz+conFRjaJhMpcTm4QenwKA/pWWxRy9CnNdUzJtS
        hppaUeYnj8qfoFa2fgkW5BQAggn56oGS7GO/HwxdpvFI1VtDfzd2Ja19eG73GCdp
        3WiFG8E2PsXXiLiEe6c82gcVRyZZqgs6FkCE1aJ0lY8GOSZVYnLbHytXXYCO1z1w
        ==
X-ME-Sender: <xms:rqG1Xc7VJ3DQb9M0vHjEsgMpQcRSuQ-c-AzTQ3yNmOFFx15HjMXy_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleejgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepjeejrddvgedurddvvdelrddvfedvnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeek
X-ME-Proxy: <xmx:rqG1XWV3uJG6dyxaUMXXjRnrbFG8B7muMkcE6IE688AD4gM84ZhpEA>
    <xmx:rqG1Xb4D2VGLtRji_01RbUlQfslCVi9fiVVa51FhHV_NzHU-ZNw_DQ>
    <xmx:rqG1XRobYXDBA0q30UWNQp0_LpZjpqJ9h6FA5SbP9A57oKd_kmEtYA>
    <xmx:rqG1Xb0UxS16vURl3OQcRdRouhN0w52ZD0rEdWefuX0hwJvnrKcAYA>
Received: from localhost (unknown [77.241.229.232])
        by mail.messagingengine.com (Postfix) with ESMTPA id E07718005B;
        Sun, 27 Oct 2019 09:54:53 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: Allow CAVIUM_TX2_ERRATUM_219 to be selected" failed to apply to 4.14-stable tree
To:     maz@kernel.org, marc.zyngier@arm.com, stable@vger.kernel.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Oct 2019 14:54:43 +0100
Message-ID: <157218448320254@kroah.com>
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

