Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A51F428F3E
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237766AbhJKN4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237862AbhJKNye (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:54:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 568C6610CC;
        Mon, 11 Oct 2021 13:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960340;
        bh=6hvihozSgGjPmz/3nASpO5tEwLMVh+jlhT5AeGs0SEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOI7aj/yHOdtnCzVjsoVO3SrUfd5PoQi9K/AvB58xWuWYnketvNnSfsL1VAF8uYdY
         9X8Ph8Pu6QRjo6KKENw+z7pVuKmDRfB0Mbafgrpykzq3sF6WUqOmOfCHYri8w9Th8p
         NSq2vDFgZtA+v7DZ7iwyKjaYNeoXRy7ePfWDXbbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Amit Pundir <amit.pundir@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/83] arm64: dts: qcom: pm8150: use qcom,pm8998-pon binding
Date:   Mon, 11 Oct 2021 15:45:51 +0200
Message-Id: <20211011134509.440004522@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a153d317168aa3d61a204fadc85bac3995381d33 ]

Change pm8150 to use the qcom,pm8998-pon compatible string for the pon
in order to pass reboot mode properly.

Fixes: 5101f22a5c37 ("arm64: dts: qcom: pm8150: Add base dts file")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210916151341.1797512-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm8150.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pm8150.dtsi b/arch/arm64/boot/dts/qcom/pm8150.dtsi
index 1b6406927509..82edcd74ce98 100644
--- a/arch/arm64/boot/dts/qcom/pm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm8150.dtsi
@@ -48,7 +48,7 @@
 		#size-cells = <0>;
 
 		pon: power-on@800 {
-			compatible = "qcom,pm8916-pon";
+			compatible = "qcom,pm8998-pon";
 			reg = <0x0800>;
 			pwrkey {
 				compatible = "qcom,pm8941-pwrkey";
-- 
2.33.0



