Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E584A2DF2
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 11:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236712AbiA2K75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 05:59:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52872 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235573AbiA2K7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 05:59:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CCE4B82770;
        Sat, 29 Jan 2022 10:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFDBC340E5;
        Sat, 29 Jan 2022 10:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643453993;
        bh=2acsqUS72WcvPlvZlcHgoMKaeasqnbhldLmjqFxlge0=;
        h=From:To:Cc:Subject:Date:From;
        b=1DeDHlRd6TXl41c1WnwKD2i1DxbpIck2yx4YoGIPIrX6sbBhwWXcQFK4ugJaPzBeb
         eu7YIyb6aOBmlLk+I+jEexMXGFkni6R9zlaV/WmeSX2fcXTRJyTQ9r1EwdepUIT2re
         XICUNPpFRGzQx68zSA9TPyBoxBPWy/hyazQ55BXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.175
Date:   Sat, 29 Jan 2022 11:59:39 +0100
Message-Id: <16434539792375@kroah.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.175 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 
 arch/arm/boot/dts/bcm283x.dtsi                   |    1 
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h |    3 
 drivers/gpu/drm/i915/gem/i915_gem_pages.c        |   10 +
 drivers/gpu/drm/i915/gt/intel_gt.c               |   99 ++++++++++
 drivers/gpu/drm/i915/gt/intel_gt.h               |    2 
 drivers/gpu/drm/i915/gt/intel_gt_types.h         |    2 
 drivers/gpu/drm/i915/i915_reg.h                  |   11 +
 drivers/gpu/drm/i915/i915_vma.c                  |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h              |    5 
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c          |   33 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c            |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c              |    2 
 drivers/mmc/host/sdhci-esdhc-imx.c               |    3 
 drivers/pinctrl/bcm/pinctrl-bcm2835.c            |  209 +++++++++++++++++++----
 fs/select.c                                      |   63 +++---
 kernel/rcu/tree.c                                |    7 
 17 files changed, 366 insertions(+), 92 deletions(-)

Florian Fainelli (2):
      pinctrl: bcm2835: Match BCM7211 compatible string
      pinctrl: bcm2835: Add support for wake-up interrupts

Greg Kroah-Hartman (1):
      Linux 5.4.175

Jan Kara (1):
      select: Fix indefinitely sleeping task in poll_schedule_timeout()

Mathias Krause (1):
      drm/vmwgfx: Fix stale file descriptors on failed usercopy

Paul E. McKenney (1):
      rcu: Tighten rcu_advance_cbs_nowake() checks

Phil Elwell (2):
      pinctrl: bcm2835: Change init order for gpio hogs
      ARM: dts: gpio-ranges property is now required

Stefan Wahren (3):
      pinctrl: bcm2835: Drop unused define
      pinctrl: bcm2835: Refactor platform data
      pinctrl: bcm2835: Add support for all GPIOs on BCM2711

Tim Harvey (1):
      mmc: sdhci-esdhc-imx: disable CMDQ support

Tvrtko Ursulin (1):
      drm/i915: Flush TLBs before releasing backing store

