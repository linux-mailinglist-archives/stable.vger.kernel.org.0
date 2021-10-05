Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4B74220E8
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 10:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhJEIjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 04:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230526AbhJEIjs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 04:39:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0CAB61130;
        Tue,  5 Oct 2021 08:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633423078;
        bh=ch25ZyoSC4A/2UySrYo9vkFVpGLP3S3g3Kq3k6vSlOk=;
        h=From:To:Cc:Subject:Date:From;
        b=wtaRPz3OgO836NpyEXSJSzHcqgqboZDCHB9fqdi2NnTIsUPEQ8KHe6sCeOI+b8izx
         7ol5JlmNAaVqIPs1jwNTKTSaV8nICJoy7tBtI02nJpTygw7t+BhEytqwCFKLcXUFXw
         DFfx9q4nQUPoJ0Yu/95frs/Cbx+kpQXfa34DcPuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/41] 4.4.286-rc2 review
Date:   Tue,  5 Oct 2021 10:37:55 +0200
Message-Id: <20211005083253.853051879@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.286-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.286-rc2
X-KernelTest-Deadline: 2021-10-07T08:32+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.286 release.
There are 41 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.286-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.286-rc2

NeilBrown <neilb@suse.com>
    cred: allow get_cred() and put_cred() to be given NULL.

Anirudh Rayabharam <mail@anirudhrb.com>
    HID: usbhid: free raw_report buffers in usbhid_stop

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix oversized kvmalloc() calls

F.A.Sulaiman <asha.16@itfac.mrt.ac.lk>
    HID: betop: fix slab-out-of-bounds Write in betop_probe

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: Extend workaround for erratum 1024718 to all versions of Cortex-A55

Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
    EDAC/synopsys: Fix wrong value type assignment for edac_mode

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

Andrea Claudi <aclaudi@redhat.com>
    ipvs: check that ip_vs_conn_tab_bits is between 8 and 20

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix use-after-free in CCMP/GCMP RX

Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
    tty: Fix out-of-bound vmalloc access in imageblit

Linus Torvalds <torvalds@linux-foundation.org>
    qnx4: work around gcc false positive warning bug

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

Zhihao Cheng <chengzhihao1@huawei.com>
    blktrace: Fix uaf in blk_trace access after removing by sysfs

Baokun Li <libaokun1@huawei.com>
    scsi: iscsi: Adjust iface sysfs attr detection

Aya Levin <ayal@nvidia.com>
    net/mlx4_en: Don't allow aRFS for encapsulated packets

Johan Hovold <johan@kernel.org>
    net: hso: fix muxed tty registration

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add device id for Foxconn T99W265

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    USB: serial: option: remove duplicate USB device ID

Carlo Lobrano <c.lobrano@gmail.com>
    USB: serial: option: add Telit LN920 compositions

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    USB: serial: mos7840: remove duplicated 0xac24 device ID

Uwe Brandt <uwe.brandt@gmail.com>
    USB: serial: cp210x: add ID for GW Instek GDM-834x Digital Multimeter

Jan Beulich <jbeulich@suse.com>
    xen/x86: fix PV trap handling on secondary processors

Steve French <stfrench@microsoft.com>
    cifs: fix incorrect check for null pointer in header_assemble

Dan Carpenter <dan.carpenter@oracle.com>
    usb: musb: tusb6010: uninitialized data in tusb_fifo_write_unaligned()

Dan Carpenter <dan.carpenter@oracle.com>
    usb: gadget: r8a66597: fix a loop in set_feature()


-------------

Diffstat:

 Makefile                                       |  4 +-
 arch/alpha/include/asm/io.h                    |  6 +--
 arch/arm64/Kconfig                             |  2 +-
 arch/arm64/kernel/process.c                    |  2 +-
 arch/arm64/mm/proc.S                           |  4 +-
 arch/m68k/include/asm/raw_io.h                 | 20 ++++----
 arch/parisc/include/asm/page.h                 |  2 +-
 arch/sparc/kernel/mdesc.c                      |  3 +-
 arch/x86/xen/enlighten.c                       | 15 +++---
 drivers/edac/synopsys_edac.c                   |  2 +-
 drivers/hid/hid-betopff.c                      | 13 +++--
 drivers/hid/usbhid/hid-core.c                  | 13 ++++-
 drivers/ipack/devices/ipoctal.c                | 63 +++++++++++++++++------
 drivers/net/ethernet/i825xx/82596.c            |  2 +-
 drivers/net/ethernet/intel/e100.c              | 22 +++++---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |  3 ++
 drivers/net/hamradio/6pack.c                   |  4 +-
 drivers/net/usb/hso.c                          | 12 ++---
 drivers/scsi/scsi_transport_iscsi.c            |  8 +--
 drivers/spi/spi-tegra20-slink.c                |  4 +-
 drivers/tty/vt/vt.c                            | 21 +++++++-
 drivers/usb/gadget/udc/r8a66597-udc.c          |  2 +-
 drivers/usb/musb/tusb6010.c                    |  1 +
 drivers/usb/serial/cp210x.c                    |  1 +
 drivers/usb/serial/mos7840.c                   |  2 -
 drivers/usb/serial/option.c                    | 11 +++-
 fs/cifs/connect.c                              |  5 +-
 fs/ext4/dir.c                                  |  6 +--
 fs/qnx4/dir.c                                  | 69 +++++++++++++++++++-------
 include/linux/compiler.h                       |  2 +
 include/linux/cred.h                           | 14 ++++--
 kernel/trace/blktrace.c                        |  8 +++
 net/mac80211/wpa.c                             |  6 +++
 net/netfilter/ipset/ip_set_hash_gen.h          |  4 +-
 net/netfilter/ipvs/ip_vs_conn.c                |  4 ++
 35 files changed, 254 insertions(+), 106 deletions(-)


