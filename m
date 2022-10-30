Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F90E612940
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 10:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiJ3JDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 05:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3JDF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 05:03:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08842B50;
        Sun, 30 Oct 2022 02:03:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93E8E60DFB;
        Sun, 30 Oct 2022 09:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3954C433C1;
        Sun, 30 Oct 2022 09:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667120580;
        bh=d2FIaV87/eBt8oFDZdjtTXYs/x82sNdPujUj4rXhtPY=;
        h=From:To:Cc:Subject:Date:From;
        b=uceoSEr/cMc1+sgt6qwG5puqbh5/Go6Ncn7ZVQ8u75lWQ5i2ujgr+pQ/V3YidhlRA
         AexxH5/6PdWKlKp1ZzO4YxhaQUAIVRJX/r/K2Gv44+1GA/SJ1CItBRRg/ZauaptD/s
         zOnSO7XZnRph66jy0Y9lK2uIKzG96lAlS2ZSdhfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.152
Date:   Sun, 30 Oct 2022 10:03:54 +0100
Message-Id: <1667120634113153@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.152 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm64/silicon-errata.rst               |    4 
 Makefile                                             |    6 -
 arch/arm64/Kconfig                                   |   16 +++
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi |    4 
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi         |    2 
 arch/arm64/include/asm/cpucaps.h                     |    3 
 arch/arm64/kernel/cpu_errata.c                       |   16 +++
 arch/arm64/kernel/cpufeature.c                       |   13 ++
 arch/arm64/kernel/topology.c                         |   40 --------
 arch/arm64/kvm/vgic/vgic-its.c                       |    5 -
 arch/riscv/Kconfig                                   |    2 
 arch/riscv/kernel/setup.c                            |   13 ++
 arch/riscv/kernel/smpboot.c                          |    4 
 arch/x86/Kconfig                                     |    1 
 arch/x86/events/intel/pt.c                           |   63 ++++++++++--
 arch/x86/include/asm/iommu.h                         |    4 
 arch/x86/kernel/cpu/microcode/amd.c                  |   16 ++-
 block/blk-wbt.c                                      |   11 --
 drivers/acpi/acpi_extlog.c                           |   33 ++++--
 drivers/acpi/video_detect.c                          |   64 ++++++++++++
 drivers/ata/ahci.h                                   |    2 
 drivers/ata/ahci_imx.c                               |    2 
 drivers/base/arch_topology.c                         |   19 +++
 drivers/cpufreq/qcom-cpufreq-nvmem.c                 |   10 +-
 drivers/dma/mxs-dma.c                                |   48 +--------
 drivers/gpu/drm/virtio/virtgpu_plane.c               |    6 -
 drivers/hid/hid-magicmouse.c                         |    2 
 drivers/hwmon/coretemp.c                             |   56 ++++++++---
 drivers/i2c/busses/i2c-qcom-cci.c                    |   13 +-
 drivers/iommu/intel/iommu.c                          |    5 +
 drivers/media/platform/qcom/venus/vdec.c             |    2 
 drivers/media/rc/mceusb.c                            |    2 
 drivers/mmc/core/block.c                             |    7 +
 drivers/mmc/core/card.h                              |    6 +
 drivers/mmc/core/quirks.h                            |    6 +
 drivers/mmc/host/sdhci-tegra.c                       |    2 
 drivers/net/ethernet/hisilicon/hns/hnae.c            |    4 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c       |    3 
 drivers/net/ethernet/intel/i40e/i40e_main.c          |   16 +--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c          |   13 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h          |    1 
 drivers/net/ethernet/intel/i40e/i40e_xsk.c           |   67 +++++++++++--
 drivers/net/ethernet/intel/i40e/i40e_xsk.h           |    2 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c      |   12 +-
 drivers/net/ethernet/sfc/ef10.c                      |   58 ++++-------
 drivers/net/ethernet/sfc/filter.h                    |    3 
 drivers/net/ethernet/sfc/rx_common.c                 |   10 +-
 drivers/net/hyperv/hyperv_net.h                      |    3 
 drivers/net/hyperv/netvsc.c                          |    4 
 drivers/net/hyperv/netvsc_drv.c                      |   20 ++++
 drivers/net/phy/dp83822.c                            |    3 
 drivers/net/phy/dp83867.c                            |    8 +
 drivers/net/usb/cdc_ether.c                          |    7 +
 drivers/net/usb/r8152.c                              |    1 
 drivers/nvme/host/core.c                             |    7 +
 drivers/nvme/host/hwmon.c                            |   58 ++++++++---
 drivers/nvme/host/nvme.h                             |    8 +
 drivers/xen/gntdev-common.h                          |    3 
 drivers/xen/gntdev.c                                 |   94 +++++--------------
 fs/btrfs/backref.c                                   |   46 ++++++---
 fs/cifs/cifsfs.c                                     |    7 +
 fs/cifs/file.c                                       |   11 +-
 fs/cifs/sess.c                                       |    1 
 fs/fcntl.c                                           |   32 ++++--
 fs/ocfs2/namei.c                                     |   23 ++--
 fs/proc/task_mmu.c                                   |    2 
 include/linux/kvm_host.h                             |    2 
 include/linux/mmc/card.h                             |    1 
 include/net/sch_generic.h                            |    1 
 include/net/sock_reuseport.h                         |   11 +-
 kernel/trace/trace.c                                 |   12 +-
 net/atm/mpoa_proc.c                                  |    3 
 net/core/sock_reuseport.c                            |   16 +++
 net/hsr/hsr_forward.c                                |   12 +-
 net/ipv4/datagram.c                                  |    2 
 net/ipv4/udp.c                                       |    2 
 net/ipv6/datagram.c                                  |    2 
 net/ipv6/udp.c                                       |    2 
 net/sched/sch_api.c                                  |    5 -
 net/sched/sch_atm.c                                  |    1 
 net/sched/sch_cake.c                                 |    4 
 net/sched/sch_cbq.c                                  |    1 
 net/sched/sch_choke.c                                |    2 
 net/sched/sch_drr.c                                  |    2 
 net/sched/sch_dsmark.c                               |    2 
 net/sched/sch_etf.c                                  |    3 
 net/sched/sch_ets.c                                  |    2 
 net/sched/sch_fq_codel.c                             |    2 
 net/sched/sch_fq_pie.c                               |    3 
 net/sched/sch_hfsc.c                                 |    2 
 net/sched/sch_htb.c                                  |    2 
 net/sched/sch_multiq.c                               |    1 
 net/sched/sch_prio.c                                 |    2 
 net/sched/sch_qfq.c                                  |    2 
 net/sched/sch_red.c                                  |    2 
 net/sched/sch_sfb.c                                  |    5 -
 net/sched/sch_skbprio.c                              |    3 
 net/sched/sch_taprio.c                               |    2 
 net/sched/sch_tbf.c                                  |    2 
 net/sched/sch_teql.c                                 |    1 
 net/tipc/discover.c                                  |    2 
 net/tipc/topsrv.c                                    |    2 
 security/selinux/ss/services.c                       |    5 -
 security/selinux/ss/sidtab.c                         |    4 
 security/selinux/ss/sidtab.h                         |    2 
 tools/perf/util/parse-events.c                       |    6 +
 tools/perf/util/pmu.c                                |   50 ++++++++++
 tools/perf/util/pmu.h                                |    5 +
 tools/perf/util/pmu.l                                |    2 
 tools/perf/util/pmu.y                                |   15 ---
 virt/kvm/kvm_main.c                                  |   11 ++
 111 files changed, 802 insertions(+), 454 deletions(-)

