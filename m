Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D007F6C15DC
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 15:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjCTO6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 10:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbjCTO56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 10:57:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01C93A89;
        Mon, 20 Mar 2023 07:56:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89A04B80D34;
        Mon, 20 Mar 2023 14:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4A2C433D2;
        Mon, 20 Mar 2023 14:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324176;
        bh=ZiTMKlbR0J/R6uBW2pq+QJR8b4rPR3ce7YthXtUyDd8=;
        h=From:To:Cc:Subject:Date:From;
        b=gaBU9NWKazGYLFNYYu071FQ6sOOeXk/8nnZ+7M74H7iCjBlX1jXFRdw4aFaXbUyVS
         k/dDzpSBls6siQfCfCM8euZBL6yzhUOibY9ReWbWY66E/4S76U4sWeeEIa64ktqRiR
         vWnxxuNF1ucFR8x+P2CcKx1WOwT0NvBx43Q47LXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 00/99] 5.10.176-rc1 review
Date:   Mon, 20 Mar 2023 15:53:38 +0100
Message-Id: <20230320145443.333824603@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.176-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.176-rc1
X-KernelTest-Deadline: 2023-03-22T14:54+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.176 release.
There are 99 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Mar 2023 14:54:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.176-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.176-rc1

Lee Jones <lee@kernel.org>
    HID: uhid: Over-ride the default maximum data buffer value with our own

Lee Jones <lee@kernel.org>
    HID: core: Provide new max_buffer_size attribute to over-ride the default

Gaosheng Cui <cuigaosheng1@huawei.com>
    xfs: remove xfs_setattr_time() declaration

Christian Brauner <brauner@kernel.org>
    fs: use consistent setgid checks in is_sxid()

Amir Goldstein <amir73il@gmail.com>
    attr: use consistent sgid stripping checks

Amir Goldstein <amir73il@gmail.com>
    attr: add setattr_should_drop_sgid()

Amir Goldstein <amir73il@gmail.com>
    fs: move should_remove_suid()

Amir Goldstein <amir73il@gmail.com>
    attr: add in_group_or_capable()

Yang Xu <xuyang2018.jy@fujitsu.com>
    fs: move S_ISGID stripping into the vfs_*() helpers

Yang Xu <xuyang2018.jy@fujitsu.com>
    fs: add mode_strip_sgid() helper

Darrick J. Wong <djwong@kernel.org>
    xfs: use setattr_copy to set vfs inode attributes

Dave Chinner <dchinner@redhat.com>
    xfs: set prealloc flag in xfs_alloc_file_space()

Dave Chinner <dchinner@redhat.com>
    xfs: fallocate() should call file_modified()

Dave Chinner <dchinner@redhat.com>
    xfs: remove XFS_PREALLOC_SYNC

Darrick J. Wong <djwong@kernel.org>
    xfs: don't leak btree cursor when insrec fails after a split

Darrick J. Wong <djwong@kernel.org>
    xfs: purge dquots after inode walk fails during quotacheck

Dave Chinner <dchinner@redhat.com>
    xfs: don't assert fail on perag references on teardown

Lukas Wunner <lukas@wunner.de>
    PCI/DPC: Await readiness of secondary bus after reset

Lukas Wunner <lukas@wunner.de>
    PCI: Unify delay handling for reset and resume

Sven Schnelle <svens@linux.ibm.com>
    s390/ipl: add missing intersection check to ipl_report handling

Fedor Pchelkin <pchelkin@ispras.ru>
    io_uring: avoid null-ptr-deref in io_arm_poll_handler

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915/active: Fix misuse of non-idle barriers as fence trackers

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Don't use stolen memory for ring buffers with LLC

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    x86/mm: Fix use of uninitialized buffer in sme_enable()

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/mce: Make sure logged MCEs are processed after sysfs update

Shawn Guo <shawn.guo@linaro.org>
    cpuidle: psci: Iterate backwards over list in psci_pd_remove()

Helge Deller <deller@gmx.de>
    fbdev: stifb: Provide valid pixelclock and add fb_check_var() checks

