Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6B91F46EB
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 21:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbgFITSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 15:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729318AbgFITSK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 15:18:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9733206D5;
        Tue,  9 Jun 2020 19:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591730289;
        bh=1wA2k3/8+BeB5vO72LER7S0mPUOOUaUUFt8UVAI8SO8=;
        h=From:To:Cc:Subject:Date:From;
        b=f+OmPaYMHWno/oHZNyUe2ye1Gd/+9KMqVQCjrKb92CZNe5fWZfp9WgpfJFgdan3ZV
         A75w/OtfUY1SggYND675XSBSoyjhnHkRtTUg91G9F7mJGN7pJjUNPIvQ0/MKej914s
         2KPH25wFZBT9AOiKxLoBpU8ffpauFDHG7PoKgeZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/36] 4.4.227-rc2 review
Date:   Tue,  9 Jun 2020 21:18:06 +0200
Message-Id: <20200609190211.793882726@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.227-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.227-rc2
X-KernelTest-Deadline: 2020-06-11T19:02+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.227 release.
There are 36 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 11 Jun 2020 19:02:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.227-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.227-rc2

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

Jia Zhang <qianyue.zj@alibaba-inc.com>
    x86/cpu: Rename cpu_data.x86_mask to cpu_data.x86_stepping

Pascal Terjan <pterjan@google.com>
    staging: rtl8712: Fix IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    vt: keyboard: avoid signed integer overflow in k_ascii

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit LE910C1-EUX compositions

Bin Liu <b-liu@ti.com>
    USB: serial: usb_wwan: do not resubmit rx urb on fatal errors

Matt Jolly <Kangie@footclan.ninja>
    USB: serial: qcserial: add DW5816e QDL support

Eric Dumazet <edumazet@google.com>
    l2tp: do not use inet_hash()/inet_unhash()

Eric Dumazet <edumazet@google.com>
    l2tp: add sk_family checks to l2tp_validate_socket

Stefano Garzarella <sgarzare@redhat.com>
    vsock: fix timeout in vsock_accept()

Chuhong Yuan <hslester96@gmail.com>
    NFC: st21nfca: add missed kfree_skb() in an error path

Yang Yingliang <yangyingliang@huawei.com>
    devinet: fix memleak in inetdev_init()

Can Guo <cang@codeaurora.org>
    scsi: ufs: Release clock if DMA map fails

yangerkun <yangerkun@huawei.com>
    slip: not call free_netdev before rtnl_unlock in slip_open

Ben Hutchings <ben@decadent.org.uk>
    slcan: Fix double-free on slcan_open() error path

Jérôme Pouiller <jerome.pouiller@silabs.com>
    mmc: fix compilation of user API

Guillaume Nault <gnault@redhat.com>
    pppoe: only process PADT targeted at local interfaces

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

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - No loopback on ALC299 codec

Christophe Jaillet <christophe.jaillet@wanadoo.fr>
    IB/mlx4: Fix an error handling path in 'mlx4_ib_rereg_user_mr()'

Zhen Lei <thunder.leizhen@huawei.com>
    esp6: fix memleak on error path in esp6_input

Lee, Chun-Yi <joeyli.kernel@gmail.com>
    platform/x86: acer-wmi: setup accelerometer when ACPI device was found

Eugeniu Rosca <erosca@de.adit-jv.com>
    usb: gadget: f_uac2: fix error handling in afunc_bind (again)

