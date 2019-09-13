Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B06EFB205B
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390696AbfIMNVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390714AbfIMNVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:21:01 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF22920CC7;
        Fri, 13 Sep 2019 13:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380860;
        bh=ww+gVDIXtSAvjhRKsGbFxasDZ5cA5jpz7i8WP2lR2w0=;
        h=From:To:Cc:Subject:Date:From;
        b=rY3NQZWR5N4w8YY6m+scbo27NHY01wKHMDjnSuAq0YL9deYVVN3ZSE1rz0LlEEXQb
         i2Uvfd8dmdNcVKS8Da4HgNYM2GRKNwV8z1aIBnU1MHwflcHamCpFwVqvtDpcnLngB+
         fLP/CSZryW2ZvppJjuH46WIDTXle0GcUf4uBO368=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.2 00/37] 5.2.15-stable review
Date:   Fri, 13 Sep 2019 14:07:05 +0100
Message-Id: <20190913130510.727515099@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.15-rc1
X-KernelTest-Deadline: 2019-09-15T13:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.2.15 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.15-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.2.15-rc1

yongduan <yongduan@tencent.com>
    vhost: make sure log_num < in_num

Michael S. Tsirkin <mst@redhat.com>
    vhost: block speculation of translated descriptors

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix unwritten extent buffers and hangs on future writeback attempts

Lionel Landwerlin <lionel.g.landwerlin@intel.com>
    drm/i915/icl: whitelist PS_(DEPTH|INVOCATION)_COUNT

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Add whitelist workarounds for ICL

Lionel Landwerlin <lionel.g.landwerlin@intel.com>
    drm/i915: whitelist PS_(DEPTH|INVOCATION)_COUNT

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Support whitelist workarounds on all engines

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Support flags in whitlist WAs

Halil Pasic <pasic@linux.ibm.com>
    virtio/s390: fix race on airq_areas[]

André Draszik <git@andred.net>
    usb: chipidea: imx: fix EPROBE_DEFER support during driver probe

Peter Chen <peter.chen@nxp.com>
    usb: chipidea: imx: add imx7ulp support

Baolin Wang <baolin.wang@linaro.org>
    mmc: sdhci-sprd: Fix the incorrect soft reset operation when runtime resuming

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Make sure cdclk is high enough for DP audio on VLV/CHV

Kenneth Graunke <kenneth@whitecape.org>
    drm/i915: Disable SAMPLER_STATE prefetching on all Gen11 steppings.

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Unreserve a flushed OPFN request

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/{rdmavt, qib, hfi1}: Convert to new completion API

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/rdmavt: Add new completion inline

Coly Li <colyli@suse.de>
    bcache: fix race in btree_flush_write()

Coly Li <colyli@suse.de>
    bcache: add comments for mutex_lock(&b->write_lock)

Coly Li <colyli@suse.de>
    bcache: only clear BTREE_NODE_dirty bit when it is set

Sven Eckelmann <sven@narfation.org>
    batman-adv: Only read OGM tvlv_len after buffer len check

Eric Dumazet <edumazet@google.com>
    batman-adv: fix uninit-value in batadv_netlink_get_ifindex()

Gustavo Romero <gromero@linux.ibm.com>
    powerpc/tm: Fix restoring FP/VMX facility incorrectly on interrupts

Gustavo Romero <gromero@linux.ibm.com>
    powerpc/tm: Fix FP/VMX unavailable exceptions inside a transaction

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/64e: Drop stale call to smp_processor_id() which hangs SMP startup

Tiwei Bie <tiwei.bie@intel.com>
    vhost/test: fix build for vhost test - again

Tiwei Bie <tiwei.bie@intel.com>
    vhost/test: fix build for vhost test

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/sec2/gp102: add missing MODULE_FIRMWAREs

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vmwgfx: Fix double free in vmw_recv_msg()

Liangyan <liangyan.peng@linux.alibaba.com>
    sched/fair: Don't assign runtime for throttled cfs_rq

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - Fix the problem of two front mics on a ThinkCentre

Jian-Hong Pan <jian-hong@endlessm.com>
    ALSA: hda/realtek - Enable internal speaker & headset mic of ASUS UX431FL

Sam Bazley <sambazley@fastmail.com>
    ALSA: hda/realtek - Add quirk for HP Pavilion 15

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Fix overridden device-specific initialization

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix potential endless loop at applying quirks

David Jander <david@protonic.nl>
    gpio: pca953x: use pca953x_read_regs instead of regmap_bulk_read

David Jander <david@protonic.nl>
    gpio: pca953x: correct type of reg_direction


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/powerpc/kernel/process.c                      |  21 +---
 arch/powerpc/mm/nohash/tlb.c                       |   1 -
 drivers/gpio/gpio-pca953x.c                        |  15 +--
 drivers/gpu/drm/i915/i915_reg.h                    |   7 ++
 drivers/gpu/drm/i915/intel_cdclk.c                 |  11 ++
 drivers/gpu/drm/i915/intel_workarounds.c           | 136 +++++++++++++++++----
 .../gpu/drm/nouveau/nvkm/subdev/secboot/gp102.c    |  12 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                |   8 +-
 drivers/infiniband/hw/hfi1/rc.c                    |  28 +----
 drivers/infiniband/hw/qib/qib_rc.c                 |  26 +---
 drivers/infiniband/sw/rdmavt/qp.c                  |  31 ++---
 drivers/md/bcache/btree.c                          |  49 +++++++-
 drivers/md/bcache/btree.h                          |   2 +
 drivers/md/bcache/journal.c                        |   7 ++
 drivers/mmc/host/sdhci-acpi.c                      |   2 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   2 +-
 drivers/mmc/host/sdhci-of-at91.c                   |   2 +-
 drivers/mmc/host/sdhci-pci-core.c                  |   4 +-
 drivers/mmc/host/sdhci-pxav3.c                     |   2 +-
 drivers/mmc/host/sdhci-s3c.c                       |   2 +-
 drivers/mmc/host/sdhci-sprd.c                      |   2 +-
 drivers/mmc/host/sdhci-xenon.c                     |   2 +-
 drivers/mmc/host/sdhci.c                           |   4 +-
 drivers/mmc/host/sdhci.h                           |   2 +-
 drivers/s390/virtio/virtio_ccw.c                   |   3 +
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  43 ++++++-
 drivers/usb/chipidea/usbmisc_imx.c                 |   4 +
 drivers/vhost/test.c                               |  13 +-
 drivers/vhost/vhost.c                              |  10 +-
 fs/btrfs/extent_io.c                               |  35 ++++--
 include/linux/usb/chipidea.h                       |   1 +
 include/rdma/rdmavt_qp.h                           | 117 +++++++++++-------
 kernel/sched/fair.c                                |   5 +
 net/batman-adv/bat_iv_ogm.c                        |  20 +--
 net/batman-adv/netlink.c                           |   2 +-
 sound/pci/hda/hda_auto_parser.c                    |   4 +-
 sound/pci/hda/hda_generic.c                        |   3 +-
 sound/pci/hda/hda_generic.h                        |   1 +
 sound/pci/hda/patch_realtek.c                      |  17 +++
 40 files changed, 439 insertions(+), 221 deletions(-)


