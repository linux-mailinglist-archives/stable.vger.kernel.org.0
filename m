Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79411EEF5F
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388068AbfKDV6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:58:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:55578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388034AbfKDV6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:58:34 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE35021744;
        Mon,  4 Nov 2019 21:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904713;
        bh=cSx6GwyYxGmMR1+wulVsFwOfORtNECpv/wNfs1AdwFo=;
        h=From:To:Cc:Subject:Date:From;
        b=IALp32UjAGOfhOT0erVWkl9rObhu4TJM+g6wbA/VEApZYWVQ7O6wgtpUxDmR23Ub1
         t9fWlstvIqK+ocAamwSZ17mB1tl3qJk4RDiOn+Z/KsLfNcl65cabZssUNN/Ij+LWM3
         2u6ue6/C3AIkf3QOHrH8jgZpUbCFYj4Il6lsDy4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/149] 4.19.82-stable review
Date:   Mon,  4 Nov 2019 22:43:13 +0100
Message-Id: <20191104212126.090054740@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.82-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.82-rc1
X-KernelTest-Deadline: 2019-11-06T21:21+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.82 release.
There are 149 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.82-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.82-rc1

Justin Song <flyingecar@gmail.com>
    ALSA: usb-audio: Add DSD support for Gustard U16/X26 USB Interface

Jussi Laako <jussi@sonarnerd.net>
    ALSA: usb-audio: Update DSD support quirks for Oppo and Rotel

Jussi Laako <jussi@sonarnerd.net>
    ALSA: usb-audio: DSD auto-detection for Playback Designs

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Fix mutex deadlock at releasing card

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Simplify error path in snd_timer_open()

Eric Dumazet <edumazet@google.com>
    sch_netem: fix rcu splat in netem_enqueue()

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    net: usb: sr9800: fix uninitialized local variable

Eric Dumazet <edumazet@google.com>
    bonding: fix potential NULL deref in bond_update_slave_arr

Johan Hovold <johan@kernel.org>
    NFC: pn533: fix use-after-free and memleaks

David Howells <dhowells@redhat.com>
    rxrpc: Fix trace-after-put looking at the put peer record

David Howells <dhowells@redhat.com>
    rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record

David Howells <dhowells@redhat.com>
    rxrpc: Fix call ref leak

Eric Biggers <ebiggers@google.com>
    llc: fix sk_buff leak in llc_conn_service()

Eric Biggers <ebiggers@google.com>
    llc: fix sk_buff leak in llc_sap_state_process()

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid free/alloc race when handling OGM buffer

Trond Myklebust <trondmy@gmail.com>
    NFS: Fix an RCU lock leak in nfs4_refresh_delegation_stateid()

Pelle van Gils <pelle@vangils.xyz>
    drm/amdgpu/powerplay/vega10: allow undervolting in p7

Tony Lindgren <tony@atomide.com>
    dmaengine: cppi41: Fix cppi41_dma_prep_slave_sg() when idle

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    dmaengine: qcom: bam_dma: Fix resource leak

Laura Abbott <labbott@redhat.com>
    rtlwifi: Fix potential overflow on P2P code

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Ensure VM_WRITE|VM_SHARED ptes are clean by default

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/idle: fix cpu idle time calculation

Yihui ZENG <yzeng56@asu.edu>
    s390/cmm: fix information leak in cmm_timeout_handler()

Markus Theil <markus.theil@tu-ilmenau.de>
    nl80211: fix validation of mesh path nexthop

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    HID: fix error message in hid_open_report()

Alan Stern <stern@rowland.harvard.edu>
    HID: Fix assumption that devices have inputs

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: add Trekstor Primebook C11B to descriptor override

Bart Van Assche <bvanassche@acm.org>
    scsi: target: cxgbit: Fix cxgbit_fw4_ack()

Johan Hovold <johan@kernel.org>
    USB: serial: whiteheat: fix line-speed endianness

Johan Hovold <johan@kernel.org>
    USB: serial: whiteheat: fix potential slab corruption

Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
    usb: xhci: fix __le32/__le64 accessors in debugfs code

Johan Hovold <johan@kernel.org>
    USB: ldusb: fix control-message timeout