Adrian Hunter (1):
      perf/x86/intel/pt: Relax address filter validation

Alexander Graf (1):
      kvm: Add support for arch compat vm ioctls

Alexander Potapenko (1):
      tipc: fix an information leak in tipc_topsrv_kern_subscr

Alexander Stein (1):
      ata: ahci-imx: Fix MODULE_ALIAS

Avri Altman (1):
      mmc: core: Add SD card quirk for broken discard

Borislav Petkov (1):
      x86/microcode/AMD: Apply the patch early on every logical thread

Brett Creeley (1):
      ionic: catch NULL pointer issue on reconfig

Bryan O'Donoghue (2):
      i2c: qcom-cci: Fix ordering of pm_runtime_xx and i2c_add_adapter
      media: venus: dec: Handle the case where find_format fails

Charlotte Tan (1):
      iommu/vt-d: Allow NVS regions in arch_rmrr_sanity_check()

Christoph Hellwig (1):
      nvme-hwmon: consistently ignore errors from nvme_hwmon_init

Conor Dooley (2):
      arm64: topology: move store_cpu_topology() to shared code
      riscv: topology: fix default topology reporting

Daniel Wagner (1):
      nvme-hwmon: Return error code when registration fails

Dario Binacchi (1):
      dmaengine: mxs: use platform_driver_register

Desmond Cheong Zhi Xi (1):
      fcntl: fix potential deadlocks for &fown_struct.lock

Dmitry Osipenko (1):
      drm/virtio: Use appropriate atomic state in virtio_gpu_plane_cleanup_fb()

Eric Dumazet (2):
      net: hsr: avoid possible NULL deref in skb_clone()
      net: sched: fix race condition in qdisc_graft()

Eric Ren (1):
      KVM: arm64: vgic: Fix exit condition in scan_its_table()

