Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7B9676FE4
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbjAVP0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbjAVP0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:26:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5408022DC6
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:26:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E64D160C64
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DC1C433D2;
        Sun, 22 Jan 2023 15:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401177;
        bh=GV/0RIRLDbQ/69NyJGkV82zD13L1sZ5jj8r3Iflp25M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+9+1fNpop0atdeXfFBcmDflpZyg3Sqj1CugFlds1SPjmpUAvTkI9f2uldV/0G078
         yN00dg+LW8jpKdMpes3kcMvUsSXneDCMe3Nz1e9/amZiAbXx+6oGLfuEyf5F4Z2Ma6
         8tv8C0yHPn7Qf7Uyw2uziaFRH9MO6qaa83N9Jyl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nirmoy Das <nirmoy.das@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 140/193] drm/i915: Remove unused variable
Date:   Sun, 22 Jan 2023 16:04:29 +0100
Message-Id: <20230122150252.781318746@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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
 drivers/gpu/drm/i915/i915_driver.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_driver.c
+++ b/drivers/gpu/drm/i915/i915_driver.c
@@ -1070,8 +1070,6 @@ static int i915_driver_open(struct drm_d
  */
 static void i915_driver_lastclose(struct drm_device *dev)
 {
-	struct drm_i915_private *i915 = to_i915(dev);
-
 	intel_fbdev_restore_mode(dev);
 
 	vga_switcheroo_process_delayed_switch();


