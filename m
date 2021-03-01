Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8645B327E12
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbhCAMQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:16:24 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:52683 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232836AbhCAMQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 07:16:22 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2FCCA1941902;
        Mon,  1 Mar 2021 07:15:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 07:15:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Rx/Scs
        E7QI61SbTzmsVuCXL0i6vPdW5N85ISojea52o=; b=HoifjsuJ/x++ceH3nwwduO
        tG3iLw7q70kJB8kyxx9f65uitBIVeEQMtsb68Sx7ZoHOpWt018z52hOdExP9v2wX
        hOnVez6y54wPI3BMSqXhUlkmsiXZRY8V0jHLc8vahvg3t0vnHumyzSr9pnC9KihR
        pYdP7TqmDfQCOMSkuWDtZJ9POzmHUoZagOikE5g9jLEjUP4QCPFd/tdBfK5WKPhL
        n5P4UGXUYae/NzzuxlEv7bZUN1JWmHnuykmXim3LK13WoBVpAJ9ubxes5miHqkBZ
        CXJsHfJBqtorLODLF/WbjkiCY3BG+kbyc+2Ri69IA89/+TtLAI5V7dni0vhi78iQ
        ==
X-ME-Sender: <xms:5do8YEcrRTAcupHvtXG6bdskw1xJmMmtMMZj0hXYDu06pE0v43liYQ>
    <xme:5do8YGK4PpKaMmSf3NHFx6HkAXWjMVH3bHEWcXFkVKCGPxG0zZYrBm5Lrpua8Gqt3
    jivl0qGz2gN-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:5do8YCaD2TU08FRvgI5iWNZGlpRa1b5vJLWKxohzg0vyTHRlQsmDrg>
    <xmx:5do8YBvoI_aLV4lPoHhWoyKoTkeUi5-b7npgk_ll_nRZgl8hXs-J-w>
    <xmx:5do8YPsetYGi2S5o3eCtzrNnyLrz1JSjz-R4vIQZks-pbYLKhJBmRg>
    <xmx:5to8YPaeUUQc1n7PogIx-oHwNhL6sGgmOVbHoqUdscYiwIHneQOLlA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2E1E51080064;
        Mon,  1 Mar 2021 07:15:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: Extend workaround for erratum 1024718 to all versions" failed to apply to 5.4-stable tree
To:     suzuki.poulose@arm.com, catalin.marinas@arm.com,
        hayashi.kunihiko@socionext.com, james.morse@arm.com,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 13:15:22 +0100
Message-ID: <161460092211572@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From c0b15c25d25171db4b70cc0b7dbc1130ee94017d Mon Sep 17 00:00:00 2001
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Date: Wed, 3 Feb 2021 23:00:57 +0000
Subject: [PATCH] arm64: Extend workaround for erratum 1024718 to all versions
 of Cortex-A55

The erratum 1024718 affects Cortex-A55 r0p0 to r2p0. However
we apply the work around for r0p0 - r1p0. Unfortunately this
won't be fixed for the future revisions for the CPU. Thus
extend the work around for all versions of A55, to cover
for r2p0 and any future revisions.

Cc: stable@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20210203230057.3961239-1-suzuki.poulose@arm.com
[will: Update Kconfig help text]
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index f39568b28ec1..3dfb25afa616 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -522,7 +522,7 @@ config ARM64_ERRATUM_1024718
 	help
 	  This option adds a workaround for ARM Cortex-A55 Erratum 1024718.
 
-	  Affected Cortex-A55 cores (r0p0, r0p1, r1p0) could cause incorrect
+	  Affected Cortex-A55 cores (all revisions) could cause incorrect
 	  update of the hardware dirty bit when the DBM/AP bits are updated
 	  without a break-before-make. The workaround is to disable the usage
 	  of hardware DBM locally on the affected cores. CPUs not affected by
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e99eddec0a46..db400ca77427 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1455,7 +1455,7 @@ static bool cpu_has_broken_dbm(void)
 	/* List of CPUs which have broken DBM support. */
 	static const struct midr_range cpus[] = {
 #ifdef CONFIG_ARM64_ERRATUM_1024718
-		MIDR_RANGE(MIDR_CORTEX_A55, 0, 0, 1, 0),  // A55 r0p0 -r1p0
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
 		/* Kryo4xx Silver (rdpe => r1p0) */
 		MIDR_REV(MIDR_QCOM_KRYO_4XX_SILVER, 0xd, 0xe),
 #endif

