Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3BA57D409
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 21:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbiGUTWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 15:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiGUTWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 15:22:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E3088E3E;
        Thu, 21 Jul 2022 12:22:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C9A5B82643;
        Thu, 21 Jul 2022 19:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493CDC341CB;
        Thu, 21 Jul 2022 19:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658431363;
        bh=gyYyvQ0uuGkhsRSrRCeIMsCW6m18BC4XzZtWzIn6iEI=;
        h=From:To:Cc:Subject:Date:From;
        b=JD2qDpOHTj4F1xyufeZj53oxguq2A4i6FEsGHefoEBWIx+WncPaLOfKFI8KXaMee/
         jyhnzViv/th3HM+YzQMi95m5JKmVPJY7jkgXY1zfFZOXHbZ8uLFz8dkoYFEfpPNAG7
         gK5ls9E2LXtrL8oZ8kfrMUn6OoCvY6I/+7D6H01Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.132
Date:   Thu, 21 Jul 2022 21:22:39 +0200
Message-Id: <16584313593316@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.132 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/ip-sysctl.rst                     |    4 
 Makefile                                                   |    2 
 arch/arm/boot/dts/imx6qdl-ts7970.dtsi                      |    2 
 arch/arm/boot/dts/sama5d2.dtsi                             |    2 
 arch/arm/boot/dts/stm32mp151.dtsi                          |    2 
 arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts          |    2 
 arch/arm/include/asm/mach/map.h                            |    1 
 arch/arm/include/asm/ptrace.h                              |   26 ++++++
 arch/arm/mm/alignment.c                                    |    3 
 arch/arm/mm/mmu.c                                          |   15 +++
 arch/arm/mm/proc-v7-bugs.c                                 |    9 --
 arch/arm/probes/decode.h                                   |   26 ------
 arch/sh/include/asm/io.h                                   |    8 +
 arch/x86/kernel/head64.c                                   |    2 
 arch/x86/kernel/ima_arch.c                                 |    2 
 arch/x86/kvm/x86.c                                         |   18 ++--
 arch/x86/mm/init.c                                         |   14 ++-
 drivers/cpufreq/pmac32-cpufreq.c                           |    4 
 drivers/gpu/drm/i915/display/intel_dp_mst.c                |    1 
 drivers/gpu/drm/i915/gt/intel_gt.c                         |   15 +++
 drivers/gpu/drm/i915/gt/selftest_lrc.c                     |    8 -
 drivers/gpu/drm/panfrost/panfrost_drv.c                    |    4 
 drivers/gpu/drm/panfrost/panfrost_mmu.c                    |    2 
 drivers/irqchip/irq-or1k-pic.c                             |    1 
 drivers/net/can/xilinx_can.c                               |    4 
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c       |   23 +----
 drivers/net/ethernet/faraday/ftgmac100.c                   |   15 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c         |    2 
 drivers/net/ethernet/sfc/ef10.c                            |    3 
 drivers/net/ethernet/sfc/ef10_sriov.c                      |   10 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c    |    1 
 drivers/net/phy/sfp.c                                      |    2 
 drivers/net/xen-netback/rx.c                               |    1 
 drivers/nfc/nxp-nci/i2c.c                                  |    8 +
 drivers/nvme/host/core.c                                   |    2 
 drivers/nvme/host/nvme.h                                   |    1 
 drivers/nvme/host/pci.c                                    |    3 
 drivers/nvme/host/rdma.c                                   |   12 ++
 drivers/nvme/host/tcp.c                                    |   13 +--
 drivers/pinctrl/aspeed/pinctrl-aspeed.c                    |    4 
 drivers/platform/x86/hp-wmi.c                              |    3 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                     |    7 +
 drivers/soc/ixp4xx/ixp4xx-npe.c                            |    2 
 drivers/spi/spi-amd.c                                      |    8 +
 drivers/tty/serial/8250/8250_core.c                        |    4 
 drivers/tty/serial/8250/8250_port.c                        |    4 
 drivers/tty/serial/amba-pl011.c                            |   23 +++++
 drivers/tty/serial/samsung_tty.c                           |    5 -
 drivers/tty/serial/serial_core.c                           |    5 -
 drivers/tty/serial/stm32-usart.c                           |    2 
 drivers/tty/vt/vt.c                                        |    2 
 drivers/usb/dwc3/gadget.c                                  |    4 
 drivers/usb/serial/ftdi_sio.c                              |    3 
 drivers/usb/serial/ftdi_sio_ids.h                          |    6 +
 drivers/usb/typec/class.c                                  |    1 
 drivers/virtio/virtio_mmio.c                               |   26 ++++++
 fs/btrfs/inode.c                                           |   14 +++
 fs/exec.c                                                  |    2 
 fs/ext4/extents.c                                          |    9 +-
 fs/ext4/inode.c                                            |    9 --
 fs/nilfs2/nilfs.h                                          |    3 
 fs/remap_range.c                                           |    3 
 include/linux/cgroup-defs.h                                |    3 
 include/linux/kexec.h                                      |    6 +
 include/linux/sched/task.h                                 |    2 
 include/linux/serial_core.h                                |    5 +
 include/net/raw.h                                          |    2 
 include/net/sock.h                                         |    2 
 include/net/tls.h                                          |    4 
 include/trace/events/sock.h                                |    6 -
 kernel/cgroup/cgroup.c                                     |   37 +++++----
 kernel/exit.c                                              |    2 
 kernel/kexec_file.c                                        |   11 ++
 kernel/signal.c                                            |    8 -
 kernel/sysctl.c                                            |   53 +++++++------
 kernel/time/posix-timers.c                                 |   19 +++-
 kernel/trace/trace_events_hist.c                           |    2 
 mm/memory.c                                                |   27 +++---
 net/bridge/br_netfilter_hooks.c                            |   21 ++++-
 net/core/filter.c                                          |    1 
 net/ipv4/af_inet.c                                         |    4 
 net/ipv4/cipso_ipv4.c                                      |   12 +-
 net/ipv4/fib_semantics.c                                   |    4 
 net/ipv4/fib_trie.c                                        |    2 
 net/ipv4/icmp.c                                            |   10 +-
 net/ipv4/inetpeer.c                                        |   12 +-
 net/ipv4/nexthop.c                                         |    5 -
 net/ipv4/tcp.c                                             |    3 
 net/ipv6/route.c                                           |    2 
 net/ipv6/seg6_iptunnel.c                                   |    5 -
 net/ipv6/seg6_local.c                                      |    2 
 net/mac80211/wme.c                                         |    4 
 net/tipc/socket.c                                          |    1 
 net/tls/tls_device.c                                       |    4 
 net/tls/tls_main.c                                         |    7 +
 security/integrity/evm/evm_crypto.c                        |    7 -
 security/integrity/ima/ima_appraise.c                      |    3 
 security/integrity/ima/ima_crypto.c                        |    1 
 sound/pci/hda/patch_conexant.c                             |    1 
 sound/pci/hda/patch_realtek.c                              |   16 +++
 sound/soc/codecs/cs47l15.c                                 |    5 -
 sound/soc/codecs/madera.c                                  |   14 ++-
 sound/soc/codecs/sgtl5000.c                                |    9 ++
 sound/soc/codecs/sgtl5000.h                                |    1 
 sound/soc/codecs/tas2764.c                                 |   46 ++++++-----
 sound/soc/codecs/tas2764.h                                 |    6 -
 sound/soc/codecs/wm5110.c                                  |    8 +
 sound/soc/intel/skylake/skl-nhlt.c                         |   40 ++++++---
 sound/soc/soc-dapm.c                                       |    5 +
 sound/soc/soc-ops.c                                        |    4 
 sound/soc/sof/intel/hda-loader.c                           |    8 -
 113 files changed, 603 insertions(+), 287 deletions(-)

