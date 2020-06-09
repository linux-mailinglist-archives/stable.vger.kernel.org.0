Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAED1F4437
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732754AbgFISCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731768AbgFIRxf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:53:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21FA12074B;
        Tue,  9 Jun 2020 17:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725214;
        bh=M2qvBWuNsEMskpaQiCnMGc5yfr7IKHfgPpFxMoxMCnc=;
        h=From:To:Cc:Subject:Date:From;
        b=quT6YKfVWrUDuEaNqZrUMzVBlyHklLHCKtMFmC3ymRuU+HE6uW/R4/vnZIZBzVsku
         9P9CjNsQmehNext5K9YZbpz849NckYat/XRoqbiweweGCQjF+bYoeIAjwUl9VspUkx
         7yiEjvyGd2uYdnOs6VU4ZPCrJ+ut0NoghrHNMgoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.6 00/41] 5.6.18-rc1 review
Date:   Tue,  9 Jun 2020 19:45:02 +0200
Message-Id: <20200609174112.129412236@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.6.18-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.6.18-rc1
X-KernelTest-Deadline: 2020-06-11T17:41+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.6.18 release.
There are 41 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 11 Jun 2020 17:40:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.18-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.6.18-rc1

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

Josh Triplett <josh@joshtriplett.org>
    serial: 8250: Enable 16550A variants by default on non-x86

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

Johan Hovold <johan@kernel.org>
    USB: serial: ch341: fix lockup of devices with limited prescaler

Michael Hanselmann <public@hansmi.ch>
    USB: serial: ch341: add basis for quirk detection

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit LE910C1-EUX compositions

Bin Liu <b-liu@ti.com>
    USB: serial: usb_wwan: do not resubmit rx urb on fatal errors

Matt Jolly <Kangie@footclan.ninja>
    USB: serial: qcserial: add DW5816e QDL support

Pablo Neira Ayuso <pablo@netfilter.org>
    net/mlx5e: replace EINVAL in mlx5e_flower_parse_meta()

Davide Caratti <dcaratti@redhat.com>
    net/sched: fix infinite loop in sch_fq_pie

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix unblocking connect()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: send VLANs on CPU port as egress-tagged

Eric Dumazet <edumazet@google.com>
    net: be more gentle about silly gso requests coming from user

Stefano Garzarella <sgarzare@redhat.com>
    vsock: fix timeout in vsock_accept()

Jia He <justin.he@arm.com>
    virtio_vsock: Fix race condition in virtio_transport_recv_pkt

Jonas Falkevik <jonas.falkevik@gmail.com>
    sctp: check assoc before SCTP_ADDR_{MADE_PRIM, ADDED} event

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

Willem de Bruijn <willemb@google.com>
    net: check untrusted gso_size at kernel entry

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
 arch/x86/kernel/cpu/common.c                       |  56 ++++++--
 arch/x86/kernel/cpu/cpu.h                          |   1 +
 arch/x86/kernel/cpu/match.c                        |   7 +-
 drivers/base/cpu.c                                 |   8 ++
 drivers/iio/adc/stm32-adc-core.c                   |  34 ++---
 drivers/iio/chemical/pms7003.c                     |  17 ++-
 drivers/iio/chemical/sps30.c                       |   9 +-
 drivers/iio/light/vcnl4000.c                       |   6 +-
 drivers/net/dsa/ocelot/felix.c                     |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   6 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  18 +++
 .../net/ethernet/netronome/nfp/flower/offload.c    |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   3 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/nfc/st21nfca/dep.c                         |   4 +-
 drivers/nvmem/qfprom.c                             |  14 --
 drivers/staging/rtl8712/wifi.h                     |   9 +-
 drivers/tty/hvc/hvc_console.c                      |  23 ++--
 drivers/tty/serial/8250/Kconfig                    |   1 +
 drivers/tty/vt/keyboard.c                          |  26 ++--
 drivers/usb/class/cdc-acm.c                        |   2 +-
 drivers/usb/musb/musb_core.c                       |   7 +
 drivers/usb/musb/musb_debugfs.c                    |  10 +-
 drivers/usb/serial/ch341.c                         |  68 +++++++++-
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
 net/mptcp/protocol.c                               |  20 ++-
 net/sched/sch_fq_pie.c                             |   4 +-
 net/sctp/ulpevent.c                                |   3 +
 net/vmw_vsock/af_vsock.c                           |   2 +-
 net/vmw_vsock/virtio_transport_common.c            |   8 ++
 .../tc-testing/tc-tests/qdiscs/fq_pie.json         |  21 +++
 50 files changed, 694 insertions(+), 147 deletions(-)


