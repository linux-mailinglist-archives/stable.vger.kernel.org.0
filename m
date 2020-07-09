Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A69C219C38
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 11:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgGIJ3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 05:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbgGIJ3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 05:29:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C90E7206A1;
        Thu,  9 Jul 2020 09:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594286953;
        bh=6JPhqvwurWMZpsL8nt8K66+xH3XEx7ECW0r9t+2nFxE=;
        h=From:To:Cc:Subject:Date:From;
        b=1Bjpv0C/n63kAQtBdzaty7KMpw9Kb7aIxoaXDD535i7SRy2zOSnfdi6daMD7XAO4O
         nzJG4RiEI3FdEGalFvwGirpmWJ6dbcGR1YPmV3NLZmW+AtuSmcHAVhvPWI/ERfowEt
         0QG26zwmjHe6OnNFeDvzrc6dzeyts8tEd8VubSCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.51
Date:   Thu,  9 Jul 2020 11:29:10 +0200
Message-Id: <15942869501043@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.51 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/mips/kernel/traps.c                                |    1 
 arch/mips/lantiq/xway/sysctrl.c                         |    8 
 arch/s390/kernel/debug.c                                |    3 
 arch/x86/kernel/cpu/resctrl/core.c                      |    2 
 arch/x86/kernel/cpu/resctrl/internal.h                  |    3 
 arch/x86/kernel/cpu/resctrl/monitor.c                   |    3 
 crypto/af_alg.c                                         |   26 +--
 crypto/algif_aead.c                                     |    9 -
 crypto/algif_hash.c                                     |    9 -
 crypto/algif_skcipher.c                                 |    9 -
 drivers/block/virtio_blk.c                              |    1 
 drivers/char/tpm/tpm-dev-common.c                       |   19 +-
 drivers/dma-buf/dma-buf.c                               |   54 +++---
 drivers/edac/amd64_edac.c                               |    2 
 drivers/firmware/efi/Kconfig                            |   11 +
 drivers/firmware/efi/efi.c                              |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c        |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c                  |    4 
 drivers/gpu/drm/amd/display/dc/core/dc.c                |   10 -
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c             |    2 
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c                  |    5 
 drivers/hwmon/acpi_power_meter.c                        |    4 
 drivers/hwmon/max6697.c                                 |    7 
 drivers/i2c/algos/i2c-algo-pca.c                        |    3 
 drivers/i2c/busses/i2c-mlxcpld.c                        |    4 
 drivers/infiniband/core/counters.c                      |    4 
 drivers/irqchip/irq-gic.c                               |   14 -
 drivers/md/dm-zoned-target.c                            |    2 
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c          |    6 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c       |   25 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c         |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c    |   30 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c       |   18 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h |  122 +++++++++-----
 drivers/net/ethernet/chelsio/cxgb4/sge.c                |    2 
 drivers/net/usb/smsc95xx.c                              |    2 
 drivers/nvme/host/core.c                                |   12 +
 drivers/nvme/host/multipath.c                           |   45 ++++-
 drivers/nvme/host/nvme.h                                |    2 
 drivers/spi/spi-fsl-dspi.c                              |   17 +-
 drivers/thermal/mtk_thermal.c                           |    5 
 drivers/thermal/rcar_gen3_thermal.c                     |    2 
 drivers/usb/misc/usbtest.c                              |    1 
 fs/cifs/connect.c                                       |   10 -
 fs/cifs/inode.c                                         |   10 -
 fs/io_uring.c                                           |   63 +++++++
 fs/nfsd/nfs4state.c                                     |    8 
 fs/nfsd/nfsctl.c                                        |   23 +-
 fs/nfsd/nfsd.h                                          |    3 
 fs/nfsd/vfs.c                                           |    6 
 include/crypto/if_alg.h                                 |    4 
 kernel/debug/debug_core.c                               |    4 
 kernel/sched/debug.c                                    |    2 
 mm/compaction.c                                         |   19 +-
 mm/slub.c                                               |   30 +++
 mm/swap_state.c                                         |    4 
 net/rxrpc/call_event.c                                  |   29 +--
 samples/vfs/test-statx.c                                |    2 
 sound/usb/card.h                                        |    4 
 sound/usb/endpoint.c                                    |   43 -----
 sound/usb/endpoint.h                                    |    1 
 sound/usb/pcm.c                                         |    2 
 tools/lib/traceevent/event-parse.c                      |  133 +++++++++-------
 tools/testing/selftests/tpm2/test_smoke.sh              |    2 
 tools/testing/selftests/tpm2/test_space.sh              |    2 
 66 files changed, 559 insertions(+), 360 deletions(-)

Alex Deucher (2):
      drm/amdgpu: use %u rather than %d for sclk/mclk
      drm/amdgpu/atomfirmware: fix vram_info fetching for renoir

Anton Eidelman (2):
      nvme-multipath: fix deadlock between ana_work and scan_work
      nvme-multipath: fix deadlock due to head->lock

