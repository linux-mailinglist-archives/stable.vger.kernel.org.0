Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA9981AF1
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730377AbfHENKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730054AbfHENKm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:10:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 824332067D;
        Mon,  5 Aug 2019 13:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010642;
        bh=HAJIUKAnC7bJu5wsqkTi3X8xbKnJ5vzI7COmh/zhbeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KupVax7spWHa4z41iGxU/UvHdXOT2o6SvjwJORDwfHx2ojPNoKuSddn2EnXc20k3T
         Mpd99llpYWPQJz8Zsi5+BArdtVnGt41IGZfTR7SDlkysZKUBETEozNjE+vliCfFA5d
         jufUoJ76Y+BewNUcFy4nsLVQENihQ+A5ZUkGxjLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 47/74] mmc: meson-mx-sdio: Fix misuse of GENMASK macro
Date:   Mon,  5 Aug 2019 15:03:00 +0200
Message-Id: <20190805124939.692542146@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Perches <joe@perches.com>

commit 665e985c2f41bebc3e6cee7e04c36a44afbc58f7 upstream.

Arguments are supposed to be ordered high then low.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Fixes: ed80a13bb4c4 ("mmc: meson-mx-sdio: Add a driver for the Amlogic
Meson8 and Meson8b SoCs")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/meson-mx-sdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/meson-mx-sdio.c
+++ b/drivers/mmc/host/meson-mx-sdio.c
@@ -76,7 +76,7 @@
 	#define MESON_MX_SDIO_IRQC_IF_CONFIG_MASK		GENMASK(7, 6)
 	#define MESON_MX_SDIO_IRQC_FORCE_DATA_CLK		BIT(8)
 	#define MESON_MX_SDIO_IRQC_FORCE_DATA_CMD		BIT(9)
-	#define MESON_MX_SDIO_IRQC_FORCE_DATA_DAT_MASK		GENMASK(10, 13)
+	#define MESON_MX_SDIO_IRQC_FORCE_DATA_DAT_MASK		GENMASK(13, 10)
 	#define MESON_MX_SDIO_IRQC_SOFT_RESET			BIT(15)
 	#define MESON_MX_SDIO_IRQC_FORCE_HALT			BIT(30)
 	#define MESON_MX_SDIO_IRQC_HALT_HOLE			BIT(31)