Francesco Dolcini <francesco.dolcini@toradex.com>
    mmc: sdhci_am654: lower power-on failed message severity

David Hildenbrand <david@redhat.com>
    mm/userfaultfd: propagate uffd-wp bit when PTE-mapping the huge zeropage

Chen Zhongjin <chenzhongjin@huawei.com>
    ftrace: Fix invalid address access in lookup_rec() when index is 0

Matthieu Baerts <matthieu.baerts@tessares.net>
    mptcp: avoid setting TCP_CLOSE state twice

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/shmem-helper: Remove another errant put in error path

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
    interconnect: fix mem leak when freeing nodes

Roman Gushchin <roman.gushchin@linux.dev>
    firmware: xilinx: don't make a sleepable memory allocation from an atomic context

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

Qu Huang <qu.huang@linux.dev>
    drm/amdkfd: Fix an illegal memory access

Baokun Li <libaokun1@huawei.com>
    ext4: fix task hung in ext4_xattr_delete_inode

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
    hwmon: (adm1266) Set `can_sleep` flag for GPIO chip

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

Damien Le Moal <damien.lemoal@wdc.com>
    null_blk: Move driver into its own directory

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

Daniil Tatianin <d-tatianin@yandex-team.ru>
    qed/qed_dev: guard against a possible division by zero

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix NULL sndbuf_desc in smc_cdc_tx_handler()

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

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: core: Fix a comment in function scsi_host_dev_release()

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

 Documentation/filesystems/vfs.rst                  |  2 +-
 Documentation/trace/ftrace.rst                     |  2 +-
 Makefile                                           |  4 +-
 arch/s390/boot/ipl_report.c                        |  8 +++
 arch/x86/Makefile.um                               |  6 ++
 arch/x86/kernel/cpu/mce/core.c                     |  1 +
 arch/x86/kvm/vmx/nested.c                          | 10 ++-
 arch/x86/mm/mem_encrypt_identity.c                 |  3 +-
 drivers/block/Kconfig                              |  8 +--
 drivers/block/Makefile                             |  7 +-
 drivers/block/null_blk/Kconfig                     | 12 ++++
 drivers/block/null_blk/Makefile                    | 11 +++
 drivers/block/{null_blk_main.c => null_blk/main.c} |  6 +-
 drivers/block/{ => null_blk}/null_blk.h            |  0
 .../block/{null_blk_trace.c => null_blk/trace.c}   |  2 +-
 .../block/{null_blk_trace.h => null_blk/trace.h}   |  2 +-
 .../block/{null_blk_zoned.c => null_blk/zoned.c}   |  2 +-
 drivers/block/sunvdc.c                             |  2 +
 drivers/clk/Kconfig                                |  2 +-
 drivers/cpuidle/cpuidle-psci-domain.c              |  3 +-
 drivers/firmware/xilinx/zynqmp.c                   |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |  9 +--
 .../amd/display/dc/dml/dcn30/display_mode_vba_30.c |  5 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |  9 ++-
 drivers/gpu/drm/i915/gt/intel_ring.c               |  2 +-
 drivers/gpu/drm/i915/i915_active.c                 | 24 ++++---
 drivers/gpu/drm/meson/meson_vpp.c                  |  2 +
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |  2 +-
 drivers/hid/hid-core.c                             | 18 +++--
 drivers/hid/uhid.c                                 |  1 +
 drivers/hwmon/adt7475.c                            |  8 +--
 drivers/hwmon/ina3221.c                            |  2 +-
 drivers/hwmon/pmbus/adm1266.c                      |  1 +
 drivers/hwmon/pmbus/ucd9000.c                      | 75 ++++++++++++++++++++
 drivers/hwmon/tmp513.c                             |  2 +-
 drivers/hwmon/xgene-hwmon.c                        |  1 +
 drivers/interconnect/core.c                        |  4 ++
 drivers/media/i2c/m5mols/m5mols_core.c             |  2 +-
 drivers/mmc/host/atmel-mci.c                       |  3 -
 drivers/mmc/host/sdhci_am654.c                     |  2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   | 16 +++--
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  4 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  5 ++
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c      |  2 +-
 drivers/net/ethernet/sun/ldmvsw.c                  |  3 +
 drivers/net/ethernet/sun/sunvnet.c                 |  3 +
 drivers/net/ipvlan/ipvlan_l3s.c                    |  1 +
 drivers/net/phy/smsc.c                             |  5 +-
 drivers/net/usb/smsc75xx.c                         |  7 ++
 drivers/nfc/pn533/usb.c                            |  1 +
 drivers/nfc/st-nci/ndlc.c                          |  6 +-
 drivers/nvme/host/core.c                           | 28 +++++---
 drivers/nvme/target/core.c                         |  4 +-
 drivers/pci/pci-driver.c                           |  4 +-
 drivers/pci/pci.c                                  | 57 +++++++--------
 drivers/pci/pci.h                                  | 16 ++++-
 drivers/pci/pcie/dpc.c                             |  4 +-
 drivers/scsi/hosts.c                               |  5 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           | 14 +++-
 drivers/tty/serial/8250/8250_em.c                  |  4 +-
 drivers/tty/serial/fsl_lpuart.c                    | 12 +++-
 drivers/video/fbdev/stifb.c                        | 27 ++++++++
 fs/attr.c                                          | 70 +++++++++++++++++--
 fs/cifs/smb2inode.c                                | 31 +++++++--
 fs/cifs/transport.c                                | 21 +++---
 fs/ext4/inode.c                                    | 18 +++--
 fs/ext4/namei.c                                    |  4 +-
 fs/ext4/xattr.c                                    | 11 +++
 fs/inode.c                                         | 80 +++++++++++++---------
 fs/internal.h                                      |  6 ++
 fs/jffs2/file.c                                    | 15 ++--
 fs/namei.c                                         | 80 ++++++++++++++++++----
 fs/ocfs2/file.c                                    |  4 +-
 fs/ocfs2/namei.c                                   |  1 +
 fs/open.c                                          |  6 +-
 fs/xfs/libxfs/xfs_btree.c                          |  8 ++-
 fs/xfs/xfs_bmap_util.c                             |  9 +--
 fs/xfs/xfs_file.c                                  | 24 +++----
 fs/xfs/xfs_iops.c                                  | 56 +--------------
 fs/xfs/xfs_iops.h                                  |  1 -
 fs/xfs/xfs_mount.c                                 |  3 +-
 fs/xfs/xfs_pnfs.c                                  |  9 ++-
 fs/xfs/xfs_qm.c                                    |  9 ++-
 include/drm/drm_bridge.h                           |  4 +-
 include/linux/fs.h                                 |  5 +-
 include/linux/hid.h                                |  3 +
 include/linux/netdevice.h                          |  6 +-
 include/linux/sh_intc.h                            |  5 +-
 include/linux/tracepoint.h                         | 15 ++--
 io_uring/io_uring.c                                |  4 +-
 kernel/trace/ftrace.c                              |  3 +-
 kernel/trace/trace.c                               |  2 +
 kernel/trace/trace_events_hist.c                   |  3 +
 mm/huge_memory.c                                   |  6 +-
 net/ipv4/fib_frontend.c                            |  3 +
 net/ipv4/ip_tunnel.c                               | 12 ++--
 net/ipv4/tcp_output.c                              |  2 +-
 net/ipv6/ip6_tunnel.c                              |  4 +-
 net/iucv/iucv.c                                    |  2 +-
 net/mptcp/subflow.c                                |  1 -
 net/netfilter/nft_masq.c                           |  2 +-
 net/netfilter/nft_nat.c                            |  2 +-
 net/netfilter/nft_redir.c                          |  4 +-
 net/smc/smc_cdc.c                                  |  3 +
 net/smc/smc_core.c                                 |  2 +-
 net/xfrm/xfrm_state.c                              |  3 -
 sound/hda/intel-dsp-config.c                       |  9 +++
 sound/pci/hda/hda_intel.c                          |  5 +-
 sound/pci/hda/patch_realtek.c                      |  1 +
 tools/testing/selftests/net/devlink_port_split.py  | 30 ++++++++
 111 files changed, 743 insertions(+), 360 deletions(-)


