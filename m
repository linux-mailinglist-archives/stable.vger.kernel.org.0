Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8ED33DD9BF
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236066AbhHBODd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235770AbhHBOBa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:01:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6665E6120F;
        Mon,  2 Aug 2021 13:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912598;
        bh=DUEL/2iTrGvytBaZL4KoDGsDkh3QmOAEGwVtZZHng2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X06remQ+leypGjce72kOvuX2jl8i62YnYD2y+Hb7kTiy5U6HXIikZbxOe3CQBRqpP
         TUDn+gqMvtsW+dzZ5i0+02y+wiXdAcVIL/4yVTA/t8bcPvCaqy9opyzrkdEgoJHK+i
         cZgPIl6R77Kk1Ux44T+lw0a0wDXOA14n/Q2S7kD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jagan Teki <jagan@amarulasolutions.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 066/104] drm/panel: panel-simple: Fix proper bpc for ytc700tlag_05_201c
Date:   Mon,  2 Aug 2021 15:45:03 +0200
Message-Id: <20210802134346.175931442@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jagan Teki <jagan@amarulasolutions.com>

[ Upstream commit 44379b986424b02acfa6e8c85ec5d68d89d3ccc4 ]

ytc700tlag_05_201c panel support 8 bpc not 6 bpc as per
recent testing in i.MX8MM platform.

Fix it.

Fixes: 7a1f4fa4a629 ("drm/panel: simple: Add YTC700TLAG-05-201C")
Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210725174737.891106-1-jagan@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index be312b5c04dd..1301d42cfffb 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -4124,7 +4124,7 @@ static const struct drm_display_mode yes_optoelectronics_ytc700tlag_05_201c_mode
 static const struct panel_desc yes_optoelectronics_ytc700tlag_05_201c = {
 	.modes = &yes_optoelectronics_ytc700tlag_05_201c_mode,
 	.num_modes = 1,
-	.bpc = 6,
+	.bpc = 8,
 	.size = {
 		.width = 154,
 		.height = 90,
-- 
2.30.2



