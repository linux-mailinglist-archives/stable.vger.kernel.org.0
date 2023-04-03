Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBD56D4771
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbjDCOUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbjDCOUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:20:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D7B2D7FC;
        Mon,  3 Apr 2023 07:19:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C295861D15;
        Mon,  3 Apr 2023 14:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7403C433EF;
        Mon,  3 Apr 2023 14:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531583;
        bh=apldveYs5q3hIhLENyLcdUom315KWHfnAHoyZvI314Y=;
        h=From:To:Cc:Subject:Date:From;
        b=OJ0DJKqYTz13oE0g7gn1eG8ImohorMSj2GVKuaL79YxJhxSwcEPQP7YcPaeDAiPUO
         mosiFQKZjrmmmPlzHaA1yobCLK0/SGMQBoCWeE2GL3Aflx24UuAkwNvHpHtx4wqdgO
         F3nNTgH9V6NWiIeT9Km25iGU3NJblQxKa3jAPDBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.4 000/104] 5.4.240-rc1 review
Date:   Mon,  3 Apr 2023 16:07:52 +0200
Message-Id: <20230403140403.549815164@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.240-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.240-rc1
X-KernelTest-Deadline: 2023-04-05T14:04+00:00
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

This is the start of the stable review cycle for the 5.4.240 release.
There are 104 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.240-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.240-rc1

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Always check inode size of inline inodes

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix device node validation for mailbox transport

Eric Dumazet <edumazet@google.com>
    net: sched: fix race condition in qdisc_graft()

Eric Dumazet <edumazet@google.com>
    net_sched: add __rcu annotation to netdev->qdisc

Ye Bin <yebin10@huawei.com>
    ext4: fix kernel BUG in 'ext4_write_inline_data_end()'

Anand Jain <anand.jain@oracle.com>
    btrfs: scan device in non-exclusive mode

Heiko Carstens <hca@linux.ibm.com>
    s390/uaccess: add missing earlyclobber annotations to __clear_user()

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: fix reference leak when mmaping imported buffer

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix regression on detection of Roland VS-100

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Partial revert of a quirk for Lenovo

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix hangs when recovering open state after a server reboot

Johan Hovold <johan+linaro@kernel.org>
    pinctrl: at91-pio4: fix domain name assignment

Juergen Gross <jgross@suse.com>
    xen/netback: don't do grant copy across page boundary

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - add Lenovo Yoga Book X90F to nine_bytes_report DMI table

David Disseldorp <ddiss@suse.de>
    cifs: fix DFS traversal oops without CONFIG_CIFS_DFS_UPCALL

Paulo Alcantara <pc@manguebit.com>
    cifs: prevent infinite recursion in CIFSGetDFSRefer()

Jason A. Donenfeld <Jason@zx2c4.com>
    Input: focaltech - use explicitly signed char type

msizanoen <msizanoen@qtmlabs.xyz>
    Input: alps - fix compatibility with -funsigned-char

Horatiu Vultur <horatiu.vultur@microchip.com>
    pinctrl: ocelot: Fix alt mode for ocelot

Lorenzo Bianconi <lorenzo@kernel.org>
    net: mvneta: make tx buffer array agnostic

Steffen Bätz <steffen@innosonix.de>
    net: dsa: mv88e6xxx: Enable IGMP snooping on user ports only

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    bnxt_en: Fix typo in PCI id to device description string mapping

Radoslaw Tyl <radoslawx.tyl@intel.com>
    i40e: fix registers dump after run ethtool adapter self test

Tony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: fix memory leak in vfio_ap device driver

Ivan Orlov <ivan.orlov0322@gmail.com>
    can: bcm: bcm_tx_setup(): fix KMSAN uninit-value in vfs_write

Faicker Mo <faicker.mo@ucloud.cn>
    net/net_failover: fix txq exceeding warning

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    regulator: Handle deferred clk

Colin Ian King <colin.king@canonical.com>
    regulator: fix spelling mistake "Cant" -> "Can't"

SongJingyi <u201912584@hust.edu.cn>
    ptp_qoriq: fix memory leak in probe()

