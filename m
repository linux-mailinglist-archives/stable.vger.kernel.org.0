Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C53150B20
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgBCQY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:24:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:35456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727789AbgBCQY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:24:57 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF9C420838;
        Mon,  3 Feb 2020 16:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747095;
        bh=OUCXCq3XibIfbcVziYamvjjRVFnuDgt05l7oDGmiNGw=;
        h=From:To:Cc:Subject:Date:From;
        b=U4vUzEy49XmNsExKlMt5saIGY9Qf4BatGDNcQj0C2W5Ouqf2EBeAwx1X9zgzNTmFw
         +2mTykUHVA0F5BI/quzHUvYDZG29rFhxdcZjUcm5ExAmaIjrPusXfle0siXWpkQuyi
         +zIILDY7J+3g/vx/P5OWm+xbepUft7R47fRPRLz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/68] 4.9.213-stable review
Date:   Mon,  3 Feb 2020 16:18:56 +0000
Message-Id: <20200203161904.705434837@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.213-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.213-rc1
X-KernelTest-Deadline: 2020-02-05T16:19+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.213 release.
There are 68 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.213-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.213-rc1

Praveen Chaudhary <praveen5582@gmail.com>
    net: Fix skb->csum update in inet_proto_csum_replace16().

Vasily Averin <vvs@virtuozzo.com>
    l2t_seq_next should increase position index

Vasily Averin <vvs@virtuozzo.com>
    seq_tab_next() should increase position index

Finn Thain <fthain@telegraphics.com.au>
    net/sonic: Quiesce SONIC before re-initializing descriptor memory

Finn Thain <fthain@telegraphics.com.au>
    net/sonic: Fix receive buffer handling

Finn Thain <fthain@telegraphics.com.au>
    net/sonic: Use MMIO accessors

Finn Thain <fthain@telegraphics.com.au>
    net/sonic: Add mutual exclusion for accessing shared state

Madalin Bucur <madalin.bucur@oss.nxp.com>
    net: fsl/fman: rename IF_MODE_XGMII to IF_MODE_10G

Madalin Bucur <madalin.bucur@oss.nxp.com>
    net/fsl: treat fsl,erratum-a011043

Madalin Bucur <madalin.bucur@oss.nxp.com>
    powerpc/fsl/dts: add fsl,erratum-a011043

Manish Chopra <manishc@marvell.com>
    qlcnic: Fix CPU soft lockup while collecting firmware dump

Hayes Wang <hayeswang@realtek.com>
    r8152: get default setting of WOL before initializing

Michael Ellerman <mpe@ellerman.id.au>
    airo: Add missing CAP_NET_ADMIN check in AIROOLDIOCTL/SIOCDEVPRIVATE

Michael Ellerman <mpe@ellerman.id.au>
    airo: Fix possible info leak in AIROOLDIOCTL/SIOCDEVPRIVATE

Vladimir Murzin <vladimir.murzin@arm.com>
    ARM: 8955/1: virt: Relax arch timer version check during early boot

Hannes Reinecke <hare@suse.de>
    scsi: fnic: do not queue commands during fwreset

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    vti[6]: fix packet tx through bpf_redirect()

Johan Hovold <johan@kernel.org>
    Input: aiptek - use descriptors of current altsetting

Arnd Bergmann <arnd@arndb.de>
    wireless: wext: avoid gcc -O3 warning

Jouni Malinen <j@w1.fi>
    mac80211: Fix TKIP replay protection immediately after key setup

Ganapathi Bhat <ganapathi.bhat@nxp.com>
    wireless: fix enabling channel 12 for custom regulatory domain

Cambda Zhu <cambda@linux.alibaba.com>
    ixgbe: Fix calculation of queue with VFs and flow director on interface flap

Radoslaw Tyl <radoslawx.tyl@intel.com>
    ixgbevf: Remove limit of 10 entries for unicast filter list

Lubomir Rintel <lkundrak@v3.sk>
    clk: mmp2: Fix the order of timer mux parents

Markus Theil <markus.theil@tu-ilmenau.de>
    mac80211: mesh: restrict airtime metric to peered established plinks

