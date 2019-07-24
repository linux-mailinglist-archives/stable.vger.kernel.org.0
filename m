Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35D0473C4A
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405352AbfGXUDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405320AbfGXUDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:03:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40F8E205C9;
        Wed, 24 Jul 2019 20:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998584;
        bh=jUy5za9TABNZme12wK3D6GwcKMvB0m/42X6gU+8ztQE=;
        h=From:To:Cc:Subject:Date:From;
        b=y47vXbjrDsmtGe/S2/Km2hYZ6WS1cCNLY66qJy0Xdn375BL2AHBRbBsoWGE92DYLp
         NF2Qz9jyg4O9QwcBHG3QT6wjZv6bYEEUbuVbpkYVn3vkfEQwEPCg0pCyZvzDF82S1D
         HSUTS+AeCiRa3NViaNtvVxIPyTszlgUFwYO7gjAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/271] 4.19.61-stable review
Date:   Wed, 24 Jul 2019 21:17:49 +0200
Message-Id: <20190724191655.268628197@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.61-rc1
X-KernelTest-Deadline: 2019-07-26T19:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.61 release.
There are 271 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.61-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.61-rc1

Junxiao Bi <junxiao.bi@oracle.com>
    dm bufio: fix deadlock with loop device

Josua Mayer <josua@solid-run.com>
    dt-bindings: allow up to four clocks for orion-mdio

Josua Mayer <josua@solid-run.com>
    net: mvmdio: allow up to four clocks to be specified for orion-mdio

Tejun Heo <tj@kernel.org>
    blkcg: update blkcg_print_stat() to handle larger outputs

Tejun Heo <tj@kernel.org>
    blk-iolatency: clear use_delay when io.latency is set to zero

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    blk-throttle: fix zero wait time for iops throttled group

Lee, Chiasheng <chiasheng.lee@intel.com>
    usb: Handle USB3 remote wakeup for LPM enabled devices correctly

Szymon Janc <szymon.janc@codecoup.pl>
    Bluetooth: Add SMP workaround Microsoft Surface Precision Mouse bug

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: msu: Fix single mode with disabled IOMMU

liaoweixiong <liaoweixiong@allwinnertech.com>
    mtd: spinand: read returns badly if the last page has bitflips

Xiaolei Li <xiaolei.li@mediatek.com>
    mtd: rawnand: mtk: Correct low level time calculation of r/w cycle

Dan Carpenter <dan.carpenter@oracle.com>
    eCryptfs: fix a couple type promotion bugs

Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
    mmc: sdhci-msm: fix mutex while in spinlock

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries: Fix oops in hotplug memory notifier

Greg Kurz <groug@kaod.org>
    powerpc/powernv/npu: Fix reference leak

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

Steve Longerbeam <slongerbeam@gmail.com>
    gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: abort unaligned nowait directio early

Brian Foster <bfoster@redhat.com>
    xfs: serialize unaligned dio writes against all other dio writes

Luis R. Rodriguez <mcgrof@kernel.org>
    xfs: fix reporting supported extra file attributes for statx()

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: reserve blocks for ifree transaction during log recovery

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: don't ever put nlink > 0 inodes on the unlinked list

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: rename m_inotbt_nores to m_finobt_nores

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: don't overflow xattr listent buffer

Dave Chinner <dchinner@redhat.com>
    xfs: flush removing page cache in xfs_reflink_remap_prep

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix pagecache truncation prior to reflink

Drew Davenport <ddavenport@chromium.org>
    include/asm-generic/bug.h: fix "cut here" for WARN_ON for __WARN_TAINT architectures

Jan Harkes <jaharkes@cs.cmu.edu>
    coda: pass the host file in vma->vm_file on mmap

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/pfn: fix fsdax-mode namespace info-block zero-fields

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: correct touch resolution x/y typo

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: generic: Correct pad syncing

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: generic: only switch the mode on devices with LEDs

Danit Goldberg <danitg@mellanox.com>
    IB/mlx5: Report correctly tag matching rendezvous capability

