Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D68FA429
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbfKMCO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:14:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728681AbfKMB5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:57:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E19B52246A;
        Wed, 13 Nov 2019 01:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610233;
        bh=Ws/++C/6yz3D2eqU9vCnRueTeOtZH2HVRq3VtWoVuao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EjmjxWS9FHiepmxVxJXyumXaSCzgU0irvvC6CCtgsk8bgETNP5bsNBn1k4lhMbkrg
         cHsJS+EBGMIx8eWAP8Ea9rjtIG0gE41DE+ogwchnPvflyq+pcvCbqP5nBxexdoD/RY
         h9YLOy6eQNOEHCvv+UxHHo+AeTb655Iq400MWRCo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 034/115] ARM: dts: at91: sama5d4_xplained: fix addressable nand flash size
Date:   Tue, 12 Nov 2019 20:55:01 -0500
Message-Id: <20191113015622.11592-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

[ Upstream commit df90fc64367ffdb6f1b5c0f0c4940d44832b0174 ]

sama5d4_xplained comes with a 4Gb NAND flash. Increase the rootfs
size to match this limit.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama5d4_xplained.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91-sama5d4_xplained.dts b/arch/arm/boot/dts/at91-sama5d4_xplained.dts
index cf712444b2c2c..10f2fb9e0ea61 100644
--- a/arch/arm/boot/dts/at91-sama5d4_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d4_xplained.dts
@@ -240,7 +240,7 @@
 
 						rootfs@800000 {
 							label = "rootfs";
-							reg = <0x800000 0x0f800000>;
+							reg = <0x800000 0x1f800000>;
 						};
 					};
 				};
-- 
2.20.1