Johan Hovold <johan@kernel.org>
    USB: ldusb: fix ring-buffer locking

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: Revert commit 747668dbc061 ("usb-storage: Set virt_boundary_mask to avoid SG overflows")

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: Reject endpoints with 0 maxpacket value

Alan Stern <stern@rowland.harvard.edu>
    UAS: Revert commit 3ae62a42090f ("UAS: fix alignment of scatter/gather segments")

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add support for ALC623

Aaron Ma <aaron.ma@canonical.com>
    ALSA: hda/realtek - Fix 2 front mics of codec 0x623

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: bebob: Fix prototype of helper function to return negative value

Miklos Szeredi <mszeredi@redhat.com>
    fuse: truncate pending writes on O_TRUNC

Miklos Szeredi <mszeredi@redhat.com>
    fuse: flush dirty data/metadata before non-truncate setattr

Hui Peng <benquike@gmail.com>
    ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Use 32-bit writes when writing ring producer/consumer

Dan Carpenter <dan.carpenter@oracle.com>
    USB: legousbtower: fix a signedness bug in tower_probe()

Mike Christie <mchristi@redhat.com>
    nbd: verify socket is supported during setup

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: exclude GEO SAR support for 3168

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Reduce the Headphone static noise on XPS 9350/9360

Vladimir Murzin <vladimir.murzin@arm.com>
    ARM: 8914/1: NOMMU: Fix exc_ret for XIP

Petr Mladek <pmladek@suse.com>
    tracing: Initialize iter->seq after zeroing in tracing_read_pipe()

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/uaccess: avoid (false positive) compiler warnings

Chuck Lever <chuck.lever@oracle.com>
    NFSv4: Fix leak of clp->cl_acceptor string

Xiubo Li <xiubli@redhat.com>
    nbd: fix possible sysfs duplicate warning

Navid Emamdoost <navid.emamdoost@gmail.com>
    virt: vbox: fix memory leak in hgcm_call_preprocess_linaddr

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    MIPS: fw: sni: Fix out of bounds init of o32 stack

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    MIPS: include: Mark __xchg as __always_inline

Navid Emamdoost <navid.emamdoost@gmail.com>
    iio: imu: adis16400: release allocated memory on failure

Nirmoy Das <nirmoy.das@amd.com>
    drm/amdgpu: fix memory leak

Tom Lendacky <thomas.lendacky@amd.com>
    perf/x86/amd: Change/fix NMI latency mitigation to use a timestamp

Frederic Weisbecker <frederic@kernel.org>
    sched/vtime: Fix guest/system mis-accounting on task switch

Kan Liang <kan.liang@linux.intel.com>
    x86/cpu: Add Comet Lake to the Intel CPU models header

Yunfeng Ye <yeyunfeng@huawei.com>
    arm64: armv8_deprecated: Checking return value for memory allocation

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: ocfs2: fix a possible null-pointer dereference in ocfs2_info_scan_inode_alloc()

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: ocfs2: fix a possible null-pointer dereference in ocfs2_write_end_nolock()

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa_prepare_entry()

Jia Guo <guojia12@huawei.com>
    ocfs2: clear zero in unaligned direct IO

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    x86/xen: Return from panic notifier

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    MIPS: include: Mark __cmpxchg as __always_inline

Dave Young <dyoung@redhat.com>
    efi/x86: Do not clean dummy variable in kexec path

Lukas Wunner <lukas@wunner.de>
    efi/cper: Fix endianness of PCIe class code

Adam Ford <aford173@gmail.com>
    serial: mctrl_gpio: Check for NULL pointer

Austin Kim <austindh.kim@gmail.com>
    fs: cifs: mute -Wunused-const-variable message

Thierry Reding <treding@nvidia.com>
    gpio: max77620: Use correct unit for debounce times

Randy Dunlap <rdunlap@infradead.org>
    tty: n_hdlc: fix build on SPARC

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    tty: serial: owl: Fix the link time qualifier of 'owl_uart_exit()'

James Morse <james.morse@arm.com>
    arm64: ftrace: Ensure synchronisation in PLT setup for Neoverse-N1 #1542419

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    nfs: Fix nfsi->nrequests count error on nfs_inode_remove_request

Dexuan Cui <decui@microsoft.com>
    HID: hyperv: Use in-place iterator API in the channel callback

