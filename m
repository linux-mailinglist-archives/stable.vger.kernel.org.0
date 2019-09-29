Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B434C14B7
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 15:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbfI2N5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:57:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729240AbfI2N53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:57:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB90F2082F;
        Sun, 29 Sep 2019 13:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765448;
        bh=2Cw2fhE44KlzeRytG9i9qkcR/41WQmI86RX1Tnn1Jfg=;
        h=From:To:Cc:Subject:Date:From;
        b=HswGa+wCkqOD8p8si4k07eQRah2XvLoRFRkqumy7jVsh79Qm6PucioweA/fpTm2h3
         /wnJuD3p8Ss8kML1JBxQHSg0DkwpKX0isFR5+y6CHVL3RQOzfIPjVDkRZipS/BG+cU
         palIpn/F+Zye94FSeUI8zcUMUjxi6lgYhssOw720=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/63] 4.19.76-stable review
Date:   Sun, 29 Sep 2019 15:53:33 +0200
Message-Id: <20190929135031.382429403@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.76-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.76-rc1
X-KernelTest-Deadline: 2019-10-01T13:50+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.76 release.
There are 63 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue 01 Oct 2019 01:47:47 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.76-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.76-rc1

Ka-Cheong Poon <ka-cheong.poon@oracle.com>
    net/rds: An rds_sock is added too early to the hash table

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: check cops->tcf_block in tc_bind_tclass()

Jian-Hong Pan <jian-hong@endlessm.com>
    Bluetooth: btrtl: Additional Realtek 8822CE Bluetooth devices

Fernando Fernandez Mancera <ffmancera@riseup.net>
    netfilter: nft_socket: fix erroneous socket assignment

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: don't crash on null attr fork xfs_bmapi_read

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nouveau/disp/nv50-: fix center/aspect-corrected scaling

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add new hw_changes_brightness quirk, set it on PB Easynote MZ35

Jian-Hong Pan <jian-hong@endlessm.com>
    Bluetooth: btrtl: HCI reset on close for Realtek BT chip

Stephen Hemminger <stephen@networkplumber.org>
    net: don't warn in inet diag when IPV6 is disabled

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Flush output polling on shutdown

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to do sanity check on segment bitmap of LFS curseg

