Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF491DBA84
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 19:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgETRDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 13:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbgETRD2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 13:03:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A1C1207D3;
        Wed, 20 May 2020 17:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589994206;
        bh=/gpfbOYPerZxYzoo2m7qybyaehpzRqw/lzVaMet4+S0=;
        h=Subject:To:Cc:From:Date:From;
        b=gn5CaHtVsZf5iZTAbfnFLrrZSELmMs52qxjPVfDLa/BzC2lFZwstTZuLiUk8lc+ED
         VtNOyvwskq146vHOkeDU4uuKfNNiyJgZGhvkaP4Rgf/v0YJVJDaUYXQ+goiybBbPPE
         LI1HlWYJ0hP8L1NsLvt+VQUE7qzrHT4m5WSjVpSI=
Subject: Linux 4.9.224
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Wed, 20 May 2020 19:03:01 +0200
Message-ID: <158999418117170@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.224 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |   23 +-
 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts |    4 
 arch/arm/boot/dts/r8a73a4.dtsi                   |    9 -
 arch/arm/boot/dts/r8a7740.dtsi                   |    2 
 arch/x86/include/asm/stackprotector.h            |    7 
 arch/x86/kernel/smpboot.c                        |    8 
 arch/x86/kvm/x86.c                               |    2 
 arch/x86/xen/smp.c                               |    1 
 block/blk-core.c                                 |    3 
 crypto/lrw.c                                     |    4 
 crypto/xts.c                                     |    4 
 drivers/acpi/video_detect.c                      |   11 -
 drivers/dma/mmp_tdma.c                           |    2 
 drivers/dma/pch_dma.c                            |    2 
 drivers/gpu/drm/qxl/qxl_image.c                  |    3 
 drivers/infiniband/core/addr.c                   |    8 
 drivers/infiniband/hw/i40iw/i40iw_hw.c           |    2 
 drivers/infiniband/hw/mlx4/qp.c                  |   14 +
 drivers/infiniband/sw/rxe/rxe_net.c              |    8 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c        |   18 +-
 drivers/net/ethernet/mellanox/mlx4/main.c        |    4 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c    |    6 
 drivers/net/ethernet/moxa/moxart_ether.c         |    2 
 drivers/net/ethernet/natsemi/jazzsonic.c         |    6 
 drivers/net/geneve.c                             |    4 
 drivers/net/macsec.c                             |    3 
 drivers/net/phy/dp83640.c                        |    2 
 drivers/net/phy/micrel.c                         |    4 
 drivers/net/usb/qmi_wwan.c                       |    1 
 drivers/net/vxlan.c                              |   10 -
 drivers/pinctrl/intel/pinctrl-cherryview.c       |    4 
 drivers/ptp/ptp_clock.c                          |   42 ++---
 drivers/ptp/ptp_private.h                        |    9 -
 drivers/ptp/ptp_sysfs.c                          |  162 +++++++------------
 drivers/scsi/sg.c                                |    4 
 drivers/spi/spi-dw.c                             |   15 +
 drivers/spi/spi-dw.h                             |    1 
 drivers/usb/gadget/configfs.c                    |    3 
 drivers/usb/gadget/legacy/audio.c                |    4 
 drivers/usb/gadget/legacy/cdc2.c                 |    4 
 drivers/usb/gadget/legacy/ncm.c                  |    4 
 drivers/usb/gadget/udc/net2272.c                 |    2 
 drivers/usb/host/xhci-ring.c                     |    4 
 drivers/usb/serial/garmin_gps.c                  |    4 
 drivers/usb/serial/qcserial.c                    |    1 
 drivers/usb/storage/unusual_uas.h                |    7 
 fs/binfmt_elf.c                                  |   12 +
 fs/char_dev.c                                    |   86 ++++++++++
 fs/cifs/cifssmb.c                                |   12 +
 fs/cifs/connect.c                                |   11 -
 fs/cifs/smb2pdu.c                                |   12 +
 fs/exec.c                                        |    4 
 fs/ext4/block_validity.c                         |    1 
 include/linux/blkdev.h                           |    3 
 include/linux/blktrace_api.h                     |   18 +-
 include/linux/cdev.h                             |    5 
 include/linux/compiler.h                         |    7 
 include/linux/fs.h                               |    2 
 include/linux/pnp.h                              |   29 +--
 include/linux/posix-clock.h                      |   19 +-
 include/linux/tty.h                              |    2 
 include/net/addrconf.h                           |    6 
 include/net/ipv6.h                               |    2 
 include/net/netfilter/nf_conntrack.h             |    2 
 include/sound/rawmidi.h                          |    1 
 init/main.c                                      |    2 
 ipc/util.c                                       |   12 -
 kernel/time/posix-clock.c                        |   31 +--
 kernel/trace/blktrace.c                          |  191 +++++++++++++++++------
 kernel/trace/trace.c                             |   13 +
 mm/page_alloc.c                                  |    1 
 mm/shmem.c                                       |    7 
 net/batman-adv/bat_v_ogm.c                       |    2 
 net/batman-adv/network-coding.c                  |    9 -
 net/batman-adv/sysfs.c                           |    3 
 net/core/dev.c                                   |    4 
 net/core/drop_monitor.c                          |   11 -
 net/core/netprio_cgroup.c                        |    2 
 net/dccp/ipv6.c                                  |    6 
 net/ipv4/cipso_ipv4.c                            |    6 
 net/ipv4/route.c                                 |    2 
 net/ipv6/addrconf_core.c                         |   11 -
 net/ipv6/af_inet6.c                              |    4 
 net/ipv6/calipso.c                               |    3 
 net/ipv6/datagram.c                              |    2 
 net/ipv6/inet6_connection_sock.c                 |    4 
 net/ipv6/ip6_output.c                            |    8 
 net/ipv6/raw.c                                   |    2 
 net/ipv6/route.c                                 |    6 
 net/ipv6/syncookies.c                            |    2 
 net/ipv6/tcp_ipv6.c                              |    4 
 net/l2tp/l2tp_ip6.c                              |    2 
 net/mpls/af_mpls.c                               |    7 
 net/netfilter/nf_conntrack_core.c                |    4 
 net/netlabel/netlabel_kapi.c                     |    6 
 net/sched/sch_choke.c                            |    3 
 net/sched/sch_fq_codel.c                         |    2 
 net/sched/sch_sfq.c                              |    9 +
 net/sctp/ipv6.c                                  |    4 
 net/tipc/udp_media.c                             |    9 -
 scripts/decodecode                               |    2 
 sound/core/rawmidi.c                             |   35 +++-
 sound/pci/hda/patch_hdmi.c                       |    2 
 sound/pci/hda/patch_realtek.c                    |   12 +
 sound/usb/quirks.c                               |    9 -
 tools/objtool/check.c                            |    2 
 106 files changed, 746 insertions(+), 391 deletions(-)

