Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0098C475E7C
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245248AbhLORW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:22:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43380 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239899AbhLORW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:22:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFC96619E9;
        Wed, 15 Dec 2021 17:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B30C36AE2;
        Wed, 15 Dec 2021 17:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639588948;
        bh=LeKsEBfBIFKCHd/v4LshSU14rDeJJhDnKVo7JRtg4no=;
        h=From:To:Cc:Subject:Date:From;
        b=hr4opj4weZkF+7o+t1isPvnkCKpXlyEW8wN8ft3kCd7E1gf4lnf5uM464hn6Ua1Lo
         +R16guhiBKulCIje/XzFEaZu4v8Kb/eKn9yH0w7HdARQJq2wkAMrbQWr0SgIzJgTGD
         n6DRZlPO2NV1IOcRNLw1ZFnFyBf3jBw5ZmWejPKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.15 00/42] 5.15.9-rc1 review
Date:   Wed, 15 Dec 2021 18:20:41 +0100
Message-Id: <20211215172026.641863587@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.9-rc1
X-KernelTest-Deadline: 2021-12-17T17:20+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.9 release.
There are 42 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.9-rc1

Adrian Hunter <adrian.hunter@intel.com>
    perf inject: Fix itrace space allowed for new attributes

Miklos Szeredi <mszeredi@redhat.com>
    fuse: make sure reclaim doesn't write the inode

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    staging: most: dim2: use device release method

Chen Jun <chenjun102@huawei.com>
    tracing: Fix a kmemleak false positive in tracing_map

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: process_info lock not needed for svm

Perry Yuan <Perry.Yuan@amd.com>
    drm/amd/display: add connector type check for CRC source set

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: fix double free mem structure

Mustapha Ghaddar <mghaddar@amd.com>
    drm/amd/display: Fix for the no Audio bug with Tiled Displays

Flora Cui <flora.cui@amd.com>
    drm/amdgpu: check atomic flag to differeniate with legacy path

Flora Cui <flora.cui@amd.com>
    drm/amdgpu: cancel the correct hrtimer on exit

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    net: netlink: af_netlink: Prevent empty skb by adding a check on len.

Ondrej Jirman <megous@megous.com>
    i2c: rk3x: Handle a spurious start completion interrupt flag

Helge Deller <deller@gmx.de>
    parisc/agp: Annotate parisc agp init functions with __init

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: fix HDA codec entry table order for ADL-P

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: Add Intel DG2 PCI ID and HDMI codec vid

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    loop: Use pr_warn_once() for loop_control_remove() warning

Erik Ekman <erik@kryo.se>
    net/mlx4_en: Update reported link modes for 1/10G

Alexander Stein <alexander.stein@ew.tq-group.com>
    Revert "tty: serial: fsl_lpuart: drop earlycon entry for i.MX8QXP"

Ilie Halip <ilie.halip@gmail.com>
    s390/test_unwind: use raw opcode instead of invalid instruction

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Save PSTATE early on exit

Douglas Anderson <dianders@chromium.org>
    drm/msm/dp: Avoid unpowered AUX xfers that caused crashes

Philip Chen <philipchen@chromium.org>
    drm/msm/dsi: set default num_data_lanes

Akhil P Oommen <akhilpo@codeaurora.org>
    drm/msm/a6xx: Fix uinitialized use of gpu_scid

Akhil P Oommen <akhilpo@codeaurora.org>
    drm/msm: Fix null ptr access msm_ioctl_gem_submit()

Vincent Whitchurch <vincent.whitchurch@axis.com>
    i2c: virtio: fix completion handling

Ronak Doshi <doshir@vmware.com>
    vmxnet3: fix minimum vectors alloc issue

Yahui Cao <yahui.cao@intel.com>
    ice: fix FDIR init missing when reset VF

Tatyana Nikolova <tatyana.e.nikolova@intel.com>
    RDMA/irdma: Don't arm the CQ more than two times if no CE for this CQ

Shiraz Saleem <shiraz.saleem@intel.com>
    RDMA/irdma: Report correct WC errors

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    RDMA/irdma: Fix a potential memory allocation issue in 'irdma_prm_add_pble_mem()'

Shiraz Saleem <shiraz.saleem@intel.com>
    RDMA/irdma: Fix a user-after-free in add_pble_prm

David Howells <dhowells@redhat.com>
    netfs: Fix lockdep warning from taking sb_writers whilst holding mmap_lock

