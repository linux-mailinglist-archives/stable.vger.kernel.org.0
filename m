Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4313C4F74
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239028AbhGLHZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240487AbhGLHW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:22:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F14E60C40;
        Mon, 12 Jul 2021 07:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074408;
        bh=e9bHMFgzFelIA/FkmpUKPlWgBpmwXAEWV8mcdlFXdFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07l+bhAbLWZlJulS1YE1hoemJU+MABElEoAbclFXyxU7VhmoLzhomtfD8M70ewAal
         u14HWqo0AA1tOJTXjz2Eefovf+/S8IlS0Sg1Lv/IgPJA+Ex553wdAUSc0NTtjcyjYi
         rlJC/5WO1Q+trkLzfOwce4XJ6M6Rwq+tyOAAzMiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 569/700] leds: lgm: Fix spelling mistake "prepate" -> "prepare"
Date:   Mon, 12 Jul 2021 08:10:52 +0200
Message-Id: <20210712061036.646004168@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit ec50536b7840dde085185d9570fa19d0baf5042c ]

There is a spelling mistake in a dev_err error message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/blink/leds-lgm-sso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/blink/leds-lgm-sso.c b/drivers/leds/blink/leds-lgm-sso.c
index 7d5c9ca007d6..6a63846d10b5 100644
--- a/drivers/leds/blink/leds-lgm-sso.c
+++ b/drivers/leds/blink/leds-lgm-sso.c
@@ -793,7 +793,7 @@ static int intel_sso_led_probe(struct platform_device *pdev)
 
 	ret = clk_prepare_enable(priv->gclk);
 	if (ret) {
-		dev_err(dev, "Failed to prepate/enable sso gate clock!\n");
+		dev_err(dev, "Failed to prepare/enable sso gate clock!\n");
 		return ret;
 	}
 
-- 
2.30.2



