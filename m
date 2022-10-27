Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971CF60FE18
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbiJ0RCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236840AbiJ0RCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:02:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB61189C36;
        Thu, 27 Oct 2022 10:02:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22299B824DB;
        Thu, 27 Oct 2022 17:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E4BC433C1;
        Thu, 27 Oct 2022 17:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890119;
        bh=Kw21QD+PWDuNKJJ+ubMd2lPhww6nWjFvj1gTwrluHv0=;
        h=From:To:Cc:Subject:Date:From;
        b=lq/oUGqhxsy9WQDYsR8p1GQMLiKHDBwuXCc0JyxZuQgWwvKJ0TL98/39gkGCjGQNU
         SqNnAVfwJ/MW5wo9AQY0No3ABW+xmt2JKx3NlF+TUqVaKVBRPKBtQtYbQ4S53aOdNK
         Ia0tDCTjHXn4iqMHyY3NjhenDzoh+/0r2lIHVvsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: [PATCH 5.15 00/79] 5.15.76-rc1 review
Date:   Thu, 27 Oct 2022 18:54:58 +0200
Message-Id: <20221027165054.917467648@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.76-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.76-rc1
X-KernelTest-Deadline: 2022-10-29T16:50+00:00
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

This is the start of the stable review cycle for the 5.15.76 release.
There are 79 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.76-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.76-rc1

Seth Jenkins <sethjenkins@google.com>
    mm: /proc/pid/smaps_rollup: fix no vma's null-deref

Avri Altman <avri.altman@wdc.com>
    mmc: core: Add SD card quirk for broken discard

Nick Desaulniers <ndesaulniers@google.com>
    Makefile.debug: re-enable debug info for .S files

Nathan Chancellor <nathan@kernel.org>
    x86/Kconfig: Drop check for -mabi=ms for CONFIG_EFI_STUB

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Force backlight native for more TongFang devices

Rob Herring <robh@kernel.org>
    perf: Skip and warn on unknown format 'configN' attrs

Prathamesh Shete <pshete@nvidia.com>
    mmc: sdhci-tegra: Use actual clock rate for SW tuning correction

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Do not free snapshot if tracer is on cmdline

sunliming <sunliming@kylinos.cn>
    tracing: Simplify conditional compilation code in tracing_set_tracer()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix incorrect handling of iterate_dir

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: handle smb2 query dir request for OutputBufferLength that is too small

Peter Collingbourne <pcc@google.com>
    arm64: mte: move register initialization to C

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix invalid derefence of sb_lvbptr

Jerry Snitselaar <jsnitsel@redhat.com>
    iommu/vt-d: Clean up si_domain in the init_dmars() error path

Charlotte Tan <charlotte@extrahop.com>
    iommu/vt-d: Allow NVS regions in arch_rmrr_sanity_check()

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

Brett Creeley <brett@pensando.io>
    ionic: catch NULL pointer issue on reconfig

Eric Dumazet <edumazet@google.com>
    net: hsr: avoid possible NULL deref in skb_clone()

Genjian Zhang <zhanggenjian@kylinos.cn>
    dm: remove unnecessary assignment statement in alloc_dev()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix xid leak in cifs_ses_add_channel()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix xid leak in cifs_flock()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix xid leak in cifs_copy_file_range()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix xid leak in cifs_create()

Kuniyuki Iwashima <kuniyu@amazon.com>
    udp: Update reuse->has_conns under reuseport_lock.

Rafael Mendonca <rafaelmendsr@gmail.com>
    scsi: lpfc: Fix memory leak in lpfc_create_port()

Shenwei Wang <shenwei.wang@nxp.com>
    net: phylink: add mac_managed_pm in phylink_config structure

Harini Katakam <harini.katakam@amd.com>
    net: phy: dp83867: Extend RX strap quirk for SGMII mode

Xiaobo Liu <cppcoffee@gmail.com>
    net/atm: fix proc_mpc_write incorrect return value

Jonathan Cooper <jonathan.s.cooper@amd.com>
    sfc: Change VF mac via PF as first preference if available.

José Expósito <jose.exposito89@gmail.com>
    HID: magicmouse: Do not set BTN_MOUSE on double report

Jan Sokolowski <jan.sokolowski@intel.com>
    i40e: Fix DMA mappings leak

Alexander Potapenko <glider@google.com>
    tipc: fix an information leak in tipc_topsrv_kern_subscr

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    tipc: Fix recognition of trial period

Tony Luck <tony.luck@intel.com>
    ACPI: extlog: Handle multiple records

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: Add module dependency on hdmi-codec

Filipe Manana <fdmanana@suse.com>
    btrfs: fix processing of delayed tree block refs during backref walking

