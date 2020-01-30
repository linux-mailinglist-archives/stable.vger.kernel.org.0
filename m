Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C530914E10F
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbgA3SlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:41:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730081AbgA3SlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:41:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB6FB205F4;
        Thu, 30 Jan 2020 18:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409663;
        bh=YWQvjCZBBaXdJWkDTaRqat1p77aFl6TfaiTzbyAGkts=;
        h=From:To:Cc:Subject:Date:From;
        b=TOvVJfdt9K/zKVVLjxe2Y33LXA1dZ9ZgkfoLiEp3OFne/vVcs3EhIU51T+cIrkzMU
         Zs+bINju9D1ydrgRWUSDKYGXl5X6XT33vIeUGIQBIDB7LECxzAV3PZvlLo+BC5J1s6
         gHAzGyoaJGbiIGufIjvhLbj3xa02kpw2WKVVYk7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.5 00/56] 5.5.1-stable review
Date:   Thu, 30 Jan 2020 19:38:17 +0100
Message-Id: <20200130183608.849023566@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.5.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.5.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.5.1-rc1
X-KernelTest-Deadline: 2020-02-01T18:36+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.5.1 release.
There are 56 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 01 Feb 2020 18:35:06 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.5.1-rc1

Paul Cercueil <paul@crapouillou.net>
    power/supply: ingenic-battery: Don't change scale if there's only one

Johannes Berg <johannes.berg@intel.com>
    Revert "um: Enable CONFIG_CONSTRUCTORS"

Andrew Murray <andrew.murray@arm.com>
    KVM: arm64: Write arch.mdcr_el2 changes since last vcpu_load on VHE

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: pcrypt - Fix user-after-free on module unload

Iuliana Prodan <iuliana.prodan@nxp.com>
    crypto: caam - do not reset pointer size from MCFGR register

Daniel Axtens <dja@axtens.net>
    crypto: vmx - reject xts inputs that are too short

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Use bh_lock_sock in sk_destruct

Johan Hovold <johan@kernel.org>
    rsi: fix non-atomic allocation in completion handler

Johan Hovold <johan@kernel.org>
    rsi: fix memory leak on failed URB submission

Johan Hovold <johan@kernel.org>
    rsi: fix use-after-free on probe errors

Johan Hovold <johan@kernel.org>
    rsi: fix use-after-free on failed probe and unbind

David Howells <dhowells@redhat.com>
    rxrpc: Fix use-after-free in rxrpc_receive_data()

Stephen Worley <sworley@cumulusnetworks.com>
    net: include struct nhmsg size in nh nlmsg size

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mlxsw: minimal: Fix an error handling path in 'mlxsw_m_port_create()'

Willem de Bruijn <willemb@google.com>
    udp: segment looped gso packets correctly

Lorenzo Bianconi <lorenzo@kernel.org>
    net: socionext: fix xdp_result initialization in netsec_process_rx

Lorenzo Bianconi <lorenzo@kernel.org>
    net: socionext: fix possible user-after-free in netsec_process_rx

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: walk through all child classes in tc_bind_tclass()

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix ops->bind_class() implementations

Eric Dumazet <edumazet@google.com>
    net_sched: ematch: reject invalid TCF_EM_SIMPLE

Sven Auhagen <sven.auhagen@voleatech.de>
    mvneta driver disallow XDP program on hardware buffer management

Johan Hovold <johan@kernel.org>
    zd1211rw: fix storage endpoint lookup

Johan Hovold <johan@kernel.org>
    rtl8xxxu: fix interface sanity check

Johan Hovold <johan@kernel.org>
    brcmfmac: fix interface sanity check

Johan Hovold <johan@kernel.org>
    ath9k: fix storage endpoint lookup

Paulo Alcantara (SUSE) <pc@cjr.nz>
    cifs: Fix memory allocation in __smb2_handle_cancelled_cmd()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: set correct max-buffer-size for smb2_ioctl_init()

Vincent Whitchurch <vincent.whitchurch@axis.com>
    CIFS: Fix task struct use-after-free on reconnect

Eric Biggers <ebiggers@google.com>
    crypto: chelsio - fix writing tfm flags to wrong place

Guenter Roeck <linux@roeck-us.net>
    driver core: Fix test_async_driver_probe if NUMA is disabled

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: st_gyro: Correct data for LSM9DS0 gyro

Olivier Moysan <olivier.moysan@st.com>
    iio: adc: stm32-dfsdm: fix single conversion

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: add jasper point DID

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: add comet point (lake) H device ids

Tomas Winkler <tomas.winkler@intel.com>
    mei: hdcp: bind only with i915 on the same PCH

Martin Fuzzey <martin.fuzzey@flowbird.group>
    binder: fix log spam for existing debugfs file creation.

Lubomir Rintel <lkundrak@v3.sk>
    component: do not dereference opaque pointer in debugfs

Eric Snowberg <eric.snowberg@oracle.com>
    debugfs: Return -EPERM when locked down

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    serial: imx: fix a race condition in receive path

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

Thomas Hebb <tommyhebb@gmail.com>
    usb: typec: fusb302: fix "op-sink-microwatt" default that was in mW

