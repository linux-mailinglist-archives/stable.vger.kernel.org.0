Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A863629C0A4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818080AbgJ0RRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:17:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1781848AbgJ0O4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:56:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2D522071A;
        Tue, 27 Oct 2020 14:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810572;
        bh=18PhdWFrFMv0hG7CDUW+3AHKc9YeNoFlxEkbuNliLs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxhnV9C7OR7t5U3Z4+TL4+3cvTJywH6M+ilsHoDnoUMqiSTynXtMUxTKTZqMoGmWW
         kNOsC+kp/xCI1MeBG4loOx6LJan8HpUteokSuoad6Z59pnwhFocv5CyXSvIRt4Eo1Q
         oG2dplW1KSEmkVJhpFiTy6OibreFltoja5DkYn2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 187/633] drm: panel: Fix bpc for OrtusTech COM43H4M85ULC panel
Date:   Tue, 27 Oct 2020 14:48:50 +0100
Message-Id: <20201027135531.460491517@linuxfoundation.org>
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
index 85fa4027d82d7..4b4ca31a2d577 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2862,7 +2862,7 @@ static const struct drm_display_mode ortustech_com43h4m85ulc_mode  = {
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



