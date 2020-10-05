Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35F2283A00
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbgJEPaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727746AbgJEPaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:30:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5D6C2100A;
        Mon,  5 Oct 2020 15:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911818;
        bh=BgZQWKUaW7PpbmVoYL+qbRFZb5/Fc4dgOhBsRWHram8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tK6xQtqfWdDiz0A/KSDwHqWsrDwVN+k6iXd+WaFCNobpReFYvCuRu0W5+c0tNLdxc
         wV0GPFR2sYaR+AJRDOYWl7o1oZVTvHdzGmPO2rLBPnngcgMLAJmsz/IjubaF2YmjfI
         gcBsL8RP6bIk8EnPp5FUOWHhz5ArfTksklPeZbzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Cerveny <m.cerveny@computer.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/57] drm/sun4i: mixer: Extend regmap max_register
Date:   Mon,  5 Oct 2020 17:26:31 +0200
Message-Id: <20201005142110.721388936@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Cerveny <m.cerveny@computer.org>

[ Upstream commit 74ea06164cda81dc80e97790164ca533fd7e3087 ]

Better guess. Secondary CSC registers are from 0xF0000.

Signed-off-by: Martin Cerveny <m.cerveny@computer.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20200906162140.5584-3-m.cerveny@computer.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_mixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_mixer.c b/drivers/gpu/drm/sun4i/sun8i_mixer.c
index 18b4881f44814..12b99ba575017 100644
--- a/drivers/gpu/drm/sun4i/sun8i_mixer.c
+++ b/drivers/gpu/drm/sun4i/sun8i_mixer.c
@@ -396,7 +396,7 @@ static struct regmap_config sun8i_mixer_regmap_config = {
 	.reg_bits	= 32,
 	.val_bits	= 32,
 	.reg_stride	= 4,
-	.max_register	= 0xbfffc, /* guessed */
+	.max_register	= 0xffffc, /* guessed */
 };
 
 static int sun8i_mixer_of_get_id(struct device_node *node)
-- 
2.25.1



