Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF3A1DBA7E
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 19:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgETRDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 13:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbgETRDW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 13:03:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EEF920709;
        Wed, 20 May 2020 17:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589994201;
        bh=fBsc5JrjV6lhX+xn336Snc8ZEmZs6pNQtXvHPjm4ZUI=;
        h=Subject:To:Cc:From:Date:From;
        b=Wk96csKyrSuEKNUbYK36Fy4LlKHAilqKL5sJ4LGN6az8OgIelzvCWSskRFNUcRzGw
         vw9eID+ZX3WXJ5mMkNT3F/h57FfJaOGp+VbX5RNYenl0jvVcxOAEDLg2NRRJ45rh/S
         LJPsmGLV9jjy9IPiZhNoHP9TWoBsY0Ansfgpdp/8=
Subject: Linux 4.4.224
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Wed, 20 May 2020 19:02:53 +0200
Message-ID: <158999417392188@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.224 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |   15 +
 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts |    4 
 arch/arm/boot/dts/r8a7740.dtsi                   |    2 
 arch/x86/entry/entry_32.S                        |    8 
 arch/x86/include/asm/apm.h                       |    6 
 arch/x86/include/asm/paravirt.h                  |    7 
 arch/x86/include/asm/paravirt_types.h            |    9 -
 arch/x86/include/asm/stackprotector.h            |    7 
 arch/x86/kernel/apm_32.c                         |    5 
 arch/x86/kernel/asm-offsets.c                    |    3 
 arch/x86/kernel/paravirt.c                       |    7 
 arch/x86/kernel/paravirt_patch_32.c              |    2 
 arch/x86/kernel/paravirt_patch_64.c              |    1 
 arch/x86/kernel/smpboot.c                        |    8 
 arch/x86/kvm/x86.c                               |    2 
 arch/x86/xen/enlighten.c                         |    3 
 arch/x86/xen/smp.c                               |    1 
 arch/x86/xen/xen-asm_32.S                        |   14 -
 arch/x86/xen/xen-ops.h                           |    3 
 block/blk-core.c                                 |    3 
 block/blk-mq-tag.c                               |    7 
 block/blk-mq.c                                   |   17 ++
 block/blk-timeout.c                              |    3 
 crypto/lrw.c                                     |    4 
 crypto/xts.c                                     |    4 
 drivers/acpi/video_detect.c                      |   11 -
 drivers/dma/mmp_tdma.c                           |    2 
 drivers/dma/pch_dma.c                            |    2 
 drivers/gpu/drm/qxl/qxl_image.c                  |    3 
 drivers/infiniband/core/addr.c                   |    6 
 drivers/infiniband/hw/mlx4/qp.c                  |   14 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c          |   13 -
 drivers/net/ethernet/cisco/enic/enic_main.c      |    9 -
 drivers/net/ethernet/intel/i40e/i40e_nvm.c       |   98 +++++++----
 drivers/net/ethernet/intel/i40e/i40e_prototype.h |    2 
 drivers/net/ethernet/mellanox/mlx4/main.c        |    4 
 drivers/net/ethernet/mellanox/mlx5/core/main.c   |    2 
 drivers/net/ethernet/moxa/moxart_ether.c         |    2 
 drivers/net/ethernet/natsemi/jazzsonic.c         |    6 
 drivers/net/geneve.c                             |    4 
 drivers/net/phy/dp83640.c                        |    2 
 drivers/net/phy/micrel.c                         |   17 +-
 drivers/net/phy/phy.c                            |   15 -
 drivers/net/vxlan.c                              |   10 -
 drivers/ptp/ptp_clock.c                          |   42 ++---
 drivers/ptp/ptp_private.h                        |    9 -
 drivers/ptp/ptp_sysfs.c                          |  162 +++++++------------
 drivers/scsi/libiscsi.c                          |    4 
 drivers/scsi/qla2xxx/qla_init.c                  |    4 
 drivers/scsi/sg.c                                |    4 
 drivers/spi/spi-dw.c                             |   15 +
 drivers/spi/spi-dw.h                             |    1 
 drivers/usb/gadget/configfs.c                    |    3 
 drivers/usb/gadget/legacy/audio.c                |    4 
 drivers/usb/gadget/legacy/cdc2.c                 |    4 
 drivers/usb/gadget/legacy/ncm.c                  |    4 
 drivers/usb/gadget/udc/net2272.c                 |    2 
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
 include/linux/blktrace_api.h                     |    6 
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
 mm/memory_hotplug.c                              |    4 
 net/batman-adv/network-coding.c                  |    9 -
 net/core/dev.c                                   |    4 
 net/core/drop_monitor.c                          |   11 -
 net/dccp/ipv6.c                                  |    6 
 net/ipv4/cipso_ipv4.c                            |    6 
 net/ipv4/ip_gre.c                                |    7 
 net/ipv4/route.c                                 |    2 
 net/ipv6/addrconf_core.c                         |   11 -
 net/ipv6/af_inet6.c                              |   10 -
 net/ipv6/datagram.c                              |    2 
 net/ipv6/icmp.c                                  |    6 
 net/ipv6/inet6_connection_sock.c                 |    4 
 net/ipv6/ip6_output.c                            |    8 
 net/ipv6/raw.c                                   |    2 
 net/ipv6/syncookies.c                            |    2 
 net/ipv6/tcp_ipv6.c                              |    4 
 net/l2tp/l2tp_ip6.c                              |    2 
 net/mpls/af_mpls.c                               |    7 
 net/netfilter/nf_conntrack_core.c                |    4 
 net/netlabel/netlabel_kapi.c                     |    6 
 net/openvswitch/actions.c                        |    6 
 net/sched/sch_choke.c                            |    3 
 net/sched/sch_sfq.c                              |    9 +
 net/sctp/ipv6.c                                  |    4 
 net/tipc/udp_media.c                             |    9 -
 scripts/decodecode                               |    2 
 sound/core/rawmidi.c                             |   35 +++-
 sound/pci/hda/patch_realtek.c                    |   12 +
 112 files changed, 795 insertions(+), 497 deletions(-)