Filipe Manana <fdmanana@suse.com>
    btrfs: fix processing of delayed data refs during backref walking

Zhang Rui <rui.zhang@intel.com>
    x86/topology: Fix duplicated core ID within a package

Zhang Rui <rui.zhang@intel.com>
    x86/topology: Fix multiple packages shown on a single-package system

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: venus: dec: Handle the case where find_format fails

Sean Young <sean@mess.org>
    media: mceusb: set timeout to at least timeout provided

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ipu3-imgu: Fix NULL pointer dereference in active selection access

Eric Ren <renzhengeek@gmail.com>
    KVM: arm64: vgic: Fix exit condition in scan_its_table()

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

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix BUG when iput after ocfs2_mknod fails

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: clear dinode links count in case of error

Qu Wenruo <wqu@suse.com>
    btrfs: enhance unsupported compat RO flags handling

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Relax address filter validation

James Morse <james.morse@arm.com>
    arm64: errata: Remove AES hwcap for COMPAT tasks

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: uvc: improve sg exit condition

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: uvc: giveback vb2 buffer on req complete

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: uvc: rework uvcg_queue_next_buffer to uvcg_complete_buffer

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: uvc: use on returned header len in video_encode_isoc_sg

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: uvc: consistently use define for headerlen

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/mm: Consolidate TCR_EL1 fields

Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
    r8152: add PID for the Lenovo OneLink+ Dock


-------------

