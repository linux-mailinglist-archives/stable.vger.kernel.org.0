Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE501F45C4
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732361AbgFIRsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:48:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732347AbgFIRsi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:48:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EE4F20814;
        Tue,  9 Jun 2020 17:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724918;
        bh=qVusIl9MWTWvLpOaetoz+Ss0QNK073Cq9BnK6rVU8Qc=;
        h=From:To:Cc:Subject:Date:From;
        b=DLxlG/Us7fpxIXIeV4xSKUOAjXrOc15iYZ4Ty5GQCdzSa7UnWeK1QhzpfCfvj9jPs
         K9yioXuv7XChZEyvgOBoUULvkwo7Kvyb0BV3paUhHLyi3nzCJ01vVj4sw2AV50O8+D
         CwBeFlzEuL9EyFmEqCQyLhLXLHJIz7jtfaJnNRFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/42] 4.9.227-rc1 review
Date:   Tue,  9 Jun 2020 19:44:06 +0200
Message-Id: <20200609174015.379493548@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.227-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.227-rc1
X-KernelTest-Deadline: 2020-06-11T17:40+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.227 release.
There are 42 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 11 Jun 2020 17:39:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.227-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.227-rc1

Oleg Nesterov <oleg@redhat.com>
    uprobes: ensure that uprobe->offset and ->ref_ctr_offset are properly aligned

Mathieu Othacehe <m.othacehe@gmail.com>
    iio: vcnl4000: Fix i2c swapped word reading.

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation: Add Ivy Bridge to affected list

Mark Gross <mgross@linux.intel.com>
    x86/speculation: Add SRBDS vulnerability and mitigation documentation

Mark Gross <mgross@linux.intel.com>
    x86/speculation: Add Special Register Buffer Data Sampling (SRBDS) mitigation

Mark Gross <mgross@linux.intel.com>
    x86/cpu: Add 'table' argument to cpu_matches()

Mark Gross <mgross@linux.intel.com>
    x86/cpu: Add a steppings field to struct x86_cpu_id

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    nvmem: qfprom: remove incorrect write support

Pascal Terjan <pterjan@google.com>
    staging: rtl8712: Fix IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK

Jiri Slaby <jslaby@suse.cz>
    tty: hvc_console, fix crashes on parallel open/close

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    vt: keyboard: avoid signed integer overflow in k_ascii

Dinghao Liu <dinghao.liu@zju.edu.cn>
    usb: musb: Fix runtime PM imbalance on error

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit LE910C1-EUX compositions

Bin Liu <b-liu@ti.com>
    USB: serial: usb_wwan: do not resubmit rx urb on fatal errors

Matt Jolly <Kangie@footclan.ninja>
    USB: serial: qcserial: add DW5816e QDL support

Eric Dumazet <edumazet@google.com>
    l2tp: add sk_family checks to l2tp_validate_socket

Stefano Garzarella <sgarzare@redhat.com>
    vsock: fix timeout in vsock_accept()

Chuhong Yuan <hslester96@gmail.com>
    NFC: st21nfca: add missed kfree_skb() in an error path

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit LE910C1-EUX composition

Eric Dumazet <edumazet@google.com>
    l2tp: do not use inet_hash()/inet_unhash()

Yang Yingliang <yangyingliang@huawei.com>
    devinet: fix memleak in inetdev_init()

Dan Carpenter <dan.carpenter@oracle.com>
    airo: Fix read overflows sending packets

Can Guo <cang@codeaurora.org>
    scsi: ufs: Release clock if DMA map fails

yangerkun <yangerkun@huawei.com>
    slip: not call free_netdev before rtnl_unlock in slip_open

Ben Hutchings <ben@decadent.org.uk>
    slcan: Fix double-free on slcan_open() error path

Jérôme Pouiller <jerome.pouiller@silabs.com>
    mmc: fix compilation of user API

Daniel Axtens <dja@axtens.net>
    kernel/relay.c: handle alloc_percpu returning NULL in relay_open

Giuseppe Marco Randazzo <gmrandazzo@gmail.com>
    p54usb: add AirVasT USB stick device-id

Julian Sax <jsbc@gmx.de>
    HID: i2c-hid: add Schneider SCL142ALM to descriptor override

Fan Yang <Fan_Yang@sjtu.edu.cn>
    mm: Fix mremap not considering huge pmd devmap

Guillaume Nault <gnault@redhat.com>
    pppoe: only process PADT targeted at local interfaces

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net: smsc911x: Fix runtime PM imbalance on error

