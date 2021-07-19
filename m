Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA843CDF13
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345033AbhGSPHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345960AbhGSPFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:05:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F34460238;
        Mon, 19 Jul 2021 15:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709548;
        bh=gpjRWjPbeNOVff751auNa6T17/9i/Z6JF3WyIgzwXyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4kVzfGSCXEwRvErRLdOWTZDc1s7+G+PeH2Lgx/kz9yzzFmh4l7SsC4yX09iqtCYN
         OIhB29WC8pbkp90lWxWCuCnLcMbqW6X1HCEnxLunv6Bf6AyHuv9lkT2uTfvjJRTgfO
         X0sopZ1HeHC3H+pamtQzV1rYX8iwVtc4WaxxcxMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Vorel <petr.vorel@gmail.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 405/421] arm64: dts: qcom: msm8994-angler: Fix gpio-reserved-ranges 85-88
Date:   Mon, 19 Jul 2021 16:53:36 +0200
Message-Id: <20210719145000.376934427@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Vorel <petr.vorel@gmail.com>

[ Upstream commit f890f89d9a80fffbfa7ca791b78927e5b8aba869 ]

Reserve GPIO pins 85-88 as these aren't meant to be accessible from the
application CPUs (causes reboot). Yet another fix similar to
9134586715e3, 5f8d3ab136d0, which is needed to allow angler to boot after
3edfb7bd76bd ("gpiolib: Show correct direction from the beginning").

Fixes: feeaf56ac78d ("arm64: dts: msm8994 SoC and Huawei Angler (Nexus 6P) support")

Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20210415193913.1836153-1-petr.vorel@gmail.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
index dfa08f513dc4..e5850c4d3334 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
@@ -38,3 +38,7 @@
 		};
 	};
 };
+
+&tlmm {
+	gpio-reserved-ranges = <85 4>;
+};
-- 
2.30.2



