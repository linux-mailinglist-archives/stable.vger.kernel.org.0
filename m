Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 955DBE62C5
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 14:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfJ0NyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 09:54:19 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47711 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbfJ0NyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 09:54:19 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E8CEE21C08;
        Sun, 27 Oct 2019 09:54:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 27 Oct 2019 09:54:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Kh/stX
        BqeBQOtVQtTu9KVRb5BnjVYfdlr4msICyjM0Y=; b=HcvySiN+AcF3bN4OShttks
        dPmvAXfhylLW5IFQbaVw73L24lAwHX+HiH1iE7n/dS0Du25e/UDoRzdbabatkSNO
        ipwmBadM+4mkbiK8MeuT0xsdR1Rc0jM4qmH/mIfs/niozcFIBqZNCaUPZCUdHa95
        DwKu1P3Q4CpwEvikKlPmm14tTOp9Zf7pB+Vdz5rVNFpj6xXAnQ08La9wEZgoOora
        hEclZU/+mRA1q90qeMeNUmgbc2sxLkOyo8UCZPK0QeGTesDcl3iHn4FJJWP71e/C
        z2TMasSXRWIFLnq9DKfKwhnnRrwAW8M5Md1j9RvHZQ7MEMtong+b0pZjmjWKyUBQ
        ==
X-ME-Sender: <xms:iaG1XQZYe-6xaEegVbzFdEniC3zjrBs50RoeoP_7aycmQ9BbyFR-vQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleejgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepjeejrddvgedurddvvdelrddvfedvnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeh
X-ME-Proxy: <xmx:iaG1XTTpzM8Ks1qtOGET77OQOWYs-4PkdlgTFxcbOIa3v8CM15zwpQ>
    <xmx:iaG1XaViZ1vc4MEhp7MnSl-IAce_H6cOYEh9qFC5o1JD0LgmUZEtUQ>
    <xmx:iaG1XSbGEujfwg6a9EVb-bL0vT8NkpR-Bgoxb5GOUqK9rlH65tW9Ow>
    <xmx:iaG1XRRDgiEG3kbf77Bbaezi-Vkq6ndpUxADJ2b7y3u9-KflAkH8Dw>
Received: from localhost (unknown [77.241.229.232])
        by mail.messagingengine.com (Postfix) with ESMTPA id 91F74D6005A;
        Sun, 27 Oct 2019 09:54:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: Allow CAVIUM_TX2_ERRATUM_219 to be selected" failed to apply to 4.4-stable tree
To:     maz@kernel.org, marc.zyngier@arm.com, stable@vger.kernel.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Oct 2019 14:54:07 +0100
Message-ID: <1572184447101169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

