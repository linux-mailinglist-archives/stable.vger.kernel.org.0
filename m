Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12DAA799B3
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbfG2TYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388048AbfG2TYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:24:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8853221655;
        Mon, 29 Jul 2019 19:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428272;
        bh=FpVed+0HNM+rLiJy1ll1h2iYIP7vnZxMxq8Jj1eeKIo=;
        h=From:To:Cc:Subject:Date:From;
        b=YqlzXRrhfNkBvynmVbNYfmvfxC5hmsntmyYh4mG4tCfGZdudJtd9gVwshZm10VGBq
         FdhvDV9ENUHhpIzqIObX4vX1pzNvVaVu+OAPJL9HHNMPJCEFuJO43k1tbwsxWBMxXz
         j1yqXI4k1mSsqfWR4vD98EtQiPysoTywmy82KRUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/293] 4.14.135-stable review
Date:   Mon, 29 Jul 2019 21:18:11 +0200
Message-Id: <20190729190820.321094988@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.135-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.135-rc1
X-KernelTest-Deadline: 2019-07-31T19:08+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.135 release.
There are 293 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 31 Jul 2019 07:05:01 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.135-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.135-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    access: avoid the RCU grace period for the temporary subjective credentials

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Fix oops on sigreturn on systems without TM

Gautham R. Shenoy <ego@linux.vnet.ibm.com>
    powerpc/xive: Fix loop exit-condition in xive_find_target_in_mask()

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - Add a conexant codec entry to let mute led work

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: line6: Fix wrong altsetting for LINE6_PODHD500_1

Kefeng Wang <wangkefeng.wang@huawei.com>
    hpet: Fix division by zero in hpet_time_div()

YueHaibing <yuehaibing@huawei.com>
    fpga-manager: altera-ps-spi: Fix build error

Hridya Valsaraju <hridya@google.com>
    binder: prevent transactions to context manager from its own process.

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    x86/speculation/mds: Apply more accurate check on hypervisor platform

Hans de Goede <hdegoede@redhat.com>
    x86/sysfb_efi: Add quirks for some devices with swapped width and height

Qu Wenruo <wqu@suse.com>
    btrfs: inode: Don't compress if NODATASUM or NODATACOW set

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: do not use dangling shadow VMCS after guest reset

Ryan Kennedy <ryan5544@gmail.com>
    usb: pci-quirks: Correct AMD PLL quirk detection

Phong Tran <tranmanphong@gmail.com>
    usb: wusbcore: fix unbalanced get/put cluster_id

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/crc-debugfs: Also sprinkle irqrestore over early exits

Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
    drm/crc: Only report a single overflow when a CRC fd is opened

Arnd Bergmann <arnd@arndb.de>
    locking/lockdep: Hide unused 'class' variable

Yuyang Du <duyuyang@gmail.com>
    locking/lockdep: Fix lock used or unused stats error

Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
    mm/mmu_notifier: use hlist_add_head_rcu()

Andy Lutomirski <luto@kernel.org>
    mm/gup.c: remove some BUG_ONs from get_gate_page()

Guenter Roeck <linux@roeck-us.net>
    mm/gup.c: mark undo_dev_pagemap as __maybe_unused

Christoph Hellwig <hch@lst.de>
    9p: pass the correct prototype to read_cache_page

Dmitry Vyukov <dvyukov@google.com>
    mm/kmemleak.c: fix check for softirq context

Sam Ravnborg <sam@ravnborg.org>
    sh: prevent warnings when using iounmap

Wenwen Wang <wenwen@cs.uga.edu>
    block/bio-integrity: fix a memory leak bug

Oliver O'Halloran <oohall@gmail.com>
    powerpc/eeh: Handle hugepages in ioremap space

morten petersen <morten_bp@live.dk>
    mailbox: handle failed named mailbox channel request

Ocean Chen <oceanchen@google.com>
    f2fs: avoid out-of-range memory access

Masahiro Yamada <yamada.masahiro@socionext.com>
    powerpc/boot: add {get, put}_unaligned_be32 to xz_config.h

YueHaibing <yuehaibing@huawei.com>
    PCI: dwc: pci-dra7xx: Fix compilation when !CONFIG_GPIOLIB

Konstantin Taranov <konstantin.taranov@inf.ethz.ch>
    RDMA/rxe: Fill in wc byte_len with IB_WC_RECV_RDMA_WITH_IMM

Leo Yan <leo.yan@linaro.org>
    perf annotate: Fix dereferencing freed memory found by the smatch tool

Leo Yan <leo.yan@linaro.org>
    perf session: Fix potential NULL pointer dereference found by the smatch tool

Numfor Mbiziwo-Tiapo <nums@google.com>
    perf test mmap-thread-lookup: Initialize variable to suppress memory sanitizer warning

Vasily Gorbik <gor@linux.ibm.com>
    kallsyms: exclude kasan local symbols on s390

Geert Uytterhoeven <geert+renesas@glider.be>
    serial: sh-sci: Fix TX DMA buffer flushing and workqueue races

Geert Uytterhoeven <geert+renesas@glider.be>
    serial: sh-sci: Terminate TX DMA during buffer flushing

Liu, Changcheng <changcheng.liu@intel.com>
    RDMA/i40iw: Set queue pair state when being queried

Christian Lamparter <chunkeey@gmail.com>
    powerpc/4xx/uic: clear pending interrupt after irq type/pol change

Johannes Berg <johannes.berg@intel.com>
    um: Silence lockdep complaint about mmap_sem

Axel Lin <axel.lin@ingics.com>
    mfd: hi655x-pmic: Fix missing return value check for devm_regmap_init_mmio_clk

Arnd Bergmann <arnd@arndb.de>
    mfd: arizona: Fix undefined behavior

Robert Hancock <hancock@sedsystems.ca>
    mfd: core: Set fwnode for created devices

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    recordmcount: Fix spurious mcount entries on powerpc

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/xmon: Fix disabling tracing while in xmon