Bart Van Assche <bvanassche@acm.org>
    RDMA/iwcm: Fix a lock inversion issue

Navid Emamdoost <navid.emamdoost@gmail.com>
    RDMA/hfi1: Prevent memory leak in sdma_init

Connor Kuehl <connor.kuehl@canonical.com>
    staging: rtl8188eu: fix null dereference when kzalloc fails

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf annotate: Return appropriate error code for allocation failures

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf annotate: Propagate the symbol__annotate() error return

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf annotate: Fix the signedness of failure returns

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf annotate: Propagate perf_env__arch() error

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Propagate get_cpuid() error

Andi Kleen <ak@linux.intel.com>
    perf jevents: Fix period for Intel fixed counters

Andi Kleen <ak@linux.intel.com>
    perf script brstackinsn: Fix recovery from LBR/binary mismatch

Steve MacLean <Steve.MacLean@microsoft.com>
    perf map: Fix overlapped map handling

Ian Rogers <irogers@google.com>
    perf tests: Avoid raising SEGV using an obvious NULL dereference

Ian Rogers <irogers@google.com>
    libsubcmd: Make _FORTIFY_SOURCE defines dependent on the feature

Pascal Bouwmann <bouwmann@tau-tec.de>
    iio: fix center temperature of bmc150-accel-core

Remi Pommarel <repk@triplefau.lt>
    iio: adc: meson_saradc: Fix memory allocation order

Sven Van Asbroeck <thesven73@gmail.com>
    power: supply: max14656: fix potential use-after-free

Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
    drm/amd/display: fix odm combine pipe reset

Sven Van Asbroeck <thesven73@gmail.com>
    PCI/PME: Fix possible use-after-free on remove

Andrew Lunn <andrew@lunn.ch>
    net: dsa: mv88e6xxx: Release lock while requesting IRQ

Kees Cook <keescook@chromium.org>
    exec: load_script: Do not exec truncated interpreter path

Theodore Ts'o <tytso@mit.edu>
    ext4: disallow files with EXT4_JOURNAL_DATA_FL from EXT4_IOC_SWAP_BOOT

Lucas A. M. Magalhães <lucmaga@gmail.com>
    media: vimc: Remove unused but set variables

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Apply ALC294 hp init also for S4 resume

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: add credits from unmatched responses/messages

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Respect SMB2 hdr preamble size in read responses

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Correct localport timeout duration error

Jose Abreu <jose.abreu@synopsys.com>
    net: stmmac: Fix NAPI poll in TX path when in multi-queue

Nir Dotan <nird@mellanox.com>
    mlxsw: spectrum: Set LAG port collector only when active

Hanjun Guo <hanjun.guo@linaro.org>
    arm64: kpti: Whitelist HiSilicon Taishan v110 CPUs

Hanjun Guo <hanjun.guo@linaro.org>
    arm64: Add MIDR encoding for HiSilicon Taishan CPUs

Sam Ravnborg <sam@ravnborg.org>
    rtc: pcf8523: set xtal load capacitance from DT

Jan-Marek Glogowski <glogow@fbihome.de>
    usb: handle warm-reset port requests on hub resume

Jussi Laako <jussi@sonarnerd.net>
    ALSA: usb-audio: Cleanup DSD whitelist

Felipe Balbi <felipe.balbi@linux.intel.com>
    usb: dwc3: gadget: clear DWC3_EP_TRANSFER_STARTED on cmd complete

Felipe Balbi <felipe.balbi@linux.intel.com>
    usb: dwc3: gadget: early giveback if End Transfer already completed

Daniel T. Lee <danieltimlee@gmail.com>
    samples: bpf: fix: seg fault with NULL pointer arg

Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>
    HID: steam: fix deadlock with input devices.

Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>
    HID: steam: fix boot loop with bluetooth firmware

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Ensure that the state manager exits the loop on SIGKILL

NOGUCHI Hiroshi <drvlabo@gmail.com>
    HID: Add ASUS T100CHI keyboard dock battery quirks

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    staging: mt7621-pinctrl: use pinconf-generic for 'dt_node_to_map' and 'dt_free_map'

Brian Norris <briannorris@chromium.org>
    scripts/setlocalversion: Improve -dirty check with git-status --no-optional-locks

Yi Wang <wang.yi59@zte.com.cn>
    clk: boston: unregister clks on failure in clk_boston_setup()

