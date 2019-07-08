Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89B8F621E8
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730874AbfGHPUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:20:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387584AbfGHPUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:20:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D664E2166E;
        Mon,  8 Jul 2019 15:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599235;
        bh=qCtk1NeaGNQzDMoeL1CUao9UI9gbHqgFXISJEfCw+3c=;
        h=From:To:Cc:Subject:Date:From;
        b=GkDDSFc0XQheO48SCLZnCB5ytIMyi8H4zF/1S6Ux2CFyPzl8gw5mqBaPA1YnFCwNn
         dIRXJ9dOqjuoy4FPToH/i0FT1qrpcUmTkFxM1CXXuSkPvrrGPRjGRVX1nJDwCWksNE
         bDmrp5h5NjAkh9d5nhpaDNhfEotJeq8tNG8NHFao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 000/102] 4.9.185-stable review
Date:   Mon,  8 Jul 2019 17:11:53 +0200
Message-Id: <20190708150525.973820964@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.185-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.185-rc1
X-KernelTest-Deadline: 2019-07-10T15:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.185 release.
There are 102 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.185-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.185-rc1

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    arm64: kaslr: keep modules inside module region when KASAN is enabled

Robin Gong <yibin.gong@nxp.com>
    dmaengine: imx-sdma: remove BD_INTR for channel0

Dmitry Korotin <dkorotin@wavecomp.com>
    MIPS: Add missing EHB in mtc0 -> mfc0 sequence.

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Close PSM sdma_progress sleep window

Wanpeng Li <wanpengli@tencent.com>
    KVM: LAPIC: Fix pending interrupt in IRR blocked by software disable LAPIC

Kees Cook <keescook@chromium.org>
    arm64, vdso: Define vdso_{start,end} as array

Linus Torvalds <torvalds@linux-foundation.org>
    tty: rocket: fix incorrect forward declaration of 'rp_init()'

Nikolay Borisov <nborisov@suse.com>
    btrfs: Ensure replaced device doesn't have pending chunk allocation

Robert Beckett <bob.beckett@collabora.com>
    drm/imx: only send event on crtc disable if kept disabled

Robert Beckett <bob.beckett@collabora.com>
    drm/imx: notify drm core before sending event during crtc disable

Herbert Xu <herbert@gondor.apana.org.au>
    lib/mpi: Fix karactx leak in mpi_powm

Colin Ian King <colin.king@canonical.com>
    ALSA: usb-audio: fix sign unintended sign extension on left shifts

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix write on zero-sized buffer

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-lib/fireworks: fix miss detection of received MIDI messages

Colin Ian King <colin.king@canonical.com>
    ALSA: seq: fix incorrect order of dest_client/dest_ports arguments

Eric Biggers <ebiggers@google.com>
    crypto: user - prevent operating on larval algorithms

Jann Horn <jannh@google.com>
    ptrace: Fix ->ptracer_cred handling for PTRACE_TRACEME

Paul Burton <paul.burton@mips.com>
    MIPS: Workaround GCC __builtin_unreachable reordering bug

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/i915/dmc: protect against reading random memory

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: degrade WARN to pr_warn_ratelimited

Arnd Bergmann <arnd@arndb.de>
    clk: sunxi: fix uninitialized access

Vineet Gupta <vgupta@synopsys.com>
    ARC: handle gcc generated __builtin_trap for older compiler

Arnd Bergmann <arnd@arndb.de>
    bug.h: work around GCC PR82365 in BUG()

Vineet Gupta <vgupta@synopsys.com>
    ARC: fix allnoconfig build warning

Arnd Bergmann <arnd@arndb.de>
    mfd: omap-usb-tll: Fix register offsets

Paul Burton <paul.burton@mips.com>
    MIPS: netlogic: xlr: Remove erroneous check in nlm_fmn_send()

Manuel Lauss <manuel.lauss@gmail.com>
    MIPS: math-emu: do not use bools for arithmetic

