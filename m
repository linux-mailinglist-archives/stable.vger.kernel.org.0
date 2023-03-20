Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28716C15DE
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 15:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbjCTO6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 10:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbjCTO57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 10:57:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3536E7D8B;
        Mon, 20 Mar 2023 07:56:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B705861584;
        Mon, 20 Mar 2023 14:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D171C433D2;
        Mon, 20 Mar 2023 14:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324182;
        bh=yNMeQADFi5ADqMOrBZuZPVh2bD2MxBvMcQ87QqU5iFY=;
        h=From:To:Cc:Subject:Date:From;
        b=lDl6uSdl5MH7N7DqMR7dFrdwKuGDaWdAhYKrC6vK/M5lKPn0ai3NXAbZrdxRPexO8
         yCpz5KWealVtnxCSwrlili4JUeyDRumzvgI3rApS2xc76Cc4qv6yDd6fz85YiRw9Hn
         ZX84j5UA+SBjjtUC28m1LIYKwFg66tJShw9UUGnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 000/115] 5.15.104-rc1 review
Date:   Mon, 20 Mar 2023 15:53:32 +0100
Message-Id: <20230320145449.336983711@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.104-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.104-rc1
X-KernelTest-Deadline: 2023-03-22T14:54+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.104 release.
There are 115 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Mar 2023 14:54:26 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.104-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.104-rc1

Lee Jones <lee@kernel.org>
    HID: uhid: Over-ride the default maximum data buffer value with our own

Lee Jones <lee@kernel.org>
    HID: core: Provide new max_buffer_size attribute to over-ride the default

Lukas Wunner <lukas@wunner.de>
    PCI/DPC: Await readiness of secondary bus after reset

Lukas Wunner <lukas@wunner.de>
    PCI: Unify delay handling for reset and resume

Fedor Pchelkin <pchelkin@ispras.ru>
    io_uring: avoid null-ptr-deref in io_arm_poll_handler

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915/active: Fix misuse of non-idle barriers as fence trackers

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Don't use stolen memory for ring buffers with LLC

Shawn Wang <shawnwang@linux.alibaba.com>
    x86/resctrl: Clear staged_config[] before and after it is used

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    x86/mm: Fix use of uninitialized buffer in sme_enable()

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/mce: Make sure logged MCEs are processed after sysfs update

Shawn Guo <shawn.guo@linaro.org>
    cpuidle: psci: Iterate backwards over list in psci_pd_remove()

Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
    net: phy: nxp-c45-tja11xx: fix MII_BASIC_CONFIG_REV bit

Tero Kristo <tero.kristo@linux.intel.com>
    trace/hwlat: Do not wipe the contents of per-cpu thread data

Helge Deller <deller@gmx.de>
    fbdev: stifb: Provide valid pixelclock and add fb_check_var() checks

Francesco Dolcini <francesco.dolcini@toradex.com>
    mmc: sdhci_am654: lower power-on failed message severity

David Hildenbrand <david@redhat.com>
    mm/userfaultfd: propagate uffd-wp bit when PTE-mapping the huge zeropage

Dave Ertman <david.m.ertman@intel.com>
    ice: avoid bonding causing auxiliary plug/unplug under RTNL lock

Elmer Miroslav Mosher Golovin <miroslav@mishamosher.com>
    nvme-pci: add NVME_QUIRK_BOGUS_NID for Netac NV3000

Chen Zhongjin <chenzhongjin@huawei.com>
    ftrace: Fix invalid address access in lookup_rec() when index is 0

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix lockdep false positive in mptcp_pm_nl_create_listen_socket()

Matthieu Baerts <matthieu.baerts@tessares.net>
    mptcp: avoid setting TCP_CLOSE state twice

Geliang Tang <geliang.tang@suse.com>
    mptcp: add ro_after_init for tcp{,v6}_prot_override

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix possible deadlock in subflow_error_report

Błażej Szczygieł <mumei6102@gmail.com>
    drm/amd/pm: Fix sienna cichlid incorrect OD volage after resume

Johan Hovold <johan+linaro@kernel.org>
    drm/sun4i: fix missing component unbind on bind errors

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/shmem-helper: Remove another errant put in error path

