Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA7F211817
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgGBBZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728502AbgGBBXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A849B2083E;
        Thu,  2 Jul 2020 01:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653031;
        bh=RBIbnZzztTdxZ/SbCqbKeaEtPBUQ+wEz5vBOHX/Wrjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHQUu7FtU3nGIxL2D7Bi7T3krfNPaxV/cQdo9r3XS+Xj+P2hKar89MIe8mbxYihND
         30ZpV4dwhTPXvOckJZs7536zdw9FjjWENY1jwLh34SNtLyNwqo3qlrMPFZIDNDWpaU
         akq8LIve+nUI+gl9RgOMVzh1CBrC9bVGiztDlMjc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 45/53] arm64: kpti: Add KRYO{3, 4}XX silver CPU cores to kpti safelist
Date:   Wed,  1 Jul 2020 21:21:54 -0400
Message-Id: <20200702012202.2700645-45-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

[ Upstream commit f4617be35b4b547e82d30993f56d631dfc2d5f88 ]

QCOM KRYO{3,4}XX silver/LITTLE CPU cores are based on Cortex-A55
and are meltdown safe, hence add them to kpti_safe_list[].

Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Link: https://lore.kernel.org/r/20200624123406.3472-1-saiprakash.ranjan@codeaurora.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9fac745aa7bb2..b0fb1d5bf2235 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1059,6 +1059,8 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
 		MIDR_ALL_VERSIONS(MIDR_HISI_TSV110),
 		MIDR_ALL_VERSIONS(MIDR_NVIDIA_CARMEL),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_3XX_SILVER),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_SILVER),
 		{ /* sentinel */ }
 	};
 	char const *str = "kpti command line option";
-- 
2.25.1

