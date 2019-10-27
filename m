Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A573CE62C6
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 14:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfJ0NyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 09:54:20 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55715 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbfJ0NyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 09:54:20 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1064621C7D;
        Sun, 27 Oct 2019 09:54:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 27 Oct 2019 09:54:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=GmORYs
        GWWwCe2/jJRU3aBwd3LFGVNox18oiALyQv1rc=; b=IWaQeDSYyERL80/lKz3hL0
        pRwFcuQElWKcWzn9h3dnxIDAwjTrma3OB1OCYIcJFz3j7YZSR7dyIV2Hf0wtBfoQ
        EuBxchblBV4S6+mfLbRJfkoYdaqFdR8KahjZXXv1kHXan95q2F1viXVyrBR6Q9pQ
        T3hOVhZJwzDFmkapYs/T2hMqzFIGCtXepK9biqkSPNPufkZk1HUtv3Diz7lWSBo7
        466y2N3fQ5HeODSVre043XvEPk4/K4YFfAUa5tXfzE5KNZ9DIWSNbY5wyfuuJFLN
        OrWqjjlpZFwx3rM2hNaYetsyYtpFbScFGr8ZV66SROTNibUzQkFrW9ALcf4QbEPA
        ==
X-ME-Sender: <xms:iqG1XQSOhreocgw17ZA2jrDdwYiGyM466dLlakjfZBb5FNCuzT16qQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleejgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepjeejrddvgedurddvvdelrddvfedvnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeh
X-ME-Proxy: <xmx:iqG1XX1v372lafge6Wnx8FMliNQszBPpUeYVCBqjf4H35JqpNt-rSQ>
    <xmx:iqG1XdshYzesai5J7pmMv7NwW5bVILc6QUzTx_J-EQBDF6DXFhjpWw>
    <xmx:iqG1XVgn7VNrSUgU2-6FMkr5Re2jjDXdPTwFvZKQl5GsNgkluV2ttA>
    <xmx:i6G1Xfk978hq0u7nzN3R-xj1-B55ItZTf_0IowyNbmsFu9lycPkNIg>
Received: from localhost (unknown [77.241.229.232])
        by mail.messagingengine.com (Postfix) with ESMTPA id AA08880060;
        Sun, 27 Oct 2019 09:54:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: Allow CAVIUM_TX2_ERRATUM_219 to be selected" failed to apply to 4.9-stable tree
To:     maz@kernel.org, marc.zyngier@arm.com, stable@vger.kernel.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Oct 2019 14:54:07 +0100
Message-ID: <1572184447233154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

