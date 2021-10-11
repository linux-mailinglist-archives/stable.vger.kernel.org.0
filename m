Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13643429021
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238073AbhJKOF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238866AbhJKOCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1417C611CB;
        Mon, 11 Oct 2021 13:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960692;
        bh=X8ehpy2hqD6Uxj2TLvKFaiT5ztLUWN5OZb3Oso6ewLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfFLa9zj/5cSs1MOHdaUVWvYWABqgIkDyi5lJGTJyoKirBdB5imVOm/Ah0WO8KtvR
         j9nHnQx6gesMASYgNsg0A0oUevfXiR2ULWsntIq+iiFfbXV35YXw7yM5qO53SwxiBh
         raOCyMYHGa8UWbOtea5+09gNcqocPkSIH8WYifQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Amit Pundir <amit.pundir@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 048/151] arm64: dts: qcom: pm8150: use qcom,pm8998-pon binding
Date:   Mon, 11 Oct 2021 15:45:20 +0200
Message-Id: <20211011134519.401522123@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
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
index c566a64b1373..00385b1fd358 100644
--- a/arch/arm64/boot/dts/qcom/pm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm8150.dtsi
@@ -48,7 +48,7 @@
 		#size-cells = <0>;
 
 		pon: power-on@800 {
-			compatible = "qcom,pm8916-pon";
+			compatible = "qcom,pm8998-pon";
 			reg = <0x0800>;
 
 			pon_pwrkey: pwrkey {
-- 
2.33.0



