Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272CB6860CF
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 08:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjBAHnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 02:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjBAHnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 02:43:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C933D29E05;
        Tue, 31 Jan 2023 23:43:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A7E5B82105;
        Wed,  1 Feb 2023 07:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAFEC433EF;
        Wed,  1 Feb 2023 07:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675237415;
        bh=or0jhhIOvoV640M21K8cZtu3OFTHHH01sJ8y+H+Sljk=;
        h=From:To:Cc:Subject:Date:From;
        b=vfTxh/s/VpuQtsT0rlCARVvap4feA5/dMtPhHL3ny6vi8Mh/TSRKcm/+m0kPdEARA
         dtVRL6CwCeJeXLaUXgqcAG/aX+n1tYsmZBjCwbYpPcQkZiZtTRANIOLYz9JJWXp3Yz
         2Bw7fsUdK9y2XpO3WoTPUwBU/tbj70CyY43utf7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.166
Date:   Wed,  1 Feb 2023 08:43:27 +0100
Message-Id: <167523740789253@kroah.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.166 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-kernel-oops_count                                                  |    6 
 Documentation/ABI/testing/sysfs-kernel-warn_count                                                  |    6 
 Documentation/admin-guide/sysctl/kernel.rst                                                        |   19 
 Makefile                                                                                           |    2 
 arch/alpha/kernel/traps.c                                                                          |    6 
 arch/alpha/mm/fault.c                                                                              |    2 
 arch/arm/boot/dts/imx6qdl-gw560x.dtsi                                                              |    1 
 arch/arm/boot/dts/imx6ul-pico-dwarf.dts                                                            |    2 
 arch/arm/boot/dts/imx7d-pico-dwarf.dts                                                             |    4 
 arch/arm/boot/dts/imx7d-pico-nymph.dts                                                             |    4 
 arch/arm/boot/dts/sam9x60.dtsi                                                                     |    2 
 arch/arm/kernel/traps.c                                                                            |    2 
 arch/arm/mach-imx/cpu-imx25.c                                                                      |    1 
 arch/arm/mach-imx/cpu-imx27.c                                                                      |    1 
 arch/arm/mach-imx/cpu-imx31.c                                                                      |    1 
 arch/arm/mach-imx/cpu-imx35.c                                                                      |    1 
 arch/arm/mach-imx/cpu-imx5.c                                                                       |    1 
 arch/arm/mm/fault.c                                                                                |    2 
 arch/arm/mm/nommu.c                                                                                |    2 
 arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi                                         |    4 
 arch/arm64/kernel/traps.c                                                                          |    2 
 arch/arm64/mm/fault.c                                                                              |    2 
 arch/csky/abiv1/alignment.c                                                                        |    2 
 arch/csky/kernel/traps.c                                                                           |    2 
 arch/h8300/kernel/traps.c                                                                          |    3 
 arch/h8300/mm/fault.c                                                                              |    2 
 arch/hexagon/kernel/traps.c                                                                        |    2 
 arch/ia64/Kconfig                                                                                  |    2 
 arch/ia64/kernel/mca_drv.c                                                                         |    2 
 arch/ia64/kernel/traps.c                                                                           |    2 
 arch/ia64/mm/fault.c                                                                               |    2 
 arch/m68k/kernel/traps.c                                                                           |    2 
 arch/m68k/mm/fault.c                                                                               |    2 
 arch/microblaze/kernel/exceptions.c                                                                |    4 
 arch/mips/kernel/traps.c                                                                           |    2 
 arch/nds32/kernel/fpu.c                                                                            |    2 
 arch/nds32/kernel/traps.c                                                                          |    8 
 arch/nios2/kernel/traps.c                                                                          |    4 
 arch/openrisc/kernel/traps.c                                                                       |    2 
 arch/parisc/kernel/traps.c                                                                         |    2 
 arch/powerpc/kernel/traps.c                                                                        |    2 
 arch/riscv/kernel/traps.c                                                                          |    2 
 arch/riscv/mm/fault.c                                                                              |    2 
 arch/s390/include/asm/debug.h                                                                      |    6 
 arch/s390/kernel/dumpstack.c                                                                       |    2 
 arch/s390/kernel/nmi.c                                                                             |    2 
 arch/s390/kvm/interrupt.c                                                                          |   12 
 arch/sh/kernel/traps.c                                                                             |    2 
 arch/sparc/kernel/traps_32.c                                                                       |    4 
 arch/sparc/kernel/traps_64.c                                                                       |    4 
 arch/x86/entry/entry_32.S                                                                          |    6 
 arch/x86/entry/entry_64.S                                                                          |    6 
 arch/x86/events/amd/core.c                                                                         |    2 
 arch/x86/kernel/acpi/cstate.c                                                                      |   15 
 arch/x86/kernel/dumpstack.c                                                                        |    4 
 arch/x86/kernel/i8259.c                                                                            |    1 
 arch/x86/kernel/irqinit.c                                                                          |    4 
 arch/x86/kvm/vmx/vmx.c                                                                             |   21 
 arch/xtensa/kernel/traps.c                                                                         |    2 
 block/blk-core.c                                                                                   |    4 
 drivers/base/test/test_async_driver_probe.c                                                        |    2 
 drivers/clk/clk-devres.c                                                                           |   91 ++
 drivers/cpufreq/armada-37xx-cpufreq.c                                                              |    2 
 drivers/cpufreq/cpufreq-dt-platdev.c                                                               |    1 
 drivers/dma/dmaengine.c                                                                            |    7 
 drivers/dma/xilinx/xilinx_dma.c                                                                    |    4 
 drivers/edac/edac_device.c                                                                         |   15 
 drivers/edac/highbank_mc_edac.c                                                                    |    7 
 drivers/edac/qcom_edac.c                                                                           |    5 
 drivers/firmware/arm_scmi/shmem.c                                                                  |    9 
 drivers/gpio/gpio-mxc.c                                                                            |    2 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                                                     |    6 
 drivers/gpu/drm/nouveau/nouveau_bo.c                                                               |    9 
 drivers/gpu/drm/panfrost/Kconfig                                                                   |    3 
 drivers/hid/hid-betopff.c                                                                          |   17 
 drivers/hid/hid-bigbenff.c                                                                         |    5 
 drivers/hid/hid-core.c                                                                             |    4 
 drivers/hid/hid-ids.h                                                                              |    1 
 drivers/hid/hid-quirks.c                                                                           |    1 
 drivers/hid/intel-ish-hid/ishtp/dma-if.c                                                           |   10 
 drivers/i2c/busses/i2c-designware-common.c                                                         |   11 
 drivers/i2c/busses/i2c-designware-platdrv.c                                                        |    5 
 drivers/infiniband/core/verbs.c                                                                    |    7 
 drivers/infiniband/hw/hfi1/user_exp_rcv.c                                                          |  200 ++++--
 drivers/infiniband/hw/hfi1/user_exp_rcv.h                                                          |    3 
 drivers/input/mouse/synaptics.c                                                                    |    1 
 drivers/memory/atmel-sdramc.c                                                                      |    6 
 drivers/memory/mvebu-devbus.c                                                                      |    3 
 drivers/net/dsa/microchip/ksz9477.c                                                                |    4 
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c                                                           |   23 
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c                                                          |   24 
 drivers/net/ethernet/amd/xgbe/xgbe.h                                                               |    2 
 drivers/net/ethernet/broadcom/tg3.c                                                                |    8 
 drivers/net/ethernet/cadence/macb_main.c                                                           |    9 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                                                     |    8 
 drivers/net/ethernet/renesas/ravb_main.c                                                           |    4 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                                                  |    5 
 drivers/net/mdio/mdio-mux-meson-g12a.c                                                             |   23 
 drivers/net/phy/mdio_bus.c                                                                         |    7 
 drivers/net/usb/sr9700.c                                                                           |    2 
 drivers/net/wan/fsl_ucc_hdlc.c                                                                     |    6 
 drivers/net/wireless/rndis_wlan.c                                                                  |   19 
 drivers/nvme/host/pci.c                                                                            |    2 
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c                                                      |    4 
 drivers/phy/ti/Kconfig                                                                             |    4 
 drivers/platform/x86/asus-nb-wmi.c                                                                 |    1 
 drivers/platform/x86/touchscreen_dmi.c                                                             |   25 
 drivers/scsi/hisi_sas/hisi_sas_main.c                                                              |    2 
 drivers/scsi/hpsa.c                                                                                |    2 
 drivers/scsi/scsi_transport_iscsi.c                                                                |   50 +
 drivers/soc/qcom/cpr.c                                                                             |    6 
 drivers/spi/spidev.c                                                                               |    2 
 drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c                                       |   28 
 drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h                                       |    1 
 drivers/usb/gadget/function/f_fs.c                                                                 |    7 
 drivers/usb/host/xhci.c                                                                            |    2 
 drivers/w1/w1.c                                                                                    |    6 
 drivers/w1/w1_int.c                                                                                |    5 
 fs/affs/file.c                                                                                     |    2 
 fs/cifs/smbdirect.c                                                                                |    1 
 fs/nfsd/netns.h                                                                                    |    6 
 fs/nfsd/nfs4state.c                                                                                |    8 
 fs/nfsd/nfsctl.c                                                                                   |   14 
 fs/nfsd/nfsd.h                                                                                     |    3 
 fs/nfsd/nfssvc.c                                                                                   |   35 +
 fs/proc/proc_sysctl.c                                                                              |   33 
 fs/reiserfs/super.c                                                                                |    6 
 include/linux/clk.h                                                                                |  109 +++
 include/linux/kernel.h                                                                             |    7 
 include/linux/sched/task.h                                                                         |    1 
 include/linux/sysctl.h                                                                             |    3 
 include/linux/units.h                                                                              |   20 
 include/net/sch_generic.h                                                                          |    7 
 include/net/sock.h                                                                                 |    2 
 include/scsi/scsi_transport_iscsi.h                                                                |    9 
 include/uapi/linux/netfilter/nf_conntrack_sctp.h                                                   |    2 
 include/uapi/linux/netfilter/nfnetlink_cttimeout.h                                                 |    2 
 kernel/bpf/verifier.c                                                                              |    4 
 kernel/exit.c                                                                                      |   72 ++
 kernel/kcsan/kcsan-test.c                                                                          |    7 
 kernel/kcsan/report.c                                                                              |    4 
 kernel/module.c                                                                                    |   26 
 kernel/panic.c                                                                                     |   90 ++
 kernel/sched/core.c                                                                                |    3 
 kernel/sysctl.c                                                                                    |   11 
 kernel/trace/trace.c                                                                               |    2 
 kernel/trace/trace.h                                                                               |    1 
 kernel/trace/trace_events_hist.c                                                                   |    2 
 kernel/trace/trace_output.c                                                                        |    3 
 lib/lockref.c                                                                                      |    1 
 lib/nlattr.c                                                                                       |    3 
 lib/ubsan.c                                                                                        |   11 
 mm/kasan/report.c                                                                                  |   12 
 net/bluetooth/hci_core.c                                                                           |    1 
 net/core/net_namespace.c                                                                           |    2 
 net/ipv4/fib_semantics.c                                                                           |    2 
 net/ipv4/inet_hashtables.c                                                                         |   17 
 net/ipv4/inet_timewait_sock.c                                                                      |    8 
 net/ipv4/metrics.c                                                                                 |    2 
 net/ipv4/tcp.c                                                                                     |    2 
 net/l2tp/l2tp_core.c                                                                               |  116 +--
 net/netfilter/nf_conntrack_proto_sctp.c                                                            |  118 +--
 net/netfilter/nf_conntrack_proto_tcp.c                                                             |   10 
 net/netfilter/nf_conntrack_standalone.c                                                            |    8 
 net/netfilter/nft_set_rbtree.c                                                                     |  332 ++++++----
 net/netlink/af_netlink.c                                                                           |   38 -
 net/netrom/nr_timer.c                                                                              |    1 
 net/nfc/llcp_core.c                                                                                |    1 
 net/sched/sch_taprio.c                                                                             |    2 
 net/sctp/bind_addr.c                                                                               |    6 
 scripts/tracing/ftrace-bisect.sh                                                                   |   34 -
 security/tomoyo/Makefile                                                                           |    2 
 sound/soc/fsl/fsl-asoc-card.c                                                                      |    8 
 sound/soc/fsl/fsl_micfil.c                                                                         |   16 
 sound/soc/fsl/fsl_ssi.c                                                                            |    4 
 tools/gpio/gpio-event-mon.c                                                                        |    1 
 tools/objtool/check.c                                                                              |    3 
 tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c                                        |    9 
 tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c                                        |   42 -
 tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc |   35 -
 180 files changed, 1529 insertions(+), 764 deletions(-)