swkhack <swkhack@gmail.com>
    mm/mlock.c: change count_mm_mlocked_page_nr return type

Manuel Traut <manut@linutronix.de>
    scripts/decode_stacktrace.sh: prefix addr2line with $CROSS_COMPILE

Don Brace <don.brace@microsemi.com>
    scsi: hpsa: correct ioaccel2 chaining

Alexandre Belloni <alexandre.belloni@bootlin.com>
    usb: gadget: udc: lpc32xx: allocate descriptor with GFP_ATOMIC

Young Xiao <92siuyang@gmail.com>
    usb: gadget: fusb300_udc: Fix memory leak of fusb300->ep[i]

Yu-Hsuan Hsu <yuhsuan@chromium.org>
    ASoC: max98090: remove 24-bit format support if RJ is 0

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/mediatek: fix unbind functions

YueHaibing <yuehaibing@huawei.com>
    spi: bitbang: Fix NULL pointer dereference in spi_unregister_master

Libin Yang <libin.yang@intel.com>
    ASoC: soc-pcm: BE dai needs prepare when pause release after resume

Matt Flax <flatmax@flatmax.org>
    ASoC : cs4265 : readable register too low

Matias Karhumaa <matias.karhumaa@gmail.com>
    Bluetooth: Fix faulty expression for minimum encryption key size check

Xin Long <lucien.xin@gmail.com>
    tipc: pass tunnel dev as NULL to udp_tunnel(6)_xmit_skb

Martin KaFai Lau <kafai@fb.com>
    bpf: udp: ipv6: Avoid running reuseport's bpf_prog from __udp6_lib_err

Martin KaFai Lau <kafai@fb.com>
    bpf: udp: Avoid calling reuseport's bpf_prog from udp_gro

Josh Elsasser <jelsasser@appneta.com>
    net: check before dereferencing netdev_ops during busy poll

Stephen Suryaputra <ssuryaextr@gmail.com>
    ipv4: Use return value of inet_iif() for __raw_v4_lookup in the while loop

YueHaibing <yuehaibing@huawei.com>
    bonding: Always enable vlan tx offload

YueHaibing <yuehaibing@huawei.com>
    team: Always enable vlan tx offload

Fei Li <lifei.shirley@bytedance.com>
    tun: wake up waitqueues after IFF_UP is set

Xin Long <lucien.xin@gmail.com>
    tipc: check msg->req data len in tipc_nl_compat_bearer_disable

Xin Long <lucien.xin@gmail.com>
    tipc: change to use register_pernet_device

Xin Long <lucien.xin@gmail.com>
    sctp: change to hold sk after auth shkey is created successfully

Roland Hii <roland.king.guan.hii@intel.com>
    net: stmmac: fixed new system time seconds value calculation

Neil Horman <nhorman@tuxdriver.com>
    af_packet: Block execution of tasks waiting for transmit to complete in AF_PACKET

Geert Uytterhoeven <geert@linux-m68k.org>
    cpu/speculation: Warn on unsupported mitigations= parameter

Trond Myklebust <trondmy@gmail.com>
    NFS/flexfiles: Use the correct TCP timeout for flexfiles I/O

Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
    x86/speculation: Allow guests to use SSBD even if host does not

Jan Kara <jack@suse.cz>
    scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()

Colin Ian King <colin.king@canonical.com>
    mm/page_idle.c: fix oops because end_pfn is larger than max_pfn

Jann Horn <jannh@google.com>
    fs/binfmt_flat.c: make load_flat_shared_library() work

John Ogness <john.ogness@linutronix.de>
    fs/proc/array.c: allow reporting eip/esp for all coredumping threads

Adeodato Simó <dato@net.com.org.es>
    net/9p: include trans_common.h to fix missing prototype warning.

Dominique Martinet <dominique.martinet@cea.fr>
    9p: p9dirent_read: check network-provided name length

