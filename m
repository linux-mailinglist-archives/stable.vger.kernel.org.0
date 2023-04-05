Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519496D78BF
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 11:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237649AbjDEJrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 05:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237658AbjDEJrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 05:47:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B665F4ECB;
        Wed,  5 Apr 2023 02:47:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38C62623DA;
        Wed,  5 Apr 2023 09:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A2CC433EF;
        Wed,  5 Apr 2023 09:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680688021;
        bh=0YrekIMJOAvVTt21uSyi38VTNsHH8ALvCaMFnAa3inU=;
        h=From:To:Cc:Subject:Date:From;
        b=PFrVG1zZTJcQeE0Tvfmmhhm8xesiuv+oUsqkLDg1cQLhRp+WEX/LiC7dF3NDdvaqa
         PBNnjGp0GIDazbBzfKTq+xZ2noxKRJIVWgV0rtQkx9KsXdiFUWKjoAOJYhMSPZcvU4
         JuuOfgolM56AMwn8WKX2ezedu4r9j8Yckq76IKT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.280
Date:   Wed,  5 Apr 2023 11:46:54 +0200
Message-Id: <2023040555-reformed-venomous-87e6@gregkh>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.280 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/00-INDEX                   |    4 
 Documentation/networking/i40evf.txt                 |   54 
 Documentation/networking/iavf.txt                   |   56 
 MAINTAINERS                                         |    2 
 Makefile                                            |    2 
 arch/m68k/kernel/traps.c                            |    4 
 arch/riscv/include/uapi/asm/setup.h                 |    8 
 arch/s390/lib/uaccess.c                             |    2 
 arch/sh/include/asm/processor_32.h                  |    1 
 arch/sh/kernel/signal_32.c                          |    3 
 drivers/atm/idt77252.c                              |   11 
 drivers/bluetooth/btqcomsmd.c                       |   17 
 drivers/bluetooth/btsdio.c                          |    1 
 drivers/bus/imx-weim.c                              |    2 
 drivers/firmware/arm_scmi/driver.c                  |   37 
 drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c         |   10 
 drivers/hwmon/it87.c                                |    4 
 drivers/i2c/busses/i2c-imx-lpi2c.c                  |    4 
 drivers/i2c/busses/i2c-xgene-slimpro.c              |    3 
 drivers/input/mouse/alps.c                          |   16 
 drivers/input/mouse/focaltech.c                     |    8 
 drivers/md/dm-crypt.c                               |    1 
 drivers/md/dm-stats.c                               |    7 
 drivers/md/dm-stats.h                               |    2 
 drivers/md/dm-thin.c                                |    2 
 drivers/md/dm.c                                     |    4 
 drivers/md/md.c                                     |    3 
 drivers/net/dsa/mv88e6xxx/chip.c                    |    9 
 drivers/net/ethernet/intel/Kconfig                  |   15 
 drivers/net/ethernet/intel/Makefile                 |    2 
 drivers/net/ethernet/intel/i40e/i40e_diag.c         |   11 
 drivers/net/ethernet/intel/i40e/i40e_diag.h         |    2 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c  |    8 
 drivers/net/ethernet/intel/i40evf/Makefile          |   16 
 drivers/net/ethernet/intel/i40evf/i40e_adminq.c     |  967 ----
 drivers/net/ethernet/intel/i40evf/i40e_adminq.h     |  136 
 drivers/net/ethernet/intel/i40evf/i40e_adminq_cmd.h | 2717 -------------
 drivers/net/ethernet/intel/i40evf/i40e_alloc.h      |   35 
 drivers/net/ethernet/intel/i40evf/i40e_common.c     | 1320 ------
 drivers/net/ethernet/intel/i40evf/i40e_devids.h     |   34 
 drivers/net/ethernet/intel/i40evf/i40e_hmc.h        |  215 -
 drivers/net/ethernet/intel/i40evf/i40e_lan_hmc.h    |  158 
 drivers/net/ethernet/intel/i40evf/i40e_osdep.h      |   52 
 drivers/net/ethernet/intel/i40evf/i40e_prototype.h  |  130 
 drivers/net/ethernet/intel/i40evf/i40e_register.h   |  313 -
 drivers/net/ethernet/intel/i40evf/i40e_status.h     |   78 
 drivers/net/ethernet/intel/i40evf/i40e_trace.h      |  209 -
 drivers/net/ethernet/intel/i40evf/i40e_txrx.c       | 2513 ------------
 drivers/net/ethernet/intel/i40evf/i40e_txrx.h       |  524 --
 drivers/net/ethernet/intel/i40evf/i40e_type.h       | 1496 -------
 drivers/net/ethernet/intel/i40evf/i40evf.h          |  427 --
 drivers/net/ethernet/intel/i40evf/i40evf_client.c   |  579 --
 drivers/net/ethernet/intel/i40evf/i40evf_client.h   |  169 
 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c  |  820 ----
 drivers/net/ethernet/intel/i40evf/i40evf_main.c     | 3989 -------------------
 drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c | 1458 -------
 drivers/net/ethernet/intel/iavf/Makefile            |   15 
 drivers/net/ethernet/intel/iavf/i40e_adminq.c       |  940 ++++
 drivers/net/ethernet/intel/iavf/i40e_adminq.h       |  136 
 drivers/net/ethernet/intel/iavf/i40e_adminq_cmd.h   |  528 ++
 drivers/net/ethernet/intel/iavf/i40e_alloc.h        |   35 
 drivers/net/ethernet/intel/iavf/i40e_common.c       |  982 ++++
 drivers/net/ethernet/intel/iavf/i40e_devids.h       |   34 
 drivers/net/ethernet/intel/iavf/i40e_osdep.h        |   52 
 drivers/net/ethernet/intel/iavf/i40e_prototype.h    |   71 
 drivers/net/ethernet/intel/iavf/i40e_register.h     |   68 
 drivers/net/ethernet/intel/iavf/i40e_status.h       |   78 
 drivers/net/ethernet/intel/iavf/i40e_trace.h        |  209 +
 drivers/net/ethernet/intel/iavf/i40e_txrx.c         | 2513 ++++++++++++
 drivers/net/ethernet/intel/iavf/i40e_txrx.h         |  524 ++
 drivers/net/ethernet/intel/iavf/i40e_type.h         |  719 +++
 drivers/net/ethernet/intel/iavf/i40evf.h            |  427 ++
 drivers/net/ethernet/intel/iavf/i40evf_client.c     |  579 ++
 drivers/net/ethernet/intel/iavf/i40evf_client.h     |  169 
 drivers/net/ethernet/intel/iavf/i40evf_ethtool.c    |  820 ++++
 drivers/net/ethernet/intel/iavf/i40evf_main.c       | 3990 ++++++++++++++++++++
 drivers/net/ethernet/intel/iavf/i40evf_virtchnl.c   | 1465 +++++++
 drivers/net/ethernet/intel/igb/igb_main.c           |    2 
 drivers/net/ethernet/intel/igbvf/netdev.c           |    8 
 drivers/net/ethernet/intel/igbvf/vf.c               |   13 
 drivers/net/ethernet/marvell/mvneta.c               |   66 
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c  |    6 
 drivers/net/ethernet/natsemi/sonic.c                |    4 
 drivers/net/ethernet/qlogic/qed/qed_sriov.c         |    5 
 drivers/net/ethernet/qualcomm/emac/emac.c           |    6 
 drivers/net/ethernet/toshiba/ps3_gelic_net.c        |   41 
 drivers/net/ethernet/toshiba/ps3_gelic_net.h        |    5 
 drivers/net/ethernet/xircom/xirc2ps_cs.c            |    5 
 drivers/net/ieee802154/ca8210.c                     |    5 
 drivers/net/phy/mdio-thunder.c                      |    1 
 drivers/net/tun.c                                   |  109 
 drivers/net/usb/cdc_mbim.c                          |    5 
 drivers/net/usb/qmi_wwan.c                          |    1 
 drivers/net/usb/smsc95xx.c                          |    6 
 drivers/net/xen-netback/common.h                    |    2 
 drivers/net/xen-netback/netback.c                   |   25 
 drivers/pinctrl/pinctrl-at91-pio4.c                 |    1 
 drivers/power/supply/da9150-charger.c               |    1 
 drivers/scsi/device_handler/scsi_dh_alua.c          |    6 
 drivers/scsi/megaraid/megaraid_sas_fusion.c         |    4 
 drivers/scsi/scsi_devinfo.c                         |    1 
 drivers/scsi/ufs/ufshcd.c                           |    1 
 drivers/target/iscsi/iscsi_target_parameters.c      |   12 
 drivers/thunderbolt/nhi.c                           |    2 
 drivers/tty/hvc/hvc_xen.c                           |   19 
 drivers/usb/chipidea/ci.h                           |    2 
 drivers/usb/chipidea/core.c                         |   11 
 drivers/usb/chipidea/otg.c                          |    5 
 drivers/usb/gadget/function/u_audio.c               |    2 
 drivers/usb/host/ohci-pxa27x.c                      |    2 
 drivers/usb/storage/unusual_uas.h                   |    7 
 drivers/video/fbdev/au1200fb.c                      |    3 
 drivers/video/fbdev/geode/lxfb_core.c               |    3 
 drivers/video/fbdev/intelfb/intelfbdrv.c            |    3 
 drivers/video/fbdev/nvidia/nvidia.c                 |    2 
 drivers/video/fbdev/tgafb.c                         |    3 
 fs/cifs/cifsfs.h                                    |    5 
 fs/cifs/cifssmb.c                                   |    9 
 fs/cifs/smb2ops.c                                   |    2 
 fs/ext4/inode.c                                     |    3 
 fs/gfs2/aops.c                                      |    2 
 fs/gfs2/bmap.c                                      |    3 
 fs/gfs2/glops.c                                     |    3 
 fs/nilfs2/ioctl.c                                   |    2 
 fs/ocfs2/aops.c                                     |   18 
 include/linux/cpuset.h                              |    8 
 kernel/bpf/core.c                                   |    2 
 kernel/cgroup/cgroup-v1.c                           |    3 
 kernel/cgroup/cgroup.c                              |   50 
 kernel/cgroup/cpuset.c                              |   25 
 kernel/compat.c                                     |    2 
 kernel/sched/core.c                                 |    7 
 kernel/sched/fair.c                                 |   54 
 net/can/bcm.c                                       |   16 
 net/ipv4/ip_gre.c                                   |    4 
 net/ipv6/ip6_gre.c                                  |    4 
 net/sched/sch_cbq.c                                 |    4 
 sound/pci/asihpi/hpi6205.c                          |    2 
 sound/pci/hda/patch_ca0132.c                        |    4 
 sound/pci/hda/patch_conexant.c                      |    6 
 sound/usb/format.c                                  |    8 
 141 files changed, 15039 insertions(+), 18636 deletions(-)

