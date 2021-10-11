Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3872B429095
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241004AbhJKOK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239968AbhJKOIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:08:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8495D61250;
        Mon, 11 Oct 2021 14:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960881;
        bh=Jpg09icJjYOoaBjx9uHfqBhOCOvXDfEx0NUkuahEwaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G259VVFQwNhbbHL++PqiAslqspjcOwK7xF/zaTpht3iKt+TyKwwZiZgXqSjSBoa3T
         06pnPJ7wvSrwP7o4QCsIsYc+TOaNde4XdmhJvBR5cDJkgaVrTVL4rnpnrDd4XrF32n
         m3fhKWeilAxYy8/xgVqmSzAukr+BOZV+5BjaulkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Branchereau <cbranchereau@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Paul Cercueil <paul@crapouillou.net>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 101/151] drm/panel: abt-y030xx067a: yellow tint fix
Date:   Mon, 11 Oct 2021 15:46:13 +0200
Message-Id: <20211011134521.083252472@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Branchereau <cbranchereau@gmail.com>

[ Upstream commit 413e8d06ad896dae9bbc6f97b0abea5eae5495f1 ]

The previous parameters caused an unbalanced yellow tint.

Fixes: 7467389bdafb ("drm/panel: Add ABT Y030XX067A 3.0" 320x480 panel")
Signed-off-by: Christophe Branchereau <cbranchereau@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
[Paul: Add Fixes: tag, and fix case and punctuation in commit message]
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20210914092716.2370039-1-cbranchereau@gmail.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-abt-y030xx067a.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-abt-y030xx067a.c b/drivers/gpu/drm/panel/panel-abt-y030xx067a.c
index 2d8794d495d0..3d8a9ab47cae 100644
--- a/drivers/gpu/drm/panel/panel-abt-y030xx067a.c
+++ b/drivers/gpu/drm/panel/panel-abt-y030xx067a.c
@@ -146,8 +146,8 @@ static const struct reg_sequence y030xx067a_init_sequence[] = {
 	{ 0x09, REG09_SUB_BRIGHT_R(0x20) },
 	{ 0x0a, REG0A_SUB_BRIGHT_B(0x20) },
 	{ 0x0b, REG0B_HD_FREERUN | REG0B_VD_FREERUN },
-	{ 0x0c, REG0C_CONTRAST_R(0x10) },
-	{ 0x0d, REG0D_CONTRAST_G(0x10) },
+	{ 0x0c, REG0C_CONTRAST_R(0x00) },
+	{ 0x0d, REG0D_CONTRAST_G(0x00) },
 	{ 0x0e, REG0E_CONTRAST_B(0x10) },
 	{ 0x0f, 0 },
 	{ 0x10, REG10_BRIGHT(0x7f) },
-- 
2.33.0



