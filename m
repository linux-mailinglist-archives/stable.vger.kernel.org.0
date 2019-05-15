Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 655C11EFA8
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732913AbfEOLdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:33:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732631AbfEOLdg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:33:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30CCF2053B;
        Wed, 15 May 2019 11:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557920015;
        bh=mQ1M9iKm+r/Yja+DxRhbOUAGtqb3aU8QpacbQuVG+IE=;
        h=From:To:Cc:Subject:Date:From;
        b=nK2rExqtwImXRXlCqOOTO8vZnJkDYBKUFK4mLWR1jMNddh7dX+YonhIm0UO0WLYzo
         RfWvdUa6rO57AgmyzyqN12PRB8+JkwTId5C3BwNjpb/OpQIfHAruCNU+OtYLXisDN7
         TFLV5w/eFqpl4/A4c1kjEo/YJXGtg9QzGzQrQ9B8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.1 00/46] 5.1.3-stable review
Date:   Wed, 15 May 2019 12:56:24 +0200
Message-Id: <20190515090616.670410738@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.1.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.1.3-rc1
X-KernelTest-Deadline: 2019-05-17T09:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.1.3 release.
There are 46 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 17 May 2019 09:04:22 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.1.3-rc1

Damien Le Moal <damien.lemoal@wdc.com>
    f2fs: Fix use of number of devices

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Add pci_destroy_slot() in pci_devices_present_work(), if necessary

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Add hv_pci_remove_slots() when we unload the driver

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Fix a memory leak in hv_eject_device_work()

YueHaibing <yuehaibing@huawei.com>
    virtio_ring: Fix potential mem leak in virtqueue_add_indirect_packed

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    powerpc/booke64: set RI in default MSR

Russell Currey <ruscur@russell.cc>
    powerpc/powernv/idle: Restore IAMR after idle

Rick Lindsley <ricklind@linux.vnet.ibm.com>
    powerpc/book3s/64: check for NULL pointer in pgd_alloc()

Dan Carpenter <dan.carpenter@oracle.com>
    drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl

Dan Carpenter <dan.carpenter@oracle.com>
    drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl

Paul Bolle <pebolle@tiscali.nl>
    isdn: bas_gigaset: use usb_fill_int_urb() properly

Eric Dumazet <edumazet@google.com>
    flow_dissector: disable preemption around BPF calls

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: fix phy_validate_pause

Jason Wang <jasowang@redhat.com>
    tuntap: synchronize through tfiles array instead of tun->numqueues

Jason Wang <jasowang@redhat.com>
    tuntap: fix dividing by zero in ebpf queue selection

Oliver Neukum <oneukum@suse.com>
    aqc111: fix double endianness swap on BE

Oliver Neukum <oneukum@suse.com>
    aqc111: fix writing to the phy on BE

Oliver Neukum <oneukum@suse.com>
    aqc111: fix endianness issue in aqc111_change_mtu

Stephen Suryaputra <ssuryaextr@gmail.com>
    vrf: sit mtu should not be updated when vrf netdev is the link

Hangbin Liu <liuhangbin@gmail.com>
    vlan: disable SIOCSHWTSTAMP in container

Parthasarathy Bhuvaragan <parthasarathy.bhuvaragan@gmail.com>
    tipc: fix hanging clients using poll with EPOLLOUT flag

Paolo Abeni <pabeni@redhat.com>
    selinux: do not report error on connect(AF_UNSPEC)

YueHaibing <yuehaibing@huawei.com>
    packet: Fix error path in packet_init

Christophe Leroy <christophe.leroy@c-s.fr>
    net: ucc_geth - fix Oops when changing number of buffers in the ring

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    net: seeq: fix crash caused by not set dev.parent

Harini Katakam <harini.katakam@xilinx.com>
    net: macb: Change interrupt and napi enable order in open

Corentin Labbe <clabbe@baylibre.com>
    net: ethernet: stmmac: dwmac-sun8i: enable support of unicast filtering

YueHaibing <yuehaibing@huawei.com>
    net: dsa: Fix error cleanup path in dsa_init_module

David Ahern <dsahern@gmail.com>
    ipv4: Fix raw socket lookup for local traffic

Hangbin Liu <liuhangbin@gmail.com>
    fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    dpaa_eth: fix SG frame cleanup

Tobin C. Harding <tobin@kernel.org>
    bridge: Fix error path for kobject_init_and_add()

