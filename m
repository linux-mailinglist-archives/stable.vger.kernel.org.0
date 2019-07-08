Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43C6C62169
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732469AbfGHPQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732479AbfGHPQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:16:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F434216C4;
        Mon,  8 Jul 2019 15:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562598966;
        bh=VdzGNA+JCoHezvwpAL7bv3MPCaxAr4ulKc/vjXuVuwk=;
        h=From:To:Cc:Subject:Date:From;
        b=H1uEhdvDsMBIo3c5bJBiP6HV/O6tbTRnKMsuMBmAV4SkoWzsy33SghNq9lULUU010
         wsS0SkNbWvlBtVp54tw4Gc3n3CCZ/lNi8IiriHwU19M5Wk+968LsalSYNep5As5gqy
         Obj4cQ4xfDcWGfV+nW5TSWrQfMnn0xNg5B/LV7to=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/73] 4.4.185-stable review
Date:   Mon,  8 Jul 2019 17:12:10 +0200
Message-Id: <20190708150513.136580595@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.185-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.185-rc1
X-KernelTest-Deadline: 2019-07-10T15:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.185 release.
There are 73 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.185-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.185-rc1

Robin Gong <yibin.gong@nxp.com>
    dmaengine: imx-sdma: remove BD_INTR for channel0

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: degrade WARN to pr_warn_ratelimited

Kees Cook <keescook@chromium.org>
    arm64, vdso: Define vdso_{start,end} as array

Vineet Gupta <vgupta@synopsys.com>
    ARC: handle gcc generated __builtin_trap for older compiler

Linus Torvalds <torvalds@linux-foundation.org>
    tty: rocket: fix incorrect forward declaration of 'rp_init()'

Nikolay Borisov <nborisov@suse.com>
    btrfs: Ensure replaced device doesn't have pending chunk allocation

Herbert Xu <herbert@gondor.apana.org.au>
    lib/mpi: Fix karactx leak in mpi_powm

Colin Ian King <colin.king@canonical.com>
    ALSA: usb-audio: fix sign unintended sign extension on left shifts

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

Arnd Bergmann <arnd@arndb.de>
    bug.h: work around GCC PR82365 in BUG()

Thierry Reding <treding@nvidia.com>
    swiotlb: Make linux/swiotlb.h standalone includible

Arnd Bergmann <arnd@arndb.de>
    mfd: omap-usb-tll: Fix register offsets

Manuel Lauss <manuel.lauss@gmail.com>
    MIPS: math-emu: do not use bools for arithmetic

Vineet Gupta <vgupta@synopsys.com>
    ARC: fix build warning in elf.h

Vineet Gupta <vgupta@synopsys.com>
    ARC: Assume multiplier is always present

Don Brace <don.brace@microsemi.com>
    scsi: hpsa: correct ioaccel2 chaining

Alexandre Belloni <alexandre.belloni@bootlin.com>
    usb: gadget: udc: lpc32xx: allocate descriptor with GFP_ATOMIC

Young Xiao <92siuyang@gmail.com>
    usb: gadget: fusb300_udc: Fix memory leak of fusb300->ep[i]

Yu-Hsuan Hsu <yuhsuan@chromium.org>
    ASoC: max98090: remove 24-bit format support if RJ is 0

YueHaibing <yuehaibing@huawei.com>
    spi: bitbang: Fix NULL pointer dereference in spi_unregister_master

Matt Flax <flatmax@flatmax.org>
    ASoC : cs4265 : readable register too low

Jason A. Donenfeld <Jason@zx2c4.com>
    um: Compile with modern headers

Matias Karhumaa <matias.karhumaa@gmail.com>
    Bluetooth: Fix faulty expression for minimum encryption key size check

Josh Elsasser <jelsasser@appneta.com>
    net: check before dereferencing netdev_ops during busy poll

YueHaibing <yuehaibing@huawei.com>
    bonding: Always enable vlan tx offload

Stephen Suryaputra <ssuryaextr@gmail.com>
    ipv4: Use return value of inet_iif() for __raw_v4_lookup in the while loop

YueHaibing <yuehaibing@huawei.com>
    team: Always enable vlan tx offload

Xin Long <lucien.xin@gmail.com>
    tipc: check msg->req data len in tipc_nl_compat_bearer_disable

Xin Long <lucien.xin@gmail.com>
    tipc: change to use register_pernet_device

Xin Long <lucien.xin@gmail.com>
    sctp: change to hold sk after auth shkey is created successfully

