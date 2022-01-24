Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64EBE49A934
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322318AbiAYDVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42724 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347363AbiAXUSp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:18:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBC3C61383;
        Mon, 24 Jan 2022 20:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B1CC36AE7;
        Mon, 24 Jan 2022 20:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055521;
        bh=zcjD8IIt5isRClkbcim/RGr754lvpzzmkoiQMRcYT3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9ibgw77QVe9/3LZTLQQNMr8ZmGeX1eocyQ8aLvyFZ+4WNp3kVlWg5N35dQMoC4Ae
         5+RxmGle/8j/O77Yw+hCAcFUocn8YFe/ku4VoVgQp7OxM4C6ucSqCIWHwgGATiiBgZ
         40L2gXqBYzkJkNuro6RW9gASQIp28Yaj8vjiX4bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 177/846] arm64: dts: qcom: msm8916: fix MMC controller aliases
Date:   Mon, 24 Jan 2022 19:34:54 +0100
Message-Id: <20220124184107.075270852@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit b0293c19d42f6d6951c2fab9a47fed50baf2c14d ]

Change sdhcN aliases to mmcN to make them actually work. Currently the
board uses non-standard aliases sdhcN, which do not work, resulting in
mmc0 and mmc1 hosts randomly changing indices between boots.

Fixes: c4da5a561627 ("arm64: dts: qcom: Add msm8916 sdhci configuration nodes")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211201020559.1611890-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index 427bb20626549..8b27242724641 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -19,8 +19,8 @@
 	#size-cells = <2>;
 
 	aliases {
-		sdhc1 = &sdhc_1; /* SDC1 eMMC slot */
-		sdhc2 = &sdhc_2; /* SDC2 SD card slot */
+		mmc0 = &sdhc_1; /* SDC1 eMMC slot */
+		mmc1 = &sdhc_2; /* SDC2 SD card slot */
 	};
 
 	chosen { };
-- 
2.34.1



