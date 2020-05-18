Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04511D86DA
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729492AbgERRm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:42:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728641AbgERRmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:42:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1719D20715;
        Mon, 18 May 2020 17:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823773;
        bh=QNHuWB1mpdl1/0puHEBbsFRgh7Ox95aJW9DwA7r8U2g=;
        h=From:To:Cc:Subject:Date:From;
        b=FBV0mKXAB5UCcW1PQvVvQwz1OX3MkNjirE9fMH5/jAkiuMQHNaX2yXQbsiod4wYD9
         vY0pWNfbOkO8oCgryaPu8kn6jQrvOhNcTdN7ov7O3cB54eZs4ZwIdZT0UJuFjYFhEN
         3bvCX2OFr1JMfgE3q7KgM05PBwKeO6Smx7VXmrTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/90] 4.9.224-rc1 review
Date:   Mon, 18 May 2020 19:35:38 +0200
Message-Id: <20200518173450.930655662@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.224-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.224-rc1
X-KernelTest-Deadline: 2020-05-20T17:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.224 release.
There are 90 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.224-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.224-rc1

Sergei Trofimovich <slyfox@gentoo.org>
    Makefile: disallow data races on gcc-10 as well

Jim Mattson <jmattson@google.com>
    KVM: x86: Fix off-by-one error in kvm_vcpu_ioctl_x86_setup_mce

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: r8a7740: Add missing extal2 to CPG node

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: r8a73a4: Add missing CMT1 interrupts

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

Sriharsha Allenki <sallenki@codeaurora.org>
    usb: xhci: Fix NULL pointer dereference when enqueuing trbs from urb sg list

Kyungtae Kim <kt0755@gmail.com>
    USB: gadget: fix illegal array access in binding with UDC

Jesus Ramos <jesus-ramos@live.com>
    ALSA: usb-audio: Add control message quirk delay for Kingston HyperX headset

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Fix racy buffer resize under concurrent accesses

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Initialize allocated buffers

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Limit int mic boost for Thinkpad T530

Zefan Li <lizefan@huawei.com>
    netprio_cgroup: Fix unlimited memory leak of v2 cgroups

Paolo Abeni <pabeni@redhat.com>
    net: ipv4: really enforce backoff for redirects

Maciej Żenczykowski <maze@google.com>
    Revert "ipv6: add mtu lock check in __ip6_rt_update_pmtu"

Paolo Abeni <pabeni@redhat.com>
    netlabel: cope with NULL catmap

Cong Wang <xiyou.wangcong@gmail.com>
    net: fix a potential recursive NETDEV_FEAT_CHANGE

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: disable 'restrict' warning for now

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: disable 'stringop-overflow' warning for now

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: disable 'array-bounds' warning for now

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: disable 'zero-length-bounds' warning for now

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: avoid shadowing standard library 'free()' in crypto

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: micrel: Use strlcpy() for ethtool::get_strings

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

Dan Carpenter <dan.carpenter@oracle.com>
    i40iw: Fix error handling in i40iw_manage_arp_cache()

Grace Kao <grace.kao@intel.com>
    pinctrl: cherryview: Add missing spinlock usage in chv_gpio_irq_handler

Vasily Averin <vvs@virtuozzo.com>
    ipc/util.c: sysvipc_find_ipc() incorrectly updates position index

Vasily Averin <vvs@virtuozzo.com>
    drm/qxl: lost qxl_bo_kunmap_atomic_page in qxl_image_init_helper()

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: fix race in monitor detection during probe

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

Hugh Dickins <hughd@google.com>
    shmem: fix possible deadlocks on shmlock_user_lock

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

Ivan Delalande <colona@arista.com>
    scripts/decodecode: fix trapping instruction formatting

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix stack offset tracking for indirect CFAs

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    batman-adv: Fix refcnt leak in batadv_v_ogm_process

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    batman-adv: Fix refcnt leak in batadv_store_throughput_override

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    batman-adv: Fix refcnt leak in batadv_show_throughput_override

George Spelvin <lkml@sdf.org>
    batman-adv: fix batadv_nc_random_weight_tq

David Hildenbrand <david@redhat.com>
    mm/page_alloc: fix watchdog soft lockups during set_zone_contiguous()

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Add a vmalloc_sync_mappings() for safe measure

Oliver Neukum <oneukum@suse.com>
    USB: serial: garmin_gps: add sanity checking for data length

Oliver Neukum <oneukum@suse.com>
    USB: uas: add quirk for LaCie 2Big Quadra

Kees Cook <keescook@chromium.org>
    binfmt_elf: move brk out of mmap when doing direct loader exec

Hans de Goede <hdegoede@redhat.com>
    Revert "ACPI / video: Add force_native quirk for HP Pavilion dv6"

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Improve AER slot reset.

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5: Fix command entry leak in Internal Error State

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5: Fix forced completion access non initialized command entry

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix VLAN acceleration handling in bnxt_fix_features().

Eric Dumazet <edumazet@google.com>
    sch_sfq: validate silly quantum values

Eric Dumazet <edumazet@google.com>
    sch_choke: avoid potential panic in choke_reset()

Matt Jolly <Kangie@footclan.ninja>
    net: usb: qmi_wwan: add support for DW5816e

Tariq Toukan <tariqt@mellanox.com>
    net/mlx4_core: Fix use of ENOSPC around mlx4_counter_alloc()

Scott Dial <scott@scottdial.com>
    net: macsec: preserve ingress frame ordering

