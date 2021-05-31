Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38EA395C56
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhEaNbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232476AbhEaN3X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:29:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F33346141D;
        Mon, 31 May 2021 13:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467361;
        bh=HPMgD3XK4DLCLbPqCwln+gdQAW9Ppykh+d7UiRhlbj0=;
        h=From:To:Cc:Subject:Date:From;
        b=wxaHDu2aCQZRsf8qbpE9uIDCmq5pDM6OcZMvTiHoOGqMH/yt/UXoJjMfVxqCExvLK
         cfcIQ+wIQO0ekXBzz9/bfDzoLzX8ZGLvkUs1F19L+dosQpq5NxdSbEHZdmNg8U6NUl
         XVDz5SpAzcZtdANFijU9eSM6wJ/Q7iDIJgkiGF0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 000/116] 4.19.193-rc1 review
Date:   Mon, 31 May 2021 15:12:56 +0200
Message-Id: <20210531130640.131924542@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.193-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.193-rc1
X-KernelTest-Deadline: 2021-06-02T13:06+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.193 release.
There are 116 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.193-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.193-rc1

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: core: reduce power-on-good delay time of root hub

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: check the return of skb_checksum_help()

Jesse Brandeburg <jesse.brandeburg@intel.com>
    drivers/net/ethernet: clean up unused assignments

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlbfs: hugetlb_fault_mutex_hash() cleanup

Randy Dunlap <rdunlap@infradead.org>
    MIPS: ralink: export rt_sysc_membase for rt2880_wdt.c

Randy Dunlap <rdunlap@infradead.org>
    MIPS: alchemy: xxs1500: add gpio-au1000.h header file

Taehee Yoo <ap420073@gmail.com>
    sch_dsmark: fix a NULL deref in qdisc_reset()

Francesco Ruggeri <fruggeri@arista.com>
    ipv6: record frag_max_size in atomic fragments in input path

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: libsas: Use _safe() loop in sas_resume_port()

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ixgbe: fix large MTU request from VF

Jussi Maki <joamaki@gmail.com>
    bpf: Set mac_len in bpf_skb_change_head

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: cs35l33: fix an error code in probe()

Dan Carpenter <dan.carpenter@oracle.com>
    staging: emxx_udc: fix loop in _nbu2ss_nuke()

Taehee Yoo <ap420073@gmail.com>
    mld: fix panic in mld_newpack()

Zhen Lei <thunder.leizhen@huawei.com>
    net: bnx2: Fix error return code in bnx2_init_board()

Tao Liu <thomas.liu@ucloud.cn>
    openvswitch: meter: fix race when getting now_ms.

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: mdio: octeon: Fix some double free issues

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: mdio: thunder: Fix a double free issue in the .remove function

Fugang Duan <fugang.duan@nxp.com>
    net: fec: fix the potential memory leak in fec_enet_init()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fix error code getting shifted with 4 in dsa_slave_get_sset_count

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: netcp: Fix an error message

xinhui pan <xinhui.pan@amd.com>
    drm/amdgpu: Fix a use-after-free

Jingwen Chen <Jingwen.Chen2@amd.com>
    drm/amd/amdgpu: fix refcount leak

Chris Park <Chris.Park@amd.com>
    drm/amd/display: Disconnect non-DP with no EDID

Steve French <stfrench@microsoft.com>
    SMB3: incorrect file id in requests compounded with open

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    platform/x86: intel_punit_ipc: Append MODULE_DEVICE_TABLE for ACPI

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86: hp-wireless: add AMD's hardware id to the supported list

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
    ASoC: cs43130: handle errors in cs43130_probe() properly

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    libertas: register sysfs groups properly

Phillip Potter <phil@philpotter.co.uk>
    dmaengine: qcom_hidma: comment platform_driver_register call

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

Atul Gopinathan <atulgopinathan@gmail.com>
    serial: max310x: unregister uart driver in case of failure and abort

Kai-Heng Feng <kai.heng.feng@canonical.com>
    platform/x86: hp_accel: Avoid invoking _INI to speed up resume

Felix Fietkau <nbd@nbd.name>
    perf jevents: Fix getting maximum number of fds

Jean Delvare <jdelvare@suse.de>
    i2c: i801: Don't generate an interrupt on bus reset

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    i2c: s3c2410: fix possible NULL pointer deref on read message after write

Dan Carpenter <dan.carpenter@oracle.com>
    net: dsa: fix a crash if ->get_sset_count() fails

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mt7530: fix VLAN traffic leaks