Filipe Manana <fdmanana@suse.com>
    Btrfs: add missing inode version, ctime and mtime updates when punching hole

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix fsync not persisting dentry deletions due to inode evictions

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix data loss after inode eviction, renaming it, and fsync it

Niklas Cassel <niklas.cassel@linaro.org>
    PCI: qcom: Ensure that PERST is asserted for at least 100 ms

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI: Do not poll for PME if the device is in D3cold

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Fix a use-after-free bug in hv_eject_device_work()

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Ice Lake NNPI support

Andres Rodriguez <andresx7@gmail.com>
    drm/edid: parse CEA blocks embedded in DisplayID

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/uncore: Set the thread mask for F17h L3 PMCs

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/uncore: Do not set 'ThreadMask' and 'SliceMask' for non-L3 PMCs

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix spurious NMI on fixed counter

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

Masahiro Yamada <yamada.masahiro@socionext.com>
    kconfig: fix missing choice values in auto.conf

Radoslaw Burny <rburny@google.com>
    fs/proc/proc_sysctl.c: fix the default values of i_uid/i_gid on /proc/sys inodes.

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Fix AGIC register range

Like Xu <like.xu@linux.intel.com>
    KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: videobuf2-dma-sg: Prevent size from overflowing

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: videobuf2-core: Prevent size alignment wrapping buffer size to 0

Ezequiel Garcia <ezequiel@collabora.com>
    media: coda: Remove unbalanced and unneeded mutex unlock

Boris Brezillon <boris.brezillon@collabora.com>
    media: v4l2: Test type instead of cfg->type in v4l2_ctrl_new_custom()

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek: apply ALC891 headset fixup to one Dell machine

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed Headphone Mic can't record on Dell platform

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Break too long mutex context in the write loop

Xiao Ni <xni@redhat.com>
    raid5-cache: Need to do start() part job after adding journal device

Mark Brown <broonie@kernel.org>
    ASoC: dapm: Adapt for debugfs API change

Christophe Leroy <christophe.leroy@c-s.fr>
    lib/scatterlist: Fix mapping iterator when sg->offset is greater than PAGE_SIZE

Trond Myklebust <trond.myklebust@hammerspace.com>
    pnfs: Fix a problem where we gratuitously start doing I/O through the MDS

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS: Fix a typo in pnfs_update_layout

Trond Myklebust <trond.myklebust@hammerspace.com>
    pnfs/flexfiles: Fix PTR_ERR() dereferences in ff_layout_track_ds_error

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Handle the special Linux file open access mode

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: fix RF-Kill interrupt while FW load for gen2 devices

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: don't WARN when calling iwl_get_shared_mem_conf with RF-Kill

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

Coly Li <colyli@suse.de>
    bcache: destroy dc->writeback_write_wq if failed to create dc->writeback_thread

Coly Li <colyli@suse.de>
    bcache: fix mistaken sysfs entry for io_error counter

Coly Li <colyli@suse.de>
    bcache: ignore read-ahead request failure on backing device

Coly Li <colyli@suse.de>
    bcache: Revert "bcache: free heap cache_set->flush_btree in bch_journal_free"

Coly Li <colyli@suse.de>
    bcache: Revert "bcache: fix high CPU occupancy during journal"

Coly Li <colyli@suse.de>
    Revert "bcache: set CACHE_SET_IO_DISABLE in bch_cached_dev_error()"

Wen Yang <wen.yang99@zte.com.cn>
    crypto: crypto4xx - fix a potential double free in ppc4xx_trng_probe

Cfir Cohen <cfir@google.com>
    crypto: ccp/gcm - use const time tag comparison.

Hook, Gary <Gary.Hook@amd.com>
    crypto: ccp - memset structure fields to zero before reuse

Christian Lamparter <chunkeey@gmail.com>
    crypto: crypto4xx - block ciphers should only accept complete blocks

Christian Lamparter <chunkeey@gmail.com>
    crypto: crypto4xx - fix blocksize for cfb and ofb

Christian Lamparter <chunkeey@gmail.com>
    crypto: crypto4xx - fix AES CTR blocksize value

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

