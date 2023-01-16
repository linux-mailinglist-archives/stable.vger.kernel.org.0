Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221B366C5CA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbjAPQK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbjAPQJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:09:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8BE2886E;
        Mon, 16 Jan 2023 08:06:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 115AFB8107E;
        Mon, 16 Jan 2023 16:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34683C433F0;
        Mon, 16 Jan 2023 16:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885186;
        bh=1FMbckGDZKUOmh9B8Qgm6MqJxUC6w9f36GjxU20yXd4=;
        h=From:To:Cc:Subject:Date:From;
        b=cdkCS5TQHG2Efk8FuJLrZNaPIUuTDzp07+wIKFSy87SoXKaOI6oUac6RkyrHHy0CD
         C09p+WshTyKoRhthUMjqEuTJVtEC+bTbh3ZDqPLEfRFUU8XmJ3Z2oSVrjz4+9SX4k1
         kY3Rhqe/Kq7ZVzbvbIyZL1/eoHfx7twPj76YgHc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 00/64] 5.10.164-rc1 review
Date:   Mon, 16 Jan 2023 16:51:07 +0100
Message-Id: <20230116154743.577276578@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.164-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.164-rc1
X-KernelTest-Deadline: 2023-01-18T15:47+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.164 release.
There are 64 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.164-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.164-rc1

Ferry Toth <ftoth@exalondelft.nl>
    Revert "usb: ulpi: defer ulpi_register on ulpi_read_id timeout"

Jens Axboe <axboe@kernel.dk>
    io_uring/io-wq: only free worker if it was allocated for creation

Jens Axboe <axboe@kernel.dk>
    io_uring/io-wq: free worker if task_work creation is canceled

Rob Clark <robdclark@chromium.org>
    drm/virtio: Fix GEM handle creation UAF

Johan Hovold <johan+linaro@kernel.org>
    efi: fix NULL-deref in init error path

Mark Rutland <mark.rutland@arm.com>
    arm64: cmpxchg_double*: hazard against entire exchange variable

Mark Rutland <mark.rutland@arm.com>
    arm64: atomics: remove LL/SC trampolines

Mark Rutland <mark.rutland@arm.com>
    arm64: atomics: format whitespace consistently

Peter Newman <peternewman@google.com>
    x86/resctrl: Fix task CLOSID/RMID update race

Reinette Chatre <reinette.chatre@intel.com>
    x86/resctrl: Use task_curr() instead of task_struct->on_cpu to prevent unnecessary IPI

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Do not return host topology information from KVM_GET_SUPPORTED_CPUID

Paolo Bonzini <pbonzini@redhat.com>
    Documentation: KVM: add API issues section

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iommu/mediatek-v1: Fix an error handling path in mtk_iommu_v1_probe()

Yong Wu <yong.wu@mediatek.com>
    iommu/mediatek-v1: Add error handle for mtk_iommu_probe

Aaron Thompson <dev@aaront.org>
    mm: Always release pages to the buddy allocator in memblock_free_late().

Gavin Li <gavinl@nvidia.com>
    net/mlx5e: Don't support encap rules with gbp option

Rahul Rameshbabu <rrameshbabu@nvidia.com>
    net/mlx5: Fix ptp max frequency adjustment range

Ido Schimmel <idosch@nvidia.com>
    net/sched: act_mpls: Fix warning during failed attribute validation

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()

Roger Pau Monne <roger.pau@citrix.com>
    hvc/xen: lock console list traversal

Angela Czubak <aczubak@marvell.com>
    octeontx2-af: Fix LMAC config in cgx_lmac_rx_tx_enable

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Map NIX block from CGX connection

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Update get/set resource count functions

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix unexpected link reset due to discovery messages

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    ASoC: wm8904: fix wrong outputs volume after power reactivation

Ricardo Ribalda <ribalda@chromium.org>
    regulator: da9211: Use irq handler when ready

Eliav Farber <farbere@amazon.com>
    EDAC/device: Fix period calculation in edac_device_reset_delay_period()

Peter Zijlstra <peterz@infradead.org>
    x86/boot: Avoid using Intel mnemonics in AT&T syntax asm

Kajol Jain <kjain@linux.ibm.com>
    powerpc/imc-pmu: Fix use of mutex in IRQs disabled section

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    netfilter: ipset: Fix overflow before widen in the bitmap_ip_create() function.

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm: fix rcu lock in xfrm_notify_userpolicy()

Ye Bin <yebin10@huawei.com>
    ext4: fix uninititialized value in 'ext4_evict_inode'

Ferry Toth <ftoth@exalondelft.nl>
    usb: ulpi: defer ulpi_register on ulpi_read_id timeout

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Prevent infinite loop in transaction errors recovery for streams

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: move and rename xhci_cleanup_halted_endpoint()

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: store TD status in the td struct instead of passing it along

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: move xhci_td_cleanup so it can be called by more functions

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Add xhci_reset_halted_ep() helper function

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: adjust parameters passed to cleanup_halted_endpoint()

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: get isochronous ring directly from endpoint structure

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Avoid parsing transfer events several times

Li Jun <jun.li@nxp.com>
    clk: imx: imx8mp: add shared clk gate for usb suspend clk

Li Jun <jun.li@nxp.com>
    dt-bindings: clocks: imx8mp: Add ID for usb suspend clock

Lucas Stach <l.stach@pengutronix.de>
    clk: imx8mp: add clkout1/2 support