Arnd Bergmann (2):
      drop_monitor: work around gcc-10 stringop-overflow warning
      netfilter: conntrack: avoid gcc-10 zero-length-bounds warning

Borislav Petkov (1):
      x86: Fix early boot crash on gcc-10, third try

Cengiz Can (1):
      blktrace: fix dereference after null check

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

Dmitry Torokhov (3):
      ptp: do not explicitly set drvdata in ptp_clock_register()
      ptp: use is_visible method to hide unused attributes
      ptp: create "pins" together with the rest of attributes

Eric Dumazet (3):
      fq_codel: fix TCA_FQ_CODEL_DROP_BATCH_SIZE sanity checks
      sch_choke: avoid potential panic in choke_reset()
      sch_sfq: validate silly quantum values

Eric W. Biederman (1):
      exec: Move would_dump into flush_old_exec

Fabio Estevam (1):
      ARM: dts: imx27-phytec-phycard-s-rdk: Fix the I2C1 pinctrl entries

Florian Fainelli (1):
      net: phy: micrel: Use strlcpy() for ethtool::get_strings

Geert Uytterhoeven (2):
      ARM: dts: r8a73a4: Add missing CMT1 interrupts
      ARM: dts: r8a7740: Add missing extal2 to CPG node

George Spelvin (1):
      batman-adv: fix batadv_nc_random_weight_tq

Grace Kao (1):
      pinctrl: cherryview: Add missing spinlock usage in chv_gpio_irq_handler

Greg Kroah-Hartman (1):
      Linux 4.9.224

Hans de Goede (1):
      Revert "ACPI / video: Add force_native quirk for HP Pavilion dv6"

Hugh Dickins (1):
      shmem: fix possible deadlocks on shmlock_user_lock

Ivan Delalande (1):
      scripts/decodecode: fix trapping instruction formatting

Jack Morgenstein (1):
      IB/mlx4: Test return value of calls to ib_get_cached_pkey

Jan Kara (1):
      blktrace: Protect q->blk_trace with RCU

Jason Gunthorpe (1):
      pnp: Use list_for_each_entry() instead of open coding

Jens Axboe (2):
      blktrace: fix unlocked access to init/start-stop/teardown
      blktrace: fix trace mutex deadlock

Jesus Ramos (1):
      ALSA: usb-audio: Add control message quirk delay for Kingston HyperX headset

Jim Mattson (1):
      KVM: x86: Fix off-by-one error in kvm_vcpu_ioctl_x86_setup_mce

