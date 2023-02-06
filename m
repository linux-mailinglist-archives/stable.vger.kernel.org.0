Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457EB68B651
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 08:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjBFH0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 02:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBFH0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 02:26:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AFF2681;
        Sun,  5 Feb 2023 23:26:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B60B2B80B9D;
        Mon,  6 Feb 2023 07:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E095CC433D2;
        Mon,  6 Feb 2023 07:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675668396;
        bh=lyZoZe3LHoBM3wQ0QaZJ1DWhWe0DsHlL8F8Aaa2Jm1A=;
        h=From:To:Cc:Subject:Date:From;
        b=2LX7svydDfHmS77YKO/LbgkBN9QTPgpRCgYIKW1QrkDsRt6F4QxxOVkING6eXE40t
         nr0qzyQVty4wyxm6Hvh+QP4j8f2+6FfB3cpUhery12FqXGd6KKlVOOIxm8e+xS65gT
         07aw9pFXmAjlgW1EHuV98VfAKS1DiuvkMokVTJZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.305
Date:   Mon,  6 Feb 2023 08:26:32 +0100
Message-Id: <16756683924720@kroah.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.305 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-kernel-oops_count           |    6 
 Documentation/ABI/testing/sysfs-kernel-warn_count           |    6 
 Documentation/sysctl/kernel.txt                             |   20 +++
 Makefile                                                    |    2 
 arch/alpha/kernel/traps.c                                   |    6 
 arch/alpha/mm/fault.c                                       |    2 
 arch/arm/boot/dts/imx6qdl-gw560x.dtsi                       |    1 
 arch/arm/kernel/traps.c                                     |    2 
 arch/arm/mm/fault.c                                         |    2 
 arch/arm/mm/nommu.c                                         |    2 
 arch/arm64/kernel/traps.c                                   |    2 
 arch/arm64/mm/fault.c                                       |    2 
 arch/h8300/kernel/traps.c                                   |    3 
 arch/h8300/mm/fault.c                                       |    2 
 arch/hexagon/kernel/traps.c                                 |    2 
 arch/ia64/Kconfig                                           |    2 
 arch/ia64/kernel/mca_drv.c                                  |    3 
 arch/ia64/kernel/traps.c                                    |    2 
 arch/ia64/mm/fault.c                                        |    2 
 arch/m68k/kernel/traps.c                                    |    2 
 arch/m68k/mm/fault.c                                        |    2 
 arch/microblaze/kernel/exceptions.c                         |    4 
 arch/mips/kernel/traps.c                                    |    2 
 arch/nios2/kernel/traps.c                                   |    4 
 arch/openrisc/kernel/traps.c                                |    2 
 arch/parisc/kernel/traps.c                                  |    2 
 arch/powerpc/kernel/traps.c                                 |    2 
 arch/s390/kernel/dumpstack.c                                |    2 
 arch/s390/kernel/nmi.c                                      |    2 
 arch/sh/kernel/traps.c                                      |    2 
 arch/sparc/kernel/traps_32.c                                |    4 
 arch/sparc/kernel/traps_64.c                                |    4 
 arch/x86/entry/entry_32.S                                   |    6 
 arch/x86/entry/entry_64.S                                   |    8 -
 arch/x86/kernel/dumpstack.c                                 |    4 
 arch/x86/kernel/i8259.c                                     |    1 
 arch/x86/kernel/irqinit.c                                   |    4 
 arch/x86/lib/iomap_copy_64.S                                |    2 
 arch/x86/xen/time.c                                         |    2 
 arch/xtensa/kernel/traps.c                                  |    2 
 drivers/dma/dmaengine.c                                     |    7 -
 drivers/edac/edac_device.c                                  |   15 +-
 drivers/edac/highbank_mc_edac.c                             |    7 -
 drivers/gpu/drm/radeon/atombios_dp.c                        |    8 -
 drivers/gpu/drm/radeon/radeon_mode.h                        |    4 
 drivers/hid/hid-betopff.c                                   |   17 +-
 drivers/hid/hid-core.c                                      |    4 
 drivers/hid/intel-ish-hid/ishtp/dma-if.c                    |   10 +
 drivers/infiniband/hw/hfi1/user_exp_rcv.c                   |   16 +-
 drivers/input/mouse/synaptics.c                             |    1 
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c                    |   23 ++-
 drivers/net/ethernet/broadcom/tg3.c                         |    8 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c              |    8 -
 drivers/net/ethernet/renesas/ravb_main.c                    |    4 
 drivers/net/phy/mdio_bus.c                                  |    7 -
 drivers/net/usb/sr9700.c                                    |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c |    2 
 drivers/net/wireless/rndis_wlan.c                           |   19 ---
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c               |    4 
 drivers/scsi/hpsa.c                                         |    2 
 drivers/scsi/qla2xxx/qla_bsg.c                              |   10 -
 drivers/scsi/qla2xxx/qla_isr.c                              |   12 -
 drivers/scsi/qla2xxx/qla_mr.c                               |    3 
 drivers/staging/comedi/drivers/adv_pci1760.c                |    2 
 drivers/usb/gadget/function/f_fs.c                          |    7 +
 drivers/usb/host/xhci-plat.c                                |    2 
 drivers/w1/w1.c                                             |    6 
 drivers/w1/w1_int.c                                         |    5 
 fs/affs/file.c                                              |    2 
 fs/proc/proc_sysctl.c                                       |   33 +++++
 fs/reiserfs/super.c                                         |    6 
 include/linux/kernel.h                                      |    1 
 include/linux/sched/task.h                                  |    1 
 include/linux/sysctl.h                                      |    3 
 kernel/exit.c                                               |   72 +++++++++++
 kernel/module.c                                             |   26 +++-
 kernel/panic.c                                              |   75 ++++++++++--
 kernel/sched/core.c                                         |    3 
 kernel/trace/trace.c                                        |    2 
 kernel/trace/trace.h                                        |    1 
 kernel/trace/trace_output.c                                 |    3 
 mm/kasan/report.c                                           |    3 
 mm/util.c                                                   |    6 
 net/bluetooth/hci_core.c                                    |    1 
 net/ipv6/ip6_gre.c                                          |   12 +
 net/ipv6/ip6_tunnel.c                                       |   10 -
 net/ipv6/sit.c                                              |    8 -
 net/netfilter/nf_conntrack_proto_sctp.c                     |   25 ++--
 net/netlink/af_netlink.c                                    |   31 +++-
 net/netrom/nr_timer.c                                       |    1 
 net/nfc/llcp_core.c                                         |    1 
 net/sctp/bind_addr.c                                        |    6 
 security/tomoyo/Makefile                                    |    2 
 tools/objtool/check.c                                       |    3 
 94 files changed, 470 insertions(+), 214 deletions(-)

