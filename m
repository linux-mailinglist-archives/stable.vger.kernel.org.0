Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A84168119F
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237329AbjA3OPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237336AbjA3OPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:15:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8DE18A9F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:15:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ACAA61047
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FFAC433EF;
        Mon, 30 Jan 2023 14:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088116;
        bh=RXNmd/dgWjvRq0zz7xmzDRzW+wE2hOYWXcVsO/eLZ+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1KxrVIA3o0s9mJs85psGUMQf02vc5sSawV6kP5+kSPmuNOXSa//B+P6Mo2eunvLU
         nkmxm5OD+tRa2V4envTfC2BPkd4SBehgI8H9EKBmj6eXETM4kY4Ue00wQLJRFkT0f7
         Mk3EDR8/n2VWglrh4sG4GbaupWb3pXPUnvic4ABs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nirmoy Das <nirmoy.das@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 120/204] drm/i915: Remove unused variable
Date:   Mon, 30 Jan 2023 14:51:25 +0100
Message-Id: <20230130134321.765091723@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@intel.com>

commit 2293a73ad4f3b6c37c06713ff1b67659d92ef43d upstream.

Removed unused i915 var.

Fixes: a273e95721e9 ("drm/i915: Allow switching away via vga-switcheroo if uninitialized")
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230118170624.9326-1-nirmoy.das@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_drv.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -986,8 +986,6 @@ static int i915_driver_open(struct drm_d
  */
 static void i915_driver_lastclose(struct drm_device *dev)
 {
-	struct drm_i915_private *i915 = to_i915(dev);
-
 	intel_fbdev_restore_mode(dev);
 
 	vga_switcheroo_process_delayed_switch();


