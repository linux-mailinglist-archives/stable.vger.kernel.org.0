Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEAA43A117
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbhJYThQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236253AbhJYTd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:33:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59C3360187;
        Mon, 25 Oct 2021 19:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190191;
        bh=qqSAJxMUHt47L0pXlFdZ/EloN9+j6uBepN63Q6Bq7Ro=;
        h=From:To:Cc:Subject:Date:From;
        b=OYBqzOQSlkTk1GEsy5FHQdTh6WTtEBwzwpahBd8i6af3GY/y9DBoE8d89taaqey2+
         pBg0s05/TXFQsTFdfjz0EEGJb6tFFWpPqyfns4YTGIoM+e2Rsulfshcx0b26Yzbwiy
         xPqEp1YL4z50aXVsoc2IIUTrc2yznfFmWh6g1Xdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/95] 5.10.76-rc1 review
Date:   Mon, 25 Oct 2021 21:13:57 +0200
Message-Id: <20211025190956.374447057@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.76-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.76-rc1
X-KernelTest-Deadline: 2021-10-27T19:10+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.76 release.
There are 95 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.76-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.76-rc1

Fabien Dessenne <fabien.dessenne@foss.st.com>
    pinctrl: stm32: use valid pin identifier in stm32_pinctrl_resume()

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 9122/1: select HAVE_FUTEX_CMPXCHG

Lorenz Bauer <lmb@cloudflare.com>
    selftests: bpf: fix backported ASSERT_FALSE

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Separate TGP board type from SPT

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Have all levels of checks prevent recursion

Yanfei Xu <yanfei.xu@windriver.com>
    net: mdiobus: Fix memory leak in __mdiobus_register

Oliver Neukum <oneukum@suse.com>
    usbnet: sanity check for maxpacket

Daniel Borkmann <daniel@iogearbox.net>
    bpf, test, cgroup: Use sk_{alloc,free} for test cases

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: fix zpci_zdev_put() on reserve

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: isotp: isotp_sendmsg(): fix TX buffer concurrent access in isotp_sendmsg()

Dexuan Cui <decui@microsoft.com>
    scsi: core: Fix shost->cmd_per_lun calculation in scsi_add_host_with_dma()

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: fix for miscalculation of rx unused desc

Woody Lin <woodylin@google.com>
    sched/scs: Reset the shadow stack when idle_task_exit

Joy Gu <jgu@purestorage.com>
    scsi: qla2xxx: Fix a memory leak in an error path of qla2x00_process_els()

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix set_param() handling

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Input: snvs_pwrkey - add clk handling

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/msr: Add Sapphire Rapids CPU support

Shunsuke Nakamura <nakamura.shun@fujitsu.com>
    libperf tests: Fix test_stat_cpu

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: avoid write to STATESTS if controller is in reset

Prashant Malani <pmalani@chromium.org>
    platform/x86: intel_scu_ipc: Update timeout value in comment

Zheyu Ma <zheyuma97@gmail.com>
    isdn: mISDN: Fix sleeping function called from invalid context

Herve Codina <herve.codina@bootlin.com>
    ARM: dts: spear3xx: Fix gmac node

Herve Codina <herve.codina@bootlin.com>
    net: stmmac: add support for dwmac 3.40a

Filipe Manana <fdmanana@suse.com>
    btrfs: deal with errors when checking if a dir entry exists during log replay

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: intel: Allow repeatedly probing on codec configuration errors

Brendan Higgins <brendanhiggins@google.com>
    gcc-plugins/structleak: add makefile var for disabling structleak

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: fix the max tx size according to user manual

Marek Vasut <marex@denx.de>
    drm: mxsfb: Fix NULL pointer dereference crash on unload

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: bridge: mcast: use multicast_membership_interval for IGMPv3

Florian Westphal <fw@strlen.de>
    selftests: netfilter: remove stray bash debug line

Vegard Nossum <vegard.nossum@gmail.com>
    netfilter: Kconfig: use 'default y' instead of 'm' for bool config option

Xiaolong Huang <butterflyhuangxx@gmail.com>
    isdn: cpai: check ctr->cnr to avoid array index out of bound

