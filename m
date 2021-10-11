Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1593429089
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239749AbhJKOJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238508AbhJKOHi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:07:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6665F61208;
        Mon, 11 Oct 2021 14:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960854;
        bh=EGHYuQ7iTgfF1v16raV76dUZqXn7lsF3sBDsTlOfT8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJnoLOUhtlSmoCUuO+m0LzGv9vMWlfS7OMNaXCGoaRSDWIxr9XFmDhgn3yb3PHdI1
         IAC+zOruKnKxqIvK1FRsrQqt8yRvY6VcHC5GTIt5W/r30qgMA45d8sL5KG0htCtaf0
         x+PK8X4MGyoR1IXCDEfEqQL8nJdriyzNqV5cAlnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 094/151] ARM: defconfig: gemini: Restore framebuffer
Date:   Mon, 11 Oct 2021 15:46:06 +0200
Message-Id: <20211011134520.866697589@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit a6949059318a064880050c76a9d8fb070156385f ]

The framebuffer is gone on the D-Link DIR-685, restore it.

Fixes: f611b1e7624c ("drm: Avoid circular dependencies for CONFIG_FB")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210922200933.1825752-1-linus.walleij@linaro.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/gemini_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/gemini_defconfig b/arch/arm/configs/gemini_defconfig
index d2d5f1cf815f..e6ff844821cf 100644
--- a/arch/arm/configs/gemini_defconfig
+++ b/arch/arm/configs/gemini_defconfig
@@ -76,6 +76,7 @@ CONFIG_REGULATOR_FIXED_VOLTAGE=y
 CONFIG_DRM=y
 CONFIG_DRM_PANEL_ILITEK_IL9322=y
 CONFIG_DRM_TVE200=y
+CONFIG_FB=y
 CONFIG_LOGO=y
 CONFIG_USB=y
 CONFIG_USB_MON=y
-- 
2.33.0



