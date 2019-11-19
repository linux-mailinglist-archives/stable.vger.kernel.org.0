Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4F01014DF
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbfKSFiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:38:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:60266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730173AbfKSFiS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:38:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7606E206EC;
        Tue, 19 Nov 2019 05:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141898;
        bh=kYX34TqtCC3SM/hdhNIA6q1CTQZWCDNDaa35a4w3VJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bm1sH2uPE63AZkLytEkePlQHAjr8mGVeXZpYSTKpaz/vgLEWBG/CVZRvsO8hOXdxL
         kFJAqwDo015OFsO9h5JC8ofTQlf+BmyxN/mYXNjeYNr76ctGlpgmPisjjDttKTh8s+
         AAWbLaw4ehwT9S0pRWQXb8DGROKQA2CZIiNPo+qQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 311/422] ARM: dts: stm32: Fix SPI controller node names
Date:   Tue, 19 Nov 2019 06:18:28 +0100
Message-Id: <20191119051419.149965549@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 1ba23b1df0bb6eec430408614c3a11280941e112 ]

SPI controller nodes should be named 'spi' rather than 'qspi'. Fixing the
name enables dtc SPI bus checks.

Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157c.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp157c.dtsi b/arch/arm/boot/dts/stm32mp157c.dtsi
index 185541a5b69fb..c50c36baba758 100644
--- a/arch/arm/boot/dts/stm32mp157c.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c.dtsi
@@ -947,7 +947,7 @@
 			dma-requests = <48>;
 		};
 
-		qspi: qspi@58003000 {
+		qspi: spi@58003000 {
 			compatible = "st,stm32f469-qspi";
 			reg = <0x58003000 0x1000>, <0x70000000 0x10000000>;
 			reg-names = "qspi", "qspi_mm";
-- 
2.20.1