Diffstat:

 Documentation/arm64/silicon-errata.rst          |  4 ++
 Makefile                                        |  8 +--
 arch/arm64/Kconfig                              | 16 ++++++
 arch/arm64/include/asm/mte.h                    |  5 ++
 arch/arm64/include/asm/pgtable-hwdef.h          |  2 +
 arch/arm64/include/asm/sysreg.h                 |  4 --
 arch/arm64/kernel/cpu_errata.c                  | 16 ++++++
 arch/arm64/kernel/cpufeature.c                  | 17 ++++++-
 arch/arm64/kernel/mte.c                         | 51 +++++++++++++++++++
 arch/arm64/kernel/suspend.c                     |  2 +
 arch/arm64/kvm/vgic/vgic-its.c                  |  5 +-
 arch/arm64/mm/proc.S                            | 48 +++---------------
 arch/arm64/tools/cpucaps                        |  1 +
 arch/x86/Kconfig                                |  1 -
 arch/x86/events/intel/pt.c                      | 63 ++++++++++++++++++-----
 arch/x86/include/asm/iommu.h                    |  4 +-
 arch/x86/kernel/cpu/microcode/amd.c             | 16 ++++--
 arch/x86/kernel/cpu/resctrl/core.c              |  8 +--
 arch/x86/kernel/cpu/topology.c                  | 16 ++++--
 drivers/acpi/acpi_extlog.c                      | 33 +++++++-----
 drivers/acpi/video_detect.c                     | 64 +++++++++++++++++++++++
 drivers/ata/ahci.h                              |  2 +-
 drivers/ata/ahci_imx.c                          |  2 +-
 drivers/cpufreq/qcom-cpufreq-nvmem.c            | 10 ++--
 drivers/cpufreq/tegra194-cpufreq.c              |  1 +
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c          |  5 --
 drivers/gpu/drm/amd/amdgpu/soc15.c              | 21 ++++++++
 drivers/gpu/drm/vc4/vc4_drv.c                   |  1 +
 drivers/hid/hid-magicmouse.c                    |  2 +-
 drivers/hwmon/coretemp.c                        | 56 +++++++++++++++------
 drivers/i2c/busses/i2c-qcom-cci.c               | 13 +++--
 drivers/iommu/intel/iommu.c                     |  5 ++
 drivers/md/dm.c                                 |  1 -
 drivers/media/platform/qcom/venus/vdec.c        |  2 +
 drivers/media/rc/mceusb.c                       |  2 +-
 drivers/mmc/core/block.c                        |  7 ++-
 drivers/mmc/core/card.h                         |  6 +++
 drivers/mmc/core/quirks.h                       |  6 +++
 drivers/mmc/host/sdhci-tegra.c                  |  2 +-
 drivers/net/ethernet/hisilicon/hns/hnae.c       |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c  |  3 --
 drivers/net/ethernet/intel/i40e/i40e_main.c     | 16 +++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c     | 13 ++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.h     |  1 -
 drivers/net/ethernet/intel/i40e/i40e_xsk.c      | 67 ++++++++++++++++++++++---
 drivers/net/ethernet/intel/i40e/i40e_xsk.h      |  2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 12 +++--
 drivers/net/ethernet/sfc/ef10.c                 | 58 +++++++++------------
 drivers/net/ethernet/sfc/filter.h               |  3 +-
 drivers/net/ethernet/sfc/rx_common.c            | 10 ++--
 drivers/net/phy/dp83822.c                       |  3 +-
 drivers/net/phy/dp83867.c                       |  8 +++
 drivers/net/phy/phylink.c                       |  3 ++
 drivers/net/usb/cdc_ether.c                     |  7 +++
 drivers/net/usb/r8152.c                         |  3 ++
 drivers/net/wwan/wwan_hwsim.c                   |  2 +-
 drivers/nvme/host/core.c                        |  6 ++-
 drivers/nvme/host/hwmon.c                       | 32 ++++++++----
 drivers/nvme/target/core.c                      |  2 +-
 drivers/scsi/lpfc/lpfc_init.c                   |  7 +--
 drivers/staging/media/ipu3/ipu3-v4l2.c          | 31 ++++++------
 drivers/usb/gadget/function/uvc.h               |  5 +-
 drivers/usb/gadget/function/uvc_queue.c         | 15 +-----
 drivers/usb/gadget/function/uvc_queue.h         |  2 +-
 drivers/usb/gadget/function/uvc_video.c         | 35 ++++++++-----
 drivers/usb/gadget/function/uvc_video.h         |  2 -
 fs/btrfs/backref.c                              | 46 +++++++++++------
 fs/btrfs/block-group.c                          | 11 +++-
 fs/btrfs/super.c                                |  9 ++++
 fs/cifs/cifsfs.c                                |  7 ++-
 fs/cifs/dir.c                                   |  6 ++-
 fs/cifs/file.c                                  | 11 ++--
 fs/cifs/sess.c                                  |  1 +
 fs/dlm/lock.c                                   |  2 +-
 fs/ksmbd/smb2pdu.c                              | 24 +++++----
 fs/ocfs2/namei.c                                | 23 ++++-----
 fs/proc/task_mmu.c                              |  2 +-
 include/linux/kvm_host.h                        |  2 +
 include/linux/mmc/card.h                        |  1 +
 include/linux/phylink.h                         |  2 +
 include/net/sch_generic.h                       |  1 -
 include/net/sock_reuseport.h                    | 11 ++--
 kernel/trace/trace.c                            | 12 ++---
 mm/hugetlb.c                                    |  2 +-
 net/atm/mpoa_proc.c                             |  3 +-
 net/core/sock_reuseport.c                       | 16 ++++++
 net/hsr/hsr_forward.c                           | 12 ++---
 net/ipv4/datagram.c                             |  2 +-
 net/ipv4/udp.c                                  |  2 +-
 net/ipv6/datagram.c                             |  2 +-
 net/ipv6/udp.c                                  |  2 +-
 net/netfilter/nf_tables_api.c                   |  5 +-
 net/sched/sch_api.c                             |  5 +-
 net/sched/sch_atm.c                             |  1 -
 net/sched/sch_cake.c                            |  4 ++
 net/sched/sch_cbq.c                             |  1 -
 net/sched/sch_choke.c                           |  2 -
 net/sched/sch_drr.c                             |  2 -
 net/sched/sch_dsmark.c                          |  2 -
 net/sched/sch_etf.c                             |  3 --
 net/sched/sch_ets.c                             |  2 -
 net/sched/sch_fq_codel.c                        |  2 -
 net/sched/sch_fq_pie.c                          |  3 --
 net/sched/sch_hfsc.c                            |  2 -
 net/sched/sch_htb.c                             |  2 -
 net/sched/sch_multiq.c                          |  1 -
 net/sched/sch_prio.c                            |  2 -
 net/sched/sch_qfq.c                             |  2 -
 net/sched/sch_red.c                             |  2 -
 net/sched/sch_sfb.c                             |  5 +-
 net/sched/sch_skbprio.c                         |  3 --
 net/sched/sch_taprio.c                          |  2 -
 net/sched/sch_tbf.c                             |  2 -
 net/sched/sch_teql.c                            |  1 -
 net/tipc/discover.c                             |  2 +-
 net/tipc/topsrv.c                               |  2 +-
 security/selinux/ss/services.c                  |  5 +-
 security/selinux/ss/sidtab.c                    |  4 +-
 security/selinux/ss/sidtab.h                    |  2 +-
 tools/perf/util/parse-events.c                  |  3 ++
 tools/perf/util/pmu.c                           | 17 +++++++
 tools/perf/util/pmu.h                           |  2 +
 tools/perf/util/pmu.l                           |  2 -
 tools/perf/util/pmu.y                           | 15 ++----
 virt/kvm/kvm_main.c                             | 11 ++++
 125 files changed, 808 insertions(+), 405 deletions(-)


