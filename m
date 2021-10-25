Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD0D43A29D
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbhJYTud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237459AbhJYTrY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:47:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B1ED611CB;
        Mon, 25 Oct 2021 19:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190821;
        bh=Z7a3wzQB/hssMjpN8UOeL/XqmTnt9B6oAdAifSdnf+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zYP5ndwUVxblvUjziBT87S3bWEF/FXIUUTmj5f5AVy9xWMD+e4vHXZUfXxBZSKcgd
         C4PLKgcBWjJt1undV0tD0S88S2rEcQzGRmPSOk2qzBigMLCcN0fahjn8niV8IYjINV
         1WMzRNFCabYlXE8dIuVh7kIX+XZTJhIn9B6y9H/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anitha Chrisanthus <anitha.chrisanthus@intel.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 061/169] drm/kmb: Corrected typo in handle_lcd_irq
Date:   Mon, 25 Oct 2021 21:14:02 +0200
Message-Id: <20211025191025.220333170@linuxfoundation.org>
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

From: Anitha Chrisanthus <anitha.chrisanthus@intel.com>

[ Upstream commit 004d2719806fb8e355c1bccd538e82c04319d391 ]

Check for Overflow bits for layer3 in the irq handler.

Fixes: 7f7b96a8a0a1 ("drm/kmb: Add support for KeemBay Display")
Signed-off-by: Anitha Chrisanthus <anitha.chrisanthus@intel.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211013233632.471892-5-anitha.chrisanthus@intel.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/kmb/kmb_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/kmb/kmb_drv.c b/drivers/gpu/drm/kmb/kmb_drv.c
index f54392ec4fab..bb7eca9e13ae 100644
--- a/drivers/gpu/drm/kmb/kmb_drv.c
+++ b/drivers/gpu/drm/kmb/kmb_drv.c
@@ -381,7 +381,7 @@ static irqreturn_t handle_lcd_irq(struct drm_device *dev)
 		if (val & LAYER3_DMA_FIFO_UNDERFLOW)
 			drm_dbg(&kmb->drm,
 				"LAYER3:GL1 DMA UNDERFLOW val = 0x%lx", val);
-		if (val & LAYER3_DMA_FIFO_UNDERFLOW)
+		if (val & LAYER3_DMA_FIFO_OVERFLOW)
 			drm_dbg(&kmb->drm,
 				"LAYER3:GL1 DMA OVERFLOW val = 0x%lx", val);
 	}
-- 
2.33.0



