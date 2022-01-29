Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3CF4A2DEA
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 11:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiA2K7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 05:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbiA2K7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 05:59:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3CFC061714;
        Sat, 29 Jan 2022 02:59:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28E0460B0F;
        Sat, 29 Jan 2022 10:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0666CC340E5;
        Sat, 29 Jan 2022 10:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643453976;
        bh=GWs6EVaDEMuZ3z9Skr6B2FA2WlWSMMZEocoJkiBuhTM=;
        h=From:To:Cc:Subject:Date:From;
        b=JfRcgK/lx0ljXPndksuwcD0egbDpks5zVfA/hM9LPvkH3ytZckf4sNoqDNQ+WHCq+
         bTfMV5KbULr1wYMmLqbu2249lGrgnOg3o8NbRTFZWkZnQHpAefXx4l0cTL6MoF8y9M
         pSSn4S2ZJubRpvchDYK8QjZBmMcuofrCF2ORFaJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.299
Date:   Sat, 29 Jan 2022 11:59:22 +0100
Message-Id: <1643453962188126@kroah.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.299 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/virtual/kvm/mmu.txt       |    4 -
 Makefile                                |    2 
 arch/arm/Kconfig.debug                  |   44 +++++++++-----
 arch/x86/kvm/paging_tmpl.h              |   44 +++++++++-----
 drivers/gpu/drm/i915/i915_drv.h         |    5 +
 drivers/gpu/drm/i915/i915_gem.c         |   72 ++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_gem_gtt.c     |    4 +
 drivers/gpu/drm/i915/i915_reg.h         |    6 ++
 drivers/media/firewire/firedtv-avc.c    |   14 +++-
 drivers/media/firewire/firedtv-ci.c     |    2 
 drivers/staging/android/ion/ion-ioctl.c |   96 ++++++++++++++++++++++++++++----
 drivers/staging/android/ion/ion.c       |   19 ++++--
 drivers/staging/android/ion/ion.h       |    4 +
 drivers/staging/android/ion/ion_priv.h  |    4 +
 fs/nfs/nfs4client.c                     |   82 ++++++++++++++-------------
 lib/Kconfig.debug                       |    6 +-
 16 files changed, 310 insertions(+), 98 deletions(-)

Dan Carpenter (1):
      media: firewire: firedtv-avc: fix a buffer overflow in avc_ca_pmt()

Daniel Rosenberg (2):
      ion: Fix use after free during ION_IOC_ALLOC
      ion: Protect kref from userspace manipulation

Greg Kroah-Hartman (1):
      Linux 4.9.299

Lai Jiangshan (1):
      KVM: X86: MMU: Use the correct inherited permissions to get shadow page

Lee Jones (1):
      ion: Do not 'put' ION handle until after its final use

Paolo Bonzini (1):
      KVM: nVMX: fix EPT permissions as reported in exit qualification

Stefan Agner (1):
      ARM: 8800/1: use choice for kernel unwinders

Trond Myklebust (1):
      NFSv4: Initialise connection to the server in nfs4_alloc_client()

Tvrtko Ursulin (1):
      drm/i915: Flush TLBs before releasing backing store

