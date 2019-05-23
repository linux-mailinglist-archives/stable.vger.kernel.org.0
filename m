Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F76286A7
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388141AbfEWTLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388138AbfEWTLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:11:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 640D721841;
        Thu, 23 May 2019 19:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638677;
        bh=TGcvWQvQGIernpU3yaDoIBIeBrPgtm5Dsczx9DWINLM=;
        h=From:To:Cc:Subject:Date:From;
        b=GDSYSzfd9JTD/yyw5Rbbcb7/HdcCbcDl6c9UO1jzPgZBKxwuDnhcPQ3PW61tIOKee
         TLwYmnGPp0up77TpzbAHoPEweH12XLPzVlig+C+HacmuduYYuA75DzxOJdSI6EHqIn
         MhhxFOnba1el4SMC5eRrKRkz7g4D33W5CV6noF/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/77] 4.14.122-stable review
Date:   Thu, 23 May 2019 21:05:18 +0200
Message-Id: <20190523181719.982121681@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.122-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.122-rc1
X-KernelTest-Deadline: 2019-05-25T18:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.122 release.
There are 77 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 25 May 2019 06:15:09 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.122-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.122-rc1

Nikolay Borisov <nborisov@suse.com>
    btrfs: Honour FITRIM range constraints during free space trim

Daniel Borkmann <daniel@iogearbox.net>
    bpf, lru: avoid messing with eviction heuristics upon syscall lookup

Daniel Borkmann <daniel@iogearbox.net>
    bpf: add map_lookup_elem_sys_only for lookups from syscall side

John Garry <john.garry@huawei.com>
    driver core: Postpone DMA tear-down until after devres release for probe failure

Nigel Croxon <ncroxon@redhat.com>
    md/raid: raid5 preserve the writeback action after the parity check

Song Liu <songliubraving@fb.com>
    Revert "Don't jump to compute_result state from check_result state"

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf bench numa: Add define for RUSAGE_THREAD if not present

Al Viro <viro@zeniv.linux.org.uk>
    ufs: fix braino in ufs_get_inode_gid() for solaris UFS flavour

Gary Hook <Gary.Hook@amd.com>
    x86/mm/mem_encrypt: Disable all instrumentation for early SME setup

Tobin C. Harding <tobin@kernel.org>
    sched/cpufreq: Fix kobject memleak

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: check for length correctness in iwl_mvm_create_skb()

Andrey Smirnov <andrew.smirnov@gmail.com>
    power: supply: sysfs: prevent endless uevent loop with CONFIG_POWER_SUPPLY_DEBUG

Andrew Jones <drjones@redhat.com>
    KVM: arm/arm64: Ensure vcpu target is unset on reset failure

Bhagavathi Perumal S <bperumal@codeaurora.org>
    mac80211: Fix kernel panic due to use of txq after free

Al Viro <viro@zeniv.linux.org.uk>
    apparmorfs: fix use-after-free on symlink traversal

Al Viro <viro@zeniv.linux.org.uk>
    securityfs: fix use-after-free on symlink traversal

Tony Lindgren <tony@atomide.com>
    power: supply: cpcap-battery: Fix division by zero

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm4: Fix uninitialized memory read in _decode_session4

Sabrina Dubroca <sd@queasysnail.net>
    esp4: add length check for UDP encapsulation

Jeremy Sowden <jeremy@azazel.net>
    vti4: ipip tunnel deregistration fixes.

Su Yanjun <suyj.fnst@cn.fujitsu.com>
    xfrm6_tunnel: Fix potential panic when unloading xfrm6_tunnel module

YueHaibing <yuehaibing@huawei.com>
    xfrm: policy: Fix out-of-bound array accesses in __xfrm_policy_unlink

Mikulas Patocka <mpatocka@redhat.com>
    dm delay: fix a crash when invalid device is specified

Damien Le Moal <damien.lemoal@wdc.com>
    dm zoned: Fix zone report handling

Nikos Tsironis <ntsironis@arrikto.com>
    dm cache metadata: Fix loading discard bitset

Stefan Mätje <stefan.maetje@esd.eu>
    PCI: Work around Pericom PCIe-to-PCI bridge Retrain Link erratum

Stefan Mätje <stefan.maetje@esd.eu>
    PCI: Factor out pcie_retrain_link() function

