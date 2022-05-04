Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC17B51A862
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355880AbiEDRKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356160AbiEDRJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE3A527DB;
        Wed,  4 May 2022 09:54:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB6A8B8278E;
        Wed,  4 May 2022 16:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6B9C385A5;
        Wed,  4 May 2022 16:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683293;
        bh=sIcdSQKIIDNNFM/w9Updax0ffwrvLpzihuIATxAFl1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnPx14KT7XLjFf+bhymLHWFN3gjI/glrZD7F8ckrIA0pTu3qrZ3+FmOwIntdloACE
         H/VfjzZV2A8peEdukMzKWTcMN3IC4OZqj9vMWZfHTSX1j5QXV8o5MTI0w7qie4hKO6
         oJDi0wg6EhTPdpcbs1G6JULWHdcbwZFO6Ssj2rGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.15 147/177] drm/i915: Fix SEL_FETCH_PLANE_*(PIPE_B+) register addresses
Date:   Wed,  4 May 2022 18:45:40 +0200
Message-Id: <20220504153106.457815410@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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
@@ -7458,7 +7458,7 @@ enum {
 #define _SEL_FETCH_PLANE_BASE_6_A		0x70940
 #define _SEL_FETCH_PLANE_BASE_7_A		0x70960
 #define _SEL_FETCH_PLANE_BASE_CUR_A		0x70880
-#define _SEL_FETCH_PLANE_BASE_1_B		0x70990
+#define _SEL_FETCH_PLANE_BASE_1_B		0x71890
 
 #define _SEL_FETCH_PLANE_BASE_A(plane) _PICK(plane, \
 					     _SEL_FETCH_PLANE_BASE_1_A, \


