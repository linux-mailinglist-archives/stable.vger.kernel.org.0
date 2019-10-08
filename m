Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5949ECF2CB
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 08:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbfJHGgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 02:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729926AbfJHGgJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 02:36:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B343206BB;
        Tue,  8 Oct 2019 06:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570516568;
        bh=T1gFaXj1//+OP7ypK7kF8WOVyYEPjGR3J8LIHYtpu+U=;
        h=Date:From:To:Cc:Subject:From;
        b=A2cJ7SwAElJfk/afh3Q+CFVbPYdHLZmBLD6+WtzcOt0CHi6FR54z8SQEnIZB2roS6
         bH+yt3FiIE35GkR0rzpLeexVl2XvjBVOTbVz2k7MiezjssrWUQFinj6qJxsOZmNQcM
         iopMiE/ZQrRE6wDOuz1GUqIZRY4potwcZp+KVB9c=
Date:   Tue, 8 Oct 2019 08:36:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.196
Message-ID: <20191008063605.GA2466809@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.196 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 -
 arch/arm/mm/fault.c                        |    4 +-
 arch/arm/mm/fault.h                        |    1 
 arch/powerpc/include/asm/futex.h           |    3 -
 arch/powerpc/kernel/exceptions-64s.S       |    4 ++
 arch/powerpc/kernel/rtas.c                 |   11 ++++--
 arch/powerpc/platforms/pseries/mobility.c  |    9 +++++
 arch/powerpc/platforms/pseries/setup.c     |    3 +
 arch/s390/hypfs/inode.c                    |    9 ++---
 drivers/android/binder.c                   |   26 ++++++++++++++-
 drivers/char/ipmi/ipmi_si_intf.c           |   24 +++++++++++---
 drivers/clk/clk-qoriq.c                    |    2 -
 drivers/clk/sirf/clk-common.c              |   12 ++++---
 drivers/gpu/drm/radeon/radeon_connectors.c |    2 -
 drivers/hid/hid-apple.c                    |   49 ++++++++++++++++-------------
 drivers/mfd/intel-lpss-pci.c               |    2 +
 drivers/net/ethernet/qlogic/qla3xxx.c      |    1 
 drivers/net/usb/hso.c                      |   12 ++++---
 drivers/net/xen-netfront.c                 |   17 +++++-----
 drivers/pinctrl/pinctrl-tegra.c            |    4 +-
 drivers/scsi/scsi_logging.c                |   48 +---------------------------
 drivers/vfio/pci/vfio_pci.c                |   17 +++++++---
 drivers/video/fbdev/ssd1307fb.c            |    2 -
 fs/fat/dir.c                               |   13 ++++++-
 fs/fat/fatent.c                            |    3 +
 fs/ocfs2/dlm/dlmunlock.c                   |   23 +++++++++++--
 include/scsi/scsi_dbg.h                    |    2 -
 lib/Kconfig.debug                          |    2 -
 net/ipv4/route.c                           |    5 +-
 net/ipv6/ip6_input.c                       |   10 +++++
 net/nfc/llcp_sock.c                        |    7 +++-
 net/nfc/netlink.c                          |    6 ++-
 net/rds/ib.c                               |    6 +--
 net/sched/sch_cbq.c                        |   27 +++++++++++++--
 net/sched/sch_dsmark.c                     |    2 +
 security/smack/smack_access.c              |    4 +-
 security/smack/smack_lsm.c                 |    7 ++--
 37 files changed, 246 insertions(+), 135 deletions(-)

Andrey Konovalov (1):
      NFC: fix attrs checks in netlink interface

Bart Van Assche (1):
      scsi: core: Reduce memory required for SCSI logging

Changwei Ge (1):
      ocfs2: wait for recovering done after direct unlock request

Christophe Leroy (1):
      powerpc/futex: Fix warning: 'oldval' may be used uninitialized in this function

Corey Minyard (1):
      ipmi_si: Only schedule continuously in the thread in maintenance mode

David Howells (1):
      hypfs: Fix error number left in struct pointer member

Dongli Zhang (1):
      xen-netfront: do not use ~0U as error return value for xennet_fill_frags()

Dotan Barak (1):
      net/rds: Fix error handling in rds_ib_add_one()

Eric Biggers (1):
      smack: use GFP_NOFS while holding inode_smack::smk_lock

Eric Dumazet (4):
      ipv6: drop incoming packets having a v4mapped source address
      nfc: fix memory leak in llcp_sock_bind()
      sch_dsmark: fix potential NULL deref in dsmark_init()
      sch_cbq: validate TCA_CBQ_WRROPT to avoid crash

Greg Kroah-Hartman (1):
      Linux 4.4.196

Jann Horn (1):
      Smack: Don't ignore other bprm->unsafe flags if LSM_UNSAFE_PTRACE is set

Jia-Ju Bai (2):
      gpu: drm: radeon: Fix a possible null-pointer dereference in radeon_connector_set_property()
      security: smack: Fix possible null-pointer dereferences in smack_socket_sock_rcv_skb()

Joao Moreno (1):
      HID: apple: Fix stuck function keys when using FN

Johan Hovold (1):
      hso: fix NULL-deref on tty open

Kai-Heng Feng (1):
      mfd: intel-lpss: Remove D3cold delay

Marko Kohtala (1):
      video: ssd1307fb: Start page range at page_offset

Martijn Coenen (2):
      ANDROID: binder: remove waitqueue when thread exits.
      ANDROID: binder: synchronize_rcu() when using POLLFREE.

Nathan Huckleberry (1):
      clk: qoriq: Fix -Wunused-const-variable

Nathan Lynch (3):
      powerpc/rtas: use device model APIs and serialization during LPM
      powerpc/pseries/mobility: use cond_resched when updating device tree
      powerpc/pseries: correctly track irq state in default idle

Navid Emamdoost (1):
      net: qlogic: Fix memory leak in ql_alloc_large_buffers

Nicholas Piggin (1):
      powerpc/64s/exception: machine check use correct cfar for late handler

Nicolas Boichat (1):
      kmemleak: increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE default to 16K

OGAWA Hirofumi (1):
      fat: work around race with userspace's read via blockdev while mounting

Paolo Abeni (1):
      net: ipv4: avoid mixed n_redirects and rate_tokens usage

Sowjanya Komatineni (1):
      pinctrl: tegra: Fix write barrier placement in pmx_writel

Stephen Boyd (1):
      clk: sirf: Don't reference clk_init_data after registration

Will Deacon (1):
      ARM: 8898/1: mm: Don't treat faults reported from cache maintenance as writes

hexin (1):
      vfio_pci: Restore original state on release

