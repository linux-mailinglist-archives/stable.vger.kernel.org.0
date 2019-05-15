Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8CA91F23A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbfEOMAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730139AbfEOLOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:14:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B08520644;
        Wed, 15 May 2019 11:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918877;
        bh=IzKyCwSb9+/zngvWRcofYf2BV7s01HWiDt6qd9CHLu0=;
        h=From:To:Cc:Subject:Date:From;
        b=wsZsDxGwQKs9y39UMdjWK358plc/BcZ1ns+4URiqxjQHCL0ziOAM3bZviNYAuFS5v
         AMdLfxPqPTjej7NVG5rxH+C+3o7P+l72SpBH4n/4vM4OpAqrewE0n2YGp3M57oSh/l
         H/PkXdQUbqP+ZjjyMmEN6dzhyEgehbc0JB2zjsus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/51] 4.9.177-stable review
Date:   Wed, 15 May 2019 12:55:35 +0200
Message-Id: <20190515090616.669619870@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.177-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.177-rc1
X-KernelTest-Deadline: 2019-05-17T09:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.177 release.
There are 51 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 17 May 2019 09:04:42 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.177-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.177-rc1

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    powerpc/booke64: set RI in default MSR

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/lib: fix book3s/32 boot failure due to code patching

Dan Carpenter <dan.carpenter@oracle.com>
    drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl

Dan Carpenter <dan.carpenter@oracle.com>
    drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl

Jarod Wilson <jarod@redhat.com>
    bonding: fix arp_validate toggling in active-backup mode

David Ahern <dsahern@gmail.com>
    ipv4: Fix raw socket lookup for local traffic

Stephen Suryaputra <ssuryaextr@gmail.com>
    vrf: sit mtu should not be updated when vrf netdev is the link

Hangbin Liu <liuhangbin@gmail.com>
    vlan: disable SIOCSHWTSTAMP in container

YueHaibing <yuehaibing@huawei.com>
    packet: Fix error path in packet_init

Christophe Leroy <christophe.leroy@c-s.fr>
    net: ucc_geth - fix Oops when changing number of buffers in the ring

Hangbin Liu <liuhangbin@gmail.com>
    fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied

Tobin C. Harding <tobin@kernel.org>
    bridge: Fix error path for kobject_init_and_add()

Breno Leitao <leitao@debian.org>
    powerpc/64s: Include cpu header

Alistair Strachan <astrachan@google.com>
    x86/vdso: Pass --eh-frame-hdr to the linker

Nick Desaulniers <ndesaulniers@google.com>
    x86/vdso: Drop implicit common-page-size linker flag

Alistair Strachan <astrachan@google.com>
    x86: vdso: Use $LD instead of $CC to link

Sasha Levin <sashal@kernel.org>
    Revert "x86: vdso: Use $LD instead of $CC to link"

Sasha Levin <sashal@kernel.org>
    Revert "x86/vdso: Drop implicit common-page-size linker flag"

Nigel Croxon <ncroxon@redhat.com>
    Don't jump to compute_result state from check_result state

Gustavo A. R. Silva <gustavo@embeddedor.com>
    rtlwifi: rtl8723ae: Fix missing break in switch statement

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: pcm: remove SNDRV_PCM_IOCTL1_INFO internal command

Wei Yongjun <weiyongjun1@huawei.com>
    cw1200: fix missing unlock on error in cw1200_hw_scan()

Pan Bian <bianpan2016@163.com>
    Input: synaptics-rmi4 - fix possible double free

Daniel Gomez <dagmcr@gmail.com>
    spi: ST ST95HF NFC: declare missing of table

Daniel Gomez <dagmcr@gmail.com>
    spi: Micrel eth switch: declare missing of table

Lucas Stach <l.stach@pengutronix.de>
    gpu: ipu-v3: dp: fix CSC handling

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests/net: correct the return value for run_netsocktests

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    drm/sun4i: Set device driver data at bind time for use in unbind

Arnd Bergmann <arnd@arndb.de>
    s390: ctcm: fix ctcm_new_device error return code

Petr Štetiar <ynezz@true.cz>
    MIPS: perf: ath79: Fix perfcount IRQ assignment

Julian Anastasov <ja@ssi.bg>
    ipvs: do not schedule icmp errors from tunnels

Florian Westphal <fw@strlen.de>
    selftests: netfilter: check icmp pkttoobig errors are set as related

Dan Williams <dan.j.williams@intel.com>
    init: initialize jump labels before command line option parsing

Rikard Falkeborn <rikard.falkeborn@gmail.com>
    tools lib traceevent: Fix missing equality check for strcmp

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: avoid misreporting level-triggered irqs as edge-triggered in tracing

