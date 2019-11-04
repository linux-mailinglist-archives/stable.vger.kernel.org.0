Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC00FEEF37
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388860AbfKDWAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:00:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:58102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388855AbfKDWA3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:00:29 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFCCD21744;
        Mon,  4 Nov 2019 22:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904829;
        bh=N5U55wIakqyhRe6UX1Xc0Agm3a6SqaU6CQ7eXxYzCJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bddIx1LSRlfAAg5FpRwNgu9Q+dNUSojFkfd6Y75Z7/oVJwBOqGp9j9OipFf2BHmGL
         8pnLK0l8zzq0sS0SPa+B4gyzEJXzQav+sq9nx1Si1LRi//KFXSmC4cGOt94vu6lC+2
         H6176Fcb11hk3V2jNNCfQq9gkspEiw/CNA39qaac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanjun Guo <hanjun.guo@linaro.org>,
        John Garry <john.garry@huawei.com>,
        Zhangshaokun <zhangshaokun@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 4.19 043/149] arm64: Add MIDR encoding for HiSilicon Taishan CPUs
Date:   Mon,  4 Nov 2019 22:43:56 +0100
Message-Id: <20191104212138.923940327@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanjun Guo <hanjun.guo@linaro.org>

commit efd00c722ca855745fcc35a7e6675b5a782a3fc8 upstream.

Adding the MIDR encodings for HiSilicon Taishan v110 CPUs,
which is used in Kunpeng ARM64 server SoCs. TSV110 is the
abbreviation of Taishan v110.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Zhangshaokun <zhangshaokun@hisilicon.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/cputype.h |    4 ++++
 1 file changed, 4 insertions(+)

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
 