Song Liu <songliubraving@fb.com>
    perf bpf_skel: Do not use typedef to avoid error on old clang

Martin Botka <martin.botka@somainline.org>
    clk: qcom: sm6125-gcc: Swap ops of ice and apps on sdcc1

Rob Herring <robh@kernel.org>
    dt-bindings: media: nxp,imx7-mipi-csi2: Drop bad if/then schema

Eric Dumazet <edumazet@google.com>
    inet: use #ifdef CONFIG_SOCK_RX_QUEUE_MAPPING consistently

Herve Codina <herve.codina@bootlin.com>
    mtd: rawnand: Fix nand_choose_best_timings() on unsupported interface

Herve Codina <herve.codina@bootlin.com>
    mtd: rawnand: Fix nand_erase_op delay

Alaa Hleihel <alaa@nvidia.com>
    RDMA/mlx5: Fix releasing unallocated memory in dereg MR flow

Pavel Skripkin <paskripkin@gmail.com>
    RDMA: Fix use-after-free in rxe_queue_cleanup

Wilken Gottwalt <wilken.gottwalt@posteo.net>
    hwmon: (corsair-psu) fix plain integer used as NULL pointer

Tadeusz Struk <tadeusz.struk@linaro.org>
    nfc: fix segfault in nfc_genl_dump_devices_done


-------------

Diffstat:

 .../bindings/media/nxp,imx7-mipi-csi2.yaml         | 14 +-----
 Makefile                                           |  4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  6 +++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  7 ++-
 arch/s390/lib/test_unwind.c                        |  5 +-
 drivers/block/loop.c                               |  2 +-
 drivers/char/agp/parisc-agp.c                      |  6 +--
 drivers/clk/qcom/gcc-sm6125.c                      |  4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  8 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c           |  4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |  9 ----
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c  |  8 ++++
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |  4 ++
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              | 18 +++----
 drivers/gpu/drm/msm/dp/dp_aux.c                    | 17 +++++++
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  2 +
 drivers/gpu/drm/msm/msm_gem_submit.c               |  1 +
 drivers/hwmon/corsair-psu.c                        |  2 +-
 drivers/i2c/busses/i2c-rk3x.c                      |  4 +-
 drivers/i2c/busses/i2c-virtio.c                    | 32 +++++--------
 drivers/infiniband/hw/irdma/hw.c                   |  7 ++-
 drivers/infiniband/hw/irdma/main.h                 |  1 +
 drivers/infiniband/hw/irdma/pble.c                 |  8 ++--
 drivers/infiniband/hw/irdma/pble.h                 |  1 -
 drivers/infiniband/hw/irdma/utils.c                | 24 +++++++---
 drivers/infiniband/hw/irdma/verbs.c                | 23 +++++++--
 drivers/infiniband/hw/irdma/verbs.h                |  2 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  6 +--
 drivers/infiniband/hw/mlx5/mr.c                    | 26 +++++-----
 drivers/infiniband/sw/rxe/rxe_qp.c                 |  1 +
 drivers/mtd/nand/raw/nand_base.c                   |  6 +--
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  2 +
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |  6 +--
 drivers/net/vmxnet3/vmxnet3_drv.c                  | 13 ++---
 drivers/staging/most/dim2/dim2.c                   | 55 ++++++++++++----------
 drivers/tty/serial/fsl_lpuart.c                    |  1 +
 fs/fuse/dir.c                                      |  8 ++++
 fs/fuse/file.c                                     | 15 ++++++
 fs/fuse/fuse_i.h                                   |  1 +
 fs/fuse/inode.c                                    |  3 ++
 fs/netfs/read_helper.c                             | 15 ++----
 kernel/trace/tracing_map.c                         |  3 ++
 net/ipv4/inet_connection_sock.c                    |  2 +-
 net/netlink/af_netlink.c                           |  5 ++
 net/nfc/netlink.c                                  |  6 ++-
 sound/pci/hda/hda_intel.c                          | 12 ++++-
 sound/pci/hda/patch_hdmi.c                         |  3 +-
 tools/perf/builtin-inject.c                        |  2 +-
 tools/perf/util/bpf_skel/bperf.h                   | 14 ------
 tools/perf/util/bpf_skel/bperf_follower.bpf.c      | 16 +++++--
 tools/perf/util/bpf_skel/bperf_leader.bpf.c        | 16 +++++--
 52 files changed, 284 insertions(+), 180 deletions(-)


