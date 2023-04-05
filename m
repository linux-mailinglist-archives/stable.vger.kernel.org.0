Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF4B6D78C7
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 11:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237778AbjDEJsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 05:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237682AbjDEJrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 05:47:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0233A4ED7;
        Wed,  5 Apr 2023 02:47:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AAAE62358;
        Wed,  5 Apr 2023 09:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161C8C4339B;
        Wed,  5 Apr 2023 09:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680688029;
        bh=OdwxLTS2RD8plFztLueQTcSw/CujTbgxqQhz1nlR6OM=;
        h=From:To:Cc:Subject:Date:From;
        b=ezvZI58zLuwUOUIUhjqbRu0EP6C0FicHdkZqsik5wqQyBVO51CK6ep3QN3ku4FR8p
         DW59JzEgS7TI9S4MsrTyy07XAD6lFUEmsgWH2xp1iYdbXDn79E9PvVpn1vQOwPumzU
         zl1TVW8SQIOkG8typtY7Dv8NlcfISO4d7UFGhupo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.240
Date:   Wed,  5 Apr 2023 11:47:02 +0200
Message-Id: <2023040502-untimely-condition-cbad@gregkh>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.240 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arc/mm/dma.c                                  |    8 -
 arch/arm/mm/dma-mapping.c                          |    8 -
 arch/arm/xen/mm.c                                  |   12 +-
 arch/arm64/mm/dma-mapping.c                        |    8 -
 arch/c6x/mm/dma-coherent.c                         |   14 +-
 arch/csky/mm/dma-mapping.c                         |    8 -
 arch/hexagon/kernel/dma.c                          |    4 
 arch/ia64/mm/init.c                                |    4 
 arch/m68k/kernel/dma.c                             |    4 
 arch/m68k/kernel/traps.c                           |    4 
 arch/microblaze/kernel/dma.c                       |   14 +-
 arch/mips/bmips/dma.c                              |    7 +
 arch/mips/bmips/setup.c                            |    8 +
 arch/mips/jazz/jazzdma.c                           |   17 +--
 arch/mips/mm/dma-noncoherent.c                     |   12 +-
 arch/nds32/kernel/dma.c                            |    8 -
 arch/nios2/mm/dma-mapping.c                        |    8 -
 arch/openrisc/kernel/dma.c                         |    2 
 arch/parisc/kernel/pci-dma.c                       |    8 -
 arch/powerpc/mm/dma-noncoherent.c                  |    8 -
 arch/riscv/include/uapi/asm/setup.h                |    8 +
 arch/s390/lib/uaccess.c                            |    2 
 arch/sh/include/asm/processor_32.h                 |    1 
 arch/sh/kernel/dma-coherent.c                      |    6 -
 arch/sh/kernel/signal_32.c                         |    3 
 arch/sparc/kernel/ioport.c                         |    4 
 arch/xtensa/kernel/pci-dma.c                       |    8 -
 drivers/atm/idt77252.c                             |   11 ++
 drivers/bluetooth/btqcomsmd.c                      |   17 +++
 drivers/bluetooth/btsdio.c                         |    1 
 drivers/bus/imx-weim.c                             |    2 
 drivers/firmware/arm_scmi/driver.c                 |   37 +++++++
 drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c        |   10 +
 drivers/hwmon/it87.c                               |    4 
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |    4 
 drivers/i2c/busses/i2c-xgene-slimpro.c             |    3 
 drivers/input/mouse/alps.c                         |   16 +--
 drivers/input/mouse/focaltech.c                    |    8 -
 drivers/input/touchscreen/goodix.c                 |   14 ++
 drivers/iommu/dma-iommu.c                          |   10 -
 drivers/md/dm-crypt.c                              |    1 
 drivers/md/dm-stats.c                              |    7 +
 drivers/md/dm-stats.h                              |    2 
 drivers/md/dm-thin.c                               |    2 
 drivers/md/dm.c                                    |    4 
 drivers/md/md.c                                    |    3 
 drivers/mtd/nand/raw/meson_nand.c                  |    8 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |    9 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    8 -
 drivers/net/ethernet/intel/i40e/i40e_diag.c        |   11 +-
 drivers/net/ethernet/intel/i40e/i40e_diag.h        |    2 
 drivers/net/ethernet/intel/iavf/iavf_common.c      |    2 
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |    2 
 drivers/net/ethernet/intel/igb/igb_main.c          |    2 
 drivers/net/ethernet/intel/igbvf/netdev.c          |    8 +
 drivers/net/ethernet/intel/igbvf/vf.c              |   13 +-
 drivers/net/ethernet/marvell/mvneta.c              |   66 ++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |    6 -
 drivers/net/ethernet/natsemi/sonic.c               |    4 
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |    5 
 drivers/net/ethernet/qualcomm/emac/emac.c          |    6 +
 drivers/net/ethernet/toshiba/ps3_gelic_net.c       |   41 ++++---
 drivers/net/ethernet/toshiba/ps3_gelic_net.h       |    5 
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |    5 
 drivers/net/ieee802154/ca8210.c                    |    5 
 drivers/net/net_failover.c                         |    8 -
 drivers/net/phy/mdio-thunder.c                     |    1 
 drivers/net/tun.c                                  |  109 +++++++++++----------
 drivers/net/usb/cdc_mbim.c                         |    5 
 drivers/net/usb/qmi_wwan.c                         |    1 
 drivers/net/usb/smsc95xx.c                         |    6 +
 drivers/net/xen-netback/common.h                   |    2 
 drivers/net/xen-netback/netback.c                  |   25 ++++
 drivers/pinctrl/pinctrl-at91-pio4.c                |    1 
 drivers/pinctrl/pinctrl-ocelot.c                   |    2 
 drivers/platform/chrome/cros_ec_chardev.c          |    2 
 drivers/power/supply/da9150-charger.c              |    1 
 drivers/ptp/ptp_qoriq.c                            |    2 
 drivers/regulator/fixed.c                          |    4 
 drivers/s390/crypto/vfio_ap_drv.c                  |    3 
 drivers/scsi/device_handler/scsi_dh_alua.c         |    6 -
 drivers/scsi/lpfc/lpfc_sli.c                       |    8 -
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |    4 
 drivers/scsi/qla2xxx/qla_os.c                      |   11 ++
 drivers/scsi/scsi_devinfo.c                        |    1 
 drivers/scsi/ufs/ufshcd.c                          |    1 
 drivers/target/iscsi/iscsi_target_parameters.c     |   12 +-
 drivers/thunderbolt/nhi.c                          |    2 
 drivers/tty/hvc/hvc_xen.c                          |   19 +++
 drivers/usb/cdns3/cdns3-pci-wrap.c                 |    5 
 drivers/usb/chipidea/ci.h                          |    2 
 drivers/usb/chipidea/core.c                        |   11 +-
 drivers/usb/chipidea/otg.c                         |    5 
 drivers/usb/gadget/function/u_audio.c              |    2 
 drivers/usb/storage/unusual_uas.h                  |    7 +
 drivers/video/fbdev/au1200fb.c                     |    3 
 drivers/video/fbdev/geode/lxfb_core.c              |    3 
 drivers/video/fbdev/intelfb/intelfbdrv.c           |    3 
 drivers/video/fbdev/nvidia/nvidia.c                |    2 
 drivers/video/fbdev/tgafb.c                        |    3 
 drivers/xen/swiotlb-xen.c                          |    8 -
 fs/btrfs/volumes.c                                 |   11 +-
 fs/cifs/cifsfs.h                                   |    5 
 fs/cifs/cifssmb.c                                  |    9 +
 fs/cifs/smb2ops.c                                  |    2 
 fs/ext4/inode.c                                    |    3 
 fs/gfs2/aops.c                                     |    2 
 fs/gfs2/bmap.c                                     |    3 
 fs/gfs2/glops.c                                    |    3 
 fs/nfs/nfs4proc.c                                  |    5 
 fs/nilfs2/ioctl.c                                  |    2 
 fs/ocfs2/aops.c                                    |   18 +++
 fs/verity/enable.c                                 |   24 ++--
 fs/verity/verify.c                                 |   12 +-
 include/linux/dma-noncoherent.h                    |   20 +--
 include/linux/netdevice.h                          |    2 
 include/linux/nvme-tcp.h                           |    5 
 include/xen/swiotlb-xen.h                          |    8 -
 kernel/bpf/core.c                                  |    2 
 kernel/compat.c                                    |    2 
 kernel/dma/direct.c                                |   14 +-
 kernel/sched/core.c                                |    7 -
 kernel/sched/fair.c                                |   54 +++++++++-
 net/can/bcm.c                                      |   16 +--
 net/core/rtnetlink.c                               |    6 -
 net/ipv4/ip_gre.c                                  |    4 
 net/ipv6/ip6_gre.c                                 |    4 
 net/mac80211/wme.c                                 |    6 -
 net/sched/cls_api.c                                |    6 -
 net/sched/sch_api.c                                |   25 ++--
 net/sched/sch_generic.c                            |   22 ++--
 net/tls/tls_main.c                                 |    9 -
 security/keys/request_key.c                        |    9 +
 sound/pci/asihpi/hpi6205.c                         |    2 
 sound/pci/hda/patch_ca0132.c                       |    4 
 sound/pci/hda/patch_conexant.c                     |    6 -
 sound/usb/format.c                                 |    8 +
 tools/testing/selftests/bpf/test_btf.c             |   28 +++++
 139 files changed, 829 insertions(+), 393 deletions(-)

