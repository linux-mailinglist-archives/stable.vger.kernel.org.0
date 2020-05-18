Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA2C1D8745
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgERRiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:32976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728593AbgERRip (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:38:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 767C32083E;
        Mon, 18 May 2020 17:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823523;
        bh=p+3vPL+0qtuTQ2LxEjBpZrxASsS9fz7TYcDzNo/6KiI=;
        h=From:To:Cc:Subject:Date:From;
        b=XgYIV5dDqzjiSIrvqLFYfg0npVnlGenjSBIuJlNyZ3FD/b/4hbxloThCil4bdVAdb
         30H5BMnI0rHl03ktFCKSFeimJmfc+ABA5brdGKQHJOeR84Xsh4Akl+oDYUEKyJj6pC
         QnCSVB66BmhV4+tQ0xWNYHl899oGP2+dbdp/h+/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/86] 4.4.224-rc1 review
Date:   Mon, 18 May 2020 19:35:31 +0200
Message-Id: <20200518173450.254571947@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.224-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.224-rc1
X-KernelTest-Deadline: 2020-05-20T17:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.224 release.
There are 86 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.224-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.224-rc1

Sergei Trofimovich <slyfox@gentoo.org>
    Makefile: disallow data races on gcc-10 as well

Jim Mattson <jmattson@google.com>
    KVM: x86: Fix off-by-one error in kvm_vcpu_ioctl_x86_setup_mce

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: r8a7740: Add missing extal2 to CPG node

Kai-Heng Feng <kai.heng.feng@canonical.com>
    Revert "ALSA: hda/realtek: Fix pop noise on ALC225"

Wei Yongjun <weiyongjun1@huawei.com>
    usb: gadget: legacy: fix error return code in cdc_bind()

Wei Yongjun <weiyongjun1@huawei.com>
    usb: gadget: legacy: fix error return code in gncm_bind()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: gadget: audio: Fix a missing error return value in audio_bind()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: gadget: net2272: Fix a memory leak in an error handling path in 'net2272_plat_probe()'

Eric W. Biederman <ebiederm@xmission.com>
    exec: Move would_dump into flush_old_exec

Borislav Petkov <bp@suse.de>
    x86: Fix early boot crash on gcc-10, third try

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx27-phytec-phycard-s-rdk: Fix the I2C1 pinctrl entries

Kyungtae Kim <kt0755@gmail.com>
    USB: gadget: fix illegal array access in binding with UDC

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Initialize allocated buffers

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Fix racy buffer resize under concurrent accesses

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Limit int mic boost for Thinkpad T530

Paolo Abeni <pabeni@redhat.com>
    netlabel: cope with NULL catmap

Paolo Abeni <pabeni@redhat.com>
    net: ipv4: really enforce backoff for redirects

Cong Wang <xiyou.wangcong@gmail.com>
    net: fix a potential recursive NETDEV_FEAT_CHANGE

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: avoid shadowing standard library 'free()' in crypto

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    x86/paravirt: Remove the unused irq_enable_sysexit pv op

Keith Busch <keith.busch@intel.com>
    blk-mq: Allow blocking queue tag iter callbacks

Jianchao Wang <jianchao.w.wang@oracle.com>
    blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter

Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
    blk-mq: Allow timeouts to run while queue is freezing

Christoph Hellwig <hch@lst.de>
    block: defer timeouts to a workqueue

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: disable 'restrict' warning for now

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: disable 'stringop-overflow' warning for now

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: disable 'array-bounds' warning for now

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: disable 'zero-length-bounds' warning for now

Linus Torvalds <torvalds@linux-foundation.org>
    Stop the ad-hoc games with -Wno-maybe-initialized

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: compute false-positive -Wmaybe-uninitialized cases in Kconfig

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10 warnings: fix low-hanging fruit

Jason Gunthorpe <jgg@mellanox.com>
    pnp: Use list_for_each_entry() instead of open coding

Jack Morgenstein <jackm@dev.mellanox.co.il>
    IB/mlx4: Test return value of calls to ib_get_cached_pkey

Arnd Bergmann <arnd@arndb.de>
    netfilter: conntrack: avoid gcc-10 zero-length-bounds warning

