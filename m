Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5E133B4F6
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbhCONxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:53:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229880AbhCONwf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:52:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DA9C64D9E;
        Mon, 15 Mar 2021 13:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816355;
        bh=qr+xR07uX1PsTsqYb2/lBUfX2f1Z0LNHdggLWWqojzE=;
        h=From:To:Cc:Subject:Date:From;
        b=q1mCHA+FDUyWuG70S2f20rA32qa5A6nK0mA9+mWsR3HBsDIZLvYeHF3HZPov7arWJ
         UzPT7+84de+wmYpmyLXM5/k8HhJTHyRlGzsKuulpBg303KNg5qoZ31SD9Pxz6v71a0
         8/randkxA9AXK/gzdyyoiCfS5LOnueLFLR5qjPGY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/75] 4.4.262-rc1 review
Date:   Mon, 15 Mar 2021 14:51:14 +0100
Message-Id: <20210315135208.252034256@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.262-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.262-rc1
X-KernelTest-Deadline: 2021-03-17T13:52+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 4.4.262 release.
There are 75 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 17 Mar 2021 13:51:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.262-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.262-rc1

Juergen Gross <jgross@suse.com>
    xen/events: avoid handling the same event on two cpus at the same time

Juergen Gross <jgross@suse.com>
    xen/events: don't unmask an event channel when an eoi is pending

Juergen Gross <jgross@suse.com>
    xen/events: reset affinity of 2-level event when tearing it down

Navid Emamdoost <navid.emamdoost@gmail.com>
    iio: imu: adis16400: fix memory leak

Navid Emamdoost <navid.emamdoost@gmail.com>
    iio: imu: adis16400: release allocated memory on failure

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix exclusive limit for IPA size

Arvind Yadav <arvind.yadav.cs@gmail.com>
    media: hdpvr: Fix an error handling path in hdpvr_probe()

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/64s: Fix instruction encoding for lis in ppc_function_entry()

Al Viro <viro@zeniv.linux.org.uk>
    alpha: switch __copy_user() and __do_clean_user() to normal calling conventions

Al Viro <viro@zeniv.linux.org.uk>
    alpha: get rid of tail-zeroing in __copy_user()

Al Viro <viro@zeniv.linux.org.uk>
    alpha: move exports to actual definitions

Richard Henderson <rth@twiddle.net>
    alpha: Package string routines together

Masahiro Yamada <yamada.masahiro@socionext.com>
    alpha: make short build log available for division routines

Masahiro Yamada <yamada.masahiro@socionext.com>
    alpha: merge build rules of division routines

Masahiro Yamada <yamada.masahiro@socionext.com>
    alpha: add $(src)/ rather than $(obj)/ to make source file path

Alexey Dobriyan <adobriyan@gmail.com>
    prctl: fix PR_SET_MM_AUXV kernel stack leak

Jia-Ju Bai <baijiaju1990@gmail.com>
    block: rsxx: fix error return code of rsxx_pci_probe()

Ondrej Mosnacek <omosnace@redhat.com>
    NFSv4.2: fix return value of _nfs4_get_security_label()

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: pcl818: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: pcl711: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: me4000: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: dmm32at: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: das800: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: das6402: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: adv_pci1710: Fix endian problem for AI command data

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: addi_apci_1500: Fix endian problem for command sample

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: addi_apci_1032: Fix endian problem for COS sample

Lee Gibson <leegib@gmail.com>
    staging: rtl8192e: Fix possible buffer overflow in _rtl92e_wx_set_scan

Lee Gibson <leegib@gmail.com>
    staging: rtl8712: Fix possible buffer overflow in r8712_sitesurvey_cmd

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8188eu: fix potential memory corruption in rtw_check_beacon_data()

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8712: unterminated string leads to read overflow

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8188eu: prevent ->ssid overflow in rtw_wx_set_scan()

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8192u: fix ->ssid overflow in r8192_wx_set_scan()

