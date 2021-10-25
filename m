Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EDF43A23F
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbhJYTrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236190AbhJYTo7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:44:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 085C86101C;
        Mon, 25 Oct 2021 19:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190731;
        bh=k4h7mDm1FTIA015LOnE2ug/myEehyELWNNItntL85ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skLFjv9liBwjSsVdw1O7vSxgwry+mIBfT1Ssc42YI1o1cTiVQHibvtWCGEwsk/Sgc
         vhXdma/ZzZ6GeyXlj6pJ31YvnA95jr6OhdiCvjWvgS19uXQmQZMkjhUslAAejT8jxz
         jBhtUQDKWSUrTnPDsws2/h/VQAtFDj+oSOHEpR+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Johansen <strit@manjaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Marius Gripsgard <marius@ubports.com>
Subject: [PATCH 5.14 057/169] drm/panel: ilitek-ili9881c: Fix sync for Feixin K101-IM2BYL02 panel
Date:   Mon, 25 Oct 2021 21:13:58 +0200
Message-Id: <20211025191024.802020032@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Johansen <strit@manjaro.org>

[ Upstream commit 772970620a839141835eaf2bc507d957b10adcca ]

This adjusts sync values according to the datasheet

Fixes: 1c243751c095 ("drm/panel: ilitek-ili9881c: add support for Feixin K101-IM2BYL02 panel")
Co-developed-by: Marius Gripsgard <marius@ubports.com>
Signed-off-by: Dan Johansen <strit@manjaro.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210818214818.298089-1-strit@manjaro.org
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-ilitek-ili9881c.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c b/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
index 0145129d7c66..534dd7414d42 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
@@ -590,14 +590,14 @@ static const struct drm_display_mode k101_im2byl02_default_mode = {
 	.clock		= 69700,
 
 	.hdisplay	= 800,
-	.hsync_start	= 800 + 6,
-	.hsync_end	= 800 + 6 + 15,
-	.htotal		= 800 + 6 + 15 + 16,
+	.hsync_start	= 800 + 52,
+	.hsync_end	= 800 + 52 + 8,
+	.htotal		= 800 + 52 + 8 + 48,
 
 	.vdisplay	= 1280,
-	.vsync_start	= 1280 + 8,
-	.vsync_end	= 1280 + 8 + 48,
-	.vtotal		= 1280 + 8 + 48 + 52,
+	.vsync_start	= 1280 + 16,
+	.vsync_end	= 1280 + 16 + 6,
+	.vtotal		= 1280 + 16 + 6 + 15,
 
 	.width_mm	= 135,
 	.height_mm	= 217,
-- 
2.33.0



