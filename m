Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 991A2B5CCA
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbfIRGZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbfIRGZz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:25:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46BFC21925;
        Wed, 18 Sep 2019 06:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787953;
        bh=qLAAUX4SsYM1Clfv4xEO6SGYWjL/OsRk8EGWmNpBWag=;
        h=From:To:Cc:Subject:Date:From;
        b=cPKAuGSKi9xqMEEiR13WNJV4ynNliIgTJzu2BBpxMT7aPI14tivdi1mrNzM96ZwVG
         uxk5OvNQZxHF8wI0SEbLAjo+dp+H++B1UD/T1k1V1Jk30ASonLwoMGNrs1Us54YXo4
         20vozI5frfpGdSspADx710ijL/IB/KfY6AhoatQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.2 00/85] 5.2.16-stable review
Date:   Wed, 18 Sep 2019 08:18:18 +0200
Message-Id: <20190918061234.107708857@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.16-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.16-rc1
X-KernelTest-Deadline: 2019-09-20T06:12+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.2.16 release.
There are 85 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.16-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.2.16-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    x86/build: Add -Wnoaddress-of-packed-member to REALMODE_CFLAGS, to silence GCC9 build warning

Hui Peng <benquike@gmail.com>
    rsi: fix a double free bug in rsi_91x_deinit()

Enrico Weigelt <info@metux.net>
    platform/x86: pcengines-apuv2: use KEY_RESTART for front button

Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>
    platform/x86: pmc_atom: Add CB4063 Beckhoff Automation board to critclk_systems DMI table

Liran Alon <liran.alon@oracle.com>
    KVM: SVM: Fix detection of AMD Errata 1096

Jim Mattson <jmattson@google.com>
    kvm: nVMX: Remove unnecessary sync_roots from handle_invept

Jessica Yu <jeyu@kernel.org>
    modules: always page-align module section allocations

Yang Yingliang <yangyingliang@huawei.com>
    modules: fix compile error if don't have strict module rwx

Yang Yingliang <yangyingliang@huawei.com>
    modules: fix BUG when load module with rodata=n

Olivier Moysan <olivier.moysan@st.com>
    iio: adc: stm32-dfsdm: fix data type

Olivier Moysan <olivier.moysan@st.com>
    iio: adc: stm32-dfsdm: fix output resolution

Mario Limonciello <mario.limonciello@dell.com>
    Revert "Bluetooth: btusb: driver to enable the usb-wakeup feature"

Gustavo A. R. Silva <gustavo@embeddedor.com>
    mm/z3fold.c: fix lock/unlock imbalance in z3fold_page_isolate

Henry Burns <henryburns@google.com>
    mm/z3fold.c: remove z3fold_migration trylock

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

Alex Williamson <alex.williamson@redhat.com>
    PCI: Always allow probing with driver_override

Xiaolei Li <xiaolei.li@mediatek.com>
    mtd: rawnand: mtk: Fix wrongly assigned OOB buffer pointer issue

Douglas Anderson <dianders@chromium.org>
    clk: rockchip: Don't yell about bad mmc phases when getting

Dan Carpenter <dan.carpenter@oracle.com>
    mt76: mt7615: Use after free in mt7615_mcu_set_bcn()

Dan Carpenter <dan.carpenter@oracle.com>
    mt76: Fix a signedness bug in mt7615_add_interface()

Stephen Boyd <sboyd@kernel.org>
    clk: Simplify debugfs printing and add a newline

Chen-Yu Tsai <wens@csie.org>
    clk: Fix debugfs clk_possible_parents for clks without parent string names

Neil Armstrong <narmstrong@baylibre.com>
    drm/meson: Add support for XBGR8888 & ABGR8888 formats

Mimi Zohar <zohar@linux.ibm.com>
    x86/ima: check EFI SetupMode too

Junichi Nomura <j-nomura@ce.jp.nec.com>
    x86/boot: Use efi_setup_data for searching RSDP on kexec-ed kernels

YueHaibing <yuehaibing@huawei.com>
    kernel/module: Fix mem leak in module_add_modinfo_attrs

