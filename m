Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88FC16E7A8E
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 15:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbjDSNWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 09:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbjDSNWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 09:22:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE601FD2;
        Wed, 19 Apr 2023 06:22:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBF5E63F0D;
        Wed, 19 Apr 2023 13:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5194C433EF;
        Wed, 19 Apr 2023 13:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681910532;
        bh=vJeTI4nYBXXgFz1KFmoE87iUElfVSmKxPKQSQcZPY5A=;
        h=From:To:Cc:Subject:Date:From;
        b=qww0fpPH/5yL0dMPKOXCaiDV0oQ305gX2UtVC9QzOLRZi5xGgv52+cs1kmYrW9M8g
         CYxHZeO3XHr6H+LKGBIKtyomprnza/gJqCEHRp56zUvkmRzSJVCDJ1p5c43wgDJhYa
         F8jmt+JKoxu5JmqZIJqYsi8TGqbrYPvdhKPtmqX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 00/84] 5.15.108-rc4 review
Date:   Wed, 19 Apr 2023 15:22:09 +0200
Message-Id: <20230419132034.475843587@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.108-rc4.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.108-rc4
X-KernelTest-Deadline: 2023-04-21T13:20+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.108 release.
There are 84 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 21 Apr 2023 13:20:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.108-rc4.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.108-rc4

Xi Ruoyao <xry111@xry111.site>
    nvme-pci: avoid the deepest sleep state on ZHITAI TiPro5000 SSDs

Yanteng Si <siyanteng01@gmail.com>
    counter: Add the necessary colons and indents to the comments of counter_compi

Randy Dunlap <rdunlap@infradead.org>
    counter: fix docum. build problems after filename change

Valentin Schneider <vschneid@redhat.com>
    panic, kexec: make __crash_kexec() NMI safe

Valentin Schneider <vschneid@redhat.com>
    kexec: turn all kexec_mutex acquisitions into trylocks

Duy Truong <dory@dory.moe>
    nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD

Juraj Pecigos <kernel@juraj.dev>
    nvme-pci: mark Lexar NM760 as IGNORE_DEV_SUBNQN

Abhijit <abhijit@abhijittomar.com>
    nvme-pci: add NVME_QUIRK_BOGUS_NID for Lexar NM760

Shyamin Ayesh <me@shyamin.com>
    nvme-pci: add NVME_QUIRK_BOGUS_NID for Lexar NM610

Tobias Gruetzmacher <tobias-git@23.gs>
    nvme-pci: Crucial P2 has bogus namespace ids

Ning Wang <ningwang35@outlook.com>
    nvme-pci: avoid the deepest sleep state on ZHITAI TiPro7000 SSDs

Stefan Reiter <stefan@pimaker.at>
    nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA XPG GAMMIX S50

Gregor Herburger <gregor.herburger@tq-group.com>
    i2c: ocores: generate stop condition after timeout in polling mode

Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>
    x86/rtc: Remove __init for runtime functions

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix imbalance overflow

zgpeng <zgpeng.linux@gmail.com>
    sched/fair: Move calculate of avg_load to a better location

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/papr_scm: Update the NUMA distance table for the target node

ZhaoLong Wang <wangzhaolong1@huawei.com>
    ubi: Fix deadlock caused by recursively holding work_sem

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size

Paolo Abeni <pabeni@redhat.com>
    mptcp: stricter state check in mptcp_worker

Paolo Abeni <pabeni@redhat.com>
    mptcp: use mptcp_schedule_work instead of open-coding it

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    x86/PCI: Add quirk for AMD XHCI controller that loses MSI-X state in D3hot

Jiri Kosina <jkosina@suse.cz>
    scsi: ses: Handle enclosure with just a primary component gracefully

Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
    net: phy: nxp-c45-tja11xx: fix unsigned long multiplication overflow

Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
    net: phy: nxp-c45-tja11xx: add remove callback

