Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 251691F01B
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbfEOLkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732580AbfEOL3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:29:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6268D20818;
        Wed, 15 May 2019 11:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919775;
        bh=b+7IrKqQzISmnxuuG+ZrkN8Y88wxjcXgtHbZect4IK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CB4W2uXakztFwXLhWi2wPLoO5rQatVvHiDzaKJpcmDch5SOl9yBPPlHVf5nSTuwLI
         ZysKIuAzTWPie8MBfp6qwra2Jz3Hp7DfOHEFNKEN61efelZ2D3p6ZevbnwqHTkRrJs
         xgP7QOffCalgMfv/cGp2CR+6zfi4cvF7KDzHCg3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacky Bai <ping.bai@nxp.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 090/137] Input: snvs_pwrkey - make it depend on ARCH_MXC
Date:   Wed, 15 May 2019 12:56:11 +0200
Message-Id: <20190515090700.063042399@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index a878351f16439..52d7f55fca329 100644
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



