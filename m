Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B53BFF49A6
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbfKHMEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:04:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:56062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730614AbfKHLmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:42:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E480521D82;
        Fri,  8 Nov 2019 11:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213335;
        bh=qpvMGZ3IB0+wiopYrxiriRauFzfeubkGQ+P4ZAm2Ydc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sj3M5RR+41T4TrcmAGjMmSE8c1qcNRicsd5UuWUIp/VbIflmTJ8oK54G7o+wnugpO
         DbDnshM7atjK+rr/9NJQRzmewXmJ2AzP+CtroCcGp7pJHMwDFEqLX3VlKVCyTDCFOV
         +rv58CFCYWCoR0l+BjWBvXrMN3SMZJzNfJ658ecQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        John Crispin <john@phrozen.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 173/205] ARM: dts: qcom: ipq4019: fix cpu0's qcom,saw2 reg value
Date:   Fri,  8 Nov 2019 06:37:20 -0500
Message-Id: <20191108113752.12502-173-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

[ Upstream commit bd73a3dd257fb838bd456a18eeee0ef0224b7a40 ]

while compiling an ipq4019 target, dtc will complain:
regulator@b089000 unit address format error, expected "2089000"

The saw0 regulator reg value seems to be
copied and pasted from qcom-ipq8064.dtsi.

This patch fixes the reg value to match that of the
unit address which in turn silences the warning.
(There is no driver for qcom,saw2 right now.
So this went unnoticed)

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: John Crispin <john@phrozen.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-ipq4019.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
index 54d056b01bb51..8328ad589e2ba 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -313,7 +313,7 @@
 
                 saw0: regulator@b089000 {
                         compatible = "qcom,saw2";
-                        reg = <0x02089000 0x1000>, <0x0b009000 0x1000>;
+			reg = <0x0b089000 0x1000>, <0x0b009000 0x1000>;
                         regulator;
                 };
 
-- 
2.20.1