Adrien Thierry (1):
      scsi: ufs: core: Add soft dependency on governor_simpleondemand

Akihiko Odaki (1):
      igbvf: Regard vf reset nack as success

Al Viro (1):
      sh: sanitize the flags on sigreturn

Alexander Aring (1):
      ca8210: fix mac_len negative array access

Alexander Lobakin (2):
      iavf: fix inverted Rx hash condition leading to disabled hash
      iavf: fix non-tunneled IPv6 UDP packet type and hashing

Alexander Stein (1):
      i2c: imx-lpi2c: check only for enabled interrupt flags

Alexandre Ghiti (1):
      riscv: Bump COMMAND_LINE_SIZE value to 1024

Alvin Šipraga (1):
      usb: gadget: u_audio: don't let userspace block driver unbind

Anand Jain (1):
      btrfs: scan device in non-exclusive mode

Andreas Gruenbacher (1):
      gfs2: Always check inode size of inline inodes

Arseniy Krasnov (1):
      mtd: rawnand: meson: invalidate cache on polling ECC bit

Caleb Sander (1):
      nvme-tcp: fix nvme_tcp_term_pdu to match spec

Christoph Hellwig (1):
      dma-mapping: drop the dev argument to arch_sync_dma_for_*

Christophe JAILLET (1):
      regulator: Handle deferred clk