Xin Long <lucien.xin@gmail.com>
    tipc: skb_linearize the head skb when reassembling msgs

Hoang Le <hoang.h.le@dektech.com.au>
    Revert "net:tipc: Fix a double free in tipc_sk_mcast_rcv"

Vladyslav Tarasiuk <vladyslavt@nvidia.com>
    net/mlx4: Fix EEPROM dump support

Neil Armstrong <narmstrong@baylibre.com>
    drm/meson: fix shutdown crash when component not probed

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    NFSv4: Fix v4.0/v4.1 SEEK_DATA return -ENOTSUPP when set NFS_V4_2 config

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't corrupt the value of pg_bytes_written in nfs_do_recoalesce()

Dan Carpenter <dan.carpenter@oracle.com>
    NFS: fix an incorrect limit in filelayout_decode_layout()

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    Bluetooth: cmtp: fix file refcount when cmtp_attach_device fails

Lukas Wunner <lukas@wunner.de>
    spi: mt7621: Don't leak SPI master in probe error path

Lukas Wunner <lukas@wunner.de>
    spi: mt7621: Disable clock in probe error path

Lukas Wunner <lukas@wunner.de>
    spi: gpio: Don't leak SPI master in probe error path

Daniel Borkmann <daniel@iogearbox.net>
    bpf: No need to simulate speculative domain for immediates

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix mask direction swap upon off reg sign change

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Wrap aux data inside bpf_sanitize_info container

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix leakage of uninitialized bpf stack under speculation

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Update selftests to reflect new error states

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Tighten speculative pointer arithmetic mask

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Move sanitize_val_alu out of op switch

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Refactor and streamline bounds check into helper

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Improve verifier error messages for users

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Rework ptr_limit into alu_limit and add common error path

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Ensure off_reg has no mixed signed bounds for all types

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Move off_reg into sanitize_ptr_alu

Daniel Borkmann <daniel@iogearbox.net>
    bpf, test_verifier: switch bpf_get_stack's 0 s> r8 test

John Fastabend <john.fastabend@gmail.com>
    bpf: Test_verifier, bpf_get_stack return value add <0

Alexei Starovoitov <ast@kernel.org>
    bpf: extend is_branch_taken to registers

Ovidiu Panait <ovidiu.panait@windriver.com>
    selftests/bpf: add selftest part of "bpf: improve verifier branch analysis"

Andrey Ignatov <rdna@fb.com>
    selftests/bpf: Test narrow loads with off > 0 in test_verifier

Piotr Krysiuk <piotras@gmail.com>
    bpf, selftests: Fix up some test_verifier cases for unprivileged

Ovidiu Panait <ovidiu.panait@windriver.com>
    bpf: fix up selftests after backports were fixed

Pavel Skripkin <paskripkin@gmail.com>
    net: usb: fix memory leak in smsc75xx_bind

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: gadget: udc: renesas_usb3: Fix a race in usb3_start_pipen()

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Properly track pending and queued SG

Zolton Jheng <s6668c2t@gmail.com>
    USB: serial: pl2303: add device id for ADLINK ND-6530 GC

Dominik Andreas Schorpp <dominik.a.schorpp@ids.de>
    USB: serial: ftdi_sio: add IDs for IDS GmbH Products

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit LE910-S1 compositions 0x7010, 0x7011

Sean MacLennan <seanm@seanm.ca>
    USB: serial: ti_usb_3410_5052: add startech.com device id

Zheyu Ma <zheyuma97@gmail.com>
    serial: rp2: use 'request_firmware' instead of 'request_firmware_nowait'

Geert Uytterhoeven <geert+renesas@glider.be>
    serial: sh-sci: Fix off-by-one error in FIFO threshold register setting

Alan Stern <stern@rowland.harvard.edu>
    USB: usbfs: Don't WARN about excessively large memory allocations

Johan Hovold <johan@kernel.org>
    USB: trancevibrator: fix control-request direction

YueHaibing <yuehaibing@huawei.com>
    iio: adc: ad7793: Add missing error code in ad7793_setup()

Lucas Stankus <lucas.p.stankus@gmail.com>
    staging: iio: cdc: ad7746: avoid overwrite of num_channels

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: request autosuspend after sending rx flow control

Mathias Nyman <mathias.nyman@linux.intel.com>
    thunderbolt: dma_port: Fix NVM read buffer bounds and offset issue

Dongliang Mu <mudongliangabcd@gmail.com>
    misc/uss720: fix memory leak in uss720_probe

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kgdb: fix gcc-11 warnings harder

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: properly fix a crash when an origin has no snapshots

