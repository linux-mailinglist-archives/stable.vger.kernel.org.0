Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50AE0B5D3E
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbfIRGVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729162AbfIRGVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:21:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83303218AF;
        Wed, 18 Sep 2019 06:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787694;
        bh=haGvU4cRIPrpLQcehFbPxG/rTQsMSNW4FF/ONfaKT30=;
        h=From:To:Cc:Subject:Date:From;
        b=BHsg8vevtcte7kf2F5fpsGoseawP9Zz1fdKMQevQ0BPb7zj3QOdqVErB04V6n2hMI
         GSQm71X7ZXr96+7dkMAZKqvk1ffEfNRivJ6m9MksoYfJ7PTrAsqJbv1oVw/L6eg1Io
         87LnAPTg+YVzeeZ596DUd3YZ/+qldW05wZ8ooxfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/45] 4.14.145-stable review
Date:   Wed, 18 Sep 2019 08:18:38 +0200
Message-Id: <20190918061222.854132812@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.145-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.145-rc1
X-KernelTest-Deadline: 2019-09-20T06:12+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.145 release.
There are 45 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.145-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.145-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    x86/build: Add -Wnoaddress-of-packed-member to REALMODE_CFLAGS, to silence GCC9 build warning

Jean Delvare <jdelvare@suse.de>
    nvmem: Use the same permissions for eeprom as for nvmem

Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>
    platform/x86: pmc_atom: Add CB4063 Beckhoff Automation board to critclk_systems DMI table

Mario Limonciello <mario.limonciello@dell.com>
    Revert "Bluetooth: btusb: driver to enable the usb-wakeup feature"

Nishka Dasgupta <nishkadg.linux@gmail.com>
    drm/mediatek: mtk_drm_drv.c: Add of_node_put() before goto

Andrew F. Davis <afd@ti.com>
    firmware: ti_sci: Always request response from firmware

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - HMAC SNOOP NO AFEU mode requires SW icv checking.

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - Do not modify req->cryptlen on decryption.

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - fix ECB algs ivsize

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - check data blocksize in ablkcipher.

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - fix CTR alg blocksize

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - check AES key size

Muchun Song <smuchun@gmail.com>
    driver core: Fix use-after-free and double free on glue directory

Richard Weinberger <richard@nod.at>
    ubifs: Correctly use tnc_next() in search_dh_cookie()

Alex Williamson <alex.williamson@redhat.com>
    PCI: Always allow probing with driver_override

Xiaolei Li <xiaolei.li@mediatek.com>
    mtd: rawnand: mtk: Fix wrongly assigned OOB buffer pointer issue

Douglas Anderson <dianders@chromium.org>
    clk: rockchip: Don't yell about bad mmc phases when getting

Neil Armstrong <narmstrong@baylibre.com>
    drm/meson: Add support for XBGR8888 & ABGR8888 formats

Suraj Jitindar Singh <sjitindarsingh@gmail.com>
    powerpc: Add barrier_nospec to raw_copy_in_user()

Paul Burton <paul.burton@mips.com>
    MIPS: VDSO: Use same -m%-float cflag as the kernel proper

Paul Burton <paul.burton@mips.com>
    MIPS: VDSO: Prevent use of smp_processor_id()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: handle page fault in vmread

Fuqian Huang <huangfq.daxian@gmail.com>
    KVM: x86: work around leak of uninitialized stack contents

Thomas Huth <thuth@redhat.com>
    KVM: s390: Do not leak kernel stack data in the KVM_S390_INTERRUPT ioctl

Yunfeng Ye <yeyunfeng@huawei.com>
    genirq: Prevent NULL pointer dereference in resend_irqs()

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix assertion failure during fsync and use of stale transaction

Kent Gibson <warthog618@gmail.com>
    gpio: fix line flag validation in lineevent_create

Kent Gibson <warthog618@gmail.com>
    gpio: fix line flag validation in linehandle_create

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Add gpiolib_acpi_run_edge_events_on_boot option and blacklist

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "MIPS: SiByte: Enable swiotlb for SWARM, LittleSur and BigSur"

Johannes Thumshirn <jthumshirn@suse.de>
    btrfs: correctly validate compression type

David Sterba <dsterba@suse.com>
    btrfs: compression: add helper for type to string conversion