Gal Pressman <galp@mellanox.com>
    net/mlx5: Fix driver load error flow when firmware is stuck

Anjali Singhai Jain <anjali.singhai@intel.com>
    i40e: avoid NVM acquire deadlock during NVM update

Ben Hutchings <ben.hutchings@codethink.co.uk>
    scsi: qla2xxx: Avoid double completion of abort command

zhong jiang <zhongjiang@huawei.com>
    mm/memory_hotplug.c: fix overflow in test_pages_in_a_zone()

Jiri Benc <jbenc@redhat.com>
    gre: do not keep the GRE header around in collect medata mode

John Hurley <john.hurley@netronome.com>
    net: openvswitch: fix csum updates for MPLS actions

Vasily Averin <vvs@virtuozzo.com>
    ipc/util.c: sysvipc_find_ipc() incorrectly updates position index

Vasily Averin <vvs@virtuozzo.com>
    drm/qxl: lost qxl_bo_kunmap_atomic_page in qxl_image_init_helper()

Lubomir Rintel <lkundrak@v3.sk>
    dmaengine: mmp_tdma: Reset channel error on release

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    dmaengine: pch_dma.c: Avoid data race between probe and irq handler

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: Fix a race condition with cifs_echo_request

Samuel Cabrero <scabrero@suse.de>
    cifs: Check for timeout on Negotiate stage

wuxu.wu <wuxu.wu@huawei.com>
    spi: spi-dw: Add lock protect dw_spi rx/tx to prevent concurrent calls

Wu Bo <wubo40@huawei.com>
    scsi: sg: add sg_remove_request in sg_write

Arnd Bergmann <arnd@arndb.de>
    drop_monitor: work around gcc-10 stringop-overflow warning

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: moxa: Fix a potential double 'free_irq()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net/sonic: Fix a resource leak in an error handling path in 'jazz_sonic_probe()'

David Ahern <dsa@cumulusnetworks.com>
    net: handle no dst on skb in icmp6_send

Vladis Dronov <vdronov@redhat.com>
    ptp: free ptp device pin descriptors properly

Vladis Dronov <vdronov@redhat.com>
    ptp: fix the race between the release of ptp_clock and cdev

YueHaibing <yuehaibing@huawei.com>
    ptp: Fix pass zero to ERR_PTR() in ptp_clock_register

Logan Gunthorpe <logang@deltatee.com>
    chardev: add helper function to register char devs with a struct device

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    ptp: create "pins" together with the rest of attributes

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    ptp: use is_visible method to hide unused attributes

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    ptp: do not explicitly set drvdata in ptp_clock_register()

Cengiz Can <cengiz@kernel.wtf>
    blktrace: fix dereference after null check

Jan Kara <jack@suse.cz>
    blktrace: Protect q->blk_trace with RCU

Jens Axboe <axboe@kernel.dk>
    blktrace: fix trace mutex deadlock

Jens Axboe <axboe@kernel.dk>
    blktrace: fix unlocked access to init/start-stop/teardown

Waiman Long <longman@redhat.com>
    blktrace: Fix potential deadlock between delete & sysfs ops

Sabrina Dubroca <sd@queasysnail.net>
    net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup

Sabrina Dubroca <sd@queasysnail.net>
    net: ipv6: add net argument to ip6_dst_lookup_flow

Shijie Luo <luoshijie1@huawei.com>
    ext4: add cond_resched() to ext4_protect_reserved_inode

Kees Cook <keescook@chromium.org>
    binfmt_elf: Do not move brk for INTERP-less ET_EXEC

Alexandre Belloni <alexandre.belloni@free-electrons.com>
    phy: micrel: Ensure interrupts are reenabled on resume

Alexandre Belloni <alexandre.belloni@free-electrons.com>
    phy: micrel: Disable auto negotiation on startup

Ivan Delalande <colona@arista.com>
    scripts/decodecode: fix trapping instruction formatting

George Spelvin <lkml@sdf.org>
    batman-adv: fix batadv_nc_random_weight_tq

Oliver Neukum <oneukum@suse.com>
    USB: serial: garmin_gps: add sanity checking for data length

