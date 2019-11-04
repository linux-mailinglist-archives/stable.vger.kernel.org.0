Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C0CEE146
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 14:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbfKDNdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 08:33:05 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:58044 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727430AbfKDNdF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 08:33:05 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F120362AD44B81AB9603;
        Mon,  4 Nov 2019 21:33:02 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Mon, 4 Nov 2019 21:32:53 +0800
From:   Hanjun Guo <guohanjun@huawei.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, <stable@vger.kernel.org>
CC:     Will Deacon <will@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 4.19.82-rc1] arm64: Add MIDR encoding for HiSilicon Taishan CPUs
Date:   Mon, 4 Nov 2019 21:28:36 +0800
Message-ID: <1572874116-10831-1-git-send-email-guohanjun@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanjun Guo <hanjun.guo@linaro.org>

[ Upstream commit efd00c722ca855745fcc35a7e6675b5a782a3fc8 ]

Adding the MIDR encodings for HiSilicon Taishan v110 CPUs,
which is used in Kunpeng ARM64 server SoCs. TSV110 is the
abbreviation of Taishan v110.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Zhangshaokun <zhangshaokun@hisilicon.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
---
 arch/arm64/include/asm/cputype.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 9b7d5ab..fa770c0 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -68,6 +68,7 @@
 #define ARM_CPU_IMP_BRCM		0x42
 #define ARM_CPU_IMP_QCOM		0x51
 #define ARM_CPU_IMP_NVIDIA		0x4E
+#define ARM_CPU_IMP_HISI		0x48
 
 #define ARM_CPU_PART_AEM_V8		0xD0F
 #define ARM_CPU_PART_FOUNDATION		0xD00
@@ -96,6 +97,8 @@
 #define NVIDIA_CPU_PART_DENVER		0x003
 #define NVIDIA_CPU_PART_CARMEL		0x004
 
+#define HISI_CPU_PART_TSV110		0xD01
+
 #define MIDR_CORTEX_A53 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A53)
 #define MIDR_CORTEX_A57 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A57)
 #define MIDR_CORTEX_A72 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A72)
@@ -114,6 +117,7 @@
 #define MIDR_QCOM_KRYO MIDR_CPU_MODEL(ARM_CPU_IMP_QCOM, QCOM_CPU_PART_KRYO)
 #define MIDR_NVIDIA_DENVER MIDR_CPU_MODEL(ARM_CPU_IMP_NVIDIA, NVIDIA_CPU_PART_DENVER)
 #define MIDR_NVIDIA_CARMEL MIDR_CPU_MODEL(ARM_CPU_IMP_NVIDIA, NVIDIA_CPU_PART_CARMEL)
+#define MIDR_HISI_TSV110 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_TSV110)
 
 #ifndef __ASSEMBLY__
 
-- 
1.7.12.4