Abhishek Ambure <aambure@codeaurora.org>
    ath10k: assign 'n_cipher_suites = 11' for WCN3990 to enable WPA3

Ville Syrjälä <ville.syrjala@linux.intel.com>
    platform/x86: Fix config space access for intel_atomisp2_pm

Ville Syrjälä <ville.syrjala@linux.intel.com>
    platform/x86: Add the VLV ISP PCI ID to atomisp2_pm

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: Add Odys Winbook 13 to descriptor override

Kai-Heng Feng <kai.heng.feng@canonical.com>
    HID: i2c-hid: Ignore input report if there's no data present on Elan touchpanels

Kai-Heng Feng <kai.heng.feng@canonical.com>
    HID: i2c-hid: Disable runtime PM for LG touchscreen

Stefano Brivio <sbrivio@redhat.com>
    netfilter: ipset: Make invalid MAC address checks consistent

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix deadlock on tree root leaf when finding free extent

Logan Gunthorpe <logang@deltatee.com>
    PCI: Fix Switchtec DMA aliasing quirk dmesg noise

Coly Li <colyli@suse.de>
    bcache: fix input overflow to writeback_rate_minimum

Jeykumar Sankaran <jsanka@codeaurora.org>
    drm/msm/dpu: handle failures while initializing displays

Kan Liang <kan.liang@linux.intel.com>
    x86/cpu: Add Atom Tremont (Jacobsville)

Len Brown <len.brown@intel.com>
    tools/power turbostat: fix goldmont C-state limit decoding

Fabrice Gasnier <fabrice.gasnier@st.com>
    usb: dwc2: fix unbalanced use of external vbus-supply

Julian Sax <jsbc@gmx.de>
    HID: i2c-hid: add Direkt-Tek DTLAPY133-1 to descriptor override

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to recover inode->i_flags of inode block during POR

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to recover inode's i_gc_failures during POR

David Hildenbrand <david@redhat.com>
    powerpc/powernv: hold device_hotplug_lock when calling memtrace_offline_pages()

Phil Elwell <phil@raspberrypi.org>
    sc16is7xx: Fix for "Unexpected interrupt: 8"

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix a duplicate 0711 log message number.

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: flush quota blocks after turnning it off

Ahmad Masri <amasri@codeaurora.org>
    wil6210: fix freeing of rx buffers in EDMA mode

Qu Wenruo <wqu@suse.com>
    btrfs: tracepoints: Fix wrong parameter order for qgroup events

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: Always free PREALLOC META reserve in btrfs_delalloc_release_extents()

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix memory leak due to concurrent append writes with fiemap

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix inode cache block reserve leak on failure to allocate data space

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: rework COW throttling to fix deadlock

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: introduce account_start_copy() and account_end_copy()