Jian-Hong Pan <jian-hong@endlessm.com>
    x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    mISDN: Check address length before reading address family

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/3270: fix lockdep false positive on view->lock

Felix Fietkau <nbd@nbd.name>
    mac80211: fix unaligned access in mesh table hash function

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/dasd: Fix capacity calculation for large volumes

Aditya Pakki <pakki001@umn.edu>
    libnvdimm/btt: Fix a kmemdup failure check

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: input: add mapping for "Toggle Display" key

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: input: add mapping for keyboard Brightness Up/Down/Toggle keys

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: input: add mapping for Expose/Overview key

Kangjie Lu <kjlu@umn.edu>
    libnvdimm/namespace: Fix a potential NULL pointer dereference

Sven Van Asbroeck <thesven73@gmail.com>
    iio: adc: xilinx: fix potential use-after-free on remove

Johan Hovold <johan@kernel.org>
    USB: serial: fix unthrottle races

Gustavo A. R. Silva <gustavo@embeddedor.com>
    platform/x86: sony-laptop: Fix unintentional fall-through

Alexei Starovoitov <ast@fb.com>
    bpf: convert htab map to hlist_nulls

Alexei Starovoitov <ast@fb.com>
    bpf: fix struct htab_elem layout

Francesco Ruggeri <fruggeri@arista.com>
    netfilter: compat: initialize all fields in xt_init


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/mips/ath79/setup.c                            |   6 -
 arch/powerpc/include/asm/reg_booke.h               |   2 +-
 arch/powerpc/kernel/security.c                     |   1 +
 arch/powerpc/lib/code-patching.c                   |   2 +-
 arch/x86/entry/vdso/Makefile                       |   3 +-
 arch/x86/kernel/reboot.c                           |  21 ++
 arch/x86/kvm/trace.h                               |   4 +-
 drivers/gpu/drm/sun4i/sun4i_drv.c                  |   2 +
 drivers/gpu/ipu-v3/ipu-dp.c                        |  12 +-
 drivers/hid/hid-input.c                            |  14 +
 drivers/iio/adc/xilinx-xadc-core.c                 |   2 +-
 drivers/input/rmi4/rmi_driver.c                    |   6 +-
 drivers/irqchip/irq-ath79-misc.c                   |  11 +
 drivers/isdn/mISDN/socket.c                        |   4 +-
 drivers/md/raid5.c                                 |  19 +-
 drivers/net/bonding/bond_options.c                 |   7 -
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c  |   8 +-
 drivers/net/phy/spi_ks8995.c                       |   9 +
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |   1 +
 drivers/net/wireless/st/cw1200/scan.c              |   5 +-
 drivers/nfc/st95hf/core.c                          |   7 +
 drivers/nvdimm/btt_devs.c                          |  18 +-
 drivers/nvdimm/namespace_devs.c                    |   5 +-
 drivers/platform/x86/sony-laptop.c                 |   8 +-
 drivers/s390/block/dasd_eckd.c                     |   6 +-
 drivers/s390/char/con3270.c                        |   2 +-
 drivers/s390/char/fs3270.c                         |   3 +-
 drivers/s390/char/raw3270.c                        |   3 +-
 drivers/s390/char/raw3270.h                        |   4 +-
 drivers/s390/char/tty3270.c                        |   3 +-
 drivers/s390/net/ctcm_main.c                       |   1 +
 drivers/usb/serial/generic.c                       |  39 ++-
 drivers/virt/fsl_hypervisor.c                      |  29 ++-
 include/linux/efi.h                                |   7 +-
 include/linux/list_nulls.h                         |   5 +
 include/linux/rculist_nulls.h                      |  14 +
 include/sound/pcm.h                                |   2 +-
 init/main.c                                        |   4 +-
 kernel/bpf/hashtab.c                               |  99 ++++---
 net/8021q/vlan_dev.c                               |   4 +-
 net/bridge/br_if.c                                 |  13 +-
 net/core/fib_rules.c                               |   6 +-
 net/ipv4/raw.c                                     |   4 +-
 net/ipv6/sit.c                                     |   2 +-
 net/mac80211/mesh_pathtbl.c                        |   2 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   2 +-
 net/netfilter/x_tables.c                           |   2 +-
 net/packet/af_packet.c                             |  25 +-
 sound/core/pcm_lib.c                               |   2 -
 sound/core/pcm_native.c                            |   6 +-
 tools/lib/traceevent/event-parse.c                 |   2 +-
 tools/testing/selftests/net/run_netsocktests       |   2 +-
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 .../selftests/netfilter/conntrack_icmp_related.sh  | 283 +++++++++++++++++++++
 55 files changed, 605 insertions(+), 154 deletions(-)