Michal Suchanek <msuchanek@suse.de>
    net/ibmvnic: Fix missing { in __ibmvnic_reset

Mikulas Patocka <mpatocka@redhat.com>
    dm zoned: fix invalid memory access

Chao Yu <yuchao0@huawei.com>
    Revert "f2fs: avoid out-of-range memory access"

zhengbin <zhengbin13@huawei.com>
    blk-mq: move cancel of requeue_work to the front of blk_exit_queue

Jianchao Wang <jianchao.w.wang@oracle.com>
    blk-mq: change gfp flags to GFP_NOIO in blk_mq_realloc_hw_ctxs

Steven Price <steven.price@arm.com>
    initramfs: don't free a non-existent initrd

Coly Li <colyli@suse.de>
    bcache: remove redundant LIST_HEAD(journal) from run_cache_set()

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Avoid use of hv_pci_dev->pci_slot after freeing it

Surbhi Palande <f2fsnewbie@gmail.com>
    f2fs: check all the data segments against all node ones

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3-its: Fix LPI release for Multi-MSI devices

Lorenz Bauer <lmb@cloudflare.com>
    bpf: libbpf: retry loading program on EAGAIN

Shirish S <shirish.s@amd.com>
    Revert "drm/amd/powerplay: Enable/Disable NBPSTATE on On/OFF of UVD"

Himanshu Madhani <himanshu.madhani@cavium.com>
    scsi: qla2xxx: Return switch command on a timeout

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Remove all rports if fabric scan retry fails

Quinn Tran <quinn.tran@cavium.com>
    scsi: qla2xxx: Turn off IOCB timeout timer on IOCB completion

Waiman Long <longman@redhat.com>
    locking/lockdep: Add debug_locks check in __lock_downgrade() - again

Waiman Long <longman@redhat.com>
    locking/lockdep: Add debug_locks check in __lock_downgrade()

David Lechner <david@lechnology.com>
    power: supply: sysfs: ratelimit property read error message

Nathan Chancellor <natechancellor@gmail.com>
    pinctrl: sprd: Use define directive for sprd_pinconf_params values

Vadim Sukhomlinov <sukhomlinov@google.com>
    tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM operations

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Clobber user CFLAGS variable

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Apply AMD controller workaround for Raven platform

Shih-Yuan Lee (FourDollars) <fourdollars@debian.org>
    ALSA: hda - Add laptop imic fixup for ASUS M9V laptop

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: dice: fix wrong packet parameter for Alesis iO26

Jussi Laako <jussi@sonarnerd.net>
    ALSA: usb-audio: Add DSD support for EVGA NU Audio

Ilya Pshonkin <sudokamikaze@protonmail.com>
    ALSA: usb-audio: Add Hiby device family to quirks for native DSD support

Takashi Iwai <tiwai@suse.de>
    ASoC: fsl: Fix of-node refcount unbalance in fsl_ssi_probe_from_dt()

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: cht_bsw_max98090_ti: Enable codec clock once and keep it enabled

Marco Felsch <m.felsch@pengutronix.de>
    media: tvp5150: fix switch exit in set control handler

Naftali Goldstein <naftali.goldstein@intel.com>
    iwlwifi: mvm: always init rs_fw with 20MHz bandwidth rates

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: send BCAST management frames to the right station

Saeed Mahameed <saeedm@mellanox.com>
    net/mlx5e: Rx, Check ip headers sanity

Saeed Mahameed <saeedm@mellanox.com>
    net/mlx5e: Rx, Fixup skb checksum for packets with tail padding

Saeed Mahameed <saeedm@mellanox.com>
    net/mlx5e: XDP, Avoid checksum complete when XDP prog is loaded

Or Gerlitz <ogerlitz@mellanox.com>
    net/mlx5e: Allow reporting of checksum unnecessary

Cong Wang <xiyou.wangcong@gmail.com>
    mlx5: fix get_ip_proto()

Alaa Hleihel <alaa@mellanox.com>
    net/mlx5e: don't set CHECKSUM_COMPLETE on SCTP packets

Natali Shechtman <natali@mellanox.com>
    net/mlx5e: Set ECN for received packets using CQE indication

Aurelien Aptel <aaptel@suse.com>
    CIFS: fix deadlock in cached root handling

Gustavo A. R. Silva <gustavo@embeddedor.com>
    crypto: talitos - fix missing break in switch statement

Tokunori Ikegami <ikegami.t@gmail.com>
    mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()

Sebastian Parschauer <s.parschauer@gmx.de>
    HID: Add quirk for HP X500 PIXART OEM mouse

Alan Stern <stern@rowland.harvard.edu>
    HID: hidraw: Fix invalid read in hidraw_ioctl

Alan Stern <stern@rowland.harvard.edu>
    HID: logitech: Fix general protection fault caused by Logitech driver

Roderick Colenbrander <roderick.colenbrander@sony.com>
    HID: sony: Fix memory corruption issue on cleanup.

Alan Stern <stern@rowland.harvard.edu>
    HID: prodikeys: Fix general protection fault during probe

Jack Morgenstein <jackm@dev.mellanox.co.il>
    IB/core: Add an unbound WQ type to the new CQ API

Nick Desaulniers <ndesaulniers@google.com>
    drm/amd/display: readd -msse2 to prevent Clang from emitting libcalls to undefined SW FP routines

Greg Kurz <groug@kaod.org>
    powerpc/xive: Fix bogus error code returned by OPAL

Leon Romanovsky <leon@kernel.org>
    RDMA/restrack: Protect from reentry to resource return path

Juliet Kim <julietk@linux.vnet.ibm.com>
    net/ibmvnic: free reset work of removed device from queue

Marcel Holtmann <marcel@holtmann.org>
    Revert "Bluetooth: validate BLE connection interval updates"


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/powerpc/include/asm/opal.h                    |   2 +-
 arch/powerpc/platforms/powernv/opal-wrappers.S     |   2 +-
 arch/powerpc/sysdev/xive/native.c                  |  11 ++
 block/blk-core.c                                   |   2 +-
 block/blk-flush.c                                  |   6 +-
 block/blk-mq.c                                     |  19 +--
 block/blk-sysfs.c                                  |   3 +
 block/blk.h                                        |   2 +-
 drivers/acpi/acpi_video.c                          |  37 ++++++
 drivers/bluetooth/btrtl.c                          |  20 +++
 drivers/bluetooth/btrtl.h                          |   6 +
 drivers/bluetooth/btusb.c                          |   4 +
 drivers/char/tpm/tpm-chip.c                        |   3 +
 drivers/crypto/talitos.c                           |   1 +
 drivers/gpu/drm/amd/display/dc/calcs/Makefile      |   4 +
 drivers/gpu/drm/amd/display/dc/dml/Makefile        |   4 +
 drivers/gpu/drm/amd/powerplay/hwmgr/smu8_hwmgr.c   |   5 +-
 drivers/gpu/drm/drm_probe_helper.c                 |   9 +-
 drivers/gpu/drm/nouveau/dispnv50/head.c            |  28 ++++-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-lg.c                               |  10 +-
 drivers/hid/hid-lg4ff.c                            |   1 -
 drivers/hid/hid-prodikeys.c                        |  12 +-
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/hid-sony.c                             |   2 +-
 drivers/hid/hidraw.c                               |   2 +-
 drivers/infiniband/core/cq.c                       |   8 +-
 drivers/infiniband/core/device.c                   |  15 ++-
 drivers/infiniband/core/mad.c                      |   2 +-
 drivers/infiniband/core/restrack.c                 |   4 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   9 +-
 drivers/md/bcache/super.c                          |   1 -
 drivers/md/dm-zoned-target.c                       |   2 -
 drivers/media/i2c/tvp5150.c                        |   2 +-
 drivers/mtd/chips/cfi_cmdset_0002.c                |  18 ++-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   3 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  28 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   8 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 126 ++++++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   9 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   6 +
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   2 +-
 drivers/pci/controller/pci-hyperv.c                |   2 +-
 drivers/pinctrl/sprd/pinctrl-sprd.c                |   6 +-
 drivers/power/supply/power_supply_sysfs.c          |   3 +-
 drivers/scsi/qla2xxx/qla_gs.c                      | 134 +++++++++++----------
 drivers/scsi/qla2xxx/qla_init.c                    |  11 +-
 fs/cifs/smb2ops.c                                  |  44 +++++++
 fs/f2fs/segment.c                                  |  44 ++++++-
 fs/f2fs/super.c                                    |   4 +-
 fs/xfs/libxfs/xfs_bmap.c                           |  29 +++--
 include/rdma/ib_verbs.h                            |   9 +-
 init/initramfs.c                                   |   2 +-
 kernel/locking/lockdep.c                           |   6 +
 net/bluetooth/hci_event.c                          |   5 -
 net/bluetooth/l2cap_core.c                         |   9 +-
 net/ipv4/raw_diag.c                                |   3 -
 net/netfilter/nft_socket.c                         |   6 +-
 net/rds/bind.c                                     |  40 +++---
 net/sched/sch_api.c                                |   2 +
 sound/firewire/dice/dice-alesis.c                  |   2 +-
 sound/pci/hda/hda_intel.c                          |   3 +-
 sound/pci/hda/patch_analog.c                       |   1 +
 sound/soc/fsl/fsl_ssi.c                            |   6 +-
 sound/soc/intel/boards/cht_bsw_max98090_ti.c       |  47 +++++++-
 sound/usb/quirks.c                                 |   2 +
 tools/lib/bpf/bpf.c                                |  17 ++-
 tools/objtool/Makefile                             |   2 +-
 73 files changed, 669 insertions(+), 232 deletions(-)