Thomas Hebb <tommyhebb@gmail.com>
    usb: typec: wcove: fix "op-sink-microwatt" default that was in mW

Bin Liu <b-liu@ti.com>
    usb: dwc3: turn off VBUS when leaving host mode

Johan Hovold <johan@kernel.org>
    USB: serial: ir-usb: fix IrLAP framing

Johan Hovold <johan@kernel.org>
    USB: serial: ir-usb: fix link-speed handling

Johan Hovold <johan@kernel.org>
    USB: serial: ir-usb: add missing endpoint sanity check

Peter Robinson <pbrobinson@gmail.com>
    usb: host: xhci-tegra: set MODULE_FIRMWARE for tegra186

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add ID for the Intel Comet Lake -V variant

Johan Hovold <johan@kernel.org>
    rsi_91x_usb: fix interface sanity check

Johan Hovold <johan@kernel.org>
    orinoco_usb: fix interface sanity check

Johan Hovold <johan@kernel.org>
    Bluetooth: btusb: fix non-atomic allocation in completion handler


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/kvm/debug.c                             |   6 +-
 arch/um/include/asm/common.lds.S                   |   2 +-
 arch/um/kernel/dyn.lds.S                           |   1 +
 crypto/af_alg.c                                    |   6 +-
 crypto/pcrypt.c                                    |   3 +-
 drivers/android/binder.c                           |  37 +++---
 drivers/base/component.c                           |   8 +-
 drivers/base/test/test_async_driver_probe.c        |   3 +-
 drivers/bluetooth/btusb.c                          |   2 +-
 drivers/crypto/caam/ctrl.c                         |   6 +-
 drivers/crypto/chelsio/chcr_algo.c                 |  16 +--
 drivers/crypto/vmx/aes_xts.c                       |   3 +
 drivers/iio/adc/stm32-dfsdm-adc.c                  |   2 +
 drivers/iio/gyro/st_gyro_core.c                    |  75 +++++++++++-
 drivers/misc/mei/hdcp/mei_hdcp.c                   |  33 ++++-
 drivers/misc/mei/hw-me-regs.h                      |   6 +
 drivers/misc/mei/pci-me.c                          |   4 +
 drivers/net/ethernet/marvell/mvneta.c              |   6 +
 drivers/net/ethernet/mellanox/mlxsw/minimal.c      |   2 +-
 drivers/net/ethernet/socionext/netsec.c            |   4 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   4 +-
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |   4 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   2 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |  12 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |  37 ++++--
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |   2 +-
 drivers/power/supply/ingenic-battery.c             |  15 ++-
 drivers/staging/most/net/net.c                     |  10 ++
 drivers/staging/vt6656/device.h                    |   2 +
 drivers/staging/vt6656/int.c                       |   6 +-
 drivers/staging/vt6656/main_usb.c                  |   1 +
 drivers/staging/vt6656/rxtx.c                      |  26 ++--
 drivers/staging/wlan-ng/prism2mgmt.c               |   2 +-
 drivers/tty/serial/8250/8250_bcm2835aux.c          |   2 +-
 drivers/tty/serial/imx.c                           |  51 ++++++--
 drivers/usb/dwc3/core.c                            |   3 +
 drivers/usb/dwc3/dwc3-pci.c                        |   4 +
 drivers/usb/host/xhci-tegra.c                      |   1 +
 drivers/usb/serial/ir-usb.c                        | 136 ++++++++++++++++-----
 drivers/usb/typec/tcpm/fusb302.c                   |   2 +-
 drivers/usb/typec/tcpm/wcove.c                     |   2 +-
 fs/cifs/cifsglob.h                                 |   1 +
 fs/cifs/smb2misc.c                                 |   2 +-
 fs/cifs/smb2ops.c                                  |   9 +-
 fs/cifs/smb2transport.c                            |   2 +
 fs/cifs/transport.c                                |   3 +
 fs/debugfs/file.c                                  |  17 +--
 include/linux/usb/irda.h                           |  13 +-
 include/net/pkt_cls.h                              |  33 ++---
 include/net/sch_generic.h                          |   3 +-
 include/net/udp.h                                  |   3 +
 init/Kconfig                                       |   1 +
 kernel/gcov/Kconfig                                |   2 +-
 net/ipv4/nexthop.c                                 |   4 +-
 net/rxrpc/input.c                                  |  12 +-
 net/sched/cls_basic.c                              |  11 +-
 net/sched/cls_bpf.c                                |  11 +-
 net/sched/cls_flower.c                             |  11 +-
 net/sched/cls_fw.c                                 |  11 +-
 net/sched/cls_matchall.c                           |  11 +-
 net/sched/cls_route.c                              |  11 +-
 net/sched/cls_rsvp.h                               |  11 +-
 net/sched/cls_tcindex.c                            |  11 +-
 net/sched/cls_u32.c                                |  11 +-
 net/sched/ematch.c                                 |   3 +
 net/sched/sch_api.c                                |  47 +++++--
 68 files changed, 591 insertions(+), 218 deletions(-)


