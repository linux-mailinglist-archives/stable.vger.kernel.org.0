Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81FC96E904D
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 12:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbjDTKeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 06:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbjDTKeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 06:34:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EB73C0F;
        Thu, 20 Apr 2023 03:31:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 643CC61158;
        Thu, 20 Apr 2023 10:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79021C433D2;
        Thu, 20 Apr 2023 10:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681986697;
        bh=Gpr+7syIDuQwbkkqEBJDLQWIKkpZYpa6SKLBVqrM7EU=;
        h=From:To:Cc:Subject:Date:From;
        b=uJ3z3J+8RsvFcRYdmo/UqLQz3041AQPxQBgL546/HQondyx/AAf6sEHhizSIkf74H
         p4/YaCu6RleG9Hbhb2xVjPD+GWTY4KDgyZCdReybTRl3QL2ZY0/xz7ek48iLN6u6Ex
         0TnqL2+M3PW1SwxGRBpVIyc8MOZ42F6IHO/Um1eQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.178
Date:   Thu, 20 Apr 2023 12:31:34 +0200
Message-Id: <2023042034-unicycle-copious-d453@gregkh>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.178 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/serial/renesas,scif.yaml |    4 
 Documentation/networking/ip-sysctl.rst                     |    2 
 Documentation/powerpc/associativity.rst                    |  104 +
 Documentation/sound/hd-audio/models.rst                    |    2 
 Makefile                                                   |   10 
 arch/powerpc/include/asm/firmware.h                        |    7 
 arch/powerpc/include/asm/prom.h                            |    3 
 arch/powerpc/include/asm/topology.h                        |    6 
 arch/powerpc/kernel/prom_init.c                            |    3 
 arch/powerpc/mm/numa.c                                     |  433 +++-
 arch/powerpc/platforms/pseries/firmware.c                  |    3 
 arch/powerpc/platforms/pseries/hotplug-cpu.c               |    2 
 arch/powerpc/platforms/pseries/hotplug-memory.c            |    2 
 arch/powerpc/platforms/pseries/lpar.c                      |    4 
 arch/powerpc/platforms/pseries/papr_scm.c                  |    7 
 arch/riscv/Kconfig                                         |   22 
 arch/riscv/Makefile                                        |   12 
 arch/riscv/kernel/signal.c                                 |    9 
 arch/s390/kvm/intercept.c                                  |   32 
 arch/x86/kernel/sysfb_efi.c                                |    8 
 arch/x86/kernel/x86_init.c                                 |    4 
 arch/x86/pci/fixup.c                                       |   21 
 crypto/asymmetric_keys/pkcs7_verify.c                      |   10 
 crypto/asymmetric_keys/verify_pefile.c                     |   32 
 drivers/clk/sprd/common.c                                  |    9 
 drivers/gpio/Kconfig                                       |    2 
 drivers/gpio/gpio-davinci.c                                |    2 
 drivers/gpu/drm/armada/armada_drv.c                        |    1 
 drivers/gpu/drm/bridge/lontium-lt9611.c                    |    1 
 drivers/gpu/drm/drm_panel_orientation_quirks.c             |   13 
 drivers/gpu/drm/nouveau/dispnv50/disp.c                    |   32 
 drivers/gpu/drm/nouveau/nouveau_dp.c                       |    8 
 drivers/gpu/drm/panfrost/panfrost_mmu.c                    |    1 
 drivers/hv/connection.c                                    |    4 
 drivers/hwtracing/coresight/coresight-etm4x-core.c         |    2 
 drivers/i2c/busses/i2c-imx-lpi2c.c                         |    2 
 drivers/i2c/busses/i2c-ocores.c                            |   35 
 drivers/iio/adc/ad7791.c                                   |    2 
 drivers/iio/adc/ti-ads7950.c                               |    1 
 drivers/iio/dac/cio-dac.c                                  |    4 
 drivers/iio/light/cm32181.c                                |   12 
 drivers/infiniband/core/cma.c                              |   60 
 drivers/infiniband/core/verbs.c                            |    2 
 drivers/infiniband/hw/mlx5/main.c                          |   16 
 drivers/media/platform/ti-vpe/cal.c                        |    4 
 drivers/mtd/mtdblock.c                                     |   12 
 drivers/mtd/nand/raw/meson_nand.c                          |    6 
 drivers/mtd/nand/raw/stm32_fmc2_nand.c                     |    3 
 drivers/mtd/ubi/build.c                                    |   21 
 drivers/mtd/ubi/wl.c                                       |    5 
 drivers/net/ethernet/cadence/macb_main.c                   |    4 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c            |    8 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c          |    6 
 drivers/net/ethernet/sun/niu.c                             |    2 
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                   |    6 
 drivers/net/phy/sfp.c                                      |   13 
 drivers/net/wireless/marvell/mwifiex/pcie.c                |    2 
 drivers/net/wireless/marvell/mwifiex/sdio.c                |    2 
 drivers/pinctrl/pinctrl-amd.c                              |   36 
 drivers/power/supply/cros_usbpd-charger.c                  |    2 
 drivers/pwm/pwm-cros-ec.c                                  |    1 
 drivers/pwm/pwm-sprd.c                                     |    1 
 drivers/scsi/iscsi_tcp.c                                   |    3 
 drivers/scsi/ses.c                                         |   20 
 drivers/tty/serial/fsl_lpuart.c                            |    8 
 drivers/tty/serial/sh-sci.c                                |   10 
 drivers/usb/host/xhci-tegra.c                              |    6 
 drivers/usb/host/xhci.c                                    |    6 
 drivers/usb/serial/cp210x.c                                |    1 
 drivers/usb/serial/option.c                                |   10 
 drivers/usb/typec/altmodes/displayport.c                   |    6 
 drivers/video/fbdev/core/fbmem.c                           |    2 
 drivers/watchdog/sbsa_gwdt.c                               |    1 
 fs/btrfs/disk-io.c                                         |   17 
 fs/btrfs/super.c                                           |    2 
 fs/nfsd/nfs4callback.c                                     |    4 
 fs/nilfs2/segment.c                                        |    3 
 fs/nilfs2/super.c                                          |    2 
 fs/nilfs2/the_nilfs.c                                      |   12 
 fs/ocfs2/dlmglue.c                                         |    8 
 fs/ocfs2/super.c                                           |    3 
 fs/proc/proc_sysctl.c                                      |    6 
 include/linux/ftrace.h                                     |    2 
 include/linux/kexec.h                                      |    2 
 include/linux/sysctl.h                                     |    2 
 include/net/netns/ipv4.h                                   |  100 
 init/Kconfig                                               |   12 
 kernel/cgroup/cpuset.c                                     |    6 
 kernel/events/core.c                                       |    2 
 kernel/kexec.c                                             |   41 
 kernel/kexec_core.c                                        |   28 
 kernel/kexec_file.c                                        |    4 
 kernel/kexec_internal.h                                    |   15 
 kernel/ksysfs.c                                            |    7 
 kernel/sched/fair.c                                        |   15 
 kernel/sysctl.c                                            |   65 
 kernel/trace/ftrace.c                                      |   15 
 kernel/trace/ring_buffer.c                                 |   13 
 kernel/trace/trace.c                                       |    1 
 mm/swapfile.c                                              |    3 
 net/9p/trans_xen.c                                         |    4 
 net/bluetooth/hidp/core.c                                  |    2 
 net/bluetooth/l2cap_core.c                                 |   24 
 net/can/isotp.c                                            |   17 
 net/can/j1939/transport.c                                  |    5 
 net/core/netpoll.c                                         |   19 
 net/ipv4/icmp.c                                            |    5 
 net/ipv4/sysctl_net_ipv4.c                                 |  203 +-
 net/ipv6/ip6_output.c                                      |    7 
 net/ipv6/udp.c                                             |    8 
 net/mac80211/sta_info.c                                    |    3 
 net/qrtr/Makefile                                          |    3 
 net/qrtr/af_qrtr.c                                         | 1303 +++++++++++++
 net/qrtr/ns.c                                              |   15 
 net/qrtr/qrtr.c                                            | 1288 ------------
 net/sctp/socket.c                                          |    4 
 net/sctp/stream_interleave.c                               |    3 
 net/sunrpc/svcauth_unix.c                                  |   17 
 scripts/Kconfig.include                                    |    6 
 scripts/as-version.sh                                      |   69 
 scripts/dummy-tools/gcc                                    |    6 
 sound/firewire/tascam/tascam-stream.c                      |    2 
 sound/i2c/cs8427.c                                         |    7 
 sound/pci/emu10k1/emupcm.c                                 |    4 
 sound/pci/hda/patch_realtek.c                              |    1 
 sound/pci/hda/patch_sigmatel.c                             |   10 
 sound/soc/codecs/hdac_hdmi.c                               |   17 
 tools/lib/bpf/btf_dump.c                                   |   11 
 tools/testing/selftests/intel_pstate/aperf.c               |   22 
 129 files changed, 2779 insertions(+), 1854 deletions(-)

