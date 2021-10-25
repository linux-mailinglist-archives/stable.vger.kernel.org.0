Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE1043A099
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbhJYTcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235263AbhJYT3k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:29:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7033B60200;
        Mon, 25 Oct 2021 19:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189997;
        bh=RMzx8ckQvKIK2SUHZ6gWHvYV36iQACbormCM9VToE58=;
        h=From:To:Cc:Subject:Date:From;
        b=XVAh690BBEUB5Nr/diuMZ9DiQyKC4GRkaBt94OuLAutEVM6quhPfpJa6RndFekG9C
         eaN0EkSoPoUOV2mWhvfFwQg7T9LWIx/s3x0mhAvEv/wcZQ33Dro/Ixy/bnMDiMV5Gj
         OdCGvkJmOP0ChfFLYc1Pd7IjjcylT1GQLutHMa9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/58] 5.4.156-rc1 review
Date:   Mon, 25 Oct 2021 21:14:17 +0200
Message-Id: <20211025190937.555108060@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.156-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.156-rc1
X-KernelTest-Deadline: 2021-10-27T19:09+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.156 release.
There are 58 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.156-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.156-rc1

Fabien Dessenne <fabien.dessenne@foss.st.com>
    pinctrl: stm32: use valid pin identifier in stm32_pinctrl_resume()

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 9122/1: select HAVE_FUTEX_CMPXCHG

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Have all levels of checks prevent recursion

Yanfei Xu <yanfei.xu@windriver.com>
    net: mdiobus: Fix memory leak in __mdiobus_register

Oliver Neukum <oneukum@suse.com>
    usbnet: sanity check for maxpacket

Dexuan Cui <decui@microsoft.com>
    scsi: core: Fix shost->cmd_per_lun calculation in scsi_add_host_with_dma()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Input: snvs_pwrkey - add clk handling

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

Brendan Higgins <brendanhiggins@google.com>
    gcc-plugins/structleak: add makefile var for disabling structleak

Florian Westphal <fw@strlen.de>
    selftests: netfilter: remove stray bash debug line

Vegard Nossum <vegard.nossum@gmail.com>
    netfilter: Kconfig: use 'default y' instead of 'm' for bool config option

Xiaolong Huang <butterflyhuangxx@gmail.com>
    isdn: cpai: check ctr->cnr to avoid array index out of bound

Lin Ma <linma@zju.edu.cn>
    nfc: nci: fix the UAF of rf_conn_info object

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

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    ocfs2: mount fails with buffer overflow in strlen

Jan Kara <jack@suse.cz>
    ocfs2: fix data corruption after conversion from inline format

Jeff Layton <jlayton@kernel.org>
    ceph: fix handling of "meta" errors

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: j1939_xtp_rx_rts_session_new(): abort TP less than 9 bytes

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: j1939_xtp_rx_dat_one(): cancel session if receive TP.DT with error length

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: j1939: j1939_netdev_start(): fix UAF for rx_kref of j1939_priv

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: j1939: j1939_tp_rxtimer(): fix errant alert in j1939_tp_rxtimer

Zheyu Ma <zheyuma97@gmail.com>
    can: peak_pci: peak_pci_remove(): fix UAF

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: pcan_usb_fd_decode_status(): fix back to ERROR_ACTIVE state notification

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    can: rcar_can: fix suspend/resume

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: fix ethtool counter name for PM0_TERR

Kurt Kanzenbach <kurt@linutronix.de>
    net: stmmac: Fix E2E delay mechanism

Peng Li <lipeng321@huawei.com>
    net: hns3: disable sriov before unload hclge layer

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: add limit ets dwrr bandwidth cannot be 0

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: reset DWRR of unused tc to zero

Randy Dunlap <rdunlap@infradead.org>
    NIOS2: irqflags: rename a redefined register name

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: dsa: lantiq_gswip: fix register definition

Vegard Nossum <vegard.nossum@oracle.com>
    lan78xx: select CRC32

Antoine Tenart <atenart@kernel.org>
    netfilter: ipvs: make global sysctl readonly in non-init netns

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: wm8960: Fix clock configuration on slave mode

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    dma-debug: fix sg checks in debug_dma_map_sg()

