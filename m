Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3842C07CA
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733196AbgKWMoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:44:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733010AbgKWMoN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:44:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 033AA20888;
        Mon, 23 Nov 2020 12:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135453;
        bh=U6Dbr4iZO3XiSTZ9y1UJzOMDaKGuF09Uj/1vLOAbWyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLgGiZ9R3qnl6HQ+X9+Wjs8r3beqVNNXB2Qrr59jYDT3WJl3rg2p5BZwVNiBgHR5q
         y+YtuY8vG3/ybam0DVPxbiFF0PGfu/BUPHSckWKyVLda8QBAD6DGi6beyYP4qbQomk
         OEccV4Itnj66v8ahUWfGj1L5Z7arm3Z1GJ8c8zaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 073/252] arm64: cpu_errata: Apply Erratum 845719 to KRYO2XX Silver
Date:   Mon, 23 Nov 2020 13:20:23 +0100
Message-Id: <20201123121839.114353594@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