Ivan Bornyakov <i.bornyakov@metrotek.ru>
    net: sfp: initialize sfp->i2c_block_size at sfp allocation

Mathis Salmen <mathis.salmen@matsal.de>
    riscv: add icache flush for nommu sigreturn trampoline

Min Li <lm0963hack@gmail.com>
    drm/i915: fix race condition UAF in i915_perf_add_config_ioctl

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    i915/perf: Replace DRM_DEBUG with driver specific drm_dbg call

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Have tracing_snapshot_instance_cond() write errors to the appropriate instance

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Add trace_array_puts() to write into instance

William Breathitt Gray <william.gray@linaro.org>
    counter: 104-quad-8: Fix Synapse action reported for Index signals

William Breathitt Gray <vilhelm.gray@gmail.com>
    counter: Internalize sysfs interface code

William Breathitt Gray <vilhelm.gray@gmail.com>
    counter: stm32-timer-cnt: Provide defines for slave mode selection

William Breathitt Gray <vilhelm.gray@gmail.com>
    counter: stm32-lptimer-cnt: Provide defines for clock polarities

Aymeric Wibo <obiwac@gmail.com>
    ACPI: resource: Add Medion S17413 to IRQ override quirk

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: fix mvmtxq->stopped handling

Robbie Harwood <rharwood@redhat.com>
    asymmetric_keys: log on fatal failures in PE/pkcs7

Robbie Harwood <rharwood@redhat.com>
    verify_pefile: relax wrapper length check

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for Lenovo Yoga Book X90F

Hans de Goede <hdegoede@redhat.com>
    efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L

Yicong Yang <yangyicong@hisilicon.com>
    i2c: hisi: Avoid redundant interrupts

Alexander Stein <alexander.stein@ew.tq-group.com>
    i2c: imx-lpi2c: clean rx/tx buffers upon new message

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    wifi: mwifiex: mark OF related data as maybe unused

Grant Grundler <grundler@chromium.org>
    power: supply: cros_usbpd: reclassify "default case!" as debug

Andrew Jeffery <andrew@aj.id.au>
    ARM: 9290/1: uaccess: Fix KASAN false-positives

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix single-line struct definition output in btf_dump

Liang Chen <liangchen.linux@gmail.com>
    skbuff: Fix a race between coalescing and releasing SKBs

Roman Gushchin <roman.gushchin@linux.dev>
    net: macb: fix a memory corruption in extended buffer descriptor mode

Eric Dumazet <edumazet@google.com>
    udp6: fix potential access to stale information

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/core: Fix GID entry ref leak when create_ah fails

Xin Long <lucien.xin@gmail.com>
    sctp: fix a potential overflow in sctp_ifwdtsn_skip

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: qrtr: Fix an uninit variable access bug in qrtr_tx_resume()

Denis Plotnikov <den-plotnikov@yandex-team.ru>
    qlcnic: check pci_reset_function result

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/armada: Fix a potential double free in an error handling path

YueHaibing <yuehaibing@huawei.com>
    tcp: restrict net.ipv4.tcp_app_win

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    niu: Fix missing unwind goto in niu_alloc_channels()

Zheng Wang <zyytlz.wz@163.com>
    9p/xen : Fix use after free bug in xen_9pfs_front_remove due to race condition

Martin KaFai Lau <martin.lau@kernel.org>
    bpf: tcp: Use sock_gen_put instead of sock_put in bpf_iter_tcp

Mark Zhang <markzhang@nvidia.com>
    RDMA/cma: Allow UD qp_type to join multicast only

Maher Sanalla <msanalla@nvidia.com>
    IB/mlx5: Add support for 400G_8X lane speed

Tatyana Nikolova <tatyana.e.nikolova@intel.com>
    RDMA/irdma: Add ipv4 check to irdma_find_listener()

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Increase iWARP CM default rexmit count

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Fix memory leak of PBLE objects