Babu Moger (1):
      x86/resctrl: Fix memory bandwidth counter width for AMD

Borislav Petkov (1):
      EDAC/amd64: Read back the scrub rate PCI register on F15h

Chen Tao (1):
      drm/msm/dpu: fix error return code in dpu_encoder_init

Chen-Yu Tsai (1):
      drm: sun4i: hdmi: Remove extra HPD polling

Chris Packham (1):
      i2c: algo-pca: Add 0x78 as SCL stuck low status for PCA9665

Christian Borntraeger (1):
      s390/debug: avoid kernel warning on too large number of pages

Christoph Hellwig (1):
      nvme: fix a crash in nvme_mpath_add_disk

Chu Lin (1):
      hwmon: (max6697) Make sure the OVERT mask is set correctly

David Howells (2):
      rxrpc: Fix race between incoming ACK parser and retransmitter
      rxrpc: Fix afs large storage transmission performance drop

Dien Pham (1):
      thermal/drivers/rcar_gen3: Fix undefined temperature if negative

Dongli Zhang (1):
      mm/slub.c: fix corrupted freechain in deactivate_slab()

Douglas Anderson (1):
      kgdb: Avoid suspicious RCU usage warning

Greg Kroah-Hartman (2):
      Revert "ALSA: usb-audio: Improve frames size computation"
      Linux 5.4.51

Hauke Mehrtens (1):
      MIPS: Add missing EHB in mtc0 -> mfc0 sequence for DSPen

Herbert Xu (1):
      crypto: af_alg - fix use-after-free in af_alg_accept() due to bh_lock_sock()

Hou Tao (2):
      virtio-blk: free vblk-vqs in error path of virtblk_probe()
      dm zoned: assign max_io_len correctly

Hugh Dickins (1):
      mm: fix swap cache node allocation mask

J. Bruce Fields (3):
      nfsd4: fix nfsdfs reference count loop
      nfsd: fix nfsdfs inode reference count leak
      nfsd: apply umask on fs without ACL support

James Bottomley (1):
      tpm: Fix TIS locality timeout problems

Jarkko Sakkinen (1):
      selftests: tpm: Use /bin/sh instead of /bin/bash

Jens Axboe (1):
      io_uring: make sure async workqueue is canceled on exit

Kees Cook (1):
      samples/vfs: avoid warning in statx override

Keith Busch (1):
      nvme-multipath: set bdi capabilities once

Krzysztof Kozlowski (1):
      spi: spi-fsl-dspi: Fix external abort on interrupt in resume or exit paths

Marc Zyngier (1):
      irqchip/gic: Atomically update affinity

Mark Zhang (1):
      RDMA/counter: Query a counter before release

Martin Blumenstingl (1):
      MIPS: lantiq: xway: sysctrl: fix the GPHY clock alias names

Michael Kao (1):
      thermal/drivers/mediatek: Fix bank number settings on mt8183

Misono Tomohiro (1):
      hwmon: (acpi_power_meter) Fix potential memory leak in acpi_power_meter_add()

Nicholas Kazlauskas (1):
      drm/amd/display: Only revalidate bandwidth on medium and fast updates

Paul Aurich (5):
      SMB3: Honor 'posix' flag for multiuser mounts
      SMB3: Honor 'seal' flag for multiuser mounts
      SMB3: Honor persistent/resilient handle flags for multiuser mounts
      SMB3: Honor lease disabling for multiuser mounts
      SMB3: Honor 'handletimeout' flag for multiuser mounts

Peter Jones (1):
      efi: Make it possible to disable efivar_ssdt entirely

Qian Cai (1):
      mm/slub: fix stack overruns with SLUB_STATS

Rahul Lakkireddy (5):
      cxgb4: use unaligned conversion for fetching timestamp
      cxgb4: parse TC-U32 key values and masks natively
      cxgb4: fix endian conversions for L4 ports in filters
      cxgb4: use correct type for all-mask IP address comparison
      cxgb4: fix SGE queue dump destination buffer context

Sagi Grimberg (2):
      nvme-multipath: fix bogus request queue reference put
      nvme: fix identify error status silent ignore

Steven Rostedt (VMware) (2):
      tools lib traceevent: Add append() function helper for appending strings
      tools lib traceevent: Handle __attribute__((user)) in field names

Sumit Semwal (1):
      dma-buf: Move dma_buf_release() from fops to dentry_ops

Tuomas Tynkkynen (1):
      usbnet: smsc95xx: Fix use-after-free after removal

Valentin Schneider (1):
      sched/debug: Make sd->flags sysctl read-only

Vlastimil Babka (2):
      mm, compaction: fully assume capture is not NULL in compact_zone_order()
      mm, compaction: make capture control handling safe wrt interrupts

Wolfram Sang (1):
      i2c: mlxcpld: check correct size of maximum RECV_LEN packet

Zhang Xiaoxu (1):
      cifs: Fix the target file was deleted when rename failed.

Zqiang (1):
      usb: usbtest: fix missing kfree(dev->buf) in usbtest_disconnect

