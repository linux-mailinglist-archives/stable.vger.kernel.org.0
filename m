Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323D31F435A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732919AbgFIRwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732908AbgFIRwf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:52:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE1212074B;
        Tue,  9 Jun 2020 17:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725154;
        bh=7MiBdfNFGwF11Enjt2LeYmNCk2mdnJnELpIjBs0LCXQ=;
        h=From:To:Cc:Subject:Date:From;
        b=qiB7lbIHodXmUhXtLj8eq4bz04oRuY9H1nJDgNsYsYFUcii+8+RHv3gkBu+Q39WAZ
         iIQYntKJHJpcWSJfQe68yvcZOwYGTWr4muWRaLfZ99N4VSpGjrxMwm2kKQrDWjD+YI
         HRiLyEFiY2Co/FSYJW48+NjbvPVMJft+hyGwsEVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/34] 5.4.46-rc1 review
Date:   Tue,  9 Jun 2020 19:44:56 +0200
Message-Id: <20200609174052.628006868@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.46-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.46-rc1
X-KernelTest-Deadline: 2020-06-11T17:40+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.46 release.
There are 34 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 11 Jun 2020 17:40:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.46-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.46-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net/mlx5: Annotate mutex destroy for root ns"

Oleg Nesterov <oleg@redhat.com>
    uprobes: ensure that uprobe->offset and ->ref_ctr_offset are properly aligned

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

Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
    x86/speculation/spectre_v2: Exclude Zhaoxin CPUs from SPECTRE_V2

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    nvmem: qfprom: remove incorrect write support

Oliver Neukum <oneukum@suse.com>
    CDC-ACM: heed quirk also in error handling

Pascal Terjan <pterjan@google.com>
    staging: rtl8712: Fix IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK

Jiri Slaby <jslaby@suse.cz>
    tty: hvc_console, fix crashes on parallel open/close

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    vt: keyboard: avoid signed integer overflow in k_ascii

Dinghao Liu <dinghao.liu@zju.edu.cn>
    usb: musb: Fix runtime PM imbalance on error

Bin Liu <b-liu@ti.com>
    usb: musb: start session in resume for host port

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: adc: stm32-adc: fix a wrong error message when probing interrupts

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:chemical:pms7003: Fix timestamp alignment and prevent data leak.

Mathieu Othacehe <m.othacehe@gmail.com>
    iio: vcnl4000: Fix i2c swapped word reading.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:chemical:sps30: Fix timestamp alignment

Michael Hanselmann <public@hansmi.ch>
    USB: serial: ch341: add basis for quirk detection

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit LE910C1-EUX compositions

Bin Liu <b-liu@ti.com>
    USB: serial: usb_wwan: do not resubmit rx urb on fatal errors

Matt Jolly <Kangie@footclan.ninja>
    USB: serial: qcserial: add DW5816e QDL support

Eric Dumazet <edumazet@google.com>
    net: be more gentle about silly gso requests coming from user

Willem de Bruijn <willemb@google.com>
    net: check untrusted gso_size at kernel entry

Stefano Garzarella <sgarzare@redhat.com>
    vsock: fix timeout in vsock_accept()

Heinrich Kuhn <heinrich.kuhn@netronome.com>
    nfp: flower: fix used time of merge flow statistics

Chuhong Yuan <hslester96@gmail.com>
    NFC: st21nfca: add missed kfree_skb() in an error path

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit LE910C1-EUX composition

Fugang Duan <fugang.duan@nxp.com>
    net: stmmac: enable timestamp snapshot for required PTP packets in dwmac v5.10a

Mark Bloch <markb@mellanox.com>
    net/mlx5: Fix crash upon suspend/resume

Eric Dumazet <edumazet@google.com>
    l2tp: do not use inet_hash()/inet_unhash()

Eric Dumazet <edumazet@google.com>
    l2tp: add sk_family checks to l2tp_validate_socket

Yang Yingliang <yangyingliang@huawei.com>
    devinet: fix memleak in inetdev_init()


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-system-cpu |   1 +
 Documentation/admin-guide/hw-vuln/index.rst        |   1 +
 .../special-register-buffer-data-sampling.rst      | 149 +++++++++++++++++++++
 Documentation/admin-guide/kernel-parameters.txt    |  20 +++
 Makefile                                           |   4 +-
 arch/x86/include/asm/cpu_device_id.h               |  30 +++++
 arch/x86/include/asm/cpufeatures.h                 |   2 +
 arch/x86/include/asm/msr-index.h                   |   4 +
 arch/x86/kernel/cpu/bugs.c                         | 106 +++++++++++++++
 arch/x86/kernel/cpu/common.c                       |  63 +++++++--
 arch/x86/kernel/cpu/cpu.h                          |   1 +
 arch/x86/kernel/cpu/match.c                        |   7 +-
 drivers/base/cpu.c                                 |   8 ++
 drivers/iio/adc/stm32-adc-core.c                   |  34 ++---
 drivers/iio/chemical/pms7003.c                     |  17 ++-
 drivers/iio/chemical/sps30.c                       |   9 +-
 drivers/iio/light/vcnl4000.c                       |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   6 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  18 +++
 .../net/ethernet/netronome/nfp/flower/offload.c    |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   3 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/nfc/st21nfca/dep.c                         |   4 +-
 drivers/nvmem/qfprom.c                             |  14 --
 drivers/staging/rtl8712/wifi.h                     |   9 +-
 drivers/tty/hvc/hvc_console.c                      |  23 ++--
 drivers/tty/vt/keyboard.c                          |  26 ++--
 drivers/usb/class/cdc-acm.c                        |   2 +-
 drivers/usb/musb/musb_core.c                       |   7 +
 drivers/usb/musb/musb_debugfs.c                    |  10 +-
 drivers/usb/serial/ch341.c                         |  53 ++++++++
 drivers/usb/serial/option.c                        |   4 +
 drivers/usb/serial/qcserial.c                      |   1 +
 drivers/usb/serial/usb_wwan.c                      |   4 +
 include/linux/mod_devicetable.h                    |   6 +
 include/linux/virtio_net.h                         |  25 +++-
 kernel/events/uprobes.c                            |  16 ++-
 net/ipv4/devinet.c                                 |   1 +
 net/l2tp/l2tp_core.c                               |   3 +
 net/l2tp/l2tp_ip.c                                 |  29 +++-
 net/l2tp/l2tp_ip6.c                                |  30 +++--
 net/vmw_vsock/af_vsock.c                           |   2 +-
 42 files changed, 627 insertions(+), 135 deletions(-)