Alexander Stein (1):
      i2c: imx-lpi2c: clean rx/tx buffers upon new message

Andrii Nakryiko (1):
      libbpf: Fix single-line struct definition output in btf_dump

Aneesh Kumar K.V (6):
      powerpc/pseries: rename min_common_depth to primary_domain_index
      powerpc/pseries: Rename TYPE1_AFFINITY to FORM1_AFFINITY
      powerpc/pseries: Consolidate different NUMA distance update code paths
      powerpc/pseries: Add a helper for form1 cpu distance
      powerpc/pseries: Add support for FORM2 associativity
      powerpc/papr_scm: Update the NUMA distance table for the target node

Arnd Bergmann (1):
      kexec: move locking into do_kexec_load

Arseniy Krasnov (1):
      mtd: rawnand: meson: fix bitmask for length in command word

Bang Li (1):
      mtdblock: tolerate corrected bit-flips

Basavaraj Natikar (1):
      x86/PCI: Add quirk for AMD XHCI controller that loses MSI-X state in D3hot

Biju Das (2):
      tty: serial: sh-sci: Fix transmit end interrupt handler
      tty: serial: sh-sci: Fix Rx on RZ/G2L SCI

Bjørn Mork (1):
      USB: serial: option: add Quectel RM500U-CN modem