Tomas Henzl <thenzl@redhat.com>
    scsi: megaraid_sas: Fix crash after a double completion

Arseniy Krasnov <avkrasnov@sberdevices.ru>
    mtd: rawnand: meson: invalidate cache on polling ECC bit

Álvaro Fernández Rojas <noltari@gmail.com>
    mips: bmips: BCM6358: disable RAC flush for TP1

Christoph Hellwig <hch@lst.de>
    dma-mapping: drop the dev argument to arch_sync_dma_for_*

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    ca8210: Fix unsigned mac_len comparison with zero in ca8210_skb_tx()

Wei Chen <harperchen1110@gmail.com>
    fbdev: au1200fb: Fix potential divide by zero

Wei Chen <harperchen1110@gmail.com>
    fbdev: lxfb: Fix potential divide by zero

Wei Chen <harperchen1110@gmail.com>
    fbdev: intelfb: Fix potential divide by zero

Wei Chen <harperchen1110@gmail.com>
    fbdev: nvidia: Fix potential divide by zero

Linus Torvalds <torvalds@linux-foundation.org>
    sched_getaffinity: don't assume 'cpumask_size()' is fully initialized

Wei Chen <harperchen1110@gmail.com>
    fbdev: tgafb: Fix potential divide by zero

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ALSA: hda/ca0132: fixup buffer overrun at tuning_ctl_set()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ALSA: asihpi: check pao in control_message()

NeilBrown <neilb@suse.de>
    md: avoid signed overflow in slot_store()

Ivan Bornyakov <i.bornyakov@metrotek.ru>
    bus: imx-weim: fix branch condition evaluates to a garbage value

Eric Biggers <ebiggers@google.com>
    fsverity: don't drop pagecache at end of FS_IOC_ENABLE_VERITY

Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: fix data corruption after failed write

George Kennedy <george.kennedy@oracle.com>
    tun: avoid double free in tun_free_netdev

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Sanitize vruntime of entity being migrated

Zhang Qiao <zhangqiao22@huawei.com>
    sched/fair: sanitize vruntime of entity being placed

Mikulas Patocka <mpatocka@redhat.com>
    dm crypt: add cond_resched() to dmcrypt_write()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    dm stats: check for and propagate alloc_percpu failure

Wei Chen <harperchen1110@gmail.com>
    i2c: xgene-slimpro: Fix out-of-bounds bug in xgene_slimpro_i2c_xfer()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix kernel-infoleak in nilfs_ioctl_wrap_copy()

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix qos on mesh interfaces

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: core: fix possible concurrent when switch role

Xu Yang <xu.yang_2@nxp.com>
    usb: chipdea: core: fix return -EINVAL if request role is the same with current role

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: Fix issue with using incorrect PCI device function

Coly Li <colyli@suse.de>
    dm thin: fix deadlock when swapping to thin device

Lin Ma <linma@zju.edu.cn>
    igb: revert rtnl_lock() that causes deadlock

Nathan Huckleberry <nhuck@google.com>
    fsverity: Remove WQ_UNBOUND from fsverity read workqueue

Alvin Šipraga <alsi@bang-olufsen.dk>
    usb: gadget: u_audio: don't let userspace block driver unbind

Joel Selvaraj <joelselvaraj.oss@gmail.com>
    scsi: core: Add BLIST_SKIP_VPD_PAGES for SKhynix H28U74301AMR

Shyam Prasad N <sprasad@microsoft.com>
    cifs: empty interface list when server doesn't support query interfaces

Al Viro <viro@zeniv.linux.org.uk>
    sh: sanitize the flags on sigreturn

Enrico Sau <enrico.sau@gmail.com>
    net: usb: qmi_wwan: add Telit 0x1080 composition

Enrico Sau <enrico.sau@gmail.com>
    net: usb: cdc_mbim: avoid altsetting toggling for Telit FE990

Jakob Koschel <jkl820.git@gmail.com>
    scsi: lpfc: Avoid usage of list iterator variable after loop

Adrien Thierry <athierry@redhat.com>
    scsi: ufs: core: Add soft dependency on governor_simpleondemand

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix an error message in iscsi_check_key()

