Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BD932E8A3
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhCEM2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:28:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:35984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231869AbhCEM1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:27:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3CBE6502C;
        Fri,  5 Mar 2021 12:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947265;
        bh=AF9JKHEnRkhc4FbihECl1i8EIoQWXp4O/bm3sHqf4ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gMIJFSsI0mYw22IH1xw6bN/1TxbnOB1iN9o7ymUoSABQT06A0iAXWLNSAqPVv8yu
         ltkVzI4prhVgAwYlccW2ZW+83dfdFgSp/udxULe0C2mwyEdnUmY0zrMJHQ3JBsT7+z
         rcBuoTZ78ZFTNBKD9jmDYDtl75R6FFuAO1S9CVsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.11 101/104] phy: mediatek: Add missing MODULE_DEVICE_TABLE()
Date:   Fri,  5 Mar 2021 13:21:46 +0100
Message-Id: <20210305120908.128828853@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

commit 9a8b9434c60f40e4d2603c822a68af6a9ca710df upstream.

This patch adds the missing MODULE_DEVICE_TABLE definitions on different
Mediatek phy drivers which generates correct modalias for automatic loading
when these drivers are compiled as an external module.

Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Link: https://lore.kernel.org/r/20210203110631.686003-1-enric.balletbo@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/mediatek/phy-mtk-hdmi.c     |    1 +
 drivers/phy/mediatek/phy-mtk-mipi-dsi.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/phy/mediatek/phy-mtk-hdmi.c
+++ b/drivers/phy/mediatek/phy-mtk-hdmi.c
@@ -201,6 +201,7 @@ static const struct of_device_id mtk_hdm
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, mtk_hdmi_phy_match);
 
 static struct platform_driver mtk_hdmi_phy_driver = {
 	.probe = mtk_hdmi_phy_probe,
--- a/drivers/phy/mediatek/phy-mtk-mipi-dsi.c
+++ b/drivers/phy/mediatek/phy-mtk-mipi-dsi.c
@@ -233,6 +233,7 @@ static const struct of_device_id mtk_mip
 	  .data = &mt8183_mipitx_data },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, mtk_mipi_tx_match);
 
 struct platform_driver mtk_mipi_tx_driver = {
 	.probe = mtk_mipi_tx_probe,