Boris Brezillon (1):
      drm/panfrost: Fix the panfrost_mmu_map_fault_addr() error path

Christoph Hellwig (1):
      btrfs: fix fast csum implementation detection

Christophe JAILLET (1):
      drm/armada: Fix a potential double free in an error handling path

Christophe Kerello (2):
      mtd: rawnand: stm32_fmc2: remove unsupported EDO mode
      mtd: rawnand: stm32_fmc2: use timings.mode instead of checking tRC_min

Chunyan Zhang (1):
      clk: sprd: set max_register according to mapping range

Corinna Vinschen (1):
      net: stmmac: fix up RX flow hash indirection table when setting channels

D Scott Phillips (1):
      xhci: also avoid the XHCI_ZERO_64B_REGS quirk with a passthrough iommu

Dai Ngo (1):
      NFSD: callback request does not use correct credential for AUTH_SYS

Daniel Vetter (1):
      fbmem: Reject FB_ACTIVATE_KD_TEXT from userspace

David Sterba (1):
      btrfs: print checksum type and implementation at mount time

Denis Plotnikov (1):
      qlcnic: check pci_reset_function result

Dhruva Gole (1):
      gpio: davinci: Add irq chip flag to skip set wake

Eduard Zingerman (1):
      bpftool: Print newline before '}' for struct with padding only fields

Enrico Sau (1):
      USB: serial: option: add Telit FE990 compositions