Adrien Thierry (1):
      scsi: ufs: core: Add soft dependency on governor_simpleondemand

Akihiko Odaki (1):
      igbvf: Regard vf reset nack as success

Al Viro (1):
      sh: sanitize the flags on sigreturn

Alexander Aring (1):
      ca8210: fix mac_len negative array access

Alexander Lobakin (1):
      iavf: fix inverted Rx hash condition leading to disabled hash

Alexander Stein (1):
      i2c: imx-lpi2c: check only for enabled interrupt flags

Alexandre Ghiti (1):
      riscv: Bump COMMAND_LINE_SIZE value to 1024

Alvin Šipraga (1):
      usb: gadget: u_audio: don't let userspace block driver unbind

Andreas Gruenbacher (1):
      gfs2: Always check inode size of inline inodes

Coly Li (1):
      dm thin: fix deadlock when swapping to thin device

Cristian Marussi (1):
      firmware: arm_scmi: Fix device node validation for mailbox transport

Dan Carpenter (1):
      usb: host: ohci-pxa27x: Fix and & vs | typo

Daniel Borkmann (1):
      bpf: Adjust insufficient default bpf_jit_limit

Daniil Tatianin (1):
      qed/qed_sriov: guard against NULL derefs from qed_iov_get_vf_info

David Disseldorp (1):
      cifs: fix DFS traversal oops without CONFIG_CIFS_DFS_UPCALL