Sriram R <srirrama@codeaurora.org>
    ath10k: Validate first subframe of A-MSDU before processing the list

Wen Gong <wgong@codeaurora.org>
    mac80211: extend protection against mixed key and fragment cache attacks

Johannes Berg <johannes.berg@intel.com>
    mac80211: do not accept/forward invalid EAPOL frames

Johannes Berg <johannes.berg@intel.com>
    mac80211: prevent attacks on TKIP/WEP as well

Johannes Berg <johannes.berg@intel.com>
    mac80211: check defrag PN against current frame

Johannes Berg <johannes.berg@intel.com>
    mac80211: add fragment cache to sta_info

Johannes Berg <johannes.berg@intel.com>
    mac80211: drop A-MSDUs on old ciphers

Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
    cfg80211: mitigate A-MSDU aggregation attacks

Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
    mac80211: properly handle A-MSDUs that start with an RFC 1042 header

Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
    mac80211: prevent mixed key and fragment cache attacks

Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
    mac80211: assure all fragments are encrypted

Johan Hovold <johan@kernel.org>
    net: hso: fix control-request directions

Kees Cook <keescook@chromium.org>
    proc: Check /proc/$pid/attr/ writes against file opener

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix transaction abort handling

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix sample instruction bytes

Rolf Eike Beer <eb@emlix.com>
    iommu/vt-d: Fix sysfs leak in alloc_iommu()

Anna Schumaker <Anna.Schumaker@Netapp.com>
    NFSv4: Fix a NULL pointer dereference in pnfs_mark_matching_lsegs_return()

Aurelien Aptel <aaptel@suse.com>
    cifs: set server->cipher_type to AES-128-CCM for SMB3.0

Dongliang Mu <mudongliangabcd@gmail.com>
    NFC: nci: fix memory leak in nci_allocate_device

Jack Pham <jackp@codeaurora.org>
    usb: dwc3: gadget: Enable suspend events

Stephen Brennan <stephen.s.brennan@oracle.com>
    mm, vmstat: drop zone->lock in /proc/pagetypeinfo


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/mips/alchemy/board-xxs1500.c                  |   1 +
 arch/mips/ralink/of.c                              |   2 +
 arch/openrisc/include/asm/barrier.h                |   9 +
 drivers/char/hpet.c                                |   4 +
 drivers/dma/qcom/hidma_mgmt.c                      |  14 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c             |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   1 +
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |  18 ++
 drivers/gpu/drm/meson/meson_drv.c                  |   9 +-
 drivers/i2c/busses/i2c-i801.c                      |   6 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   3 +
 drivers/iio/adc/ad7793.c                           |   1 +
 drivers/iommu/dmar.c                               |   4 +-
 drivers/isdn/hardware/mISDN/mISDNinfineon.c        |  24 +-
 drivers/md/dm-snap.c                               |   2 +-
 drivers/media/dvb-frontends/sp8870.c               |   4 +-
 drivers/media/usb/gspca/m5602/m5602_po1030.c       |  10 +-
 drivers/misc/kgdbts.c                              |   3 +-
 drivers/misc/lis3lv02d/lis3lv02d.h                 |   1 +
 drivers/misc/mei/interrupt.c                       |   3 +
 drivers/net/caif/caif_serial.c                     |   1 -
 drivers/net/dsa/mt7530.c                           |   8 -
 drivers/net/ethernet/broadcom/bnx2.c               |   2 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |   7 +-
 drivers/net/ethernet/dec/tulip/de4x5.c             |   4 +-
 drivers/net/ethernet/dec/tulip/media.c             |   5 -
 drivers/net/ethernet/freescale/fec_main.c          |  11 +-
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c          |   5 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |  16 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   2 +-
 drivers/net/ethernet/mellanox/mlx4/port.c          | 107 +++++++-
 drivers/net/ethernet/micrel/ksz884x.c              |   3 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   6 +-
 drivers/net/ethernet/neterion/vxge/vxge-traffic.c  |  32 +--
 drivers/net/ethernet/sfc/falcon/farch.c            |  29 +-
 drivers/net/ethernet/sis/sis900.c                  |   5 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-common.c  |   2 +-
 drivers/net/ethernet/ti/davinci_emac.c             |   5 +-
 drivers/net/ethernet/ti/netcp_core.c               |   4 +-
 drivers/net/ethernet/ti/tlan.c                     |   4 +-
 drivers/net/ethernet/via/via-velocity.c            |  13 -
 drivers/net/phy/mdio-octeon.c                      |   2 -
 drivers/net/phy/mdio-thunder.c                     |   1 -
 drivers/net/usb/hso.c                              |   4 +-
 drivers/net/usb/smsc75xx.c                         |   8 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |  61 ++++-
 drivers/net/wireless/marvell/libertas/mesh.c       |  28 +-
 drivers/platform/x86/hp-wireless.c                 |   2 +
 drivers/platform/x86/hp_accel.c                    |  22 +-
 drivers/platform/x86/intel_punit_ipc.c             |   1 +
 drivers/scsi/BusLogic.c                            |   6 +-
 drivers/scsi/BusLogic.h                            |   2 +-
 drivers/scsi/libsas/sas_port.c                     |   4 +-
 drivers/spi/spi-gpio.c                             |   8 +-
 drivers/staging/emxx_udc/emxx_udc.c                |   4 +-
 drivers/staging/iio/cdc/ad7746.c                   |   1 -
 drivers/staging/mt7621-spi/spi-mt7621.c            |  10 +-
 drivers/thunderbolt/dma_port.c                     |  11 +-
 drivers/tty/serial/max310x.c                       |   6 +-
 drivers/tty/serial/rp2.c                           |  52 ++--
 drivers/tty/serial/sh-sci.c                        |   4 +-
 drivers/usb/core/devio.c                           |  11 +-
 drivers/usb/core/hub.h                             |   6 +-
 drivers/usb/dwc3/gadget.c                          |  17 +-
 drivers/usb/gadget/udc/renesas_usb3.c              |   5 +-
 drivers/usb/misc/trancevibrator.c                  |   4 +-
 drivers/usb/misc/uss720.c                          |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   7 +
 drivers/usb/serial/option.c                        |   4 +
 drivers/usb/serial/pl2303.c                        |   1 +
 drivers/usb/serial/pl2303.h                        |   1 +
 drivers/usb/serial/ti_usb_3410_5052.c              |   3 +
 fs/btrfs/tree-log.c                                |   2 -
 fs/cifs/smb2pdu.c                                  |  13 +-
 fs/hugetlbfs/inode.c                               |   4 +-
 fs/nfs/filelayout/filelayout.c                     |   2 +-
 fs/nfs/nfs4file.c                                  |   2 +-
 fs/nfs/pagelist.c                                  |  12 +-
 fs/nfs/pnfs.c                                      |  15 +-
 fs/proc/base.c                                     |   4 +
 include/linux/bpf_verifier.h                       |   5 +-
 include/linux/hugetlb.h                            |   2 +-
 include/net/cfg80211.h                             |   4 +-
 include/net/nfc/nci_core.h                         |   1 +
 kernel/bpf/verifier.c                              | 300 ++++++++++++++-------
 mm/hugetlb.c                                       |  10 +-
 mm/userfaultfd.c                                   |   2 +-
 mm/vmstat.c                                        |   3 +
 net/bluetooth/cmtp/core.c                          |   5 +
 net/core/filter.c                                  |   1 +
 net/dsa/master.c                                   |   5 +-
 net/dsa/slave.c                                    |  12 +-
 net/ipv6/mcast.c                                   |   3 -
 net/ipv6/reassembly.c                              |   4 +-
 net/mac80211/ieee80211_i.h                         |  36 +--
 net/mac80211/iface.c                               |  11 +-
 net/mac80211/key.c                                 |   7 +
 net/mac80211/key.h                                 |   2 +
 net/mac80211/rx.c                                  | 150 ++++++++---
 net/mac80211/sta_info.c                            |   6 +-
 net/mac80211/sta_info.h                            |  32 +++
 net/mac80211/wpa.c                                 |  13 +-
 net/nfc/nci/core.c                                 |   1 +
 net/nfc/nci/hci.c                                  |   5 +
 net/openvswitch/meter.c                            |   8 +
 net/sched/sch_dsmark.c                             |   3 +-
 net/tipc/msg.c                                     |   9 +-
 net/tipc/socket.c                                  |   5 +-
 net/wireless/util.c                                |   7 +-
 sound/isa/sb/sb8.c                                 |   6 +-
 sound/soc/codecs/cs35l33.c                         |   1 +
 sound/soc/codecs/cs43130.c                         |  28 +-
 tools/perf/pmu-events/jevents.c                    |   2 +-
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |   6 +-
 tools/perf/util/intel-pt.c                         |   5 +-
 tools/testing/selftests/bpf/test_verifier.c        | 112 ++++++--
 120 files changed, 1056 insertions(+), 521 deletions(-)