James Prestwood <james.prestwood@linux.intel.com>
    PCI: Mark Atheros AR9462 to avoid bus reset

Nikolai Kostrigin <nickel@altlinux.org>
    PCI: Mark AMD Stoney Radeon R7 GPU ATS as broken

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: fix crashes and garbled display during DPMS modesetting

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: use 1024x768 by default on non-MIPS, fix garbled display

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: fix support for 1024x768-16 mode

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: fix crashes during framebuffer writes by correctly mapping VRAM

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: fix boot screen glitch when sm712fb replaces VGA

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: fix white screen of death on reboot, don't set CR3B-CR3F

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: fix VRAM detection, don't set SR70/71/74/75

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: fix brightness control on reboot, don't set SR30

Nathan Chancellor <natechancellor@gmail.com>
    objtool: Allow AR to be overridden with HOSTAR

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix sample timestamp wrt non-taken branches

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix improved sample timestamp

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix instructions sampling rate

Dmitry Osipenko <digetx@gmail.com>
    memory: tegra: Fix integer overflow on tick value calculation

Elazar Leibovich <elazar@lightbitslabs.com>
    tracing: Fix partial reading of trace event's id file

Peter Zijlstra <peterz@infradead.org>
    ftrace/x86_64: Emulate call function while updating in breakpoint handler

Peter Zijlstra <peterz@infradead.org>
    x86_64: Allow breakpoints to emulate call instructions

Josh Poimboeuf <jpoimboe@redhat.com>
    x86_64: Add gap to int3 to allow for call emulation

Jeff Layton <jlayton@kernel.org>
    ceph: flush dirty inodes before proceeding with remount

Dmitry Osipenko <digetx@gmail.com>
    iommu/tegra-smmu: Fix invalid ASID bits on Tegra30/114

Liu Bo <bo.liu@linux.alibaba.com>
    fuse: honor RLIMIT_FSIZE in fuse_file_fallocate

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix writepages on 32bit

Jonas Karlman <jonas@kwiboo.se>
    clk: rockchip: fix wrong clock definitions for rk3328

Dmitry Osipenko <digetx@gmail.com>
    clk: tegra: Fix PLLM programming on Tegra124+ when PMC overrides divider

Leo Yan <leo.yan@linaro.org>
    clk: hi3660: Mark clk_gate_ufs_subsys as critical

Olga Kornievskaia <kolga@netapp.com>
    PNFS fallback to MDS if no deviceid found

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    NFS4: Fix v4.0 client state corruption when mount

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "cifs: fix memory leak in SMB2_read"

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix sensor possibly not detected on probe

Christoph Probst <kernel@probst.it>
    cifs: fix strcat buffer overflow and reduce raciness in smb21_set_oplock_level()

Phong Tran <tranmanphong@gmail.com>
    of: fix clang -Wunsequenced for be32_to_cpu()

Pan Bian <bianpan2016@163.com>
    p54: drop device reference count if fails to enable device

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: msu: Fix single mode with IOMMU

Yufen Yu <yuyufen@huawei.com>
    md: add mddev->pers to avoid potential NULL pointer dereference

Tingwei Zhang <tingwei@codeaurora.org>
    stm class: Fix channel free in stm output free path

Helge Deller <deller@gmx.de>
    parisc: Rename LEVEL to PA_ASM_LEVEL to avoid name clash with DRBD code

Helge Deller <deller@gmx.de>
    parisc: Use PA_ASM_LEVEL in boot code

Helge Deller <deller@gmx.de>
    parisc: Skip registering LED when running in QEMU

Helge Deller <deller@gmx.de>
    parisc: Export running_on_qemu symbol for modules

Florian Fainelli <f.fainelli@gmail.com>
    net: Always descend into dsa/

Jorge E. Moreira <jemoreira@google.com>
    vsock/virtio: Initialize core virtio vsock before registering the driver

Junwei Hu <hujunwei4@huawei.com>
    tipc: fix modprobe tipc failed after switch order of device registration

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: free packets during the socket release

Junwei Hu <hujunwei4@huawei.com>
    tipc: switch order of device registration to fix a crash

YueHaibing <yuehaibing@huawei.com>
    ppp: deflate: Fix possible crash in deflate_init

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit 0x1260 and 0x1261 compositions

Willem de Bruijn <willemb@google.com>
    net: test nouarg before dereferencing zerocopy pointers