Adam Ford (1):
      arm64: dts: imx8mm-beacon: Fix ecspi2 pinmux

Alexander Potapenko (1):
      affs: initialize fsdata in affs_truncate()

Alexey V. Vissarionov (1):
      scsi: hpsa: Fix allocation size for scsi_host_alloc()

Andy Shevchenko (2):
      units: Add SI metric prefix definitions
      i2c: designware: Use DIV_ROUND_CLOSEST() macro

Archie Pusaka (1):
      Bluetooth: hci_sync: cancel cmd_timer if hci_open failed

Arnd Bergmann (1):
      drm/panfrost: fix GENERIC_ATOMIC64 dependency

Bartosz Golaszewski (1):
      spi: spidev: remove debug messages that access spidev->spi without locking

Chancel Liu (1):
      ASoC: fsl_micfil: Correct the number of steps on SX controls

Chen Zhongjin (1):
      driver core: Fix test_async_probe_init saves device in wrong array

Christoph Hellwig (1):
      block: fix and cleanup bio_check_ro

Christophe JAILLET (1):
      PM: AVS: qcom-cpr: Fix an error handling path in cpr_probe()

Claudiu Beznea (1):
      ARM: dts: at91: sam9x60: fix the ddr clock for sam9x60

Colin Ian King (1):
      perf/x86/amd: fix potential integer overflow on shift of a int