Suraj Jitindar Singh <sjitindarsingh@gmail.com>
    powerpc: Add barrier_nospec to raw_copy_in_user()

Steve Wahl <steve.wahl@hpe.com>
    x86/purgatory: Change compiler flags from -mcmodel=kernel to -mcmodel=large to fix kexec relocation errors

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: handle page fault in vmread

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86/mmu: Reintroduce fast invalidate/zap for flushing memslot

Fuqian Huang <huangfq.daxian@gmail.com>
    KVM: x86: work around leak of uninitialized stack contents

Thomas Huth <thuth@redhat.com>
    KVM: s390: Do not leak kernel stack data in the KVM_S390_INTERRUPT ioctl

Igor Mammedov <imammedo@redhat.com>
    KVM: s390: kvm_s390_vm_start_migration: check dirty_bitmap before using it as target for memset()

Andreas Kemnade <andreas@kemnade.info>
    regulator: twl: voltage lists for vdd1/2 on twl4030

Yunfeng Ye <yeyunfeng@huawei.com>
    genirq: Prevent NULL pointer dereference in resend_irqs()

Stanislaw Gruszka <sgruszka@redhat.com>
    mt76: mt76x0e: disable 5GHz band for MT7630E

Stanislaw Gruszka <sgruszka@redhat.com>
    Revert "rt2800: enable TX_PIN_CFG_LNA_PE_ bits per band"

Alexander Duyck <alexander.h.duyck@linux.intel.com>
    ixgbe: Prevent u8 wrapping of ITR value to something less than 10us

Ilya Maximets <i.maximets@samsung.com>
    ixgbe: fix double clean of Tx descriptors with xdp

Arnd Bergmann <arnd@arndb.de>
    ipc: fix sparc64 ipc() wrapper

Arnd Bergmann <arnd@arndb.de>
    ipc: fix semtimedop for generic 32-bit architectures

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Restore relaxed padding (OCL_OOB_SUPPRES_ENABLE) for skl+

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Limit MST to <= 8bpc once again

Vasily Khoruzhick <anarsoul@gmail.com>
    drm/lima: fix lima_gem_wait() return value

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: tmio: Fixup runtime PM management during remove

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: tmio: Fixup runtime PM management during probe

Daniel Drake <drake@endlessm.com>
    Revert "mmc: sdhci: Remove unneeded quirk2 flag of O2 SD host controller"

Stefan Wahren <wahrenst@gmx.net>
    Revert "mmc: bcm2835: Terminate timeout work synchronously"

Roman Gushchin <guro@fb.com>
    cgroup: freezer: fix frozen state inheritance

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix assertion failure during fsync and use of stale transaction

Kent Gibson <warthog618@gmail.com>
    gpio: fix line flag validation in lineevent_create

Kent Gibson <warthog618@gmail.com>
    gpio: fix line flag validation in linehandle_create

Wei Yongjun <weiyongjun1@huawei.com>
    gpio: mockup: add missing single_release()

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Add gpiolib_acpi_run_edge_events_on_boot option and blacklist

John Fastabend <john.fastabend@gmail.com>
    net: sock_map, fix missing ulp check in sock hash case

Xin Long <lucien.xin@gmail.com>
    sctp: fix the missing put_user when dumping transport thresholds

Moritz Fischer <mdf@kernel.org>
    net: fixed_phy: Add forward declaration for struct gpio_desc;

Maciej Żenczykowski <maze@google.com>
    ipv6: addrconf_f6i_alloc - fix non-null pointer check to !IS_ERR()

Maciej Żenczykowski <maze@google.com>
    net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128 local route (and others)

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

