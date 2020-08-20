Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46BB24B86F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgHTLUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:20:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730548AbgHTKHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:07:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 242F52075E;
        Thu, 20 Aug 2020 10:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918058;
        bh=2TtNXNa8iMW4REURFARyXwapDksZkPC7BzZq5kPtCvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06Te27rlxDVHaCCNrmzJIVwGaY/8uXpUA+Rt6Ci4TYA4YNiYnf/ya77SxUVIJ11zC
         HRduOQD57DVu4yaPXewqgwTC/yYluJJOnN4A+PCvD7SQV4L9bcc/fZcTenz4Swt5xz
         j7uL88YwGD+fiswfsS22vBhokwNhT8E9mIhgfvaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 021/228] drm/nouveau/fbcon: zero-initialise the mode_cmd2 structure
Date:   Thu, 20 Aug 2020 11:19:56 +0200
Message-Id: <20200820091608.591615474@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 15fbc3b938534cc8eaac584a7b0c1183fc968b86 ]

This is tripping up the format modifier patches.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index ee8f744dc4881..9ffb09679cc4a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -310,7 +310,7 @@ nouveau_fbcon_create(struct drm_fb_helper *helper,
 	struct nouveau_framebuffer *fb;
 	struct nouveau_channel *chan;
 	struct nouveau_bo *nvbo;
-	struct drm_mode_fb_cmd2 mode_cmd;
+	struct drm_mode_fb_cmd2 mode_cmd = {};
 	int ret;
 
 	mode_cmd.width = sizes->surface_width;
-- 
2.25.1



