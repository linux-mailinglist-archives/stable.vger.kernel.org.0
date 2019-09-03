Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC6E4A6EF2
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbfICQ3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731297AbfICQ3K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:29:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C78A238CF;
        Tue,  3 Sep 2019 16:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528149;
        bh=KXSNpiQMAJFXBeg9Is2IzCyQCyTFr1hSLsvhqn5Qayo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGPmEjNknHENwG7VDcKtvblH8bVJSI8FTyvOXBVf67Hg/hpo+kLCNUXTH1ijF8HbO
         EUcNgyykSp6p8A1udoYBRij1QA0PMUr9iUwGy9LXTPLQ0wDyLKzwL/saU6NE5mGe8l
         5C1fRdOL6sAozqrhwhOPMGluMWdW06flT5xBJJqY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 138/167] ARM: dts: gemini: Set DIR-685 SPI CS as active low
Date:   Tue,  3 Sep 2019 12:24:50 -0400
Message-Id: <20190903162519.7136-138-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit f90b8fda3a9d72a9422ea80ae95843697f94ea4a ]

The SPI to the display on the DIR-685 is active low, we were
just saved by the SPI library enforcing active low on everything
before, so set it as active low to avoid ambiguity.

Link: https://lore.kernel.org/r/20190715202101.16060-1-linus.walleij@linaro.org
Cc: stable@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/gemini-dlink-dir-685.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/gemini-dlink-dir-685.dts b/arch/arm/boot/dts/gemini-dlink-dir-685.dts
index 502a361d1fe90..15d6157b661db 100644
--- a/arch/arm/boot/dts/gemini-dlink-dir-685.dts
+++ b/arch/arm/boot/dts/gemini-dlink-dir-685.dts
@@ -65,7 +65,7 @@
 		gpio-miso = <&gpio1 8 GPIO_ACTIVE_HIGH>;
 		gpio-mosi = <&gpio1 7 GPIO_ACTIVE_HIGH>;
 		/* Collides with pflash CE1, not so cool */
-		cs-gpios = <&gpio0 20 GPIO_ACTIVE_HIGH>;
+		cs-gpios = <&gpio0 20 GPIO_ACTIVE_LOW>;
 		num-chipselects = <1>;
 
 		panel: display@0 {
-- 
2.20.1