Geert Uytterhoeven <geert@linux-m68k.org>
    cpu/speculation: Warn on unsupported mitigations= parameter

Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
    x86/speculation: Allow guests to use SSBD even if host does not

Vivek Goyal <vgoyal@redhat.com>
    ovl: modify ovl_permission() to do checks on two inodes

Wanpeng Li <wanpengli@tencent.com>
    KVM: X86: Fix scan ioapic use-before-initialization

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
    perf help: Remove needless use of strncpy()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf ui helpline: Use strlcpy() as a shorter form of strncpy() + explicit set nul

Johannes Berg <johannes.berg@intel.com>
    mac80211: drop robust management frames from unknown TA

Eric Biggers <ebiggers@google.com>
    cfg80211: fix memory leak of wiphy device name

Steve French <stfrench@microsoft.com>
    SMB3: retry on STATUS_INSUFFICIENT_RESOURCES instead of failing write

Marcel Holtmann <marcel@holtmann.org>
    Bluetooth: Fix regression with minimum encryption key size alignment

Marcel Holtmann <marcel@holtmann.org>
    Bluetooth: Align minimum encryption key size for LE and BR/EDR connections

Fabio Estevam <festevam@gmail.com>
    ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO increase to i.MX6SX

Willem de Bruijn <willemb@google.com>
    can: purge socket error queue on sock destruct

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: fix timeout when set small bitrate

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: start readahead also in seed devices

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race between readahead and device replace/removal

Robert Hancock <hancock@sedsystems.ca>
    hwmon: (pmbus/core) Treat parameters as paged if on multiple pages

Alexandra Winter <wintera@linux.ibm.com>
    s390/qeth: fix VLAN attribute in bridge_hostnotify udev event

Avri Altman <avri.altman@wdc.com>
    scsi: ufs: Check that space was properly alloced in copy_query_response

George G. Davis <george_davis@mentor.com>
    scripts/checkstack.pl: Fix arm64 wrong or unknown architecture

Young Xiao <92siuyang@gmail.com>
    sparc: perf: fix updated event period in response to PERF_EVENT_IOC_PERIOD

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: Fix loopback test failed at copper ports

YueHaibing <yuehaibing@huawei.com>
    MIPS: uprobes: remove set but not used variable 'epc'

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Insure freeze_work work_struct is canceled on shutdown

Helge Deller <deller@gmx.de>
    parisc: Fix compiler warnings in float emulation code

YueHaibing <yuehaibing@huawei.com>
    parport: Fix mem leak in parport_register_dev_model

Jann Horn <jannh@google.com>
    apparmor: enforce nullbyte at end of tag string

Andrey Smirnov <andrew.smirnov@gmail.com>
    Input: uinput - add compat ioctl number translation for UI_*_FF_UPLOAD

Peter Chen <peter.chen@nxp.com>
    usb: chipidea: udc: workaround for endpoint conflict issue

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-9: silence 'address-of-packed-member' warning

Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
    tracing: Silence GCC 9 array bounds warning

Jan Kara <jack@suse.cz>
    scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()

Colin Ian King <colin.king@canonical.com>
    mm/page_idle.c: fix oops because end_pfn is larger than max_pfn

Jann Horn <jannh@google.com>
    fs/binfmt_flat.c: make load_flat_shared_library() work


-------------