Colin Ian King (1):
      regulator: fix spelling mistake "Cant" -> "Can't"

Coly Li (1):
      dm thin: fix deadlock when swapping to thin device

Cristian Marussi (1):
      firmware: arm_scmi: Fix device node validation for mailbox transport

Daniel Borkmann (1):
      bpf: Adjust insufficient default bpf_jit_limit

Daniil Tatianin (1):
      qed/qed_sriov: guard against NULL derefs from qed_iov_get_vf_info

David Disseldorp (1):
      cifs: fix DFS traversal oops without CONFIG_CIFS_DFS_UPCALL

David Howells (1):
      keys: Do not cache key in task struct if key is requested from kernel thread

Enrico Sau (2):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit FE990
      net: usb: qmi_wwan: add Telit 0x1080 composition

Eric Biggers (1):
      fsverity: don't drop pagecache at end of FS_IOC_ENABLE_VERITY

Eric Dumazet (3):
      erspan: do not use skb_mac_header() in ndo_start_xmit()
      net_sched: add __rcu annotation to netdev->qdisc
      net: sched: fix race condition in qdisc_graft()

Faicker Mo (1):
      net/net_failover: fix txq exceeding warning

Felix Fietkau (1):
      wifi: mac80211: fix qos on mesh interfaces

Frank Crawford (1):
      hwmon (it87): Fix voltage scaling for chips with 10.9mV ADCs

Gaosheng Cui (1):
      intel/igbvf: free irq on the error path in igbvf_request_msix()

Geoff Levand (2):
      net/ps3_gelic_net: Fix RX sk_buff length
      net/ps3_gelic_net: Use dma_mapping_error

George Kennedy (1):
      tun: avoid double free in tun_free_netdev

Greg Kroah-Hartman (1):
      Linux 5.4.240

Hangyu Hua (1):
      net: tls: fix possible race condition between do_tls_getsockopt_conf() and do_tls_setsockopt_conf()

Hans de Goede (1):
      Input: goodix - add Lenovo Yoga Book X90F to nine_bytes_report DMI table

Harshit Mogalapalli (1):
      ca8210: Fix unsigned mac_len comparison with zero in ca8210_skb_tx()

Heiko Carstens (1):
      s390/uaccess: add missing earlyclobber annotations to __clear_user()

Horatiu Vultur (1):
      pinctrl: ocelot: Fix alt mode for ocelot

Ivan Bornyakov (1):
      bus: imx-weim: fix branch condition evaluates to a garbage value

Ivan Orlov (1):
      can: bcm: bcm_tx_setup(): fix KMSAN uninit-value in vfs_write

Jakob Koschel (1):
      scsi: lpfc: Avoid usage of list iterator variable after loop

Jan Kara via Ocfs2-devel (1):
      ocfs2: fix data corruption after failed write

Jason A. Donenfeld (1):
      Input: focaltech - use explicitly signed char type

Jiasheng Jiang (1):
      dm stats: check for and propagate alloc_percpu failure

Joel Selvaraj (1):
      scsi: core: Add BLIST_SKIP_VPD_PAGES for SKhynix H28U74301AMR

Johan Hovold (1):
      pinctrl: at91-pio4: fix domain name assignment

Juergen Gross (1):
      xen/netback: don't do grant copy across page boundary

Kalesh AP (1):
      bnxt_en: Fix typo in PCI id to device description string mapping