Alex Estrin (1):
      Revert "IB/ipoib: Update broadcast object if PKey value was changed in index 0"

Alexandre Belloni (1):
      phy: micrel: Ensure interrupts are reenabled on resume

Anjali Singhai Jain (1):
      i40e: avoid NVM acquire deadlock during NVM update

Arnd Bergmann (2):
      drop_monitor: work around gcc-10 stringop-overflow warning
      netfilter: conntrack: avoid gcc-10 zero-length-bounds warning

Bart Van Assche (1):
      scsi: iscsi: Fix a potential deadlock in the timeout handler

Ben Hutchings (1):
      scsi: qla2xxx: Avoid double completion of abort command

Boris Ostrovsky (1):
      x86/paravirt: Remove the unused irq_enable_sysexit pv op

Borislav Petkov (1):
      x86: Fix early boot crash on gcc-10, third try

Cengiz Can (1):
      blktrace: fix dereference after null check

Christoph Hellwig (1):
      block: defer timeouts to a workqueue

Christophe JAILLET (4):
      net/sonic: Fix a resource leak in an error handling path in 'jazz_sonic_probe()'
      net: moxa: Fix a potential double 'free_irq()'
      usb: gadget: net2272: Fix a memory leak in an error handling path in 'net2272_plat_probe()'
      usb: gadget: audio: Fix a missing error return value in audio_bind()

Cong Wang (1):
      net: fix a potential recursive NETDEV_FEAT_CHANGE

David Ahern (1):
      net: handle no dst on skb in icmp6_send

Dmitry Torokhov (3):
      ptp: do not explicitly set drvdata in ptp_clock_register()
      ptp: use is_visible method to hide unused attributes
      ptp: create "pins" together with the rest of attributes

Eric Dumazet (2):
      sch_sfq: validate silly quantum values
      sch_choke: avoid potential panic in choke_reset()

Eric W. Biederman (1):
      exec: Move would_dump into flush_old_exec

Fabio Estevam (1):
      ARM: dts: imx27-phytec-phycard-s-rdk: Fix the I2C1 pinctrl entries

Gabriel Krisman Bertazi (1):
      blk-mq: Allow timeouts to run while queue is freezing

Gal Pressman (1):
      net/mlx5: Fix driver load error flow when firmware is stuck