Dominique Martinet <dominique.martinet@cea.fr>
    9p/rdma: remove useless check in cm_event_handler

Dominique Martinet <dominique.martinet@cea.fr>
    9p: acl: fix uninitialized iattr access

Dominique Martinet <dominique.martinet@cea.fr>
    9p/rdma: do not disconnect on down_interruptible EAGAIN

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf header: Fix unchecked usage of strncpy()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf help: Remove needless use of strncpy()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf ui helpline: Use strlcpy() as a shorter form of strncpy() + explicit set nul

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Avoid hardlockup with flushlist_lock

Jouni Malinen <j@w1.fi>
    mac80211: Do not use stack memory with scatterlist for GMAC

Johannes Berg <johannes.berg@intel.com>
    mac80211: drop robust management frames from unknown TA

Eric Biggers <ebiggers@google.com>
    cfg80211: fix memory leak of wiphy device name

Marcel Holtmann <marcel@holtmann.org>
    Bluetooth: Fix regression with minimum encryption key size alignment

Marcel Holtmann <marcel@holtmann.org>
    Bluetooth: Align minimum encryption key size for LE and BR/EDR connections

Fabio Estevam <festevam@gmail.com>
    ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO increase to i.MX6SX

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: use unsigned division instruction for 64-bit operations

Willem de Bruijn <willemb@google.com>
    can: purge socket error queue on sock destruct

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: fix timeout when set small bitrate

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: start readahead also in seed devices

Jaesoo Lee <jalee@purestorage.com>
    nvme: Fix u32 overflow in the number of namespace list calculation

Robert Hancock <hancock@sedsystems.ca>
    hwmon: (pmbus/core) Treat parameters as paged if on multiple pages

Alexandra Winter <wintera@linux.ibm.com>
    s390/qeth: fix VLAN attribute in bridge_hostnotify udev event

Avri Altman <avri.altman@wdc.com>
    scsi: ufs: Check that space was properly alloced in copy_query_response

George G. Davis <george_davis@mentor.com>
    scripts/checkstack.pl: Fix arm64 wrong or unknown architecture

Robin Murphy <robin.murphy@arm.com>
    drm/arm/hdlcd: Allow a bit of clock tolerance

Sean Wang <sean.wang@mediatek.com>
    net: ethernet: mediatek: Use NET_IP_ALIGN to judge if HW RX_2BYTE_OFFSET is enabled

Sean Wang <sean.wang@mediatek.com>
    net: ethernet: mediatek: Use hw_feature to judge if HWLRO is supported

Young Xiao <92siuyang@gmail.com>
    sparc: perf: fix updated event period in response to PERF_EVENT_IOC_PERIOD

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: Fix loopback test failed at copper ports

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    net: dsa: mv88e6xxx: avoid error message on remove from VLAN 0

YueHaibing <yuehaibing@huawei.com>
    MIPS: uprobes: remove set but not used variable 'epc'

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/{qib, hfi1, rdmavt}: Correct ibv_devinfo max_mr value

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Insure freeze_work work_struct is canceled on shutdown

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/rdmavt: Fix alloc_qpn() WARN_ON()

Helge Deller <deller@gmx.de>
    parisc: Fix compiler warnings in float emulation code

YueHaibing <yuehaibing@huawei.com>
    parport: Fix mem leak in parport_register_dev_model

Vineet Gupta <vgupta@synopsys.com>
    ARC: fix build warnings with !CONFIG_KPROBES

Jann Horn <jannh@google.com>
    apparmor: enforce nullbyte at end of tag string

Andrey Smirnov <andrew.smirnov@gmail.com>
    Input: uinput - add compat ioctl number translation for UI_*_FF_UPLOAD

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Silence txreq allocation warnings

Peter Chen <peter.chen@nxp.com>
    usb: chipidea: udc: workaround for endpoint conflict issue

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Avoid runtime suspend possibly being blocked forever

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-9: silence 'address-of-packed-member' warning

Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
    tracing: Silence GCC 9 array bounds warning


