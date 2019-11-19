Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE29D1015EF
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731086AbfKSFsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:48:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbfKSFsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:48:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D65562071B;
        Tue, 19 Nov 2019 05:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142520;
        bh=dkRw0NLgbZfCKxHUgfLgac8iE4OQLyV4NXNb7ARPpdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJal1LjQErmlwS7lwWTPgtDEOL2TTiiLSx0VZhooTu4JugD8pzLInT9y4VtzFoNSL
         aAWEapAI1Ltp77NuSfoCjLhkULT6i9YaVtYFWeB0Wg8K9JxceHpMhZRMW1eSqI9Evg
         pqRdsKKP90wM/OslXWwbuVbe9zo1i00YlahvY2Tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Da Xue <da@lessconfused.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 109/239] arm64: dts: meson: libretech: update board model
Date:   Tue, 19 Nov 2019 06:18:29 +0100
Message-Id: <20191119051327.375868907@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit b7eb0e26cc4a212fde09144cd49d4103170d2b9e ]

There is actually several different libretech board with the CC suffix
so the model name is not appropriate here. Update to something more
specific

Reported-by: Da Xue <da@lessconfused.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts
index d71cbf596d1f7..0814b6b29b86a 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts
@@ -14,7 +14,7 @@
 
 / {
 	compatible = "libretech,cc", "amlogic,s905x", "amlogic,meson-gxl";
-	model = "Libre Technology CC";
+	model = "Libre Computer Board AML-S905X-CC";
 
 	aliases {
 		serial0 = &uart_AO;
-- 
2.20.1