Guo Ren <guoren@linux.alibaba.com>
    riscv: asid: Fixup stale TLB entry cause application crash

Sergey Matyukevich <sergey.matyukevich@syntacore.com>
    Revert "riscv: mm: notify remote harts about mmu cache updates"

Hamidreza H. Fard <nitocris@posteo.net>
    ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book2 Pro

Bard Liao <yung-chuan.liao@linux.intel.com>
    ALSA: hda: intel-dsp-config: add MTL PCI id

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: add missing consistency checks for CR0 and CR4

Volker Lendecke <vl@samba.org>
    cifs: Fix smb2_set_path_size()

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Make tracepoint lockdep check actually test something

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Check field value in hist_field_name()

Sung-hun Kim <sfoon.kim@samsung.com>
    tracing: Make splice_read available again

Johan Hovold <johan+linaro@kernel.org>
    interconnect: exynos: fix node leak in probe PM QoS error path

Johan Hovold <johan+linaro@kernel.org>
    interconnect: fix mem leak when freeing nodes

Sven Schnelle <svens@linux.ibm.com>
    s390/ipl: add missing intersection check to ipl_report handling

Roman Gushchin <roman.gushchin@linux.dev>
    firmware: xilinx: don't make a sleepable memory allocation from an atomic context

Johan Hovold <johan@kernel.org>
    serial: 8250_fsl: fix handle_irq locking

Biju Das <biju.das.jz@bp.renesas.com>
    serial: 8250_em: Fix UART port type

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: skip waiting for transmission complete when UARTCTRL_SBK is asserted

Theodore Ts'o <tytso@mit.edu>
    ext4: fix possible double unlock when moving a directory

Alex Hung <alex.hung@amd.com>
    drm/amd/display: fix shift-out-of-bounds in CalculateVMAndRowBytes

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sh: intc: Avoid spurious sizeof-pointer-div warning

Eric Van Hensbergen <ericvh@kernel.org>
    net/9p: fix bug in client create for .L

Qu Huang <qu.huang@linux.dev>
    drm/amdkfd: Fix an illegal memory access

Baokun Li <libaokun1@huawei.com>
    ext4: fix task hung in ext4_xattr_delete_inode

Baokun Li <libaokun1@huawei.com>
    ext4: update s_journal_inum if it changes after journal replay

Baokun Li <libaokun1@huawei.com>
    ext4: fail ext4_iget if special inode unallocated

David Gow <davidgow@google.com>
    rust: arch/um: Disable FP/SIMD instruction to match x86

Yifei Liu <yifeliu@cs.stonybrook.edu>
    jffs2: correct logic when creating a hole in jffs2_write_begin

Tobias Schramm <t.schramm@manjaro.org>
    mmc: atmel-mci: fix race between stop command and start of next command

Linus Torvalds <torvalds@linux-foundation.org>
    media: m5mols: fix off-by-one loop termination error

Lars-Peter Clausen <lars@metafoo.de>
    hwmon: (ltc2992) Set `can_sleep` flag for GPIO chip

Lars-Peter Clausen <lars@metafoo.de>
    hwmon: (adm1266) Set `can_sleep` flag for GPIO chip

Jurica Vukadin <jura@vukad.in>
    kconfig: Update config changed flag before calling callback

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    hwmon: tmp512: drop of_match_ptr for ID table

Lars-Peter Clausen <lars@metafoo.de>
    hwmon: (ucd90320) Add minimum delay between bus accesses

Marcus Folkesson <marcus.folkesson@gmail.com>
    hwmon: (ina3221) return prober error code

Zheng Wang <zyytlz.wz@163.com>
    hwmon: (xgene) Fix use after free bug in xgene_hwmon_remove due to race condition

Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
    hwmon: (adt7475) Fix masking of hysteresis registers

Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
    hwmon: (adt7475) Display smoothing attributes in correct order

Nikolay Aleksandrov <razor@blackwall.org>
    bonding: restore bond's IFF_SLAVE flag if a non-eth dev enslave fails