Cong Wang (2):
      l2tp: convert l2tp_tunnel_list to idr
      l2tp: close all race conditions in l2tp_tunnel_register()

Cristian Marussi (2):
      firmware: arm_scmi: Harden shared memory access in fetch_response
      firmware: arm_scmi: Harden shared memory access in fetch_notification

Daniel Lezcano (1):
      units: Add Watt units

Dario Binacchi (1):
      ARM: imx: add missing of_node_put()

David Christensen (1):
      net/tg3: resolve deadlock in tg3_reset_task() during EEH

David Howells (1):
      cifs: Fix oops due to uncleared server->smbd_conn in reconnect

David Morley (1):
      tcp: fix rate_app_limited to default to 1

Dean Luick (5):
      IB/hfi1: Reject a zero-length user expected buffer
      IB/hfi1: Reserve user expected TIDs
      IB/hfi1: Fix expected receive setup error exit issues
      IB/hfi1: Immediately remove invalid memory from hardware
      IB/hfi1: Remove user expected buffer invalidate race

Deepak Sharma (1):
      x86: ACPI: cstate: Optimize C3 entry on AMD CPUs

Dmitry Torokhov (1):
      Revert "Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode"

Dongliang Mu (1):
      fs: reiserfs: remove useless new_opts in reiserfs_remount

