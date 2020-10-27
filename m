Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D90E29B616
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1795887AbgJ0PTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796619AbgJ0PTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:19:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D6A020657;
        Tue, 27 Oct 2020 15:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811986;
        bh=cjkSj5sgxsbSc1z7k2gaF3OkQnuoEBYYj6A6CHUL4+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HC0H+aWxrvzWQy0RUisdgr+vn6ztOkFpILsuCflgAzTpW2bITZ/llK/NRa+kNQtsF
         govYoucLAnNzqL2sBCQ+pKBD7RdBszJ/huaT7GbnD9eYQKerDW6CfQZa4OFlLolrE7
         lxAaC0RsF71LLSbcP9XQbwOkZZZRLa33NFOhICHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 053/757] net: ethernet: mtk-star-emac: select REGMAP_MMIO
Date:   Tue, 27 Oct 2020 14:45:03 +0100
Message-Id: <20201027135453.043233682@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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


