Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3EC328E7E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241511AbhCATc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:32:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241531AbhCAT0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:26:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BF7B652B8;
        Mon,  1 Mar 2021 17:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620175;
        bh=ODIyvMs48heoT53hwRo7ih7S59GYjxq6fhnZTgiJ8Ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKUCcBazjolL5/LhZaZNib3nBS/POr++rUwy9+P9NvVv9JOvg8qP4wFonWf0+iONd
         fAJ3pZ3cjoe30Aac5ihkXcflif8W5fXZVLPbNy2+RQX5ElV1G4v3gLZ1Wa5HCm7cXi
         61IDJm8KaUGmATNPugQbZn7LmaIlxSEBOYXYFp+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Foss <robert.foss@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 057/775] arm64: dts: qcom: sdm845-db845c: Fix reset-pin of ov8856 node
Date:   Mon,  1 Mar 2021 17:03:45 +0100
Message-Id: <20210301161204.523093690@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Foss <robert.foss@linaro.org>

[ Upstream commit d4863ef399a29cae3001b3fedfd2864e651055ba ]

Switch reset pin of ov8856 node from GPIO_ACTIVE_HIGH to GPIO_ACTIVE_LOW,
this issue prevented the ov8856 from probing properly as it did not respon
to I2C messages.

Fixes: d4919a44564b ("arm64: dts: qcom: sdm845-db845c: Add ov8856 & ov7251
camera nodes")

Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://lore.kernel.org/r/20201221100955.148584-1-robert.foss@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index c0b93813ea9ac..c4ac6f5dc008d 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -1114,11 +1114,11 @@
 		reg = <0x10>;
 
 		// CAM0_RST_N
-		reset-gpios = <&tlmm 9 0>;
+		reset-gpios = <&tlmm 9 GPIO_ACTIVE_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&cam0_default>;
 		gpios = <&tlmm 13 0>,
-			<&tlmm 9 0>;
+			<&tlmm 9 GPIO_ACTIVE_LOW>;
 
 		clocks = <&clock_camcc CAM_CC_MCLK0_CLK>;
 		clock-names = "xvclk";
-- 
2.27.0



