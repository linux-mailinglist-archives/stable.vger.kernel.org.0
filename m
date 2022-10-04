Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9FE5F454A
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 16:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiJDOTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 10:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiJDOTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 10:19:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AC76112A;
        Tue,  4 Oct 2022 07:19:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C3D56148B;
        Tue,  4 Oct 2022 14:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4463DC433D6;
        Tue,  4 Oct 2022 14:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664893141;
        bh=4b/8k++vVGGnVZHtWimknHqUFckZ0kIt4xJhhyFNO9Y=;
        h=From:To:Cc:Subject:Date:From;
        b=2q1gQriRFj8r3avOL/xhQEWMhD/LD4ltFyoFJVoeiq3Qe30alWDny+Eci103fpVfB
         uLUJjZdXhifBFmGwKHabNoDc7YwuxoTBTqDUL2f+XSPhhgyxjTBg2Htxf05X1Zr//q
         y7BWkZfrYAZqTTPBxkHiI/W4L2zPGBliYl6MgS/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.19.13
Date:   Tue,  4 Oct 2022 16:18:54 +0200
Message-Id: <16648930732832@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.19.13 kernel.

This release is to resolve a regression on some Intel graphics systems that had
problems with 5.19.12.  If you do not have this problem with 5.19.12, there is
no need to upgrade.

The updated 5.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                               |    2 
 drivers/gpu/drm/i915/display/g4x_dp.c                  |   22 
 drivers/gpu/drm/i915/display/icl_dsi.c                 |   18 
 drivers/gpu/drm/i915/display/intel_backlight.c         |   23 -
 drivers/gpu/drm/i915/display/intel_bios.c              |  384 +++++++----------
 drivers/gpu/drm/i915/display/intel_bios.h              |    4 
 drivers/gpu/drm/i915/display/intel_ddi.c               |   22 
 drivers/gpu/drm/i915/display/intel_ddi_buf_trans.c     |    9 
 drivers/gpu/drm/i915/display/intel_display_types.h     |   69 ---
 drivers/gpu/drm/i915/display/intel_dp.c                |   40 -
 drivers/gpu/drm/i915/display/intel_dp.h                |    2 
 drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c  |    6 
 drivers/gpu/drm/i915/display/intel_drrs.c              |    3 
 drivers/gpu/drm/i915/display/intel_dsi.c               |    2 
 drivers/gpu/drm/i915/display/intel_dsi_dcs_backlight.c |    9 
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c           |   56 +-
 drivers/gpu/drm/i915/display/intel_lvds.c              |    6 
 drivers/gpu/drm/i915/display/intel_panel.c             |   13 
 drivers/gpu/drm/i915/display/intel_pps.c               |   70 ---
 drivers/gpu/drm/i915/display/intel_psr.c               |   35 -
 drivers/gpu/drm/i915/display/intel_sdvo.c              |    3 
 drivers/gpu/drm/i915/display/vlv_dsi.c                 |   21 
 drivers/gpu/drm/i915/i915_drv.h                        |   63 ++
 23 files changed, 385 insertions(+), 497 deletions(-)

Greg Kroah-Hartman (9):
      Revert "drm/i915/display: Fix handling of enable_psr parameter"
      Revert "drm/i915/dsi: fix dual-link DSI backlight and CABC ports for display 11+"
      Revert "drm/i915/dsi: filter invalid backlight and CABC ports"
      Revert "drm/i915/bios: Split VBT data into per-panel vs. global parts"
      Revert "drm/i915/bios: Split VBT parsing to global vs. panel specific parts"
      Revert "drm/i915/bios: Split parse_driver_features() into two parts"
      Revert "drm/i915/pps: Split pps_init_delays() into distinct parts"
      Revert "drm/i915: Extract intel_edp_fixup_vbt_bpp()"
      Linux 5.19.13