Marek Vasut <marex@denx.de>
    clk: imx8mp: Add DISP2 pixel clock

Kim Phillips <kim.phillips@amd.com>
    iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet and ivrs_acpihid options

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Add PCI segment support for ivrs_[ioapic/hpet/acpihid] commands

Qiang Yu <quic_qianyu@quicinc.com>
    bus: mhi: host: Fix race between channel preparation and M0 event

Herbert Xu <herbert@gondor.apana.org.au>
    ipv6: raw: Deduct extension header length in rawv6_push_pending_frames

Yang Yingliang <yangyingliang@huawei.com>
    ixgbe: fix pci device refcount leak

Hans de Goede <hdegoede@redhat.com>
    platform/x86: sony-laptop: Don't turn off 0x153 keyboard backlight during probe

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: do not complete dp_aux_cmd_fifo_tx() if irq is not for aux transfer

Konrad Dybcio <konrad.dybcio@linaro.org>
    drm/msm/adreno: Make adreno quirks not overwrite each other

Volker Lendecke <vl@samba.org>
    cifs: Fix uninitialized memory read for smb311 posix symlink create

Heiko Carstens <hca@linux.ibm.com>
    s390/percpu: add READ_ONCE() to arch_this_cpu_to_op_simple()

Heiko Carstens <hca@linux.ibm.com>
    s390/cpum_sf: add READ_ONCE() semantics to compare and swap loops

Brian Norris <computersforpeace@gmail.com>
    ASoC: qcom: lpass-cpu: Fix fallback SD line index handling

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/kexec: fix ipl report address for kdump

Adrian Hunter <adrian.hunter@intel.com>
    perf auxtrace: Fix address filter duplicate symbol selection

Jonathan Corbet <corbet@lwn.net>
    docs: Fix the docs build with Sphinx 6.0

Ard Biesheuvel <ardb@kernel.org>
    efi: tpm: Avoid READ_ONCE() for accessing the event log

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix S1PTW handling on RO memslots

Luka Guzenko <l.guzenko@web.de>
    ALSA: hda/realtek: Enable mute/micmute LEDs on HP Spectre x360 13-aw0xxx

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: incorrect arithmetics when fetching VLAN header bits


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |  51 +++-
 Documentation/sphinx/load_config.py                |   6 +-
 Documentation/virt/kvm/api.rst                     |  60 +++++
 Makefile                                           |   4 +-
 arch/arm64/include/asm/atomic_ll_sc.h              | 114 ++++----
 arch/arm64/include/asm/atomic_lse.h                |  16 +-
 arch/arm64/include/asm/kvm_emulate.h               |  22 +-
 arch/powerpc/include/asm/imc-pmu.h                 |   2 +-
 arch/powerpc/perf/imc-pmu.c                        | 136 +++++-----
 arch/s390/include/asm/cpu_mf.h                     |  31 ++-
 arch/s390/include/asm/percpu.h                     |   2 +-
 arch/s390/kernel/machine_kexec_file.c              |   5 +-
 arch/s390/kernel/perf_cpum_sf.c                    | 101 ++++---
 arch/x86/boot/bioscall.S                           |   4 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  26 +-
 arch/x86/kvm/cpuid.c                               |  32 +--
 drivers/bus/mhi/core/pm.c                          |   3 +-
 drivers/clk/imx/clk-imx8mp.c                       |  23 +-
 drivers/edac/edac_device.c                         |  17 +-
 drivers/edac/edac_module.h                         |   2 +-
 drivers/firmware/efi/efi.c                         |   9 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.h            |  10 +-
 drivers/gpu/drm/msm/dp/dp_aux.c                    |   4 +
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |  10 +-
 drivers/iommu/amd/init.c                           |  89 ++++--
 drivers/iommu/mtk_iommu_v1.c                       |  26 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |  14 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  17 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   6 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 134 ++++++++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   4 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  15 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  21 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  |   2 +
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |   2 +-
 drivers/nfc/pn533/usb.c                            |  44 ++-
 drivers/platform/x86/sony-laptop.c                 |  21 +-
 drivers/regulator/da9211-regulator.c               |  11 +-
 drivers/tty/hvc/hvc_xen.c                          |  46 ++--
 drivers/usb/host/xhci-mem.c                        |   4 +
 drivers/usb/host/xhci-ring.c                       | 297 +++++++++++----------
 drivers/usb/host/xhci.h                            |   6 +-
 fs/cifs/link.c                                     |   1 +
 fs/ext4/super.c                                    |   1 +
 include/dt-bindings/clock/imx8mp-clock.h           |  10 +-
 include/linux/tpm_eventlog.h                       |   4 +-
 io_uring/io-wq.c                                   |   6 +
 mm/memblock.c                                      |   8 +-
 net/ipv6/raw.c                                     |   4 +
 net/netfilter/ipset/ip_set_bitmap_ip.c             |   4 +-
 net/netfilter/nft_payload.c                        |   2 +-
 net/sched/act_mpls.c                               |   8 +-
 net/tipc/node.c                                    |  12 +-
 net/xfrm/xfrm_user.c                               |   7 +-
 sound/pci/hda/patch_realtek.c                      |  23 ++
 sound/soc/codecs/wm8904.c                          |   7 +
 sound/soc/qcom/lpass-cpu.c                         |   5 +-
 tools/perf/util/auxtrace.c                         |   2 +-
 58 files changed, 1015 insertions(+), 538 deletions(-)