Shuah Khan <skhan@linuxfoundation.org>
    usbip: fix stub_dev usbip_sockfd_store() races leading to gpf

Shuah Khan <skhan@linuxfoundation.org>
    usbip: fix vhci_hcd to check for stream socket

Shuah Khan <skhan@linuxfoundation.org>
    usbip: fix stub_dev to check for stream socket

Sebastian Reichel <sebastian.reichel@collabora.com>
    USB: serial: cp210x: add some more GE USB IDs

Karan Singhal <karan.singhal@acuitybrands.com>
    USB: serial: cp210x: add ID for Acuity Brands nLight Air Adapter

Niv Sardi <xaiki@evilgiggle.com>
    USB: serial: ch341: add new Product ID

Pavel Skripkin <paskripkin@gmail.com>
    USB: serial: io_edgeport: fix memory leak in edge_startup

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Improve detection of device initiated wake signal.

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: renesas_usbhs: Clear PIPECFG for re-enabling pipe with other EPNUM

Ruslan Bilovol <ruslan.bilovol@gmail.com>
    usb: gadget: f_uac2: always increase endpoint max_packet_size by one audio slot

Yorick de Wid <ydewid@gmail.com>
    Goodix Fingerprint device is not a modem

Allen Pais <allen.pais@oracle.com>
    libertas: fix a potential NULL pointer dereference

Joe Lawrence <joe.lawrence@redhat.com>
    scripts/recordmcount.{c,pl}: support -ffunction-sections .text.* section names

Adrian Hunter <adrian.hunter@intel.com>
    mmc: core: Fix partition switch time for eMMC

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix hanging DASD driver unbind

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix "cannot get freq eq" errors on Dell AE515 sound bar

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Avoid spurious unsol event handling during S3/S4

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi: Cancel pending works before suspend

Mike Christie <michael.christie@oracle.com>
    scsi: libiscsi: Fix iscsi_prep_scsi_cmd_pdu() error handling

Heiko Carstens <hca@linux.ibm.com>
    s390/smp: __smp_rescan_cpus() - move cpumask away from stack

Martin Kaiser <martin@kaiser.cx>
    PCI: xgene-msi: Fix race in installing chained irq handler

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Record counter overflow always if SAMPLE_IP is unset

Chaotian Jing <chaotian.jing@mediatek.com>
    mmc: mediatek: fix race condition between msdc_request_timeout and irq

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: mxs-mmc: Fix a resource leak in an error handling path in 'mxs_mmc_probe()'

Maxim Mikityanskiy <maxtram95@gmail.com>
    media: usbtv: Fix deadlock on suspend

Paul Cercueil <paul@crapouillou.net>
    net: davicom: Fix regulator not turned off on driver removal

Paul Cercueil <paul@crapouillou.net>
    net: davicom: Fix regulator not turned off on failed probe

Xie He <xie.he.0141@gmail.com>
    net: lapbether: Remove netif_start_queue / netif_stop_queue

Kevin(Yudong) Yang <yyd@google.com>
    net/mlx4_en: update moderation when config reset

Thomas Gleixner <tglx@linutronix.de>
    futex: fix dead code in attach_to_pi_owner()

Thomas Gleixner <tglx@linutronix.de>
    futex: Cure exit race

Peter Zijlstra <peterz@infradead.org>
    futex: Change locking rules

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "mm, slub: consider rest of partial list if acquire_slab() fails"

Jiri Kosina <jkosina@suse.cz>
    floppy: fix lock_fdc() signal handling

Paulo Alcantara <pc@cjr.nz>
    cifs: return proper error code in statfs(2)

Vasily Averin <vvs@virtuozzo.com>
    netfilter: x_tables: gpf inside xt_find_revision()

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: enable RX FIFO after FRZ/HALT valid

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: assert FRZ bit in flexcan_chip_freeze()