Diffstat:

 Makefile                                         |  6 ++--
 arch/arc/Kconfig                                 |  8 ------
 arch/arc/Makefile                                |  4 ---
 arch/arc/include/asm/bug.h                       |  3 +-
 arch/arc/include/asm/elf.h                       |  2 +-
 arch/arc/kernel/setup.c                          |  2 --
 arch/arc/kernel/traps.c                          |  8 ++++++
 arch/arm/mach-imx/cpuidle-imx6sx.c               |  3 +-
 arch/arm64/kernel/vdso.c                         | 10 +++----
 arch/ia64/include/asm/bug.h                      |  6 +++-
 arch/m68k/include/asm/bug.h                      |  3 ++
 arch/mips/Kconfig                                |  1 +
 arch/mips/include/asm/compiler.h                 | 35 ++++++++++++++++++++++++
 arch/mips/kernel/uprobes.c                       |  3 --
 arch/mips/math-emu/cp1emu.c                      |  4 +--
 arch/parisc/math-emu/cnv_float.h                 |  8 +++---
 arch/sparc/include/asm/bug.h                     |  6 +++-
 arch/sparc/kernel/perf_event.c                   |  4 +++
 arch/um/os-Linux/file.c                          |  1 +
 arch/um/os-Linux/signal.c                        |  2 ++
 arch/x86/kernel/cpu/bugs.c                       | 11 +++++++-
 arch/x86/kvm/x86.c                               |  9 +++---
 arch/x86/um/stub_segv.c                          |  1 +
 crypto/crypto_user.c                             |  3 ++
 drivers/dma/imx-sdma.c                           |  4 +--
 drivers/hwmon/pmbus/pmbus_core.c                 | 34 ++++++++++++++++++++---
 drivers/input/misc/uinput.c                      | 22 +++++++++++++--
 drivers/mfd/omap-usb-tll.c                       |  4 +--
 drivers/net/bonding/bond_main.c                  |  2 +-
 drivers/net/can/flexcan.c                        |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c |  4 +++
 drivers/net/team/team.c                          |  2 +-
 drivers/parport/share.c                          |  2 ++
 drivers/s390/net/qeth_l2_main.c                  |  2 +-
 drivers/scsi/hpsa.c                              |  7 ++++-
 drivers/scsi/hpsa_cmd.h                          |  1 +
 drivers/scsi/ufs/ufshcd.c                        |  3 +-
 drivers/scsi/vmw_pvscsi.c                        |  6 ++--
 drivers/spi/spi-bitbang.c                        |  2 +-
 drivers/staging/rdma/hfi1/chip.c                 |  1 +
 drivers/tty/rocket.c                             |  2 +-
 drivers/usb/chipidea/udc.c                       | 20 ++++++++++++++
 drivers/usb/gadget/udc/fusb300_udc.c             |  5 ++++
 drivers/usb/gadget/udc/lpc32xx_udc.c             |  3 +-
 fs/9p/acl.c                                      |  2 +-
 fs/binfmt_flat.c                                 | 24 +++++-----------
 fs/btrfs/dev-replace.c                           | 29 +++++++++++++-------
 fs/btrfs/reada.c                                 |  7 +++++
 fs/btrfs/volumes.c                               |  2 ++
 fs/btrfs/volumes.h                               |  5 ++++
 fs/cifs/smb2maperror.c                           |  2 +-
 fs/overlayfs/inode.c                             | 13 +++++++++
 include/asm-generic/bug.h                        |  1 +
 include/linux/compiler-gcc.h                     | 15 +++++++++-
 include/linux/compiler.h                         |  5 ++++
 include/linux/swiotlb.h                          |  3 ++
 include/net/bluetooth/hci_core.h                 |  3 ++
 include/net/busy_poll.h                          |  2 +-
 kernel/cpu.c                                     |  3 ++
 kernel/ptrace.c                                  |  4 +--
 kernel/trace/trace.c                             |  6 +---
 kernel/trace/trace.h                             | 18 ++++++++++++
 kernel/trace/trace_kdb.c                         |  6 +---
 lib/mpi/mpi-pow.c                                |  6 ++--
 mm/page_idle.c                                   |  4 +--
 net/9p/protocol.c                                | 12 ++++++--
 net/9p/trans_common.c                            |  1 +
 net/9p/trans_rdma.c                              |  7 ++---
 net/bluetooth/hci_conn.c                         | 10 ++++++-
 net/bluetooth/l2cap_core.c                       | 33 ++++++++++++++++++----
 net/can/af_can.c                                 |  1 +
 net/ipv4/raw.c                                   |  2 +-
 net/mac80211/rx.c                                |  2 ++
 net/sctp/endpointola.c                           |  8 +++---
 net/tipc/core.c                                  | 12 ++++----
 net/tipc/netlink_compat.c                        | 18 ++++++++++--
 net/wireless/core.c                              |  2 +-
 scripts/checkstack.pl                            |  2 +-
 security/apparmor/policy_unpack.c                |  2 +-
 sound/core/seq/oss/seq_oss_ioctl.c               |  2 +-
 sound/core/seq/oss/seq_oss_rw.c                  |  2 +-
 sound/firewire/amdtp-am824.c                     |  2 +-
 sound/soc/codecs/cs4265.c                        |  2 +-
 sound/soc/codecs/max98090.c                      | 16 +++++++++++
 sound/usb/mixer_quirks.c                         |  4 +--
 tools/perf/builtin-help.c                        |  2 +-
 tools/perf/ui/tui/helpline.c                     |  2 +-
 87 files changed, 424 insertions(+), 151 deletions(-)