Seeteena Thoufeek <s1seetee@linux.vnet.ibm.com>
    perf tests: Fix record+probe_libc_inet_pton.sh for powerpc64

Josua Mayer <josua.mayer@jm0.eu>
    Bluetooth: 6lowpan: search for destination address in all peers

João Paulo Rechi Vita <jprvita@gmail.com>
    Bluetooth: Add new 13d3:3501 QCA_ROME device

João Paulo Rechi Vita <jprvita@gmail.com>
    Bluetooth: Add new 13d3:3491 QCA_ROME device

Tomas Bortoli <tomasbortoli@gmail.com>
    Bluetooth: hci_bcsp: Fix memory leak in rx_skb

Jiri Olsa <jolsa@redhat.com>
    tools: bpftool: Fix json dump crash on powerpc

Geert Uytterhoeven <geert+renesas@glider.be>
    gpiolib: Fix references to gpiod_[gs]et_*value_cansleep() variants

Cong Wang <xiyou.wangcong@gmail.com>
    bonding: validate ip header before check IPPROTO_IGMP

Jiri Benc <jbenc@redhat.com>
    selftests: bpf: fix inlines in test_lwt_seg6local

Leo Yan <leo.yan@linaro.org>
    bpf, libbpf, smatch: Fix potential NULL pointer dereference

David Howells <dhowells@redhat.com>
    rxrpc: Fix oops in tracepoint

Phong Tran <tranmanphong@gmail.com>
    net: usb: asix: init MAC address buffers

Guilherme G. Piccoli <gpiccoli@canonical.com>
    bnx2x: Prevent ptp_task to be rescheduled indefinitely

Andi Kleen <ak@linux.intel.com>
    perf stat: Fix group lookup for metric group

Andi Kleen <ak@linux.intel.com>
    perf stat: Make metric event lookup more robust

Baruch Siach <baruch@tkos.co.il>
    bpf: fix uapi bpf_prog_info fields alignment

Andrei Otcheretianski <andrei.otcheretianski@intel.com>
    iwlwifi: mvm: Drop large non sta frames

Vedang Patel <vedang.patel@intel.com>
    igb: clear out skb->tstamp after reading the txtime

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: mvpp2: prs: Don't override the sign bit in SRAM parser shift

Wen Gong <wgong@codeaurora.org>
    ath10k: destroy sdio workqueue while remove sdio module

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: add some error checking in hclge_tm module

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix a -Wformat-nonliteral compile warning

Coly Li <colyli@suse.de>
    bcache: fix potential deadlock in cached_def_free()

Coly Li <colyli@suse.de>
    bcache: check c->gc_thread by IS_ERR_OR_NULL in cache_set_flush()

Coly Li <colyli@suse.de>
    bcache: acquire bch_register_lock later in cached_dev_free()

Coly Li <colyli@suse.de>
    bcache: check CACHE_SET_IO_DISABLE bit in bch_journal()

Coly Li <colyli@suse.de>
    bcache: check CACHE_SET_IO_DISABLE in allocator code

Eiichi Tsukata <devel@etsukata.com>
    EDAC: Fix global-out-of-bounds write when setting edac_mc_poll_msec

Ahmad Masri <amasri@codeaurora.org>
    wil6210: drop old event after wmi_call timeout

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

Nathan Chancellor <natechancellor@gmail.com>
    xsk: Properly terminate assignment in xskq_produce_flush_desc

Marek Szyprowski <m.szyprowski@samsung.com>
    clocksource/drivers/exynos_mct: Increase priority over ARM arch timer

Tejun Heo <tj@kernel.org>
    libata: don't request sense data on !ZAC ATA devices

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: hdac_hdmi: Set ops to NULL on remove

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

Icenowy Zheng <icenowy@aosc.io>
    net: stmmac: sun8i: force select external PHY when no internal one

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

Julien Thierry <julien.thierry@arm.com>
    arm64: Do not enable IRQs for ct_user_exit

Heiner Litz <hlitz@ucsc.edu>
    lightnvm: pblk: fix freeing of merged pages

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvme-pci: set the errno on ctrl state change error

