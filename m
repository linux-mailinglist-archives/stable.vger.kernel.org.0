Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C2D45C5F0
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353861AbhKXOCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:02:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353699AbhKXOAo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:00:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A3946124C;
        Wed, 24 Nov 2021 13:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759364;
        bh=Pwizb7axEw5ynMLJ3luqOWFVqtMUOCr8iGZOMoKNqDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mA6VbIQMWwcbLSvr5gkpBp/mv7rW4ntHhnt0sVTkRxNg3oOl7mBkeREpn0EAfxroI
         /4IULT/kBM8Kpuo8Nz4uyfjQzjCydAuA4mJLNTgkrb5vTT5D2+2f+2+63rqIaY0XcW
         35aSxpQLoifEyX9doiygW/lpmSLl6iycA+dZNWXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 216/279] pinctrl: ralink: include ralink_regs.h in pinctrl-mt7620.c
Date:   Wed, 24 Nov 2021 12:58:23 +0100
Message-Id: <20211124115726.206048999@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

commit a5b9703fe11cd1d6d7a60102aa2abe686dc1867f upstream.

mt7620.h, included by pinctrl-mt7620.c, mentions MT762X_SOC_MT7628AN
declared in ralink_regs.h.

Fixes: 745ec436de72 ("pinctrl: ralink: move MT7620 SoC pinmux config into a new 'pinctrl-mt7620.c' file")
Cc: stable@vger.kernel.org
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20211031064046.13533-1-sergio.paracuellos@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/ralink/pinctrl-mt7620.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pinctrl/ralink/pinctrl-mt7620.c
+++ b/drivers/pinctrl/ralink/pinctrl-mt7620.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <asm/mach-ralink/ralink_regs.h>
 #include <asm/mach-ralink/mt7620.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>