Andrea Mayer (3):
      seg6: fix skb checksum evaluation in SRH encapsulation/insertion
      seg6: fix skb checksum in SRv6 End.B6 and End.B6.Encaps behaviors
      seg6: bpf: fix skb checksum in bpf_push_seg6_encap()

Ard Biesheuvel (2):
      ARM: 9214/1: alignment: advance IT state after emulating Thumb instruction
      ARM: 9209/1: Spectre-BHB: avoid pr_info() every time a CPU comes out of idle

Baokun Li (1):
      ext4: fix race condition between ext4_write and ext4_convert_inline_data

Chanho Park (1):
      tty: serial: samsung_tty: set dma burst_size to 1

Charles Keepax (5):
      ASoC: wm5110: Fix DRE control
      ASoC: dapm: Initialise kcontrol data for mux/demux controls
      ASoC: cs47l15: Fix event generation for low power mux control
      ASoC: madera: Fix event generation for OUT1 demux
      ASoC: madera: Fix event generation for rate controls

Chia-Lin Kao (AceLan) (2):
      net: atlantic: remove deep parameter on suspend/resume functions
      net: atlantic: remove aq_nic_deinit() when resume

Chris Wilson (1):
      drm/i915/gt: Serialize TLB invalidates with GT resets

Coiby Xu (1):
      ima: force signature verification when CONFIG_KEXEC_SIG is configured

