Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4913960FD9A
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235611AbiJ0Q4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235770AbiJ0Q4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:56:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921AEE09A1;
        Thu, 27 Oct 2022 09:55:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F8FC623F0;
        Thu, 27 Oct 2022 16:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B9CC433C1;
        Thu, 27 Oct 2022 16:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889757;
        bh=w6WkGPxBZvo3SQDS+jjrR1Ze/1A6vpNBtjnFrw0pcWw=;
        h=From:To:Cc:Subject:Date:From;
        b=qkaye63rQXHnZ0whlf0QEI7GfvgVSjjtT51EMjjRXOoz6K959c/TkilbQBiuFd4rl
         9b2eqz96h9dJBlZOxNZj6wa2R/wZrY3WRdwEG/DSR17Lg555t2hL2Ky2G6xPkdtO50
         tm3acDy1QYu1pZbW/BuAGDCHUIuZD08s/1NrW3Tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: [PATCH 6.0 00/94] 6.0.6-rc1 review
Date:   Thu, 27 Oct 2022 18:54:02 +0200
Message-Id: <20221027165057.208202132@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.0.6-rc1
X-KernelTest-Deadline: 2022-10-29T16:51+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.0.6 release.
There are 94 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.0.6-rc1

Seth Jenkins <sethjenkins@google.com>
    mm: /proc/pid/smaps_rollup: fix no vma's null-deref

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Force backlight native for more TongFang devices

Ye Bin <yebin10@huawei.com>
    ext4: fix potential out of bound read in ext4_fc_replay_scan()

Ye Bin <yebin10@huawei.com>
    ext4: factor out ext4_fc_get_tl()

Ye Bin <yebin10@huawei.com>
    ext4: introduce EXT4_FC_TAG_BASE_LEN helper

Jens Axboe <axboe@kernel.dk>
    io_uring: don't gate task_work run on TIF_NOTIFY_SIGNAL

Deren Wu <deren.wu@mediatek.com>
    wifi: mt76: mt7921e: fix random fw download fail

Jerry Snitselaar <jsnitsel@redhat.com>
    iommu/vt-d: Clean up si_domain in the init_dmars() error path

Charlotte Tan <charlotte@extrahop.com>
    iommu/vt-d: Allow NVS regions in arch_rmrr_sanity_check()

Daniel Bristot de Oliveira <bristot@kernel.org>
    rv/dot2c: Make automaton definition static

Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
    drbd: only clone bio if we have a backing device

Felix Riemann <felix.riemann@sma.de>
    net: phy: dp83822: disable MDI crossover status change interrupt

Eric Dumazet <edumazet@google.com>
    net: sched: fix race condition in qdisc_graft()

Yang Yingliang <yangyingliang@huawei.com>
    net: hns: fix possible memory leak in hnae_ae_register()

Yang Yingliang <yangyingliang@huawei.com>
    wwan_hwsim: fix possible memory leak in wwan_hwsim_dev_new()

Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
    sfc: include vport_id in filter spec hash and equal()

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    io_uring/msg_ring: Fix NULL pointer dereference in io_msg_send_fd()

Paul Blakey <paulb@nvidia.com>
    net: Fix return value of qdisc ingress handling on success

Zhengchao Shao <shaozhengchao@huawei.com>
    net: sched: sfb: fix null pointer access issue when sfb_init() fails

Zhengchao Shao <shaozhengchao@huawei.com>
    net: sched: delete duplicate cleanup of backlog and qlen

Zhengchao Shao <shaozhengchao@huawei.com>
    net: sched: cake: fix null pointer access issue when cake_init() fails

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix workqueue MEM_RECLAIM flushing dependency

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    nvme-hwmon: kmalloc the NVME SMART log buffer

Christoph Hellwig <hch@lst.de>
    nvme-hwmon: consistently ignore errors from nvme_hwmon_init

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: relax NFTA_SET_ELEM_KEY_END set flags requirements

Guillaume Nault <gnault@redhat.com>
    netfilter: rpfilter/fib: Set ->flowic_uid correctly for user namespaces.

Phil Sutter <phil@nwl.cc>
    netfilter: rpfilter/fib: Populate flowic_l3mdev field

Brett Creeley <brett@pensando.io>
    ionic: catch NULL pointer issue on reconfig

Eric Dumazet <edumazet@google.com>
    net: hsr: avoid possible NULL deref in skb_clone()

Vikas Gupta <vikas.gupta@broadcom.com>
    bnxt_en: fix memory leak in bnxt_nvm_test()

Guenter Roeck <linux@roeck-us.net>
    drm/amd/display: Increase frame size limit for display_mode_vba_util_32.o

