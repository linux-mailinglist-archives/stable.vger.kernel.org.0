Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B7E1B1E6
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 10:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbfEMIaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 04:30:21 -0400
Received: from gloria.sntech.de ([185.11.138.130]:49508 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbfEMIaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 04:30:21 -0400
Received: from p5b127220.dip0.t-ipconnect.de ([91.18.114.32] helo=phil.fritz.box)
        by gloria.sntech.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <heiko@sntech.de>)
        id 1hQ6Lh-0003QG-Kb; Mon, 13 May 2019 10:30:17 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Daniel Schultz <d.schultz@phytec.de>,
        stable@vger.kernel.org, Elaine Zhang <zhangqing@rock-chips.com>,
        Joseph Chen <chenjh@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH RESEND] mfd: rk808: Fix RK818 ID template
Date:   Mon, 13 May 2019 10:29:43 +0200
Message-Id: <20190513082943.31750-1-heiko@sntech.de>
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
[added Fixes and cc-stable]
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
The original patch from Feburary 2018 got an Ack but never reached
the mfd-tree, so I ran into that problem this weekend as well.
So it would be really cool if this could be applied as fix :-) .

 include/linux/mfd/rk808.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mfd/rk808.h b/include/linux/mfd/rk808.h
index d3156594674c..338e0f6e2226 100644
--- a/include/linux/mfd/rk808.h
+++ b/include/linux/mfd/rk808.h
@@ -443,7 +443,7 @@ enum {
 enum {
 	RK805_ID = 0x8050,
 	RK808_ID = 0x0000,
-	RK818_ID = 0x8181,
+	RK818_ID = 0x8180,
 };
 
 struct rk808 {
-- 
2.20.1