Eric Dumazet (9):
      net/sched: sch_taprio: fix possible use-after-free
      l2tp: prevent lockdep issue in l2tp_tunnel_register()
      netlink: prevent potential spectre v1 gadgets
      netlink: annotate data races around nlk->portid
      netlink: annotate data races around dst_portid and dst_group
      netlink: annotate data races around sk_state
      ipv4: prevent potential spectre v1 gadget in ip_metrics_convert()
      ipv4: prevent potential spectre v1 gadget in fib_metrics_match()
      net/sched: sch_taprio: do not schedule in taprio_reset()

Eric W. Biederman (2):
      exit: Add and use make_task_dead.
      objtool: Add a missing comma to avoid string concatenation

Esina Ekaterina (1):
      net: wan: Add checks for NULL for utdm in undo_uhdlc_init and unmap_si_regs

Fabio Estevam (3):
      ARM: dts: imx6ul-pico-dwarf: Use 'clock-frequency'
      ARM: dts: imx7d-pico: Use 'clock-frequency'
      ARM: dts: imx6qdl-gw560x: Remove incorrect 'uart-has-rtscts'

Florian Westphal (1):
      netfilter: conntrack: do not renew entry stuck in tcp SYN_SENT state

Gaosheng Cui (2):
      memory: atmel-sdramc: Fix missing clk_disable_unprepare in atmel_ramc_probe()
      memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()