Eric Dumazet (5):
      icmp: guard against too small mtu
      sysctl: add proc_dou8vec_minmax()
      ipv4: shrink netns_ipv4 with sysctl conversions
      tcp: convert elligible sysctls to u8
      udp6: fix potential access to stale information

Felix Fietkau (1):
      wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta

Gaosheng Cui (1):
      Revert "media: ti: cal: fix possible memory leak in cal_ctx_create()"

Geert Uytterhoeven (1):
      dt-bindings: serial: renesas,scif: Fix 4th IRQ for 4-IRQ SCIFs

George Cherian (1):
      watchdog: sbsa_wdog: Make sure the timeout programming is within the limits

Grant Grundler (1):
      power: supply: cros_usbpd: reclassify "default case!" as debug

Greg Kroah-Hartman (1):
      Linux 5.10.178

Gregor Herburger (1):
      i2c: ocores: generate stop condition after timeout in polling mode

Hans de Goede (2):
      efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L
      drm: panel-orientation-quirks: Add quirk for Lenovo Yoga Book X90F

Harshit Mogalapalli (1):
      niu: Fix missing unwind goto in niu_alloc_channels()

Heming Zhao (1):
      ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown

Ivan Bornyakov (1):
      net: sfp: initialize sfp->i2c_block_size at sfp allocation

Jakub Kicinski (1):
      net: don't let netpoll invoke NAPI if in xmit context

Jason Montleon (1):
      ASoC: hdac_hdmi: use set_stream() instead of set_tdm_slots()

Jeff Layton (1):
      sunrpc: only free unix grouplist after RCU settles

Jeremy Soller (1):
      ALSA: hda/realtek: Add quirk for Clevo X370SNW

Jiri Kosina (1):
      scsi: ses: Handle enclosure with just a primary component gracefully

John Keeping (1):
      ftrace: Mark get_lock_parent_ip() __always_inline

Kai-Heng Feng (1):
      iio: light: cm32181: Unregister second I2C client if present

Kan Liang (1):
      perf/core: Fix the same task check in perf_event_set_output

Karol Herbst (1):
      drm/nouveau/disp: Support more modes by checking with lower bpc

Kees Jan Koster (1):
      USB: serial: cp210x: add Silicon Labs IFS-USB-DATACABLE IDs

Kornel Dulęba (1):
      Revert "pinctrl: amd: Disable and mask interrupts on resume"

Krzysztof Kozlowski (1):
      wifi: mwifiex: mark OF related data as maybe unused

Kuniyuki Iwashima (1):
      sysctl: Fix data-races in proc_dou8vec_minmax().

Lars-Peter Clausen (1):
      iio: adc: ti-ads7950: Set `can_sleep` flag for GPIO chip

Lee Jones (1):
      mtd: ubi: wl: Fix a couple of kernel-doc issues

Luca Weiss (1):
      net: qrtr: combine nameservice into main module

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}

Maher Sanalla (1):
      IB/mlx5: Add support for 400G_8X lane speed

Mark Zhang (1):
      RDMA/cma: Allow UD qp_type to join multicast only

Masahiro Yamada (2):
      kbuild: check the minimum assembler version in Kconfig
      kbuild: check CONFIG_AS_IS_LLVM instead of LLVM_IAS

Mathis Salmen (1):
      riscv: add icache flush for nommu sigreturn trampoline

Matija Glavinic Pecotic (1):
      x86/rtc: Remove __init for runtime functions

Meir Lichtinger (1):
      IB/mlx5: Add support for NDR link speed

Michal Sojka (1):
      can: isotp: isotp_ops: fix poll() to not report false EPOLLOUT events

Min Li (1):
      Bluetooth: Fix race condition in hidp_session_thread

Mohammed Gamal (1):
      Drivers: vmbus: Check for channel allocation before looking up relids

Nathan Chancellor (2):
      kbuild: Switch to 'f' variants of integrated assembler flag
      riscv: Handle zicsr/zifencei issues between clang and binutils

Nico Boehr (1):
      KVM: s390: pv: fix external interruption loop not always detected

