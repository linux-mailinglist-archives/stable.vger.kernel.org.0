Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAB513E6E7
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387500AbgAPRWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:22:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733197AbgAPRNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:13:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14A16246AF;
        Thu, 16 Jan 2020 17:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194815;
        bh=ndOS0f4Dtb1ODMTqk6eVUDdez0LhtfKzKRVYAhh27OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSZ4ys/iSvhKhx4jwv5ZwHy4yLgWuUQV20tb1Vv2dyMzMfilqVjdAoNMkLZHGtJ7O
         EPa3DCFje15QHQrXBfXBZkZK+qka0yMFLj/DTlfLVOgYsCj+Sq7e+StakX6dlRSXtV
         NMrxldOIaNjq/hSN/5wTp1pJnRS9q+DZF2/+zDvo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 621/671] arm64: dts: apq8096-db820c: Increase load on l21 for SDCARD
Date:   Thu, 16 Jan 2020 12:04:19 -0500
Message-Id: <20200116170509.12787-358-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit e38161bd325ea541ef2f258d8e28281077dde524 ]

In the same way as for msm8974-hammerhead, l21 load, used for SDCARD
VMMC, needs to be increased in order to prevent any voltage drop issues
(due to limited current) happening with some SDCARDS or during specific
operations (e.g. write).

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Fixes: 660a9763c6a9 (arm64: dts: qcom: db820c: Add pm8994 regulator node)
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi b/arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi
index 0ef90c6554a9..9b41d77aa39b 100644
--- a/arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi
+++ b/arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi
@@ -580,6 +580,8 @@
 				l21 {
 					regulator-min-microvolt = <2950000>;
 					regulator-max-microvolt = <2950000>;
+					regulator-allow-set-load;
+					regulator-system-load = <200000>;
 				};
 				l22 {
 					regulator-min-microvolt = <3300000>;
-- 
2.20.1