Lin Ma <linma@zju.edu.cn>
    nfc: nci: fix the UAF of rf_conn_info object

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: promptly process interrupts delivered while in guest mode

Miaohe Lin <linmiaohe@huawei.com>
    mm, slub: fix incorrect memcg slab count for bulk free

Miaohe Lin <linmiaohe@huawei.com>
    mm, slub: fix potential memoryleak in kmem_cache_open()

Miaohe Lin <linmiaohe@huawei.com>
    mm, slub: fix mismatch between reconstructed freelist depth and cnt

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/idle: Don't corrupt back chain when going idle

Michael Ellerman <mpe@ellerman.id.au>
    KVM: PPC: Book3S HV: Make idle_kvm_start_guest() return 0 if it went to guest

Michael Ellerman <mpe@ellerman.id.au>
    KVM: PPC: Book3S HV: Fix stack handling in idle_kvm_start_guest()

Christopher M. Riedl <cmr@codefail.de>
    powerpc64/idle: Fix SP offsets when saving GPRs

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mt7530: correct ds->num_ports

Gaosheng Cui <cuigaosheng1@huawei.com>
    audit: fix possible null-pointer dereference in audit_filter_rules

Takashi Iwai <tiwai@suse.de>
    ASoC: DAPM: Fix missing kctl change notifications

Steven Clarkson <sc@lambdal.com>
    ALSA: hda/realtek: Add quirk for Clevo PC50HS

Brendan Grieve <brendan@grieve.com.au>
    ALSA: usb-audio: Provide quirk for Sennheiser GSP670 Headset

Matthew Wilcox (Oracle) <willy@infradead.org>
    vfs: check fd has read access in kernel_read_file_from_fd()

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    elfcore: correct reference to CONFIG_UML

Nadav Amit <namit@vmware.com>
    userfaultfd: fix a race between writeprotect and exit_mmap()

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    ocfs2: mount fails with buffer overflow in strlen

Jan Kara <jack@suse.cz>
    ocfs2: fix data corruption after conversion from inline format

Jeff Layton <jlayton@kernel.org>
    ceph: fix handling of "meta" errors

Jeff Layton <jlayton@kernel.org>
    ceph: skip existing superblocks that are blocklisted or shut down when mounting

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: j1939_xtp_rx_rts_session_new(): abort TP less than 9 bytes

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: j1939_xtp_rx_dat_one(): cancel session if receive TP.DT with error length

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: j1939: j1939_netdev_start(): fix UAF for rx_kref of j1939_priv

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: j1939: j1939_tp_rxtimer(): fix errant alert in j1939_tp_rxtimer

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: isotp: isotp_sendmsg(): add result check for wait_event_interruptible()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: isotp: isotp_sendmsg(): fix return error on FC timeout on TX path

Zheyu Ma <zheyuma97@gmail.com>
    can: peak_pci: peak_pci_remove(): fix UAF

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: pcan_usb_fd_decode_status(): fix back to ERROR_ACTIVE state notification

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    can: rcar_can: fix suspend/resume

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: fix ethtool counter name for PM0_TERR

Dan Johansen <strit@manjaro.org>
    drm/panel: ilitek-ili9881c: Fix sync for Feixin K101-IM2BYL02 panel

Tony Nguyen <anthony.l.nguyen@intel.com>
    ice: Add missing E810 device ids

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Fix packet loss on Tiger Lake and later

Kurt Kanzenbach <kurt@linutronix.de>
    net: stmmac: Fix E2E delay mechanism

Peng Li <lipeng321@huawei.com>
    net: hns3: disable sriov before unload hclge layer

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: fix vf reset workqueue cannot exit

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: schedule the polling again when allocation fails

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: add limit ets dwrr bandwidth cannot be 0

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: reset DWRR of unused tc to zero

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/smp: do not decrement idle task preempt count in CPU offline

Randy Dunlap <rdunlap@infradead.org>
    NIOS2: irqflags: rename a redefined register name

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: dsa: lantiq_gswip: fix register definition

Stephen Suryaputra <ssuryaextr@gmail.com>
    ipv6: When forwarding count rx stats on the orig netdev