Alex Deucher (1):
      drm/radeon/dp: make radeon_dp_get_dp_link_config static

Alexander Potapenko (1):
      affs: initialize fsdata in affs_truncate()

Alexey V. Vissarionov (1):
      scsi: hpsa: Fix allocation size for scsi_host_alloc()

Archie Pusaka (1):
      Bluetooth: hci_sync: cancel cmd_timer if hci_open failed

Christoph Hellwig (1):
      scsi: qla2xxx: don't break the bsg-lib abstractions

David Christensen (1):
      net/tg3: resolve deadlock in tg3_reset_task() during EEH

Dean Luick (2):
      IB/hfi1: Reject a zero-length user expected buffer
      IB/hfi1: Reserve user expected TIDs

Dmitry Torokhov (1):
      Revert "Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode"

Dongliang Mu (1):
      fs: reiserfs: remove useless new_opts in reiserfs_remount

Eric Dumazet (3):
      netlink: annotate data races around dst_portid and dst_group
      netlink: annotate data races around sk_state
      ipv6: ensure sane device mtu in tunnels

Eric W. Biederman (2):
      exit: Add and use make_task_dead.
      objtool: Add a missing comma to avoid string concatenation

Fabio Estevam (1):
      ARM: dts: imx6qdl-gw560x: Remove incorrect 'uart-has-rtscts'