Oleksij Rempel <o.rempel@pengutronix.de>
    can: skb: can_skb_set_owner(): fix ref counting if socket was closed before setting skb ownership

Daniel Borkmann <daniel@iogearbox.net>
    net: Fix gro aggregation for udp encaps with zero csum

Felix Fietkau <nbd@nbd.name>
    ath9k: fix transmitting to stations in dynamic SMPS mode

Dmitry V. Levin <ldv@altlinux.org>
    uapi: nfnetlink_cthelper.h: fix userspace compilation error


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/alpha/include/asm/Kbuild                     |   1 +
 arch/alpha/include/asm/uaccess.h                  |  76 ++------
 arch/alpha/kernel/Makefile                        |   2 +-
 arch/alpha/kernel/alpha_ksyms.c                   | 102 -----------
 arch/alpha/kernel/machvec_impl.h                  |   6 +-
 arch/alpha/kernel/setup.c                         |   1 +
 arch/alpha/lib/Makefile                           |  33 ++--
 arch/alpha/lib/callback_srm.S                     |   5 +
 arch/alpha/lib/checksum.c                         |   3 +
 arch/alpha/lib/clear_page.S                       |   3 +-
 arch/alpha/lib/clear_user.S                       |  66 +++----
 arch/alpha/lib/copy_page.S                        |   3 +-
 arch/alpha/lib/copy_user.S                        | 101 ++++-------
 arch/alpha/lib/csum_ipv6_magic.S                  |   2 +
 arch/alpha/lib/csum_partial_copy.c                |   2 +
 arch/alpha/lib/dec_and_lock.c                     |   2 +
 arch/alpha/lib/divide.S                           |   3 +
 arch/alpha/lib/ev6-clear_page.S                   |   3 +-
 arch/alpha/lib/ev6-clear_user.S                   |  85 ++++-----
 arch/alpha/lib/ev6-copy_page.S                    |   3 +-
 arch/alpha/lib/ev6-copy_user.S                    | 130 +++++---------
 arch/alpha/lib/ev6-csum_ipv6_magic.S              |   2 +
 arch/alpha/lib/ev6-divide.S                       |   3 +
 arch/alpha/lib/ev6-memchr.S                       |   3 +-
 arch/alpha/lib/ev6-memcpy.S                       |   3 +-
 arch/alpha/lib/ev6-memset.S                       |   7 +-
 arch/alpha/lib/ev67-strcat.S                      |   3 +-
 arch/alpha/lib/ev67-strchr.S                      |   3 +-
 arch/alpha/lib/ev67-strlen.S                      |   3 +-
 arch/alpha/lib/ev67-strncat.S                     |   3 +-
 arch/alpha/lib/ev67-strrchr.S                     |   3 +-
 arch/alpha/lib/fpreg.c                            |   7 +
 arch/alpha/lib/memchr.S                           |   3 +-
 arch/alpha/lib/memcpy.c                           |   5 +-
 arch/alpha/lib/memmove.S                          |   3 +-
 arch/alpha/lib/memset.S                           |   7 +-
 arch/alpha/lib/strcat.S                           |   2 +
 arch/alpha/lib/strchr.S                           |   3 +-
 arch/alpha/lib/strcpy.S                           |   3 +-
 arch/alpha/lib/strlen.S                           |   3 +-
 arch/alpha/lib/strncat.S                          |   3 +-
 arch/alpha/lib/strncpy.S                          |   3 +-
 arch/alpha/lib/strrchr.S                          |   3 +-
 arch/arm/kvm/mmu.c                                |   2 +-
 arch/powerpc/include/asm/code-patching.h          |   2 +-
 arch/powerpc/perf/core-book3s.c                   |  19 +-
 arch/s390/kernel/smp.c                            |   2 +-
 drivers/block/floppy.c                            |  35 ++--
 drivers/block/rsxx/core.c                         |   1 +
 drivers/iio/imu/adis16400_buffer.c                |   5 +-
 drivers/iio/imu/adis_buffer.c                     |   5 +-
 drivers/media/usb/hdpvr/hdpvr-core.c              |  33 ++--
 drivers/media/usb/usbtv/usbtv-audio.c             |   2 +-
 drivers/mmc/core/mmc.c                            |  15 +-
 drivers/mmc/host/mtk-sd.c                         |  18 +-
 drivers/mmc/host/mxs-mmc.c                        |   2 +-
 drivers/net/can/flexcan.c                         |  12 +-
 drivers/net/ethernet/davicom/dm9000.c             |  21 ++-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c    |   2 +
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h      |   1 +
 drivers/net/wan/lapbether.c                       |   3 -
 drivers/net/wireless/ath/ath9k/ath9k.h            |   3 +-
 drivers/net/wireless/ath/ath9k/xmit.c             |   6 +
 drivers/net/wireless/libertas/if_sdio.c           |   5 +
 drivers/pci/host/pci-xgene-msi.c                  |  10 +-
 drivers/s390/block/dasd.c                         |   3 +-
 drivers/scsi/libiscsi.c                           |  11 +-
 drivers/staging/comedi/drivers/addi_apci_1032.c   |   4 +-
 drivers/staging/comedi/drivers/addi_apci_1500.c   |  18 +-
 drivers/staging/comedi/drivers/adv_pci1710.c      |  10 +-
 drivers/staging/comedi/drivers/das6402.c          |   2 +-
 drivers/staging/comedi/drivers/das800.c           |   2 +-
 drivers/staging/comedi/drivers/dmm32at.c          |   2 +-
 drivers/staging/comedi/drivers/me4000.c           |   2 +-
 drivers/staging/comedi/drivers/pcl711.c           |   2 +-
 drivers/staging/comedi/drivers/pcl818.c           |   2 +-
 drivers/staging/rtl8188eu/core/rtw_ap.c           |   5 +
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |   6 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c        |   7 +-
 drivers/staging/rtl8192u/r8192U_wx.c              |   6 +-
 drivers/staging/rtl8712/rtl871x_cmd.c             |   6 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c     |   2 +-
 drivers/usb/class/cdc-acm.c                       |   5 +
 drivers/usb/gadget/function/f_uac2.c              |   2 +-
 drivers/usb/host/xhci.c                           |  16 +-
 drivers/usb/renesas_usbhs/pipe.c                  |   2 +
 drivers/usb/serial/ch341.c                        |   1 +
 drivers/usb/serial/cp210x.c                       |   3 +
 drivers/usb/serial/io_edgeport.c                  |  26 +--
 drivers/usb/usbip/stub_dev.c                      |  42 ++++-
 drivers/usb/usbip/vhci_sysfs.c                    |  10 +-
 drivers/xen/events/events_2l.c                    |  22 ++-
 drivers/xen/events/events_base.c                  | 130 ++++++++++----
 drivers/xen/events/events_fifo.c                  |   7 -
 drivers/xen/events/events_internal.h              |  22 ++-
 fs/cifs/cifsfs.c                                  |   2 +-
 fs/nfs/nfs4proc.c                                 |   2 +-
 include/linux/can/skb.h                           |   8 +-
 include/uapi/linux/netfilter/nfnetlink_cthelper.h |   2 +-
 kernel/futex.c                                    | 209 ++++++++++++++++++----
 kernel/sys.c                                      |   2 +-
 mm/slub.c                                         |   2 +-
 net/ipv4/udp_offload.c                            |   2 +-
 net/netfilter/x_tables.c                          |   6 +-
 scripts/recordmcount.c                            |   2 +-
 scripts/recordmcount.pl                           |  13 ++
 sound/pci/hda/hda_bind.c                          |   4 +
 sound/pci/hda/patch_hdmi.c                        |  13 ++
 sound/usb/quirks.c                                |   1 +
 111 files changed, 895 insertions(+), 671 deletions(-)