Chunyan Zhang <chunyan.zhang@unisoc.com>
    clk: sprd: set max_register according to mapping range

Jani Nikula <jani.nikula@intel.com>
    drm/i915/dsi: fix DSS CTL register offsets for TGL+

Reiji Watanabe <reijiw@google.com>
    KVM: arm64: PMU: Restore the guest's EL0 event counting after migration

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: rawnand: stm32_fmc2: use timings.mode instead of checking tRC_min

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: rawnand: stm32_fmc2: remove unsupported EDO mode

Arseniy Krasnov <avkrasnov@sberdevices.ru>
    mtd: rawnand: meson: fix bitmask for length in command word

Bang Li <libang.linuxer@gmail.com>
    mtdblock: tolerate corrected bit-flips

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbmem: Reject FB_ACTIVATE_KD_TEXT from userspace

Christoph Hellwig <hch@lst.de>
    btrfs: fix fast csum implementation detection

David Sterba <dsterba@suse.com>
    btrfs: print checksum type and implementation at mount time

Min Li <lm0963hack@gmail.com>
    Bluetooth: Fix race condition in hidp_session_thread

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: hda/sigmatel: fix S/PDIF out on Intel D*45* motherboards

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emu10k1: don't create old pass-through playback device on Audigy

Xu Biang <xubiang@hust.edu.cn>
    ALSA: firewire-tascam: add missing unwind goto in snd_tscm_stream_start_duplex()

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: i2c/cs8427: fix iec958 mixer control deactivation

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: hda/sigmatel: add pin overrides for Intel DP45SG motherboard

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emu10k1: fix capture interrupt handler unlinking

Kornel Dulęba <korneld@chromium.org>
    Revert "pinctrl: amd: Disable and mask interrupts on resume"


-------------

