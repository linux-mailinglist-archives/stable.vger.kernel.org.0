Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782C5240A26
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgHJPZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728521AbgHJPZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:25:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 804F620658;
        Mon, 10 Aug 2020 15:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073126;
        bh=daSujJqalxOnFgPexOzYox4sW5tvLzbbdq92CfDmxrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqVf86MNhjBKZf3BrJBBwMqHFqzpInVzwY5x2pCkUBhIJbEt2GLayfG8hb/7KTPQX
         x5w9YlFbyNt7eDXqLnpFRWRZPM2GVFHn3b1TOiBsrSpQ1h8IywGMexfpv8PNEe+UcM
         Q2QAYHL9VHvlDK5iFUeEh41DoTQ/JvCfdytFXswc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 35/79] drm/nouveau/fbcon: zero-initialise the mode_cmd2 structure
Date:   Mon, 10 Aug 2020 17:20:54 +0200
Message-Id: <20200810151814.016946010@linuxfoundation.org>
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

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 15fbc3b938534cc8eaac584a7b0c1183fc968b86 ]

This is tripping up the format modifier patches.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index e42100a2425fd..47883f225941d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -315,7 +315,7 @@ nouveau_fbcon_create(struct drm_fb_helper *helper,
 	struct nouveau_framebuffer *fb;
 	struct nouveau_channel *chan;
 	struct nouveau_bo *nvbo;
-	struct drm_mode_fb_cmd2 mode_cmd;
+	struct drm_mode_fb_cmd2 mode_cmd = {};
 	int ret;
 
 	mode_cmd.width = sizes->surface_width;
-- 
2.25.1



