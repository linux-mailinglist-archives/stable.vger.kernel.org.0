Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4DC3CA9C0
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242285AbhGOTIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242218AbhGOTHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:07:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FBF0613DA;
        Thu, 15 Jul 2021 19:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375822;
        bh=8zY8dRMfQiVYsok90pcHhDj8dcATD+Fzm7MWBbgQjNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NlMEgCHh4KNwVxrb5Map9E4dZuUGvq1+6FWhntciEsqRNRB0BC0T38k3gpIBGb0qG
         fykN8dzDUqnU7j7ScndGsU2PzwoS0LS2OrlBU36OICFAjjoCNprNH50LvukCo7otEt
         npEuHCnbovqLGTuNri0AICzPycslKHLtgnj2rOwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Stefan Agner <stefan@agner.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 001/266] drm/mxsfb: Dont select DRM_KMS_FB_HELPER
Date:   Thu, 15 Jul 2021 20:35:56 +0200
Message-Id: <20210715182614.185406015@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 13b29cc3a722c2c0bc9ab9f72f9047d55d08a2f9 ]

Selecting DRM_FBDEV_EMULATION will include the correct settings for
fbdev emulation. Drivers should not override this.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Stefan Agner <stefan@agner.ch>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210415110040.23525-3-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/mxsfb/Kconfig b/drivers/gpu/drm/mxsfb/Kconfig
index 0143d539f8f8..ee22cd25d3e3 100644
--- a/drivers/gpu/drm/mxsfb/Kconfig
+++ b/drivers/gpu/drm/mxsfb/Kconfig
@@ -10,7 +10,6 @@ config DRM_MXSFB
 	depends on COMMON_CLK
 	select DRM_MXS
 	select DRM_KMS_HELPER
-	select DRM_KMS_FB_HELPER
 	select DRM_KMS_CMA_HELPER
 	select DRM_PANEL
 	select DRM_PANEL_BRIDGE
-- 
2.30.2



