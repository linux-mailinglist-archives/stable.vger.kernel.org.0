Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8EA4A2DF1
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 11:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbiA2K74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 05:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbiA2K7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 05:59:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA21C061748;
        Sat, 29 Jan 2022 02:59:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7268960B26;
        Sat, 29 Jan 2022 10:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAB9C340E5;
        Sat, 29 Jan 2022 10:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643453989;
        bh=tFVoiyhq7ldNYvQpGZ/SLds2BVEAwWTkvFKiY/1MReg=;
        h=From:To:Cc:Subject:Date:From;
        b=dCSqw/F4p15bwYMWmTIgDYeZAibxbz1hwDU4qnivyuBR8K6ffb47YNFlDeHF47Bcy
         LpDUcZHF29txydTpXCZDvWsIRCNu3esNCH2AfxS3etJJutVFQdPRvGLBB4bbfQaYM+
         KM+Tvs3XqQNKGhhmYu/nNpDpHwaOgrrpYuqx/RRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.227
Date:   Sat, 29 Jan 2022 11:59:34 +0100
Message-Id: <164345397562207@kroah.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.227 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 
 drivers/gpu/drm/i915/i915_drv.h         |    2 
 drivers/gpu/drm/i915/i915_gem.c         |   83 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_gem_object.h  |    1 
 drivers/gpu/drm/i915/i915_reg.h         |    6 ++
 drivers/gpu/drm/i915/i915_vma.c         |    4 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h     |    5 -
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |   34 ++++++-------
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c   |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c     |    2 
 fs/select.c                             |   63 ++++++++++++------------
 net/bridge/br_device.c                  |    2 
 12 files changed, 153 insertions(+), 53 deletions(-)

Greg Kroah-Hartman (1):
      Linux 4.19.227

Jan Kara (1):
      select: Fix indefinitely sleeping task in poll_schedule_timeout()

Mathias Krause (1):
      drm/vmwgfx: Fix stale file descriptors on failed usercopy

Nikolay Aleksandrov (1):
      net: bridge: clear bridge's private skb space on xmit

Tvrtko Ursulin (1):
      drm/i915: Flush TLBs before releasing backing store