Bastien Nocera <hadess@hadess.net>
    iio: iio-utils: Fix possible incorrect mask calculation

Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>
    PCI: xilinx-nwl: Fix Multi MSI data programming

Nathan Chancellor <natechancellor@gmail.com>
    kbuild: Add -Werror=unknown-warning-option to CLANG_FLAGS

Marek Vasut <marek.vasut+renesas@gmail.com>
    PCI: sysfs: Ignore lockdep for remove attribute

Stefan Roese <sr@denx.de>
    serial: mctrl_gpio: Check if GPIO property exisits before requesting it

Sean Paul <seanpaul@chromium.org>
    drm/msm: Depopulate platform on probe failure

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/pci/of: Fix OF flags parsing for 64bit BARs

Andrzej Pietrasiewicz <andrzej.p@collabora.com>
    usb: gadget: Zero ffs_io_data

Serge Semin <fancer.lancer@gmail.com>
    tty: serial_core: Set port active bit in uart_port_activate

Douglas Anderson <dianders@chromium.org>
    drm/rockchip: Properly adjust to a true clock in adjusted_mode

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/mobility: prevent cpu hotplug during DT update

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    phy: renesas: rcar-gen2: Fix memory leak at error paths

David Riley <davidriley@chromium.org>
    drm/virtio: Add memory barriers for capset cache.

Rautkoski Kimmo EXT <ext-kimmo.rautkoski@vaisala.com>
    serial: 8250: Fix TX interrupt handling condition

Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
    tty: serial: msm_serial: avoid system lockup condition

Kefeng Wang <wangkefeng.wang@huawei.com>
    tty/serial: digicolor: Fix digicolor-usart already registered warning

Wang Hai <wanghai26@huawei.com>
    memstick: Fix error cleanup path of memstick_init

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/crc-debugfs: User irqsafe spinlock in drm_crtc_add_crc_entry

Jyri Sarha <jsarha@ti.com>
    drm/bridge: sii902x: pixel clock unit is 10kHz instead of 1kHz

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/bridge: tc358767: read display_props in get_modes()

Alex Williamson <alex.williamson@redhat.com>
    PCI: Return error if cannot probe VF

Gen Zhang <blackgod016574@gmail.com>
    drm/edid: Fix a missing-check bug in drm_load_edid_firmware()

Christophe Leroy <christophe.leroy@c-s.fr>
    tty: serial: cpm_uart - fix init when SMC is relocated

Wen Yang <wen.yang99@zte.com.cn>
    pinctrl: rockchip: fix leaked of_node references

Serge Semin <fancer.lancer@gmail.com>
    tty: max310x: Fix invalid baudrate divisors calculator

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: core: hub: Disable hub-initiated U1/U2

Peter Ujfalusi <peter.ujfalusi@ti.com>
    drm/panel: simple: Fix panel_simple_dsi_probe

Sunil Muthuswamy <sunilmut@microsoft.com>
    hvsock: fix epollout hang from race condition

Paul Menzel <pmenzel@molgen.mpg.de>
    nfsd: Fix overflow causing non-working mounts on 1 TB machines

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix performance-limiting session calculation

J. Bruce Fields <bfields@redhat.com>
    nfsd: give out fewer session slots as limit approaches

J. Bruce Fields <bfields@redhat.com>
    nfsd: increase DRC cache limit

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Fix open create exclusive when the server reboots

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    perf/events/amd/uncore: Fix amd_uncore_llc ID to use pre-defined cpu_llc_id

Kuo-Hsin Yang <vovoy@chromium.org>
    mm: vmscan: scan anonymous pages on file refaults

Theodore Ts'o <tytso@mit.edu>
    ext4: allow directory holes

Ross Zwisler <zwisler@chromium.org>
    ext4: use jbd2_inode dirty range scoping

Ross Zwisler <zwisler@chromium.org>
    jbd2: introduce jbd2_inode dirty range scoping

Ross Zwisler <zwisler@chromium.org>
    mm: add filemap_fdatawait_range_keep_errors()

Theodore Ts'o <tytso@mit.edu>
    ext4: enforce the immutable flag on open files

Darrick J. Wong <darrick.wong@oracle.com>
    ext4: don't allow any modifications to an immutable file

Paul Cercueil <paul@crapouillou.net>
    MIPS: lb60: Fix pin mappings

Chris Wilson <chris@chris-wilson.co.uk>
    dma-buf: Discard old fence_excl on retrying get_fences_rcu for realloc

Jérôme Glisse <jglisse@redhat.com>
    dma-buf: balance refcount inbalance

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: stp: don't cache eth dest pointer before skb pull

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: mcast: fix stale ipv6 hdr pointer when handling v6 query

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: mcast: fix stale nsrcs pointer in igmp3/mld2 report handling

Christoph Paasch <cpaasch@apple.com>
    tcp: Reset bytes_acked and bytes_received when disconnecting

Eric Dumazet <edumazet@google.com>
    tcp: fix tcp_set_congestion_control() use from bpf hook

Florian Westphal <fw@strlen.de>
    net: make skb_dst_force return true when dst is refcounted

Cong Wang <xiyou.wangcong@gmail.com>
    bonding: validate ip header before check IPPROTO_IGMP

Cong Wang <xiyou.wangcong@gmail.com>
    netrom: hold sock when setting skb->destructor

Cong Wang <xiyou.wangcong@gmail.com>
    netrom: fix a memory leak in nr_rx_frame()

Andreas Steinmetz <ast@domdv.de>
    macsec: fix checksumming after decryption

Andreas Steinmetz <ast@domdv.de>
    macsec: fix use-after-free of skb during RX

Peter Kosyh <p.kosyh@gmail.com>
    vrf: make sure skb->data contains ip header to make routing

Takashi Iwai <tiwai@suse.de>
    sky2: Disable MSI on ASUS P6T

David Howells <dhowells@redhat.com>
    rxrpc: Fix send on a connected, but unbound socket

Yang Wei <albin_yang@163.com>
    nfc: fix potential illegal memory access

John Hurley <john.hurley@netronome.com>
    net: openvswitch: fix csum updates for MPLS actions

Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
    net: neigh: fix multiple neigh timer scheduling

