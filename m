Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9263353FB2
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239564AbhDEJNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:13:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239561AbhDEJNo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C81E61393;
        Mon,  5 Apr 2021 09:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614019;
        bh=TjrbE5iDZEU9XsV5Ikrh7AvPDUTzdS8K4Ek3QibHjCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dti5p4piK4tzvDR7aHRAk8AaGEiaaN7WiGVyr8EyaVhEw7tjOghly3gEA5jfkeftD
         wlmYJg/hBOuUqV5CVAghRnKeCr8VVuCANiPlbCjeMgSKUtvfQtOXecOEfuaO/9mLaC
         /hR4oNMTTQhPUo/wuTuY7vqED/LhZyIVOSmBZX7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 053/152] can: tcan4x5x: fix max register value
Date:   Mon,  5 Apr 2021 10:53:22 +0200
Message-Id: <20210405085036.000807387@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
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
index 4920de09ffb7..aeac3ce7bfc8 100644
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



