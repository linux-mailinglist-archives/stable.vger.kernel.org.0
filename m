Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BF34575EE
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbhKSRnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:43:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235083AbhKSRm6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:42:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57C226113A;
        Fri, 19 Nov 2021 17:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343596;
        bh=hXzFbEnW12ZFfm+7pEjkuldY0VLubddoq0czroiTRWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqOMBegP5rLnyJFjNcu/COnEcvtEI/ek/oGLfXpOBnCFeiE9j9D7vnbkIliq05qAg
         VPabSb8sWwBkyyBoyEO1FPbFeFWmTaDUbnDLShwJyOCfzhFOmD1Yr66mAgCXvO8GeG
         rPyDxQyGVaiiw/lmc7zAA1INWId5Kq1jD7yeEHGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/20] Revert "drm: fb_helper: fix CONFIG_FB dependency"
Date:   Fri, 19 Nov 2021 18:39:21 +0100
Message-Id: <20211119171444.748503128@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
References: <20211119171444.640508836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit c95380ba527ae0aee29b2a133c5d0c481d472759 which is
commit 606b102876e3741851dfb09d53f3ee57f650a52c upstream.

It causes some build problems as reported by Jiri.

Link: https://lore.kernel.org/r/9fdb2bf1-de52-1b9d-4783-c61ce39e8f51@kernel.org
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -103,7 +103,7 @@ config DRM_DEBUG_DP_MST_TOPOLOGY_REFS
 config DRM_FBDEV_EMULATION
 	bool "Enable legacy fbdev support for your modesetting driver"
 	depends on DRM
-	depends on FB=y || FB=DRM
+	depends on FB
 	select DRM_KMS_HELPER
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA


