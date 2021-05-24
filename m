Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13ABB38EE63
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhEXPui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234476AbhEXPrP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:47:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FF3561413;
        Mon, 24 May 2021 15:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870617;
        bh=akIz5FSbY/gH/yILLhqxJBWXdXP7pjLwVU0pCP4SxdI=;
        h=From:To:Cc:Subject:Date:From;
        b=dyXwEYBWylYj2yBkFQ/T6SuXFLqlgaRs17b8xzCRzkq0mzkpX4l4pcY9gJfONm8+I
         CmrCdICflahh3jRGhpJcIqcUOvPoWTv6ABNz9pRl3RDg4gRCKAYEg4+vB/JCbCJEEg
         uPrr/hw0m170QAERK03R5o242zDZwOcP75lR7KAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/71] 5.4.122-rc1 review
Date:   Mon, 24 May 2021 17:25:06 +0200
Message-Id: <20210524152326.447759938@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.122-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.122-rc1
X-KernelTest-Deadline: 2021-05-26T15:23+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.122 release.
There are 71 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.122-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.122-rc1

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix handling LE modes by L2CAP_OPTIONS

Eric Biggers <ebiggers@google.com>
    ext4: fix error handling in ext4_end_enable_verity()

Christoph Hellwig <hch@lst.de>
    nvme-multipath: fix double initialization of ANA state

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tty: vt: always invoke vc->vc_sw->con_resize callback

Maciej W. Rozycki <macro@orcam.me.uk>
    vt: Fix character height handling with VT_RESIZEX

Maciej W. Rozycki <macro@orcam.me.uk>
    vgacon: Record video mode changes with VT_RESIZEX

Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
    video: hgafb: fix potential NULL pointer dereference

Tom Seewald <tseewald@gmail.com>
    qlcnic: Add null check after calling netdev_alloc_skb

Phillip Potter <phil@philpotter.co.uk>
    leds: lp5523: check return value of lp5xx_read and jump to cleanup code

Darrick J. Wong <djwong@kernel.org>
    ics932s401: fix broken handling of errors when word reading fails

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: rtlwifi: properly check for alloc_workqueue() failure

Phillip Potter <phil@philpotter.co.uk>
    scsi: ufs: handle cleanup correctly on devm_reset_control_get error

Anirudh Rayabharam <mail@anirudhrb.com>
    net: stmicro: handle clk_prepare() failure during init

Du Cheng <ducheng2@gmail.com>
    ethernet: sun: niu: fix missing checks of niu_pci_eeprom_read()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "niu: fix missing checks of niu_pci_eeprom_read"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "qlcnic: Avoid potential NULL pointer dereference"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "rtlwifi: fix a potential NULL pointer dereference"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "media: rcar_drif: fix a memory disclosure"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    cdrom: gdrom: initialize global variable at init time

Atul Gopinathan <atulgopinathan@gmail.com>
    cdrom: gdrom: deallocate struct gdrom_unit fields in remove_gdrom

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "gdrom: fix a memory leak bug"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "scsi: ufs: fix a missing check of devm_reset_control_get"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ecryptfs: replace BUG_ON with error handling code"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "video: imsttfb: fix potential NULL pointer dereferences"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "hwmon: (lm80) fix a missing check of bus read in lm80 probe"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "leds: lp5523: fix a missing check of return value of lp55xx_read"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net: stmicro: fix a missing check of clk_prepare"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "video: hgafb: fix potential NULL pointer dereference"

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: fix crash with transient storage and zero chunk size

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: fix a crash when an origin has no snapshots

Jan Beulich <jbeulich@suse.com>
    xen-pciback: reconfigure also from backend watch handler

Daniel Beer <dlbeer@gmail.com>
    mmc: sdhci-pci-gli: increase 1.8V regulator wait

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: update sdma golden setting for Navi12

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: update gc golden setting for Navi12

Changfeng <Changfeng.Zhu@amd.com>
    drm/amdgpu: disable 3DCGCG on picasso/raven1 to avoid compute hang

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "serial: mvebu-uart: Fix to avoid a potential NULL pointer dereference"

Anirudh Rayabharam <mail@anirudhrb.com>
    rapidio: handle create_workqueue() failure

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "rapidio: fix a NULL pointer dereference when create_workqueue() fails"

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    uio_hv_generic: Fix a memory leak in error handling paths

Elia Devito <eliadevito@gmail.com>
    ALSA: hda/realtek: Add fixup for HP Spectre x360 15-df0xxx

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add fixup for HP OMEN laptop

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix silent headphone output on ASUS UX430UA

PeiSen Hou <pshou@realtek.com>
    ALSA: hda/realtek: Add some CLOVE SSIDs of ALC293

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek: reset eapd coeff to default value for alc287

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-lib: fix check for the size of isochronous packet payload

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ALSA: sb8: add a check for request_region"

Daniel Cordova A <danesc87@gmail.com>
    ALSA: hda: fixup headset for ASUS GU502 laptop

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Validate MS endpoint descriptors

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-lib: fix calculation for size of IR context payload

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: dice: fix stream format at middle sampling rate for Alesis iO 26

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix racy initialization of LINE6 MIDI

Takashi Iwai <tiwai@suse.de>
    ALSA: intel8x0: Don't update period unless prepared

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: dice: fix stream format for TC Electronic Konnekt Live at high sampling transfer frequency

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix memory leak in smb2_copychunk_range

Josef Bacik <josef@toxicpanda.com>
    btrfs: avoid RCU stalls while running delayed iputs