Giulio Benetti (1):
      ARM: 9280/1: mm: fix warning on phys_addr_t to void pointer assignment

Greg Kroah-Hartman (1):
      Linux 5.10.166

Hans de Goede (1):
      platform/x86: asus-nb-wmi: Add alternate mapping for KEY_SCREENLOCK

Heiko Carstens (1):
      KVM: s390: interrupt: use READ_ONCE() before cmpxchg()

Heiner Kallweit (2):
      net: mdio: validate parameter addr in mdiobus_get_phy()
      net: stmmac: fix invalid call to mdiobus_get_phy()

Hendrik Borghorst (1):
      KVM: x86/vmx: Do not skip segment attributes if unusable bit is set

Ivo Borisov Shopov (1):
      tools: gpio: fix -c option of gpio-event-mon

Jakub Sitnicki (2):
      l2tp: Serialize access to sk_user_data with sk_callback_lock
      l2tp: Don't sleep and disable BH under writer-side sk_callback_lock

Jann Horn (1):
      exit: Put an upper limit on how often we can oops

Jason Xing (1):
      tcp: avoid the lookup process failing to get sk in ehash table

Jerome Brunet (1):
      net: mdio-mux-meson-g12a: force internal PHY off on mux switch

Jiasheng Jiang (1):
      HID: intel_ish-hid: Add check for ishtp_dma_tx_map

Jiri Kosina (1):
      HID: revert CHERRY_MOUSE_000C quirk

Jisoo Jang (1):
      net: nfc: Fix use-after-free in local_cleanup()

Karol Herbst (1):
      nouveau: explicitly wait on the fence in nouveau_bo_move_m2mf

Kees Cook (8):
      panic: Separate sysctl logic from CONFIG_SMP
      exit: Expose "oops_count" to sysfs
      exit: Allow oops_limit to be disabled
      panic: Consolidate open-coded panic_on_warn checks
      panic: Introduce warn_limit
      panic: Expose "warn_count" to sysfs
      docs: Fix path paste-o for /sys/kernel/warn_count
      exit: Use READ_ONCE() for all oops/warn limit reads

Keith Busch (1):
      nvme-pci: fix timeout request state check

Kishon Vijay Abraham I (1):
      xhci: Set HCD flag to defer primary roothub registration

Koba Ko (1):
      dmaengine: Fix double increment of client_count in dma_chan_get()

Kuniyuki Iwashima (1):
      netrom: Fix use-after-free of a listening socket.

Lareine Khawaly (1):
      i2c: designware: use casting of u64 in clock multiplication to avoid overflow

Liu Shixin (1):
      dmaengine: xilinx_dma: call of_node_put() when breaking out of for_each_child_of_node()

Luis Gerhorst (1):
      bpf: Fix pointer-leak due to insufficient speculative store bypass mitigation

Manivannan Sadhasivam (2):
      EDAC/device: Respect any driver-supplied workqueue polling value
      EDAC/qcom: Do not pass llcc_driv_data as edac_device_ctl_info's pvt_info

Marcelo Ricardo Leitner (1):
      sctp: fail if no bound addresses can be used for a given scope

Marek Vasut (1):
      gpio: mxc: Always set GPIOs used as interrupt source to INPUT mode

Mark Brown (2):
      ASoC: fsl_ssi: Rename AC'97 streams to avoid collisions with AC'97 CODEC
      ASoC: fsl-asoc-card: Fix naming of AC'97 CODEC widgets

Masahiro Yamada (1):
      tomoyo: fix broken dependency on *.conf.default

Mateusz Guzik (1):
      lockref: stop doing cpu_relax in the cmpxchg loop

Max Filippov (1):
      kcsan: test: don't put the expect array on the stack

Miaoqian Lin (1):
      EDAC/highbank: Fix memory leak in highbank_mc_probe()

Michael Klein (1):
      platform/x86: touchscreen_dmi: Add info for the CSL Panther Tab HD

Miles Chen (1):
      cpufreq: armada-37xx: stop using 0 as NULL pointer

Natalia Petrova (1):
      trace_events_hist: add check for return value of 'create_hist_field'

