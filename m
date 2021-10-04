Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110A4420BA5
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 14:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbhJDM6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 08:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233660AbhJDM5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 08:57:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 832AB613AD;
        Mon,  4 Oct 2021 12:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352165;
        bh=sONzN0AqyZIzG1xXvXVPKHEz8nVZFonkcj7gYAet4g4=;
        h=From:To:Cc:Subject:Date:From;
        b=YXYEZtwAJ6EySqu72vd8YyS/NjfqK9AACwyyMRbExzylrMNp0StPkbmmYh4BADKIr
         eDKGodnQ1xM+y4yrZMP04VpI/RpbNgF+WE/eHF2/qrGCPwvK6yjnfdfhJXJov5hvTW
         t1bR3KY+NUfijPDg9XgSHcG0/BUoPhV1VJaZ3nsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 00/57] 4.9.285-rc1 review
Date:   Mon,  4 Oct 2021 14:51:44 +0200
Message-Id: <20211004125028.940212411@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.285-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.285-rc1
X-KernelTest-Deadline: 2021-10-06T12:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.285 release.
There are 57 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.285-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.285-rc1

Yanfei Xu <yanfei.xu@windriver.com>
    net: mdiobus: Fix memory leak in __mdiobus_register

Anirudh Rayabharam <mail@anirudhrb.com>
    HID: usbhid: free raw_report buffers in usbhid_stop

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix oversized kvmalloc() calls

F.A.Sulaiman <asha.16@itfac.mrt.ac.lk>
    HID: betop: fix slab-out-of-bounds Write in betop_probe

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: Extend workaround for erratum 1024718 to all versions of Cortex-A55

Alex Sverdlin <alexander.sverdlin@nokia.com>
    ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without DYNAMIC_FTRACE

Alex Sverdlin <alexander.sverdlin@nokia.com>
    ARM: 9079/1: ftrace: Add MODULE_PLTS support

Alex Sverdlin <alexander.sverdlin@nokia.com>
    ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()

Alex Sverdlin <alexander.sverdlin@nokia.com>
    ARM: 9077/1: PLT: Move struct plt_entries definition to header

Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
    EDAC/synopsys: Fix wrong value type assignment for edac_mode

Eric Dumazet <edumazet@google.com>
    net: udp: annotate data race around udp_sk(sk)->corkflag

yangerkun <yangerkun@huawei.com>
    ext4: fix potential infinite loop in ext4_dx_readdir()

Johan Hovold <johan@kernel.org>
    ipack: ipoctal: fix module reference leak

Johan Hovold <johan@kernel.org>
    ipack: ipoctal: fix missing allocation-failure check

Johan Hovold <johan@kernel.org>
    ipack: ipoctal: fix tty-registration error handling

Johan Hovold <johan@kernel.org>
    ipack: ipoctal: fix tty registration race

Johan Hovold <johan@kernel.org>
    ipack: ipoctal: fix stack information leak

Jacob Keller <jacob.e.keller@intel.com>
    e100: fix buffer overrun in e100_get_regs

Jacob Keller <jacob.e.keller@intel.com>
    e100: fix length calculation in e100_get_regs_len

Paul Fertser <fercerpav@gmail.com>
    hwmon: (tmp421) fix rounding for negative values

Lorenzo Bianconi <lorenzo@kernel.org>
    mac80211: limit injected vht mcs/nss in ieee80211_parse_tx_radiotap

Andrea Claudi <aclaudi@redhat.com>
    ipvs: check that ip_vs_conn_tab_bits is between 8 and 20

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix use-after-free in CCMP/GCMP RX

James Morse <james.morse@arm.com>
    cpufreq: schedutil: Destroy mutex before kobject_put() frees the memory

Kevin Hao <haokexin@gmail.com>
    cpufreq: schedutil: Use kobject release() method to free sugov_tunables

Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
    tty: Fix out-of-bound vmalloc access in imageblit

Linus Torvalds <torvalds@linux-foundation.org>
    qnx4: work around gcc false positive warning bug

Pali Rohár <pali@kernel.org>
    arm64: dts: marvell: armada-37xx: Extend PCIe MEM space

Linus Torvalds <torvalds@linux-foundation.org>
    spi: Fix tegra20 build with CONFIG_PM=n

Guenter Roeck <linux@roeck-us.net>
    net: 6pack: Fix tx timeout and slot time

Guenter Roeck <linux@roeck-us.net>
    alpha: Declare virt_to_phys and virt_to_bus parameter as pointer to volatile

Dan Li <ashimida@linux.alibaba.com>
    arm64: Mark __stack_chk_guard as __ro_after_init

Helge Deller <deller@gmx.de>
    parisc: Use absolute_pointer() to define PAGE0

Linus Torvalds <torvalds@linux-foundation.org>
    qnx4: avoid stringop-overread errors

Linus Torvalds <torvalds@linux-foundation.org>
    sparc: avoid stringop-overread errors

Guenter Roeck <linux@roeck-us.net>
    net: i825xx: Use absolute_pointer for memcpy from fixed memory location

Guenter Roeck <linux@roeck-us.net>
    compiler.h: Introduce absolute_pointer macro

Guenter Roeck <linux@roeck-us.net>
    m68k: Double cast io functions to unsigned long

Jesper Nilsson <jesper.nilsson@axis.com>
    net: stmmac: allow CSR clock of 300MHz

