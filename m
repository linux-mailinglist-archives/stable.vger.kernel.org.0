Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325022E12B0
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgLWCXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:23:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:52148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728944AbgLWCX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE7C122202;
        Wed, 23 Dec 2020 02:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690190;
        bh=VvXvEW1RDgg5wGctb1IXHpEUGrkdqawmRiT3EwkA874=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9kIPilm9nFo6Iwk9A9WsDsxkMWmmU4D5qKWPsRK6lFxKLFTvgq+44WYZo3f/Jmux
         jXJJmYu6fYyZom+FzDNP6+x3d66bk0CmEtUdpee+cn434MRd+nicYJhqZUrsdwyAyW
         OWUvt/AGGRxQ5XQnmqJFVyNRb4W6PLUK7IufqQ45iGpIqPo5pJMf0rmV5Vhx+hSEx4
         OsVTtJe+Fv7LNdJGzsD6IlEEOKI/PIbCvvZyZdG3LUyr8azpQqjnFW5zurBSmDmpFY
         cr9c4ObJivAhAPKvqPtrDOiSTnwdhMjPSDtEz05RHji2T5NifsdDwm6Qvo6bAfdYtE
         A+wHuTYMnoawA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 14/66] drm/ast: Fixed 1920x1080 sync. polarity issue
Date:   Tue, 22 Dec 2020 21:22:00 -0500
Message-Id: <20201223022253.2793452-14-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>

[ Upstream commit 2d26123dd9075df82f217364f585a3a6aab5412d ]

[Bug] Change the vertical synchroous polary of 1920x1080 @60Hz
      from  Negtive to Positive

Signed-off-by: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20201105094729.106059-1-kuohsiang_chou@aspeedtech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_tables.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_tables.h b/drivers/gpu/drm/ast/ast_tables.h
index d665dd5af5dd8..dbe1cc620f6e6 100644
--- a/drivers/gpu/drm/ast/ast_tables.h
+++ b/drivers/gpu/drm/ast/ast_tables.h
@@ -293,10 +293,10 @@ static const struct ast_vbios_enhtable res_1600x900[] = {
 
 static const struct ast_vbios_enhtable res_1920x1080[] = {
 	{2200, 1920, 88, 44, 1125, 1080, 4, 5, VCLK148_5,	/* 60Hz */
-	 (SyncNP | Charx8Dot | LineCompareOff | WideScreenMode | NewModeInfo |
+	 (SyncPP | Charx8Dot | LineCompareOff | WideScreenMode | NewModeInfo |
 	  AST2500PreCatchCRT), 60, 1, 0x38 },
 	{2200, 1920, 88, 44, 1125, 1080, 4, 5, VCLK148_5,	/* 60Hz */
-	 (SyncNP | Charx8Dot | LineCompareOff | WideScreenMode | NewModeInfo |
+	 (SyncPP | Charx8Dot | LineCompareOff | WideScreenMode | NewModeInfo |
 	  AST2500PreCatchCRT), 0xFF, 1, 0x38 },
 };
 
-- 
2.27.0