Lorenz Bauer <lorenz.bauer@isovalent.com>
    selftests/bpf: check that modifier resolves after pointer

Michael Schmitz <schmitzmic@gmail.com>
    m68k: Only force 030 bus error if PC not in exception table

Alexander Aring <aahringo@redhat.com>
    ca8210: fix mac_len negative array access

Alexandre Ghiti <alex@ghiti.fr>
    riscv: Bump COMMAND_LINE_SIZE value to 1024

Mario Limonciello <mario.limonciello@amd.com>
    thunderbolt: Use const qualifier for `ring_interrupt_index`

Yaroslav Furman <yaro330@gmail.com>
    uas: Add US_FL_NO_REPORT_OPCODES for JMicron JMS583Gen 2

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Perform lockless command completion in abort path

Frank Crawford <frank@crawford.emu.id.au>
    hwmon (it87): Fix voltage scaling for chips with 10.9mV ADCs

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec_chardev: fix kernel data leak from ioctl

Zheng Wang <zyytlz.wz@163.com>
    Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    Bluetooth: btqcomsmd: Fix command timeout after setting BD address

Liang He <windhl@126.com>
    net: mdio: thunder: Add missing fwnode_handle_put()

Arınç ÜNAL <arinc.unal@arinc9.com>
    net: dsa: mt7530: move setting ssc_delta to PHY_INTERFACE_MODE_TRGMII case

Roger Pau Monne <roger.pau@citrix.com>
    hvc/xen: prevent concurrent accesses to the shared ring

Caleb Sander <csander@purestorage.com>
    nvme-tcp: fix nvme_tcp_term_pdu to match spec

Zhang Changzhong <zhangchangzhong@huawei.com>
    net/sonic: use dma_mapping_error() for error check

Eric Dumazet <edumazet@google.com>
    erspan: do not use skb_mac_header() in ndo_start_xmit()

Li Zetao <lizetao1@huawei.com>
    atm: idt77252: fix kmemleak when rmmod idt77252

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Read the TC mapping of all priorities on ETS query

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Adjust insufficient default bpf_jit_limit

David Howells <dhowells@redhat.com>
    keys: Do not cache key in task struct if key is requested from kernel thread

Geoff Levand <geoff@infradead.org>
    net/ps3_gelic_net: Use dma_mapping_error

Geoff Levand <geoff@infradead.org>
    net/ps3_gelic_net: Fix RX sk_buff length

Zheng Wang <zyytlz.wz@163.com>
    net: qcom/emac: Fix use after free bug in emac_remove due to race condition

Zheng Wang <zyytlz.wz@163.com>
    xirc2ps_cs: Fix use after free bug in xirc2ps_detach

Daniil Tatianin <d-tatianin@yandex-team.ru>
    qed/qed_sriov: guard against NULL derefs from qed_iov_get_vf_info

Szymon Heidrich <szymon.heidrich@gmail.com>
    net: usb: smsc95xx: Limit packet length to skb->len

Yu Kuai <yukuai3@huawei.com>
    scsi: scsi_dh_alua: Fix memleak for 'qdata' in alua_activate()

Alexander Stein <alexander.stein@ew.tq-group.com>
    i2c: imx-lpi2c: check only for enabled interrupt flags

Akihiko Odaki <akihiko.odaki@daynix.com>
    igbvf: Regard vf reset nack as success

Gaosheng Cui <cuigaosheng1@huawei.com>
    intel/igbvf: free irq on the error path in igbvf_request_msix()

Alexander Lobakin <aleksander.lobakin@intel.com>
    iavf: fix non-tunneled IPv6 UDP packet type and hashing

Alexander Lobakin <aleksander.lobakin@intel.com>
    iavf: fix inverted Rx hash condition leading to disabled hash

Zheng Wang <zyytlz.wz@163.com>
    power: supply: da9150: Fix use after free bug in da9150_charger_remove due to race condition