Oliver Neukum <oneukum@suse.com>
    USB: uas: add quirk for LaCie 2Big Quadra

Alex Estrin <alex.estrin@intel.com>
    Revert "IB/ipoib: Update broadcast object if PKey value was changed in index 0"

Ville Syrjälä <ville.syrjala@linux.intel.com>
    x86/apm: Don't access __preempt_count with zeroed fs

Kees Cook <keescook@chromium.org>
    binfmt_elf: move brk out of mmap when doing direct loader exec

Sabrina Dubroca <sd@queasysnail.net>
    ipv6: fix cleanup ordering for ip6_mr failure

Govindarajulu Varadarajan <gvaradar@cisco.com>
    enic: do not overwrite error code

Hans de Goede <hdegoede@redhat.com>
    Revert "ACPI / video: Add force_native quirk for HP Pavilion dv6"

Eric Dumazet <edumazet@google.com>
    sch_choke: avoid potential panic in choke_reset()

Eric Dumazet <edumazet@google.com>
    sch_sfq: validate silly quantum values

Tariq Toukan <tariqt@mellanox.com>
    net/mlx4_core: Fix use of ENOSPC around mlx4_counter_alloc()

Julia Lawall <Julia.Lawall@inria.fr>
    dp83640: reverse arguments to list_add_tail

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net: phy: Avoid polling PHY with PHY_IGNORE_INTERRUPTS"

Matt Jolly <Kangie@footclan.ninja>
    USB: serial: qcserial: Add DW5816e support


-------------