Jarod Wilson <jarod@redhat.com>
    bonding: fix arp_validate toggling in active-backup mode

Nigel Croxon <ncroxon@redhat.com>
    Don't jump to compute_result state from check_result state

Gustavo A. R. Silva <gustavo@embeddedor.com>
    rtlwifi: rtl8723ae: Fix missing break in switch statement

Petr Štetiar <ynezz@true.cz>
    mwl8k: Fix rate_idx underflow

Johan Hovold <johan@kernel.org>
    USB: serial: fix unthrottle races

Hans de Goede <hdegoede@redhat.com>
    virt: vbox: Sanity-check parameter types for hgcm-calls coming from userspace

Andrea Parri <andrea.parri@amarulasolutions.com>
    kernfs: fix barrier usage in __kernfs_new_node()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: core: ratelimit 'transfer when suspended' errors

Kees Cook <keescook@chromium.org>
    selftests/seccomp: Handle namespace failures gracefully

Lei YU <mine260309@gmail.com>
    hwmon: (occ) Fix extended status bits

Stefan Wahren <stefan.wahren@i2se.com>
    hwmon: (pwm-fan) Disable PWM if fetching cooling data fails

Mario Limonciello <mario.limonciello@dell.com>
    platform/x86: dell-laptop: fix rfkill functionality

Jiaxun Yang <jiaxun.yang@flygoat.com>
    platform/x86: thinkpad_acpi: Disable Bluetooth for some machines

Gustavo A. R. Silva <gustavo@embeddedor.com>
    platform/x86: sony-laptop: Fix unintentional fall-through


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/powerpc/include/asm/book3s/64/pgalloc.h       |  3 +
 arch/powerpc/include/asm/reg_booke.h               |  2 +-
 arch/powerpc/kernel/idle_book3s.S                  | 20 ++++++
 drivers/hwmon/occ/sysfs.c                          |  8 +--
 drivers/hwmon/pwm-fan.c                            |  2 +-
 drivers/i2c/i2c-core-base.c                        |  5 +-
 drivers/isdn/gigaset/bas-gigaset.c                 |  9 +--
 drivers/md/raid5.c                                 | 19 ++----
 drivers/net/bonding/bond_options.c                 |  7 ---
 drivers/net/ethernet/cadence/macb_main.c           |  6 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  2 +-
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c  |  8 +--
 drivers/net/ethernet/seeq/sgiseeq.c                |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |  2 +
 drivers/net/phy/phy_device.c                       | 11 ++--
 drivers/net/tun.c                                  | 14 ++++-
 drivers/net/usb/aqc111.c                           | 31 +++++++---
 drivers/net/wireless/marvell/mwl8k.c               | 13 ++--
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |  1 +
 drivers/pci/controller/pci-hyperv.c                | 23 +++++++
 drivers/platform/x86/dell-laptop.c                 |  6 +-
 drivers/platform/x86/sony-laptop.c                 |  8 ++-
 drivers/platform/x86/thinkpad_acpi.c               | 72 +++++++++++++++++++++-
 drivers/usb/serial/generic.c                       | 39 +++++++++---
 drivers/virt/fsl_hypervisor.c                      | 29 +++++----
 drivers/virt/vboxguest/vboxguest_core.c            | 31 ++++++++++
 drivers/virtio/virtio_ring.c                       |  1 +
 fs/f2fs/data.c                                     | 17 +++--
 fs/f2fs/f2fs.h                                     | 13 +++-
 fs/f2fs/file.c                                     |  2 +-
 fs/f2fs/gc.c                                       |  2 +-
 fs/f2fs/segment.c                                  | 13 ++--
 fs/kernfs/dir.c                                    |  5 +-
 include/linux/i2c.h                                |  3 +-
 net/8021q/vlan_dev.c                               |  4 +-
 net/bridge/br_if.c                                 | 13 ++--
 net/core/fib_rules.c                               |  6 +-
 net/core/flow_dissector.c                          |  3 +
 net/dsa/dsa.c                                      | 11 +++-
 net/ipv4/raw.c                                     |  4 +-
 net/ipv6/sit.c                                     |  2 +-
 net/packet/af_packet.c                             | 25 ++++++--
 net/tipc/socket.c                                  |  4 +-
 security/selinux/hooks.c                           |  8 +--
 tools/testing/selftests/seccomp/seccomp_bpf.c      | 43 +++++++------
 46 files changed, 399 insertions(+), 156 deletions(-)