Eric Dumazet <edumazet@google.com>
    fq_codel: fix TCA_FQ_CODEL_DROP_BATCH_SIZE sanity checks

Julia Lawall <Julia.Lawall@inria.fr>
    dp83640: reverse arguments to list_add_tail

Matt Jolly <Kangie@footclan.ninja>
    USB: serial: qcserial: Add DW5816e support


-------------

Diffstat:

 Makefile                                         |  25 +--
 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts |   4 +-
 arch/arm/boot/dts/r8a73a4.dtsi                   |   9 +-
 arch/arm/boot/dts/r8a7740.dtsi                   |   2 +-
 arch/x86/include/asm/stackprotector.h            |   7 +-
 arch/x86/kernel/smpboot.c                        |   8 +
 arch/x86/kvm/x86.c                               |   2 +-
 arch/x86/xen/smp.c                               |   1 +
 block/blk-core.c                                 |   3 +
 crypto/lrw.c                                     |   4 +-
 crypto/xts.c                                     |   4 +-
 drivers/acpi/video_detect.c                      |  11 --
 drivers/dma/mmp_tdma.c                           |   2 +
 drivers/dma/pch_dma.c                            |   2 +-
 drivers/gpu/drm/qxl/qxl_image.c                  |   3 +-
 drivers/infiniband/core/addr.c                   |   8 +-
 drivers/infiniband/hw/i40iw/i40iw_hw.c           |   2 +-
 drivers/infiniband/hw/mlx4/qp.c                  |  14 +-
 drivers/infiniband/sw/rxe/rxe_net.c              |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c        |  18 ++-
 drivers/net/ethernet/mellanox/mlx4/main.c        |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c    |   6 +-
 drivers/net/ethernet/moxa/moxart_ether.c         |   2 +-
 drivers/net/ethernet/natsemi/jazzsonic.c         |   6 +-
 drivers/net/geneve.c                             |   4 +-
 drivers/net/macsec.c                             |   3 +-
 drivers/net/phy/dp83640.c                        |   2 +-
 drivers/net/phy/micrel.c                         |   4 +-
 drivers/net/usb/qmi_wwan.c                       |   1 +
 drivers/net/vxlan.c                              |  10 +-
 drivers/pinctrl/intel/pinctrl-cherryview.c       |   4 +
 drivers/ptp/ptp_clock.c                          |  42 ++---
 drivers/ptp/ptp_private.h                        |   9 +-
 drivers/ptp/ptp_sysfs.c                          | 162 ++++++++-----------
 drivers/scsi/sg.c                                |   4 +-
 drivers/spi/spi-dw.c                             |  15 +-
 drivers/spi/spi-dw.h                             |   1 +
 drivers/usb/gadget/configfs.c                    |   3 +
 drivers/usb/gadget/legacy/audio.c                |   4 +-
 drivers/usb/gadget/legacy/cdc2.c                 |   4 +-
 drivers/usb/gadget/legacy/ncm.c                  |   4 +-
 drivers/usb/gadget/udc/net2272.c                 |   2 +
 drivers/usb/host/xhci-ring.c                     |   4 +-
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
 include/linux/blktrace_api.h                     |  18 ++-
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
 kernel/trace/trace.c                             |  13 ++
 mm/page_alloc.c                                  |   1 +
 mm/shmem.c                                       |   7 +-
 net/batman-adv/bat_v_ogm.c                       |   2 +-
 net/batman-adv/network-coding.c                  |   9 +-
 net/batman-adv/sysfs.c                           |   3 +-
 net/core/dev.c                                   |   4 +-
 net/core/drop_monitor.c                          |  11 +-
 net/core/netprio_cgroup.c                        |   2 +
 net/dccp/ipv6.c                                  |   6 +-
 net/ipv4/cipso_ipv4.c                            |   6 +-
 net/ipv4/route.c                                 |   2 +-
 net/ipv6/addrconf_core.c                         |  11 +-
 net/ipv6/af_inet6.c                              |   4 +-
 net/ipv6/calipso.c                               |   3 +-
 net/ipv6/datagram.c                              |   2 +-
 net/ipv6/inet6_connection_sock.c                 |   4 +-
 net/ipv6/ip6_output.c                            |   8 +-
 net/ipv6/raw.c                                   |   2 +-
 net/ipv6/route.c                                 |   6 +-
 net/ipv6/syncookies.c                            |   2 +-
 net/ipv6/tcp_ipv6.c                              |   4 +-
 net/l2tp/l2tp_ip6.c                              |   2 +-
 net/mpls/af_mpls.c                               |   7 +-
 net/netfilter/nf_conntrack_core.c                |   4 +-
 net/netlabel/netlabel_kapi.c                     |   6 +
 net/sched/sch_choke.c                            |   3 +-
 net/sched/sch_fq_codel.c                         |   2 +-
 net/sched/sch_sfq.c                              |   9 ++
 net/sctp/ipv6.c                                  |   4 +-
 net/tipc/udp_media.c                             |   9 +-
 scripts/decodecode                               |   2 +-
 sound/core/rawmidi.c                             |  35 ++++-
 sound/pci/hda/patch_hdmi.c                       |   2 +
 sound/pci/hda/patch_realtek.c                    |  12 +-
 sound/usb/quirks.c                               |   9 +-
 tools/objtool/check.c                            |   2 +-
 106 files changed, 747 insertions(+), 392 deletions(-)


