Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74461DBA86
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 19:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgETRDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 13:03:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727830AbgETRDd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 13:03:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1D3320708;
        Wed, 20 May 2020 17:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589994212;
        bh=Q4hn0S+az4AxqHB8E85xalt83krDRr+zFIY+Q8MUp3Q=;
        h=Subject:To:Cc:From:Date:From;
        b=Y65KBIrKyZWZT314PDGLoDW/96AwuVq//UndekuLiIsyhcfKyH8f87C8oGfrPsoDC
         rY4AA5ZfdGI1pXVcG3T8rNkLlSi8db+hmnXOZ7NuhNhh2Lip/EcMUjNMqryYwqj51m
         0EhLGunAycAcBEd4khaL3eFxiIYZLKeGNnQzLiSw=
Subject: Linux 4.14.181
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Wed, 20 May 2020 19:03:07 +0200
Message-ID: <1589994187224147@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.181 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |   23 +-
 arch/arm/boot/dts/dra7.dtsi                          |    4 
 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts     |    4 
 arch/arm/boot/dts/r8a73a4.dtsi                       |    9 
 arch/arm/boot/dts/r8a7740.dtsi                       |    2 
 arch/arm64/boot/dts/rockchip/rk3328-evb.dts          |    2 
 arch/arm64/boot/dts/rockchip/rk3328-rock64.dts       |    2 
 arch/arm64/boot/dts/rockchip/rk3399.dtsi             |    4 
 arch/x86/entry/calling.h                             |   38 ++--
 arch/x86/entry/entry_64.S                            |    5 
 arch/x86/include/asm/bitops.h                        |   29 +--
 arch/x86/include/asm/percpu.h                        |    2 
 arch/x86/include/asm/stackprotector.h                |    7 
 arch/x86/kernel/smpboot.c                            |    8 
 arch/x86/kernel/unwind_orc.c                         |   20 +-
 arch/x86/kvm/x86.c                                   |    2 
 arch/x86/xen/smp_pv.c                                |    1 
 crypto/lrw.c                                         |    4 
 crypto/xts.c                                         |    4 
 drivers/block/virtio_blk.c                           |   86 ++++++++-
 drivers/char/ipmi/ipmi_ssif.c                        |    4 
 drivers/clk/rockchip/clk-rk3228.c                    |   17 -
 drivers/cpufreq/intel_pstate.c                       |    2 
 drivers/dma/mmp_tdma.c                               |    2 
 drivers/dma/pch_dma.c                                |    2 
 drivers/gpu/drm/qxl/qxl_image.c                      |    3 
 drivers/hid/usbhid/hid-core.c                        |   37 +++
 drivers/hid/usbhid/usbhid.h                          |    1 
 drivers/hid/wacom_sys.c                              |    4 
 drivers/hwmon/da9052-hwmon.c                         |    4 
 drivers/infiniband/core/addr.c                       |    7 
 drivers/infiniband/hw/i40iw/i40iw_hw.c               |    2 
 drivers/infiniband/hw/mlx4/qp.c                      |   14 +
 drivers/infiniband/sw/rxe/rxe_net.c                  |    8 
 drivers/net/dsa/dsa_loop.c                           |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c            |   18 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.h            |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c      |    9 
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c    |   16 +
 drivers/net/ethernet/huawei/hinic/hinic_main.c       |   16 -
 drivers/net/ethernet/mellanox/mlx4/main.c            |    4 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c        |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      |   11 -
 drivers/net/ethernet/moxa/moxart_ether.c             |    2 
 drivers/net/ethernet/natsemi/jazzsonic.c             |    6 
 drivers/net/ethernet/stmicro/stmmac/stmmac.h         |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c |   12 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |   31 +--
 drivers/net/geneve.c                                 |   20 +-
 drivers/net/macsec.c                                 |    3 
 drivers/net/phy/dp83640.c                            |    2 
 drivers/net/phy/micrel.c                             |    4 
 drivers/net/phy/phy.c                                |    8 
 drivers/net/usb/qmi_wwan.c                           |    1 
 drivers/net/vxlan.c                                  |    8 
 drivers/pinctrl/intel/pinctrl-baytrail.c             |    1 
 drivers/pinctrl/intel/pinctrl-cherryview.c           |    4 
 drivers/scsi/sg.c                                    |    4 
 drivers/usb/core/hub.c                               |    6 
 drivers/usb/gadget/configfs.c                        |    3 
 drivers/usb/gadget/legacy/audio.c                    |    4 
 drivers/usb/gadget/legacy/cdc2.c                     |    4 
 drivers/usb/gadget/legacy/ncm.c                      |    4 
 drivers/usb/gadget/udc/net2272.c                     |    2 
 drivers/usb/host/xhci-plat.c                         |    4 
 drivers/usb/host/xhci-ring.c                         |    4 
 drivers/usb/serial/garmin_gps.c                      |    4 
 drivers/usb/serial/qcserial.c                        |    1 
 drivers/usb/storage/unusual_uas.h                    |    7 
 fs/coredump.c                                        |    8 
 fs/exec.c                                            |    4 
 fs/f2fs/xattr.c                                      |  176 +++++++++++-------
 fs/f2fs/xattr.h                                      |    2 
 include/linux/blkdev.h                               |    2 
 include/linux/blktrace_api.h                         |   18 +
 include/linux/compiler.h                             |    6 
 include/linux/fs.h                                   |    2 
 include/linux/pnp.h                                  |   29 ---
 include/linux/tty.h                                  |    2 
 include/linux/virtio_net.h                           |   24 ++
 include/net/addrconf.h                               |    6 
 include/net/ipv6.h                                   |    2 
 include/net/netfilter/nf_conntrack.h                 |    2 
 include/sound/rawmidi.h                              |    1 
 init/main.c                                          |    2 
 ipc/util.c                                           |   12 -
 kernel/trace/blktrace.c                              |  177 ++++++++++++++-----
 kernel/trace/trace.c                                 |   13 +
 kernel/umh.c                                         |    5 
 mm/page_alloc.c                                      |    1 
 mm/shmem.c                                           |    7 
 net/batman-adv/bat_v_ogm.c                           |    2 
 net/batman-adv/network-coding.c                      |    9 
 net/batman-adv/sysfs.c                               |    3 
 net/core/dev.c                                       |    4 
 net/core/drop_monitor.c                              |   11 -
 net/core/netprio_cgroup.c                            |    2 
 net/dccp/ipv6.c                                      |    6 
 net/ipv4/cipso_ipv4.c                                |    6 
 net/ipv4/route.c                                     |    2 
 net/ipv4/tcp.c                                       |    6 
 net/ipv6/addrconf_core.c                             |   11 -
 net/ipv6/af_inet6.c                                  |   10 -
 net/ipv6/calipso.c                                   |    3 
 net/ipv6/datagram.c                                  |    2 
 net/ipv6/inet6_connection_sock.c                     |    4 
 net/ipv6/ip6_output.c                                |    8 
 net/ipv6/raw.c                                       |    2 
 net/ipv6/route.c                                     |    6 
 net/ipv6/syncookies.c                                |    2 
 net/ipv6/tcp_ipv6.c                                  |    4 
 net/l2tp/l2tp_ip6.c                                  |    2 
 net/mpls/af_mpls.c                                   |    7 
 net/netfilter/nf_conntrack_core.c                    |    4 
 net/netfilter/nf_nat_proto_udp.c                     |    5 
 net/netlabel/netlabel_kapi.c                         |    6 
 net/sched/sch_choke.c                                |    3 
 net/sched/sch_fq_codel.c                             |    2 
 net/sched/sch_sfq.c                                  |    9 
 net/sctp/ipv6.c                                      |    4 
 net/tipc/udp_media.c                                 |    9 
 scripts/decodecode                                   |    2 
 sound/core/rawmidi.c                                 |   35 +++
 sound/pci/hda/patch_hdmi.c                           |    2 
 sound/pci/hda/patch_realtek.c                        |   28 ++-
 sound/usb/quirks.c                                   |    9 
 tools/objtool/check.c                                |    2 
 virt/kvm/arm/vgic/vgic-mmio.c                        |    4 
 128 files changed, 891 insertions(+), 442 deletions(-)

