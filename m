Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916BD3D283A
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhGVP4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231529AbhGVPzv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:55:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68A936135C;
        Thu, 22 Jul 2021 16:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971786;
        bh=JdUK1TSRuBMz0ILc6K9/YlYoSPxLV5avkXwT+icrvCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yUymFsnXFsY1ZjCaGT57Ijnp+kpUrzYR+EJ6FJxUS60+NRpKhRB/RNniGZzqTZeG8
         WNHcjJinP6RIUmTJpG3VkSWVfsuzJw4sJJLYF+Z8zESqanrltk9S3xMdnxEHWi99TO
         K5M9fVjtJipcEbJ6Pg5zro5tbmpAngnS/bGC8IWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/125] ARM: dts: ux500: Fix orientation of accelerometer
Date:   Thu, 22 Jul 2021 18:30:16 +0200
Message-Id: <20210722155625.533377966@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 4beba4011995a2c44ee27e1d358dc32e6b9211b3 ]

This adds a mounting matrix to the accelerometer
on the TVK1281618 R3.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi b/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
index c0de1337bdaa..457bddabc32c 100644
--- a/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
+++ b/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
@@ -19,6 +19,9 @@
 					     <19 IRQ_TYPE_EDGE_RISING>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&accel_tvk_mode>;
+				mount-matrix = "0", "-1", "0",
+					       "-1", "0", "0",
+					       "0", "0", "-1";
 			};
 			magnetometer@1e {
 				compatible = "st,lsm303dlm-magn";
-- 
2.30.2



