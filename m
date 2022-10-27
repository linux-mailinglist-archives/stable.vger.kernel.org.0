Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E18360FE78
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236957AbiJ0RFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236956AbiJ0RFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:05:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50827172501;
        Thu, 27 Oct 2022 10:05:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3396623F7;
        Thu, 27 Oct 2022 17:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4E8C433C1;
        Thu, 27 Oct 2022 17:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890330;
        bh=NXd7bzTaDmgsSTd0PybORcCN6oGPiM7SiChGoXkVDfQ=;
        h=From:To:Cc:Subject:Date:From;
        b=af3UO5lNQa8NpDms6xEsLLecO3f0v/mHLoqkvv1xz5VY4NQzCpMbcNsjGW5/c0Xe6
         Rg6LIIoxYkUzKs4v+8A5SBXE/ApjbymKRsDGo7hgsYWIfcZFrLzkF9J09lpYstcPY/
         HEFca1iwkiYAVOUqtZLtutk7KGY7clKd1yto7LeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: [PATCH 5.10 00/79] 5.10.151-rc1 review
Date:   Thu, 27 Oct 2022 18:55:10 +0200
Message-Id: <20221027165054.270676357@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.151-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.151-rc1
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

This is the start of the stable review cycle for the 5.10.151 release.
There are 79 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.151-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.151-rc1

Seth Jenkins <sethjenkins@google.com>
    mm: /proc/pid/smaps_rollup: fix no vma's null-deref

Yu Kuai <yukuai3@huawei.com>
    blk-wbt: fix that 'rwb->wc' is always set to 1 in wbt_init()

Avri Altman <avri.altman@wdc.com>
    mmc: core: Add SD card quirk for broken discard

Nick Desaulniers <ndesaulniers@google.com>
    Makefile.debug: re-enable debug info for .S files

Nathan Chancellor <nathan@kernel.org>
    x86/Kconfig: Drop check for -mabi=ms for CONFIG_EFI_STUB

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Force backlight native for more TongFang devices

Gaurav Kohli <gauravkohli@linux.microsoft.com>
    hv_netvsc: Fix race between VF offering and VF association message from host

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Relax address filter validation

Conor Dooley <conor.dooley@microchip.com>
    riscv: topology: fix default topology reporting

Conor Dooley <conor.dooley@microchip.com>
    arm64: topology: move store_cpu_topology() to shared code

Sibi Sankar <sibis@codeaurora.org>
    arm64: dts: qcom: sc7180-trogdor: Fixup modem memory region

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    fcntl: fix potential deadlocks for &fown_struct.lock

Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
    fcntl: make F_GETOWN(EX) return 0 on dead owner task

Rob Herring <robh@kernel.org>
    perf: Skip and warn on unknown format 'configN' attrs

Jin Yao <yao.jin@linux.intel.com>
    perf pmu: Validate raw event with sysfs exported format bits

Wenting Zhang <zephray@outlook.com>
    riscv: always honor the CONFIG_CMDLINE_FORCE when parsing dtb

Kefeng Wang <wangkefeng.wang@huawei.com>
    riscv: Add machine name to kernel boot log and stack dump output

Prathamesh Shete <pshete@nvidia.com>
    mmc: sdhci-tegra: Use actual clock rate for SW tuning correction

M. Vefa Bicakci <m.v.b@runbox.com>
    xen/gntdev: Accommodate VMA splitting

Juergen Gross <jgross@suse.com>
    xen: assume XENFEAT_gnttab_map_avail_bits being set for pv guests

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Do not free snapshot if tracer is on cmdline

sunliming <sunliming@kylinos.cn>
    tracing: Simplify conditional compilation code in tracing_set_tracer()

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    dmaengine: mxs: use platform_driver_register

Fabio Estevam <festevam@gmail.com>
    dmaengine: mxs-dma: Remove the unused .id_table

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/virtio: Use appropriate atomic state in virtio_gpu_plane_cleanup_fb()

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

Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
    sfc: include vport_id in filter spec hash and equal()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: sched: sfb: fix null pointer access issue when sfb_init() fails

Zhengchao Shao <shaozhengchao@huawei.com>
    net: sched: delete duplicate cleanup of backlog and qlen

Zhengchao Shao <shaozhengchao@huawei.com>
    net: sched: cake: fix null pointer access issue when cake_init() fails

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    nvme-hwmon: kmalloc the NVME SMART log buffer

Christoph Hellwig <hch@lst.de>
    nvme-hwmon: consistently ignore errors from nvme_hwmon_init

Daniel Wagner <dwagner@suse.de>
    nvme-hwmon: Return error code when registration fails

Hannes Reinecke <hare@suse.de>
    nvme-hwmon: rework to avoid devm allocation

