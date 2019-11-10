Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9EEEF6667
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfKJDNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:13:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727991AbfKJCmq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:42:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD6FF21655;
        Sun, 10 Nov 2019 02:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353765;
        bh=kYX34TqtCC3SM/hdhNIA6q1CTQZWCDNDaa35a4w3VJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCPKLjnO/jzuDQ6spo0qC/MfkajzkKzqWn494OJaDC/+hwLXzwFl3maQKwE0+BUi0
         wlfyWSkbP9ZxJLlxfJsgygl2WYF7Lk0aJhQDjd+2ZEW+3fihzfeKy4AiziFMHhhD4D
         EHqh4qUo8PLQD0gxvKDQ+Pj8m2diG55HXhb+LLmY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 077/191] ARM: dts: stm32: Fix SPI controller node names
Date:   Sat,  9 Nov 2019 21:38:19 -0500
Message-Id: <20191110024013.29782-77-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

