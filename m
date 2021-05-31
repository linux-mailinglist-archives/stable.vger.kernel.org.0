Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E82B395B30
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhEaNSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231574AbhEaNSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:18:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38C1061287;
        Mon, 31 May 2021 13:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622466989;
        bh=Lay/VwuRWIiBRZ/dkfnp699OP23MzSP+o4kbtWt8wyo=;
        h=From:To:Cc:Subject:Date:From;
        b=IxC+mfhAqSdeijoOr12ImksdVF4z1/PcbtlPgkyU7WiTurjPXE8WoiD6ARPxUhzQo
         0pBWHA1+Qh5gE5Zz3k9/vAMg0uNKQ40VHISR/FPw+lq0TLhQ1CKSqgDjEjyYauoHxz
         NTTYvSkzWGlOOTqk+p7RR+Tl2CrTJEgmVo7Q90KM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/54] 4.4.271-rc1 review
Date:   Mon, 31 May 2021 15:13:26 +0200
Message-Id: <20210531130635.070310929@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.271-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.271-rc1
X-KernelTest-Deadline: 2021-06-02T13:06+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.271 release.
There are 54 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.271-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.271-rc1

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: core: reduce power-on-good delay time of root hub

Lin Ma <linma@zju.edu.cn>
    bluetooth: eliminate the potential race condition when removing the HCI controller

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlbfs: hugetlb_fault_mutex_hash() cleanup

Randy Dunlap <rdunlap@infradead.org>
    MIPS: ralink: export rt_sysc_membase for rt2880_wdt.c

Randy Dunlap <rdunlap@infradead.org>
    MIPS: alchemy: xxs1500: add gpio-au1000.h header file

Taehee Yoo <ap420073@gmail.com>
    sch_dsmark: fix a NULL deref in qdisc_reset()

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: libsas: Use _safe() loop in sas_resume_port()

Dan Carpenter <dan.carpenter@oracle.com>
    staging: emxx_udc: fix loop in _nbu2ss_nuke()

Taehee Yoo <ap420073@gmail.com>
    mld: fix panic in mld_newpack()

Zhen Lei <thunder.leizhen@huawei.com>
    net: bnx2: Fix error return code in bnx2_init_board()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: netcp: Fix an error message

xinhui pan <xinhui.pan@amd.com>
    drm/amdgpu: Fix a use-after-free

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not BUG_ON in link_to_fixup_dir

Peter Zijlstra <peterz@infradead.org>
    openrisc: Define memory barrier mb

Matt Wang <wwentao@vmware.com>
    scsi: BusLogic: Fix 64-bit system enumeration error for Buslogic

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    media: gspca: properly check for errors in po1030_probe()

Alaa Emad <alaaemadhossney.ae@gmail.com>
    media: dvb: Add check on sp8870_readreg return

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    libertas: register sysfs groups properly

Phillip Potter <phil@philpotter.co.uk>
    isdn: mISDNinfineon: check/cleanup ioremap failure correctly in setup_io

Atul Gopinathan <atulgopinathan@gmail.com>
    ALSA: sb8: Add a comment note regarding an unused pointer

Tom Seewald <tseewald@gmail.com>
    char: hpet: add checks after calling ioremap

Du Cheng <ducheng2@gmail.com>
    net: caif: remove BUG_ON(dev == NULL) in caif_xmit

Anirudh Rayabharam <mail@anirudhrb.com>
    net: fujitsu: fix potential null-ptr-deref

Kai-Heng Feng <kai.heng.feng@canonical.com>
    platform/x86: hp_accel: Avoid invoking _INI to speed up resume

Jean Delvare <jdelvare@suse.de>
    i2c: i801: Don't generate an interrupt on bus reset

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    i2c: s3c2410: fix possible NULL pointer deref on read message after write

Xin Long <lucien.xin@gmail.com>
    tipc: skb_linearize the head skb when reassembling msgs

Hoang Le <hoang.h.le@dektech.com.au>
    Revert "net:tipc: Fix a double free in tipc_sk_mcast_rcv"

Vladyslav Tarasiuk <vladyslavt@nvidia.com>
    net/mlx4: Fix EEPROM dump support

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    NFSv4: Fix v4.0/v4.1 SEEK_DATA return -ENOTSUPP when set NFS_V4_2 config

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't corrupt the value of pg_bytes_written in nfs_do_recoalesce()

Dan Carpenter <dan.carpenter@oracle.com>
    NFS: fix an incorrect limit in filelayout_decode_layout()

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    Bluetooth: cmtp: fix file refcount when cmtp_attach_device fails

Lukas Wunner <lukas@wunner.de>
    spi: spi-sh: Fix use-after-free on unbind

William A. Kennington III <wak@google.com>
    spi: Fix use-after-free with devm_spi_alloc_*

Pavel Skripkin <paskripkin@gmail.com>
    net: usb: fix memory leak in smsc75xx_bind

Zolton Jheng <s6668c2t@gmail.com>
    USB: serial: pl2303: add device id for ADLINK ND-6530 GC

Dominik Andreas Schorpp <dominik.a.schorpp@ids.de>
    USB: serial: ftdi_sio: add IDs for IDS GmbH Products

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit LE910-S1 compositions 0x7010, 0x7011

Zheyu Ma <zheyuma97@gmail.com>
    serial: rp2: use 'request_firmware' instead of 'request_firmware_nowait'

Johan Hovold <johan@kernel.org>
    USB: trancevibrator: fix control-request direction