Geert Uytterhoeven (1):
      ARM: dts: r8a7740: Add missing extal2 to CPG node

George Spelvin (1):
      batman-adv: fix batadv_nc_random_weight_tq

Govindarajulu Varadarajan (1):
      enic: do not overwrite error code

Greg Kroah-Hartman (2):
      Revert "net: phy: Avoid polling PHY with PHY_IGNORE_INTERRUPTS"
      Linux 4.4.224

Hans de Goede (1):
      Revert "ACPI / video: Add force_native quirk for HP Pavilion dv6"

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

Jianchao Wang (1):
      blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter

Jim Mattson (1):
      KVM: x86: Fix off-by-one error in kvm_vcpu_ioctl_x86_setup_mce

Jiri Benc (1):
      gre: do not keep the GRE header around in collect medata mode

John Hurley (1):
      net: openvswitch: fix csum updates for MPLS actions

Julia Lawall (1):
      dp83640: reverse arguments to list_add_tail

Kai-Heng Feng (1):
      Revert "ALSA: hda/realtek: Fix pop noise on ALC225"

Kees Cook (2):
      binfmt_elf: move brk out of mmap when doing direct loader exec
      binfmt_elf: Do not move brk for INTERP-less ET_EXEC

Keith Busch (1):
      blk-mq: Allow blocking queue tag iter callbacks

Kyungtae Kim (1):
      USB: gadget: fix illegal array access in binding with UDC

Linus Torvalds (7):
      gcc-10 warnings: fix low-hanging fruit
      Stop the ad-hoc games with -Wno-maybe-initialized
      gcc-10: disable 'zero-length-bounds' warning for now
      gcc-10: disable 'array-bounds' warning for now
      gcc-10: disable 'stringop-overflow' warning for now
      gcc-10: disable 'restrict' warning for now
      gcc-10: avoid shadowing standard library 'free()' in crypto

Logan Gunthorpe (1):
      chardev: add helper function to register char devs with a struct device

Lubomir Rintel (1):
      dmaengine: mmp_tdma: Reset channel error on release

Madhuparna Bhowmik (1):
      dmaengine: pch_dma.c: Avoid data race between probe and irq handler

Masahiro Yamada (1):
      kbuild: compute false-positive -Wmaybe-uninitialized cases in Kconfig

Matt Jolly (1):
      USB: serial: qcserial: Add DW5816e support

Oliver Neukum (2):
      USB: uas: add quirk for LaCie 2Big Quadra
      USB: serial: garmin_gps: add sanity checking for data length

Paolo Abeni (2):
      net: ipv4: really enforce backoff for redirects
      netlabel: cope with NULL catmap

Ronnie Sahlberg (1):
      cifs: Fix a race condition with cifs_echo_request

Sabrina Dubroca (3):
      ipv6: fix cleanup ordering for ip6_mr failure
      net: ipv6: add net argument to ip6_dst_lookup_flow
      net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup

Samuel Cabrero (1):
      cifs: Check for timeout on Negotiate stage

Sergei Trofimovich (1):
      Makefile: disallow data races on gcc-10 as well

Shijie Luo (1):
      ext4: add cond_resched() to ext4_protect_reserved_inode

Takashi Iwai (3):
      ALSA: hda/realtek - Limit int mic boost for Thinkpad T530
      ALSA: rawmidi: Fix racy buffer resize under concurrent accesses
      ALSA: rawmidi: Initialize allocated buffers

Tariq Toukan (1):
      net/mlx4_core: Fix use of ENOSPC around mlx4_counter_alloc()

Vasily Averin (2):
      drm/qxl: lost qxl_bo_kunmap_atomic_page in qxl_image_init_helper()
      ipc/util.c: sysvipc_find_ipc() incorrectly updates position index

Ville Syrjälä (1):
      x86/apm: Don't access __preempt_count with zeroed fs

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

YueHaibing (1):
      ptp: Fix pass zero to ERR_PTR() in ptp_clock_register

wuxu.wu (1):
      spi: spi-dw: Add lock protect dw_spi rx/tx to prevent concurrent calls

zhong jiang (1):
      mm/memory_hotplug.c: fix overflow in test_pages_in_a_zone()

