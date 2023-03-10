Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F506B4304
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjCJOKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjCJOJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:09:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D75E116C36
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:08:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4C7860D29
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5527C433D2;
        Fri, 10 Mar 2023 14:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457325;
        bh=FiGWTSRi8jwQPxcgYZ80FI0oc0kERnP0xwXyK8GlclA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FyNuBhpoMrdlrhL/jRt1l617Bdp01O/XInLgMmhModzYCZODGil09HH9+16D41Eyf
         jR7VPo0qUBRMy5ZwrM/sFP4aJwgCFPXvrxC2WAqeh4UJNsQqsF9voGM5gzvc+ljpEE
         PMIbniSxC4O+TxR+nwMAGCk8hIJtsYMXp7n0Gjhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/200] drm/i915: move a Kconfig symbol to unbreak the menu presentation
Date:   Fri, 10 Mar 2023 14:37:55 +0100
Message-Id: <20230310133719.213346000@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 0b93efca3659f6d55ed31cff6722dca5f6e4d6e2 ]

Inserting a Kconfig symbol that does not have a dependency (DRM_I915_GVT)
into a list of other symbols that do have a dependency (on DRM_I915)
breaks the driver menu presentation in 'make *config'.

Relocate the DRM_I915_GVT symbol so that it does not cause this
problem.

Fixes: 8b750bf74418 ("drm/i915/gvt: move the gvt code into kvmgt.ko")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Zhi Wang <zhi.a.wang@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: intel-gvt-dev@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20230215044533.4847-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
index 3efce05d7b57c..3a6e176d77aa5 100644
--- a/drivers/gpu/drm/i915/Kconfig
+++ b/drivers/gpu/drm/i915/Kconfig
@@ -107,9 +107,6 @@ config DRM_I915_USERPTR
 
 	  If in doubt, say "Y".
 
-config DRM_I915_GVT
-	bool
-
 config DRM_I915_GVT_KVMGT
 	tristate "Enable KVM host support Intel GVT-g graphics virtualization"
 	depends on DRM_I915
@@ -160,3 +157,6 @@ menu "drm/i915 Unstable Evolution"
 	depends on DRM_I915
 	source "drivers/gpu/drm/i915/Kconfig.unstable"
 endmenu
+
+config DRM_I915_GVT
+	bool
-- 
2.39.2