Hannes Reinecke <hare@suse.de>
    scsi: scsi_devinfo: fixup string compare


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-system-cpu |   1 +
 .../special-register-buffer-data-sampling.rst      | 149 +++++++++++++++++++++
 Documentation/kernel-parameters.txt                |  20 +++
 Makefile                                           |   4 +-
 arch/arc/kernel/setup.c                            |   5 +-
 arch/s390/kernel/mcount.S                          |   1 +
 arch/x86/include/asm/acpi.h                        |   2 +-
 arch/x86/include/asm/cpu_device_id.h               |  27 ++++
 arch/x86/include/asm/cpufeatures.h                 |   2 +
 arch/x86/include/asm/msr-index.h                   |   4 +
 arch/x86/include/asm/processor.h                   |   2 +-
 arch/x86/kernel/amd_nb.c                           |   2 +-
 arch/x86/kernel/asm-offsets_32.c                   |   2 +-
 arch/x86/kernel/cpu/amd.c                          |  26 ++--
 arch/x86/kernel/cpu/bugs.c                         | 106 +++++++++++++++
 arch/x86/kernel/cpu/centaur.c                      |   4 +-
 arch/x86/kernel/cpu/common.c                       |  62 +++++++--
 arch/x86/kernel/cpu/cpu.h                          |   1 +
 arch/x86/kernel/cpu/cyrix.c                        |   2 +-
 arch/x86/kernel/cpu/intel.c                        |  20 +--
 arch/x86/kernel/cpu/match.c                        |   7 +-
 arch/x86/kernel/cpu/microcode/intel.c              |   4 +-
 arch/x86/kernel/cpu/mtrr/generic.c                 |   2 +-
 arch/x86/kernel/cpu/mtrr/main.c                    |   4 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |   2 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c         |   2 +-
 arch/x86/kernel/cpu/perf_event_p6.c                |   2 +-
 arch/x86/kernel/cpu/proc.c                         |   4 +-
 arch/x86/kernel/head_32.S                          |   4 +-
 arch/x86/kernel/mpparse.c                          |   2 +-
 arch/x86/mm/mmio-mod.c                             |   4 +-
 drivers/base/cpu.c                                 |   8 ++
 drivers/char/hw_random/via-rng.c                   |   2 +-
 drivers/cpufreq/acpi-cpufreq.c                     |   2 +-
 drivers/cpufreq/longhaul.c                         |   6 +-
 drivers/cpufreq/p4-clockmod.c                      |   2 +-
 drivers/cpufreq/powernow-k7.c                      |   2 +-
 drivers/cpufreq/speedstep-centrino.c               |   4 +-
 drivers/cpufreq/speedstep-lib.c                    |   6 +-
 drivers/crypto/padlock-aes.c                       |   2 +-
 drivers/edac/amd64_edac.c                          |   2 +-
 drivers/edac/mce_amd.c                             |   2 +-
 drivers/hwmon/coretemp.c                           |   6 +-
 drivers/hwmon/hwmon-vid.c                          |   2 +-
 drivers/hwmon/k10temp.c                            |   2 +-
 drivers/hwmon/k8temp.c                             |   2 +-
 drivers/iio/light/vcnl4000.c                       |   6 +-
 drivers/infiniband/hw/mlx4/mr.c                    |   7 +-
 drivers/net/can/slcan.c                            |   3 +-
 drivers/net/ethernet/apple/bmac.c                  |   2 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |  13 +-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |  13 ++
 drivers/net/ppp/pppoe.c                            |   3 +
 drivers/net/slip/slip.c                            |   3 +
 drivers/nfc/st21nfca/dep.c                         |   4 +-
 drivers/platform/x86/acer-wmi.c                    |   9 +-
 drivers/scsi/scsi_devinfo.c                        |  23 ++--
 drivers/scsi/ufs/ufshcd.c                          |   1 +
 drivers/spi/spi-dw.c                               |   3 +
 drivers/staging/rtl8712/wifi.h                     |   9 +-
 drivers/tty/vt/keyboard.c                          |  26 ++--
 drivers/usb/gadget/function/f_uac2.c               |   4 +-
 drivers/usb/serial/option.c                        |   4 +
 drivers/usb/serial/qcserial.c                      |   1 +
 drivers/usb/serial/usb_wwan.c                      |   4 +
 drivers/video/fbdev/geode/video_gx.c               |   2 +-
 include/linux/mod_devicetable.h                    |   6 +
 include/uapi/linux/mmc/ioctl.h                     |   1 +
 kernel/events/uprobes.c                            |  14 +-
 net/ipv4/devinet.c                                 |   1 +
 net/ipv6/esp6.c                                    |   4 +-
 net/l2tp/l2tp_core.c                               |   2 +
 net/l2tp/l2tp_ip.c                                 |  28 +++-
 net/l2tp/l2tp_ip6.c                                |  28 +++-
 net/vmw_vsock/af_vsock.c                           |   2 +-
 sound/pci/hda/patch_realtek.c                      |   3 +
 76 files changed, 601 insertions(+), 157 deletions(-)


