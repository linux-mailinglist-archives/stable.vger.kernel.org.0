Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F2E3C55FA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351070AbhGLIM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354112AbhGLIDa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AAAD61249;
        Mon, 12 Jul 2021 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076815;
        bh=BnakF79SOWYssZwRtM5UQ5BOpY/qC5NC/RMD34MqgsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzV8Ksko23WnRX3uhZLM6q/2d/T/ROmqIl9OUQXENdCSJyzfbfHIH1VGCnWZlTpUq
         Nm8Thuhc8Eg23OGKPkTGvZCWxzXB6PjdQfPGJ8mS+Hkwh2WhKJJybDHZ7OECJ7idYw
         CAp4rjOgdOw25KjT+xex9Hm4KAVzQOowqWr3vJ5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.13 799/800] media: exynos4-is: remove a now unused integer
Date:   Mon, 12 Jul 2021 08:13:42 +0200
Message-Id: <20210712061051.615266798@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit 29dd19e3ac7b2a8671ebeac02859232ce0e34f58 upstream.

The usage of pm_runtime_resume_and_get() removed the need of a
temporary integer. So, drop it.

Fixes: 59f96244af94 ("media: exynos4-is: fix pm_runtime_get_sync() usage count")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/exynos4-is/media-dev.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1284,7 +1284,6 @@ static DEVICE_ATTR(subdev_conf_mode, S_I
 static int cam_clk_prepare(struct clk_hw *hw)
 {
 	struct cam_clk *camclk = to_cam_clk(hw);
-	int ret;
 
 	if (camclk->fmd->pmf == NULL)
 		return -ENODEV;


