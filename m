Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36B40147F92
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731809AbgAXLDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:03:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733271AbgAXLDD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:03:03 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75F062071A;
        Fri, 24 Jan 2020 11:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863783;
        bh=5RrCn43JER/35P9jlDECfPw6IAm7jFm1h3GH20wrEdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DIUtyV5nrifGXRFMWZ/I0ZRsa/iN8qyqDFFN7KuyIL8fQ9H240uN/ajuCmwRvxQe9
         FbkMaevC4sYb+LT9oeNiaCk9rOGDbbwPvKgQC87fD6ugR+sgEy4bINRHZEZcSv956B
         N+I3VhihGl4reoxcS2YtA9WHaiRpRHOdH21HduPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 064/639] ARM: dts: bcm283x: Correct mailbox register sizes
Date:   Fri, 24 Jan 2020 10:23:54 +0100
Message-Id: <20200124093055.422079857@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Elwell <phil@raspberrypi.org>

[ Upstream commit 227fa865061470a568858baa404a508f6c030fe4 ]

The size field in a Device Tree "reg" property is encoded in bytes, not
words.

Fixes: 614fa22119d6 ("ARM: dts: bcm2835: Add VCHIQ node to the Raspberry Pi boards. (v3)")
Signed-off-by: Phil Elwell <phil@raspberrypi.org>
Acked-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2835-rpi.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm2835-rpi.dtsi b/arch/arm/boot/dts/bcm2835-rpi.dtsi
index cb2d6d78a7fbf..c481eab1bd7c0 100644
--- a/arch/arm/boot/dts/bcm2835-rpi.dtsi
+++ b/arch/arm/boot/dts/bcm2835-rpi.dtsi
@@ -32,7 +32,7 @@
 
 		mailbox@7e00b840 {
 			compatible = "brcm,bcm2835-vchiq";
-			reg = <0x7e00b840 0xf>;
+			reg = <0x7e00b840 0x3c>;
 			interrupts = <0 2>;
 		};
 	};
-- 
2.20.1



