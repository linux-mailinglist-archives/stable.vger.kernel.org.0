Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224792B5F93
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 13:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgKQM5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:57:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728625AbgKQM5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 876BE24654;
        Tue, 17 Nov 2020 12:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617844;
        bh=U6Dbr4iZO3XiSTZ9y1UJzOMDaKGuF09Uj/1vLOAbWyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gb4ihYhmDsV3IidWycCzqQ7VjjN7NElgkkigB09NzlTO0uBRwDi95TrF7mdO3BEmH
         dHjFJZKC3mjiqaVu5k77YciMDLGnmlbycv02feYJ3mlYCPpOIk1UHn3WzgmnPsVhnv
         rPirFwxEv9p4JIdd+DFGH126+665/94tN62Z5Okw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 21/21] arm64: cpu_errata: Apply Erratum 845719 to KRYO2XX Silver
Date:   Tue, 17 Nov 2020 07:56:52 -0500
Message-Id: <20201117125652.599614-21-sashal@kernel.org>
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

[ Upstream commit 23c216416056148136bdaf0cdd18caf4904bb6e1 ]

QCOM KRYO2XX Silver cores are Cortex-A53 based and are
susceptible to the 845719 erratum. Add them to the lookup
list to apply the erratum.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20201104232218.198800-5-konrad.dybcio@somainline.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpu_errata.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 966672b2213e1..533a957dd83ee 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -750,6 +750,8 @@ static const struct midr_range erratum_845719_list[] = {
 	MIDR_REV_RANGE(MIDR_CORTEX_A53, 0, 0, 4),
 	/* Brahma-B53 r0p[0] */
 	MIDR_REV(MIDR_BRAHMA_B53, 0, 0),
+	/* Kryo2XX Silver rAp4 */
+	MIDR_REV(MIDR_QCOM_KRYO_2XX_SILVER, 0xa, 0x4),
 	{},
 };
 #endif
-- 
2.27.0

