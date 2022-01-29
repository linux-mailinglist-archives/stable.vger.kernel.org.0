Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD814A2DEC
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 11:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbiA2K7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 05:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbiA2K7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 05:59:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E9FC061714;
        Sat, 29 Jan 2022 02:59:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9A92B8235B;
        Sat, 29 Jan 2022 10:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D78C340E5;
        Sat, 29 Jan 2022 10:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643453979;
        bh=3hT9dEjpoiCVhFfxNUnMVQFqHRvNgivPrRWpmcfbJo0=;
        h=From:To:Cc:Subject:Date:From;
        b=Vr4lkCldM35XQ4pitVjZypFCrWALkIz5MwykPgq1Ng/v46VOEz5+nHazOwe00XASi
         sV0FDxOHKbZz88Y9YeiQbnYTXijrT+fxc8MXm/G8goqh/IRppR9I6g5GX0XqU5ow/F
         xP+firH79ye/0CSt7XoHc97KgMO4MR/ta0O1FzDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.264
Date:   Sat, 29 Jan 2022 11:59:29 +0100
Message-Id: <1643453970118134@kroah.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.264 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 
 drivers/gpu/drm/i915/i915_drv.h         |    2 
 drivers/gpu/drm/i915/i915_gem.c         |   84 +++++++++++++++++++++++++++++++-
 drivers/gpu/drm/i915/i915_gem_object.h  |    1 
 drivers/gpu/drm/i915/i915_reg.h         |    6 ++
 drivers/gpu/drm/i915/i915_vma.c         |    4 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h     |    5 -
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |   34 ++++++------
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c   |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c     |    2 
 net/can/bcm.c                           |   20 +++----
 11 files changed, 128 insertions(+), 34 deletions(-)

Greg Kroah-Hartman (1):
      Linux 4.14.264

Mathias Krause (1):
      drm/vmwgfx: Fix stale file descriptors on failed usercopy

Tvrtko Ursulin (1):
      drm/i915: Flush TLBs before releasing backing store

Ziyang Xuan (1):
      can: bcm: fix UAF of bcm op

