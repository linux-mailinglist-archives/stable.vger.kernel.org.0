Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0215948BA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347384AbiHOXP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245338AbiHOXOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:14:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE9C12F71D;
        Mon, 15 Aug 2022 13:01:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3865061299;
        Mon, 15 Aug 2022 20:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBBCC433D7;
        Mon, 15 Aug 2022 20:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593678;
        bh=wkCfAnjFsSmxAg0uM9KGph7C/w9NhuQf22vBGcpc4qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dAzbwj8la92tG6qAHHRbiWnKA2d5KJr0eel5r/T96EanhMR8Veu/GFX7Qp9ZAybKL
         i1Hw6I7+yjZ+PidYt1R1jmTsbSfpxwGrYG1e7NJxVBu5wEtKkWK1ibuDohnaNtGQAg
         GuulmSygY7yIG2tc+QHYGfa6PGwZYgRjrqt6KGuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0306/1157] drm/i915: remove unused GEM_DEBUG_DECL() and GEM_DEBUG_BUG_ON()
Date:   Mon, 15 Aug 2022 19:54:22 +0200
Message-Id: <20220815180451.900305479@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 1b93ff4d0679190e8812cd0d0b3aebfcba1ed883 ]

There are already too many choices here, take away the unused ones.

Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220504183716.987793-1-jani.nikula@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_gem.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.h b/drivers/gpu/drm/i915/i915_gem.h
index d0752e5553db..b7b257f54d2e 100644
--- a/drivers/gpu/drm/i915/i915_gem.h
+++ b/drivers/gpu/drm/i915/i915_gem.h
@@ -54,9 +54,7 @@ struct drm_i915_private;
 	} while(0)
 #define GEM_WARN_ON(expr) WARN_ON(expr)
 
-#define GEM_DEBUG_DECL(var) var
 #define GEM_DEBUG_EXEC(expr) expr
-#define GEM_DEBUG_BUG_ON(expr) GEM_BUG_ON(expr)
 #define GEM_DEBUG_WARN_ON(expr) GEM_WARN_ON(expr)
 
 #else
@@ -66,9 +64,7 @@ struct drm_i915_private;
 #define GEM_BUG_ON(expr) BUILD_BUG_ON_INVALID(expr)
 #define GEM_WARN_ON(expr) ({ unlikely(!!(expr)); })
 
-#define GEM_DEBUG_DECL(var)
 #define GEM_DEBUG_EXEC(expr) do { } while (0)
-#define GEM_DEBUG_BUG_ON(expr)
 #define GEM_DEBUG_WARN_ON(expr) ({ BUILD_BUG_ON_INVALID(expr); 0; })
 #endif
 
-- 
2.35.1



