Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495A51F453A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388245AbgFISNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:13:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732778AbgFIRvH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:51:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4A3F2074B;
        Tue,  9 Jun 2020 17:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725066;
        bh=LmDXrdnTdQZE3STrw+xTiFWz36crARbNW12eODsSAX4=;
        h=From:To:Cc:Subject:Date:From;
        b=i8xsn+eMif3EnGBbP927n3mgaLMEjTcAt3n//f8DZjmgPm2NKrgaokdXGaQud98pK
         N0HuoCetbQNXjc/rbjJCer8yM+0PDdFj0COSXjwIFK+rak12MFL8l69el61TOrEJIi
         DGkz+x2S4f5a5wYC+VJG/euGmjLG7RYiHQp3iwEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/25] 4.19.128-rc1 review
Date:   Tue,  9 Jun 2020 19:44:50 +0200
Message-Id: <20200609174048.576094775@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.128-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.128-rc1
X-KernelTest-Deadline: 2020-06-11T17:40+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.128 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 11 Jun 2020 17:40:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.128-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.128-rc1

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

Dinghao Liu <dinghao.liu@zju.edu.cn>
    usb: musb: Fix runtime PM imbalance on error

Bin Liu <b-liu@ti.com>
    usb: musb: start session in resume for host port

Mathieu Othacehe <m.othacehe@gmail.com>
    iio: vcnl4000: Fix i2c swapped word reading.

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit LE910C1-EUX compositions

Bin Liu <b-liu@ti.com>
    USB: serial: usb_wwan: do not resubmit rx urb on fatal errors

Matt Jolly <Kangie@footclan.ninja>
    USB: serial: qcserial: add DW5816e QDL support

Willem de Bruijn <willemb@google.com>
    net: check untrusted gso_size at kernel entry

Stefano Garzarella <sgarzare@redhat.com>
    vsock: fix timeout in vsock_accept()

Chuhong Yuan <hslester96@gmail.com>
    NFC: st21nfca: add missed kfree_skb() in an error path

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit LE910C1-EUX composition

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
 arch/x86/include/asm/cpu_device_id.h               |  27 ++++
 arch/x86/include/asm/cpufeatures.h                 |   2 +
 arch/x86/include/asm/msr-index.h                   |   4 +
 arch/x86/kernel/cpu/bugs.c                         | 106 +++++++++++++++
 arch/x86/kernel/cpu/common.c                       |  54 ++++++--
 arch/x86/kernel/cpu/cpu.h                          |   1 +
 arch/x86/kernel/cpu/match.c                        |   7 +-
 drivers/base/cpu.c                                 |   8 ++
 drivers/iio/light/vcnl4000.c                       |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   6 -
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/nfc/st21nfca/dep.c                         |   4 +-
 drivers/nvmem/qfprom.c                             |  14 --
 drivers/staging/rtl8712/wifi.h                     |   9 +-
 drivers/tty/hvc/hvc_console.c                      |  23 ++--
 drivers/tty/vt/keyboard.c                          |  26 ++--
 drivers/usb/class/cdc-acm.c                        |   2 +-
 drivers/usb/musb/musb_core.c                       |   7 +
 drivers/usb/musb/musb_debugfs.c                    |  10 +-
 drivers/usb/serial/option.c                        |   4 +
 drivers/usb/serial/qcserial.c                      |   1 +
 drivers/usb/serial/usb_wwan.c                      |   4 +
 include/linux/mod_devicetable.h                    |   6 +
 include/linux/virtio_net.h                         |  14 +-
 kernel/events/uprobes.c                            |  16 ++-
 net/ipv4/devinet.c                                 |   1 +
 net/l2tp/l2tp_core.c                               |   3 +
 net/l2tp/l2tp_ip.c                                 |  29 +++-
 net/l2tp/l2tp_ip6.c                                |  30 +++--
 net/vmw_vsock/af_vsock.c                           |   2 +-
 35 files changed, 503 insertions(+), 99 deletions(-)