Giulio Benetti (1):
      ARM: 9280/1: mm: fix warning on phys_addr_t to void pointer assignment

Greg Kroah-Hartman (3):
      wifi: brcmfmac: fix up incorrect 4.14.y backport for brcmf_fw_map_chip_to_name()
      xen: Fix up build warning with xen_init_time_ops() reference
      Linux 4.14.305

Heiner Kallweit (1):
      net: mdio: validate parameter addr in mdiobus_get_phy()

Ian Abbott (1):
      comedi: adv_pci1760: Fix PWM instruction handling

Jan Beulich (1):
      x86/entry/64: Add instruction suffix to SYSRET

Jann Horn (1):
      exit: Put an upper limit on how often we can oops

Jiasheng Jiang (1):
      HID: intel_ish-hid: Add check for ishtp_dma_tx_map

Jisoo Jang (1):
      net: nfc: Fix use-after-free in local_cleanup()

Kees Cook (7):
      exit: Expose "oops_count" to sysfs
      exit: Allow oops_limit to be disabled
      panic: Consolidate open-coded panic_on_warn checks
      panic: Introduce warn_limit
      panic: Expose "warn_count" to sysfs
      docs: Fix path paste-o for /sys/kernel/warn_count
      exit: Use READ_ONCE() for all oops/warn limit reads

Koba Ko (1):
      dmaengine: Fix double increment of client_count in dma_chan_get()

Kuniyuki Iwashima (1):
      netrom: Fix use-after-free of a listening socket.

Manivannan Sadhasivam (1):
      EDAC/device: Respect any driver-supplied workqueue polling value

Marcelo Ricardo Leitner (1):
      sctp: fail if no bound addresses can be used for a given scope

Masahiro Yamada (1):
      tomoyo: fix broken dependency on *.conf.default

Miaoqian Lin (1):
      EDAC/highbank: Fix memory leak in highbank_mc_probe()

Michal Hocko (1):
      mm: kvmalloc does not fallback to vmalloc for incompatible gfp flags

Mikulas Patocka (1):
      x86/asm: Fix an assembler warning with current binutils

Nathan Chancellor (2):
      hexagon: Fix function name in die()
      h8300: Fix build errors from do_exit() to make_task_dead() transition

Peter Chen (1):
      usb: host: xhci-plat: add wakeup entry at sysfs

Petr Pavlu (1):
      module: Don't wait for GOING modules

Pietro Borrello (2):
      HID: check empty report_list in hid_validate_values()
      HID: betop: check shape of output reports

Raju Rangoju (1):
      amd-xgbe: TX Flow Ctrl Registers are h/w ver dependent

Randy Dunlap (2):
      net: mlx5: eliminate anonymous module_init & module_exit
      ia64: make IA64_MCA_RECOVERY bool instead of tristate

Shang XiaoJing (1):
      phy: rockchip-inno-usb2: Fix missing clk_disable_unprepare() in rockchip_usb2phy_power_on()

Sriram Yagnaraman (1):
      netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE

Steven Rostedt (Google) (1):
      tracing: Make sure trace_printk() can output as soon as it can be used

Szymon Heidrich (2):
      wifi: rndis_wlan: Prevent buffer overflow in rndis_query_oid
      net: usb: sr9700: Handle negative len

Thomas Gleixner (1):
      x86/i8259: Mark legacy PIC interrupts with IRQ_LEVEL

Tiezhu Yang (1):
      panic: unset panic_on_warn inside panic()

Udipto Goswami (2):
      usb: gadget: f_fs: Prevent race during ffs_ep0_queue_wait
      usb: gadget: f_fs: Ensure ep0req is dequeued before free_request

Xiaoming Ni (1):
      sysctl: add a new register_sysctl_init() interface

Yang Yingliang (2):
      w1: fix deadloop in __w1_remove_master_device()
      w1: fix WARNING after calling w1_process()

Yoshihiro Shimoda (1):
      net: ravb: Fix possible hang if RIS2_QFF1 happen

