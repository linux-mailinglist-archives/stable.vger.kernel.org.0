Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD9951A768
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354925AbiEDRDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354439AbiEDRA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9EB4C7A4;
        Wed,  4 May 2022 09:52:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FDDD61808;
        Wed,  4 May 2022 16:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94B4C385AA;
        Wed,  4 May 2022 16:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683136;
        bh=pH3brHySVuqvaO/GLTVJAdfN9TFvIk3pZnWEFz1DQdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tt8aATmK1TT30mfVrAqZ8dr3NIsGbPtdUCuNDssRzpbRECZFsyUBWD6MmIF1YG3I2
         PMn/LgmBqR7mZ4Stda51viOmmzdVcXMaGkAvHFSfsyNi9cAflJjj9m4FGyFg2m2rpT
         ZUqTAmKe4OVvFnGavGbwhb7QPuCfGrkbk9XgJQxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.10 109/129] drm/i915: Fix SEL_FETCH_PLANE_*(PIPE_B+) register addresses
Date:   Wed,  4 May 2022 18:45:01 +0200
Message-Id: <20220504153029.727825922@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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

From: Imre Deak <imre.deak@intel.com>

commit 4ae4dd2e26fdfebf0b8c6af6c325383eadfefdb4 upstream.

Fix typo in the _SEL_FETCH_PLANE_BASE_1_B register base address.

Fixes: a5523e2ff074a5 ("drm/i915: Add PSR2 selective fetch registers")
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: <stable@vger.kernel.org> # v5.9+
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220421162221.2261895-1-imre.deak@intel.com
(cherry picked from commit af2cbc6ef967f61711a3c40fca5366ea0bc7fecc)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_reg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -7202,7 +7202,7 @@ enum {
 #define _SEL_FETCH_PLANE_BASE_6_A		0x70940
 #define _SEL_FETCH_PLANE_BASE_7_A		0x70960
 #define _SEL_FETCH_PLANE_BASE_CUR_A		0x70880
-#define _SEL_FETCH_PLANE_BASE_1_B		0x70990
+#define _SEL_FETCH_PLANE_BASE_1_B		0x71890
 
 #define _SEL_FETCH_PLANE_BASE_A(plane) _PICK(plane, \
 					     _SEL_FETCH_PLANE_BASE_1_A, \


