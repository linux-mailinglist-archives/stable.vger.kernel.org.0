Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16C915C4E
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfEGGCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbfEGFf1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:35:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50A722087F;
        Tue,  7 May 2019 05:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207327;
        bh=B6Ib1DbM2W/TAMM0LH1WLtMkYekyJiCmf9YXS4kH7h0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPY+I2pVIuGFbYUuaIsUQllybyPcgUAGB2c5B11k59d/i8It3BNzCfCJWuXLowoG/
         oeXFczS+wohHGLvSL7EQSRvv72OwyOIB50hWQ/0wnjz8V4uDLYdkhYVkWDTpoVajYb
         Tr3KOxGRyzOSjVQ9I9Hi+SiRTNg3ECCn41jBJpy4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacky Bai <ping.bai@nxp.com>, Dong Aisheng <aisheng.dong@nxp.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 88/99] Input: snvs_pwrkey - make it depend on ARCH_MXC
Date:   Tue,  7 May 2019 01:32:22 -0400
Message-Id: <20190507053235.29900-88-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacky Bai <ping.bai@nxp.com>

[ Upstream commit f06eba72274788db6a43012a05a99915c0283aef ]

The SNVS power key is not only used on i.MX6SX and i.MX7D, it is also
used by i.MX6UL and NXP's latest ARMv8 based i.MX8M series SOC. So
update the config dependency to use ARCH_MXC, and add the COMPILE_TEST
too.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index a878351f1643..52d7f55fca32 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -420,7 +420,7 @@ config KEYBOARD_MPR121
 
 config KEYBOARD_SNVS_PWRKEY
 	tristate "IMX SNVS Power Key Driver"
-	depends on SOC_IMX6SX || SOC_IMX7D
+	depends on ARCH_MXC || COMPILE_TEST
 	depends on OF
 	help
 	  This is the snvs powerkey driver for the Freescale i.MX application
-- 
2.20.1