Benjamin Coddington <bcodding@redhat.com>
    NFSD: Keep existing listeners on portlist error

Guenter Roeck <linux@roeck-us.net>
    xtensa: xtfpga: Try software restart before simulating CPU reset

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: xtfpga: use CONFIG_USE_OF instead of CONFIG_OF

Eugen Hristev <eugen.hristev@microchip.com>
    ARM: dts: at91: sama5d2_som1_ek: disable ISC node by default

Sumit Garg <sumit.garg@linaro.org>
    tee: optee: Fix missing devices unregister during optee_remove

Russell King <rmk+kernel@armlinux.org.uk>
    net: switchdev: do not propagate bridge updates across bridges

Helge Deller <deller@gmx.de>
    parisc: math-emu: Fix fall-through warnings


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/Kconfig                                   |   1 +
 arch/arm/boot/dts/at91-sama5d27_som1_ek.dts        |   1 -
 arch/arm/boot/dts/spear3xx.dtsi                    |   2 +-
 arch/nios2/include/asm/irqflags.h                  |   4 +-
 arch/nios2/include/asm/registers.h                 |   2 +-
 arch/parisc/math-emu/fpudispatch.c                 |  56 +++++++-
 arch/powerpc/kernel/idle_book3s.S                  | 148 +++++++++++----------
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |  28 ++--
 arch/xtensa/platforms/xtfpga/setup.c               |  12 +-
 drivers/input/keyboard/snvs_pwrkey.c               |  29 ++++
 drivers/isdn/capi/kcapi.c                          |   5 +
 drivers/isdn/hardware/mISDN/netjet.c               |   2 +-
 drivers/net/can/rcar/rcar_can.c                    |  20 +--
 drivers/net/can/sja1000/peak_pci.c                 |   9 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |   5 +-
 drivers/net/dsa/lantiq_gswip.c                     |   2 +-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |  21 +++
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |   9 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   2 +
 .../net/ethernet/stmicro/stmmac/dwmac-generic.c    |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   8 ++
 drivers/net/phy/mdio_bus.c                         |   1 +
 drivers/net/usb/Kconfig                            |   1 +
 drivers/net/usb/usbnet.c                           |   4 +
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   4 +-
 drivers/platform/x86/intel_scu_ipc.c               |   2 +-
 drivers/scsi/hosts.c                               |   3 +-
 drivers/tee/optee/core.c                           |   3 +
 drivers/tee/optee/device.c                         |  22 +++
 drivers/tee/optee/optee_private.h                  |   1 +
 fs/btrfs/tree-log.c                                |  47 ++++---
 fs/ceph/caps.c                                     |  12 +-
 fs/ceph/file.c                                     |   1 -
 fs/ceph/inode.c                                    |   2 -
 fs/ceph/mds_client.c                               |  17 +--
 fs/ceph/super.h                                    |   3 -
 fs/exec.c                                          |   2 +-
 fs/nfsd/nfsctl.c                                   |   5 +-
 fs/ocfs2/alloc.c                                   |  46 ++-----
 fs/ocfs2/super.c                                   |  14 +-
 include/linux/elfcore.h                            |   2 +-
 kernel/auditsc.c                                   |   2 +-
 kernel/dma/debug.c                                 |  12 +-
 kernel/trace/ftrace.c                              |   4 +-
 kernel/trace/trace.h                               |  64 +++------
 kernel/trace/trace_functions.c                     |   2 +-
 mm/slub.c                                          |  13 +-
 net/can/j1939/j1939-priv.h                         |   1 +
 net/can/j1939/main.c                               |   7 +-
 net/can/j1939/transport.c                          |  14 +-
 net/netfilter/Kconfig                              |   2 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   5 +
 net/nfc/nci/rsp.c                                  |   2 +
 net/switchdev/switchdev.c                          |   9 ++
 scripts/Makefile.gcc-plugins                       |   4 +
 sound/hda/hdac_controller.c                        |   5 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/wm8960.c                          |  13 +-
 sound/soc/soc-dapm.c                               |  13 +-
 sound/usb/quirks-table.h                           |  32 +++++
 tools/testing/selftests/netfilter/nft_flowtable.sh |   1 -
 66 files changed, 495 insertions(+), 280 deletions(-)


