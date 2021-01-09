Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E722F00CD
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 16:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbhAIP0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 10:26:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:57204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbhAIP0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Jan 2021 10:26:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D85C323A79;
        Sat,  9 Jan 2021 15:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610205938;
        bh=0wtbd9nE/lWNvXXFONU77ZCEv/zftyUgLNRYNYxM6g0=;
        h=From:To:Cc:Subject:Date:From;
        b=S/KxqGLr+4UTuo7Jg+pCtiJ3RCFYCCIc/mZrOrmzYyH98EcttL5T0mKfjCZnra5ls
         9ii7GtAJNVjqYAzW/o08RA24WfJ68+HasH7LPB+WNTyqeoWVNLzgQPaOjl9KXfLv/G
         Nf9mkFO7Fb0EpPGRMd7hOMS2wsjatMhVpvUXj0tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.6
Date:   Sat,  9 Jan 2021 16:26:50 +0100
Message-Id: <16102060105348@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.6 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/rtc/rtc.yaml    |    5 +
 Makefile                                          |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c     |   41 +++++++-----
 drivers/infiniband/core/device.c                  |   43 ++++++------
 drivers/infiniband/core/rw.c                      |    5 +
 drivers/infiniband/sw/rdmavt/Kconfig              |    1 
 drivers/infiniband/sw/rdmavt/mr.c                 |    6 -
 drivers/infiniband/sw/rdmavt/vt.c                 |    8 --
 drivers/infiniband/sw/rxe/Kconfig                 |    1 
 drivers/infiniband/sw/rxe/rxe_net.c               |   12 ---
 drivers/infiniband/sw/rxe/rxe_verbs.c             |    8 --
 drivers/infiniband/sw/rxe/rxe_verbs.h             |    1 
 drivers/infiniband/sw/siw/Kconfig                 |    1 
 drivers/infiniband/sw/siw/siw.h                   |    1 
 drivers/infiniband/sw/siw/siw_main.c              |   26 -------
 drivers/mtd/nand/spi/core.c                       |    4 -
 drivers/net/wireless/marvell/mwifiex/join.c       |    2 
 drivers/nvme/target/rdma.c                        |    3 
 drivers/rtc/rtc-pcf2127.c                         |   57 +++++++++--------
 drivers/scsi/ufs/ufs-mediatek.c                   |    4 -
 drivers/scsi/ufs/ufs-qcom.c                       |    6 +
 drivers/scsi/ufs/ufshcd.h                         |   16 +++-
 fs/exec.c                                         |   12 +--
 fs/fuse/acl.c                                     |    6 +
 fs/fuse/dir.c                                     |   37 +++++++++--
 fs/fuse/file.c                                    |   19 +++--
 fs/fuse/fuse_i.h                                  |   12 +++
 fs/fuse/inode.c                                   |    4 -
 fs/fuse/readdir.c                                 |    4 -
 fs/fuse/xattr.c                                   |    9 ++
 fs/proc/base.c                                    |   10 +--
 include/linux/kdev_t.h                            |   22 +++---
 include/linux/rwsem.h                             |    3 
 include/linux/sched/signal.h                      |   11 +--
 include/rdma/ib_verbs.h                           |   73 +++++++++++++++-------
 init/init_task.c                                  |    2 
 kernel/events/core.c                              |   52 +++++++--------
 kernel/fork.c                                     |    6 -
 kernel/kcmp.c                                     |   30 ++++-----
 kernel/locking/rwsem.c                            |   40 ++++++++++++
 kernel/pid.c                                      |    4 -
 net/bluetooth/hci_core.c                          |    2 
 sound/pci/hda/patch_hdmi.c                        |    2 
 sound/pci/hda/patch_realtek.c                     |    2 
 45 files changed, 362 insertions(+), 256 deletions(-)

Adrian Hunter (1):
      scsi: ufs: Allow an error return value from ->device_reset()

Alex Deucher (1):
      Revert "drm/amd/display: Fix memory leaks in S3 resume"

Christoph Hellwig (1):
      RDMA/core: remove use of dma_virt_ops

Edward Vear (1):
      Bluetooth: Fix attempting to set RPA timeout when unsupported

Eric W. Biederman (3):
      rwsem: Implement down_read_killable_nested
      rwsem: Implement down_read_interruptible
      exec: Transform exec_update_mutex into a rw_semaphore

Felix Fietkau (1):
      Revert "mtd: spinand: Fix OOB read"

Greg Kroah-Hartman (1):
      Linux 5.10.6

Imre Deak (1):
      drm/i915/tgl: Fix Combo PHY DPLL fractional divider for 38.4MHz ref clock

Jason Gunthorpe (1):
      RDMA/siw,rxe: Make emulated devices virtual in the device tree

Josh Poimboeuf (1):
      kdev_t: always inline major/minor helper functions

Kailang Yang (1):
      ALSA: hda/realtek - Modify Dell platform name

Miklos Szeredi (1):
      fuse: fix bad inode

Rasmus Villemoes (1):
      dt-bindings: rtc: add reset-source property

Stanley Chu (1):
      scsi: ufs: Re-enable WriteBooster after device reset

Takashi Iwai (1):
      ALSA: hda/hdmi: Fix incorrect mutex unlock in silent_stream_disable()

Uwe Kleine-König (2):
      rtc: pcf2127: move watchdog initialisation to a separate function
      rtc: pcf2127: only use watchdog when explicitly available

Zhang Xiaohui (1):
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start

peterz@infradead.org (1):
      perf: Break deadlock involving exec_update_mutex