Enrico Sau (2):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit FE990
      net: usb: qmi_wwan: add Telit 0x1080 composition

Eric Dumazet (1):
      erspan: do not use skb_mac_header() in ndo_start_xmit()

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
      Linux 4.19.280

Harshit Mogalapalli (1):
      ca8210: Fix unsigned mac_len comparison with zero in ca8210_skb_tx()

Heiko Carstens (1):
      s390/uaccess: add missing earlyclobber annotations to __clear_user()

Ivan Bornyakov (1):
      bus: imx-weim: fix branch condition evaluates to a garbage value

Ivan Orlov (1):
      can: bcm: bcm_tx_setup(): fix KMSAN uninit-value in vfs_write

Jamal Hadi Salim (1):
      net: sched: cbq: dont intepret cls results when asked to drop

Jan Kara via Ocfs2-devel (1):
      ocfs2: fix data corruption after failed write

Jason A. Donenfeld (1):
      Input: focaltech - use explicitly signed char type

Jesse Brandeburg (2):
      intel-ethernet: rename i40evf to iavf
      iavf: diet and reformat

Jiasheng Jiang (1):
      dm stats: check for and propagate alloc_percpu failure

Joel Selvaraj (1):
      scsi: core: Add BLIST_SKIP_VPD_PAGES for SKhynix H28U74301AMR

Johan Hovold (1):
      pinctrl: at91-pio4: fix domain name assignment

Juergen Gross (1):
      xen/netback: don't do grant copy across page boundary

Juri Lelli (1):
      cgroup/cpuset: Change cpuset_rwsem and hotplug lock order

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

NeilBrown (1):
      md: avoid signed overflow in slot_store()

Paulo Alcantara (1):
      cifs: prevent infinite recursion in CIFSGetDFSRefer()

Paweł Jabłoński (1):
      i40evf: Change a VF mac without reloading the VF driver

Radoslaw Tyl (1):
      i40e: fix registers dump after run ethtool adapter self test

Roger Pau Monne (1):
      hvc/xen: prevent concurrent accesses to the shared ring

Ryusuke Konishi (1):
      nilfs2: fix kernel-infoleak in nilfs_ioctl_wrap_copy()

Shyam Prasad N (1):
      cifs: empty interface list when server doesn't support query interfaces

Steffen Bätz (1):
      net: dsa: mv88e6xxx: Enable IGMP snooping on user ports only

Stephan Gerhold (1):
      Bluetooth: btqcomsmd: Fix command timeout after setting BD address

Szymon Heidrich (1):
      net: usb: smsc95xx: Limit packet length to skb->len

Takashi Iwai (2):
      ALSA: hda/conexant: Partial revert of a quirk for Lenovo
      ALSA: usb-audio: Fix regression on detection of Roland VS-100

Tejun Heo (1):
      cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock

Tetsuo Handa (1):
      cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()

Tomas Henzl (1):
      scsi: megaraid_sas: Fix crash after a double completion

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

