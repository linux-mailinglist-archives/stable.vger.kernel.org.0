Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1E24788A9
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 11:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbhLQKVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 05:21:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43074 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbhLQKVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 05:21:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8648B82787;
        Fri, 17 Dec 2021 10:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA6AC36AE5;
        Fri, 17 Dec 2021 10:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639736474;
        bh=nddvfwNP6grdpmsXci0Z6sQwUQsqQFgKDS1QY5m2huo=;
        h=From:To:Cc:Subject:Date:From;
        b=ks9YqHzWLOSXPj5sU8Udy5QxQgxnA0eHZk8hR7Yef42JwRafCRAHpkwREYv24135c
         CM2a9pS7Zt7zRCf3h6cFC20Kc30EaIjNos14YLRLS+wgGZgUWK9I0u6MchnIe5wp98
         mMsGrmSyxUCPmUwhFFhmzaTMsb+QKon8CXPsHBFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.10
Date:   Fri, 17 Dec 2021 11:21:08 +0100
Message-Id: <16397364681642@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.10 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.yaml |   14 --
 Makefile                                                        |    2 
 arch/arm64/kvm/hyp/include/hyp/switch.h                         |    6 +
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h                      |    7 +
 arch/s390/lib/test_unwind.c                                     |    5 
 drivers/block/loop.c                                            |    2 
 drivers/char/agp/parisc-agp.c                                   |    6 -
 drivers/clk/qcom/gcc-sm6125.c                                   |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                |    8 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                      |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c                        |    4 
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c                            |    9 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c           |    8 +
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c               |    4 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                           |   18 +--
 drivers/gpu/drm/msm/dp/dp_aux.c                                 |   17 +++
 drivers/gpu/drm/msm/dsi/dsi_host.c                              |    2 
 drivers/gpu/drm/msm/msm_gem_submit.c                            |    1 
 drivers/hwmon/corsair-psu.c                                     |    2 
 drivers/i2c/busses/i2c-rk3x.c                                   |    4 
 drivers/i2c/busses/i2c-virtio.c                                 |   32 ++---
 drivers/infiniband/hw/irdma/hw.c                                |    7 +
 drivers/infiniband/hw/irdma/main.h                              |    1 
 drivers/infiniband/hw/irdma/pble.c                              |    8 -
 drivers/infiniband/hw/irdma/pble.h                              |    1 
 drivers/infiniband/hw/irdma/utils.c                             |   24 +++-
 drivers/infiniband/hw/irdma/verbs.c                             |   23 +++-
 drivers/infiniband/hw/irdma/verbs.h                             |    2 
 drivers/infiniband/hw/mlx5/mlx5_ib.h                            |    6 -
 drivers/infiniband/hw/mlx5/mr.c                                 |   26 ++--
 drivers/infiniband/sw/rxe/rxe_qp.c                              |    1 
 drivers/mtd/nand/raw/nand_base.c                                |    6 -
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c                |    2 
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                 |    6 -
 drivers/net/vmxnet3/vmxnet3_drv.c                               |   13 +-
 drivers/staging/most/dim2/dim2.c                                |   55 +++++-----
 drivers/tty/serial/fsl_lpuart.c                                 |    1 
 fs/fuse/dir.c                                                   |    8 +
 fs/fuse/file.c                                                  |   15 ++
 fs/fuse/fuse_i.h                                                |    1 
 fs/fuse/inode.c                                                 |    3 
 fs/netfs/read_helper.c                                          |   15 --
 kernel/trace/tracing_map.c                                      |    3 
 net/ipv4/inet_connection_sock.c                                 |    2 
 net/netlink/af_netlink.c                                        |    5 
 net/nfc/netlink.c                                               |    6 -
 sound/pci/hda/hda_intel.c                                       |   12 ++
 sound/pci/hda/patch_hdmi.c                                      |    3 
 tools/perf/builtin-inject.c                                     |    2 
 tools/perf/util/bpf_skel/bperf.h                                |   14 --
 tools/perf/util/bpf_skel/bperf_follower.bpf.c                   |   16 ++
 tools/perf/util/bpf_skel/bperf_leader.bpf.c                     |   16 ++
 52 files changed, 283 insertions(+), 179 deletions(-)