Cristian Ciocaltea (1):
      spi: amd: Limit max transfer and message size

Dan Carpenter (1):
      drm/i915/selftests: fix a couple IS_ERR() vs NULL tests

Dave Chinner (1):
      fs/remap: constrain dedupe of EOF blocks

Dmitry Osipenko (3):
      ARM: 9213/1: Print message about disabled Spectre workarounds only once
      drm/panfrost: Put mapping instead of shmem obj on panfrost_mmu_map_fault_addr() error
      drm/panfrost: Fix shrinker list corruption by madvise IOCTL

Felix Fietkau (1):
      wifi: mac80211: fix queue selection for mesh/OCB interfaces

Filipe Manana (1):
      btrfs: return -EAGAIN for NOWAIT dio reads/writes on compressed and inline extents

Florian Westphal (1):
      netfilter: br_netfilter: do not skip all hooks with 0 priority

Francesco Dolcini (1):
      ASoC: sgtl5000: Fix noise on shutdown/remove

Gabriel Fernandez (1):
      ARM: dts: stm32: use the correct clock source for CEC on stm32mp151

Gal Pressman (1):
      net/mlx5e: Fix capability check for updating vnic env counters

Geert Uytterhoeven (1):
      sh: convert nommu io{re,un}map() to static inline functions

Gowans, James (1):
      mm: split huge PUD on wp_huge_pud fallback

Greg Kroah-Hartman (1):
      Linux 5.10.132

Hangyu Hua (2):
      drm/i915: fix a possible refcount leak in intel_dp_add_mst_connector()
      net: tipc: fix possible refcount leak in tipc_sk_create()

Haowen Bai (1):
      pinctrl: aspeed: Fix potential NULL dereference in aspeed_pinmux_set_mux()

Hector Martin (2):
      ASoC: tas2764: Correct playback volume range
      ASoC: tas2764: Fix amp gain register offset & default

Huaxin Lu (1):
      ima: Fix a potential integer overflow in ima_appraise_measurement

Ilpo Järvinen (3):
      serial: stm32: Clear prev values before setting RTS delays
      serial: pl011: UPSTAT_AUTORTS requires .throttle/unthrottle
      serial: 8250: Fix PM usage_count for console handover

Jianglei Nie (2):
      ima: Fix potential memory leak in ima_init_crypto()
      net: sfp: fix memory leak in sfp_probe()

John Garry (1):
      scsi: hisi_sas: Limit max hw sectors for v3 HW

Jon Hunter (1):
      net: stmmac: dwc-qos: Disable split header for Tegra194

Juergen Gross (3):
      xen/netback: avoid entering xenvif_rx_next_skb() with an empty rx queue
      x86: Clear .brk area at early boot
      x86/pat: Fix x86_has_pat_wp()

Kai-Heng Feng (1):
      platform/x86: hp-wmi: Ignore Sanitization Mode event

Keith Busch (1):
      nvme-pci: phison e16 has bogus namespace ids

Kris Bahnsen (1):
      ARM: dts: imx6qdl-ts7970: Fix ngpio typo and count

Kuniyuki Iwashima (18):
      sysctl: Fix data races in proc_dointvec().
      sysctl: Fix data races in proc_douintvec().
      sysctl: Fix data races in proc_dointvec_minmax().
      sysctl: Fix data races in proc_douintvec_minmax().
      sysctl: Fix data races in proc_doulongvec_minmax().
      sysctl: Fix data races in proc_dointvec_jiffies().
      tcp: Fix a data-race around sysctl_tcp_max_orphans.
      inetpeer: Fix data-races around sysctl.
      net: Fix data-races around sysctl_mem.
      cipso: Fix data-races around sysctl.
      icmp: Fix data-races around sysctl.
      ipv4: Fix a data-race around sysctl_fib_sync_mem.
      sysctl: Fix data-races in proc_dointvec_ms_jiffies().
      icmp: Fix a data-race around sysctl_icmp_ratelimit.
      icmp: Fix a data-race around sysctl_icmp_ratemask.
      raw: Fix a data-race around sysctl_raw_l3mdev_accept.
      ipv4: Fix data-races around sysctl_ip_dynaddr.
      nexthop: Fix data-races around nexthop_compat_mode.