Baruch Siach <baruch@tkos.co.il>
    net: dsa: mv88e6xxx: wait after reset deactivation

Justin Chen <justinpopo6@gmail.com>
    net: bcmgenet: use promisc for unsupported filters

Matteo Croce <mcroce@redhat.com>
    ipv4: don't set IPv6 only flags to IPv4 addresses

Eric Dumazet <edumazet@google.com>
    igmp: fix memory leak in igmpv3_del_delrec()

Taehee Yoo <ap420073@gmail.com>
    caif-hsi: fix possible deadlock in cfhsi_exit_module()

Guilherme G. Piccoli <gpiccoli@canonical.com>
    bnx2x: Prevent ptp_task to be rescheduled indefinitely

Brian King <brking@linux.vnet.ibm.com>
    bnx2x: Prevent load reordering in tx completion processing

Andrey Ryabinin <aryabinin@virtuozzo.com>
    lib/strscpy: Shut up KASAN false-positives in strscpy()

Andrey Ryabinin <aryabinin@virtuozzo.com>
    compiler.h: Add read_word_at_a_time() function.

Andrey Ryabinin <aryabinin@virtuozzo.com>
    compiler.h, kasan: Avoid duplicating __read_once_size_nocheck()

Junxiao Bi <junxiao.bi@oracle.com>
    dm bufio: fix deadlock with loop device

Josua Mayer <josua@solid-run.com>
    dt-bindings: allow up to four clocks for orion-mdio

Josua Mayer <josua@solid-run.com>
    net: mvmdio: allow up to four clocks to be specified for orion-mdio

Lee, Chiasheng <chiasheng.lee@intel.com>
    usb: Handle USB3 remote wakeup for LPM enabled devices correctly

Szymon Janc <szymon.janc@codecoup.pl>
    Bluetooth: Add SMP workaround Microsoft Surface Precision Mouse bug

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: msu: Fix single mode with disabled IOMMU

Dan Carpenter <dan.carpenter@oracle.com>
    eCryptfs: fix a couple type promotion bugs

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    powerpc/watchpoint: Restore NV GPRs while returning from exception

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/32s: fix suspend/resume when IBATs 4-7 are used

Helge Deller <deller@gmx.de>
    parisc: Fix kernel panic due invalid values in IAOQ0 or IAOQ1

Helge Deller <deller@gmx.de>
    parisc: Ensure userspace privilege for ptraced processes in regset functions

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    crypto: caam - limit output IV to CBC to work around CTR mode DMA issue

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Fix a use-after-free bug in hv_eject_device_work()

Steve Longerbeam <slongerbeam@gmail.com>
    gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM

Jan Harkes <jaharkes@cs.cmu.edu>
    coda: pass the host file in vma->vm_file on mmap

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/pfn: fix fsdax-mode namespace info-block zero-fields

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: correct touch resolution x/y typo

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: generic: only switch the mode on devices with LEDs

Filipe Manana <fdmanana@suse.com>
    Btrfs: add missing inode version, ctime and mtime updates when punching hole

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix fsync not persisting dentry deletions due to inode evictions

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix data loss after inode eviction, renaming it, and fsync it

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI: Do not poll for PME if the device is in D3cold

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Ice Lake NNPI support

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/uncore: Set the thread mask for F17h L3 PMCs

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/uncore: Do not set 'ThreadMask' and 'SliceMask' for non-L3 PMCs

David Rientjes <rientjes@google.com>
    x86/boot: Fix memory leak in default_get_smp_config()

YueHaibing <yuehaibing@huawei.com>
    9p/virtio: Add cleanup path in p9_virtio_init

YueHaibing <yuehaibing@huawei.com>
    9p/xen: Add cleanup path in p9_trans_xen_init

Juergen Gross <jgross@suse.com>
    xen/events: fix binding user event channels to cpus

Damien Le Moal <damien.lemoal@wdc.com>
    dm zoned: fix zone state management race

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: use smp_mb in padata_reorder to avoid orphaned padata jobs

Lyude Paul <lyude@redhat.com>
    drm/nouveau/i2c: Enable i2c pads & busses during preinit

Radoslaw Burny <rburny@google.com>
    fs/proc/proc_sysctl.c: fix the default values of i_uid/i_gid on /proc/sys inodes.

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Fix AGIC register range

Like Xu <like.xu@linux.intel.com>
    KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed

Ezequiel Garcia <ezequiel@collabora.com>
    media: coda: Remove unbalanced and unneeded mutex unlock

Boris Brezillon <boris.brezillon@collabora.com>
    media: v4l2: Test type instead of cfg->type in v4l2_ctrl_new_custom()

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek: apply ALC891 headset fixup to one Dell machine

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Break too long mutex context in the write loop

Mark Brown <broonie@kernel.org>
    ASoC: dapm: Adapt for debugfs API change

Christophe Leroy <christophe.leroy@c-s.fr>
    lib/scatterlist: Fix mapping iterator when sg->offset is greater than PAGE_SIZE

Trond Myklebust <trond.myklebust@hammerspace.com>
    pnfs/flexfiles: Fix PTR_ERR() dereferences in ff_layout_track_ds_error

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Handle the special Linux file open access mode

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: fix ALIVE interrupt handling for gen2 devices w/o MSI-X

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: don't service an interrupt that was masked

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Update Jetson TX1 GPU regulator timings

Krzysztof Kozlowski <krzk@kernel.org>
    regulator: s2mps11: Fix buck7 and buck8 wrong voltages

Hui Wang <hui.wang@canonical.com>
    Input: alps - fix a mismatch between a condition check and its comment

Nick Black <dankamongmen@gmail.com>
    Input: synaptics - whitelist Lenovo T580 SMBus intertouch

Hui Wang <hui.wang@canonical.com>
    Input: alps - don't handle ALPS cs19 trackpoint-only device

Grant Hernandez <granthernandez@google.com>
    Input: gtco - bounds check collection indent level