Zqiang <qiang.zhang@windriver.com>
    locking/mutex: clear MUTEX_FLAGS if wait_list is empty due to signal

Daniel Wagner <dwagner@suse.de>
    nvmet: seset ns->file when open fails

Oleg Nesterov <oleg@redhat.com>
    ptrace: make ptrace() fail if the tracee changed its pid unexpectedly

Dan Carpenter <dan.carpenter@oracle.com>
    RDMA/uverbs: Fix a NULL vs IS_ERR() bug

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-smbios-wmi: Fix oops on rmmod dell_smbios

Liming Sun <limings@nvidia.com>
    platform/mellanox: mlxbf-tmfifo: Fix a memory barrier issue

Shay Drory <shayd@nvidia.com>
    RDMA/core: Don't access cm_id after its destruction

Maor Gottlieb <maorg@nvidia.com>
    RDMA/mlx5: Recover from fatal event in dual port mode

Zhen Lei <thunder.leizhen@huawei.com>
    scsi: qla2xxx: Fix error return code in qla82xx_write_flash_dword()

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Increase the usable queue depth

Leon Romanovsky <leonro@nvidia.com>
    RDMA/rxe: Clear all QP fields if creation failed

Leon Romanovsky <leonro@nvidia.com>
    RDMA/siw: Release xarray entry

Leon Romanovsky <leonro@nvidia.com>
    RDMA/siw: Properly check send and receive CQ pointers

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    openrisc: Fix a memory leak

Dan Carpenter <dan.carpenter@oracle.com>
    firmware: arm_scpi: Prevent the ternary sign expansion bug


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/openrisc/kernel/setup.c                       |   2 +
 drivers/cdrom/gdrom.c                              |  13 +-
 drivers/firmware/arm_scpi.c                        |   4 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c             |   4 +
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   2 -
 drivers/hwmon/lm80.c                               |  11 +-
 drivers/infiniband/core/cma.c                      |   4 +-
 drivers/infiniband/core/uverbs_std_types_device.c  |   4 +-
 drivers/infiniband/hw/mlx5/main.c                  |   1 +
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   7 ++
 drivers/infiniband/sw/siw/siw_verbs.c              |  11 +-
 drivers/leds/leds-lp5523.c                         |   2 +-
 drivers/md/dm-snap.c                               |   6 +-
 drivers/media/platform/rcar_drif.c                 |   1 -
 drivers/misc/ics932s401.c                          |   2 +-
 drivers/mmc/host/sdhci-pci-gli.c                   |   7 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |   3 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c  |   8 +-
 drivers/net/ethernet/sun/niu.c                     |  32 +++--
 drivers/net/wireless/realtek/rtlwifi/base.c        |  18 +--
 drivers/nvme/host/core.c                           |   3 +-
 drivers/nvme/host/multipath.c                      |  55 +++++----
 drivers/nvme/host/nvme.h                           |   8 +-
 drivers/nvme/target/io-cmd-file.c                  |   8 +-
 drivers/platform/mellanox/mlxbf-tmfifo.c           |  11 +-
 drivers/platform/x86/dell-smbios-wmi.c             |   3 +-
 drivers/rapidio/rio_cm.c                           |  17 ++-
 drivers/scsi/qla2xxx/qla_nx.c                      |   3 +-
 drivers/scsi/ufs/ufs-hisi.c                        |  15 ++-
 drivers/scsi/ufs/ufshcd.c                          |   5 +-
 drivers/tty/serial/mvebu-uart.c                    |   3 -
 drivers/tty/vt/vt.c                                |   2 +-
 drivers/tty/vt/vt_ioctl.c                          |   6 +-
 drivers/uio/uio_hv_generic.c                       |   8 +-
 drivers/video/console/vgacon.c                     |  56 +++++----
 drivers/video/fbdev/core/fbcon.c                   |   2 +-
 drivers/video/fbdev/hgafb.c                        |  21 ++--
 drivers/video/fbdev/imsttfb.c                      |   5 -
 drivers/xen/xen-pciback/xenbus.c                   |  22 +++-
 fs/btrfs/inode.c                                   |   1 +
 fs/cifs/smb2ops.c                                  |   2 +
 fs/ecryptfs/crypto.c                               |   6 +-
 fs/ext4/verity.c                                   |  89 ++++++++------
 include/linux/console_struct.h                     |   1 +
 kernel/locking/mutex-debug.c                       |   4 +-
 kernel/locking/mutex-debug.h                       |   2 +-
 kernel/locking/mutex.c                             |  18 ++-
 kernel/locking/mutex.h                             |   4 +-
 kernel/ptrace.c                                    |  18 ++-
 net/bluetooth/l2cap_sock.c                         |  24 +++-
 sound/firewire/Kconfig                             |   4 +-
 sound/firewire/amdtp-stream.c                      |  27 +++--
 sound/firewire/bebob/bebob.c                       |   2 +-
 sound/firewire/dice/dice-alesis.c                  |   2 +-
 sound/firewire/dice/dice-tcelectronic.c            |   4 +-
 sound/firewire/oxfw/oxfw.c                         |   1 -
 sound/isa/sb/sb8.c                                 |   4 -
 sound/pci/hda/patch_realtek.c                      | 135 ++++++++++++++++++++-
 sound/pci/intel8x0.c                               |   7 ++
 sound/usb/line6/driver.c                           |   4 +
 sound/usb/line6/pod.c                              |   5 -
 sound/usb/line6/variax.c                           |   6 -
 sound/usb/midi.c                                   |   4 +
 66 files changed, 532 insertions(+), 257 deletions(-)