Genjian Zhang <zhanggenjian@kylinos.cn>
    dm: remove unnecessary assignment statement in alloc_dev()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix memory leak when build ntlmssp negotiate blob failed

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix xid leak in cifs_ses_add_channel()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix xid leak in cifs_flock()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix xid leak in cifs_copy_file_range()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix xid leak in cifs_create()

Zhengchao Shao <shaozhengchao@huawei.com>
    ip6mr: fix UAF issue in ip6mr_sk_done() when addrconf_init_net() failed

Kuniyuki Iwashima <kuniyu@amazon.com>
    udp: Update reuse->has_conns under reuseport_lock.

Rafael Mendonca <rafaelmendsr@gmail.com>
    scsi: lpfc: Fix memory leak in lpfc_create_port()

Yang Yingliang <yangyingliang@huawei.com>
    net: ethernet: mtk_eth_wed: add missing of_node_put()

Yang Yingliang <yangyingliang@huawei.com>
    net: ethernet: mtk_eth_wed: add missing put_device() in mtk_wed_add_hw()

Yang Yingliang <yangyingliang@huawei.com>
    net: ethernet: mtk_eth_soc: fix possible memory leak in mtk_probe()

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: remove leftover debug statement

Yu Kuai <yukuai3@huawei.com>
    blk-mq: fix null pointer dereference in blk_mq_clear_rq_mapping()

Gao Xiang <xiang@kernel.org>
    erofs: shouldn't churn the mapping page for duplicated copies

Eric Dumazet <edumazet@google.com>
    skmsg: pass gfp argument to alloc_sk_msg()

Shenwei Wang <shenwei.wang@nxp.com>
    net: stmmac: Enable mac_managed_pm phylink config

Shenwei Wang <shenwei.wang@nxp.com>
    net: phylink: add mac_managed_pm in phylink_config structure

Dan Carpenter <dan.carpenter@oracle.com>
    net/smc: Fix an error code in smc_lgr_create()

Harini Katakam <harini.katakam@amd.com>
    net: phy: dp83867: Extend RX strap quirk for SGMII mode

Xiaobo Liu <cppcoffee@gmail.com>
    net/atm: fix proc_mpc_write incorrect return value

Jonathan Cooper <jonathan.s.cooper@amd.com>
    sfc: Change VF mac via PF as first preference if available.

José Expósito <jose.exposito89@gmail.com>
    HID: magicmouse: Do not set BTN_MOUSE on double report

Jakub Kicinski <kuba@kernel.org>
    tls: strp: make sure the TCP skbs do not have overlapping data

Jan Sokolowski <jan.sokolowski@intel.com>
    i40e: Fix DMA mappings leak

Christian Marangi <ansuelsmth@gmail.com>
    net: dsa: qca8k: fix ethtool autocast mib for big-endian systems

Christian Marangi <ansuelsmth@gmail.com>
    net: dsa: qca8k: fix inband mgmt for big-endian systems

Alexander Potapenko <glider@google.com>
    tipc: fix an information leak in tipc_topsrv_kern_subscr

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    tipc: Fix recognition of trial period

Tony Luck <tony.luck@intel.com>
    ACPI: extlog: Handle multiple records

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Enforce the minimum rate at runtime_resume

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: Add module dependency on hdmi-codec

Filipe Manana <fdmanana@suse.com>
    btrfs: fix processing of delayed tree block refs during backref walking

Filipe Manana <fdmanana@suse.com>
    btrfs: fix processing of delayed data refs during backref walking

Mikulas Patocka <mpatocka@redhat.com>
    dm bufio: use the acquire memory barrier when testing for B_READING

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd: pmc: Read SMU version during suspend on Cezanne systems

Zhang Rui <rui.zhang@intel.com>
    x86/topology: Fix duplicated core ID within a package

Zhang Rui <rui.zhang@intel.com>
    x86/topology: Fix multiple packages shown on a single-package system

Nathan Chancellor <nathan@kernel.org>
    x86/Kconfig: Drop check for -mabi=ms for CONFIG_EFI_STUB

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: venus: Fix NV12 decoder buffer discovery on HFI_VERSION_1XX

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: venus: dec: Handle the case where find_format fails

Sean Young <sean@mess.org>
    media: mceusb: set timeout to at least timeout provided

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ipu3-imgu: Fix NULL pointer dereference in active selection access

Eric Ren <renzhengeek@gmail.com>
    KVM: arm64: vgic: Fix exit condition in scan_its_table()

Alexander Graf <graf@amazon.com>
    KVM: x86: Add compat handler for KVM_X86_SET_MSR_FILTER