Adrian Hunter (1):
      perf inject: Fix itrace space allowed for new attributes

Akhil P Oommen (2):
      drm/msm: Fix null ptr access msm_ioctl_gem_submit()
      drm/msm/a6xx: Fix uinitialized use of gpu_scid

Alaa Hleihel (1):
      RDMA/mlx5: Fix releasing unallocated memory in dereg MR flow

Alexander Stein (1):
      Revert "tty: serial: fsl_lpuart: drop earlycon entry for i.MX8QXP"

Chen Jun (1):
      tracing: Fix a kmemleak false positive in tracing_map

Christophe JAILLET (1):
      RDMA/irdma: Fix a potential memory allocation issue in 'irdma_prm_add_pble_mem()'

David Howells (1):
      netfs: Fix lockdep warning from taking sb_writers whilst holding mmap_lock

Douglas Anderson (1):
      drm/msm/dp: Avoid unpowered AUX xfers that caused crashes

Eric Dumazet (1):
      inet: use #ifdef CONFIG_SOCK_RX_QUEUE_MAPPING consistently

Erik Ekman (1):
      net/mlx4_en: Update reported link modes for 1/10G

Flora Cui (2):
      drm/amdgpu: cancel the correct hrtimer on exit
      drm/amdgpu: check atomic flag to differeniate with legacy path

Greg Kroah-Hartman (1):
      Linux 5.15.10

Harshit Mogalapalli (1):
      net: netlink: af_netlink: Prevent empty skb by adding a check on len.

Helge Deller (1):
      parisc/agp: Annotate parisc agp init functions with __init

Herve Codina (2):
      mtd: rawnand: Fix nand_erase_op delay
      mtd: rawnand: Fix nand_choose_best_timings() on unsupported interface

Ilie Halip (1):
      s390/test_unwind: use raw opcode instead of invalid instruction

Kai Vehmanen (2):
      ALSA: hda: Add Intel DG2 PCI ID and HDMI codec vid
      ALSA: hda/hdmi: fix HDA codec entry table order for ADL-P

Marc Zyngier (1):
      KVM: arm64: Save PSTATE early on exit

Martin Botka (1):
      clk: qcom: sm6125-gcc: Swap ops of ice and apps on sdcc1

Miklos Szeredi (1):
      fuse: make sure reclaim doesn't write the inode

Mustapha Ghaddar (1):
      drm/amd/display: Fix for the no Audio bug with Tiled Displays

Nikita Yushchenko (1):
      staging: most: dim2: use device release method

Ondrej Jirman (1):
      i2c: rk3x: Handle a spurious start completion interrupt flag

Pavel Skripkin (1):
      RDMA: Fix use-after-free in rxe_queue_cleanup

Perry Yuan (1):
      drm/amd/display: add connector type check for CRC source set

Philip Chen (1):
      drm/msm/dsi: set default num_data_lanes

Philip Yang (2):
      drm/amdkfd: fix double free mem structure
      drm/amdkfd: process_info lock not needed for svm

Rob Herring (1):
      dt-bindings: media: nxp,imx7-mipi-csi2: Drop bad if/then schema

Ronak Doshi (1):
      vmxnet3: fix minimum vectors alloc issue

Shiraz Saleem (2):
      RDMA/irdma: Fix a user-after-free in add_pble_prm
      RDMA/irdma: Report correct WC errors

Song Liu (1):
      perf bpf_skel: Do not use typedef to avoid error on old clang

Tadeusz Struk (1):
      nfc: fix segfault in nfc_genl_dump_devices_done

Tatyana Nikolova (1):
      RDMA/irdma: Don't arm the CQ more than two times if no CE for this CQ

Tetsuo Handa (1):
      loop: Use pr_warn_once() for loop_control_remove() warning

Vincent Whitchurch (1):
      i2c: virtio: fix completion handling

Wilken Gottwalt (1):
      hwmon: (corsair-psu) fix plain integer used as NULL pointer

Yahui Cao (1):
      ice: fix FDIR init missing when reset VF