Leonard Crestez <cdleonard@gmail.com>
    tcp: md5: Fix overlap between vrf and non-vrf keys

Vegard Nossum <vegard.nossum@oracle.com>
    lan78xx: select CRC32

Antoine Tenart <atenart@kernel.org>
    netfilter: ipvs: make global sysctl readonly in non-init netns

Xin Long <lucien.xin@gmail.com>
    netfilter: ip6t_rt: fix rt0_hdr parsing in rt_mt6

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: fix getting UDP tunnel entry

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: wm8960: Fix clock configuration on slave mode

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    dma-debug: fix sg checks in debug_dma_map_sg()

Juhee Kang <claudiajkang@gmail.com>
    netfilter: xt_IDLETIMER: fix panic that occurs when timer_type has garbage value

Benjamin Coddington <bcodding@redhat.com>
    NFSD: Keep existing listeners on portlist error

Guenter Roeck <linux@roeck-us.net>
    xtensa: xtfpga: Try software restart before simulating CPU reset

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: xtfpga: use CONFIG_USE_OF instead of CONFIG_OF

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: fix dependencies for DRM_AMD_DC_SI

Jan Beulich <jbeulich@suse.com>
    xen/x86: prevent PVH type from getting clobbered

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    block: decode QUEUE_FLAG_HCTX_ACTIVE in debugfs output

Eugen Hristev <eugen.hristev@microchip.com>
    ARM: dts: at91: sama5d2_som1_ek: disable ISC node by default

Rob Herring <robh@kernel.org>
    arm: dts: vexpress-v2p-ca9: Fix the SMB unit-address

Kamal Mostafa <kamal@canonical.com>
    io_uring: fix splice_fd_in checks backport typo

Jonathan Bell <jonathan@raspberrypi.org>
    xhci: add quirk for host controllers that don't update endpoint DCS