Brett Creeley <brett@pensando.io>
    ionic: catch NULL pointer issue on reconfig

Eric Dumazet <edumazet@google.com>
    net: hsr: avoid possible NULL deref in skb_clone()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix xid leak in cifs_ses_add_channel()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix xid leak in cifs_flock()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix xid leak in cifs_copy_file_range()

Kuniyuki Iwashima <kuniyu@amazon.com>
    udp: Update reuse->has_conns under reuseport_lock.

Kuniyuki Iwashima <kuniyu@amazon.co.jp>
    tcp: Add num_closed_socks to struct sock_reuseport.

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

Filipe Manana <fdmanana@suse.com>
    btrfs: fix processing of delayed tree block refs during backref walking

Filipe Manana <fdmanana@suse.com>
    btrfs: fix processing of delayed data refs during backref walking

Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
    r8152: add PID for the Lenovo OneLink+ Dock

James Morse <james.morse@arm.com>
    arm64: errata: Remove AES hwcap for COMPAT tasks

Yu Kuai <yukuai3@huawei.com>
    blk-wbt: call rq_qos_add() after wb_normal is initialized

Lei Chen <lennychen@tencent.com>
    block: wbt: Remove unnecessary invoking of wbt_update_limits in wbt_init

Martin Rodriguez Reboredo <yakoyoku@gmail.com>
    kbuild: Add skip_encoding_btf_enum64 option to pahole

Jiri Olsa <jolsa@redhat.com>
    kbuild: Unify options for BTF generation for vmlinux and modules

Andrii Nakryiko <andrii@kernel.org>
    kbuild: skip per-CPU BTF generation for pahole v1.18-v1.21

Javier Martinez Canillas <javierm@redhat.com>
    kbuild: Quote OBJCOPY var to avoid a pahole call break the build

Ilya Leoshkevich <iii@linux.ibm.com>
    bpf: Generate BTF_KIND_FLOAT when linking vmlinux

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: venus: dec: Handle the case where find_format fails

Sean Young <sean@mess.org>
    media: mceusb: set timeout to at least timeout provided

Eric Ren <renzhengeek@gmail.com>
    KVM: arm64: vgic: Fix exit condition in scan_its_table()

Alexander Graf <graf@amazon.com>
    kvm: Add support for arch compat vm ioctls

Fabien Parent <fabien.parent@linaro.org>
    cpufreq: qcom: fix memory leak in error path

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


-------------

