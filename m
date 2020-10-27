Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F3329B37C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762957AbgJ0Ow3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1769820AbgJ0Otu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:49:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4B0820709;
        Tue, 27 Oct 2020 14:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810190;
        bh=cjkSj5sgxsbSc1z7k2gaF3OkQnuoEBYYj6A6CHUL4+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+cAmNOnWPbxTDggOCDL8k7Pn9U95WYYoZcU1RPe30k9/WUd82mOMj6gWc8xduG6x
         u21GVsNMo1zA00hEcNHYMrewyTbr2fI4kRDkD2ALAs2P571vpxxdQgaBBGWx8OO306
         10PSDoX35cxOeGsDI8X2Ti1WB60s8LzlyQSdHJR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 053/633] net: ethernet: mtk-star-emac: select REGMAP_MMIO
Date:   Tue, 27 Oct 2020 14:46:36 +0100
Message-Id: <20201027135525.187030211@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

[ Upstream commit 5403caf21648d739bf2b1266c33e34384c313379 ]

The driver depends on mmio regmap API but doesn't select the appropriate
Kconfig option. This fixes it.

Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Link: https://lore.kernel.org/r/20201020073515.22769-1-brgl@bgdev.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mediatek/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mediatek/Kconfig
+++ b/drivers/net/ethernet/mediatek/Kconfig
@@ -17,6 +17,7 @@ config NET_MEDIATEK_SOC
 config NET_MEDIATEK_STAR_EMAC
 	tristate "MediaTek STAR Ethernet MAC support"
 	select PHYLIB
+	select REGMAP_MMIO
 	help
 	  This driver supports the ethernet MAC IP first used on
 	  MediaTek MT85** SoCs.