Diffstat:

 Documentation/driver-api/generic-counter.rst      |    2 +-
 Documentation/networking/ip-sysctl.rst            |    2 +
 Documentation/sound/hd-audio/models.rst           |    2 +-
 MAINTAINERS                                       |    1 -
 Makefile                                          |    4 +-
 arch/arm/lib/uaccess_with_memcpy.c                |    4 +-
 arch/arm64/kvm/pmu-emul.c                         |    1 +
 arch/arm64/kvm/sys_regs.c                         |    1 -
 arch/powerpc/mm/numa.c                            |    1 +
 arch/powerpc/platforms/pseries/papr_scm.c         |    7 +
 arch/riscv/kernel/signal.c                        |    9 +-
 arch/x86/kernel/x86_init.c                        |    4 +-
 arch/x86/pci/fixup.c                              |   21 +
 crypto/asymmetric_keys/pkcs7_verify.c             |   10 +-
 crypto/asymmetric_keys/verify_pefile.c            |   32 +-
 drivers/acpi/resource.c                           |    7 +
 drivers/clk/sprd/common.c                         |    9 +-
 drivers/counter/104-quad-8.c                      |  451 +++----
 drivers/counter/Makefile                          |    1 +
 drivers/counter/counter-core.c                    |  142 ++
 drivers/counter/counter-sysfs.c                   |  849 ++++++++++++
 drivers/counter/counter-sysfs.h                   |   13 +
 drivers/counter/counter.c                         | 1496 ---------------------
 drivers/counter/ftm-quaddec.c                     |   60 +-
 drivers/counter/intel-qep.c                       |  146 +-
 drivers/counter/interrupt-cnt.c                   |   62 +-
 drivers/counter/microchip-tcb-capture.c           |   91 +-
 drivers/counter/stm32-lptimer-cnt.c               |  212 ++-
 drivers/counter/stm32-timer-cnt.c                 |  195 ++-
 drivers/counter/ti-eqep.c                         |  180 +--
 drivers/firmware/efi/sysfb_efi.c                  |    8 +
 drivers/gpu/drm/armada/armada_drv.c               |    1 -
 drivers/gpu/drm/drm_panel_orientation_quirks.c    |   13 +-
 drivers/gpu/drm/i915/display/icl_dsi.c            |   20 +-
 drivers/gpu/drm/i915/i915_perf.c                  |  155 ++-
 drivers/i2c/busses/i2c-hisi.c                     |    7 +
 drivers/i2c/busses/i2c-imx-lpi2c.c                |    2 +
 drivers/i2c/busses/i2c-ocores.c                   |   35 +-
 drivers/infiniband/core/cma.c                     |   60 +-
 drivers/infiniband/core/verbs.c                   |    2 +
 drivers/infiniband/hw/irdma/cm.c                  |   16 +-
 drivers/infiniband/hw/irdma/cm.h                  |    2 +-
 drivers/infiniband/hw/irdma/hw.c                  |    3 +
 drivers/infiniband/hw/mlx5/main.c                 |    4 +
 drivers/mtd/mtdblock.c                            |   12 +-
 drivers/mtd/nand/raw/meson_nand.c                 |    6 +-
 drivers/mtd/nand/raw/stm32_fmc2_nand.c            |    3 +
 drivers/mtd/ubi/build.c                           |   21 +-
 drivers/mtd/ubi/wl.c                              |    4 +-
 drivers/net/ethernet/cadence/macb_main.c          |    4 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c   |    8 +-
 drivers/net/ethernet/sun/niu.c                    |    2 +-
 drivers/net/phy/nxp-c45-tja11xx.c                 |   14 +-
 drivers/net/phy/sfp.c                             |   13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |    5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |    5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      |    4 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c       |    2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c       |    2 +-
 drivers/nvme/host/pci.c                           |   15 +
 drivers/pinctrl/pinctrl-amd.c                     |   36 +-
 drivers/power/supply/cros_usbpd-charger.c         |    2 +-
 drivers/scsi/ses.c                                |   20 +-
 drivers/video/fbdev/core/fbmem.c                  |    2 +
 fs/btrfs/disk-io.c                                |   17 +
 fs/btrfs/super.c                                  |    2 -
 include/linux/counter.h                           |  658 ++++-----
 include/linux/counter_enum.h                      |   45 -
 include/linux/kexec.h                             |    2 +-
 include/linux/mfd/stm32-lptimer.h                 |    5 +
 include/linux/mfd/stm32-timers.h                  |    4 +
 include/linux/trace.h                             |   12 +
 kernel/cgroup/cpuset.c                            |    6 +-
 kernel/kexec.c                                    |   11 +-
 kernel/kexec_core.c                               |   28 +-
 kernel/kexec_file.c                               |    4 +-
 kernel/kexec_internal.h                           |   15 +-
 kernel/ksysfs.c                                   |    7 +-
 kernel/sched/fair.c                               |   15 +-
 kernel/trace/trace.c                              |   41 +-
 net/9p/trans_xen.c                                |    4 +
 net/bluetooth/hidp/core.c                         |    2 +-
 net/bluetooth/l2cap_core.c                        |   24 +-
 net/core/skbuff.c                                 |   16 +-
 net/ipv4/sysctl_net_ipv4.c                        |    3 +
 net/ipv4/tcp_ipv4.c                               |    4 +-
 net/ipv6/udp.c                                    |    8 +-
 net/mptcp/options.c                               |    5 +-
 net/mptcp/protocol.c                              |    2 +-
 net/mptcp/subflow.c                               |   18 +-
 net/qrtr/af_qrtr.c                                |    8 +-
 net/sctp/stream_interleave.c                      |    3 +-
 sound/firewire/tascam/tascam-stream.c             |    2 +-
 sound/i2c/cs8427.c                                |    7 +-
 sound/pci/emu10k1/emupcm.c                        |   14 +-
 sound/pci/hda/patch_sigmatel.c                    |   10 +
 tools/lib/bpf/btf_dump.c                          |    7 +-
 98 files changed, 2580 insertions(+), 2956 deletions(-)