YueHaibing <yuehaibing@huawei.com>
    iio: adc: ad7793: Add missing error code in ad7793_setup()

Lucas Stankus <lucas.p.stankus@gmail.com>
    staging: iio: cdc: ad7746: avoid overwrite of num_channels

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: request autosuspend after sending rx flow control

Dongliang Mu <mudongliangabcd@gmail.com>
    misc/uss720: fix memory leak in uss720_probe

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kgdb: fix gcc-11 warnings harder

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: properly fix a crash when an origin has no snapshots

Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
    mac80211: prevent mixed key and fragment cache attacks

Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
    mac80211: assure all fragments are encrypted

Johan Hovold <johan@kernel.org>
    net: hso: fix control-request directions

Kees Cook <keescook@chromium.org>
    proc: Check /proc/$pid/attr/ writes against file opener

Dongliang Mu <mudongliangabcd@gmail.com>
    NFC: nci: fix memory leak in nci_allocate_device

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    netfilter: x_tables: Use correct memory barriers.

Stephen Brennan <stephen.s.brennan@oracle.com>
    mm, vmstat: drop zone->lock in /proc/pagetypeinfo


-------------

Diffstat:

 Makefile                                        |   4 +-
 arch/mips/alchemy/board-xxs1500.c               |   1 +
 arch/mips/ralink/of.c                           |   2 +
 arch/openrisc/include/asm/barrier.h             |   9 ++
 drivers/char/hpet.c                             |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c         |   1 +
 drivers/i2c/busses/i2c-i801.c                   |   6 +-
 drivers/i2c/busses/i2c-s3c2410.c                |   4 +-
 drivers/iio/adc/ad7793.c                        |   1 +
 drivers/isdn/hardware/mISDN/mISDNinfineon.c     |  24 ++++--
 drivers/md/dm-snap.c                            |   2 +-
 drivers/media/dvb-frontends/sp8870.c            |   4 +-
 drivers/media/usb/gspca/m5602/m5602_po1030.c    |  10 ++-
 drivers/misc/kgdbts.c                           |   3 +-
 drivers/misc/lis3lv02d/lis3lv02d.h              |   1 +
 drivers/misc/mei/interrupt.c                    |   3 +
 drivers/net/caif/caif_serial.c                  |   1 -
 drivers/net/ethernet/broadcom/bnx2.c            |   2 +-
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c       |   5 ++
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c |   4 +-
 drivers/net/ethernet/mellanox/mlx4/port.c       | 107 +++++++++++++++++++++++-
 drivers/net/ethernet/ti/netcp_core.c            |   4 +-
 drivers/net/usb/hso.c                           |   4 +-
 drivers/net/usb/smsc75xx.c                      |   8 +-
 drivers/net/wireless/libertas/mesh.c            |  28 +------
 drivers/platform/x86/hp_accel.c                 |  22 ++++-
 drivers/scsi/BusLogic.c                         |   6 +-
 drivers/scsi/BusLogic.h                         |   2 +-
 drivers/scsi/libsas/sas_port.c                  |   4 +-
 drivers/spi/spi-sh.c                            |  14 +---
 drivers/spi/spi.c                               |   9 +-
 drivers/staging/emxx_udc/emxx_udc.c             |   4 +-
 drivers/staging/iio/cdc/ad7746.c                |   1 -
 drivers/tty/serial/rp2.c                        |  52 ++++--------
 drivers/usb/core/hub.h                          |   6 +-
 drivers/usb/misc/trancevibrator.c               |   4 +-
 drivers/usb/misc/uss720.c                       |   1 +
 drivers/usb/serial/ftdi_sio.c                   |   3 +
 drivers/usb/serial/ftdi_sio_ids.h               |   7 ++
 drivers/usb/serial/option.c                     |   4 +
 drivers/usb/serial/pl2303.c                     |   1 +
 drivers/usb/serial/pl2303.h                     |   1 +
 fs/btrfs/tree-log.c                             |   2 -
 fs/hugetlbfs/inode.c                            |   4 +-
 fs/nfs/filelayout/filelayout.c                  |   2 +-
 fs/nfs/nfs4file.c                               |   2 +-
 fs/nfs/pagelist.c                               |  12 ++-
 fs/proc/base.c                                  |   4 +
 include/linux/hugetlb.h                         |   2 +-
 include/linux/netfilter/x_tables.h              |   2 +-
 include/linux/spi/spi.h                         |   3 +
 include/net/nfc/nci_core.h                      |   1 +
 mm/hugetlb.c                                    |   8 +-
 mm/vmstat.c                                     |   3 +
 net/bluetooth/cmtp/core.c                       |   5 ++
 net/bluetooth/hci_core.c                        |  13 ++-
 net/ipv6/mcast.c                                |   3 -
 net/mac80211/ieee80211_i.h                      |   1 +
 net/mac80211/key.c                              |   7 ++
 net/mac80211/key.h                              |   2 +
 net/mac80211/rx.c                               |  29 ++++---
 net/netfilter/x_tables.c                        |   3 +
 net/nfc/nci/core.c                              |   1 +
 net/nfc/nci/hci.c                               |   5 ++
 net/sched/sch_dsmark.c                          |   3 +-
 net/tipc/msg.c                                  |   9 +-
 net/tipc/socket.c                               |   5 +-
 sound/isa/sb/sb8.c                              |   6 +-
 68 files changed, 347 insertions(+), 173 deletions(-)