Diffstat:

 Makefile                                         |  17 +-
 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts |   4 +-
 arch/arm/boot/dts/r8a7740.dtsi                   |   2 +-
 arch/x86/entry/entry_32.S                        |   8 +-
 arch/x86/include/asm/apm.h                       |   6 -
 arch/x86/include/asm/paravirt.h                  |   7 -
 arch/x86/include/asm/paravirt_types.h            |   9 --
 arch/x86/include/asm/stackprotector.h            |   7 +-
 arch/x86/kernel/apm_32.c                         |   5 +
 arch/x86/kernel/asm-offsets.c                    |   3 -
 arch/x86/kernel/paravirt.c                       |   7 -
 arch/x86/kernel/paravirt_patch_32.c              |   2 -
 arch/x86/kernel/paravirt_patch_64.c              |   1 -
 arch/x86/kernel/smpboot.c                        |   8 +
 arch/x86/kvm/x86.c                               |   2 +-
 arch/x86/xen/enlighten.c                         |   3 -
 arch/x86/xen/smp.c                               |   1 +
 arch/x86/xen/xen-asm_32.S                        |  14 --
 arch/x86/xen/xen-ops.h                           |   3 -
 block/blk-core.c                                 |   3 +
 block/blk-mq-tag.c                               |   7 +-
 block/blk-mq.c                                   |  17 ++
 block/blk-timeout.c                              |   3 +
 crypto/lrw.c                                     |   4 +-
 crypto/xts.c                                     |   4 +-
 drivers/acpi/video_detect.c                      |  11 --
 drivers/dma/mmp_tdma.c                           |   2 +
 drivers/dma/pch_dma.c                            |   2 +-
 drivers/gpu/drm/qxl/qxl_image.c                  |   3 +-
 drivers/infiniband/core/addr.c                   |   6 +-
 drivers/infiniband/hw/mlx4/qp.c                  |  14 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c          |  13 --
 drivers/net/ethernet/cisco/enic/enic_main.c      |   9 +-
 drivers/net/ethernet/intel/i40e/i40e_nvm.c       |  98 +++++++-----
 drivers/net/ethernet/intel/i40e/i40e_prototype.h |   2 -
 drivers/net/ethernet/mellanox/mlx4/main.c        |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c   |   2 +-
 drivers/net/ethernet/moxa/moxart_ether.c         |   2 +-
 drivers/net/ethernet/natsemi/jazzsonic.c         |   6 +-
 drivers/net/geneve.c                             |   4 +-
 drivers/net/phy/dp83640.c                        |   2 +-
 drivers/net/phy/micrel.c                         |  28 +++-
 drivers/net/phy/phy.c                            |  15 +-
 drivers/net/vxlan.c                              |  10 +-
 drivers/ptp/ptp_clock.c                          |  42 ++---
 drivers/ptp/ptp_private.h                        |   9 +-
 drivers/ptp/ptp_sysfs.c                          | 162 ++++++++-----------
 drivers/scsi/qla2xxx/qla_init.c                  |   4 +-
 drivers/scsi/sg.c                                |   4 +-
 drivers/spi/spi-dw.c                             |  15 +-
 drivers/spi/spi-dw.h                             |   1 +
 drivers/usb/gadget/configfs.c                    |   3 +
 drivers/usb/gadget/legacy/audio.c                |   4 +-
 drivers/usb/gadget/legacy/cdc2.c                 |   4 +-
 drivers/usb/gadget/legacy/ncm.c                  |   4 +-
 drivers/usb/gadget/udc/net2272.c                 |   2 +
 drivers/usb/serial/garmin_gps.c                  |   4 +-
 drivers/usb/serial/qcserial.c                    |   1 +
 drivers/usb/storage/unusual_uas.h                |   7 +
 fs/binfmt_elf.c                                  |  12 ++
 fs/char_dev.c                                    |  86 ++++++++++
 fs/cifs/cifssmb.c                                |  12 ++
 fs/cifs/connect.c                                |  11 +-
 fs/cifs/smb2pdu.c                                |  12 ++
 fs/exec.c                                        |   4 +-
 fs/ext4/block_validity.c                         |   1 +
 include/linux/blkdev.h                           |   3 +-
 include/linux/blktrace_api.h                     |   6 +-
 include/linux/cdev.h                             |   5 +
 include/linux/compiler.h                         |   7 +
 include/linux/fs.h                               |   2 +-
 include/linux/pnp.h                              |  29 ++--
 include/linux/posix-clock.h                      |  19 ++-
 include/linux/tty.h                              |   2 +-
 include/net/addrconf.h                           |   6 +-
 include/net/ipv6.h                               |   2 +-
 include/net/netfilter/nf_conntrack.h             |   2 +-
 include/sound/rawmidi.h                          |   1 +
 init/main.c                                      |   2 +
 ipc/util.c                                       |  12 +-
 kernel/time/posix-clock.c                        |  31 ++--
 kernel/trace/blktrace.c                          | 191 +++++++++++++++++------
 mm/memory_hotplug.c                              |   4 +-
 net/batman-adv/network-coding.c                  |   9 +-
 net/core/dev.c                                   |   4 +-
 net/core/drop_monitor.c                          |  11 +-
 net/dccp/ipv6.c                                  |   6 +-
 net/ipv4/cipso_ipv4.c                            |   6 +-
 net/ipv4/ip_gre.c                                |   7 +-
 net/ipv4/route.c                                 |   2 +-
 net/ipv6/addrconf_core.c                         |  11 +-
 net/ipv6/af_inet6.c                              |  10 +-
 net/ipv6/datagram.c                              |   2 +-
 net/ipv6/icmp.c                                  |   6 +-
 net/ipv6/inet6_connection_sock.c                 |   4 +-
 net/ipv6/ip6_output.c                            |   8 +-
 net/ipv6/raw.c                                   |   2 +-
 net/ipv6/syncookies.c                            |   2 +-
 net/ipv6/tcp_ipv6.c                              |   4 +-
 net/l2tp/l2tp_ip6.c                              |   2 +-
 net/mpls/af_mpls.c                               |   7 +-
 net/netfilter/nf_conntrack_core.c                |   4 +-
 net/netlabel/netlabel_kapi.c                     |   6 +
 net/openvswitch/actions.c                        |   6 +-
 net/sched/sch_choke.c                            |   3 +-
 net/sched/sch_sfq.c                              |   9 ++
 net/sctp/ipv6.c                                  |   4 +-
 net/tipc/udp_media.c                             |   9 +-
 scripts/decodecode                               |   2 +-
 sound/core/rawmidi.c                             |  35 ++++-
 sound/pci/hda/patch_realtek.c                    |  12 +-
 111 files changed, 805 insertions(+), 496 deletions(-)


