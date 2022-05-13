Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D0552644D
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380781AbiEMO3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380714AbiEMO1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:27:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116FC50E18;
        Fri, 13 May 2022 07:27:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9458462155;
        Fri, 13 May 2022 14:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66961C34100;
        Fri, 13 May 2022 14:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452052;
        bh=1AoLTDAALQr7QOhpcU99xOeIqr+N6b46LV8dUcsNKbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpBWzMIn5uHHY2no+27zb+/KGRH4NGUzEO7+SrtOhW7gguOeKfAkihd8UaRgGCwXa
         ZYfCesZYi1+SE/3U4tHq2HT3SflakMlnaBxbtaFoLcqQioY2Z/Enc+zTFryqq9QHh5
         2KKetrW7RJABo9l7Fz1YpqFGE3grK5Z6G3V/SXpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, Lee Jones <lee.jones@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 04/10] drm/amd/display/dc/gpio/gpio_service: Pass around correct dce_{version, environment} types
Date:   Fri, 13 May 2022 16:23:48 +0200
Message-Id: <20220513142228.435635841@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142228.303546319@linuxfoundation.org>
References: <20220513142228.303546319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

commit 353f7f3a9dd5fd2833b6462bac89ec1654c9c3aa upstream.

Fixes the following W=1 kernel build warning(s):

 drivers/gpu/drm/amd/amdgpu/../display/dc/gpio/gpio_service.c: In function ‘dal_gpio_service_create’:
 drivers/gpu/drm/amd/amdgpu/../display/dc/gpio/gpio_service.c:71:4: warning: implicit conversion from ‘enum dce_version’ to ‘enum dce_environment’ [-Wenum-conversion]
 drivers/gpu/drm/amd/amdgpu/../display/dc/gpio/gpio_service.c:77:4: warning: implicit conversion from ‘enum dce_version’ to ‘enum dce_environment’ [-Wenum-conversion]

Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Leo Li <sunpeng.li@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: amd-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c           |   12 +++++------
 drivers/gpu/drm/amd/display/include/gpio_service_interface.h |    4 +--
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c
+++ b/drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c
@@ -53,8 +53,8 @@
  */
 
 struct gpio_service *dal_gpio_service_create(
-	enum dce_version dce_version_major,
-	enum dce_version dce_version_minor,
+	enum dce_version dce_version,
+	enum dce_environment dce_environment,
 	struct dc_context *ctx)
 {
 	struct gpio_service *service;
@@ -67,14 +67,14 @@ struct gpio_service *dal_gpio_service_cr
 		return NULL;
 	}
 
-	if (!dal_hw_translate_init(&service->translate, dce_version_major,
-			dce_version_minor)) {
+	if (!dal_hw_translate_init(&service->translate, dce_version,
+			dce_environment)) {
 		BREAK_TO_DEBUGGER();
 		goto failure_1;
 	}
 
-	if (!dal_hw_factory_init(&service->factory, dce_version_major,
-			dce_version_minor)) {
+	if (!dal_hw_factory_init(&service->factory, dce_version,
+			dce_environment)) {
 		BREAK_TO_DEBUGGER();
 		goto failure_1;
 	}
--- a/drivers/gpu/drm/amd/display/include/gpio_service_interface.h
+++ b/drivers/gpu/drm/amd/display/include/gpio_service_interface.h
@@ -42,8 +42,8 @@ void dal_gpio_destroy(
 	struct gpio **ptr);
 
 struct gpio_service *dal_gpio_service_create(
-	enum dce_version dce_version_major,
-	enum dce_version dce_version_minor,
+	enum dce_version dce_version,
+	enum dce_environment dce_environment,
 	struct dc_context *ctx);
 
 struct gpio *dal_gpio_service_create_irq(