Minwoo Im <minwoo.im.dev@gmail.com>
    nvme-pci: properly report state change failure in nvme_reset_work

Anton Eidelman <anton@lightbitslabs.com>
    nvme: fix possible io failures when removing multipathed ns

Pan Bian <bianpan2016@163.com>
    EDAC/sysfs: Fix memory leak when creating a csrow object

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Clear status of GPEs on first direct enable

Dennis Zhou <dennis@kernel.org>
    blk-iolatency: only account submitted bios

Qian Cai <cai@lca.pw>
    x86/cacheinfo: Fix a -Wtype-limits warning

Denis Kirjanov <kda@linux-powerpc.org>
    ipoib: correcly show a VF hardware address

Jason Wang <jasowang@redhat.com>
    vhost_net: disable zerocopy by default

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf evsel: Make perf_evsel__name() accept a NULL argument

Peter Zijlstra <peterz@infradead.org>
    x86/atomic: Fix smp_mb__{before,after}_atomic()

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Handle invalid event coding for free-running counter

Qian Cai <cai@lca.pw>
    sched/fair: Fix "runnable_avg_yN_inv" not used warnings

Gao Xiang <gaoxiang25@huawei.com>
    sched/core: Add __sched tag for io_schedule()

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm: fix sa selector validation

Tejun Heo <tj@kernel.org>
    blkcg, writeback: dead memcgs shouldn't contribute to writeback ownership arbitration

Bob Liu <bob.liu@oracle.com>
    block: null_blk: fix race condition for null_del_dev

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: fix for skb leak when doing selftest

Michal Kalderon <michal.kalderon@marvell.com>
    qed: iWARP - Fix tc for MPA ll2 connection

Aaron Lewis <aaronlewis@google.com>
    x86/cpufeatures: Add FDP_EXCPTN_ONLY and ZERO_FCS_FDS

Waiman Long <longman@redhat.com>
    rcu: Force inlining of rcu_read_lock()

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-tdm: fix sample clock inversion

Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>
    x86/cpu: Add Ice Lake NNPI to Intel family

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix empty write to keycreate file

Marek Szyprowski <m.szyprowski@samsung.com>
    media: s5p-mfc: fix reading min scratch buffer size on MFC v6/v7

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

Oliver Neukum <oneukum@suse.com>
    media: uvcvideo: Fix access to uninitialized fields on probe error

Xingyu Chen <xingyu.chen@amlogic.com>
    irqchip/meson-gpio: Add support for Meson-G12A SoC

Thomas Richter <tmricht@linux.ibm.com>
    perf report: Fix OOM error in TUI mode on s390

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

Antoine Tenart <antoine.tenart@bootlin.com>
    crypto: inside-secure - do not rely on the hardware last bit for result descriptors

Biao Huang <biao.huang@mediatek.com>
    net: stmmac: modify default value of tx-frames

Biao Huang <biao.huang@mediatek.com>
    net: stmmac: dwmac4: fix flow control issue

Jiri Olsa <jolsa@redhat.com>
    perf jvmti: Address gcc string overflow warning for strncpy()

Miles Chen <miles.chen@mediatek.com>
    arm64: mm: make CONFIG_ZONE_DMA32 configurable

Abhishek Goel <huntbag@linux.vnet.ibm.com>
    cpupower : frequency-set -r option misses the last cpu in related cpu list

Weihang Li <liweihang@hisilicon.com>
    net: hns3: set ops to null when unregister ad_dev

Kefeng Wang <wangkefeng.wang@huawei.com>
    media: wl128x: Fix some error handling in fm_v4l2_init_video_device()

Imre Deak <imre.deak@intel.com>
    locking/lockdep: Fix merging of hlocks with non-zero references

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix duplicated OGMs on NETDEV_UP

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

Kefeng Wang <wangkefeng.wang@huawei.com>
    media: saa7164: fix remove_proc_entry warning

Hans Verkuil <hverkuil@xs4all.nl>
    media: mc-device.c: don't memset __user pointer contents

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf annotate TUI browser: Do not use member from variable within its own initialization

