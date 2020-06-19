Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793DD200F98
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404225AbgFSPTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392594AbgFSPSp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:18:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DB09206DB;
        Fri, 19 Jun 2020 15:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579924;
        bh=NwARTSH7XyqllZL+B+8gV7JlC9yF8Y14manG+jnxrHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PcIrMq5nipHNOvItYFI+mOT0sUBPqqfhJe5bjzuG9VvN0MIY5nnSVknR6/7tgijJS
         leAy6CJD6ibhqfRLCMm5Ep9c4KH7v2I6iz6Ts2MrtOCP1kz8xrHsFGV9Zo8dX9VnEi
         3wmlzXEL0/DVEIyNJLo9Ru++khVlyk+HFw/IA7SI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Pearson <mpearson@gmail.com>,
        Lyude Paul <lyude@redhat.com>, Sasha Levin <sashal@kernel.org>,
        jendrina@lenovo.com
Subject: [PATCH 5.7 056/376] drm/dp: Lenovo X13 Yoga OLED panel brightness fix
Date:   Fri, 19 Jun 2020 16:29:34 +0200
Message-Id: <20200619141712.992342977@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Pearson <mpearson.lenovo@gmail.com>

[ Upstream commit 0df3ff451287d71c620384eb7bb2cd3a8106412c ]

Add another panel that needs the edid quirk to the list so that
brightness control works correctly. Fixes issue seen on Lenovo X13 Yoga
with OLED panel

Co-developed-by: jendrina@lenovo.com
Signed-off-by: Mark Pearson <mpearson@gmail.com>
[fixed commit message, sobs]
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200519025635.22846-1-mpearson@lenovo.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_helper.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
index c6fbe6e6bc9d..41f0e797ce8c 100644
--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -1313,6 +1313,7 @@ static const struct edid_quirk edid_quirk_list[] = {
 	{ MFG(0x06, 0xaf), PROD_ID(0xeb, 0x41), BIT(DP_QUIRK_FORCE_DPCD_BACKLIGHT) },
 	{ MFG(0x4d, 0x10), PROD_ID(0xc7, 0x14), BIT(DP_QUIRK_FORCE_DPCD_BACKLIGHT) },
 	{ MFG(0x4d, 0x10), PROD_ID(0xe6, 0x14), BIT(DP_QUIRK_FORCE_DPCD_BACKLIGHT) },
+	{ MFG(0x4c, 0x83), PROD_ID(0x47, 0x41), BIT(DP_QUIRK_FORCE_DPCD_BACKLIGHT) },
 };
 
 #undef MFG
-- 
2.25.1



