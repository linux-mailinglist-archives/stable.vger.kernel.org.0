Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4680B3F64E6
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239633AbhHXRIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:08:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239144AbhHXRGb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:06:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77FA6619E0;
        Tue, 24 Aug 2021 16:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824386;
        bh=QIDp6PZOsveV9JoWR4zsgP3h46AMLaiOP9ut1K7/tO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nN9R5vfr4AinkJ6Uye/Mm4BJcRK00sBHVkXJ4vqshj8x77tttI8g0Fhqiu95TvJgR
         lbr6JLHTrl9/2olo5Ou9z9r00zNcDZppZkOOsmOfxY/k1YQsTGis32kQa9UWzlytRt
         Oz7sEEhYWecUkJuOk6e/IwkxK3NrRs4gq4l1AAlFA7LWujYr6T2nWQVLLBe87BAJgU
         9j6vZIkKDe5boSSSYWriQHtf07Oez1jn4/S62Tw/R64OcjAkZfbRFOW7YP111QjKLh
         sqT7kIwGYuFRIAjPePJ6juJW1UQLudH28grRSfza48j+FtJKnPvKvBD3P7j5XDdxpH
         OiouK68O3ZKVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Vorel <petr.vorel@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 36/98] arm64: dts: qcom: msm8992-bullhead: Remove PSCI
Date:   Tue, 24 Aug 2021 12:58:06 -0400
Message-Id: <20210824165908.709932-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Vorel <petr.vorel@gmail.com>

[ Upstream commit 9d1fc2e4f5a94a492c7dd1ca577c66fdb7571c84 ]

Bullhead firmware obviously doesn't support PSCI as it fails to boot
with this definition.

Fixes: 329e16d5f8fc ("arm64: dts: qcom: msm8992: Add PSCI support.")
Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
Link: https://lore.kernel.org/r/20210713185734.380-2-petr.vorel@gmail.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
index 5969b5cfdc85..cb82864a90ef 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2015, LGE Inc. All rights reserved.
  * Copyright (c) 2016, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2021, Petr Vorel <petr.vorel@gmail.com>
  */
 
 /dts-v1/;
@@ -15,6 +16,9 @@
 	qcom,board-id = <0xb64 0>;
 	qcom,pmic-id = <0x10009 0x1000A 0x0 0x0>;
 
+	/* Bullhead firmware doesn't support PSCI */
+	/delete-node/ psci;
+
 	aliases {
 		serial0 = &blsp1_uart2;
 	};
-- 
2.30.2

