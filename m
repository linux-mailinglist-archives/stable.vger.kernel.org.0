Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8112FB5C23
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbfIRGXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:23:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729527AbfIRGXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:23:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87933218AF;
        Wed, 18 Sep 2019 06:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787784;
        bh=c7/bZFvs4Xjb0pnFZW1B4w3hGkSHpMKD+4ehjXKgkBU=;
        h=From:To:Cc:Subject:Date:From;
        b=wTr50sSKyVCN/KxmK38S3fTSe37OAoi3b82Q0n+Q99FJMCref1j3N89Fnm9IvWgwh
         Q5s2ZjN0eI0Hrp8nfN5Vqk7pc/XnfG09DiTjFUERDKJz2T0q3ttKAHgSJJTSutyAa1
         YsgSK3FZRPsLVKT7gbK1/RQ2LhRDXmEzTuxxc8WA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/50] 4.19.74-stable review
Date:   Wed, 18 Sep 2019 08:18:43 +0200
Message-Id: <20190918061223.116178343@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.74-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.74-rc1
X-KernelTest-Deadline: 2019-09-20T06:12+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.74 release.
There are 50 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.74-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.74-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    x86/build: Add -Wnoaddress-of-packed-member to REALMODE_CFLAGS, to silence GCC9 build warning

Jean Delvare <jdelvare@suse.de>
    nvmem: Use the same permissions for eeprom as for nvmem

Hui Peng <benquike@gmail.com>
    rsi: fix a double free bug in rsi_91x_deinit()

Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>
    platform/x86: pmc_atom: Add CB4063 Beckhoff Automation board to critclk_systems DMI table

Yang Yingliang <yangyingliang@huawei.com>
    modules: fix compile error if don't have strict module rwx

Yang Yingliang <yangyingliang@huawei.com>
    modules: fix BUG when load module with rodata=n

Olivier Moysan <olivier.moysan@st.com>
    iio: adc: stm32-dfsdm: fix data type

Mario Limonciello <mario.limonciello@dell.com>
    Revert "Bluetooth: btusb: driver to enable the usb-wakeup feature"

Nishka Dasgupta <nishkadg.linux@gmail.com>
    drm/mediatek: mtk_drm_drv.c: Add of_node_put() before goto

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add extra quirk table entry for GPD MicroPC

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

Kent Gibson <warthog618@gmail.com>
    gpio: fix line flag validation in lineevent_create

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

Steve Wahl <steve.wahl@hpe.com>
    x86/purgatory: Change compiler flags from -mcmodel=kernel to -mcmodel=large to fix kexec relocation errors

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: handle page fault in vmread

Fuqian Huang <huangfq.daxian@gmail.com>
    KVM: x86: work around leak of uninitialized stack contents

Thomas Huth <thuth@redhat.com>
    KVM: s390: Do not leak kernel stack data in the KVM_S390_INTERRUPT ioctl

Igor Mammedov <imammedo@redhat.com>
    KVM: s390: kvm_s390_vm_start_migration: check dirty_bitmap before using it as target for memset()

Yunfeng Ye <yeyunfeng@huawei.com>
    genirq: Prevent NULL pointer dereference in resend_irqs()

Alexander Duyck <alexander.h.duyck@linux.intel.com>
    ixgbe: Prevent u8 wrapping of ITR value to something less than 10us

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix assertion failure during fsync and use of stale transaction

Kent Gibson <warthog618@gmail.com>
    gpio: fix line flag validation in linehandle_create

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Add gpiolib_acpi_run_edge_events_on_boot option and blacklist

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

Eric Dumazet <edumazet@google.com>
    net: sched: fix reordering issues

Stefan Chulski <stefanc@marvell.com>
    net: phylink: Fix flow control resolution

Shmulik Ladkani <shmulik@metanetworks.com>
    net: gso: Fix skb_segment splat when splitting gso_size mangled skb having linear-headed frag_list

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
    net: Fix null de-reference of device refcount

Steffen Klassert <steffen.klassert@secunet.com>
    ixgbe: Fix secpath usage for IPsec TX offload.

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

 Makefile                                       |  4 +-
 arch/powerpc/include/asm/uaccess.h             |  1 +
 arch/s390/kvm/interrupt.c                      | 10 ++++
 arch/s390/kvm/kvm-s390.c                       |  4 +-
 arch/x86/Makefile                              |  1 +
 arch/x86/kvm/vmx.c                             |  7 ++-
 arch/x86/kvm/x86.c                             |  7 +++
 arch/x86/purgatory/Makefile                    | 35 ++++++++------
 drivers/base/core.c                            | 53 +++++++++++++++++++-
 drivers/bluetooth/btusb.c                      |  5 --
 drivers/clk/rockchip/clk-mmc-phase.c           |  4 +-
 drivers/crypto/talitos.c                       | 67 +++++++++++++++++++-------
 drivers/firmware/ti_sci.c                      |  8 +--
 drivers/gpio/gpiolib-acpi.c                    | 42 ++++++++++++++--
 drivers/gpio/gpiolib.c                         | 16 ++++--
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 12 +++++
 drivers/gpu/drm/mediatek/mtk_drm_drv.c         |  5 +-
 drivers/gpu/drm/meson/meson_plane.c            | 16 ++++++
 drivers/iio/adc/stm32-dfsdm-adc.c              |  4 +-
 drivers/isdn/capi/capi.c                       | 10 +++-
 drivers/mtd/nand/raw/mtk_nand.c                | 21 ++++----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  |  8 ++-
 drivers/net/phy/phylink.c                      |  6 +--
 drivers/net/tun.c                              | 16 ++++--
 drivers/net/usb/cdc_ether.c                    | 13 +++--
 drivers/net/wireless/rsi/rsi_91x_usb.c         |  1 -
 drivers/nvmem/core.c                           | 15 ++++--
 drivers/pci/pci-driver.c                       |  3 +-
 drivers/platform/x86/pmc_atom.c                |  8 +++
 fs/btrfs/tree-log.c                            |  8 +--
 fs/ubifs/tnc.c                                 | 16 ++++--
 include/uapi/linux/isdn/capicmd.h              |  1 +
 kernel/irq/resend.c                            |  2 +
 kernel/module.c                                | 22 ++++++---
 net/bridge/br_mdb.c                            |  2 +-
 net/core/dev.c                                 |  2 +
 net/core/skbuff.c                              | 19 ++++++++
 net/ipv4/tcp_input.c                           |  2 +-
 net/ipv6/ping.c                                |  2 +-
 net/sched/sch_generic.c                        |  9 +++-
 net/sched/sch_hhf.c                            |  2 +-
 net/sctp/protocol.c                            |  2 +-
 net/sctp/sm_sideeffect.c                       |  2 +-
 net/tipc/name_distr.c                          |  3 +-
 44 files changed, 377 insertions(+), 119 deletions(-)