Fabien Parent (2):
      cpufreq: qcom: fix writes in read-only memory region
      cpufreq: qcom: fix memory leak in error path

Fabio Estevam (1):
      dmaengine: mxs-dma: Remove the unused .id_table

Felix Riemann (1):
      net: phy: dp83822: disable MDI crossover status change interrupt

Filipe Manana (2):
      btrfs: fix processing of delayed data refs during backref walking
      btrfs: fix processing of delayed tree block refs during backref walking

GONG, Ruiqi (1):
      selinux: enable use of both GFP_KERNEL and GFP_ATOMIC in convert_context()

Gaurav Kohli (1):
      hv_netvsc: Fix race between VF offering and VF association message from host

Greg Kroah-Hartman (1):
      Linux 5.10.152

Hannes Reinecke (1):
      nvme-hwmon: rework to avoid devm allocation

Harini Katakam (1):
      net: phy: dp83867: Extend RX strap quirk for SGMII mode

James Morse (1):
      arm64: errata: Remove AES hwcap for COMPAT tasks

Jan Sokolowski (1):
      i40e: Fix DMA mappings leak

Jean-Francois Le Fillatre (1):
      r8152: add PID for the Lenovo OneLink+ Dock

Jerry Snitselaar (1):
      iommu/vt-d: Clean up si_domain in the init_dmars() error path

Jin Yao (1):
      perf pmu: Validate raw event with sysfs exported format bits

Jonathan Cooper (1):
      sfc: Change VF mac via PF as first preference if available.

Joseph Qi (2):
      ocfs2: clear dinode links count in case of error
      ocfs2: fix BUG when iput after ocfs2_mknod fails

José Expósito (1):
      HID: magicmouse: Do not set BTN_MOUSE on double report

Juergen Gross (1):
      xen: assume XENFEAT_gnttab_map_avail_bits being set for pv guests

Kai-Heng Feng (1):
      ata: ahci: Match EM_MAX_SLOTS with SATA_PMP_MAX_PORTS

Kefeng Wang (1):
      riscv: Add machine name to kernel boot log and stack dump output

Kuniyuki Iwashima (1):
      udp: Update reuse->has_conns under reuseport_lock.

Lei Chen (1):
      block: wbt: Remove unnecessary invoking of wbt_update_limits in wbt_init

M. Vefa Bicakci (1):
      xen/gntdev: Accommodate VMA splitting

Mark Tomlinson (1):
      tipc: Fix recognition of trial period

Nathan Chancellor (1):
      x86/Kconfig: Drop check for -mabi=ms for CONFIG_EFI_STUB

Nick Desaulniers (1):
      Makefile.debug: re-enable debug info for .S files

Pavel Tikhomirov (1):
      fcntl: make F_GETOWN(EX) return 0 on dead owner task

Pieter Jansen van Vuuren (1):
      sfc: include vport_id in filter spec hash and equal()

Prathamesh Shete (1):
      mmc: sdhci-tegra: Use actual clock rate for SW tuning correction

Rob Herring (1):
      perf: Skip and warn on unknown format 'configN' attrs

Sean Young (1):
      media: mceusb: set timeout to at least timeout provided

Serge Semin (1):
      nvme-hwmon: kmalloc the NVME SMART log buffer

Seth Jenkins (1):
      mm: /proc/pid/smaps_rollup: fix no vma's null-deref

Sibi Sankar (1):
      arm64: dts: qcom: sc7180-trogdor: Fixup modem memory region

Steven Rostedt (Google) (1):
      tracing: Do not free snapshot if tracer is on cmdline

Tony Luck (1):
      ACPI: extlog: Handle multiple records

Wenting Zhang (1):
      riscv: always honor the CONFIG_CMDLINE_FORCE when parsing dtb

Werner Sembach (1):
      ACPI: video: Force backlight native for more TongFang devices

Xiaobo Liu (1):
      net/atm: fix proc_mpc_write incorrect return value

Yang Yingliang (1):
      net: hns: fix possible memory leak in hnae_ae_register()

Yu Kuai (2):
      blk-wbt: call rq_qos_add() after wb_normal is initialized
      blk-wbt: fix that 'rwb->wc' is always set to 1 in wbt_init()

Zhang Rui (1):
      hwmon/coretemp: Handle large core ID value

Zhang Xiaoxu (3):
      cifs: Fix xid leak in cifs_copy_file_range()
      cifs: Fix xid leak in cifs_flock()
      cifs: Fix xid leak in cifs_ses_add_channel()

Zhengchao Shao (3):
      net: sched: cake: fix null pointer access issue when cake_init() fails
      net: sched: delete duplicate cleanup of backlog and qlen
      net: sched: sfb: fix null pointer access issue when sfb_init() fails

sunliming (1):
      tracing: Simplify conditional compilation code in tracing_set_tracer()

