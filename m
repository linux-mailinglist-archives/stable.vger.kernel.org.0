Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED06A2408C9
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgHJPZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbgHJPZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:25:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04ECE20772;
        Mon, 10 Aug 2020 15:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073108;
        bh=nGpeLG21Dvg+Nmre5tLkQr5WxfGP/5qtM6NgnOvlGGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnLfoJnhadVXLIAekAkAJPl3VjNmQw9Ukhwharc6ipobW42eoxc980FASMkKkMlTF
         N+WR58kzY7BLr2wIICtmdJEiAX7PEW01tt03RSuKeztU4Usuh986ncWmVGL//pXbkt
         1jCtrExY5fA64OClp+RoUKpoHamIfyYTqA8tdheg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jitao Shi <jitao.shi@mediatek.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 39/79] drm/panel: Fix auo, kd101n80-45na horizontal noise on edges of panel
Date:   Mon, 10 Aug 2020 17:20:58 +0200
Message-Id: <20200810151814.203744726@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jitao Shi <jitao.shi@mediatek.com>

[ Upstream commit d76acc9fcddeda53b985b029c890976a87fcc3fc ]

Fine tune the HBP and HFP to avoid the dot noise on the left and right edges.

Signed-off-by: Jitao Shi <jitao.shi@mediatek.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200714123332.37609-1-jitao.shi@mediatek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
index 48a164257d18c..3edb33e619088 100644
--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -615,9 +615,9 @@ static const struct panel_desc boe_tv101wum_nl6_desc = {
 static const struct drm_display_mode auo_kd101n80_45na_default_mode = {
 	.clock = 157000,
 	.hdisplay = 1200,
-	.hsync_start = 1200 + 80,
-	.hsync_end = 1200 + 80 + 24,
-	.htotal = 1200 + 80 + 24 + 36,
+	.hsync_start = 1200 + 60,
+	.hsync_end = 1200 + 60 + 24,
+	.htotal = 1200 + 60 + 24 + 56,
 	.vdisplay = 1920,
 	.vsync_start = 1920 + 16,
 	.vsync_end = 1920 + 16 + 4,
-- 
2.25.1



