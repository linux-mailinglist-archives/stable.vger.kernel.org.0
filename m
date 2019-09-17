Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F154B48F2
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 10:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404733AbfIQINc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 04:13:32 -0400
Received: from gloria.sntech.de ([185.11.138.130]:46318 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728986AbfIQINc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Sep 2019 04:13:32 -0400
Received: from ip5f5a6266.dynamic.kabel-deutschland.de ([95.90.98.102] helo=phil.fritz.box)
        by gloria.sntech.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <heiko@sntech.de>)
        id 1iA8bz-0005RU-WA; Tue, 17 Sep 2019 10:13:24 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, d.schultz@phytec.de,
        linux-rockchip@lists.infradead.org,
        christoph.muellner@theobroma-systems.com, tony.xie@rock-chips.com,
        stable@vger.kernel.org, Elaine Zhang <zhangqing@rock-chips.com>,
        Joseph Chen <chenjh@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 1/4] mfd: rk808: fix rk818 ID template
Date:   Tue, 17 Sep 2019 10:12:53 +0200
Message-Id: <20190917081256.24919-1-heiko@sntech.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Schultz <d.schultz@phytec.de>

The Rockchip PMIC driver can automatically detect connected component
versions by reading the ID_MSB and ID_LSB registers. The probe function
will always fail with RK818 PMICs because the ID_MSK is 0xFFF0 and the
RK818 template ID is 0x8181.

This patch changes this value to 0x8180.

Fixes: 9d6105e19f61 ("mfd: rk808: Fix up the chip id get failed")
Cc: stable@vger.kernel.org
Cc: Elaine Zhang <zhangqing@rock-chips.com>
Cc: Joseph Chen <chenjh@rock-chips.com>
Signed-off-by: Daniel Schultz <d.schultz@phytec.de>
Acked-by: Lee Jones <lee.jones@linaro.org>
[resend as it seems to have dropped on the floor]
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 include/linux/mfd/rk808.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mfd/rk808.h b/include/linux/mfd/rk808.h
index 7cfd2b0504df..a59bf323f713 100644
--- a/include/linux/mfd/rk808.h
+++ b/include/linux/mfd/rk808.h
@@ -610,7 +610,7 @@ enum {
 	RK808_ID = 0x0000,
 	RK809_ID = 0x8090,
 	RK817_ID = 0x8170,
-	RK818_ID = 0x8181,
+	RK818_ID = 0x8180,
 };
 
 struct rk808 {
-- 
2.20.1

