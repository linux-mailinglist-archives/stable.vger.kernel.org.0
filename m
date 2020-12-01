Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725CD2C9BE6
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390061AbgLAJNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:13:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390031AbgLAJNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:13:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A229621D7F;
        Tue,  1 Dec 2020 09:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813943;
        bh=ujal3ZrL3DxeQXhTnSw2quJHU8Kh8gcNR96acI/asoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKZmZqdnym7qm78jEp77JWXzgEqsotG5h8YRmcKmjx+QzUH9Sq1VZ1HcqA485EPsK
         nthy/UifPXIHhwU53ixAQpw7S6KDx8IEDr5qyxEfkBxbmCCut/3hch600JYsiyyqFo
         PxjB/jdhG6OcxiDH0dpAMhukBcI4YSxcriI5VUTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 083/152] phy: qualcomm: Fix 28 nm Hi-Speed USB PHY OF dependency
Date:   Tue,  1 Dec 2020 09:53:18 +0100
Message-Id: <20201201084722.760628401@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 14839107b51cc0db19579039b1f72cba7a0c8049 ]

This Kconfig entry should declare a dependency on OF

Fixes: 67b27dbeac4d ("phy: qualcomm: Add Synopsys 28nm Hi-Speed USB PHY driver")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20201113151225.1657600-3-bryan.odonoghue@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/Kconfig b/drivers/phy/qualcomm/Kconfig
index 9129c4b8bb9b1..7f6fcb8ec5bab 100644
--- a/drivers/phy/qualcomm/Kconfig
+++ b/drivers/phy/qualcomm/Kconfig
@@ -87,7 +87,7 @@ config PHY_QCOM_USB_HSIC
 
 config PHY_QCOM_USB_HS_28NM
 	tristate "Qualcomm 28nm High-Speed PHY"
-	depends on ARCH_QCOM || COMPILE_TEST
+	depends on OF && (ARCH_QCOM || COMPILE_TEST)
 	depends on EXTCON || !EXTCON # if EXTCON=m, this cannot be built-in
 	select GENERIC_PHY
 	help
-- 
2.27.0



