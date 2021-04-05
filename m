Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4073C353F14
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238620AbhDEJKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238930AbhDEJJP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:09:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFE9661393;
        Mon,  5 Apr 2021 09:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613749;
        bh=p4lZxp8x+BeIFanmYK4yBrTLUHfSdNTGBNj15kf6IcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zieUuIwBEYDeokrchr5rPEL50UDRXJpJWA3Vfqq3Ss8wfCeYhtgAiNbU07gB49jwf
         BVVSnBN2adHhhezR151O74jpNzHNoznkf2299kc5aNHU+MwlIMyHIXUPaimDgpiY1c
         Ceg36UVPC8YHesToW0lxyS0Qm2S2b+S6YmHOSEIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/126] can: tcan4x5x: fix max register value
Date:   Mon,  5 Apr 2021 10:53:23 +0200
Message-Id: <20210405085032.410386367@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6e1caaf8ed22eb700cc47ec353816eee33186c1c ]

This patch fixes the max register value for the regmap.

Reviewed-by: Dan Murphy <dmurphy@ti.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20201215231746.1132907-12-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/tcan4x5x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index 01f5b6e03a2d..f169d9090e52 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -88,7 +88,7 @@
 
 #define TCAN4X5X_MRAM_START 0x8000
 #define TCAN4X5X_MCAN_OFFSET 0x1000
-#define TCAN4X5X_MAX_REGISTER 0x8fff
+#define TCAN4X5X_MAX_REGISTER 0x8ffc
 
 #define TCAN4X5X_CLEAR_ALL_INT 0xffffffff
 #define TCAN4X5X_SET_ALL_INT 0xffffffff
-- 
2.30.1



