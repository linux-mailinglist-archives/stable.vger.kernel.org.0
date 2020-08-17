Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D39246F5F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbgHQRq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388775AbgHQQOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:14:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5C9820825;
        Mon, 17 Aug 2020 16:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680843;
        bh=6zHXhwM6UKIINxvXom4eGFiGWD+R/zrKrM0EsRxcG+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmgIYonfqgPYi0RYIMIsI6L0UlV4U/bEEg6NbRQFGpfWDXo2w50O3wowNqYAoNpb/
         76M4jxDd8q7Vw6CNkPjrhaXNrpYxr80kziQPuCx/zt3GJdWLUI4hatWUEeCFyAuPre
         qnCrWnNyr1rtBifItTM0NT3f2dAkKY+SalheDwoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 080/168] drm: panel: simple: Fix bpc for LG LB070WV8 panel
Date:   Mon, 17 Aug 2020 17:16:51 +0200
Message-Id: <20200817143737.721172217@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit a6ae2fe5c9f9fd355a48fb7d21c863e5b20d6c9c ]

The LG LB070WV8 panel incorrectly reports a 16 bits per component value,
while the panel uses 8 bits per component. Fix it.

Fixes: dd0150026901 ("drm/panel: simple: Add support for LG LB070WV8 800x480 7" panel")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200711225317.28476-1-laurent.pinchart+renesas@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 654fea2b43124..8814aa38c5e7b 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1503,7 +1503,7 @@ static const struct drm_display_mode lg_lb070wv8_mode = {
 static const struct panel_desc lg_lb070wv8 = {
 	.modes = &lg_lb070wv8_mode,
 	.num_modes = 1,
-	.bpc = 16,
+	.bpc = 8,
 	.size = {
 		.width = 151,
 		.height = 91,
-- 
2.25.1