Wen Yang <wen.yang99@zte.com.cn>
    crypto: crypto4xx - fix a potential double free in ppc4xx_trng_probe

Cfir Cohen <cfir@google.com>
    crypto: ccp/gcm - use const time tag comparison.

Hook, Gary <Gary.Hook@amd.com>
    crypto: ccp - memset structure fields to zero before reuse

Eric Biggers <ebiggers@google.com>
    crypto: chacha20poly1305 - fix atomic sleep when using async algorithm

Elena Petrova <lenaptr@google.com>
    crypto: arm64/sha2-ce - correct digest for empty data in finup

Elena Petrova <lenaptr@google.com>
    crypto: arm64/sha1-ce - correct digest for empty data in finup

Hook, Gary <Gary.Hook@amd.com>
    crypto: ccp - Validate the the error value used to index error messages

Eric Biggers <ebiggers@google.com>
    crypto: ghash - fix unaligned memory access in ghash_setkey()

Finn Thain <fthain@telegraphics.com.au>
    scsi: mac_scsi: Fix pseudo DMA implementation, take 2

Finn Thain <fthain@telegraphics.com.au>
    scsi: mac_scsi: Increase PIO/PDMA transfer length threshold

Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
    scsi: megaraid_sas: Fix calculation of target ID

Ming Lei <ming.lei@redhat.com>
    scsi: core: Fix race on creating sense cache

Finn Thain <fthain@telegraphics.com.au>
    Revert "scsi: ncr5380: Increase register polling limit"

Finn Thain <fthain@telegraphics.com.au>
    scsi: NCR5380: Always re-enable reselection interrupt

Finn Thain <fthain@telegraphics.com.au>
    scsi: NCR5380: Reduce goto statements in NCR5380_select()

Juergen Gross <jgross@suse.com>
    xen: let alloc_xenballooned_pages() fail if not enough memory free

Denis Efremov <efremov@ispras.ru>
    floppy: fix out-of-bounds read in copy_buffer

Denis Efremov <efremov@ispras.ru>
    floppy: fix invalid pointer dereference in drive_name

Denis Efremov <efremov@ispras.ru>
    floppy: fix out-of-bounds read in next_valid_format

Denis Efremov <efremov@ispras.ru>
    floppy: fix div-by-zero in setup_format_params

Colin Ian King <colin.king@canonical.com>
    iavf: fix dereference of null rx_buffer pointer

Josua Mayer <josua@solid-run.com>
    net: mvmdio: defer probe of orion-mdio if a clock is not ready

Taehee Yoo <ap420073@gmail.com>
    gtp: fix use-after-free in gtp_newlink()

Taehee Yoo <ap420073@gmail.com>
    gtp: fix use-after-free in gtp_encap_destroy()

Taehee Yoo <ap420073@gmail.com>
    gtp: fix Illegal context switch in RCU read-side critical section.

Taehee Yoo <ap420073@gmail.com>
    gtp: fix suspicious RCU usage

csonsino <csonsino@gmail.com>
    Bluetooth: validate BLE connection interval updates

Taehee Yoo <ap420073@gmail.com>
    gtp: add missing gtp_encap_disable_sock() in gtp_encap_enable()

Matias Karhumaa <matias.karhumaa@gmail.com>
    Bluetooth: Check state in l2cap_disconnect_rsp

Josua Mayer <josua.mayer@jm0.eu>
    Bluetooth: 6lowpan: search for destination address in all peers

Tomas Bortoli <tomasbortoli@gmail.com>
    Bluetooth: hci_bcsp: Fix memory leak in rx_skb

Geert Uytterhoeven <geert+renesas@glider.be>
    gpiolib: Fix references to gpiod_[gs]et_*value_cansleep() variants

Phong Tran <tranmanphong@gmail.com>
    net: usb: asix: init MAC address buffers

Andi Kleen <ak@linux.intel.com>
    perf stat: Make metric event lookup more robust

Andrei Otcheretianski <andrei.otcheretianski@intel.com>
    iwlwifi: mvm: Drop large non sta frames

Wen Gong <wgong@codeaurora.org>
    ath10k: destroy sdio workqueue while remove sdio module

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: add some error checking in hclge_tm module

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix a -Wformat-nonliteral compile warning

Coly Li <colyli@suse.de>
    bcache: check c->gc_thread by IS_ERR_OR_NULL in cache_set_flush()

Eiichi Tsukata <devel@etsukata.com>
    EDAC: Fix global-out-of-bounds write when setting edac_mc_poll_msec

Arnd Bergmann <arnd@arndb.de>
    crypto: asymmetric_keys - select CRYPTO_HASH where needed

Arnd Bergmann <arnd@arndb.de>
    crypto: serpent - mark __serpent_setkey_sbox noinline

Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
    ixgbe: Check DDM existence in transceiver before access

Ferdinand Blomqvist <ferdinand.blomqvist@gmail.com>
    rslib: Fix handling of of caller provided syndrome

Ferdinand Blomqvist <ferdinand.blomqvist@gmail.com>
    rslib: Fix decoding of shortened codes

Marek Szyprowski <m.szyprowski@samsung.com>
    clocksource/drivers/exynos_mct: Increase priority over ARM arch timer

Tejun Heo <tj@kernel.org>
    libata: don't request sense data on !ZAC ATA devices

Kyle Meyer <kyle.meyer@hpe.com>
    perf tools: Increase MAX_NR_CPUS and MAX_CACHES

Miaoqing Pan <miaoqing@codeaurora.org>
    ath10k: fix PCIE device wake up failed

Claire Chang <tientzu@chromium.org>
    ath10k: add missing error handling

Julian Anastasov <ja@ssi.bg>
    ipvs: fix tinfo memory leak in start_sync_thread

Lorenzo Bianconi <lorenzo@kernel.org>
    mt7601u: fix possible memory leak when the device is disconnected

Masahiro Yamada <yamada.masahiro@socionext.com>
    x86/build: Add 'set -e' to mkcapflags.sh to delete broken capflags.c

Lorenzo Bianconi <lorenzo@kernel.org>
    mt7601u: do not schedule rx_tasklet when the device has been disconnected

