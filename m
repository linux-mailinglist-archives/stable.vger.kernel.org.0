Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 128D811B58F
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731422AbfLKPSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:18:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732086AbfLKPSC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98E2324671;
        Wed, 11 Dec 2019 15:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077482;
        bh=uTVJWRqB+hrVmymygwybQVOn/weF1+2ifA1NVusuY64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcwP1ahfOOLXV47aFHnphkQ641G1NMR1Sbm2HSkuW+Ds3OyzKGj+s+svPdFCRiolK
         cCSwPlzxhdjzYgkDzedmQFxwWtxb3y3dMcv7Nm9cI+oPF5UKMYUZ0hfSngeKKliloI
         Vi//fo9XrJ+2CSsGCD6lo0uq4hEzvF0k38FfWTQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Jourdan <mjourdan@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 055/243] drivers: soc: Allow building the amlogic drivers without ARCH_MESON
Date:   Wed, 11 Dec 2019 16:03:37 +0100
Message-Id: <20191211150342.820041861@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Jourdan <mjourdan@baylibre.com>

[ Upstream commit 41bb5769b7f4b7a85e4b92c37429228279b4f569 ]

The current condition makes it difficult to compile the amlogic/
drivers with COMPILE_TEST, or without ARCH_MESON in general.

Fixes kbuild errors with patch series that depend on drivers in that
directory, for instance the meson video decoder.

Signed-off-by: Maxime Jourdan <mjourdan@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
index 113e884697fd8..f0d46b16e08c4 100644
--- a/drivers/soc/Makefile
+++ b/drivers/soc/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_ARCH_GEMINI)	+= gemini/
 obj-$(CONFIG_ARCH_MXC)		+= imx/
 obj-$(CONFIG_SOC_XWAY)		+= lantiq/
 obj-y				+= mediatek/
-obj-$(CONFIG_ARCH_MESON)	+= amlogic/
+obj-y				+= amlogic/
 obj-y				+= qcom/
 obj-y				+= renesas/
 obj-$(CONFIG_ARCH_ROCKCHIP)	+= rockchip/
-- 
2.20.1



