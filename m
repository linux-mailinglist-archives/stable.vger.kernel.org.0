Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E3A499C04
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380295AbiAXV65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576067AbiAXVxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:53:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FA1C08B4F0;
        Mon, 24 Jan 2022 12:34:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A2F6B81229;
        Mon, 24 Jan 2022 20:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D487C340EA;
        Mon, 24 Jan 2022 20:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056459;
        bh=EgN3WYwHQlO/nVftIjAlxl6B3bD+NtPV1F3G+g/3siQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vmM3VDNGjnV2O953gjsZ9D6jDCzRGMzgShqxOUj94OP1i8OdKokL9lYuGUoQbcIVL
         51Up6KGIsFgVro8RCjlMP5l08LrLx+Qy6htmRF6xA1NXxYEsD3I6PGMkilzqAAgeqp
         BeFKdM22xPq/yzajNE9dN8JYZkLYzEuvf9fMuf0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 491/846] arm64: dts: qcom: sm8350: Shorten camera-thermal-bottom name
Date:   Mon, 24 Jan 2022 19:40:08 +0100
Message-Id: <20220124184117.950649359@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit f52dd33943ca5f84ae76890f352f6d9e12512c3f ]

Thermal zone names should not be longer than 20 names, which is indicated by
a message at boot. Change "camera-thermal-bottom" to "cam-thermal-bottom" to
fix it.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211114012755.112226-6-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index e91cd8a5e5356..296ffb0e9888c 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -2185,7 +2185,7 @@
 			};
 		};
 
-		camera-thermal-bottom {
+		cam-thermal-bottom {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 
-- 
2.34.1