Ping-Ke Shih <pkshih@realtek.com>
    rtlwifi: rtl8192cu: fix error handle when usb probe failed

Hans Verkuil <hverkuil@xs4all.nl>
    media: hdpvr: fix locking and a missing msleep

André Almeida <andrealmeid@collabora.com>
    media: vimc: cap: check v4l2_fill_pixfmt return value

Philipp Zabel <p.zabel@pengutronix.de>
    media: coda: increment sequence offset for the last returned frame

Marco Felsch <m.felsch@pengutronix.de>
    media: coda: fix last buffer handling in V4L2_ENC_CMD_STOP

Philipp Zabel <p.zabel@pengutronix.de>
    media: coda: fix mpeg2 sequence number handling

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    acpi/arm64: ignore 5.1 FADTs that are reported as 5.0

Nathan Huckleberry <nhuck@google.com>
    timer_list: Guard procfs specific code

Miroslav Lichvar <mlichvar@redhat.com>
    ntp: Limit TAI-UTC offset

Anders Roxell <anders.roxell@linaro.org>
    media: i2c: fix warning same module names

Marek Szyprowski <m.szyprowski@samsung.com>
    media: s5p-mfc: Make additional clocks optional

Julian Anastasov <ja@ssi.bg>
    ipvs: defer hook registration to avoid leaks

Arnd Bergmann <arnd@arndb.de>
    ipsec: select crypto ciphers for xfrm_algo

Pan Bian <bianpan2016@163.com>
    EDAC/sysfs: Fix memory leak when creating a csrow object

Denis Kirjanov <kda@linux-powerpc.org>
    ipoib: correcly show a VF hardware address

Jason Wang <jasowang@redhat.com>
    vhost_net: disable zerocopy by default

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf evsel: Make perf_evsel__name() accept a NULL argument

Peter Zijlstra <peterz@infradead.org>
    x86/atomic: Fix smp_mb__{before,after}_atomic()

Qian Cai <cai@lca.pw>
    sched/fair: Fix "runnable_avg_yN_inv" not used warnings

Gao Xiang <gaoxiang25@huawei.com>
    sched/core: Add __sched tag for io_schedule()

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm: fix sa selector validation

Tejun Heo <tj@kernel.org>
    blkcg, writeback: dead memcgs shouldn't contribute to writeback ownership arbitration

Aaron Lewis <aaronlewis@google.com>
    x86/cpufeatures: Add FDP_EXCPTN_ONLY and ZERO_FCS_FDS

Waiman Long <longman@redhat.com>
    rcu: Force inlining of rcu_read_lock()

Valdis Kletnieks <valdis.kletnieks@vt.edu>
    bpf: silence warning messages in core

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    regmap: fix bulk writes on paged registers

Russell King <rmk+kernel@armlinux.org.uk>
    gpio: omap: ensure irq is enabled before wakeup

Russell King <rmk+kernel@armlinux.org.uk>
    gpio: omap: fix lack of irqstatus_raw0 for OMAP4

Eric Auger <eric.auger@redhat.com>
    iommu: Fix a leak in iommu_insert_resv_region

Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
    media: fdp1: Support M3N and E3 platforms

Thomas Richter <tmricht@linux.ibm.com>
    perf test 6: Fix missing kvm module load for s390

Mathieu Poirier <mathieu.poirier@linaro.org>
    perf cs-etm: Properly set the value of 'old' and 'head' in snapshot mode

Stefano Brivio <sbrivio@redhat.com>
    ipset: Fix memory accounting for hash types on resize

Robert Hancock <hancock@sedsystems.ca>
    net: sfp: add mutex to prevent concurrent state checks

Borislav Petkov <bp@suse.de>
    RAS/CEC: Fix pfn insertion

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qdio: handle PENDING state for QEBSM devices

Robert Hancock <hancock@sedsystems.ca>
    net: axienet: Fix race condition causing TX hang

Fabio Estevam <festevam@gmail.com>
    net: fec: Do not use netdev messages too early

Biao Huang <biao.huang@mediatek.com>
    net: stmmac: dwmac4: fix flow control issue

Abhishek Goel <huntbag@linux.vnet.ibm.com>
    cpupower : frequency-set -r option misses the last cpu in related cpu list

Kefeng Wang <wangkefeng.wang@huawei.com>
    media: wl128x: Fix some error handling in fm_v4l2_init_video_device()

Imre Deak <imre.deak@intel.com>
    locking/lockdep: Fix merging of hlocks with non-zero references

David S. Miller <davem@davemloft.net>
    tua6100: Avoid build warnings.

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - Align SEC1 accesses to 32 bits boundaries.

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - properly handle split ICV.

Ioana Ciornei <ioana.ciornei@nxp.com>
    net: phy: Check against net_device being NULL

Shailendra Verma <shailendra.v@samsung.com>
    media: staging: media: davinci_vpfe: - Fix for memory leak if decoder initialization fails.

Hans Verkuil <hverkuil@xs4all.nl>
    media: mc-device.c: don't memset __user pointer contents

Eric Biggers <ebiggers@google.com>
    fscrypt: clean up some BUG_ON()s in block encryption/decryption

Anirudh Gupta <anirudhrudr@gmail.com>
    xfrm: Fix xfrm sel prefix length validation

Jeremy Sowden <jeremy@azazel.net>
    af_key: fix leaks in key_pol_get_resp and dump_sp.

Eric W. Biederman <ebiederm@xmission.com>
    signal/pid_namespace: Fix reboot_pid_ns to use send_sig not force_sig

Michal Kalderon <michal.kalderon@marvell.com>
    qed: Set the doorbell address correctly

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: dwmac4/5: Clear unused address entries

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: dwmac1000: Clear unused address entries

Jungo Lin <jungo.lin@mediatek.com>
    media: media_device_enum_links32: clean a reserved field

Kangjie Lu <kjlu@umn.edu>
    media: vpss: fix a potential NULL pointer dereference

