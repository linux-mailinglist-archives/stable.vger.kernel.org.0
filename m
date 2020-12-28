Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201742E401D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502671AbgL1OWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:22:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502667AbgL1OWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51AD320731;
        Mon, 28 Dec 2020 14:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165335;
        bh=Al+ew9otR+njL6C8r5gDrw2MpAKsbWvr1VcofJGPCAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/SaoEcn0hJfJfEhZD6RuD+HHl94wQqc5JGi+zUGhP5hUHXZ3I+f70toZ1FPDzFBE
         /aZhmu9zaHeTTf97i0EAo3wUMJD2aFfX3lj2nL41weNHbZhwnJOfJtRYLAumZb8Ir+
         sP7oLxUkPwd9aCqGOpYYNC91vXv0QHitJJtNalnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Maxime Ripard <mripard@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 494/717] clk: bcm: dvp: Add MODULE_DEVICE_TABLE()
Date:   Mon, 28 Dec 2020 13:48:12 +0100
Message-Id: <20201228125044.632201023@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit be439cc4c404f646a8ba090fa786d53c10926b12 ]

Add MODULE_DEVICE_TABLE() so as to be able to use the driver as a
module. More precisely, for the driver to be loaded automatically at
boot.

Fixes: 1bc95972715a ("clk: bcm: Add BCM2711 DVP driver")
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Link: https://lore.kernel.org/r/20201202103518.21889-1-nsaenzjulienne@suse.de
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-bcm2711-dvp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/bcm/clk-bcm2711-dvp.c b/drivers/clk/bcm/clk-bcm2711-dvp.c
index 8333e20dc9d22..69e2f85f7029d 100644
--- a/drivers/clk/bcm/clk-bcm2711-dvp.c
+++ b/drivers/clk/bcm/clk-bcm2711-dvp.c
@@ -108,6 +108,7 @@ static const struct of_device_id clk_dvp_dt_ids[] = {
 	{ .compatible = "brcm,brcm2711-dvp", },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, clk_dvp_dt_ids);
 
 static struct platform_driver clk_dvp_driver = {
 	.probe	= clk_dvp_probe,
-- 
2.27.0