Hangyu Hua <hbh25y@gmail.com>
    net: tls: fix possible race condition between do_tls_getsockopt_conf() and do_tls_setsockopt_conf()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/mm/dma.c                                  |   8 +-
 arch/arm/mm/dma-mapping.c                          |   8 +-
 arch/arm/xen/mm.c                                  |  12 +--
 arch/arm64/mm/dma-mapping.c                        |   8 +-
 arch/c6x/mm/dma-coherent.c                         |  14 +--
 arch/csky/mm/dma-mapping.c                         |   8 +-
 arch/hexagon/kernel/dma.c                          |   4 +-
 arch/ia64/mm/init.c                                |   4 +-
 arch/m68k/kernel/dma.c                             |   4 +-
 arch/m68k/kernel/traps.c                           |   4 +-
 arch/microblaze/kernel/dma.c                       |  14 +--
 arch/mips/bmips/dma.c                              |   7 +-
 arch/mips/bmips/setup.c                            |   8 ++
 arch/mips/jazz/jazzdma.c                           |  17 ++--
 arch/mips/mm/dma-noncoherent.c                     |  12 +--
 arch/nds32/kernel/dma.c                            |   8 +-
 arch/nios2/mm/dma-mapping.c                        |   8 +-
 arch/openrisc/kernel/dma.c                         |   2 +-
 arch/parisc/kernel/pci-dma.c                       |   8 +-
 arch/powerpc/mm/dma-noncoherent.c                  |   8 +-
 arch/riscv/include/uapi/asm/setup.h                |   8 ++
 arch/s390/lib/uaccess.c                            |   2 +-
 arch/sh/include/asm/processor_32.h                 |   1 +
 arch/sh/kernel/dma-coherent.c                      |   6 +-
 arch/sh/kernel/signal_32.c                         |   3 +
 arch/sparc/kernel/ioport.c                         |   4 +-
 arch/xtensa/kernel/pci-dma.c                       |   8 +-
 drivers/atm/idt77252.c                             |  11 +++
 drivers/bluetooth/btqcomsmd.c                      |  17 +++-
 drivers/bluetooth/btsdio.c                         |   1 +
 drivers/bus/imx-weim.c                             |   2 +-
 drivers/firmware/arm_scmi/driver.c                 |  37 +++++++
 drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c        |  10 +-
 drivers/hwmon/it87.c                               |   4 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |   4 +
 drivers/i2c/busses/i2c-xgene-slimpro.c             |   3 +
 drivers/input/mouse/alps.c                         |  16 +--
 drivers/input/mouse/focaltech.c                    |   8 +-
 drivers/input/touchscreen/goodix.c                 |  14 ++-
 drivers/iommu/dma-iommu.c                          |  10 +-
 drivers/md/dm-crypt.c                              |   1 +
 drivers/md/dm-stats.c                              |   7 +-
 drivers/md/dm-stats.h                              |   2 +-
 drivers/md/dm-thin.c                               |   2 +
 drivers/md/dm.c                                    |   4 +-
 drivers/md/md.c                                    |   3 +
 drivers/mtd/nand/raw/meson_nand.c                  |   8 +-
 drivers/net/dsa/mt7530.c                           |   9 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   9 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_diag.c        |  11 ++-
 drivers/net/ethernet/intel/i40e/i40e_diag.h        |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_common.c      |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   2 -
 drivers/net/ethernet/intel/igbvf/netdev.c          |   8 +-
 drivers/net/ethernet/intel/igbvf/vf.c              |  13 ++-
 drivers/net/ethernet/marvell/mvneta.c              |  66 ++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   6 +-
 drivers/net/ethernet/natsemi/sonic.c               |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |   5 +-
 drivers/net/ethernet/qualcomm/emac/emac.c          |   6 ++
 drivers/net/ethernet/toshiba/ps3_gelic_net.c       |  41 ++++----
 drivers/net/ethernet/toshiba/ps3_gelic_net.h       |   5 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |   5 +
 drivers/net/ieee802154/ca8210.c                    |   5 +-
 drivers/net/net_failover.c                         |   8 +-
 drivers/net/phy/mdio-thunder.c                     |   1 +
 drivers/net/tun.c                                  | 109 +++++++++++----------
 drivers/net/usb/cdc_mbim.c                         |   5 +
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/smsc95xx.c                         |   6 ++
 drivers/net/xen-netback/common.h                   |   2 +-
 drivers/net/xen-netback/netback.c                  |  25 ++++-
 drivers/pinctrl/pinctrl-at91-pio4.c                |   1 -
 drivers/pinctrl/pinctrl-ocelot.c                   |   2 +-
 drivers/platform/chrome/cros_ec_chardev.c          |   2 +-
 drivers/power/supply/da9150-charger.c              |   1 +
 drivers/ptp/ptp_qoriq.c                            |   2 +-
 drivers/regulator/fixed.c                          |   4 +-
 drivers/s390/crypto/vfio_ap_drv.c                  |   3 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |   6 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   8 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  11 +++
 drivers/scsi/scsi_devinfo.c                        |   1 +
 drivers/scsi/ufs/ufshcd.c                          |   1 +
 drivers/target/iscsi/iscsi_target_parameters.c     |  12 ++-
 drivers/thunderbolt/nhi.c                          |   2 +-
 drivers/tty/hvc/hvc_xen.c                          |  19 +++-
 drivers/usb/cdns3/cdns3-pci-wrap.c                 |   5 +
 drivers/usb/chipidea/ci.h                          |   2 +
 drivers/usb/chipidea/core.c                        |  11 ++-
 drivers/usb/chipidea/otg.c                         |   5 +-
 drivers/usb/gadget/function/u_audio.c              |   2 +-
 drivers/usb/storage/unusual_uas.h                  |   7 ++
 drivers/video/fbdev/au1200fb.c                     |   3 +
 drivers/video/fbdev/geode/lxfb_core.c              |   3 +
 drivers/video/fbdev/intelfb/intelfbdrv.c           |   3 +
 drivers/video/fbdev/nvidia/nvidia.c                |   2 +
 drivers/video/fbdev/tgafb.c                        |   3 +
 drivers/xen/swiotlb-xen.c                          |   8 +-
 fs/btrfs/volumes.c                                 |  11 ++-
 fs/cifs/cifsfs.h                                   |   5 +-
 fs/cifs/cifssmb.c                                  |   9 +-
 fs/cifs/smb2ops.c                                  |   2 +-
 fs/ext4/inode.c                                    |   3 +-
 fs/gfs2/aops.c                                     |   2 -
 fs/gfs2/bmap.c                                     |   3 -
 fs/gfs2/glops.c                                    |   3 +
 fs/nfs/nfs4proc.c                                  |   5 +-
 fs/nilfs2/ioctl.c                                  |   2 +-
 fs/ocfs2/aops.c                                    |  18 +++-
 fs/verity/enable.c                                 |  24 ++---
 fs/verity/verify.c                                 |  12 +--
 include/linux/dma-noncoherent.h                    |  20 ++--
 include/linux/netdevice.h                          |   2 +-
 include/linux/nvme-tcp.h                           |   5 +-
 include/xen/swiotlb-xen.h                          |   8 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/compat.c                                    |   2 +-
 kernel/dma/direct.c                                |  14 +--
 kernel/sched/core.c                                |   7 +-
 kernel/sched/fair.c                                |  54 +++++++++-
 net/can/bcm.c                                      |  16 +--
 net/core/rtnetlink.c                               |   6 +-
 net/ipv4/ip_gre.c                                  |   4 +-
 net/ipv6/ip6_gre.c                                 |   4 +-
 net/mac80211/wme.c                                 |   6 +-
 net/sched/cls_api.c                                |   6 +-
 net/sched/sch_api.c                                |  25 ++---
 net/sched/sch_generic.c                            |  22 +++--
 net/tls/tls_main.c                                 |   9 +-
 security/keys/request_key.c                        |   9 +-
 sound/pci/asihpi/hpi6205.c                         |   2 +-
 sound/pci/hda/patch_ca0132.c                       |   4 +-
 sound/pci/hda/patch_conexant.c                     |   6 +-
 sound/usb/format.c                                 |   8 +-
 tools/testing/selftests/bpf/test_btf.c             |  28 ++++++
 140 files changed, 834 insertions(+), 399 deletions(-)