Jeff Kirsher <jeffrey.t.kirsher@intel.com>
    ixgbevf: Fix secpath usage for IPsec Tx offload

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

 Makefile                                           |   4 +-
 arch/powerpc/include/asm/uaccess.h                 |   1 +
 arch/s390/kvm/interrupt.c                          |  10 ++
 arch/s390/kvm/kvm-s390.c                           |   4 +-
 arch/sparc/kernel/sys_sparc_64.c                   |  33 +++--
 arch/x86/Makefile                                  |   1 +
 arch/x86/boot/compressed/acpi.c                    | 143 +++++++++++++-----
 arch/x86/include/asm/kvm_host.h                    |   2 +
 arch/x86/kernel/ima_arch.c                         |  12 +-
 arch/x86/kvm/mmu.c                                 | 101 ++++++++++++-
 arch/x86/kvm/svm.c                                 |  42 +++++-
 arch/x86/kvm/vmx/nested.c                          |  12 +-
 arch/x86/kvm/x86.c                                 |   7 +
 arch/x86/purgatory/Makefile                        |  35 +++--
 drivers/base/core.c                                |  53 ++++++-
 drivers/bluetooth/btusb.c                          |   5 -
 drivers/clk/clk.c                                  |  38 ++++-
 drivers/clk/rockchip/clk-mmc-phase.c               |   4 +-
 drivers/crypto/talitos.c                           |  70 ++++++---
 drivers/firmware/ti_sci.c                          |   8 +-
 drivers/gpio/gpio-mockup.c                         |   1 +
 drivers/gpio/gpiolib-acpi.c                        |  42 +++++-
 drivers/gpio/gpiolib.c                             |  16 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  12 ++
 drivers/gpu/drm/i915/intel_dp_mst.c                |  10 +-
 drivers/gpu/drm/i915/intel_workarounds.c           |   5 -
 drivers/gpu/drm/lima/lima_gem.c                    |   2 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   5 +-
 drivers/gpu/drm/meson/meson_plane.c                |  16 ++
 drivers/iio/adc/stm32-dfsdm-adc.c                  | 162 ++++++++++++++++-----
 drivers/iio/adc/stm32-dfsdm.h                      |  24 ++-
 drivers/isdn/capi/capi.c                           |  10 +-
 drivers/mmc/host/bcm2835.c                         |   2 +-
 drivers/mmc/host/sdhci-pci-o2micro.c               |   2 +-
 drivers/mmc/host/tmio_mmc.h                        |   1 +
 drivers/mmc/host/tmio_mmc_core.c                   |  16 +-
 drivers/mtd/nand/raw/mtk_nand.c                    |  21 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  29 ++--
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   3 +-
 drivers/net/phy/phylink.c                          |   6 +-
 drivers/net/tun.c                                  |  16 +-
 drivers/net/usb/cdc_ether.c                        |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |   5 +
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |  18 +--
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   1 -
 drivers/pci/pci-driver.c                           |   3 +-
 drivers/platform/x86/pcengines-apuv2.c             |   2 +-
 drivers/platform/x86/pmc_atom.c                    |   8 +
 drivers/regulator/twl-regulator.c                  |  23 ++-
 fs/btrfs/tree-log.c                                |  16 +-
 fs/ubifs/tnc.c                                     |  16 +-
 include/linux/phy_fixed.h                          |   1 +
 include/linux/syscalls.h                           |  19 +++
 include/uapi/asm-generic/unistd.h                  |   2 +-
 include/uapi/linux/isdn/capicmd.h                  |   1 +
 ipc/util.h                                         |  25 +---
 kernel/cgroup/cgroup.c                             |  10 +-
 kernel/irq/resend.c                                |   2 +
 kernel/module.c                                    |  51 ++++---
 mm/z3fold.c                                        |   7 +-
 net/bridge/br_mdb.c                                |   2 +-
 net/core/dev.c                                     |   2 +
 net/core/skbuff.c                                  |  19 +++
 net/core/sock_map.c                                |   3 +
 net/ipv4/tcp_input.c                               |   2 +-
 net/ipv6/ping.c                                    |   2 +-
 net/ipv6/route.c                                   |   8 +-
 net/sched/sch_generic.c                            |   9 +-
 net/sched/sch_hhf.c                                |   2 +-
 net/sctp/protocol.c                                |   2 +-
 net/sctp/sm_sideeffect.c                           |   2 +-
 net/sctp/socket.c                                  |   3 +-
 net/tipc/name_distr.c                              |   3 +-
 76 files changed, 956 insertions(+), 323 deletions(-)


