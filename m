Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCEFEDB8C
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 10:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbfKDJVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 04:21:14 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53053 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726364AbfKDJVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 04:21:13 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C611F2207D;
        Mon,  4 Nov 2019 04:21:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 04 Nov 2019 04:21:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=SCZvf3
        0wtKZIWbLFBKxM3Eyr/jzs5WEZWeUP7h7QU7w=; b=qtLg6QlJreHcebNhKB+g4/
        3IhkocsO645eUjujmzZB2cZaql3SPcHQnuJu8sfEVYluQuHivMD9jUNFIk7DO3ci
        bQGrALU/wZYNohnvNHpeStBRl5hvy/181JluLMcfOOm/dSETOBlndxot2kmj8N4K
        LwVnJzp+vNzG6wBo4kJC/wlqbhVT9VrBVCw1/DARr4sb8WUAkUPx9mIXIeo8z54V
        J6PaoZCNXrJPUinQTpxIPj2OmeN8uihD3o13dv/shM1Vxcizb0gJD1PQOPEo8F8B
        uP296pOjA6Z+7B1GbNzzk4DdtutJr4gQscSbatjsA25MmPKAlT8XjcmQHVl0lCxQ
        ==
X-ME-Sender: <xms:iO2_XS9vwXK8vyFQamUUO9ktupcD-61_vtqLG22oNuj2QHDgroO9Jg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddufedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:iO2_XSrS9eZybcSdMHQrSD6-NErD4f9UQ01N5MavYY9p6_n5pX2okQ>
    <xmx:iO2_XTlWNWzd7Sp1QxxtBYoiDZgTa-Su6yE9BGRx7D0Hg2kSm_3ZrQ>
    <xmx:iO2_XfZAgUWs-jVq4pnSCqQxXCQH2bkspUQxuMl_Hp5WLiWH_FgZUw>
    <xmx:iO2_XZTD9uVx7IEmSRRSARriaBhK7yz8wk5qvAO1usZvg1oa9hwByQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3C98B8005C;
        Mon,  4 Nov 2019 04:21:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: cpufeature: Enable Qualcomm Falkor/Kryo errata 1003" failed to apply to 4.19-stable tree
To:     bjorn.andersson@linaro.org, broonie@kernel.org, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Nov 2019 10:21:07 +0100
Message-ID: <157285926713032@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