Alan Stern (1):
      HID: usbhid: Fix race between usbhid_close() and usbhid_stop()

Andy Shevchenko (1):
      pinctrl: baytrail: Enable pin configuration setting for GPIO chip

Arnd Bergmann (2):
      drop_monitor: work around gcc-10 stringop-overflow warning
      netfilter: conntrack: avoid gcc-10 zero-length-bounds warning

Borislav Petkov (1):
      x86: Fix early boot crash on gcc-10, third try

Cengiz Can (1):
      blktrace: fix dereference after null check

Chao Yu (2):
      f2fs: introduce read_inline_xattr
      f2fs: introduce read_xattr_block

Chen-Yu Tsai (2):
      arm64: dts: rockchip: Replace RK805 PMIC node name with "pmic" on rk3328 boards
      arm64: dts: rockchip: Rename dwc3 device nodes on rk3399 to make dtc happy

Chris Wilson (1):
      cpufreq: intel_pstate: Only mention the BIOS disabling turbo mode once

Christophe JAILLET (4):
      net/sonic: Fix a resource leak in an error handling path in 'jazz_sonic_probe()'
      net: moxa: Fix a potential double 'free_irq()'
      usb: gadget: net2272: Fix a memory leak in an error handling path in 'net2272_plat_probe()'
      usb: gadget: audio: Fix a missing error return value in audio_bind()