Dave Gerlach <d-gerlach@ti.com>
    soc: ti: wkup_m3_ipc: Fix race condition with rproc_boot

Kishon Vijay Abraham I <kishon@ti.com>
    ARM: dts: beagle-x15-common: Model 5V0 regulator

Lee Jones <lee.jones@linaro.org>
    media: si470x-i2c: Move free() past last use of 'radio'

Bin Liu <b-liu@ti.com>
    usb: dwc3: turn off VBUS when leaving host mode

Dan Carpenter <dan.carpenter@oracle.com>
    Bluetooth: Fix race condition in hci_release_sock()

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    ttyprintk: fix a potential deadlock in interrupt context issue

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: dvb-usb/dvb-usb-urb.c: initialize actlen to 0

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: gspca: zero usb_buf

Sean Young <sean@mess.org>
    media: af9005: uninitialized variable printked

Sean Young <sean@mess.org>
    media: digitv: don't continue if remote control state can't be read

Jan Kara <jack@suse.cz>
    reiserfs: Fix memory leak of journal device string

Dan Carpenter <dan.carpenter@oracle.com>
    mm/mempolicy.c: fix out of bounds write in mpol_parse_str()

Dirk Behme <dirk.behme@de.bosch.com>
    arm64: kbuild: remove compressed images on 'make ARCH=arm64 (dist)clean'

Vitaly Chikunov <vt@altlinux.org>
    tools lib: Fix builds when glibc contains strlcpy()

Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
    iio: gyro: st_gyro: fix L3GD20H support

Linus Walleij <linus.walleij@linaro.org>
    iio: gyro: st_gyro: inline per-sensor data

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: pcrypt - Fix user-after-free on module unload

Al Viro <viro@zeniv.linux.org.uk>
    vfs: fix do_last() regression

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Use bh_lock_sock in sk_destruct

Eric Dumazet <edumazet@google.com>
    net_sched: ematch: reject invalid TCF_EM_SIMPLE

Laura Abbott <labbott@fedoraproject.org>
    usb-storage: Disable UAS on JMicron SATA enclosure

Arnd Bergmann <arnd@arndb.de>
    atm: eni: fix uninitialized variable warning

Dmitry Osipenko <digetx@gmail.com>
    gpio: max77620: Add missing dependency on GPIOLIB_IRQCHIP

Krzysztof Kozlowski <krzk@kernel.org>
    net: wan: sdla: Fix cast from pointer to integer of different size

Fenghua Yu <fenghua.yu@intel.com>
    drivers/net/b44: Change to non-atomic bit operations on pwol_mask

Andreas Kemnade <andreas@kemnade.info>
    watchdog: rn5t618_wdt: fix module aliases

Randy Dunlap <rdunlap@infradead.org>
    arc: eznps: fix allmodconfig kconfig warning

Johan Hovold <johan@kernel.org>
    zd1211rw: fix storage endpoint lookup

Johan Hovold <johan@kernel.org>
    rtl8xxxu: fix interface sanity check

Johan Hovold <johan@kernel.org>
    brcmfmac: fix interface sanity check

Johan Hovold <johan@kernel.org>
    ath9k: fix storage endpoint lookup

Lukas Wunner <lukas@wunner.de>
    serial: 8250_bcm2835aux: Fix line mismatch on driver unbind

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Fix false Tx excessive retries reporting.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: use NULLFUCTION stack on mac80211

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: correct packet types for CTS protect, mode.

Colin Ian King <colin.king@canonical.com>
    staging: wlan-ng: ensure error return is actually returned

Andrey Shvetsov <andrey.shvetsov@k2l.de>
    staging: most: net: fix buffer overflow

Johan Hovold <johan@kernel.org>
    USB: serial: ir-usb: fix IrLAP framing

Johan Hovold <johan@kernel.org>
    USB: serial: ir-usb: fix link-speed handling

Johan Hovold <johan@kernel.org>
    USB: serial: ir-usb: add missing endpoint sanity check

Johan Hovold <johan@kernel.org>
    rsi_91x_usb: fix interface sanity check