Eric Biggers <ebiggers@google.com>
    fscrypt: clean up some BUG_ON()s in block encryption/decryption

Anirudh Gupta <anirudhrudr@gmail.com>
    xfrm: Fix xfrm sel prefix length validation

Jeremy Sowden <jeremy@azazel.net>
    af_key: fix leaks in key_pol_get_resp and dump_sp.

Eric W. Biederman <ebiederm@xmission.com>
    signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig

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

Akinobu Mita <akinobu.mita@gmail.com>
    media: ov7740: avoid invalid framesize setting

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - fix skcipher failure due to wrong output IV

Daniel Gomez <dagmcr@gmail.com>
    media: spi: IR LED: add missing of table registration

Oliver Neukum <oneukum@suse.com>
    media: dvb: usb: fix use after free in dvb_usb_device_exit

Jeremy Sowden <jeremy@azazel.net>
    batman-adv: fix for leaked TVLV handler.

Daniel Baluta <daniel.baluta@nxp.com>
    regmap: debugfs: Fix memory leak in regmap_debugfs_init

Anilkumar Kolli <akolli@codeaurora.org>
    ath: DFS JP domain W56 fixed pulse type 3 RADAR detection

Maya Erez <merez@codeaurora.org>
    wil6210: fix spurious interrupts in 3-msi