Cong Wang (1):
      net: fix a potential recursive NETDEV_FEAT_CHANGE

Dan Carpenter (1):
      i40iw: Fix error handling in i40iw_manage_arp_cache()

David Hildenbrand (1):
      mm/page_alloc: fix watchdog soft lockups during set_zone_contiguous()

Eric Dumazet (3):
      fq_codel: fix TCA_FQ_CODEL_DROP_BATCH_SIZE sanity checks
      sch_choke: avoid potential panic in choke_reset()
      sch_sfq: validate silly quantum values

Eric W. Biederman (1):
      exec: Move would_dump into flush_old_exec

Eugeniu Rosca (1):
      usb: core: hub: limit HUB_QUIRK_DISABLE_AUTOSUSPEND to USB5534B

Fabio Estevam (1):
      ARM: dts: imx27-phytec-phycard-s-rdk: Fix the I2C1 pinctrl entries

Florian Fainelli (2):
      net: phy: micrel: Use strlcpy() for ethtool::get_strings
      net: dsa: loop: Add module soft dependency

Geert Uytterhoeven (2):
      ARM: dts: r8a73a4: Add missing CMT1 interrupts
      ARM: dts: r8a7740: Add missing extal2 to CPG node

George Spelvin (1):
      batman-adv: fix batadv_nc_random_weight_tq

Grace Kao (1):
      pinctrl: cherryview: Add missing spinlock usage in chv_gpio_irq_handler

Greg Kroah-Hartman (1):
      Linux 4.14.181

Guillaume Nault (1):
      netfilter: nat: never update the UDP checksum when it's 0

Gustavo A. R. Silva (1):
      ipmi: Fix NULL pointer dereference in ssif_probe

Hangbin Liu (1):
      geneve: only configure or fill UDP_ZERO_CSUM6_RX/TX info when CONFIG_IPV6

Heiner Kallweit (1):
      net: phy: fix aneg restart in phy_ethtool_set_eee

Hugh Dickins (1):
      shmem: fix possible deadlocks on shmlock_user_lock

Ivan Delalande (1):
      scripts/decodecode: fix trapping instruction formatting

Jack Morgenstein (1):
      IB/mlx4: Test return value of calls to ib_get_cached_pkey

Jaegeuk Kim (1):
      f2fs: sanity check of xattr entry size

Jan Beulich (1):
      x86/asm: Add instruction suffixes to bitops

Jan Kara (1):
      blktrace: Protect q->blk_trace with RCU

Jann Horn (1):
      x86/entry/64: Fix unwind hints in rewind_stack_do_exit()

Jason Gerecke (1):
      HID: wacom: Read HID_DG_CONTACTMAX directly for non-generic devices

Jason Gunthorpe (1):
      pnp: Use list_for_each_entry() instead of open coding

Jens Axboe (2):
      blktrace: fix unlocked access to init/start-stop/teardown
      blktrace: fix trace mutex deadlock

Jesus Ramos (1):
      ALSA: usb-audio: Add control message quirk delay for Kingston HyperX headset

Jim Mattson (1):
      KVM: x86: Fix off-by-one error in kvm_vcpu_ioctl_x86_setup_mce

Josh Poimboeuf (6):
      x86/entry/64: Fix unwind hints in kernel exit path
      x86/unwind/orc: Prevent unwinding before ORC initialization
      x86/unwind/orc: Fix error path for bad ORC entry type
      objtool: Fix stack offset tracking for indirect CFAs
      x86/entry/64: Fix unwind hints in register clearing code
      x86/unwind/orc: Fix error handling in __unwind_start()

Julia Lawall (1):
      dp83640: reverse arguments to list_add_tail

Justin Swartz (1):
      clk: rockchip: fix incorrect configuration of rk3228 aclk_gpu* clocks

Kai Vehmanen (1):
      ALSA: hda/hdmi: fix race in monitor detection during probe

Kai-Heng Feng (2):
      ALSA: hda/realtek - Fix S3 pop noise on Dell Wyse
      Revert "ALSA: hda/realtek: Fix pop noise on ALC225"

Kelly Littlepage (1):
      net: tcp: fix rx timestamp behavior for tcp_recvmsg