Liang He (2):
      net: ftgmac100: Hold reference returned by of_get_child_by_name()
      cpufreq: pmac32-cpufreq: Fix refcount leak bug

Linus Torvalds (1):
      signal handling: don't use BUG_ON() for debugging

Linus Walleij (1):
      soc: ixp4xx/npe: Fix unused match warning

Linyu Yuan (1):
      usb: typec: add missing uevent when partner support PD

Lucien Buchmann (1):
      USB: serial: ftdi_sio: add Belimo device ids

Mark Brown (1):
      ASoC: ops: Fix off by one in range control validation

Martin Povišer (2):
      ASoC: tas2764: Add post reset delays
      ASoC: tas2764: Fix and extend FSYNC polarity handling

Meng Tang (6):
      ALSA: hda - Add fixup for Dell Latitidue E5430
      ALSA: hda/conexant: Apply quirk for another HP ProDesk 600 G3 model
      ALSA: hda/realtek: Fix headset mic for Acer SF313-51
      ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc671
      ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc221
      ALSA: hda/realtek - Enable the headset-mic on a Xiaomi's laptop

Michael Walle (1):
      NFC: nxp-nci: don't print header length mismatch on i2c error

Michal Suchanek (1):
      ARM: dts: sunxi: Fix SPI NOR campatible on Orange Pi Zero

Muchun Song (1):
      mm: sysctl: fix missing numa_stat when !CONFIG_HUGETLB_PAGE

Nicolas Dichtel (1):
      ip: fix dflt addr selection for connected nexthop

Oleg Nesterov (1):
      fix race between exit_itimers() and /proc/pid/timers

Peter Ujfalusi (3):
      ASoC: Intel: Skylake: Correct the ssp rate discovery in skl_get_ssp_clks()
      ASoC: Intel: Skylake: Correct the handling of fmt_config flexible array
      ASoC: SOF: Intel: hda-loader: Clarify the cl_dsp_init() flow

Ruozhu Li (1):
      nvme: fix regression when disconnect a recovering ctrl

Ryan Wanner (1):
      ARM: dts: at91: sama5d2: Fix typo in i2s1 node

Ryusuke Konishi (1):
      nilfs2: fix incorrect masking of permission flags for symlinks

Sagi Grimberg (1):
      nvme-tcp: always fail a request when sending it failed

Srinivas Neeli (1):
      Revert "can: xilinx_can: Limit CANFD brp to 2"

Stafford Horne (1):
      irqchip: or1k-pic: Undefine mask_ack for level triggered hardware

Stephan Gerhold (2):
      virtio_mmio: Add missing PM calls to freeze/restore
      virtio_mmio: Restore guest page size on resume

Steven Rostedt (Google) (1):
      net: sock: tracing: Fix sock_exceed_buf_limit not to dereference stale pointer

Tariq Toukan (3):
      net/mlx5e: kTLS, Fix build time constant test in TX
      net/mlx5e: kTLS, Fix build time constant test in RX
      net/tls: Check for errors in tls_device_init

Tejun Heo (1):
      cgroup: Use separate src/dst nodes when preloading css_sets for migration

Thinh Nguyen (1):
      usb: dwc3: gadget: Fix event pending check

Vitaly Kuznetsov (1):
      KVM: x86: Fully initialize 'struct kvm_lapic_irq' in kvm_pv_kick_cpu_op()

Xiu Jianfeng (1):
      Revert "evm: Fix memleak in init_desc"

Yangxi Xiang (1):
      vt: fix memory overlapping when deleting chars in the buffer

Yi Yang (1):
      serial: 8250: fix return error code in serial8250_request_std_resource()

Zhen Lei (1):
      ARM: 9210/1: Mark the FDT_FIXED sections as shareable

Zheng Yejian (1):
      tracing/histograms: Fix memory leak problem

Íñigo Huguet (2):
      sfc: fix use after free when disabling sriov
      sfc: fix kernel panic when creating VF