Helge Deller <deller@gmx.de>
    parisc: math-emu: Fix fall-through warnings


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/Kconfig                                   |   1 +
 arch/arm/boot/dts/at91-sama5d27_som1_ek.dts        |   1 -
 arch/arm/boot/dts/spear3xx.dtsi                    |   2 +-
 arch/arm/boot/dts/vexpress-v2m.dtsi                |   2 +-
 arch/arm/boot/dts/vexpress-v2p-ca9.dts             |   2 +-
 arch/nios2/include/asm/irqflags.h                  |   4 +-
 arch/nios2/include/asm/registers.h                 |   2 +-
 arch/parisc/math-emu/fpudispatch.c                 |  56 ++++++-
 arch/powerpc/kernel/idle_book3s.S                  | 148 +++++++++---------
 arch/powerpc/kernel/smp.c                          |   2 -
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |  28 ++--
 arch/s390/include/asm/pci.h                        |   3 +
 arch/s390/pci/pci.c                                |  45 +++++-
 arch/s390/pci/pci_event.c                          |   4 +-
 arch/x86/events/msr.c                              |   1 +
 arch/x86/kvm/vmx/vmx.c                             |  17 +-
 arch/x86/xen/enlighten.c                           |   9 +-
 arch/xtensa/platforms/xtfpga/setup.c               |  12 +-
 block/blk-mq-debugfs.c                             |   1 +
 drivers/gpu/drm/amd/display/Kconfig                |   2 +
 drivers/gpu/drm/mxsfb/mxsfb_drv.c                  |   6 +-
 drivers/gpu/drm/panel/panel-ilitek-ili9881c.c      |  12 +-
 drivers/input/keyboard/snvs_pwrkey.c               |  29 ++++
 drivers/isdn/capi/kcapi.c                          |   5 +
 drivers/isdn/hardware/mISDN/netjet.c               |   2 +-
 drivers/net/can/rcar/rcar_can.c                    |  20 ++-
 drivers/net/can/sja1000/peak_pci.c                 |   9 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |   5 +-
 drivers/net/dsa/lantiq_gswip.c                     |   2 +-
 drivers/net/dsa/mt7530.c                           |   8 +-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |  21 +++
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  37 +++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   7 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |   9 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   6 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |   4 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  31 +++-
 drivers/net/ethernet/intel/e1000e/ich8lan.h        |   3 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |  29 ++--
 drivers/net/ethernet/intel/ice/ice_common.c        |   2 +
 drivers/net/ethernet/intel/ice/ice_devids.h        |   4 +
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |   4 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   2 +
 .../net/ethernet/stmicro/stmmac/dwmac-generic.c    |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   8 +
 drivers/net/phy/mdio_bus.c                         |   1 +
 drivers/net/usb/Kconfig                            |   1 +
 drivers/net/usb/usbnet.c                           |   4 +
 drivers/pci/hotplug/s390_pci_hpc.c                 |   9 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   4 +-
 drivers/platform/x86/intel_scu_ipc.c               |   2 +-
 drivers/scsi/hosts.c                               |   3 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |   2 +-
 drivers/scsi/scsi_transport_iscsi.c                |   2 -
 drivers/usb/host/xhci-pci.c                        |   4 +-
 drivers/usb/host/xhci-ring.c                       |  26 +++-
 drivers/usb/host/xhci.h                            |   1 +
 fs/btrfs/tree-log.c                                |  47 +++---
 fs/ceph/caps.c                                     |  12 +-
 fs/ceph/file.c                                     |   1 -
 fs/ceph/inode.c                                    |   2 -
 fs/ceph/mds_client.c                               |  17 +-
 fs/ceph/super.c                                    |  17 +-
 fs/ceph/super.h                                    |   3 -
 fs/io_uring.c                                      |   2 +-
 fs/kernel_read_file.c                              |   2 +-
 fs/nfsd/nfsctl.c                                   |   5 +-
 fs/ocfs2/alloc.c                                   |  46 ++----
 fs/ocfs2/super.c                                   |  14 +-
 fs/userfaultfd.c                                   |  12 +-
 include/linux/elfcore.h                            |   2 +-
 include/sound/hda_codec.h                          |   1 +
 kernel/auditsc.c                                   |   2 +-
 kernel/dma/debug.c                                 |  12 +-
 kernel/sched/core.c                                |   1 +
 kernel/trace/ftrace.c                              |   4 +-
 kernel/trace/trace.h                               |  61 +++-----
 kernel/trace/trace_functions.c                     |   2 +-
 mm/slub.c                                          |  17 +-
 net/bpf/test_run.c                                 |  14 +-
 net/bridge/br_private.h                            |   4 +-
 net/can/isotp.c                                    |  45 ++++--
 net/can/j1939/j1939-priv.h                         |   1 +
 net/can/j1939/main.c                               |   7 +-
 net/can/j1939/transport.c                          |  14 +-
 net/ipv4/tcp_ipv4.c                                |  19 ++-
 net/ipv6/ip6_output.c                              |   3 +-
 net/ipv6/netfilter/ip6t_rt.c                       |  48 +-----
 net/netfilter/Kconfig                              |   2 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   5 +
 net/netfilter/xt_IDLETIMER.c                       |   2 +-
 net/nfc/nci/rsp.c                                  |   2 +
 scripts/Makefile.gcc-plugins                       |   4 +
 sound/hda/hdac_controller.c                        |   5 +-
 sound/pci/hda/hda_bind.c                           |  20 +--
 sound/pci/hda/hda_codec.c                          |   1 +
 sound/pci/hda/hda_controller.c                     |  24 ++-
 sound/pci/hda/hda_controller.h                     |   2 +-
 sound/pci/hda/hda_intel.c                          |  29 +++-
 sound/pci/hda/hda_intel.h                          |   4 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/wm8960.c                          |  13 +-
 sound/soc/soc-dapm.c                               |  13 +-
 sound/usb/quirks-table.h                           |  32 ++++
 tools/lib/perf/tests/test-evlist.c                 |   6 +-
 tools/lib/perf/tests/test-evsel.c                  |   6 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |   2 +-
 tools/testing/selftests/net/forwarding/Makefile    |   1 +
 .../net/forwarding/forwarding.config.sample        |   2 +
 .../net/forwarding/ip6_forward_instats_vrf.sh      | 172 +++++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh      |   8 +
 tools/testing/selftests/netfilter/nft_flowtable.sh |   1 -
 118 files changed, 994 insertions(+), 479 deletions(-)