Yunjian Wang <wangyunjian@huawei.com>
    net/mlx4_core: Change the error print to info print

Eric Dumazet <edumazet@google.com>
    net: avoid weird emergency message


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/parisc/boot/compressed/head.S                 |   6 +-
 arch/parisc/include/asm/assembly.h                 |   6 +-
 arch/parisc/kernel/head.S                          |   4 +-
 arch/parisc/kernel/process.c                       |   1 +
 arch/parisc/kernel/syscall.S                       |   2 +-
 arch/x86/entry/entry_64.S                          |  18 +-
 arch/x86/include/asm/text-patching.h               |  28 +++
 arch/x86/kernel/ftrace.c                           |  32 ++-
 arch/x86/lib/Makefile                              |  12 +
 drivers/base/dd.c                                  |   5 +-
 drivers/clk/hisilicon/clk-hi3660.c                 |   6 +-
 drivers/clk/rockchip/clk-rk3328.c                  |  18 +-
 drivers/clk/tegra/clk-pll.c                        |   4 +-
 drivers/hwtracing/intel_th/msu.c                   |  35 ++-
 drivers/hwtracing/stm/core.c                       |   2 +-
 drivers/iommu/tegra-smmu.c                         |  25 ++-
 drivers/md/dm-cache-metadata.c                     |   9 +-
 drivers/md/dm-delay.c                              |   3 +-
 drivers/md/dm-zoned-metadata.c                     |   5 +
 drivers/md/md.c                                    |   6 +-
 drivers/md/raid5.c                                 |  29 ++-
 drivers/media/i2c/ov6650.c                         |   2 +
 drivers/memory/tegra/mc.c                          |   2 +-
 drivers/net/Makefile                               |   2 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |   2 +-
 drivers/net/ppp/ppp_deflate.c                      |  20 +-
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  28 ++-
 drivers/net/wireless/intersil/p54/p54pci.c         |   3 +-
 drivers/parisc/led.c                               |   3 +
 drivers/pci/pcie/aspm.c                            |  49 +++--
 drivers/pci/quirks.c                               |  19 ++
 drivers/power/supply/cpcap-battery.c               |   3 +
 drivers/power/supply/power_supply_sysfs.c          |   6 -
 drivers/video/fbdev/sm712.h                        |  12 +-
 drivers/video/fbdev/sm712fb.c                      | 242 +++++++++++++++++----
 fs/btrfs/extent-tree.c                             |  25 ++-
 fs/ceph/super.c                                    |   7 +
 fs/cifs/smb2ops.c                                  |  14 +-
 fs/cifs/smb2pdu.c                                  |   1 -
 fs/fuse/file.c                                     |   9 +-
 fs/nfs/filelayout/filelayout.c                     |   2 +-
 fs/nfs/nfs4state.c                                 |   4 +
 fs/ufs/util.h                                      |   2 +-
 include/linux/bpf.h                                |   1 +
 include/linux/of.h                                 |   4 +-
 include/linux/pci.h                                |   2 +
 include/linux/skbuff.h                             |   9 +-
 kernel/bpf/hashtab.c                               |  23 +-
 kernel/bpf/syscall.c                               |   5 +-
 kernel/sched/cpufreq_schedutil.c                   |   1 +
 kernel/trace/trace_events.c                        |   3 -
 lib/Makefile                                       |  11 +
 net/core/dev.c                                     |   2 +-
 net/ipv4/esp4.c                                    |  20 +-
 net/ipv4/ip_vti.c                                  |   5 +-
 net/ipv4/xfrm4_policy.c                            |  24 +-
 net/ipv6/xfrm6_tunnel.c                            |   4 +
 net/mac80211/iface.c                               |   3 +
 net/tipc/core.c                                    |  14 +-
 net/vmw_vsock/virtio_transport.c                   |  13 +-
 net/vmw_vsock/virtio_transport_common.c            |   7 +
 net/xfrm/xfrm_user.c                               |   2 +-
 security/apparmor/apparmorfs.c                     |  13 +-
 security/inode.c                                   |  13 +-
 tools/objtool/Makefile                             |   3 +-
 tools/perf/bench/numa.c                            |   4 +
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |  31 ++-
 virt/kvm/arm/arm.c                                 |  11 +-
 70 files changed, 720 insertions(+), 227 deletions(-)


