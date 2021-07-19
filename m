Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC1F3CE37C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346249AbhGSPim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348809AbhGSPfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3E75611F2;
        Mon, 19 Jul 2021 16:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711292;
        bh=Gb9zFMGBXfir8GeCh+VGx5XxS566nl2HzZq1yD787+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FG8qclE8zD8uTdY7kC5up/yC4JeRzCjuH+F4hMeji3OET+iFuSU6tu/ifvSz+ttjq
         yP+diYKNdUuOBtCFT1ELSpLUciTHdur8PKsFdLBaqOBFkGG1S2fyx4OYVaJuMwUy9O
         4IfVXALuL+SZrIG5EfisFPaPmL5uJ9m0ziwTwwac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Vorel <petr.vorel@gmail.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 299/351] arm64: dts: qcom: msm8994-angler: Fix gpio-reserved-ranges 85-88
Date:   Mon, 19 Jul 2021 16:54:05 +0200
Message-Id: <20210719144954.941375072@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index baa55643b40f..ffe1a9bd8f70 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
@@ -32,3 +32,7 @@
 		};
 	};
 };
+
+&tlmm {
+	gpio-reserved-ranges = <85 4>;
+};
-- 
2.30.2



