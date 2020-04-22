Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38621B3F1F
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731289AbgDVKem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:34:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730397AbgDVKYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:24:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11C7C2076B;
        Wed, 22 Apr 2020 10:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551044;
        bh=R/EkibC1xiHR1BW+LamJK6V0IuMDFME4qS/zquvUOgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPUguWtT6Ip+AogbcEfVpukymXjIlCoGZsf4sG5H2yDlfZvSjcIM+DSMhmg4OI1qM
         tlovK3V64zHARHsD16cOX1P8r8ptNKSUFMB4HAvdpOHgRYCcPDh9wbOc6qjkGMGRcx
         HHB6371GBeVcpSN7s4VTxQ3YIvI+H8usudk9Y7b0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 079/166] phy: uniphier-usb3ss: Add Pro5 support
Date:   Wed, 22 Apr 2020 11:56:46 +0200
Message-Id: <20200422095057.300703336@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 9376fa634afc207a3ce99e0957e04948c34d6510 ]

Pro5 SoC has same scheme of USB3 ss-phy as Pro4, so the data for Pro5 is
equivalent to Pro4.

Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/socionext/phy-uniphier-usb3ss.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/phy/socionext/phy-uniphier-usb3ss.c b/drivers/phy/socionext/phy-uniphier-usb3ss.c
index ec231e40ef2ac..a7577e316baf5 100644
--- a/drivers/phy/socionext/phy-uniphier-usb3ss.c
+++ b/drivers/phy/socionext/phy-uniphier-usb3ss.c
@@ -314,6 +314,10 @@ static const struct of_device_id uniphier_u3ssphy_match[] = {
 		.compatible = "socionext,uniphier-pro4-usb3-ssphy",
 		.data = &uniphier_pro4_data,
 	},
+	{
+		.compatible = "socionext,uniphier-pro5-usb3-ssphy",
+		.data = &uniphier_pro4_data,
+	},
 	{
 		.compatible = "socionext,uniphier-pxs2-usb3-ssphy",
 		.data = &uniphier_pxs2_data,
-- 
2.20.1