-------------

Diffstat:

 Makefile                                           |  6 ++--
 arch/arc/Kconfig                                   |  2 +-
 arch/arc/include/asm/bug.h                         |  3 +-
 arch/arc/include/asm/cmpxchg.h                     | 14 ++++++---
 arch/arc/kernel/traps.c                            |  8 +++++
 arch/arc/mm/tlb.c                                  | 13 ++++----
 arch/arm/mach-imx/cpuidle-imx6sx.c                 |  3 +-
 arch/arm64/kernel/module.c                         |  8 +++--
 arch/arm64/kernel/vdso.c                           | 10 +++----
 arch/ia64/include/asm/bug.h                        |  6 +++-
 arch/m68k/include/asm/bug.h                        |  3 ++
 arch/mips/Kconfig                                  |  1 +
 arch/mips/include/asm/compiler.h                   | 35 ++++++++++++++++++++++
 arch/mips/include/asm/netlogic/xlr/fmn.h           |  2 --
 arch/mips/kernel/uprobes.c                         |  3 --
 arch/mips/math-emu/cp1emu.c                        |  4 +--
 arch/mips/mm/tlbex.c                               | 29 ++++++++++++------
 arch/parisc/math-emu/cnv_float.h                   |  8 ++---
 arch/powerpc/include/asm/ppc-opcode.h              |  1 +
 arch/powerpc/net/bpf_jit.h                         |  2 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |  8 ++---
 arch/sparc/include/asm/bug.h                       |  6 +++-
 arch/sparc/kernel/perf_event.c                     |  4 +++
 arch/x86/kernel/cpu/bugs.c                         | 11 ++++++-
 arch/x86/kvm/lapic.c                               |  2 +-
 arch/x86/kvm/x86.c                                 |  6 ++--
 crypto/crypto_user.c                               |  3 ++
 drivers/clk/sunxi/clk-sun8i-bus-gates.c            |  4 +++
 drivers/dma/imx-sdma.c                             |  4 +--
 drivers/gpu/drm/arm/hdlcd_crtc.c                   |  3 +-
 drivers/gpu/drm/i915/intel_csr.c                   | 18 +++++++++++
 drivers/gpu/drm/imx/ipuv3-crtc.c                   |  6 ++--
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |  2 ++
 drivers/hwmon/pmbus/pmbus_core.c                   | 34 ++++++++++++++++++---
 drivers/infiniband/hw/hfi1/chip.c                  |  1 +
 drivers/infiniband/hw/hfi1/sdma.c                  |  9 ++----
 drivers/infiniband/hw/hfi1/user_sdma.c             | 13 +++-----
 drivers/infiniband/hw/hfi1/verbs.c                 |  2 --
 drivers/infiniband/hw/hfi1/verbs_txreq.c           |  2 +-
 drivers/infiniband/hw/hfi1/verbs_txreq.h           |  3 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |  2 --
 drivers/infiniband/sw/rdmavt/mr.c                  |  2 ++
 drivers/infiniband/sw/rdmavt/qp.c                  |  3 +-
 drivers/input/misc/uinput.c                        | 22 ++++++++++++--
 drivers/mfd/omap-usb-tll.c                         |  4 +--
 drivers/net/bonding/bond_main.c                    |  2 +-
 drivers/net/can/flexcan.c                          |  2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |  4 +++
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        | 15 +++++-----
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |  2 +-
 drivers/net/team/team.c                            |  2 +-
 drivers/net/tun.c                                  | 19 ++++++------
 drivers/nvme/host/core.c                           |  3 +-
 drivers/parport/share.c                            |  2 ++
 drivers/s390/net/qeth_l2_main.c                    |  2 +-
 drivers/scsi/hpsa.c                                |  7 ++++-
 drivers/scsi/hpsa_cmd.h                            |  1 +
 drivers/scsi/ufs/ufshcd-pltfrm.c                   | 11 +++----
 drivers/scsi/ufs/ufshcd.c                          |  3 +-
 drivers/scsi/vmw_pvscsi.c                          |  6 ++--
 drivers/spi/spi-bitbang.c                          |  2 +-
 drivers/tty/rocket.c                               |  2 +-
 drivers/usb/chipidea/udc.c                         | 20 +++++++++++++
 drivers/usb/gadget/udc/fusb300_udc.c               |  5 ++++
 drivers/usb/gadget/udc/lpc32xx_udc.c               |  3 +-
 fs/9p/acl.c                                        |  2 +-
 fs/binfmt_flat.c                                   | 23 +++++---------
 fs/btrfs/dev-replace.c                             | 29 +++++++++++-------
 fs/btrfs/reada.c                                   |  5 ++++
 fs/btrfs/volumes.c                                 |  2 ++
 fs/btrfs/volumes.h                                 |  5 ++++
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |  2 +-
 fs/proc/array.c                                    |  2 +-
 include/asm-generic/bug.h                          |  1 +
 include/linux/compiler-gcc.h                       | 15 +++++++++-
 include/linux/compiler.h                           |  5 ++++
 include/net/bluetooth/hci_core.h                   |  3 ++
 kernel/cpu.c                                       |  3 ++
 kernel/ptrace.c                                    |  4 +--
 kernel/trace/trace.c                               |  6 +---
 kernel/trace/trace.h                               | 18 +++++++++++
 kernel/trace/trace_kdb.c                           |  6 +---
 lib/mpi/mpi-pow.c                                  |  6 ++--
 mm/mlock.c                                         |  4 +--
 mm/page_idle.c                                     |  4 +--
 net/9p/protocol.c                                  | 12 ++++++--
 net/9p/trans_common.c                              |  1 +
 net/9p/trans_rdma.c                                |  7 ++---
 net/bluetooth/hci_conn.c                           | 10 ++++++-
 net/bluetooth/l2cap_core.c                         | 33 ++++++++++++++++----
 net/can/af_can.c                                   |  1 +
 net/core/dev.c                                     |  5 +++-
 net/ipv4/raw.c                                     |  2 +-
 net/ipv4/udp.c                                     |  6 +++-
 net/ipv6/udp.c                                     |  4 +--
 net/mac80211/rx.c                                  |  2 ++
 net/mac80211/wpa.c                                 |  7 ++++-
 net/packet/af_packet.c                             | 20 +++++++++++--
 net/packet/internal.h                              |  1 +
 net/sctp/endpointola.c                             |  8 ++---
 net/tipc/core.c                                    | 12 ++++----
 net/tipc/netlink_compat.c                          | 18 +++++++++--
 net/tipc/udp_media.c                               |  8 ++---
 net/wireless/core.c                                |  2 +-
 scripts/checkstack.pl                              |  2 +-
 scripts/decode_stacktrace.sh                       |  2 +-
 security/apparmor/policy_unpack.c                  |  2 +-
 sound/core/seq/oss/seq_oss_ioctl.c                 |  2 +-
 sound/core/seq/oss/seq_oss_rw.c                    |  2 +-
 sound/firewire/amdtp-am824.c                       |  2 +-
 sound/soc/codecs/cs4265.c                          |  2 +-
 sound/soc/codecs/max98090.c                        | 16 ++++++++++
 sound/soc/soc-pcm.c                                |  3 +-
 sound/usb/line6/pcm.c                              |  5 ++++
 sound/usb/mixer_quirks.c                           |  4 +--
 tools/perf/builtin-help.c                          |  2 +-
 tools/perf/ui/tui/helpline.c                       |  2 +-
 tools/perf/util/header.c                           |  2 +-
 119 files changed, 568 insertions(+), 234 deletions(-)


