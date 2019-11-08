Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16FCFF45EF
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732750AbfKHLij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:38:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732746AbfKHLii (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0075721D7B;
        Fri,  8 Nov 2019 11:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213117;
        bh=YfqKLYSnsyumgux2Rxwepr9n4EMJK++Yk6lQwlbYAtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ub6uhxxIvAFxuRipXtMWtAX3RdS2A51lb3t8SaP3R8D+YJ3/6yaRhXsm6XjBmYnjA
         lNCXKvNjhHCOIQlAc5fa93b5fCkYSXahOPm6fUfO95nl9tq6UPB1mn1YAJyDU3xZ4z
         YUrbUwW6ODJQuZK5HkA0VSboQzO29FxxTljClOQU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akshu Agrawal <akshu.agrawal@amd.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 037/205] ASoC: AMD: Change MCLK to 48Mhz
Date:   Fri,  8 Nov 2019 06:35:04 -0500
Message-Id: <20191108113752.12502-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akshu Agrawal <akshu.agrawal@amd.com>

[ Upstream commit a1b1e9880f0c2754a5ac416a546d9f295f72eabc ]

25Mhz MCLK which was earlier used was of spread type.
Thus, we were not getting accurate rate. The 48Mhz system
clk is of non-spread type and we are changing to it to get
accurate rate.

Signed-off-by: Akshu Agrawal <akshu.agrawal@amd.com>
Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-da7219-max98357a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp-da7219-max98357a.c b/sound/soc/amd/acp-da7219-max98357a.c
index 8e3275a96a821..e53b54d77692e 100644
--- a/sound/soc/amd/acp-da7219-max98357a.c
+++ b/sound/soc/amd/acp-da7219-max98357a.c
@@ -42,7 +42,7 @@
 #include "../codecs/da7219.h"
 #include "../codecs/da7219-aad.h"
 
-#define CZ_PLAT_CLK 25000000
+#define CZ_PLAT_CLK 48000000
 #define DUAL_CHANNEL		2
 
 static struct snd_soc_jack cz_jack;
-- 
2.20.1

