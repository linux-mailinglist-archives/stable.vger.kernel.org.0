Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EC729C2D3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1820877AbgJ0Rjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:39:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760210AbgJ0Od7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:33:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFC3620773;
        Tue, 27 Oct 2020 14:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809239;
        bh=GhfGQ5Xd0qaQv6zUo4Pc376V5DOjoVEJjxUtEHqB9l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BlOYVQsWxjO77+eXnzStR2Ror1+hXbOcIkbojCGBgxfl73M9vJv9PauifMVEvjkuv
         TXTLQ54Q9R0Ju1bpM8SH8EFn7boGEkviCzkM+eKBbOEU58m6EoPFPEX95ogXaHxxn/
         S3SUD+HHLC/jRGLPvsf+2HHjUWrR+sBPZxQJqXEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 126/408] drm: panel: Fix bpc for OrtusTech COM43H4M85ULC panel
Date:   Tue, 27 Oct 2020 14:51:04 +0100
Message-Id: <20201027135500.949797139@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 3b8095169982ff4ec2a1b4be61b7224bbef23b48 ]

The OrtusTech COM43H4M85ULC panel is a 18-bit RGB panel. Commit
f098f168e91c ("drm: panel: Fix bus format for OrtusTech COM43H4M85ULC
panel") has fixed the bus formats, but forgot to address the bpc value.
Set it to 6.

Fixes: f098f168e91c ("drm: panel: Fix bus format for OrtusTech COM43H4M85ULC panel")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200824003254.21904-1-laurent.pinchart@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 14f5c79299cc0..f0ea782df836d 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2382,7 +2382,7 @@ static const struct drm_display_mode ortustech_com43h4m85ulc_mode  = {
 static const struct panel_desc ortustech_com43h4m85ulc = {
 	.modes = &ortustech_com43h4m85ulc_mode,
 	.num_modes = 1,
-	.bpc = 8,
+	.bpc = 6,
 	.size = {
 		.width = 56,
 		.height = 93,
-- 
2.25.1