Nathan Chancellor (3):
      hexagon: Fix function name in die()
      h8300: Fix build errors from do_exit() to make_task_dead() transition
      csky: Fix function name in csky_alignment() and die()

Niklas Schnelle (1):
      s390/debug: add _ASM_S390_ prefix to header guard

Pablo Neira Ayuso (2):
      netfilter: nft_set_rbtree: Switch to node list walk for overlap detection
      netfilter: nft_set_rbtree: skip elements in transaction from garbage collection

Paolo Abeni (1):
      net: fix UaF in netns ops registration error path

Patrick Thompson (1):
      drm: Add orientation quirk for Lenovo ideapad D330-10IGL

Petr Pavlu (1):
      module: Don't wait for GOING modules

Pietro Borrello (3):
      HID: check empty report_list in hid_validate_values()
      HID: check empty report_list in bigben_probe()
      HID: betop: check shape of output reports

Rafael J. Wysocki (1):
      thermal: intel: int340x: Add locking to int340x_thermal_get_trip_type()

Raju Rangoju (2):
      amd-xgbe: TX Flow Ctrl Registers are h/w ver dependent
      amd-xgbe: Delay AN timeout during KR training

Rakesh Sankaranarayanan (1):
      net: dsa: microchip: ksz9477: port map correction in ALU table entry register

Randy Dunlap (3):
      phy: ti: fix Kconfig warning and operator precedence
      net: mlx5: eliminate anonymous module_init & module_exit
      ia64: make IA64_MCA_RECOVERY bool instead of tristate

Robert Hancock (1):
      net: macb: fix PTP TX timestamp failure due to packet padding

Sasha Levin (1):
      Revert "selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID"

Shang XiaoJing (1):
      phy: rockchip-inno-usb2: Fix missing clk_disable_unprepare() in rockchip_usb2phy_power_on()

Srinivas Pandruvada (1):
      thermal: intel: int340x: Protect trip temperature from concurrent updates

Sriram Yagnaraman (2):
      netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE
      netfilter: conntrack: unify established states for SCTP paths

Steven Rostedt (Google) (2):
      tracing: Make sure trace_printk() can output as soon as it can be used
      ftrace/scripts: Update the instructions for ftrace-bisect.sh

Sumit Gupta (1):
      cpufreq: Add Tegra234 to cpufreq-dt-platdev blocklist

Szymon Heidrich (2):
      wifi: rndis_wlan: Prevent buffer overflow in rndis_query_oid
      net: usb: sr9700: Handle negative len

Thomas Gleixner (1):
      x86/i8259: Mark legacy PIC interrupts with IRQ_LEVEL

Tiezhu Yang (3):
      panic: unset panic_on_warn inside panic()
      ubsan: no need to unset panic_on_warn in ubsan_epilogue()
      kasan: no need to unset panic_on_warn in end_report()

Trond Myklebust (1):
      nfsd: Ensure knfsd shuts down when the "nfsd" pseudofs is unmounted

Udipto Goswami (2):
      usb: gadget: f_fs: Prevent race during ffs_ep0_queue_wait
      usb: gadget: f_fs: Ensure ep0req is dequeued before free_request

Uwe Kleine-König (3):
      clk: generalize devm_clk_get() a bit
      clk: Provide new devm_clk helpers for prepared and enabled clocks
      clk: Fix pointer casting to prevent oops in devm_clk_release()

Wenchao Hao (1):
      scsi: iscsi: Fix multiple iSCSI session unbind events sent to userspace

Xiaoming Ni (1):
      sysctl: add a new register_sysctl_init() interface

Yang Yingliang (2):
      w1: fix deadloop in __w1_remove_master_device()
      w1: fix WARNING after calling w1_process()

Yihang Li (1):
      scsi: hisi_sas: Set a port invalid only if there are no devices attached when refreshing port id

Yonatan Nachum (1):
      RDMA/core: Fix ib block iterator counter overflow

Yoshihiro Shimoda (1):
      net: ravb: Fix possible hang if RIS2_QFF1 happen

Zheng Yejian (1):
      Revert "selftests/ftrace: Update synthetic event syntax errors"

tangmeng (1):
      kernel/panic: move panic sysctls to its own file