Alexander Graf <graf@amazon.com>
    KVM: x86: Copy filter arg outside kvm_vm_ioctl_set_msr_filter()

Alexander Graf <graf@amazon.com>
    kvm: Add support for arch compat vm ioctls

Rik van Riel <riel@surriel.com>
    mm,hugetlb: take hugetlb_lock before decrementing h->resv_huge_pages

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix sdma doorbell init ordering on APUs

Fabien Parent <fabien.parent@linaro.org>
    cpufreq: qcom: fix memory leak in error path

Babu Moger <babu.moger@amd.com>
    x86/resctrl: Fix min_cbm_bits for AMD

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ata: ahci: Match EM_MAX_SLOTS with SATA_PMP_MAX_PORTS

Alexander Stein <alexander.stein@ew.tq-group.com>
    ata: ahci-imx: Fix MODULE_ALIAS

Zhang Rui <rui.zhang@intel.com>
    hwmon/coretemp: Handle large core ID value

Borislav Petkov <bp@suse.de>
    x86/microcode/AMD: Apply the patch early on every logical thread

Jon Hunter <jonathanh@nvidia.com>
    cpufreq: tegra194: Fix module loading

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    i2c: qcom-cci: Fix ordering of pm_runtime_xx and i2c_add_adapter

Fabien Parent <fabien.parent@linaro.org>
    cpufreq: qcom: fix writes in read-only memory region

GONG, Ruiqi <gongruiqi1@huawei.com>
    selinux: enable use of both GFP_KERNEL and GFP_ATOMIC in convert_context()

Steve French <stfrench@microsoft.com>
    smb3: interface count displayed incorrectly

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix BUG when iput after ocfs2_mknod fails

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: clear dinode links count in case of error