Nikolay Aleksandrov <razor@blackwall.org>
    bonding: restore IFF_MASTER/SLAVE flags on bond enslave ether type change

Liang He <windhl@126.com>
    ethernet: sun: add check for the mdesc_grab()

Daniil Tatianin <d-tatianin@yandex-team.ru>
    qed/qed_mng_tlv: correctly zero out ->min instead of ->hour

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: net: devlink_port_split.py: skip test if no suitable device available

Alexandra Winter <wintera@linux.ibm.com>
    net/iucv: Fix size of interrupt data

Szymon Heidrich <szymon.heidrich@gmail.com>
    net: usb: smsc75xx: Move packet length check to prevent kernel panic in skb_pull

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix incorrect table ID in IOCTL path

Wolfram Sang <wsa+renesas@sang-engineering.com>
    sh_eth: avoid PHY being resumed when interface is not up

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ravb: avoid PHY being resumed when interface is not up

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250, 6290

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: disable txq irq before flushing hw

Liang He <windhl@126.com>
    block: sunvdc: add check for mdesc_grab() returning NULL

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    nvmet: avoid potential UAF in nvmet_req_complete()

Ming Lei <ming.lei@redhat.com>
    nvme: fix handling single range discard request

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    block: null_blk: Fix handling of fake timeout request

Liu Ying <victor.liu@nxp.com>
    drm/bridge: Fix returned array size name for atomic_get_input_bus_fmts kdoc

Szymon Heidrich <szymon.heidrich@gmail.com>
    net: usb: smsc75xx: Limit packet length to skb->len

Wenjia Zhang <wenjia@linux.ibm.com>
    net/smc: fix deadlock triggered by cancel_delayed_work_syn()

Zheng Wang <zyytlz.wz@163.com>
    nfc: st-nci: Fix use after free bug in ndlc_remove due to race condition

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: smsc: bail out in lan87xx_read_status if genphy_read_status fails

Eric Dumazet <edumazet@google.com>
    net: tunnels: annotate lockless accesses to dev->needed_headroom

Bart Van Assche <bvanassche@acm.org>
    loop: Fix use-after-free issues

Arınç ÜNAL <arinc.unal@arinc9.com>
    net: dsa: mt7530: set PLL frequency and trgmii only when trgmii is used

Arınç ÜNAL <arinc.unal@arinc9.com>
    net: dsa: mt7530: remove now incorrect comment regarding port 5

Daniil Tatianin <d-tatianin@yandex-team.ru>
    qed/qed_dev: guard against a possible division by zero

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix NULL sndbuf_desc in smc_cdc_tx_handler()

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Use calculated io and fast wake lines

Tom Rix <trix@redhat.com>
    drm/i915/display: clean up comments

José Roberto de Souza <jose.souza@intel.com>
    drm/i915/display/psr: Handle plane and pipe restrictions at every page flip

José Roberto de Souza <jose.souza@intel.com>
    drm/i915/display/psr: Use drm damage helpers to calculate plane damaged area

José Roberto de Souza <jose.souza@intel.com>
    drm/i915/display: Workaround cursor left overs with PSR2 selective fetch enabled

Niklas Schnelle <schnelle@linux.ibm.com>
    PCI: s390: Fix use-after-free of PCI resources with per-function hotplug

Eugenio Pérez <eperezma@redhat.com>
    vdpa_sim: set last_used_idx as last_avail_idx in vdpasim_queue_ready

Eugenio Pérez <eperezma@redhat.com>
    vdpa_sim: not reset state in vdpasim_queue_ready

Ivan Vecera <ivecera@redhat.com>
    i40e: Fix kernel crash during reboot when adapter is in recovery mode

Jianguo Wu <wujianguo@chinatelecom.cn>
    ipvlan: Make skb->skb_iif track skb->dev for l3s mode

Fedor Pchelkin <pchelkin@ispras.ru>
    nfc: pn533: initialize struct pn533_out_arg properly

Breno Leitao <leitao@debian.org>
    tcp: tcp_make_synack() can be called from process context

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Fix a procfs host directory removal regression

Jeremy Sowden <jeremy@azazel.net>
    netfilter: nft_redir: correct value of inet type `.maxattrs`