Sasha Levin <sashal@kernel.org>
    zram: fix race between backing_dev_show and backing_dev_store


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   4 +
 Makefile                                           |   4 +-
 arch/arm/kernel/head-common.S                      |   5 +-
 arch/arm/kernel/head-nommu.S                       |   2 +
 arch/arm/mm/proc-v7m.S                             |   5 +-
 arch/arm64/include/asm/cputype.h                   |   4 +
 arch/arm64/include/asm/pgtable-prot.h              |  15 +--
 arch/arm64/kernel/armv8_deprecated.c               |   5 +
 arch/arm64/kernel/cpufeature.c                     |   1 +
 arch/arm64/kernel/ftrace.c                         |  12 ++-
 arch/mips/fw/sni/sniprom.c                         |   2 +-
 arch/mips/include/asm/cmpxchg.h                    |   9 +-
 arch/powerpc/platforms/powernv/memtrace.c          |   4 +-
 arch/s390/include/asm/uaccess.h                    |   4 +-
 arch/s390/kernel/idle.c                            |  29 ++++--
 arch/s390/mm/cmm.c                                 |  12 +--
 arch/x86/events/amd/core.c                         |  30 +++---
 arch/x86/include/asm/intel-family.h                |   6 +-
 arch/x86/platform/efi/efi.c                        |   3 -
 arch/x86/xen/enlighten.c                           |  28 ++++-
 drivers/block/nbd.c                                |  25 ++++-
 drivers/block/zram/zram_drv.c                      |   5 +-
 drivers/clk/imgtec/clk-boston.c                    |  18 +++-
 drivers/dma/qcom/bam_dma.c                         |  19 ++++
 drivers/dma/ti/cppi41.c                            |  21 +++-
 drivers/firmware/efi/cper.c                        |   2 +-
 drivers/gpio/gpio-max77620.c                       |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c        |  14 +--
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   6 +-
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c |   4 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |  31 +++---
 drivers/hid/hid-axff.c                             |  11 +-
 drivers/hid/hid-core.c                             |   7 +-
 drivers/hid/hid-dr.c                               |  12 ++-
 drivers/hid/hid-emsff.c                            |  12 ++-
 drivers/hid/hid-gaff.c                             |  12 ++-
 drivers/hid/hid-holtekff.c                         |  12 ++-
 drivers/hid/hid-hyperv.c                           |  56 ++--------
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-input.c                            |   3 +
 drivers/hid/hid-lg2ff.c                            |  12 ++-
 drivers/hid/hid-lg3ff.c                            |  11 +-
 drivers/hid/hid-lg4ff.c                            |  11 +-
 drivers/hid/hid-lgff.c                             |  11 +-
 drivers/hid/hid-logitech-hidpp.c                   |  11 +-
 drivers/hid/hid-sony.c                             |  12 ++-
 drivers/hid/hid-steam.c                            |  60 +++++------
 drivers/hid/hid-tmff.c                             |  12 ++-
 drivers/hid/hid-zpff.c                             |  12 ++-
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  11 ++
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |  35 +++++++
 drivers/iio/accel/bmc150-accel-core.c              |   2 +-
 drivers/iio/adc/meson_saradc.c                     |  10 +-
 drivers/iio/imu/adis_buffer.c                      |   5 +-
 drivers/infiniband/core/cma.c                      |   3 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |   5 +-
 drivers/md/bcache/sysfs.c                          |   4 +-
 drivers/md/dm-snap.c                               |  90 +++++++++++++---
 drivers/media/platform/vimc/vimc-sensor.c          |   7 --
 drivers/net/bonding/bond_main.c                    |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  62 ++++++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   5 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 115 ++++++++++++---------
 drivers/net/usb/sr9800.c                           |   2 +-
 drivers/net/wireless/ath/ath10k/core.c             |   2 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |   8 ++
 drivers/net/wireless/ath/wil6210/txrx_edma.c       |  44 +++-----
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  16 +--
 drivers/net/wireless/realtek/rtlwifi/ps.c          |   6 ++
 drivers/nfc/pn533/usb.c                            |   9 +-
 drivers/pci/pcie/pme.c                             |   1 +
 drivers/pci/quirks.c                               |   4 +-
 drivers/platform/x86/intel_atomisp2_pm.c           |  69 +++++++++----
 drivers/power/supply/max14656_charger_detector.c   |  17 ++-
 drivers/rtc/rtc-pcf8523.c                          |  28 +++--
 drivers/scsi/lpfc/lpfc_nvmet.c                     |   6 +-
 drivers/scsi/lpfc/lpfc_nvmet.h                     |   2 +
 drivers/scsi/lpfc/lpfc_scsi.c                      |   2 +-
 drivers/staging/mt7621-pinctrl/Kconfig             |   1 +
 drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c    |  41 +-------
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   6 +-
 drivers/target/iscsi/cxgbit/cxgbit_cm.c            |   3 +-
 drivers/thunderbolt/nhi.c                          |  22 +++-
 drivers/tty/n_hdlc.c                               |   5 +
 drivers/tty/serial/owl-uart.c                      |   2 +-
 drivers/tty/serial/sc16is7xx.c                     |  28 +++++
 drivers/tty/serial/serial_mctrl_gpio.c             |   3 +
 drivers/usb/core/hub.c                             |   7 ++
 drivers/usb/dwc2/hcd.c                             |  33 ++++--
 drivers/usb/dwc3/gadget.c                          |  25 ++---
 drivers/usb/gadget/udc/core.c                      |  11 ++
 drivers/usb/host/xhci-debugfs.c                    |  24 ++---
 drivers/usb/misc/ldusb.c                           |   6 +-
 drivers/usb/misc/legousbtower.c                    |   2 +-
 drivers/usb/serial/whiteheat.c                     |  13 ++-
 drivers/usb/serial/whiteheat.h                     |   2 +-
 drivers/usb/storage/scsiglue.c                     |  10 --
 drivers/usb/storage/uas.c                          |  20 ----
 drivers/virt/vboxguest/vboxguest_utils.c           |   3 +-
 fs/binfmt_script.c                                 |  57 ++++++++--
 fs/btrfs/ctree.h                                   |   6 +-
 fs/btrfs/extent-tree.c                             |   5 +-
 fs/btrfs/file.c                                    |  20 +++-
 fs/btrfs/free-space-cache.c                        |  22 +++-
 fs/btrfs/inode-map.c                               |   5 +-
 fs/btrfs/inode.c                                   |  44 +++++---
 fs/btrfs/ioctl.c                                   |   6 +-
 fs/btrfs/qgroup.c                                  |   4 +-
 fs/btrfs/relocation.c                              |   9 +-
 fs/cifs/cifssmb.c                                  |   7 +-
 fs/cifs/connect.c                                  |  22 ++++
 fs/cifs/netmisc.c                                  |   4 -
 fs/cifs/smb2misc.c                                 |   7 --
 fs/cifs/smb2ops.c                                  |   6 +-
 fs/ext4/ioctl.c                                    |   1 +
 fs/f2fs/recovery.c                                 |   3 +
 fs/f2fs/super.c                                    |   6 ++
 fs/fuse/dir.c                                      |  13 +++
 fs/fuse/file.c                                     |  10 +-
 fs/nfs/delegation.c                                |   2 +-
 fs/nfs/nfs4proc.c                                  |   1 +
 fs/nfs/nfs4state.c                                 |   2 +-
 fs/nfs/write.c                                     |   5 +-
 fs/ocfs2/aops.c                                    |  25 ++++-
 fs/ocfs2/ioctl.c                                   |   2 +-
 fs/ocfs2/xattr.c                                   |  56 +++++-----
 include/net/llc_conn.h                             |   2 +-
 include/net/sch_generic.h                          |   5 +
 include/trace/events/rxrpc.h                       |   6 +-
 kernel/sched/cputime.c                             |   6 +-
 kernel/trace/trace.c                               |   1 +
 net/batman-adv/bat_iv_ogm.c                        |  60 +++++++++--
 net/batman-adv/hard-interface.c                    |   2 +
 net/batman-adv/types.h                             |   3 +
 net/llc/llc_c_ac.c                                 |   8 +-
 net/llc/llc_conn.c                                 |  32 ++----
 net/llc/llc_s_ac.c                                 |  12 ++-
 net/llc/llc_sap.c                                  |  23 ++---
 net/netfilter/ipset/ip_set_bitmap_ipmac.c          |   3 +
 net/netfilter/ipset/ip_set_hash_ipmac.c            |  11 +-
 net/rxrpc/peer_object.c                            |  16 +--
 net/rxrpc/sendmsg.c                                |   1 +
 net/sched/sch_netem.c                              |   2 +-
 net/wireless/nl80211.c                             |   3 +-
 samples/bpf/bpf_load.c                             |   4 +-
 scripts/setlocalversion                            |  12 ++-
 sound/core/timer.c                                 |  63 ++++++-----
 sound/firewire/bebob/bebob_stream.c                |   3 +-
 sound/pci/hda/patch_realtek.c                      |  39 ++++++-
 sound/usb/quirks.c                                 |  31 ++----
 tools/lib/subcmd/Makefile                          |   8 +-
 tools/perf/arch/powerpc/util/header.c              |   3 +-
 tools/perf/arch/s390/util/header.c                 |   9 +-
 tools/perf/arch/x86/util/header.c                  |   3 +-
 tools/perf/builtin-kvm.c                           |   7 +-
 tools/perf/builtin-script.c                        |   6 +-
 tools/perf/pmu-events/jevents.c                    |  12 +--
 tools/perf/tests/perf-hooks.c                      |   3 +-
 tools/perf/util/annotate.c                         |  10 +-
 tools/perf/util/map.c                              |   3 +
 tools/power/x86/turbostat/turbostat.c              |   9 +-
 162 files changed, 1450 insertions(+), 775 deletions(-)


