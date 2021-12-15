Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73231475EE8
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbhLORZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245698AbhLORYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:24:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E410EC061747;
        Wed, 15 Dec 2021 09:24:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C5AFB82049;
        Wed, 15 Dec 2021 17:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF83AC36AE0;
        Wed, 15 Dec 2021 17:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589068;
        bh=Hh/z8uvjFw+iIZiEgrTtGNzhsjqg4F3X4ijRrdirUXU=;
        h=From:To:Cc:Subject:Date:From;
        b=WBEkXtxmLCdaAEZNV530L0xSP1TXGj8XDv0XrdzvXimEkr3AZHnNvrG9XnlEc4DPv
         Dgxl4iXBSlNqbio2bQpEaUycqBrMo+gKzpokZJ5XDtVX+RNyCHtHBUw55VRbCu5Mat
         HJJeDqL2h/XyNbcwEGmLJUhisIFTIJviorI0dE5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/33] 5.10.86-rc1 review
Date:   Wed, 15 Dec 2021 18:20:58 +0100
Message-Id: <20211215172024.787958154@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.86-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.86-rc1
X-KernelTest-Deadline: 2021-12-17T17:20+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.86 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.86-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.86-rc1

Mike Rapoport <rppt@kernel.org>
    arm: ioremap: don't abuse pfn_valid() to check if pfn is in RAM

Mike Rapoport <rppt@kernel.org>
    arm: extend pfn_valid to take into account freed memory map alignment

Mike Rapoport <rppt@kernel.org>
    memblock: ensure there is no overflow in memblock_overlaps_region()

Mike Rapoport <rppt@kernel.org>
    memblock: align freed memory map on pageblock boundaries with SPARSEMEM

Mike Rapoport <rppt@kernel.org>
    memblock: free_unused_memmap: use pageblock units instead of MAX_ORDER

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix error timestamp setting on the decoder error path

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix missing 'instruction' events with 'q' option

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix next 'err' value, walking trace

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix state setting when receiving overflow (OVF) packet

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix intel_pt_fup_event() assumptions about setting state type

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix sync state when a PSB (synchronization) packet is found

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix some PGE (packet generation enable/control flow packets) usage

Adrian Hunter <adrian.hunter@intel.com>
    perf inject: Fix itrace space allowed for new attributes

Antoine Tenart <atenart@kernel.org>
    ethtool: do not perform operations on net devices being unregistered

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Fix warning on /proc/i8k creation error

Miklos Szeredi <mszeredi@redhat.com>
    fuse: make sure reclaim doesn't write the inode

Bui Quang Minh <minhquangbui99@gmail.com>
    bpf: Fix integer overflow in argument calculation for bpf_map_area_alloc

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    staging: most: dim2: use device release method

Sean Christopherson <seanjc@google.com>
    KVM: x86: Ignore sparse banks size for an "all CPUs", non-sparse IPI req

Chen Jun <chenjun102@huawei.com>
    tracing: Fix a kmemleak false positive in tracing_map

Perry Yuan <Perry.Yuan@amd.com>
    drm/amd/display: add connector type check for CRC source set

Mustapha Ghaddar <mghaddar@amd.com>
    drm/amd/display: Fix for the no Audio bug with Tiled Displays

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

Erik Ekman <erik@kryo.se>
    net/mlx4_en: Update reported link modes for 1/10G

Alexander Stein <alexander.stein@ew.tq-group.com>
    Revert "tty: serial: fsl_lpuart: drop earlycon entry for i.MX8QXP"

Ilie Halip <ilie.halip@gmail.com>
    s390/test_unwind: use raw opcode instead of invalid instruction

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Save PSTATE early on exit

Philip Chen <philipchen@chromium.org>
    drm/msm/dsi: set default num_data_lanes

Tadeusz Struk <tadeusz.struk@linaro.org>
    nfc: fix segfault in nfc_genl_dump_devices_done


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/mm/init.c                                 | 37 ++++++----
 arch/arm/mm/ioremap.c                              |  4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  6 ++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  7 +-
 arch/s390/lib/test_unwind.c                        |  5 +-
 arch/x86/kvm/hyperv.c                              |  7 +-
 drivers/char/agp/parisc-agp.c                      |  6 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c  |  8 +++
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |  4 ++
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  2 +
 drivers/hwmon/dell-smm-hwmon.c                     |  7 +-
 drivers/i2c/busses/i2c-rk3x.c                      |  4 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |  6 +-
 drivers/staging/most/dim2/dim2.c                   | 55 +++++++-------
 drivers/tty/serial/fsl_lpuart.c                    |  1 +
 fs/fuse/dir.c                                      |  8 +++
 fs/fuse/file.c                                     | 15 ++++
 fs/fuse/fuse_i.h                                   |  1 +
 fs/fuse/inode.c                                    |  3 +
 kernel/bpf/devmap.c                                |  4 +-
 kernel/trace/tracing_map.c                         |  3 +
 mm/memblock.c                                      |  3 +-
 net/core/sock_map.c                                |  2 +-
 net/ethtool/netlink.h                              |  3 +
 net/netlink/af_netlink.c                           |  5 ++
 net/nfc/netlink.c                                  |  6 +-
 sound/pci/hda/hda_intel.c                          | 12 +++-
 sound/pci/hda/patch_hdmi.c                         |  3 +-
 tools/perf/builtin-inject.c                        |  2 +-
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  | 83 ++++++++++++++--------
 tools/perf/util/intel-pt.c                         |  1 +
 32 files changed, 224 insertions(+), 93 deletions(-)