Lubomir Rintel <lkundrak@v3.sk>
    media: marvell-ccic: fix DMA s/g desc number calculation

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - fix skcipher failure due to wrong output IV

Daniel Gomez <dagmcr@gmail.com>
    media: spi: IR LED: add missing of table registration

Oliver Neukum <oneukum@suse.com>
    media: dvb: usb: fix use after free in dvb_usb_device_exit

Jeremy Sowden <jeremy@azazel.net>
    batman-adv: fix for leaked TVLV handler.

Anilkumar Kolli <akolli@codeaurora.org>
    ath: DFS JP domain W56 fixed pulse type 3 RADAR detection

Dan Carpenter <dan.carpenter@oracle.com>
    ath6kl: add some bounds checking

Tim Schumacher <timschumi@gmx.de>
    ath9k: Check for errors when reading SREV register

Surabhi Vishnoi <svishnoi@codeaurora.org>
    ath10k: Do not send probe response template for mesh

Gustavo A. R. Silva <gustavo@embeddedor.com>
    wil6210: fix potential out-of-bounds read

Sven Van Asbroeck <thesven73@gmail.com>
    dmaengine: imx-sdma: fix use-after-free on probe error path

Maurizio Lombardi <mlombard@redhat.com>
    scsi: iscsi: set auth_protocol back to NULL if CHAP_A value is not supported

Nathan Chancellor <natechancellor@gmail.com>
    arm64/efi: Mark __efistub_stext_offset as an absolute symbol explicitly

Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
    MIPS: fix build on non-linux hosts

Stefan Hellermann <stefan@the2masters.de>
    MIPS: ath79: fix ar933x uart parity mode


-------------