Josh Poimboeuf (1):
      objtool: Fix stack offset tracking for indirect CFAs

Julia Lawall (1):
      dp83640: reverse arguments to list_add_tail

Kai Vehmanen (1):
      ALSA: hda/hdmi: fix race in monitor detection during probe

Kai-Heng Feng (1):
      Revert "ALSA: hda/realtek: Fix pop noise on ALC225"

Kees Cook (2):
      binfmt_elf: move brk out of mmap when doing direct loader exec
      binfmt_elf: Do not move brk for INTERP-less ET_EXEC

Kyungtae Kim (1):
      USB: gadget: fix illegal array access in binding with UDC

Linus Torvalds (7):
      gcc-10 warnings: fix low-hanging fruit
      Stop the ad-hoc games with -Wno-maybe-initialized
      gcc-10: avoid shadowing standard library 'free()' in crypto
      gcc-10: disable 'zero-length-bounds' warning for now
      gcc-10: disable 'array-bounds' warning for now
      gcc-10: disable 'stringop-overflow' warning for now
      gcc-10: disable 'restrict' warning for now

Logan Gunthorpe (1):
      chardev: add helper function to register char devs with a struct device

Lubomir Rintel (1):
      dmaengine: mmp_tdma: Reset channel error on release

Maciej Żenczykowski (1):
      Revert "ipv6: add mtu lock check in __ip6_rt_update_pmtu"

Madhuparna Bhowmik (1):
      dmaengine: pch_dma.c: Avoid data race between probe and irq handler

Masahiro Yamada (1):
      kbuild: compute false-positive -Wmaybe-uninitialized cases in Kconfig

Matt Jolly (2):
      USB: serial: qcserial: Add DW5816e support
      net: usb: qmi_wwan: add support for DW5816e

Michael Chan (2):
      bnxt_en: Fix VLAN acceleration handling in bnxt_fix_features().
      bnxt_en: Improve AER slot reset.

Moshe Shemesh (2):
      net/mlx5: Fix forced completion access non initialized command entry
      net/mlx5: Fix command entry leak in Internal Error State

Oliver Neukum (2):
      USB: uas: add quirk for LaCie 2Big Quadra
      USB: serial: garmin_gps: add sanity checking for data length

Paolo Abeni (2):
      netlabel: cope with NULL catmap
      net: ipv4: really enforce backoff for redirects

Ronnie Sahlberg (1):
      cifs: Fix a race condition with cifs_echo_request

Sabrina Dubroca (2):
      net: ipv6: add net argument to ip6_dst_lookup_flow
      net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup

Samuel Cabrero (1):
      cifs: Check for timeout on Negotiate stage

Scott Dial (1):
      net: macsec: preserve ingress frame ordering

Sergei Trofimovich (1):
      Makefile: disallow data races on gcc-10 as well

Shijie Luo (1):
      ext4: add cond_resched() to ext4_protect_reserved_inode

Sriharsha Allenki (1):
      usb: xhci: Fix NULL pointer dereference when enqueuing trbs from urb sg list

Steven Rostedt (VMware) (1):
      tracing: Add a vmalloc_sync_mappings() for safe measure

Takashi Iwai (3):
      ALSA: hda/realtek - Limit int mic boost for Thinkpad T530
      ALSA: rawmidi: Initialize allocated buffers
      ALSA: rawmidi: Fix racy buffer resize under concurrent accesses

Tariq Toukan (1):
      net/mlx4_core: Fix use of ENOSPC around mlx4_counter_alloc()

Vasily Averin (2):
      drm/qxl: lost qxl_bo_kunmap_atomic_page in qxl_image_init_helper()
      ipc/util.c: sysvipc_find_ipc() incorrectly updates position index

Vladis Dronov (2):
      ptp: fix the race between the release of ptp_clock and cdev
      ptp: free ptp device pin descriptors properly

Waiman Long (1):
      blktrace: Fix potential deadlock between delete & sysfs ops

Wei Yongjun (2):
      usb: gadget: legacy: fix error return code in gncm_bind()
      usb: gadget: legacy: fix error return code in cdc_bind()

Wu Bo (1):
      scsi: sg: add sg_remove_request in sg_write

Xiyu Yang (3):
      batman-adv: Fix refcnt leak in batadv_show_throughput_override
      batman-adv: Fix refcnt leak in batadv_store_throughput_override
      batman-adv: Fix refcnt leak in batadv_v_ogm_process

YueHaibing (1):
      ptp: Fix pass zero to ERR_PTR() in ptp_clock_register

Zefan Li (1):
      netprio_cgroup: Fix unlimited memory leak of v2 cgroups

wuxu.wu (1):
      spi: spi-dw: Add lock protect dw_spi rx/tx to prevent concurrent calls

