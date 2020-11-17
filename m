Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541322B5FDA
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgKQM5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:57:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728612AbgKQM5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5163824686;
        Tue, 17 Nov 2020 12:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617843;
        bh=51+6+uPww+RmJBsPsYhNpnC8ORVfQ015jaj6oYZgpvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aECtkJ7wKr/VLhBOxDsIExGA0y2L2Ow+n2eeW20jN92PiuZJb6i1juYisanrIheX8
         ELL+gQL+VV3t3wSFUFiT4MQLEtsyA/+LE0KAaobWdAAF3U5x/y7dl4iNrUYd0/MiRR
         qSdbWz62TW0i+cavT+z5hFjqKLWnI5r6xclZWXtQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 20/21] arm64: kpti: Add KRYO2XX gold/silver CPU cores to kpti safelist
Date:   Tue, 17 Nov 2020 07:56:51 -0500
Message-Id: <20201117125652.599614-20-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125652.599614-1-sashal@kernel.org>
References: <20201117125652.599614-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit e3dd11a9f2521cecbcf30c2fd17ecc5a445dfb94 ]

QCOM KRYO2XX gold (big) silver (LITTLE) CPU cores are based on
Cortex-A73 and Cortex-A53 respectively and are meltdown safe,
hence add them to kpti_safe_list[].

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20201104232218.198800-3-konrad.dybcio@somainline.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6424584be01e6..9d0e4afdc8caa 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1333,6 +1333,8 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
 		MIDR_ALL_VERSIONS(MIDR_HISI_TSV110),
 		MIDR_ALL_VERSIONS(MIDR_NVIDIA_CARMEL),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_2XX_GOLD),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_2XX_SILVER),
 		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_3XX_SILVER),
 		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_SILVER),
 		{ /* sentinel */ }
-- 
2.27.0