Johan Hovold <johan@kernel.org>
    orinoco_usb: fix interface sanity check

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Add missing copy ops check before clearing buffer


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/plat-eznps/Kconfig                        |   2 +-
 arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi    |  21 +++
 arch/arm/kernel/hyp-stub.S                         |   7 +-
 arch/arm64/boot/Makefile                           |   2 +-
 .../dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi   |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi |   1 +
 .../dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi   |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi  |   1 +
 crypto/af_alg.c                                    |   6 +-
 crypto/pcrypt.c                                    |   3 +-
 drivers/atm/eni.c                                  |   4 +-
 drivers/char/ttyprintk.c                           |  15 +-
 drivers/clk/mmp/clk-of-mmp2.c                      |   2 +-
 drivers/gpio/Kconfig                               |   1 +
 drivers/iio/gyro/st_gyro.h                         |   1 +
 drivers/iio/gyro/st_gyro_core.c                    | 210 +++++++--------------
 drivers/iio/gyro/st_gyro_i2c.c                     |   5 +
 drivers/iio/gyro/st_gyro_spi.c                     |   1 +
 drivers/input/tablet/aiptek.c                      |   2 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   2 +-
 drivers/media/usb/dvb-usb/af9005.c                 |   2 +-
 drivers/media/usb/dvb-usb/digitv.c                 |  10 +-
 drivers/media/usb/dvb-usb/dvb-usb-urb.c            |   2 +-
 drivers/media/usb/gspca/gspca.c                    |   2 +-
 drivers/net/ethernet/broadcom/b44.c                |   9 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/l2t.c           |   3 +-
 drivers/net/ethernet/freescale/fman/fman_memac.c   |   4 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c        |   7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  37 +++-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   5 -
 drivers/net/ethernet/natsemi/sonic.c               | 109 +++++++++--
 drivers/net/ethernet/natsemi/sonic.h               |  25 ++-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |   1 +
 .../net/ethernet/qlogic/qlcnic/qlcnic_minidump.c   |   2 +
 drivers/net/usb/r8152.c                            |   9 +-
 drivers/net/wan/sdla.c                             |   2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   4 +-
 drivers/net/wireless/cisco/airo.c                  |  20 +-
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |   4 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   2 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   2 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |   2 +-
 drivers/scsi/fnic/fnic_scsi.c                      |   3 +
 drivers/soc/ti/wkup_m3_ipc.c                       |   4 +-
 drivers/staging/most/aim-network/networking.c      |  10 +
 drivers/staging/vt6656/device.h                    |   2 +
 drivers/staging/vt6656/int.c                       |   6 +-
 drivers/staging/vt6656/main_usb.c                  |   1 +
 drivers/staging/vt6656/rxtx.c                      |  26 +--
 drivers/staging/wlan-ng/prism2mgmt.c               |   2 +-
 drivers/tty/serial/8250/8250_bcm2835aux.c          |   2 +-
 drivers/usb/dwc3/core.c                            |   3 +
 drivers/usb/serial/ir-usb.c                        | 136 +++++++++----
 drivers/usb/storage/unusual_uas.h                  |   7 +-
 drivers/watchdog/rn5t618_wdt.c                     |   1 +
 fs/namei.c                                         |   4 +-
 fs/reiserfs/super.c                                |   2 +
 include/linux/usb/irda.h                           |  13 +-
 mm/mempolicy.c                                     |   6 +-
 net/bluetooth/hci_sock.c                           |   3 +
 net/core/utils.c                                   |  20 +-
 net/ipv4/ip_vti.c                                  |  13 +-
 net/ipv6/ip6_vti.c                                 |  13 +-
 net/mac80211/mesh_hwmp.c                           |   3 +
 net/mac80211/tkip.c                                |  18 +-
 net/sched/ematch.c                                 |   3 +
 net/wireless/reg.c                                 |  13 +-
 net/wireless/wext-core.c                           |   3 +-
 sound/core/pcm_native.c                            |   2 +-
 tools/include/linux/string.h                       |   8 +
 tools/lib/string.c                                 |   7 +
 88 files changed, 587 insertions(+), 321 deletions(-)