Diffstat:

 Documentation/arm64/silicon-errata.rst             |  4 +
 Makefile                                           | 11 ++-
 arch/arm64/Kconfig                                 | 16 ++++
 .../boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi      |  4 +
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi       |  2 +-
 arch/arm64/include/asm/cpucaps.h                   |  3 +-
 arch/arm64/kernel/cpu_errata.c                     | 16 ++++
 arch/arm64/kernel/cpufeature.c                     | 13 ++-
 arch/arm64/kernel/topology.c                       | 40 ---------
 arch/arm64/kvm/vgic/vgic-its.c                     |  5 +-
 arch/riscv/Kconfig                                 |  2 +-
 arch/riscv/kernel/setup.c                          | 13 ++-
 arch/riscv/kernel/smpboot.c                        |  4 +-
 arch/x86/Kconfig                                   |  1 -
 arch/x86/events/intel/pt.c                         | 63 ++++++++++++---
 arch/x86/include/asm/iommu.h                       |  4 +-
 arch/x86/kernel/cpu/microcode/amd.c                | 16 +++-
 block/blk-wbt.c                                    | 11 +--
 drivers/acpi/acpi_extlog.c                         | 33 +++++---
 drivers/acpi/video_detect.c                        | 64 +++++++++++++++
 drivers/ata/ahci.h                                 |  2 +-
 drivers/ata/ahci_imx.c                             |  2 +-
 drivers/base/arch_topology.c                       | 19 +++++
 drivers/cpufreq/qcom-cpufreq-nvmem.c               | 10 ++-
 drivers/cpufreq/tegra194-cpufreq.c                 |  1 +
 drivers/dma/mxs-dma.c                              | 48 +++--------
 drivers/gpu/drm/virtio/virtgpu_plane.c             |  6 +-
 drivers/hid/hid-magicmouse.c                       |  2 +-
 drivers/hwmon/coretemp.c                           | 56 +++++++++----
 drivers/i2c/busses/i2c-qcom-cci.c                  | 13 +--
 drivers/iommu/intel/iommu.c                        |  5 ++
 drivers/media/platform/qcom/venus/vdec.c           |  2 +
 drivers/media/rc/mceusb.c                          |  2 +-
 drivers/mmc/core/block.c                           |  7 +-
 drivers/mmc/core/card.h                            |  6 ++
 drivers/mmc/core/quirks.h                          |  6 ++
 drivers/mmc/host/sdhci-tegra.c                     |  2 +-
 drivers/net/ethernet/hisilicon/hns/hnae.c          |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  3 -
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 16 ++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        | 13 ++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |  1 -
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         | 67 +++++++++++++--
 drivers/net/ethernet/intel/i40e/i40e_xsk.h         |  2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    | 12 ++-
 drivers/net/ethernet/sfc/ef10.c                    | 58 ++++++-------
 drivers/net/ethernet/sfc/filter.h                  |  3 +-
 drivers/net/ethernet/sfc/rx_common.c               | 10 +--
 drivers/net/hyperv/hyperv_net.h                    |  3 +-
 drivers/net/hyperv/netvsc.c                        |  4 +
 drivers/net/hyperv/netvsc_drv.c                    | 20 +++++
 drivers/net/phy/dp83822.c                          |  3 +-
 drivers/net/phy/dp83867.c                          |  8 ++
 drivers/net/usb/cdc_ether.c                        |  7 ++
 drivers/net/usb/r8152.c                            |  1 +
 drivers/nvme/host/core.c                           |  7 +-
 drivers/nvme/host/hwmon.c                          | 58 +++++++++----
 drivers/nvme/host/nvme.h                           |  8 ++
 drivers/xen/gntdev-common.h                        |  3 +-
 drivers/xen/gntdev.c                               | 94 +++++++---------------
 fs/btrfs/backref.c                                 | 46 +++++++----
 fs/cifs/cifsfs.c                                   |  7 +-
 fs/cifs/file.c                                     | 11 ++-
 fs/cifs/sess.c                                     |  1 +
 fs/fcntl.c                                         | 32 +++++---
 fs/ocfs2/namei.c                                   | 23 +++---
 fs/proc/task_mmu.c                                 |  2 +-
 include/linux/kvm_host.h                           |  2 +
 include/linux/mmc/card.h                           |  1 +
 include/net/sch_generic.h                          |  1 -
 include/net/sock_reuseport.h                       | 16 ++--
 kernel/trace/trace.c                               | 12 +--
 net/atm/mpoa_proc.c                                |  3 +-
 net/core/sock_reuseport.c                          | 91 ++++++++++++++++-----
 net/hsr/hsr_forward.c                              | 12 +--
 net/ipv4/datagram.c                                |  2 +-
 net/ipv4/udp.c                                     |  2 +-
 net/ipv6/datagram.c                                |  2 +-
 net/ipv6/udp.c                                     |  2 +-
 net/sched/sch_api.c                                |  5 +-
 net/sched/sch_atm.c                                |  1 -
 net/sched/sch_cake.c                               |  4 +
 net/sched/sch_cbq.c                                |  1 -
 net/sched/sch_choke.c                              |  2 -
 net/sched/sch_drr.c                                |  2 -
 net/sched/sch_dsmark.c                             |  2 -
 net/sched/sch_etf.c                                |  3 -
 net/sched/sch_ets.c                                |  2 -
 net/sched/sch_fq_codel.c                           |  2 -
 net/sched/sch_fq_pie.c                             |  3 -
 net/sched/sch_hfsc.c                               |  2 -
 net/sched/sch_htb.c                                |  2 -
 net/sched/sch_multiq.c                             |  1 -
 net/sched/sch_prio.c                               |  2 -
 net/sched/sch_qfq.c                                |  2 -
 net/sched/sch_red.c                                |  2 -
 net/sched/sch_sfb.c                                |  5 +-
 net/sched/sch_skbprio.c                            |  3 -
 net/sched/sch_taprio.c                             |  2 -
 net/sched/sch_tbf.c                                |  2 -
 net/sched/sch_teql.c                               |  1 -
 net/tipc/discover.c                                |  2 +-
 net/tipc/topsrv.c                                  |  2 +-
 scripts/link-vmlinux.sh                            |  2 +-
 scripts/pahole-flags.sh                            | 21 +++++
 security/selinux/ss/services.c                     |  5 +-
 security/selinux/ss/sidtab.c                       |  4 +-
 security/selinux/ss/sidtab.h                       |  2 +-
 tools/perf/util/parse-events.c                     |  6 ++
 tools/perf/util/pmu.c                              | 50 ++++++++++++
 tools/perf/util/pmu.h                              |  5 ++
 tools/perf/util/pmu.l                              |  2 -
 tools/perf/util/pmu.y                              | 15 +---
 virt/kvm/kvm_main.c                                | 11 +++
 114 files changed, 889 insertions(+), 476 deletions(-)


