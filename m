Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7201499148
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378960AbiAXUKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359630AbiAXT75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:59:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D647C04D63B;
        Mon, 24 Jan 2022 11:28:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4579AB8119D;
        Mon, 24 Jan 2022 19:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDB8C340E5;
        Mon, 24 Jan 2022 19:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052497;
        bh=f9JKyd9rol/S9GiU0MrQzzrG3hpPdnm2HGeVfi+YH18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EpzoPg5OHAXl7SlfhfbsvrXD4iDYoeB9SUr6zfsLyvbACBLjKhC4GTGS3mbVRPNOR
         DYRKf+0x8kE6hZvsB+1DlYDpkGwsripCuQt4AguEUVRBnV2jdwy2fV8PhKfis/AYug
         KzhGnJDmcwfwqeQB+faynSJGwSy7bYn1L+ZsZbNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/320] arm64: dts: qcom: msm8916: fix MMC controller aliases
Date:   Mon, 24 Jan 2022 19:40:45 +0100
Message-Id: <20220124183955.808212535@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index 449843f2184d8..301c1c467c0b7 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -16,8 +16,8 @@
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



