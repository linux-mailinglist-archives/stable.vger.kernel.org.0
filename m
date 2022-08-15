Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5FE7594165
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243165AbiHOVC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347681AbiHOVCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:02:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86745CE496;
        Mon, 15 Aug 2022 12:14:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B83A060EF0;
        Mon, 15 Aug 2022 19:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAE9C433C1;
        Mon, 15 Aug 2022 19:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590852;
        bh=0GoneA/qGJtls0aUIePvwzp+dy/pKMZAcfjAAZ2A3tM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TiySknY54gVgjRw/9EQ8HRB1yqozhHJNebAoJbXQMtYNpQQTDXZzt1XWMD5NMEAW5
         bU8hyWNAX6O+v0DrhuXLOaDRBmqlxkJdgiG6XIkee+SRHibBMqTwlYT+BHBzZm5xUl
         38n91VpZVwwN6O8a5GMaUWngEvXjA1nULhq3eE0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0364/1095] drm/radeon: fix incorrrect SPDX-License-Identifiers
Date:   Mon, 15 Aug 2022 19:56:03 +0200
Message-Id: <20220815180444.778790656@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 1f43b8903f3aae4a26a603c36f6d5dd25d6edb51 ]

radeon is MIT.  This were incorrectly changed in
commit b24413180f56 ("License cleanup: add SPDX GPL-2.0 license identifier to files with no license")
and
commit d198b34f3855 (".gitignore: add SPDX License Identifier")
and:
commit ec8f24b7faaf ("treewide: Add SPDX license identifier - Makefile/Kconfig")

Fixes: d198b34f3855 (".gitignore: add SPDX License Identifier")
Fixes: ec8f24b7faaf ("treewide: Add SPDX license identifier - Makefile/Kconfig")
Fixes: b24413180f56 ("License cleanup: add SPDX GPL-2.0 license identifier to files with no license")
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2053
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/.gitignore | 2 +-
 drivers/gpu/drm/radeon/Kconfig    | 2 +-
 drivers/gpu/drm/radeon/Makefile   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/.gitignore b/drivers/gpu/drm/radeon/.gitignore
index 9c1a94153983..d8777383a64a 100644
--- a/drivers/gpu/drm/radeon/.gitignore
+++ b/drivers/gpu/drm/radeon/.gitignore
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0-only
+# SPDX-License-Identifier: MIT
 mkregtable
 *_reg_safe.h
 
diff --git a/drivers/gpu/drm/radeon/Kconfig b/drivers/gpu/drm/radeon/Kconfig
index 6f60f4840cc5..52819e7f1fca 100644
--- a/drivers/gpu/drm/radeon/Kconfig
+++ b/drivers/gpu/drm/radeon/Kconfig
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0-only
+# SPDX-License-Identifier: MIT
 config DRM_RADEON_USERPTR
 	bool "Always enable userptr support"
 	depends on DRM_RADEON
diff --git a/drivers/gpu/drm/radeon/Makefile b/drivers/gpu/drm/radeon/Makefile
index 11c97edde54d..3d502f1bbfcb 100644
--- a/drivers/gpu/drm/radeon/Makefile
+++ b/drivers/gpu/drm/radeon/Makefile
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0
+# SPDX-License-Identifier: MIT
 #
 # Makefile for the drm device driver.  This driver provides support for the
 # Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
-- 
2.35.1