Kishon Vijay Abraham I (1):
      ARM: dts: dra7: Fix bus_dma_limit for PCIe

Kyungtae Kim (1):
      USB: gadget: fix illegal array access in binding with UDC

Li Jun (1):
      usb: host: xhci-plat: keep runtime active when removing host

Linus Torvalds (7):
      gcc-10 warnings: fix low-hanging fruit
      Stop the ad-hoc games with -Wno-maybe-initialized
      gcc-10: disable 'zero-length-bounds' warning for now
      gcc-10: disable 'array-bounds' warning for now
      gcc-10: disable 'stringop-overflow' warning for now
      gcc-10: disable 'restrict' warning for now
      gcc-10: avoid shadowing standard library 'free()' in crypto

Lubomir Rintel (1):
      dmaengine: mmp_tdma: Reset channel error on release

Luis Chamberlain (1):
      coredump: fix crash when umh is disabled

Luo bin (1):
      hinic: fix a bug of ndo_stop

Maciej Żenczykowski (1):
      Revert "ipv6: add mtu lock check in __ip6_rt_update_pmtu"

Madhuparna Bhowmik (1):
      dmaengine: pch_dma.c: Avoid data race between probe and irq handler

Marc Zyngier (1):
      KVM: arm: vgic: Fix limit condition when writing to GICD_I[CS]ACTIVER

Masahiro Yamada (1):
      kbuild: compute false-positive -Wmaybe-uninitialized cases in Kconfig

Matt Jolly (2):
      USB: serial: qcserial: Add DW5816e support
      net: usb: qmi_wwan: add support for DW5816e

Michael Chan (3):
      bnxt_en: Fix VLAN acceleration handling in bnxt_fix_features().
      bnxt_en: Improve AER slot reset.
      bnxt_en: Fix VF anti-spoof filter setup.

Miroslav Benes (1):
      x86/unwind/orc: Don't skip the first frame for inactive tasks

Moshe Shemesh (2):
      net/mlx5: Fix forced completion access non initialized command entry
      net/mlx5: Fix command entry leak in Internal Error State

Oliver Neukum (2):
      USB: uas: add quirk for LaCie 2Big Quadra
      USB: serial: garmin_gps: add sanity checking for data length

Paolo Abeni (2):
      netlabel: cope with NULL catmap
      net: ipv4: really enforce backoff for redirects

Randall Huang (2):
      f2fs: fix to avoid accessing xattr across the boundary
      f2fs: fix to avoid memory leakage in f2fs_listxattr

Sabrina Dubroca (3):
      ipv6: fix cleanup ordering for ip6_mr failure
      net: ipv6: add net argument to ip6_dst_lookup_flow
      net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup

Samu Nuutamo (1):
      hwmon: (da9052) Synchronize access with mfd

Scott Dial (1):
      net: macsec: preserve ingress frame ordering

Sergei Trofimovich (1):
      Makefile: disallow data races on gcc-10 as well

Sriharsha Allenki (1):
      usb: xhci: Fix NULL pointer dereference when enqueuing trbs from urb sg list

Stefan Hajnoczi (1):
      virtio-blk: handle block_device_operations callbacks after hot unplug

Steven Rostedt (VMware) (1):
      tracing: Add a vmalloc_sync_mappings() for safe measure

Takashi Iwai (3):
      ALSA: hda/realtek - Limit int mic boost for Thinkpad T530
      ALSA: rawmidi: Initialize allocated buffers
      ALSA: rawmidi: Fix racy buffer resize under concurrent accesses

Tariq Toukan (1):
      net/mlx4_core: Fix use of ENOSPC around mlx4_counter_alloc()

Thierry Reding (1):
      net: stmmac: Use mutex instead of spinlock

Vasily Averin (2):
      drm/qxl: lost qxl_bo_kunmap_atomic_page in qxl_image_init_helper()
      ipc/util.c: sysvipc_find_ipc() incorrectly updates position index

Wei Yongjun (2):
      usb: gadget: legacy: fix error return code in gncm_bind()
      usb: gadget: legacy: fix error return code in cdc_bind()

Willem de Bruijn (1):
      net: stricter validation of untrusted gso packets

Wu Bo (1):
      scsi: sg: add sg_remove_request in sg_write

Xiyu Yang (3):
      batman-adv: Fix refcnt leak in batadv_show_throughput_override
      batman-adv: Fix refcnt leak in batadv_store_throughput_override
      batman-adv: Fix refcnt leak in batadv_v_ogm_process

Zefan Li (1):
      netprio_cgroup: Fix unlimited memory leak of v2 cgroups

