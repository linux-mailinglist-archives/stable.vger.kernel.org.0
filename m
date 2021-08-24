Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B349C3F63AC
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbhHXQ5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233396AbhHXQ5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBD1761368;
        Tue, 24 Aug 2021 16:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824196;
        bh=2NAkDIyTRrwqI+mj+MoaPNmUKhjmatcTuJPtOJKjMRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eb4L0z0baALmuj6SssfUn5zbIT9/1Pi2QZGxWwOvfdaOGSBtdeDN0vovDYCoJqfdB
         6G35x3aXvhgQ7WbUvu1O+F9MApfOs0+7P7Nok+Ko8mMbGh7rq4uVW4gQ4IXDyqrr5o
         iOaGo1ZIMNavi0+JV33TOitHjiuD+mUl5BGifxaFEj4NB5UvGrIh6+irkIlx12wZ8x
         Qnh/iRSe/Q4ED214rRzRssNWnHlA6MUuzVMR67upLMlwEoP6nNVqYseFF85J04H8aQ
         nz902vppx0jZz1a51kEKIVc3mhuNTdCSeYFyt8AMkcfeNuvoNpcVQFQl3oOa9N4GKf
         VugFF1IFvQpyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Vorel <petr.vorel@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 028/127] arm64: dts: qcom: msm8992-bullhead: Remove PSCI
Date:   Tue, 24 Aug 2021 12:54:28 -0400
Message-Id: <20210824165607.709387-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
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
index 23cdcc9f7c72..5c6e17f11ee9 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2015, LGE Inc. All rights reserved.
  * Copyright (c) 2016, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2021, Petr Vorel <petr.vorel@gmail.com>
  */
 
 /dts-v1/;
@@ -17,6 +18,9 @@
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