Jonathan McDowell <noodles@earth.li>
    net: ethernet: stmmac: Enable interface clocks on probe for IPQ806x

Valentin Longchamp <valentin@longchamp.me>
    net/ethernet/freescale: rework quiesce/activate for ucc_geth

Jeremy Kerr <jk@ozlabs.org>
    net: bmac: Fix read of MAC address from ROM

Nathan Chancellor <natechancellor@gmail.com>
    x86/mmiotrace: Use cpumask_available() for cpumask_var_t variables

Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
    ARC: Fix ICCM & DCCM runtime size checks

Vasily Gorbik <gor@linux.ibm.com>
    s390/ftrace: save traced function caller

Xinwei Kong <kong.kongxinwei@hisilicon.com>
    spi: dw: use "smp_mb()" to avoid sending spi data error

Zhen Lei <thunder.leizhen@huawei.com>
    esp6: fix memleak on error path in esp6_input

Eugeniu Rosca <erosca@de.adit-jv.com>
    usb: gadget: f_uac2: fix error handling in afunc_bind (again)

Hannes Reinecke <hare@suse.de>
    scsi: scsi_devinfo: fixup string compare


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-system-cpu |   1 +
 Documentation/hw-vuln/index.rst                    |   3 +-
 .../special-register-buffer-data-sampling.rst      | 149 +++++++++++++++++++++
 Documentation/kernel-parameters.txt                |  20 +++
 Makefile                                           |   4 +-
 arch/arc/kernel/setup.c                            |   5 +-
 arch/s390/kernel/mcount.S                          |   1 +
 arch/x86/include/asm/cpu_device_id.h               |  27 ++++
 arch/x86/include/asm/cpufeatures.h                 |  30 +++--
 arch/x86/include/asm/msr-index.h                   |   4 +
 arch/x86/include/asm/pgtable.h                     |   1 +
 arch/x86/kernel/cpu/bugs.c                         | 106 +++++++++++++++
 arch/x86/kernel/cpu/common.c                       |  54 ++++++--
 arch/x86/kernel/cpu/cpu.h                          |   1 +
 arch/x86/kernel/cpu/match.c                        |   7 +-
 arch/x86/mm/mmio-mod.c                             |   4 +-
 drivers/base/cpu.c                                 |   8 ++
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |   8 ++
 drivers/iio/light/vcnl4000.c                       |   6 +-
 drivers/net/can/slcan.c                            |   3 +-
 drivers/net/ethernet/apple/bmac.c                  |   2 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |  13 +-
 drivers/net/ethernet/smsc/smsc911x.c               |   9 +-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |  13 ++
 drivers/net/ppp/pppoe.c                            |   3 +
 drivers/net/slip/slip.c                            |   3 +
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/cisco/airo.c                  |  12 ++
 drivers/net/wireless/intersil/p54/p54usb.c         |   1 +
 drivers/nfc/st21nfca/dep.c                         |   4 +-
 drivers/nvmem/qfprom.c                             |  14 --
 drivers/scsi/scsi_devinfo.c                        |  23 ++--
 drivers/scsi/ufs/ufshcd.c                          |   1 +
 drivers/spi/spi-dw.c                               |   3 +
 drivers/staging/rtl8712/wifi.h                     |   9 +-
 drivers/tty/hvc/hvc_console.c                      |  23 ++--
 drivers/tty/vt/keyboard.c                          |  26 ++--
 drivers/usb/gadget/function/f_uac2.c               |   4 +-
 drivers/usb/musb/musb_debugfs.c                    |  10 +-
 drivers/usb/serial/option.c                        |   4 +
 drivers/usb/serial/qcserial.c                      |   1 +
 drivers/usb/serial/usb_wwan.c                      |   4 +
 include/linux/mod_devicetable.h                    |   6 +
 include/uapi/linux/mmc/ioctl.h                     |   1 +
 kernel/events/uprobes.c                            |  16 ++-
 kernel/relay.c                                     |   5 +
 mm/mremap.c                                        |   2 +-
 net/ipv4/devinet.c                                 |   1 +
 net/ipv6/esp6.c                                    |   4 +-
 net/l2tp/l2tp_core.c                               |   2 +
 net/l2tp/l2tp_ip.c                                 |  29 +++-
 net/l2tp/l2tp_ip6.c                                |  30 +++--
 net/vmw_vsock/af_vsock.c                           |   2 +-
 53 files changed, 587 insertions(+), 136 deletions(-)


