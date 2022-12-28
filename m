Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF7A657D50
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiL1PmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbiL1PmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:42:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379C317411
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:41:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0F1BB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F810C433D2;
        Wed, 28 Dec 2022 15:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242105;
        bh=SClkrmNjl9BiacFl33xQGVQVYpd8Ndhx0npwfmRUNmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gy/BTj83YOSLS3DJGBVtPlHFgpMvArjPkCMH3zWO21nLOyqbg+CM1Fx2DesVsxEss
         AMX+qXplpYULjMeDNJ7qbWM1XUOYgRxFyxAYzBm0NfuLt4BAUgpL0s59oy39SRdTaI
         SK5DeL36239AshQLnaemrZ5jOFby+A64njUDE508=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alan Previn <alan.previn.teres.alexis@intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0368/1073] drm/i915/guc: make default_lists const data
Date:   Wed, 28 Dec 2022 15:32:36 +0100
Message-Id: <20221228144337.999409317@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit dfa5e6ef3ccefff9fa8a70d9f5fa6ef6244aa312 ]

The default_lists array should be in rodata.

Fixes: dce2bd542337 ("drm/i915/guc: Add Gen9 registers for GuC error state capture.")
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221122141616.3469214-1-jani.nikula@intel.com
(cherry picked from commit 8b7f7a9b10b704ba7d73199ff0f01354e0bad7a5)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
index 34e72675b7e4..4c51888fd78b 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
@@ -165,7 +165,7 @@ static const struct __guc_mmio_reg_descr empty_regs_list[] = {
 	}
 
 /* List of lists */
-static struct __guc_mmio_reg_descr_group default_lists[] = {
+static const struct __guc_mmio_reg_descr_group default_lists[] = {
 	MAKE_REGLIST(default_global_regs, PF, GLOBAL, 0),
 	MAKE_REGLIST(default_rc_class_regs, PF, ENGINE_CLASS, GUC_RENDER_CLASS),
 	MAKE_REGLIST(xe_lpd_rc_inst_regs, PF, ENGINE_INSTANCE, GUC_RENDER_CLASS),
-- 
2.35.1