Zhihao Cheng <chengzhihao1@huawei.com>
    blktrace: Fix uaf in blk_trace access after removing by sysfs

Baokun Li <libaokun1@huawei.com>
    scsi: iscsi: Adjust iface sysfs attr detection

Aya Levin <ayal@nvidia.com>
    net/mlx4_en: Don't allow aRFS for encapsulated packets

Johan Hovold <johan@kernel.org>
    net: hso: fix muxed tty registration

Pali Rohár <pali@kernel.org>
    serial: mvebu-uart: fix driver's tx_empty callback

Dan Carpenter <dan.carpenter@oracle.com>
    mcb: fix error handling in mcb_alloc_bus()

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add device id for Foxconn T99W265

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    USB: serial: option: remove duplicate USB device ID

Carlo Lobrano <c.lobrano@gmail.com>
    USB: serial: option: add Telit LN920 compositions

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    USB: serial: mos7840: remove duplicated 0xac24 device ID

Johan Hovold <johan@kernel.org>
    staging: greybus: uart: fix tty use after free

Uwe Brandt <uwe.brandt@gmail.com>
    USB: serial: cp210x: add ID for GW Instek GDM-834x Digital Multimeter

Ondrej Zary <linux@zary.sk>
    usb-storage: Add quirk for ScanLogic SL11R-IDE older than 2.6c

Jan Beulich <jbeulich@suse.com>
    xen/x86: fix PV trap handling on secondary processors

Steve French <stfrench@microsoft.com>
    cifs: fix incorrect check for null pointer in header_assemble

Dan Carpenter <dan.carpenter@oracle.com>
    usb: musb: tusb6010: uninitialized data in tusb_fifo_write_unaligned()

Dan Carpenter <dan.carpenter@oracle.com>
    usb: gadget: r8a66597: fix a loop in set_feature()

Wengang Wang <wen.gang.wang@oracle.com>
    ocfs2: drop acl cache for directories too


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/alpha/include/asm/io.h                       |  6 +-
 arch/arm/include/asm/ftrace.h                     |  3 +
 arch/arm/include/asm/insn.h                       |  8 +--
 arch/arm/include/asm/module.h                     | 10 ++++
 arch/arm/kernel/ftrace.c                          | 45 ++++++++++++---
 arch/arm/kernel/insn.c                            | 19 ++++---
 arch/arm/kernel/module-plts.c                     | 49 ++++++++++++----
 arch/arm64/Kconfig                                |  2 +-
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi      | 11 +++-
 arch/arm64/kernel/process.c                       |  2 +-
 arch/arm64/mm/proc.S                              |  4 +-
 arch/m68k/include/asm/raw_io.h                    | 20 +++----
 arch/parisc/include/asm/page.h                    |  2 +-
 arch/sparc/kernel/mdesc.c                         |  3 +-
 arch/x86/xen/enlighten.c                          | 15 +++--
 drivers/cpufreq/cpufreq_governor_attr_set.c       |  2 +-
 drivers/edac/synopsys_edac.c                      |  2 +-
 drivers/hid/hid-betopff.c                         | 13 ++++-
 drivers/hid/usbhid/hid-core.c                     | 13 ++++-
 drivers/hwmon/tmp421.c                            | 24 +++-----
 drivers/ipack/devices/ipoctal.c                   | 63 +++++++++++++++------
 drivers/mcb/mcb-core.c                            | 12 ++--
 drivers/net/ethernet/i825xx/82596.c               |  2 +-
 drivers/net/ethernet/intel/e100.c                 | 22 +++++---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c    |  3 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  2 +-
 drivers/net/hamradio/6pack.c                      |  4 +-
 drivers/net/phy/mdio_bus.c                        |  1 +
 drivers/net/usb/hso.c                             | 12 ++--
 drivers/scsi/scsi_transport_iscsi.c               |  8 +--
 drivers/spi/spi-tegra20-slink.c                   |  4 +-
 drivers/staging/greybus/uart.c                    | 62 ++++++++++----------
 drivers/tty/serial/mvebu-uart.c                   |  2 +-
 drivers/tty/vt/vt.c                               | 21 ++++++-
 drivers/usb/gadget/udc/r8a66597-udc.c             |  2 +-
 drivers/usb/musb/tusb6010.c                       |  1 +
 drivers/usb/serial/cp210x.c                       |  1 +
 drivers/usb/serial/mos7840.c                      |  2 -
 drivers/usb/serial/option.c                       | 11 +++-
 drivers/usb/storage/unusual_devs.h                |  9 ++-
 fs/cifs/connect.c                                 |  5 +-
 fs/ext4/dir.c                                     |  6 +-
 fs/ocfs2/dlmglue.c                                |  3 +-
 fs/qnx4/dir.c                                     | 69 +++++++++++++++++------
 include/linux/compiler.h                          |  2 +
 kernel/sched/cpufreq_schedutil.c                  | 16 ++++--
 kernel/trace/blktrace.c                           |  8 +++
 net/ipv4/udp.c                                    | 10 ++--
 net/ipv6/udp.c                                    |  2 +-
 net/mac80211/tx.c                                 |  4 ++
 net/mac80211/wpa.c                                |  6 ++
 net/netfilter/ipset/ip_set_hash_gen.h             |  4 +-
 net/netfilter/ipvs/ip_vs_conn.c                   |  4 ++
 54 files changed, 438 insertions(+), 202 deletions(-)