Jeremy Sowden <jeremy@azazel.net>
    netfilter: nft_redir: correct length for loading protocol registers

Jeremy Sowden <jeremy@azazel.net>
    netfilter: nft_masq: correct length for loading protocol registers

Jeremy Sowden <jeremy@azazel.net>
    netfilter: nft_nat: correct length for loading protocol registers

Bjorn Helgaas <bhelgaas@google.com>
    ALSA: hda: Match only Intel devices with CONTROLLER_IN_GPU()

Wenchao Hao <haowenchao2@huawei.com>
    scsi: mpt3sas: Fix NULL pointer access in mpt3sas_transport_port_add()

Glenn Washburn <development@efficientek.com>
    docs: Correct missing "d_" prefix for dentry_operations member d_weak_revalidate

Randy Dunlap <rdunlap@infradead.org>
    clk: HI655X: select REGMAP instead of depending on it

Christian Hewitt <christianshewitt@gmail.com>
    drm/meson: fix 1px pink line on GXM when scaling video overlay

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Move the in_send statistic to __smb_send_rqst()

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/panfrost: Don't sync rpm suspension after mmu flushing

Herbert Xu <herbert@gondor.apana.org.au>
    xfrm: Allow transport-mode states with AF_UNSPEC selector


-------------

Diffstat:

 Documentation/filesystems/vfs.rst                  |   2 +-
 Makefile                                           |   4 +-
 arch/riscv/include/asm/mmu.h                       |   2 -
 arch/riscv/include/asm/tlbflush.h                  |  18 --
 arch/riscv/mm/context.c                            |  40 ++--
 arch/riscv/mm/tlbflush.c                           |  28 +--
 arch/s390/boot/ipl_report.c                        |   8 +
 arch/s390/pci/pci.c                                |  16 +-
 arch/s390/pci/pci_bus.c                            |  12 +-
 arch/s390/pci/pci_bus.h                            |   3 +-
 arch/x86/Makefile.um                               |   6 +
 arch/x86/kernel/cpu/mce/core.c                     |   1 +
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c          |   7 +-
 arch/x86/kernel/cpu/resctrl/internal.h             |   1 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  25 ++-
 arch/x86/kvm/vmx/nested.c                          |  10 +-
 arch/x86/mm/mem_encrypt_identity.c                 |   3 +-
 drivers/block/loop.c                               |  25 ++-
 drivers/block/null_blk/main.c                      |   6 +-
 drivers/block/sunvdc.c                             |   2 +
 drivers/clk/Kconfig                                |   2 +-
 drivers/cpuidle/cpuidle-psci-domain.c              |   3 +-
 drivers/firmware/xilinx/zynqmp.c                   |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |   9 +-
 .../amd/display/dc/dml/dcn30/display_mode_vba_30.c |   5 +-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |  43 ++++-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |   9 +-
 drivers/gpu/drm/i915/display/intel_display_types.h |   2 +
 drivers/gpu/drm/i915/display/intel_psr.c           | 207 +++++++++++++++------
 drivers/gpu/drm/i915/gt/intel_ring.c               |   2 +-
 drivers/gpu/drm/i915/i915_active.c                 |  24 +--
 drivers/gpu/drm/meson/meson_vpp.c                  |   2 +
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |   2 +-
 drivers/gpu/drm/sun4i/sun4i_drv.c                  |   6 +-
 drivers/hid/hid-core.c                             |  18 +-
 drivers/hid/uhid.c                                 |   1 +
 drivers/hwmon/adt7475.c                            |   8 +-
 drivers/hwmon/ina3221.c                            |   2 +-
 drivers/hwmon/ltc2992.c                            |   1 +
 drivers/hwmon/pmbus/adm1266.c                      |   1 +
 drivers/hwmon/pmbus/ucd9000.c                      |  75 ++++++++
 drivers/hwmon/tmp513.c                             |   2 +-
 drivers/hwmon/xgene-hwmon.c                        |   1 +
 drivers/interconnect/core.c                        |   4 +
 drivers/interconnect/samsung/exynos.c              |   6 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |   2 +-
 drivers/mmc/host/atmel-mci.c                       |   3 -
 drivers/mmc/host/sdhci_am654.c                     |   2 +-
 drivers/net/bonding/bond_main.c                    |  23 ++-
 drivers/net/dsa/mt7530.c                           |  64 +++----
 drivers/net/dsa/mv88e6xxx/chip.c                   |  16 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   1 +
 drivers/net/ethernet/intel/ice/ice.h               |  14 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  19 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |   5 +
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c      |   2 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  12 +-
 drivers/net/ethernet/renesas/sh_eth.c              |  12 +-
 drivers/net/ethernet/sun/ldmvsw.c                  |   3 +
 drivers/net/ethernet/sun/sunvnet.c                 |   3 +
 drivers/net/ipvlan/ipvlan_l3s.c                    |   1 +
 drivers/net/phy/nxp-c45-tja11xx.c                  |   2 +-
 drivers/net/phy/smsc.c                             |   5 +-
 drivers/net/usb/smsc75xx.c                         |   7 +
 drivers/nfc/pn533/usb.c                            |   1 +
 drivers/nfc/st-nci/ndlc.c                          |   6 +-
 drivers/nvme/host/core.c                           |  28 ++-
 drivers/nvme/host/pci.c                            |   2 +
 drivers/nvme/target/core.c                         |   4 +-
 drivers/pci/bus.c                                  |  21 +++
 drivers/pci/pci-driver.c                           |   4 +-
 drivers/pci/pci.c                                  |  57 +++---
 drivers/pci/pci.h                                  |  16 +-
 drivers/pci/pcie/dpc.c                             |   4 +-
 drivers/scsi/hosts.c                               |   3 -
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |  14 +-
 drivers/tty/serial/8250/8250_em.c                  |   4 +-
 drivers/tty/serial/8250/8250_fsl.c                 |   4 +-
 drivers/tty/serial/fsl_lpuart.c                    |  12 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |  13 ++
 drivers/video/fbdev/stifb.c                        |  27 +++
 fs/cifs/smb2inode.c                                |  31 ++-
 fs/cifs/transport.c                                |  21 +--
 fs/ext4/inode.c                                    |  18 +-
 fs/ext4/namei.c                                    |   4 +-
 fs/ext4/super.c                                    |   7 +-
 fs/ext4/xattr.c                                    |  11 ++
 fs/jffs2/file.c                                    |  15 +-
 include/drm/drm_bridge.h                           |   4 +-
 include/linux/hid.h                                |   3 +
 include/linux/netdevice.h                          |   6 +-
 include/linux/pci.h                                |   1 +
 include/linux/sh_intc.h                            |   5 +-
 include/linux/tracepoint.h                         |  15 +-
 io_uring/io_uring.c                                |   4 +-
 kernel/trace/ftrace.c                              |   3 +-
 kernel/trace/trace.c                               |   2 +
 kernel/trace/trace_events_hist.c                   |   3 +
 kernel/trace/trace_hwlat.c                         |   3 -
 mm/huge_memory.c                                   |   6 +-
 net/9p/client.c                                    |   2 +-
 net/ipv4/fib_frontend.c                            |   3 +
 net/ipv4/ip_tunnel.c                               |  12 +-
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv6/ip6_tunnel.c                              |   4 +-
 net/iucv/iucv.c                                    |   2 +-
 net/mptcp/pm_netlink.c                             |  16 ++
 net/mptcp/subflow.c                                |  12 +-
 net/netfilter/nft_masq.c                           |   2 +-
 net/netfilter/nft_nat.c                            |   2 +-
 net/netfilter/nft_redir.c                          |   4 +-
 net/smc/smc_cdc.c                                  |   3 +
 net/smc/smc_core.c                                 |   2 +-
 net/xfrm/xfrm_state.c                              |   3 -
 scripts/kconfig/confdata.c                         |   6 +-
 sound/hda/intel-dsp-config.c                       |   9 +
 sound/pci/hda/hda_intel.c                          |   5 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 tools/testing/selftests/net/devlink_port_split.py  |  36 +++-
 120 files changed, 925 insertions(+), 439 deletions(-)