Nuno Sá (1):
      iio: adc: ad7791: fix IRQ flags

Oleksij Rempel (1):
      can: j1939: j1939_tp_tx_dat_new(): fix out-of-bounds memory access

Oswald Buddenhagen (4):
      ALSA: emu10k1: fix capture interrupt handler unlinking
      ALSA: hda/sigmatel: add pin overrides for Intel DP45SG motherboard
      ALSA: i2c/cs8427: fix iec958 mixer control deactivation
      ALSA: hda/sigmatel: fix S/PDIF out on Intel D*45* motherboards

RD Babiera (1):
      usb: typec: altmodes/displayport: Fix configure initial pin assignment

Randy Dunlap (1):
      gpio: GPIO_REGMAP: select REGMAP instead of depending on it

Robbie Harwood (2):
      verify_pefile: relax wrapper length check
      asymmetric_keys: log on fatal failures in PE/pkcs7

Robert Foss (1):
      drm/bridge: lt9611: Fix PLL being unable to lock

Roman Gushchin (1):
      net: macb: fix a memory corruption in extended buffer descriptor mode

Rongwei Wang (1):
      mm/swap: fix swap_info_struct race between swapoff and get_swap_pages()

Ryusuke Konishi (2):
      nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()
      nilfs2: fix sysfs interface lifetime

Saravanan Vajravel (1):
      RDMA/core: Fix GID entry ref leak when create_ah fails

Sherry Sun (1):
      tty: serial: fsl_lpuart: avoid checking for transfer complete when UARTCTRL_SBK is asserted in lpuart32_tx_empty

Siddharth Vadapalli (1):
      net: ethernet: ti: am65-cpsw: Fix mdio cleanup in probe

Sricharan Ramabadhran (1):
      net: qrtr: Do not do DEL_SERVER broadcast after DEL_CLIENT

Steve Clevenger (1):
      coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug

Steven Rostedt (Google) (1):
      tracing: Free error logs of tracing instances

Tommi Rantala (1):
      selftests: intel_pstate: ftime() is deprecated

Uwe Kleine-König (2):
      pwm: cros-ec: Explicitly set .polarity in .get_state()
      pwm: sprd: Explicitly set .polarity in .get_state()

Valentin Schneider (2):
      kexec: turn all kexec_mutex acquisitions into trylocks
      panic, kexec: make __crash_kexec() NMI safe

Vincent Guittot (1):
      sched/fair: Fix imbalance overflow

Waiman Long (1):
      cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()

Wayne Chang (1):
      usb: xhci: tegra: fix sleep in atomic call

William Breathitt Gray (1):
      iio: dac: cio-dac: Fix max DAC write value check for 12-bit

Xin Long (2):
      sctp: check send stream number after wait_for_sndbuf
      sctp: fix a potential overflow in sctp_ifwdtsn_skip

Xu Biang (1):
      ALSA: firewire-tascam: add missing unwind goto in snd_tscm_stream_start_duplex()

YueHaibing (1):
      tcp: restrict net.ipv4.tcp_app_win

ZhaoLong Wang (1):
      ubi: Fix deadlock caused by recursively holding work_sem

Zheng Wang (1):
      9p/xen : Fix use after free bug in xen_9pfs_front_remove due to race condition

Zheng Yejian (2):
      ftrace: Fix issue that 'direct->addr' not restored in modify_ftrace_direct()
      ring-buffer: Fix race while reader and writer are on the same page

Zhihao Cheng (1):
      ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size

Zhong Jinghua (1):
      scsi: iscsi_tcp: Check that sock is valid before iscsi_set_param()

Ziyang Xuan (3):
      net: qrtr: Fix a refcount bug in qrtr_recvmsg()
      ipv6: Fix an uninit variable access bug in __ip6_make_skb()
      net: qrtr: Fix an uninit variable access bug in qrtr_tx_resume()

zgpeng (1):
      sched/fair: Move calculate of avg_load to a better location

