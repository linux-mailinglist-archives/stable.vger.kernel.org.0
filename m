Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008EB3D75E1
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236756AbhG0NTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:19:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236811AbhG0NTK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:19:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A80A601FD;
        Tue, 27 Jul 2021 13:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391950;
        bh=42+BG0ycbiLTUvyAYa9xiB8SuDPYDhHiL+BYxOjqBXU=;
        h=From:To:Cc:Subject:Date:From;
        b=VlFXwlJQ4kH26iezj6r8XD2PqoFpGadL8e/wXO901uRBO2HlV/f7nzNy7G+E/AUqL
         D9b3tXunhfF62dTtxxL6Y08CUJdlAz5H9avJJT5Zy98V79Ab5scnCb0A7MwJzdM+qX
         fK8blzDaGP4Oy+oTPGPq7CD7ZiDu6gHgqYi8E9tcOCkFh1+lbMdSko/w0I0uUNZ5uc
         xPOqUFSrFukjd0JvOhU+Rt6q+GAq0Q745fwm9CfChXONs2CFv1+ZHAPsnWhX3XzLLB
         e96S9WBQRecy+RMfQXdepmhe7mB8smtIYpldhjWnvdrZu78GRWNJoUxWSwnjYYTdo4
         uDp6ceBfG689w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ChiYuan Huang <cy_huang@richtek.com>,
        Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 01/21] regulator: rtmv20: Fix wrong mask for strobe-polarity-high
Date:   Tue, 27 Jul 2021 09:18:48 -0400
Message-Id: <20210727131908.834086-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChiYuan Huang <cy_huang@richtek.com>

[ Upstream commit 2b6a761be079f9fa8abf3157b5679a6f38885db4 ]

Fix wrong mask for strobe-polarity-high.

Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
In-reply-to: <CAFRkauB=0KwrJW19nJTTagdHhBR=V2R8YFWG3R3oVXt=rBRsqw@mail.gmail.com>
Reviewed-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/1624723112-26653-1-git-send-email-u0084500@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rtmv20-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/rtmv20-regulator.c b/drivers/regulator/rtmv20-regulator.c
index 4bca64de0f67..2ee334174e2b 100644
--- a/drivers/regulator/rtmv20-regulator.c
+++ b/drivers/regulator/rtmv20-regulator.c
@@ -37,7 +37,7 @@
 #define RTMV20_WIDTH2_MASK	GENMASK(7, 0)
 #define RTMV20_LBPLVL_MASK	GENMASK(3, 0)
 #define RTMV20_LBPEN_MASK	BIT(7)
-#define RTMV20_STROBEPOL_MASK	BIT(1)
+#define RTMV20_STROBEPOL_MASK	BIT(0)
 #define RTMV20_VSYNPOL_MASK	BIT(1)
 #define RTMV20_FSINEN_MASK	BIT(7)
 #define RTMV20_ESEN_MASK	BIT(6)
-- 
2.30.2

