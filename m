Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 606191218FC
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfLPRyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:54:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727425AbfLPRyj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:54:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AA75206CB;
        Mon, 16 Dec 2019 17:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518879;
        bh=3Fh3Hq0ojttMicOgdFggWJzOUyfTgpux4AiBVY8d64w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RapasiEgM5G35ZuxknnwoQc7mMf0Z5wmdXu9NRru6eB2Llag9+qS2GVs0NFYpRKPX
         eKE3dEufK1DVBt7XFXEixviBKhR6/T0cjK2UZnAPNs7hrO/ayGI/fbn38T9MYOTMe+
         BH0KBpUBlDaK9GekfCNEAt9VZdu1YnDk6G4Nz0fM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Otavio Salvador <otavio@ossystems.com.br>,
        Fabio Berton <fabio.berton@ossystems.com.br>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 067/267] ARM: dts: rockchip: Fix the PMU interrupt number for rv1108
Date:   Mon, 16 Dec 2019 18:46:33 +0100
Message-Id: <20191216174856.140287881@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Otavio Salvador <otavio@ossystems.com.br>

[ Upstream commit c955b7aec510145129ca7aaea6ecbf6d748f5ebf ]

According to the Rockchip vendor tree the PMU interrupt number is
76, so fix it accordingly.

Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
Tested-by: Fabio Berton <fabio.berton@ossystems.com.br>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rv1108.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rv1108.dtsi b/arch/arm/boot/dts/rv1108.dtsi
index e7cd1315db1b7..6013d2f888c33 100644
--- a/arch/arm/boot/dts/rv1108.dtsi
+++ b/arch/arm/boot/dts/rv1108.dtsi
@@ -101,7 +101,7 @@
 
 	arm-pmu {
 		compatible = "arm,cortex-a7-pmu";
-		interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
 	timer {
-- 
2.20.1



