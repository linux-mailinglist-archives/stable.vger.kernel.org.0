Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C5563E3B6
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 23:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiK3WwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 17:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiK3Wvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 17:51:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3A98E598;
        Wed, 30 Nov 2022 14:51:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B0F5B81D4B;
        Wed, 30 Nov 2022 22:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9724C433C1;
        Wed, 30 Nov 2022 22:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669848711;
        bh=evvF53w8GxD/57JBkn5RanlX8F+Ck9LbWx8lj8rl2XM=;
        h=Date:To:From:Subject:From;
        b=Go9Q8H7EE5F29VfGdqHbGMuLOsPScCAQQl+l14fMOdrqgaeJUCEPdDpm/N9DesSQ5
         ESDn4yrLp4hks/EQl/prDx2Bne9NvAIb6t35v61ftSbX4f1YgVFdFHl4M1Te8RsMX/
         P5cXJ1YeFATev/ozhI11wamPpgPda3FDBdBzQvR8=
Date:   Wed, 30 Nov 2022 14:51:51 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        tzimmermann@suse.de, trix@redhat.com, sunpeng.li@amd.com,
        stable@vger.kernel.org, Rodrigo.Siqueira@amd.com,
        ndesaulniers@google.com, nathan@kernel.org, mripard@kernel.org,
        maarten.lankhorst@linux.intel.com, harry.wentland@amd.com,
        daniel@ffwll.ch, christian.koenig@amd.com, arnd@arndb.de,
        alexander.deucher@amd.com, airlied@gmail.com, lee@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kconfigdebug-provide-a-little-extra-frame_warn-leeway-when-kasan-is-enabled.patch removed from -mm tree
Message-Id: <20221130225151.C9724C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled
has been removed from the -mm tree.  Its filename was
     kconfigdebug-provide-a-little-extra-frame_warn-leeway-when-kasan-is-enabled.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lee Jones <lee@kernel.org>
Subject: Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled
Date: Fri, 25 Nov 2022 12:07:50 +0000

When enabled, KASAN enlarges function's stack-frames.  Pushing quite a few
over the current threshold.  This can mainly be seen on 32-bit
architectures where the present limit (when !GCC) is a lowly 1024-Bytes.

Link: https://lkml.kernel.org/r/20221125120750.3537134-3-lee@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Leo Li <sunpeng.li@amd.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Tom Rix <trix@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.debug~kconfigdebug-provide-a-little-extra-frame_warn-leeway-when-kasan-is-enabled
+++ a/lib/Kconfig.debug
@@ -399,6 +399,7 @@ config FRAME_WARN
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
 	default 2048 if PARISC
 	default 1536 if (!64BIT && XTENSA)
+	default 1280 if KASAN && !64BIT
 	default 1024 if !64BIT
 	default 2048 if 64BIT
 	help
_

Patches currently in -mm which might be from lee@kernel.org are


