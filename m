Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586DD44A2FF
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242171AbhKIBZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:25:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:40848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243362AbhKIBPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:15:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE533619E8;
        Tue,  9 Nov 2021 01:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419994;
        bh=jK+KlWA15rDlMjhrFyJCeP1LJpavxjun6T9le43kq+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMWIZfnhMEp7rja3Yxrvw8LaOvDcT75uYobuQdsd3z2udVkhakStEQRiVjGp/Z1mo
         mjQZy/a2u+2L7mDsLPJm5s6uz4k4beXpgGlA+68ToFKZMg5hNsOz8bRF0t4pJf965F
         VQDt8pRizt06DTzAHVURuR8d8+mj2bFCGUox7wI9R1duzcYXWBXbhbOHRBzGEyStM3
         RY3yql8KD1pKu84sNbdshDu8L4pNaVJ0is6c2k6aH93Ux2cP3emaKSc2H6WK6mVKr7
         iLeXOg1WQfX4eeHGVIFHq1m4UNm7deDKhk7WvCpetVEyJHdsjkdmacBurShyzjiT6k
         gHn4UkTzPg/5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        maz@kernel.org, Dave.Martin@arm.com, tanxiaofei@huawei.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 41/47] arm64/sve: Add stub for sve_max_virtualisable_vl()
Date:   Mon,  8 Nov 2021 12:50:25 -0500
Message-Id: <20211108175031.1190422-41-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 49ed920408f85fb143020cf7d95612b6b12a84a2 ]

Fixes build problems for configurations with KVM enabled but SVE disabled.

Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20211022141635.2360415-2-broonie@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index dd1ad3950ef5d..5bd799ea683b4 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -130,6 +130,11 @@ static inline void fpsimd_release_task(struct task_struct *task) { }
 static inline void sve_sync_to_fpsimd(struct task_struct *task) { }
 static inline void sve_sync_from_fpsimd_zeropad(struct task_struct *task) { }
 
+static inline int sve_max_virtualisable_vl(void)
+{
+	return 0;
+}
+
 static inline int sve_set_current_vl(unsigned long arg)
 {
 	return -EINVAL;
-- 
2.33.0

