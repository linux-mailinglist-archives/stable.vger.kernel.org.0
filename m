Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B63A5DC18
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfGCCQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727958AbfGCCQd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:16:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C58B02187F;
        Wed,  3 Jul 2019 02:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120192;
        bh=Vax1MVjoW4XnIG0uQMSCfa0qyH3DTn2Y5luSLf2Qd9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKuBSfRdcOBAefsEaKFhrf39FmR2Y5m+4K9D1D01T7ni1hiCziGZMGzwi897GQR4s
         MSXut9AcTN7HEtyZIPJ8U2fj9wEaKZAeT8ecql0yWDSfsb6AlDOgUHZnwhgyUmYi0g
         fCZTAU4EdbrfUSVyhpzJIVLfWLmsJ8T8md1bgArs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/26] ARM: dts: gemini Fix up DNS-313 compatible string
Date:   Tue,  2 Jul 2019 22:16:04 -0400
Message-Id: <20190703021625.18116-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021625.18116-1-sashal@kernel.org>
References: <20190703021625.18116-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 36558020128b1a48b7bddd5792ee70e3f64b04b0 ]

It's a simple typo in the DNS file, which was pretty serious.
No scripts were working properly. Fix it up.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/gemini-dlink-dns-313.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/gemini-dlink-dns-313.dts b/arch/arm/boot/dts/gemini-dlink-dns-313.dts
index d1329322b968..361dccd6c7ee 100644
--- a/arch/arm/boot/dts/gemini-dlink-dns-313.dts
+++ b/arch/arm/boot/dts/gemini-dlink-dns-313.dts
@@ -11,7 +11,7 @@
 
 / {
 	model = "D-Link DNS-313 1-Bay Network Storage Enclosure";
-	compatible = "dlink,dir-313", "cortina,gemini";
+	compatible = "dlink,dns-313", "cortina,gemini";
 	#address-cells = <1>;
 	#size-cells = <1>;
 
-- 
2.20.1

