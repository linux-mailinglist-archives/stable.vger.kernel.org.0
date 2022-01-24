Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF1749A33F
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386405AbiAXX5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846016AbiAXXOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:14:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A5FC061A83;
        Mon, 24 Jan 2022 13:22:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9526161469;
        Mon, 24 Jan 2022 21:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D76C340E5;
        Mon, 24 Jan 2022 21:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059328;
        bh=Pubd9XPMb1C5VzQiXmeoVrk3Q+1SvW5q7o0MHI7eAGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBWaCxsP6BMMUGT1CBIKE7Nwf8WQI+uy2h0E+ldS+xT9QWRzxocNBX/khqjc6m/5T
         Uk0CSiOEJ8tFO2mD4iE9F7h36yDO7+/AaIBJ8s7XUn16AjQu4qU/gR7wSkD8jkyBhP
         7hFkQbeguNzucTeG6IZb6h6ABSs11rwTZL56sXCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0578/1039] arm64: dts: qcom: sm8350: Shorten camera-thermal-bottom name
Date:   Mon, 24 Jan 2022 19:39:27 +0100
Message-Id: <20220124184144.776109178@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index a8c040c564096..c13858cf50dd2 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -2447,7 +2447,7 @@
 			};
 		};
 
-		camera-thermal-bottom {
+		cam-thermal-bottom {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 
-- 
2.34.1