Kuninori Morimoto (2):
      ALSA: asihpi: check pao in control_message()
      ALSA: hda/ca0132: fixup buffer overrun at tuning_ctl_set()

Li Zetao (1):
      atm: idt77252: fix kmemleak when rmmod idt77252

Liang He (1):
      net: mdio: thunder: Add missing fwnode_handle_put()

Lin Ma (1):
      igb: revert rtnl_lock() that causes deadlock

Linus Torvalds (1):
      sched_getaffinity: don't assume 'cpumask_size()' is fully initialized

Lorenz Bauer (1):
      selftests/bpf: check that modifier resolves after pointer

Lorenzo Bianconi (1):
      net: mvneta: make tx buffer array agnostic

Lucas Stach (1):
      drm/etnaviv: fix reference leak when mmaping imported buffer

Maher Sanalla (1):
      net/mlx5: Read the TC mapping of all priorities on ETS query

Mario Limonciello (1):
      thunderbolt: Use const qualifier for `ring_interrupt_index`

Maurizio Lombardi (1):
      scsi: target: iscsi: Fix an error message in iscsi_check_key()

Michael Schmitz (1):
      m68k: Only force 030 bus error if PC not in exception table

Mikulas Patocka (1):
      dm crypt: add cond_resched() to dmcrypt_write()

Nathan Huckleberry (1):
      fsverity: Remove WQ_UNBOUND from fsverity read workqueue

NeilBrown (1):
      md: avoid signed overflow in slot_store()

Nilesh Javali (1):
      scsi: qla2xxx: Perform lockless command completion in abort path

Paulo Alcantara (1):
      cifs: prevent infinite recursion in CIFSGetDFSRefer()

Pawel Laszczak (1):
      usb: cdns3: Fix issue with using incorrect PCI device function

Radoslaw Tyl (1):
      i40e: fix registers dump after run ethtool adapter self test

Roger Pau Monne (1):
      hvc/xen: prevent concurrent accesses to the shared ring

Ryusuke Konishi (1):
      nilfs2: fix kernel-infoleak in nilfs_ioctl_wrap_copy()

Shyam Prasad N (1):
      cifs: empty interface list when server doesn't support query interfaces

SongJingyi (1):
      ptp_qoriq: fix memory leak in probe()

Steffen Bätz (1):
      net: dsa: mv88e6xxx: Enable IGMP snooping on user ports only

Stephan Gerhold (1):
      Bluetooth: btqcomsmd: Fix command timeout after setting BD address

Szymon Heidrich (1):
      net: usb: smsc95xx: Limit packet length to skb->len

Takashi Iwai (2):
      ALSA: hda/conexant: Partial revert of a quirk for Lenovo
      ALSA: usb-audio: Fix regression on detection of Roland VS-100

Tomas Henzl (1):
      scsi: megaraid_sas: Fix crash after a double completion

Tony Krowiak (1):
      s390/vfio-ap: fix memory leak in vfio_ap device driver

Trond Myklebust (1):
      NFSv4: Fix hangs when recovering open state after a server reboot

Tzung-Bi Shih (1):
      platform/chrome: cros_ec_chardev: fix kernel data leak from ioctl

Vincent Guittot (1):
      sched/fair: Sanitize vruntime of entity being migrated

Wei Chen (6):
      i2c: xgene-slimpro: Fix out-of-bounds bug in xgene_slimpro_i2c_xfer()
      fbdev: tgafb: Fix potential divide by zero
      fbdev: nvidia: Fix potential divide by zero
      fbdev: intelfb: Fix potential divide by zero
      fbdev: lxfb: Fix potential divide by zero
      fbdev: au1200fb: Fix potential divide by zero

Xu Yang (2):
      usb: chipdea: core: fix return -EINVAL if request role is the same with current role
      usb: chipidea: core: fix possible concurrent when switch role

Yaroslav Furman (1):
      uas: Add US_FL_NO_REPORT_OPCODES for JMicron JMS583Gen 2

Ye Bin (1):
      ext4: fix kernel BUG in 'ext4_write_inline_data_end()'

Yu Kuai (1):
      scsi: scsi_dh_alua: Fix memleak for 'qdata' in alua_activate()

Zhang Changzhong (1):
      net/sonic: use dma_mapping_error() for error check

Zhang Qiao (1):
      sched/fair: sanitize vruntime of entity being placed

Zheng Wang (4):
      power: supply: da9150: Fix use after free bug in da9150_charger_remove due to race condition
      xirc2ps_cs: Fix use after free bug in xirc2ps_detach
      net: qcom/emac: Fix use after free bug in emac_remove due to race condition
      Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work

msizanoen (1):
      Input: alps - fix compatibility with -funsigned-char

Álvaro Fernández Rojas (1):
      mips: bmips: BCM6358: disable RAC flush for TP1

