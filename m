Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB06EDB8D
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 10:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfKDJVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 04:21:18 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51083 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726364AbfKDJVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 04:21:18 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D54982203C;
        Mon,  4 Nov 2019 04:21:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 04 Nov 2019 04:21:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=3rm787
        M0XnqF0plsr/V2SdtLlK3ANeHwxtUO8j6LsJg=; b=vVnNjJQkVG/yN+qCg30XlW
        zmcfMBcKP965t/0mmxvKoz0roM5ltdiH0aZFZkv9CVKWEOXIjQmaR8fZsnqrB/Ae
        OAfon+WGGbU5vjg9vWWSmxid7tt1P8J+SDUxGfu/7/zHerzPc6qOqFLMzNr5LWbH
        XHZyJJH9h8cLtYPLdbe8qF8hsUtCikteIRWuaejE16P+/wtgahQ6y85vauhURSg2
        zJCxDii1u3Hsp1Fs7i4Y87FDJPpK72JluJ+XZo4pIT1SNf7a5BTzAetDzu1nLLIH
        jlu1FkDbwhOkAIReHoq10aUf77E7wXdYyiwLV2SwFECRNfNe5NXlMAheF7WgMefw
        ==
X-ME-Sender: <xms:je2_Xb1o9qMbuvywJNBumLRy3wzMZ96ijxhPC7P3Xhnmlj1VzyQdag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddufedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:je2_XeVbZUewSwJFYuOMtm07KgN33BQcDU2EXYnPUWjFAlLiZB4aLQ>
    <xmx:je2_XW7LfoW6QxY60Rt2ODxaaajxx_DjNZguOqy7wB8n_-mxFUh-RA>
    <xmx:je2_XVJ7KL7cviL48SHznsI-QsWaD6F1dmxVvK9bgbuKCG5ZXAr4Gw>
    <xmx:je2_Xem8PzZhUPygFAEya8a7eOEsjX2_VpriYUR-lN03uiaDRYvP3w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5815180059;
        Mon,  4 Nov 2019 04:21:17 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: cpufeature: Enable Qualcomm Falkor/Kryo errata 1003" failed to apply to 4.14-stable tree
To:     bjorn.andersson@linaro.org, broonie@kernel.org, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Nov 2019 10:21:08 +0100
Message-ID: <1572859268158229@kroah.com>
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

From d4af3c4b81f4cd5662baa6f1492f998d89783318 Mon Sep 17 00:00:00 2001
From: Bjorn Andersson <bjorn.andersson@linaro.org>
Date: Tue, 29 Oct 2019 10:15:39 -0700
Subject: [PATCH] arm64: cpufeature: Enable Qualcomm Falkor/Kryo errata 1003

With the introduction of 'cce360b54ce6 ("arm64: capabilities: Filter the
entries based on a given mask")' the Qualcomm Falkor/Kryo errata 1003 is
no long applied.

The result of not applying errata 1003 is that MSM8996 runs into various
RCU stalls and fails to boot most of the times.

Give 1003 a "type" to ensure they are not filtered out in
update_cpu_capabilities().

Fixes: cce360b54ce6 ("arm64: capabilities: Filter the entries based on a given mask")
Cc: stable@vger.kernel.org
Reported-by: Mark Brown <broonie@kernel.org>
Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 6c3b10a41bd8..7f9b699969c7 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -816,6 +816,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 		.desc = "Qualcomm Technologies Falkor/Kryo erratum 1003",
 		.capability = ARM64_WORKAROUND_QCOM_FALKOR_E1003,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = cpucap_multi_entry_cap_matches,
 		.match_list = qcom_erratum_1003_list,
 	},

