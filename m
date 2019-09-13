Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C53ADB2030
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390137AbfIMNR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:17:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390122AbfIMNR6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:17:58 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC8B9206BB;
        Fri, 13 Sep 2019 13:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380678;
        bh=AqqOg5iy/s9eIyKbX0tlcAjeF/e5Rb01A2K/tdXc0pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WdYpLFA+gfbk/qgXYehh1tM8873EkR6nyGXhaXWFj6J96lw5D7vjFmJoMVBNQW8Cg
         ooHo04ImqvCfhqtvJNHyq69vtx2RRlQwJAUPaZiTC4p7QbuCk1o5dtLmvQYyqPRgPe
         Ncg1HkIoOu8gV53Oh5wDHd2r2yjg37dhXZra2/RQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathias Kresin <dev@kresin.me>,
        John Crispin <john@phrozen.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 119/190] ARM: dts: qcom: ipq4019: fix PCI range
Date:   Fri, 13 Sep 2019 14:06:14 +0100
Message-Id: <20190913130609.338745524@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit da89f500cb55fb3f19c4b399b46d8add0abbd4d6 ]

The PCI range is invalid and PCI attached devices doen't work.

Signed-off-by: Mathias Kresin <dev@kresin.me>
Signed-off-by: John Crispin <john@phrozen.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-ipq4019.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
index 78db67337ed4a..2c3168d95a2d5 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -387,7 +387,7 @@
 			#size-cells = <2>;
 
 			ranges = <0x81000000 0 0x40200000 0x40200000 0 0x00100000
-				  0x82000000 0 0x48000000 0x48000000 0 0x10000000>;
+				  0x82000000 0 0x40300000 0x40300000 0 0x400000>;
 
 			interrupts = <GIC_SPI 141 IRQ_TYPE_EDGE_RISING>;
 			interrupt-names = "msi";
-- 
2.20.1



