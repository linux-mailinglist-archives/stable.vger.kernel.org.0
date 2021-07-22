Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E923D2877
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhGVP50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:57:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232966AbhGVP5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:57:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F369C61362;
        Thu, 22 Jul 2021 16:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971865;
        bh=8eOCF0wyzmasQu29+z7Zk5Ku7UHteL0M3+RqkKFQpeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLigQFInYFXQQSE40BkCgj8YUxRGCplZFwbXs1WOOPBjY5xcyNjz96g0dI6npDSJo
         K20NTQXJdhFOTHwYjdLgzW2ZKJxDamt0E8Pn0tc/BVSCwogBCOfs6B2SulbCqQTV4I
         63qt2SRPmVGRZjIiqIyvSj03LTtRaN7rBHN7vPJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Sujit Kautkar <sujitka@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/125] arm64: dts: qcom: sc7180: Move rmtfs memory region
Date:   Thu, 22 Jul 2021 18:30:30 +0200
Message-Id: <20210722155625.991583736@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sujit Kautkar <sujitka@chromium.org>

[ Upstream commit d4282fb4f8f9683711ae6c076da16aa8e675fdbd ]

Move rmtfs memory region so that it does not overlap with system
RAM (kernel data) when KAsan is enabled. This puts rmtfs right
after mba_mem which is not supposed to increase beyond 0x94600000

Reviewed-by: Sibi Sankar <sibis@codeaurora.org>
Signed-off-by: Sujit Kautkar <sujitka@chromium.org>
Link: https://lore.kernel.org/r/20210514113430.1.Ic2d032cd80424af229bb95e2c67dd4de1a70cb0c@changeid
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-idp.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-idp.dts b/arch/arm64/boot/dts/qcom/sc7180-idp.dts
index e77a7926034a..afe0f9c25816 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-idp.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-idp.dts
@@ -45,7 +45,7 @@
 
 /* Increase the size from 2MB to 8MB */
 &rmtfs_mem {
-	reg = <0x0 0x84400000 0x0 0x800000>;
+	reg = <0x0 0x94600000 0x0 0x800000>;
 };
 
 / {
-- 
2.30.2