Thomas Zimmermann <tzimmermann@suse.de>
    video/aperture: Call sysfb_disable() before removing PCI devices


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |   5 +-
 arch/x86/Kconfig                                   |   1 -
 arch/x86/include/asm/iommu.h                       |   4 +-
 arch/x86/kernel/cpu/microcode/amd.c                |  16 ++-
 arch/x86/kernel/cpu/resctrl/core.c                 |   8 +-
 arch/x86/kernel/cpu/topology.c                     |  16 ++-
 arch/x86/kvm/x86.c                                 |  87 ++++++++++++---
 block/blk-mq.c                                     |   7 +-
 drivers/acpi/acpi_extlog.c                         |  33 +++---
 drivers/acpi/video_detect.c                        |  64 +++++++++++
 drivers/ata/ahci.h                                 |   2 +-
 drivers/ata/ahci_imx.c                             |   2 +-
 drivers/block/drbd/drbd_req.c                      |  14 +--
 drivers/cpufreq/qcom-cpufreq-nvmem.c               |  10 +-
 drivers/cpufreq/tegra194-cpufreq.c                 |   1 +
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |   5 -
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |  21 ++++
 drivers/gpu/drm/amd/display/dc/dml/Makefile        |   2 +-
 drivers/gpu/drm/vc4/vc4_drv.c                      |   1 +
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   9 ++
 drivers/hid/hid-magicmouse.c                       |   2 +-
 drivers/hwmon/coretemp.c                           |  56 +++++++---
 drivers/i2c/busses/i2c-qcom-cci.c                  |  13 ++-
 drivers/iommu/intel/iommu.c                        |   5 +
 drivers/md/dm-bufio.c                              |  13 ++-
 drivers/md/dm.c                                    |   1 -
 drivers/media/platform/qcom/venus/helpers.c        |  13 ++-
 drivers/media/platform/qcom/venus/vdec.c           |   2 +
 drivers/media/rc/mceusb.c                          |   2 +-
 drivers/net/dsa/qca/qca8k-8xxx.c                   |  83 +++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |  11 +-
 drivers/net/ethernet/hisilicon/hns/hnae.c          |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   3 -
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  16 +--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |  13 +--
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |   1 -
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  67 +++++++++--
 drivers/net/ethernet/intel/i40e/i40e_xsk.h         |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  17 ++-
 drivers/net/ethernet/mediatek/mtk_wed.c            |  15 ++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  12 +-
 drivers/net/ethernet/sfc/ef10.c                    |  58 ++++------
 drivers/net/ethernet/sfc/filter.h                  |   4 +-
 drivers/net/ethernet/sfc/rx_common.c               |  10 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   1 +
 drivers/net/phy/dp83822.c                          |   3 +-
 drivers/net/phy/dp83867.c                          |   8 ++
 drivers/net/phy/phylink.c                          |   3 +
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |   1 +
 .../net/wireless/mediatek/mt76/mt7921/pci_mcu.c    |   2 +
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |   2 +
 drivers/net/wwan/wwan_hwsim.c                      |   2 +-
 drivers/nvme/host/core.c                           |   6 +-
 drivers/nvme/host/hwmon.c                          |  32 ++++--
 drivers/nvme/target/core.c                         |   2 +-
 drivers/platform/x86/amd/pmc.c                     |   7 ++
 drivers/scsi/lpfc/lpfc_init.c                      |   7 +-
 drivers/staging/media/ipu3/ipu3-v4l2.c             |  31 +++---
 drivers/video/aperture.c                           |  11 ++
 fs/btrfs/backref.c                                 |  46 +++++---
 fs/cifs/cifsfs.c                                   |   7 +-
 fs/cifs/dir.c                                      |   6 +-
 fs/cifs/file.c                                     |  11 +-
 fs/cifs/sess.c                                     |   1 +
 fs/cifs/smb2ops.c                                  |   3 +-
 fs/cifs/smb2pdu.c                                  |   2 +-
 fs/erofs/zdata.c                                   |   8 +-
 fs/erofs/zdata.h                                   |   6 +-
 fs/ext4/fast_commit.c                              | 122 ++++++++++++++-------
 fs/ext4/fast_commit.h                              |   3 +
 fs/ocfs2/namei.c                                   |  23 ++--
 fs/proc/task_mmu.c                                 |   2 +-
 include/linux/dsa/tag_qca.h                        |   8 +-
 include/linux/kvm_host.h                           |   2 +
 include/linux/phylink.h                            |   2 +
 include/net/sch_generic.h                          |   1 -
 include/net/sock_reuseport.h                       |  11 +-
 io_uring/io_uring.h                                |  10 +-
 io_uring/msg_ring.c                                |   3 +
 io_uring/rw.c                                      |   2 -
 mm/hugetlb.c                                       |   2 +-
 net/atm/mpoa_proc.c                                |   3 +-
 net/core/dev.c                                     |   4 +
 net/core/skmsg.c                                   |   8 +-
 net/core/sock_reuseport.c                          |  16 +++
 net/hsr/hsr_forward.c                              |  12 +-
 net/ipv4/datagram.c                                |   2 +-
 net/ipv4/netfilter/ipt_rpfilter.c                  |   3 +-
 net/ipv4/netfilter/nft_fib_ipv4.c                  |   3 +-
 net/ipv4/udp.c                                     |   2 +-
 net/ipv6/addrconf.c                                |   2 +
 net/ipv6/datagram.c                                |   2 +-
 net/ipv6/netfilter/ip6t_rpfilter.c                 |  10 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |   7 +-
 net/ipv6/udp.c                                     |   2 +-
 net/netfilter/nf_tables_api.c                      |   5 +-
 net/sched/sch_api.c                                |   5 +-
 net/sched/sch_atm.c                                |   1 -
 net/sched/sch_cake.c                               |   4 +
 net/sched/sch_cbq.c                                |   1 -
 net/sched/sch_choke.c                              |   2 -
 net/sched/sch_drr.c                                |   2 -
 net/sched/sch_dsmark.c                             |   2 -
 net/sched/sch_etf.c                                |   3 -
 net/sched/sch_ets.c                                |   2 -
 net/sched/sch_fq_codel.c                           |   2 -
 net/sched/sch_fq_pie.c                             |   3 -
 net/sched/sch_hfsc.c                               |   2 -
 net/sched/sch_htb.c                                |   2 -
 net/sched/sch_multiq.c                             |   1 -
 net/sched/sch_prio.c                               |   2 -
 net/sched/sch_qfq.c                                |   2 -
 net/sched/sch_red.c                                |   2 -
 net/sched/sch_sfb.c                                |   5 +-
 net/sched/sch_skbprio.c                            |   3 -
 net/sched/sch_taprio.c                             |   2 -
 net/sched/sch_tbf.c                                |   2 -
 net/sched/sch_teql.c                               |   1 -
 net/smc/smc_core.c                                 |   3 +-
 net/tipc/discover.c                                |   2 +-
 net/tipc/topsrv.c                                  |   2 +-
 net/tls/tls_strp.c                                 |  32 +++++-
 security/selinux/ss/services.c                     |   5 +-
 security/selinux/ss/sidtab.c                       |   4 +-
 security/selinux/ss/sidtab.h                       |   2 +-
 tools/verification/dot2/dot2c.py                   |   2 +-
 virt/kvm/kvm_main.c                                |  11 ++
 128 files changed, 888 insertions(+), 441 deletions(-)


