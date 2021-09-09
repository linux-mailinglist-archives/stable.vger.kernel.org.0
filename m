Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC3A4057B4
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238504AbhIINli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:41:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352828AbhIIMrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:47:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41C7463219;
        Thu,  9 Sep 2021 11:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188577;
        bh=VWA7NHbf1w0hEdSW9ID9USH1LNKqF5N+aY34kK5m2BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IYEBXu4TZo+8vtrouzoDKA9rsTdECYyOYEeu4l3U1g4kp8hBYDr72Yiu5fkZ+3EuQ
         Sq6r1b/GYa4eNbMs0pp+Y5EFgBxTi2q1bql9Pj7KyOOh5IIZs88YeQQRaL07g39Y8q
         une8K2utFjj27ubwwt89BXNGJPCuatHE05Pyye0mbImARVZfT7oczmWV5eht5WDH+z
         7hTWlyJG0PoHT8yomGZbKCXRGbfCK8dwZf65D3UfYfw3q2/QPQS2yhyADWDDzRVReC
         Bl36FJqY7MNPGvuakl5FZSqj+x2iovZe2imM9UrDRaP2xVRexy+puBtFUztdijkbX8
         S2XqNTBaIXANw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 055/109] arm64: dts: qcom: sdm660: use reg value for memory node
Date:   Thu,  9 Sep 2021 07:54:12 -0400
Message-Id: <20210909115507.147917-55-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit c81210e38966cfa1c784364e4035081c3227cf5b ]

memory node like other node should be node@reg, which is missing in this
case, so fix it up

arch/arm64/boot/dts/qcom/ipq8074-hk01.dt.yaml: /: memory: False schema does not allow {'device_type': ['memory'], 'reg': [[0, 1073741824, 0, 536870912]]}

Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20210308060826.3074234-18-vkoul@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074-hk01.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
index 70be3f95209b..830d9f2c1e5f 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
+++ b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
@@ -20,7 +20,7 @@ chosen {
 		stdout-path = "serial0";
 	};
 
-	memory {
+	memory@40000000 {
 		device_type = "memory";
 		reg = <0x0 0x40000000 0x0 0x20000000>;
 	};
-- 
2.30.2