Wen Gong <wgong@codeaurora.org>
    ath10k: add peer id check in ath10k_peer_find_by_id

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
 Makefile                                           |   4 +-
 arch/arm64/Kconfig                                 |   3 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi     |   3 +-
 arch/arm64/boot/dts/nvidia/tegra210.dtsi           |   2 +-
 arch/arm64/crypto/sha1-ce-glue.c                   |   2 +-
 arch/arm64/crypto/sha2-ce-glue.c                   |   2 +-
 arch/arm64/kernel/acpi.c                           |  10 +-
 arch/arm64/kernel/entry.S                          |   4 +-
 arch/arm64/kernel/image.h                          |   6 +-
 arch/arm64/mm/init.c                               |   5 +-
 arch/mips/boot/compressed/Makefile                 |   2 +
 arch/mips/boot/compressed/calc_vmlinuz_load_addr.c |   2 +-
 arch/mips/include/asm/mach-ath79/ar933x_uart.h     |   4 +-
 arch/parisc/kernel/ptrace.c                        |  31 +-
 arch/powerpc/kernel/exceptions-64s.S               |   9 +-
 arch/powerpc/kernel/swsusp_32.S                    |  73 +++-
 arch/powerpc/platforms/powermac/sleep.S            |  68 +++-
 arch/powerpc/platforms/powernv/npu-dma.c           |  15 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   3 +
 arch/x86/events/amd/uncore.c                       |  15 +-
 arch/x86/events/intel/core.c                       |   8 +-
 arch/x86/events/intel/uncore.h                     |  10 +
 arch/x86/events/intel/uncore_snbep.c               |   1 +
 arch/x86/include/asm/atomic.h                      |   8 +-
 arch/x86/include/asm/atomic64_64.h                 |   8 +-
 arch/x86/include/asm/barrier.h                     |   4 +-
 arch/x86/include/asm/cpufeatures.h                 |   2 +
 arch/x86/include/asm/intel-family.h                |   1 +
 arch/x86/kernel/cpu/cacheinfo.c                    |   3 +-
 arch/x86/kernel/cpu/mkcapflags.sh                  |   2 +
 arch/x86/kernel/mpparse.c                          |  10 +-
 arch/x86/kvm/pmu.c                                 |   4 +-
 block/blk-cgroup.c                                 |   8 +-
 block/blk-iolatency.c                              |   8 +-
 block/blk-throttle.c                               |   9 +-
 crypto/asymmetric_keys/Kconfig                     |   3 +
 crypto/chacha20poly1305.c                          |  30 +-
 crypto/ghash-generic.c                             |   8 +-
 crypto/serpent_generic.c                           |   8 +-
 drivers/acpi/acpica/acevents.h                     |   3 +-
 drivers/acpi/acpica/evgpe.c                        |   8 +-
 drivers/acpi/acpica/evgpeblk.c                     |   2 +-
 drivers/acpi/acpica/evxface.c                      |   2 +-
 drivers/acpi/acpica/evxfgpe.c                      |   2 +-
 drivers/ata/libata-eh.c                            |   8 +-
 drivers/base/regmap/regmap-debugfs.c               |   2 +
 drivers/base/regmap/regmap.c                       |   2 +
 drivers/block/floppy.c                             |  34 +-
 drivers/block/null_blk_main.c                      |  11 +-
 drivers/bluetooth/btusb.c                          |   2 +
 drivers/bluetooth/hci_bcsp.c                       |   5 +
 drivers/clocksource/exynos_mct.c                   |   4 +-
 drivers/crypto/amcc/crypto4xx_alg.c                |  36 +-
 drivers/crypto/amcc/crypto4xx_core.c               |  24 +-
 drivers/crypto/amcc/crypto4xx_core.h               |  10 +-
 drivers/crypto/amcc/crypto4xx_trng.c               |   1 -
 drivers/crypto/caam/caamalg.c                      |  15 +-
 drivers/crypto/ccp/ccp-dev.c                       |  96 +++---
 drivers/crypto/ccp/ccp-dev.h                       |   2 +-
 drivers/crypto/ccp/ccp-ops.c                       |  15 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     |  24 +-
 drivers/crypto/talitos.c                           |  35 +-
 drivers/dma/imx-sdma.c                             |  48 +--
 drivers/edac/edac_mc_sysfs.c                       |  24 +-
 drivers/edac/edac_module.h                         |   2 +-
 drivers/gpio/gpio-omap.c                           |  17 +-
 drivers/gpio/gpiolib.c                             |   7 +-
 drivers/gpu/drm/drm_edid.c                         |  81 ++++-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c     |  20 ++
 drivers/gpu/ipu-v3/ipu-ic.c                        |   2 +-
 drivers/hid/wacom_sys.c                            |   3 +
 drivers/hid/wacom_wac.c                            |  19 +-
 drivers/hid/wacom_wac.h                            |   1 +
 drivers/hwtracing/intel_th/msu.c                   |   2 +-
 drivers/hwtracing/intel_th/pci.c                   |   5 +
 drivers/infiniband/hw/mlx5/main.c                  |   8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   1 +
 drivers/input/mouse/alps.c                         |  32 ++
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/input/tablet/gtco.c                        |  20 +-
 drivers/iommu/iommu.c                              |   8 +-
 drivers/irqchip/irq-meson-gpio.c                   |   1 +
 drivers/lightnvm/pblk-core.c                       |  18 +-
 drivers/md/bcache/alloc.c                          |   9 +
 drivers/md/bcache/bcache.h                         |   2 -
 drivers/md/bcache/io.c                             |  12 +
 drivers/md/bcache/journal.c                        |  52 ++-
 drivers/md/bcache/super.c                          |  25 +-
 drivers/md/bcache/sysfs.c                          |   4 +-
 drivers/md/bcache/util.h                           |   2 -
 drivers/md/bcache/writeback.c                      |   5 +
 drivers/md/dm-bufio.c                              |   4 +-
 drivers/md/dm-zoned-metadata.c                     |  24 --
 drivers/md/dm-zoned.h                              |  28 +-
 drivers/md/raid5.c                                 |  11 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |   4 +
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |   2 +-
 drivers/media/dvb-frontends/tua6100.c              |  22 +-
 drivers/media/i2c/Makefile                         |   2 +-
 drivers/media/i2c/{adv7511.c => adv7511-v4l2.c}    |   5 +
 drivers/media/i2c/ov7740.c                         |   6 +-
 drivers/media/media-device.c                       |  10 +-
 drivers/media/pci/saa7164/saa7164-core.c           |  33 +-
 drivers/media/platform/coda/coda-bit.c             |   9 +-
 drivers/media/platform/coda/coda-common.c          |   2 +
 drivers/media/platform/davinci/vpss.c              |   5 +
 drivers/media/platform/marvell-ccic/mcam-core.c    |   5 +-
 drivers/media/platform/rcar_fdp1.c                 |   8 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |   5 +
 drivers/media/platform/vimc/vimc-capture.c         |   5 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |   3 +
 drivers/media/rc/ir-spi.c                          |   1 +
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |   7 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |  17 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |   4 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |   9 +-
 drivers/mmc/host/sdhci-msm.c                       |   9 +-
 drivers/mtd/nand/raw/mtk_nand.c                    |  24 +-
 drivers/mtd/nand/spi/core.c                        |   2 +-
 drivers/net/bonding/bond_main.c                    |  37 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   5 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  33 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h  |   3 +
 drivers/net/ethernet/freescale/fec_main.c          |   6 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   6 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   3 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   6 +-
 drivers/net/ethernet/intel/i40evf/i40e_txrx.c      |   6 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h       |   1 +
 drivers/net/ethernet/marvell/mvmdio.c              |   7 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     |   3 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  29 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |   2 +
 drivers/net/ethernet/qlogic/qed/qed_rdma.c         |   2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   5 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |   6 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |  18 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  20 +-
 drivers/net/gtp.c                                  |  36 +-
 drivers/net/phy/phy_device.c                       |   6 +
 drivers/net/phy/sfp.c                              |   6 +-
 drivers/net/usb/asix_devices.c                     |   6 +-
 drivers/net/wireless/ath/ath10k/hw.c               |   2 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   4 +
 drivers/net/wireless/ath/ath10k/sdio.c             |   7 +
 drivers/net/wireless/ath/ath10k/txrx.c             |   3 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |  10 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  32 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c    |   2 +-
 drivers/net/wireless/ath/wil6210/interrupt.c       |  65 ++--
 drivers/net/wireless/ath/wil6210/txrx.c            |   1 +
 drivers/net/wireless/ath/wil6210/wmi.c             |  13 +-
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   3 +
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |   2 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  27 ++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  66 ++--
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   9 +
 drivers/net/wireless/mediatek/mt7601u/dma.c        |  54 +--
 drivers/net/wireless/mediatek/mt7601u/tx.c         |   4 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   5 +-
 drivers/nvdimm/dax_devs.c                          |   2 +-
 drivers/nvdimm/pfn.h                               |   1 +
 drivers/nvdimm/pfn_devs.c                          |  18 +-
 drivers/nvme/host/core.c                           |  14 +-
 drivers/nvme/host/pci.c                            |   8 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |   2 +
 drivers/pci/controller/pci-hyperv.c                |  15 +-
 drivers/pci/pci.c                                  |   7 +
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
 drivers/usb/core/hub.c                             |   7 +-
 drivers/vhost/net.c                                |   2 +-
 drivers/xen/balloon.c                              |  16 +-
 drivers/xen/events/events_base.c                   |  12 +-
 drivers/xen/evtchn.c                               |   2 +-
 fs/btrfs/file.c                                    |   5 +
 fs/btrfs/tree-log.c                                |  40 ++-
 fs/cifs/connect.c                                  |   2 +-
 fs/coda/file.c                                     |  70 +++-
 fs/crypto/crypto.c                                 |  15 +-
 fs/ecryptfs/crypto.c                               |  12 +-
 fs/fs-writeback.c                                  |   8 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   2 +-
 fs/nfs/inode.c                                     |   1 +
 fs/nfs/nfs4file.c                                  |   2 +-
 fs/nfs/pnfs.c                                      |   4 +-
 fs/proc/proc_sysctl.c                              |   4 +
 fs/xfs/libxfs/xfs_ag_resv.c                        |   2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c                   |   4 +-
 fs/xfs/xfs_attr_list.c                             |   1 +
 fs/xfs/xfs_bmap_util.c                             |   2 +-
 fs/xfs/xfs_bmap_util.h                             |   2 +
 fs/xfs/xfs_file.c                                  |  27 +-
 fs/xfs/xfs_fsops.c                                 |   1 +
 fs/xfs/xfs_inode.c                                 |  18 +-
 fs/xfs/xfs_iops.c                                  |  21 +-
 fs/xfs/xfs_mount.h                                 |   2 +-
 fs/xfs/xfs_reflink.c                               |  16 +-
 fs/xfs/xfs_super.c                                 |   7 +
 fs/xfs/xfs_xattr.c                                 |   3 +
 include/asm-generic/bug.h                          |   6 +-
 include/drm/drm_displayid.h                        |  10 +
 include/linux/cpuhotplug.h                         |   2 +-
 include/linux/rcupdate.h                           |   2 +-
 include/net/ip_vs.h                                |   6 +-
 include/rdma/ib_verbs.h                            |   4 +-
 include/trace/events/rxrpc.h                       |   2 +-
 include/uapi/linux/bpf.h                           |   1 +
 include/xen/events.h                               |   3 +-
 kernel/bpf/Makefile                                |   1 +
 kernel/locking/lockdep.c                           |  18 +-
 kernel/padata.c                                    |  12 +
 kernel/pid_namespace.c                             |   2 +-
 kernel/sched/core.c                                |   2 +-
 kernel/sched/sched-pelt.h                          |   2 +-
 kernel/time/ntp.c                                  |   4 +-
 kernel/time/timer_list.c                           |  36 +-
 lib/reed_solomon/decode_rs.c                       |  18 +-
 lib/scatterlist.c                                  |   9 +-
 net/9p/trans_virtio.c                              |   8 +-
 net/9p/trans_xen.c                                 |   8 +-
 net/batman-adv/bat_iv_ogm.c                        |   4 +-
 net/batman-adv/hard-interface.c                    |   3 +
 net/batman-adv/translation-table.c                 |   2 +
 net/batman-adv/types.h                             |   3 +
 net/bluetooth/6lowpan.c                            |  14 +-
 net/bluetooth/hci_event.c                          |   5 +
 net/bluetooth/l2cap_core.c                         |  15 +-
 net/bluetooth/smp.c                                |  13 +
 net/key/af_key.c                                   |   8 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  21 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   4 -
 net/netfilter/ipvs/ip_vs_sync.c                    | 134 ++++----
 net/xdp/xsk_queue.h                                |   2 +-
 net/xfrm/Kconfig                                   |   2 +
 net/xfrm/xfrm_user.c                               |  19 ++
 scripts/kconfig/confdata.c                         |   7 +-
 scripts/kconfig/expr.h                             |   1 +
 security/selinux/hooks.c                           |  11 +-
 sound/core/seq/seq_clientmgr.c                     |  11 +-
 sound/pci/hda/patch_realtek.c                      |  10 +-
 sound/soc/codecs/hdac_hdmi.c                       |   6 +
 sound/soc/meson/axg-tdm.h                          |   2 +-
 sound/soc/soc-dapm.c                               |  18 +-
 tools/bpf/bpftool/jit_disasm.c                     |  11 +-
 tools/include/uapi/linux/bpf.h                     |   1 +
 tools/lib/bpf/libbpf.c                             |   8 +-
 tools/perf/arch/arm/util/cs-etm.c                  | 127 ++++++-
 tools/perf/jvmti/libjvmti.c                        |   4 +-
 tools/perf/perf.h                                  |   2 +-
 tools/perf/tests/parse-events.c                    |  27 ++
 .../tests/shell/record+probe_libc_inet_pton.sh     |   2 +-
 tools/perf/ui/browsers/annotate.c                  |   5 +-
 tools/perf/util/annotate.c                         |   5 +-
 tools/perf/util/evsel.c                            |   8 +-
 tools/perf/util/header.c                           |   2 +-
 tools/perf/util/metricgroup.c                      |  47 ++-
 tools/perf/util/stat-shadow.c                      |   5 +-
 tools/power/cpupower/utils/cpufreq-set.c           |   2 +
 tools/testing/selftests/bpf/test_lwt_seg6local.c   |  12 +-
 280 files changed, 2533 insertions(+), 1068 deletions(-)