Yang Yingliang <yangyingliang@huawei.com>
    tun: fix use-after-free when register netdev failed

Xin Long <lucien.xin@gmail.com>
    tipc: add NULL pointer check before calling kfree_rcu

Neal Cardwell <ncardwell@google.com>
    tcp: fix tcp_ecn_withdraw_cwr() to clear TCP_ECN_QUEUE_CWR

Xin Long <lucien.xin@gmail.com>
    sctp: use transport pf_retrans in sctp_do_8_2_transport_strike

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    sctp: Fix the link time qualifier of 'sctp_ctrlsock_exit()'

Cong Wang <xiyou.wangcong@gmail.com>
    sch_hhf: ensure quantum and hhf_non_hh_weight are non-zero

Stefan Chulski <stefanc@marvell.com>
    net: phylink: Fix flow control resolution

Shmulik Ladkani <shmulik@metanetworks.com>
    net: gso: Fix skb_segment splat when splitting gso_size mangled skb having linear-headed frag_list

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
    net: Fix null de-reference of device refcount

Eric Biggers <ebiggers@google.com>
    isdn/capi: check message length in capi_write()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ipv6: Fix the link time qualifier of 'ping_v6_proc_exit_net()'

Bjørn Mork <bjorn@mork.no>
    cdc_ether: fix rndis support for Mediatek based smartphones

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    bridge/mdb: remove wrong use of NLM_F_MULTI


-------------

Diffstat:

 Makefile                               |  4 +-
 arch/mips/Kconfig                      |  3 --
 arch/mips/include/asm/smp.h            | 12 +++++-
 arch/mips/sibyte/common/Makefile       |  1 -
 arch/mips/sibyte/common/dma.c          | 14 -------
 arch/mips/vdso/Makefile                |  4 +-
 arch/powerpc/include/asm/uaccess.h     |  1 +
 arch/s390/kvm/interrupt.c              | 10 +++++
 arch/s390/kvm/kvm-s390.c               |  2 +-
 arch/x86/Makefile                      |  1 +
 arch/x86/kvm/vmx.c                     |  7 +++-
 arch/x86/kvm/x86.c                     |  7 ++++
 drivers/base/core.c                    | 53 ++++++++++++++++++++++++++-
 drivers/bluetooth/btusb.c              |  5 ---
 drivers/clk/rockchip/clk-mmc-phase.c   |  4 +-
 drivers/crypto/talitos.c               | 67 +++++++++++++++++++++++++---------
 drivers/firmware/ti_sci.c              |  8 ++--
 drivers/gpio/gpiolib-acpi.c            | 42 +++++++++++++++++++--
 drivers/gpio/gpiolib.c                 | 20 +++++++---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c |  5 ++-
 drivers/gpu/drm/meson/meson_plane.c    | 16 ++++++++
 drivers/isdn/capi/capi.c               | 10 ++++-
 drivers/mtd/nand/mtk_nand.c            | 21 +++++------
 drivers/net/phy/phylink.c              |  6 +--
 drivers/net/tun.c                      | 16 +++++---
 drivers/net/usb/cdc_ether.c            | 13 +++++--
 drivers/nvmem/core.c                   | 15 ++++++--
 drivers/pci/pci-driver.c               |  3 +-
 drivers/platform/x86/pmc_atom.c        |  8 ++++
 fs/btrfs/compression.c                 | 31 ++++++++++++++++
 fs/btrfs/compression.h                 |  3 ++
 fs/btrfs/props.c                       |  6 +--
 fs/btrfs/tree-log.c                    |  8 ++--
 fs/ubifs/tnc.c                         | 16 +++++---
 include/uapi/linux/isdn/capicmd.h      |  1 +
 kernel/irq/resend.c                    |  2 +
 net/bridge/br_mdb.c                    |  2 +-
 net/core/dev.c                         |  2 +
 net/core/skbuff.c                      | 19 ++++++++++
 net/ipv4/tcp_input.c                   |  2 +-
 net/ipv6/ping.c                        |  2 +-
 net/sched/sch_hhf.c                    |  2 +-
 net/sctp/protocol.c                    |  2 +-
 net/sctp/sm_sideeffect.c               |  2 +-
 net/tipc/name_distr.c                  |  3 +-
 45 files changed, 366 insertions(+), 115 deletions(-)