Diffstat:

 Documentation/atomic_t.txt                         |   3 +
 .../devicetree/bindings/net/marvell-orion-mdio.txt |   2 +-
 Documentation/scheduler/sched-pelt.c               |   3 +-
 Makefile                                           |   5 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi     |   3 +-
 arch/arm64/boot/dts/nvidia/tegra210.dtsi           |   2 +-
 arch/arm64/crypto/sha1-ce-glue.c                   |   2 +-
 arch/arm64/crypto/sha2-ce-glue.c                   |   2 +-
 arch/arm64/kernel/acpi.c                           |  10 +-
 arch/arm64/kernel/image.h                          |   6 +-
 arch/mips/boot/compressed/Makefile                 |   2 +
 arch/mips/boot/compressed/calc_vmlinuz_load_addr.c |   2 +-
 arch/mips/include/asm/mach-ath79/ar933x_uart.h     |   4 +-
 arch/mips/jz4740/board-qi_lb60.c                   |  16 +-
 arch/parisc/kernel/ptrace.c                        |  31 +-
 arch/powerpc/boot/xz_config.h                      |  20 ++
 arch/powerpc/kernel/eeh.c                          |  15 +-
 arch/powerpc/kernel/exceptions-64s.S               |   9 +-
 arch/powerpc/kernel/pci_of_scan.c                  |   2 +
 arch/powerpc/kernel/signal_32.c                    |   3 +
 arch/powerpc/kernel/signal_64.c                    |   5 +
 arch/powerpc/kernel/swsusp_32.S                    |  73 +++-
 arch/powerpc/platforms/4xx/uic.c                   |   1 +
 arch/powerpc/platforms/powermac/sleep.S            |  68 +++-
 arch/powerpc/platforms/pseries/mobility.c          |   9 +
 arch/powerpc/sysdev/xive/common.c                  |   7 +-
 arch/powerpc/xmon/xmon.c                           |   6 +-
 arch/sh/include/asm/io.h                           |   6 +-
 arch/um/include/asm/mmu_context.h                  |   2 +-
 arch/x86/events/amd/uncore.c                       |  36 +-
 arch/x86/include/asm/atomic.h                      |   8 +-
 arch/x86/include/asm/atomic64_64.h                 |   8 +-
 arch/x86/include/asm/barrier.h                     |   4 +-
 arch/x86/include/asm/cpufeatures.h                 |   2 +
 arch/x86/kernel/cpu/bugs.c                         |   2 +-
 arch/x86/kernel/cpu/mkcapflags.sh                  |   2 +
 arch/x86/kernel/mpparse.c                          |  10 +-
 arch/x86/kernel/sysfb_efi.c                        |  46 +++
 arch/x86/kvm/pmu.c                                 |   4 +-
 arch/x86/kvm/vmx.c                                 |   8 +-
 block/bio-integrity.c                              |   8 +-
 crypto/asymmetric_keys/Kconfig                     |   3 +
 crypto/chacha20poly1305.c                          |  30 +-
 crypto/ghash-generic.c                             |   8 +-
 crypto/serpent_generic.c                           |   8 +-
 drivers/android/binder.c                           |   2 +-
 drivers/ata/libata-eh.c                            |   8 +-
 drivers/base/regmap/regmap.c                       |   2 +
 drivers/block/floppy.c                             |  34 +-
 drivers/bluetooth/hci_bcsp.c                       |   5 +
 drivers/char/hpet.c                                |   3 +-
 drivers/clocksource/exynos_mct.c                   |   4 +-
 drivers/crypto/amcc/crypto4xx_trng.c               |   1 -
 drivers/crypto/caam/caamalg.c                      |  15 +-
 drivers/crypto/ccp/ccp-dev.c                       |  96 +++---
 drivers/crypto/ccp/ccp-dev.h                       |   2 +-
 drivers/crypto/ccp/ccp-ops.c                       |  15 +-
 drivers/crypto/talitos.c                           |  35 +-
 drivers/dma-buf/dma-buf.c                          |   1 +
 drivers/dma-buf/reservation.c                      |   4 +
 drivers/dma/imx-sdma.c                             |  48 +--
 drivers/edac/edac_mc_sysfs.c                       |  24 +-
 drivers/edac/edac_module.h                         |   2 +-
 drivers/fpga/Kconfig                               |   1 +
 drivers/gpio/gpio-omap.c                           |  17 +-
 drivers/gpio/gpiolib.c                             |   6 +-
 drivers/gpu/drm/bridge/sii902x.c                   |   5 +-
 drivers/gpu/drm/bridge/tc358767.c                  |   7 +
 drivers/gpu/drm/drm_debugfs_crc.c                  |  18 +-
 drivers/gpu/drm/drm_edid_load.c                    |   2 +
 drivers/gpu/drm/msm/msm_drv.c                      |  14 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c     |  20 ++
 drivers/gpu/drm/panel/panel-simple.c               |   9 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   3 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |   3 +
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   2 +
 drivers/gpu/ipu-v3/ipu-ic.c                        |   2 +-
 drivers/hid/wacom_sys.c                            |   3 +
 drivers/hid/wacom_wac.c                            |   4 +-
 drivers/hid/wacom_wac.h                            |   1 +
 drivers/hwtracing/intel_th/msu.c                   |   2 +-
 drivers/hwtracing/intel_th/pci.c                   |   5 +
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          |   2 +
 drivers/infiniband/sw/rxe/rxe_resp.c               |   5 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |   1 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   1 +
 drivers/input/mouse/alps.c                         |  32 ++
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/input/tablet/gtco.c                        |  20 +-
 drivers/iommu/iommu.c                              |   8 +-
 drivers/mailbox/mailbox.c                          |   6 +-
 drivers/md/bcache/super.c                          |   2 +-
 drivers/md/dm-bufio.c                              |   4 +-
 drivers/md/dm-zoned-metadata.c                     |  24 --
 drivers/md/dm-zoned.h                              |  28 +-
 drivers/media/dvb-frontends/tua6100.c              |  22 +-
 drivers/media/i2c/Makefile                         |   2 +-
 drivers/media/i2c/{adv7511.c => adv7511-v4l2.c}    |   5 +
 drivers/media/media-device.c                       |  10 +-
 drivers/media/platform/coda/coda-bit.c             |   9 +-
 drivers/media/platform/coda/coda-common.c          |   2 +
 drivers/media/platform/davinci/vpss.c              |   5 +
 drivers/media/platform/marvell-ccic/mcam-core.c    |   5 +-
 drivers/media/platform/rcar_fdp1.c                 |   8 +
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |   5 +
 drivers/media/platform/vimc/vimc-capture.c         |   5 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |   3 +
 drivers/media/rc/ir-spi.c                          |   1 +
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |   7 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |  17 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |   9 +-
 drivers/memstick/core/memstick.c                   |  13 +-
 drivers/mfd/arizona-core.c                         |   2 +-
 drivers/mfd/hi655x-pmic.c                          |   2 +
 drivers/mfd/mfd-core.c                             |   1 +
 drivers/net/bonding/bond_main.c                    |  37 +-
 drivers/net/caif/caif_hsi.c                        |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   8 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  33 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h  |   3 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  57 ++--
 drivers/net/ethernet/freescale/fec_main.c          |   6 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   3 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   6 +-
 drivers/net/ethernet/intel/i40evf/i40e_txrx.c      |   6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h       |   1 +
 drivers/net/ethernet/marvell/mvmdio.c              |   7 +-
 drivers/net/ethernet/marvell/sky2.c                |   7 +
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  29 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c         |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |   6 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |  18 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  20 +-
 drivers/net/gtp.c                                  |  36 +-
 drivers/net/macsec.c                               |   6 +-
 drivers/net/phy/phy_device.c                       |   6 +
 drivers/net/phy/sfp.c                              |   6 +-
 drivers/net/usb/asix_devices.c                     |   6 +-
 drivers/net/vrf.c                                  |  58 ++--
 drivers/net/wireless/ath/ath10k/hw.c               |   2 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   4 +
 drivers/net/wireless/ath/ath10k/sdio.c             |   7 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |  10 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  32 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c    |   2 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   3 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  61 ++--
 drivers/net/wireless/mediatek/mt7601u/dma.c        |  54 +--
 drivers/net/wireless/mediatek/mt7601u/tx.c         |   4 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   5 +-
 drivers/nvdimm/dax_devs.c                          |   2 +-
 drivers/nvdimm/pfn.h                               |   1 +
 drivers/nvdimm/pfn_devs.c                          |  18 +-
 drivers/pci/dwc/pci-dra7xx.c                       |   1 +
 drivers/pci/host/pci-hyperv.c                      |  15 +-
 drivers/pci/host/pcie-xilinx-nwl.c                 |  11 +-
 drivers/pci/pci-driver.c                           |  13 +-
 drivers/pci/pci-sysfs.c                            |   2 +-
 drivers/pci/pci.c                                  |   7 +
 drivers/phy/renesas/phy-rcar-gen2.c                |   2 +
 drivers/pinctrl/pinctrl-rockchip.c                 |   1 +
 drivers/ras/cec.c                                  |   4 +-
 drivers/regulator/s2mps11.c                        |   4 +-
 drivers/s390/cio/qdio_main.c                       |   1 +
 drivers/scsi/NCR5380.c                             |  33 +-
 drivers/scsi/NCR5380.h                             |   2 +-
 drivers/scsi/mac_scsi.c                            | 375 ++++++++++++---------
 drivers/scsi/megaraid/megaraid_sas_base.c          |   3 +-
 drivers/scsi/scsi_lib.c                            |   6 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   3 +
 drivers/target/iscsi/iscsi_target_auth.c           |  16 +-
 drivers/tty/serial/8250/8250_port.c                |   3 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c        |  17 +-
 drivers/tty/serial/digicolor-usart.c               |   6 +-
 drivers/tty/serial/max310x.c                       |  51 +--
 drivers/tty/serial/msm_serial.c                    |   4 +
 drivers/tty/serial/serial_core.c                   |   7 +-
 drivers/tty/serial/serial_mctrl_gpio.c             |  14 +
 drivers/tty/serial/sh-sci.c                        |  33 +-
 drivers/usb/core/hub.c                             |  35 +-
 drivers/usb/gadget/function/f_fs.c                 |   6 +-
 drivers/usb/host/hwa-hc.c                          |   2 +-
 drivers/usb/host/pci-quirks.c                      |  31 +-
 drivers/vhost/net.c                                |   2 +-
 drivers/xen/balloon.c                              |  16 +-
 drivers/xen/events/events_base.c                   |  12 +-
 drivers/xen/evtchn.c                               |   2 +-
 fs/9p/vfs_addr.c                                   |   6 +-
 fs/btrfs/file.c                                    |   5 +
 fs/btrfs/inode.c                                   |  24 +-
 fs/btrfs/tree-log.c                                |  40 ++-
 fs/coda/file.c                                     |  70 +++-
 fs/crypto/crypto.c                                 |  15 +-
 fs/ecryptfs/crypto.c                               |  12 +-
 fs/ext4/dir.c                                      |  19 +-
 fs/ext4/ext4_jbd2.h                                |  12 +-
 fs/ext4/file.c                                     |   4 +
 fs/ext4/inode.c                                    |  24 +-
 fs/ext4/ioctl.c                                    |  46 ++-
 fs/ext4/move_extent.c                              |   3 +-
 fs/ext4/namei.c                                    |  45 ++-
 fs/f2fs/segment.c                                  |   5 +
 fs/fs-writeback.c                                  |   8 +-
 fs/jbd2/commit.c                                   |  23 +-
 fs/jbd2/journal.c                                  |   4 +
 fs/jbd2/transaction.c                              |  49 +--
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   2 +-
 fs/nfs/inode.c                                     |   1 +
 fs/nfs/nfs4file.c                                  |   2 +-
 fs/nfs/nfs4proc.c                                  |  41 ++-
 fs/nfsd/nfs4state.c                                |  11 +-
 fs/nfsd/nfssvc.c                                   |   2 +-
 fs/open.c                                          |  19 ++
 fs/proc/proc_sysctl.c                              |   4 +
 include/drm/drm_debugfs_crc.h                      |   3 +-
 include/linux/compiler.h                           |  22 +-
 include/linux/cpuhotplug.h                         |   2 +-
 include/linux/cred.h                               |   7 +-
 include/linux/fs.h                                 |   2 +
 include/linux/jbd2.h                               |  22 ++
 include/linux/rcupdate.h                           |   2 +-
 include/net/dst.h                                  |   5 +-
 include/net/ip_vs.h                                |   6 +-
 include/net/tcp.h                                  |   3 +-
 include/xen/events.h                               |   3 +-
 kernel/bpf/Makefile                                |   1 +
 kernel/cred.c                                      |  21 +-
 kernel/locking/lockdep.c                           |  18 +-
 kernel/locking/lockdep_proc.c                      |   8 +-
 kernel/padata.c                                    |  12 +
 kernel/pid_namespace.c                             |   2 +-
 kernel/sched/core.c                                |   2 +-
 kernel/sched/sched-pelt.h                          |   2 +-
 kernel/time/ntp.c                                  |   4 +-
 kernel/time/timer_list.c                           |  36 +-
 lib/reed_solomon/decode_rs.c                       |  18 +-
 lib/scatterlist.c                                  |   9 +-
 lib/string.c                                       |   2 +-
 mm/filemap.c                                       |  22 ++
 mm/gup.c                                           |  12 +-
 mm/kmemleak.c                                      |   2 +-
 mm/mmu_notifier.c                                  |   2 +-
 mm/vmscan.c                                        |   6 +-
 net/9p/trans_virtio.c                              |   8 +-
 net/9p/trans_xen.c                                 |   8 +-
 net/batman-adv/translation-table.c                 |   2 +
 net/bluetooth/6lowpan.c                            |  14 +-
 net/bluetooth/hci_event.c                          |   5 +
 net/bluetooth/l2cap_core.c                         |  15 +-
 net/bluetooth/smp.c                                |  13 +
 net/bridge/br_multicast.c                          |  32 +-
 net/bridge/br_stp_bpdu.c                           |   3 +-
 net/core/filter.c                                  |   3 +-
 net/core/neighbour.c                               |   2 +
 net/ipv4/devinet.c                                 |   8 +
 net/ipv4/igmp.c                                    |   8 +-
 net/ipv4/tcp.c                                     |   6 +-
 net/ipv4/tcp_cong.c                                |   6 +-
 net/key/af_key.c                                   |   8 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  21 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   4 -
 net/netfilter/ipvs/ip_vs_sync.c                    | 134 ++++----
 net/netfilter/nf_queue.c                           |   6 +-
 net/netrom/af_netrom.c                             |   4 +-
 net/nfc/nci/data.c                                 |   2 +-
 net/openvswitch/actions.c                          |   6 +-
 net/rxrpc/af_rxrpc.c                               |   4 +-
 net/vmw_vsock/hyperv_transport.c                   |  44 +--
 net/xfrm/Kconfig                                   |   2 +
 net/xfrm/xfrm_user.c                               |  19 ++
 scripts/kallsyms.c                                 |   3 +
 scripts/recordmcount.h                             |   3 +-
 sound/core/seq/seq_clientmgr.c                     |  11 +-
 sound/pci/hda/patch_conexant.c                     |   1 +
 sound/pci/hda/patch_realtek.c                      |   5 +
 sound/soc/soc-dapm.c                               |  18 +-
 sound/usb/line6/podhd.c                            |   2 +-
 tools/iio/iio_utils.c                              |   4 +-
 tools/perf/arch/arm/util/cs-etm.c                  | 127 ++++++-
 tools/perf/perf.h                                  |   2 +-
 tools/perf/tests/mmap-thread-lookup.c              |   2 +-
 tools/perf/tests/parse-events.c                    |  27 ++
 tools/perf/util/annotate.c                         |   6 +-
 tools/perf/util/evsel.c                            |   8 +-
 tools/perf/util/header.c                           |   2 +-
 tools/perf/util/session.c                          |   3 +
 tools/perf/util/stat-shadow.c                      |   5 +-
 tools/power/cpupower/utils/cpufreq-set.c           |   2 +
 293 files changed, 2749 insertions(+), 1145 deletions(-)


