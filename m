Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCFAB3A7FE
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732858AbfFIQz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:55:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732261AbfFIQz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:55:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D65D206BB;
        Sun,  9 Jun 2019 16:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099355;
        bh=Qm+y1+/TF9rbf7J6UaRUgGm2L7BdRUozboLwCyVsT2E=;
        h=From:To:Cc:Subject:Date:From;
        b=lKbVZeviPODcLBeCBoa1trk1rvWBN5xVfEJU/kgXDPe8vW5cVgMDT8GooZDayMHUa
         eidxHI3xLTKSN+SPG0HSTcQbrM6ljeYbGQZ2dUxq/tQJmqeJnc49Jc1g+u/JVb5Pkm
         eEHqTt3hu2CKAap+bc2kuEv1faxTaiLTsBk8Jd8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 000/241] 4.4.181-stable review
Date:   Sun,  9 Jun 2019 18:39:02 +0200
Message-Id: <20190609164147.729157653@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.181-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.181-rc1
X-KernelTest-Deadline: 2019-06-11T16:41+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.181 release.
There are 241 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue 11 Jun 2019 04:39:53 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.181-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.181-rc1

Kirill Smelkov <kirr@nexedi.com>
    fuse: Add FOPEN_STREAM to use stream_open()

Kirill Smelkov <kirr@nexedi.com>
    fs: stream_open - opener for stream-like files so that read and write can run simultaneously without deadlock

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    drm/gma500/cdv: Check vbt config bits when detecting lvds panels

Dan Carpenter <dan.carpenter@oracle.com>
    genwqe: Prevent an integer overflow in the ioctl

Paul Burton <paul.burton@mips.com>
    MIPS: pistachio: Build uImage.gz by default

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fallocate: fix return with locked inode

John David Anglin <dave.anglin@bell.net>
    parisc: Use implicit space register selection for loading the coherence index of I/O pdirs

Linus Torvalds <torvalds@linux-foundation.org>
    rcu: locking and unlocking need to always be at least barriers

Paolo Abeni <pabeni@redhat.com>
    pktgen: do not sleep with the thread lock held.

Zhu Yanjun <yanjun.zhu@oracle.com>
    net: rds: fix memory leak in rds_ib_flush_mr_pool

Erez Alfasi <ereza@mellanox.com>
    net/mlx4_en: ethtool, Remove unsupported SFP EEPROM high pages query

David Ahern <dsahern@gmail.com>
    neighbor: Call __ipv4_neigh_lookup_noref in neigh_xmit

Vivien Didelot <vivien.didelot@gmail.com>
    ethtool: fix potential userspace buffer overflow

Nadav Amit <namit@vmware.com>
    media: uvcvideo: Fix uvc_alloc_entity() allocation alignment

Peter Chen <peter.chen@nxp.com>
    usb: gadget: fix request length error for isoc transfer

Bjørn Mork <bjorn@mork.no>
    net: cdc_ncm: GetNtbFormat endian fix

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "x86/build: Move _etext to actual end of .text"

Oleg Nesterov <oleg@redhat.com>
    userfaultfd: don't pin the user memory in userfaultfd_file_create()

Arend van Spriel <arend.vanspriel@broadcom.com>
    brcmfmac: add subtype check for event handling in data path

Arend Van Spriel <arend.vanspriel@broadcom.com>
    brcmfmac: add length checks in scheduled scan result handler

Gavin Li <git@thegavinli.com>
    brcmfmac: fix incorrect event channel deduction

Arend van Spriel <arend@broadcom.com>
    brcmfmac: revise handling events in receive path

Franky Lin <franky.lin@broadcom.com>
    brcmfmac: screening firmware event packet

Hante Meuleman <meuleman@broadcom.com>
    brcmfmac: Add length checks on firmware events

Daniel Axtens <dja@axtens.net>
    bnx2x: disable GSO where gso_size is too big for hardware

Daniel Axtens <dja@axtens.net>
    net: create skb_gso_validate_mac_len()

Todd Kjos <tkjos@android.com>
    binder: replace "%p" with "%pK"

Ben Hutchings <ben.hutchings@codethink.co.uk>
    binder: Replace "%p" with "%pK" for stable

Roberto Bergantinos Corpas <rbergant@redhat.com>
    CIFS: cifs_read_allocate_pages: don't iterate through whole page array on ENOMEM

Zhenliang Wei <weizhenliang@huawei.com>
    kernel/signal.c: trace_signal_deliver when signal_group_exit

Jiri Slaby <jslaby@suse.cz>
    memcg: make it work on sparse non-0-node systems

Joe Burmeister <joe.burmeister@devtank.co.uk>
    tty: max310x: Fix external crystal register setup

Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
    tty: serial: msm_serial: Fix XON/XOFF

Lyude Paul <lyude@redhat.com>
    drm/nouveau/i2c: Disable i2c bus access after ->fini()

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Set default power save node to 0

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race updating log root item during fsync

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: fix to prevent port_remove with pure auto scan LUNs (only sdevs)

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: fix missing zfcp_port reference put on -EBUSY from port_remove

Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
    media: smsusb: better handle optional alignment

Alan Stern <stern@rowland.harvard.edu>
    media: usb: siano: Fix false-positive "uninitialized variable" warning

Alan Stern <stern@rowland.harvard.edu>
    media: usb: siano: Fix general protection fault in smsusb

Oliver Neukum <oneukum@suse.com>
    USB: rio500: fix memory leak in close after disconnect

Oliver Neukum <oneukum@suse.com>
    USB: rio500: refuse more than one device at a time

Maximilian Luz <luzmaximilian@gmail.com>
    USB: Add LPM quirk for Surface Dock GigE adapter

Oliver Neukum <oneukum@suse.com>
    USB: sisusbvga: fix oops in error path of sisusb_probe

Alan Stern <stern@rowland.harvard.edu>
    USB: Fix slab-out-of-bounds write in usb_get_bos_descriptor

Carsten Schmid <carsten_schmid@mentor.com>
    usb: xhci: avoid null pointer deref when bos field is NULL

Andrey Smirnov <andrew.smirnov@gmail.com>
    xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    include/linux/bitops.h: sanitize rotate primitives

James Clarke <jrtc27@jrtc27.com>
    sparc64: Fix regression in non-hypervisor TLB flush xcall

Junwei Hu <hujunwei4@huawei.com>
    tipc: fix modprobe tipc failed after switch order of device registration -v2

David S. Miller <davem@davemloft.net>
    Revert "tipc: fix modprobe tipc failed after switch order of device registration"

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/pciback: Don't disable PCI_COMMAND on PCI device reset.

Daniel Axtens <dja@axtens.net>
    crypto: vmx - ghash: do nosimd fallback manually

Antoine Tenart <antoine.tenart@bootlin.com>
    net: mvpp2: fix bad MVPP2_TXQ_SCHED_TOKEN_CNTR_REG queue value

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix aggregation buffer leak under OOM condition.

Chris Packham <chris.packham@alliedtelesis.co.nz>
    tipc: Avoid copying bytes beyond the supplied data

Kloetzke Jan <Jan.Kloetzke@preh.de>
    usbnet: fix kernel crash after disconnect

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    net: stmmac: fix reset gpio free missing

Eric Dumazet <edumazet@google.com>
    net-gro: fix use-after-free read in napi_gro_frags()

Eric Dumazet <edumazet@google.com>
    llc: fix skb leak in llc_build_and_send_ui_pkt()

Mike Manning <mmanning@vyatta.att-mail.com>
    ipv6: Consider sk_bound_dev_if when binding a raw socket to an address

Arnd Bergmann <arnd@arndb.de>
    ASoC: davinci-mcasp: Fix clang warning without CONFIG_PM

Chris Lesiak <chris.lesiak@licor.com>
    spi: Fix zero length xfer bug

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: rspi: Fix sequencer reset during initialization

Aditya Pakki <pakki001@umn.edu>
    spi : spi-topcliff-pch: Fix to handle empty DMA buffers

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix SLI3 commands being issued on SLI4 devices

Arnd Bergmann <arnd@arndb.de>
    media: saa7146: avoid high stack usage with clang

Arnd Bergmann <arnd@arndb.de>
    media: go7007: avoid clang frame overflow warning with KASAN

James Hutchinson <jahutchinson99@googlemail.com>
    media: m88ds3103: serialize reset messages in m88ds3103_set_frontend

Arnd Bergmann <arnd@arndb.de>
    scsi: qla4xxx: avoid freeing unallocated dma memory

Tony Lindgren <tony@atomide.com>
    usb: core: Add PM runtime calls to usb_hcd_platform_shutdown

Paul E. McKenney <paulmck@linux.ibm.com>
    rcutorture: Fix cleanup path for invalid torture_type strings

Kangjie Lu <kjlu@umn.edu>
    tty: ipwireless: fix missing checks for ioremap

Pankaj Gupta <pagupta@redhat.com>
    virtio_console: initialize vtermno value for ports

Dan Carpenter <dan.carpenter@oracle.com>
    media: wl128x: prevent two potential buffer overflows

Sowjanya Komatineni <skomatineni@nvidia.com>
    spi: tegra114: reset controller on probe

Gustavo A. R. Silva <gustavo@embeddedor.com>
    cxgb3/l2t: Fix undefined behaviour

Wen Yang <wen.yang99@zte.com.cn>
    ASoC: fsl_utils: fix a leaked reference by adding missing of_node_put

Wen Yang <wen.yang99@zte.com.cn>
    ASoC: eukrea-tlv320: fix a leaked reference by adding missing of_node_put

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    HID: core: move Usage Page concatenation to Main item

Chengguang Xu <cgxu519@gmx.com>
    chardev: add additional check for minor range overlap

Peter Zijlstra <peterz@infradead.org>
    x86/ia32: Fix ia32_restore_sigcontext() AC leak

Wen Yang <wen.yang99@zte.com.cn>
    arm64: cpu_ops: fix a leaked reference by adding missing of_node_put

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Avoid configuring regulator with undefined voltage range

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Fix regulator load and icc-level configuration

Piotr Figiel <p.figiel@camlintechnologies.com>
    brcmfmac: fix race during disconnect when USB completion is in progress

Piotr Figiel <p.figiel@camlintechnologies.com>
    brcmfmac: convert dev_init_lock mutex to completion

Arnd Bergmann <arnd@arndb.de>
    b43: shut up clang -Wuninitialized variable warning

Kangjie Lu <kjlu@umn.edu>
    brcmfmac: fix missing checks for kmemdup

Kangjie Lu <kjlu@umn.edu>
    rtlwifi: fix a potential NULL pointer dereference

Nathan Chancellor <natechancellor@gmail.com>
    iio: common: ssp_sensors: Initialize calculated_time in ssp_common_process_data

Kangjie Lu <kjlu@umn.edu>
    iio: hmc5843: fix potential NULL pointer dereferences

Lars-Peter Clausen <lars@metafoo.de>
    iio: ad_sigma_delta: Properly handle SPI bus locking vs CS assertion

Kees Cook <keescook@chromium.org>
    x86/build: Keep local relocations with ld.lld

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq: pmac32: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq/pasemi: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq: ppc_cbe: fix possible object reference leak

Arnd Bergmann <arnd@arndb.de>
    s390: cio: fix cio_irb declaration

Charles Keepax <ckeepax@opensource.cirrus.com>
    extcon: arizona: Disable mic detect if running when driver is removed

Ulf Hansson <ulf.hansson@linaro.org>
    PM / core: Propagate dev->power.wakeup_path when no callbacks

Yinbo Zhu <yinbo.zhu@nxp.com>
    mmc: sdhci-of-esdhc: add erratum eSDHC-A001 and A-008358 support

Yinbo Zhu <yinbo.zhu@nxp.com>
    mmc: sdhci-of-esdhc: add erratum eSDHC5 support

Kangjie Lu <kjlu@umn.edu>
    mmc_spi: add a status check for spi_sync_locked

John Garry <john.garry@huawei.com>
    scsi: libsas: Do discovery on empty PHY to update PHY info

Guenter Roeck <linux@roeck-us.net>
    hwmon: (f71805f) Use request_muxed_region for Super-IO accesses

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pc87427) Use request_muxed_region for Super-IO accesses

Guenter Roeck <linux@roeck-us.net>
    hwmon: (smsc47b397) Use request_muxed_region for Super-IO accesses

Guenter Roeck <linux@roeck-us.net>
    hwmon: (smsc47m1) Use request_muxed_region for Super-IO accesses

Guenter Roeck <linux@roeck-us.net>
    hwmon: (vt1211) Use request_muxed_region for Super-IO accesses

Colin Ian King <colin.king@canonical.com>
    RDMA/cxgb4: Fix null pointer dereference on alloc_skb failure

Nicholas Nunley <nicholas.d.nunley@intel.com>
    i40e: don't allow changes to HW VLAN stripping on active port VLANs

Thomas Gleixner <tglx@linutronix.de>
    x86/irq/64: Limit IST stack overflow check to #DB stack

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Don't unbind interfaces following device reset failure

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    sched/core: Handle overflow in cpu_shares_write_u64

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    sched/core: Check quota and period overflow at usec to nsec conversion

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/numa: improve control of topology updates

Dan Carpenter <dan.carpenter@oracle.com>
    media: pvrusb2: Prevent a buffer overflow

Shuah Khan <shuah@kernel.org>
    media: au0828: Fix NULL pointer dereference in au0828_analog_stream_enable()

Wenwen Wang <wang6495@umn.edu>
    audit: fix a memory leak bug

Akinobu Mita <akinobu.mita@gmail.com>
    media: ov2659: make S_FMT succeed even if requested format doesn't match

Hans Verkuil <hverkuil@xs4all.nl>
    media: au0828: stop video streaming only when last user stops

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Move v4l2_clk_get() to ov6650_video_probe() helper

Philipp Zabel <p.zabel@pengutronix.de>
    media: coda: clear error return value before picture run

Nicolas Ferre <nicolas.ferre@microchip.com>
    dmaengine: at_xdmac: remove BUG_ON macro in tasklet

Wen Yang <wen.yang99@zte.com.cn>
    pinctrl: pistachio: fix leaked of_node references

Hans de Goede <hdegoede@redhat.com>
    HID: logitech-hidpp: use RAP instead of FAP to get the protocol version

Peter Zijlstra <peterz@infradead.org>
    mm/uaccess: Use 'unsigned long' to placate UBSAN warnings on older GCC versions

Jiri Kosina <jkosina@suse.cz>
    x86/mm: Remove in_nmi() warning from 64-bit implementation of vmalloc_fault()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    smpboot: Place the __percpu annotation correctly

Kees Cook <keescook@chromium.org>
    x86/build: Move _etext to actual end of .text

Arnd Bergmann <arnd@arndb.de>
    bcache: avoid clang -Wunintialized warning

Coly Li <colyli@suse.de>
    bcache: add failure check to run_cache_set() for journal replay

Tang Junhui <tang.junhui.linux@gmail.com>
    bcache: fix failure in journal relplay

Coly Li <colyli@suse.de>
    bcache: return error immediately in bch_journal_replay()

Kangjie Lu <kjlu@umn.edu>
    net: cw1200: fix a NULL pointer dereference

Dan Carpenter <dan.carpenter@oracle.com>
    mwifiex: prevent an array overflow

Daniel Baluta <daniel.baluta@nxp.com>
    ASoC: fsl_sai: Update is_slave_mode with correct value

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    mac80211/cfg80211: update bss channel on channel switch

Sugar Zhang <sugar.zhang@rock-chips.com>
    dmaengine: pl330: _stop: clear interrupt status

Mariusz Bialonczyk <manio@skyboo.net>
    w1: fix the resume command API

Sven Van Asbroeck <thesven73@gmail.com>
    rtc: 88pm860x: prevent use-after-free on device remove

Dan Carpenter <dan.carpenter@oracle.com>
    brcm80211: potential NULL dereference in brcmf_cfg80211_vndr_cmds_dcmd_handler()

Flavio Suligoi <f.suligoi@asem.it>
    spi: pxa2xx: fix SCR (divisor) calculation

Arnd Bergmann <arnd@arndb.de>
    ASoC: imx: fix fiq dependencies

Bo YU <tsu.yubo@gmail.com>
    powerpc/boot: Fix missing check of lseek() return value

Raul E Rangel <rrangel@chromium.org>
    mmc: core: Verify SD bus width

YueHaibing <yuehaibing@huawei.com>
    cxgb4: Fix error path in cxgb4_init_module

Ross Lagerwall <ross.lagerwall@citrix.com>
    gfs2: Fix lru_count going negative

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools include: Adopt linux/bits.h

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: No need to include bitops.h in util.h

YueHaibing <yuehaibing@huawei.com>
    at76c50x-usb: Don't register led_trigger if usb_register_driver failed

YueHaibing <yuehaibing@huawei.com>
    ssb: Fix possible NULL pointer dereference in ssb_host_pcmcia_exit

Alexander Potapenko <glider@google.com>
    media: vivid: use vfree() instead of kfree() for dev->bitmap_cap

YueHaibing <yuehaibing@huawei.com>
    media: cpia2: Fix use-after-free in cpia2_exit

Jiufei Xue <jiufei.xue@linux.alibaba.com>
    fbdev: fix WARNING in __alloc_pages_nodemask bug

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: use same fault hash key for shared and private mappings

Shile Zhang <shile.zhang@linux.alibaba.com>
    fbdev: fix divide error in fb_var_to_videomode

Tobin C. Harding <tobin@kernel.org>
    btrfs: sysfs: don't leak memory when failing add fsid

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race between ranged fsync and writeback of adjacent ranges

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix sign extension bug in gfs2_update_stats

Daniel Axtens <dja@axtens.net>
    crypto: vmx - CTR: always increment IV as quadword

Martin K. Petersen <martin.petersen@oracle.com>
    Revert "scsi: sd: Keep disk read-only when re-reading partition"

Andrea Parri <andrea.parri@amarulasolutions.com>
    bio: fix improper use of smp_mb__before_atomic()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix return value for reserved EFER

Jan Kara <jack@suse.cz>
    ext4: do not delete unlinked inode from orphan list on failed truncate

Yifeng Li <tomli@tomli.me>
    fbdev: sm712fb: fix memory frequency by avoiding a switch/case fallthrough

Nikolay Borisov <nborisov@suse.com>
    btrfs: Honour FITRIM range constraints during free space trim

Nigel Croxon <ncroxon@redhat.com>
    md/raid: raid5 preserve the writeback action after the parity check

Song Liu <songliubraving@fb.com>
    Revert "Don't jump to compute_result state from check_result state"

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf bench numa: Add define for RUSAGE_THREAD if not present

Al Viro <viro@zeniv.linux.org.uk>
    ufs: fix braino in ufs_get_inode_gid() for solaris UFS flavour

Andrey Smirnov <andrew.smirnov@gmail.com>
    power: supply: sysfs: prevent endless uevent loop with CONFIG_POWER_SUPPLY_DEBUG

Andrew Jones <drjones@redhat.com>
    KVM: arm/arm64: Ensure vcpu target is unset on reset failure

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm4: Fix uninitialized memory read in _decode_session4

Jeremy Sowden <jeremy@azazel.net>
    vti4: ipip tunnel deregistration fixes.

Su Yanjun <suyj.fnst@cn.fujitsu.com>
    xfrm6_tunnel: Fix potential panic when unloading xfrm6_tunnel module

YueHaibing <yuehaibing@huawei.com>
    xfrm: policy: Fix out-of-bound array accesses in __xfrm_policy_unlink

Mikulas Patocka <mpatocka@redhat.com>
    dm delay: fix a crash when invalid device is specified

James Prestwood <james.prestwood@linux.intel.com>
    PCI: Mark Atheros AR9462 to avoid bus reset

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

Jeff Layton <jlayton@kernel.org>
    ceph: flush dirty inodes before proceeding with remount

Dmitry Osipenko <digetx@gmail.com>
    iommu/tegra-smmu: Fix invalid ASID bits on Tegra30/114

Liu Bo <bo.liu@linux.alibaba.com>
    fuse: honor RLIMIT_FSIZE in fuse_file_fallocate

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix writepages on 32bit

Dmitry Osipenko <digetx@gmail.com>
    clk: tegra: Fix PLLM programming on Tegra124+ when PMC overrides divider

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    NFS4: Fix v4.0 client state corruption when mount

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix sensor possibly not detected on probe

Christoph Probst <kernel@probst.it>
    cifs: fix strcat buffer overflow and reduce raciness in smb21_set_oplock_level()

Phong Tran <tranmanphong@gmail.com>
    of: fix clang -Wunsequenced for be32_to_cpu()

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: msu: Fix single mode with IOMMU

Yufen Yu <yuyufen@huawei.com>
    md: add mddev->pers to avoid potential NULL pointer dereference

Tingwei Zhang <tingwei@codeaurora.org>
    stm class: Fix channel free in stm output free path

Junwei Hu <hujunwei4@huawei.com>
    tipc: fix modprobe tipc failed after switch order of device registration

Junwei Hu <hujunwei4@huawei.com>
    tipc: switch order of device registration to fix a crash

YueHaibing <yuehaibing@huawei.com>
    ppp: deflate: Fix possible crash in deflate_init

Yunjian Wang <wangyunjian@huawei.com>
    net/mlx4_core: Change the error print to info print

Eric Dumazet <edumazet@google.com>
    net: avoid weird emergency message

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes

Michał Wadowski <wadosm@gmail.com>
    ALSA: hda/realtek - Fix for Lenovo B50-70 inverted internal microphone bug

Sriram Rajagopalan <sriramr@arista.com>
    ext4: zero out the unused memory region in the extent tree block

Jiufei Xue <jiufei.xue@linux.alibaba.com>
    fs/writeback.c: use rcu_barrier() to wait for inflight wb switches going into workqueue when umount

Tejun Heo <tj@kernel.org>
    writeback: synchronize sync(2) against cgroup writeback membership switches

Eric Biggers <ebiggers@google.com>
    crypto: arm/aes-neonbs - don't access already-freed walk.iv

Eric Biggers <ebiggers@google.com>
    crypto: salsa20 - don't access already-freed walk.iv

Eric Biggers <ebiggers@google.com>
    crypto: chacha20poly1305 - set cra_name correctly

Eric Biggers <ebiggers@google.com>
    crypto: gcm - fix incompatibility between "gcm" and "gcm_base"

Wei Yongjun <weiyongjun1@huawei.com>
    crypto: gcm - Fix error return code in crypto_gcm_create_common()

Kamlakant Patel <kamlakantp@marvell.com>
    ipmi:ssif: compare block number correctly for multi-part return messages

Coly Li <colyli@suse.de>
    bcache: never set KEY_PTRS of journal key to 0 in journal_reclaim()

Liang Chen <liangchen.linux@gmail.com>
    bcache: fix a race between cache register and cacheset unregister

Filipe Manana <fdmanana@suse.com>
    Btrfs: do not start a transaction at iterate_extent_inodes()

Debabrata Banerjee <dbanerje@akamai.com>
    ext4: fix ext4_show_options for file systems w/o journal

Kirill Tkhai <ktkhai@virtuozzo.com>
    ext4: actually request zeroing of inode table after grow

Sergei Trofimovich <slyfox@gentoo.org>
    tty/vt: fix write/write race in ioctl(KDSKBSENT) handler

Steve Twiss <stwiss.opensource@diasemi.com>
    mfd: da9063: Fix OTP control register names to match datasheets for DA9063/63L

Shuning Zhang <sunny.s.zhang@oracle.com>
    ocfs2: fix ocfs2 read inode data panic in ocfs2_iget

Jiri Kosina <jkosina@suse.cz>
    mm/mincore.c: make mincore() more conservative

Curtis Malainey <cujomalainey@chromium.org>
    ASoC: RT5677-SPI: Disable 16Bit SPI Transfers

Jon Hunter <jonathanh@nvidia.com>
    ASoC: max98090: Fix restore of DAPM Muxes

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - EAPD turn on later

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/hdmi - Consider eld_valid when reporting jack event

Wenwen Wang <wang6495@umn.edu>
    ALSA: usb-audio: Fix a memory leak bug

Eric Biggers <ebiggers@google.com>
    crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()

Eric Biggers <ebiggers@google.com>
    crypto: crct10dif-generic - fix use via crypto_shash_digest()

Daniel Axtens <dja@axtens.net>
    crypto: vmx - fix copy-paste error in CTR mode

Wen Yang <wen.yang99@zte.com.cn>
    ARM: exynos: Fix a leaked reference by adding missing of_node_put

Andy Lutomirski <luto@kernel.org>
    x86/speculation/mds: Improve CPU buffer clear documentation

Andy Lutomirski <luto@kernel.org>
    x86/speculation/mds: Revert CPU buffer clear on double fault exit


-------------

Diffstat:

 Documentation/x86/mds.rst                          |  44 +--
 Makefile                                           |   4 +-
 arch/arm/crypto/aesbs-glue.c                       |   4 +
 arch/arm/kvm/arm.c                                 |  11 +-
 arch/arm/mach-exynos/firmware.c                    |   1 +
 arch/arm/mach-exynos/suspend.c                     |   2 +
 arch/arm64/kernel/cpu_ops.c                        |   1 +
 arch/mips/pistachio/Platform                       |   1 +
 arch/powerpc/boot/addnote.c                        |   6 +-
 arch/powerpc/mm/numa.c                             |  18 +-
 arch/sparc/mm/ultra.S                              |   4 +-
 arch/x86/Makefile                                  |   2 +-
 arch/x86/crypto/crct10dif-pclmul_glue.c            |  13 +-
 arch/x86/ia32/ia32_signal.c                        |  29 +-
 arch/x86/kernel/irq_64.c                           |  19 +-
 arch/x86/kernel/traps.c                            |   8 -
 arch/x86/kvm/x86.c                                 |  31 +-
 arch/x86/mm/fault.c                                |   2 -
 crypto/chacha20poly1305.c                          |   4 +-
 crypto/crct10dif_generic.c                         |  11 +-
 crypto/gcm.c                                       |  36 +-
 crypto/salsa20_generic.c                           |   2 +-
 drivers/android/binder.c                           |  36 +-
 drivers/base/power/main.c                          |   4 +
 drivers/char/ipmi/ipmi_ssif.c                      |   6 +-
 drivers/char/virtio_console.c                      |   3 +-
 drivers/clk/tegra/clk-pll.c                        |   4 +-
 drivers/cpufreq/pasemi-cpufreq.c                   |   1 +
 drivers/cpufreq/pmac32-cpufreq.c                   |   2 +
 drivers/cpufreq/ppc_cbe_cpufreq.c                  |   1 +
 drivers/crypto/vmx/aesp8-ppc.pl                    |   6 +-
 drivers/crypto/vmx/ghash.c                         | 218 +++++--------
 drivers/dma/at_xdmac.c                             |   6 +-
 drivers/dma/pl330.c                                |  10 +-
 drivers/extcon/extcon-arizona.c                    |  10 +
 drivers/gpu/drm/gma500/cdv_intel_lvds.c            |   3 +
 drivers/gpu/drm/gma500/intel_bios.c                |   3 +
 drivers/gpu/drm/gma500/psb_drv.h                   |   1 +
 drivers/gpu/drm/nouveau/include/nvkm/subdev/i2c.h  |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c      |  26 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.h      |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c     |  15 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.c      |  21 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.h      |   1 +
 drivers/hid/hid-core.c                             |  36 +-
 drivers/hid/hid-logitech-hidpp.c                   |  17 +-
 drivers/hwmon/f71805f.c                            |  15 +-
 drivers/hwmon/pc87427.c                            |  14 +-
 drivers/hwmon/smsc47b397.c                         |  13 +-
 drivers/hwmon/smsc47m1.c                           |  28 +-
 drivers/hwmon/vt1211.c                             |  15 +-
 drivers/hwtracing/intel_th/msu.c                   |  35 +-
 drivers/hwtracing/stm/core.c                       |   2 +-
 drivers/iio/adc/ad_sigma_delta.c                   |  16 +-
 drivers/iio/common/ssp_sensors/ssp_iio.c           |   2 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   2 +
 drivers/iommu/tegra-smmu.c                         |  25 +-
 drivers/md/bcache/alloc.c                          |   5 +-
 drivers/md/bcache/journal.c                        |  37 ++-
 drivers/md/bcache/super.c                          |  19 +-
 drivers/md/dm-delay.c                              |   3 +-
 drivers/md/md.c                                    |   6 +-
 drivers/md/raid5.c                                 |  29 +-
 drivers/media/dvb-frontends/m88ds3103.c            |   9 +-
 drivers/media/i2c/ov2659.c                         |   6 +-
 drivers/media/i2c/soc_camera/ov6650.c              |  27 +-
 drivers/media/pci/saa7146/hexium_gemini.c          |   5 +-
 drivers/media/pci/saa7146/hexium_orion.c           |   5 +-
 drivers/media/platform/coda/coda-bit.c             |   3 +
 drivers/media/platform/vivid/vivid-vid-cap.c       |   2 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |   7 +-
 drivers/media/usb/au0828/au0828-video.c            |  16 +-
 drivers/media/usb/cpia2/cpia2_v4l.c                |   3 +-
 drivers/media/usb/go7007/go7007-fw.c               |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   2 +
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h            |   1 +
 drivers/media/usb/siano/smsusb.c                   |  33 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   2 +-
 drivers/memory/tegra/mc.c                          |   2 +-
 drivers/misc/genwqe/card_dev.c                     |   2 +
 drivers/misc/genwqe/card_utils.c                   |   4 +
 drivers/mmc/core/sd.c                              |   8 +
 drivers/mmc/host/mmc_spi.c                         |   4 +
 drivers/mmc/host/sdhci-of-esdhc.c                  |   5 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  18 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   2 +
 drivers/net/ethernet/chelsio/cxgb3/l2t.h           |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  15 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   8 +
 drivers/net/ethernet/marvell/mvpp2.c               |  10 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |   2 +-
 drivers/net/ethernet/mellanox/mlx4/port.c          |   5 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |   3 +-
 drivers/net/ppp/ppp_deflate.c                      |  20 +-
 drivers/net/usb/cdc_ncm.c                          |   4 +-
 drivers/net/usb/usbnet.c                           |   6 +
 drivers/net/wireless/at76c50x-usb.c                |   4 +-
 drivers/net/wireless/b43/phy_lp.c                  |   6 +-
 drivers/net/wireless/brcm80211/brcmfmac/bus.h      |   4 +-
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c |  23 +-
 drivers/net/wireless/brcm80211/brcmfmac/core.c     |  45 ++-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |  57 +---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |  82 ++++-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |  42 ++-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  10 +
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c     |  32 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |  29 +-
 drivers/net/wireless/brcm80211/brcmfmac/vendor.c   |   5 +-
 drivers/net/wireless/cw1200/main.c                 |   5 +
 drivers/net/wireless/mwifiex/cfp.c                 |   3 +
 drivers/net/wireless/realtek/rtlwifi/base.c        |   5 +
 drivers/parisc/ccio-dma.c                          |   4 +-
 drivers/parisc/sba_iommu.c                         |   3 +-
 drivers/pci/quirks.c                               |   1 +
 drivers/pinctrl/pinctrl-pistachio.c                |   2 +
 drivers/power/power_supply_sysfs.c                 |   6 -
 drivers/rtc/rtc-88pm860x.c                         |   2 +-
 drivers/s390/cio/cio.h                             |   2 +-
 drivers/s390/scsi/zfcp_ext.h                       |   1 +
 drivers/s390/scsi/zfcp_scsi.c                      |   9 +
 drivers/s390/scsi/zfcp_sysfs.c                     |  55 +++-
 drivers/s390/scsi/zfcp_unit.c                      |   8 +-
 drivers/scsi/libsas/sas_expander.c                 |   5 +
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  11 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +-
 drivers/scsi/sd.c                                  |   3 +-
 drivers/scsi/ufs/ufshcd.c                          |  28 +-
 drivers/spi/spi-pxa2xx.c                           |   8 +-
 drivers/spi/spi-rspi.c                             |   9 +-
 drivers/spi/spi-tegra114.c                         |  32 +-
 drivers/spi/spi-topcliff-pch.c                     |  15 +-
 drivers/spi/spi.c                                  |   2 +
 drivers/ssb/bridge_pcmcia_80211.c                  |   9 +-
 drivers/staging/iio/magnetometer/hmc5843_i2c.c     |   7 +-
 drivers/staging/iio/magnetometer/hmc5843_spi.c     |   7 +-
 drivers/tty/ipwireless/main.c                      |   8 +
 drivers/tty/serial/max310x.c                       |   2 +-
 drivers/tty/serial/msm_serial.c                    |   5 +-
 drivers/tty/vt/keyboard.c                          |  33 +-
 drivers/usb/core/config.c                          |   4 +-
 drivers/usb/core/hcd.c                             |   3 +
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/host/xhci.c                            |  24 +-
 drivers/usb/misc/rio500.c                          |  41 ++-
 drivers/usb/misc/sisusbvga/sisusb.c                |  15 +-
 drivers/video/fbdev/core/fbcmap.c                  |   2 +
 drivers/video/fbdev/core/modedb.c                  |   3 +
 drivers/video/fbdev/sm712.h                        |  12 +-
 drivers/video/fbdev/sm712fb.c                      | 243 +++++++++++---
 drivers/w1/w1_io.c                                 |   3 +-
 drivers/xen/xen-pciback/pciback_ops.c              |   2 -
 drivers/xen/xenbus/xenbus_dev_frontend.c           |   2 +-
 fs/btrfs/backref.c                                 |  18 +-
 fs/btrfs/extent-tree.c                             |  25 +-
 fs/btrfs/file.c                                    |  12 +
 fs/btrfs/sysfs.c                                   |   7 +-
 fs/btrfs/tree-log.c                                |   8 +-
 fs/ceph/super.c                                    |   7 +
 fs/char_dev.c                                      |   6 +
 fs/cifs/file.c                                     |   4 +-
 fs/cifs/smb2ops.c                                  |  14 +-
 fs/ext4/extents.c                                  |  17 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/ext4/ioctl.c                                    |   2 +-
 fs/ext4/super.c                                    |   2 +-
 fs/fs-writeback.c                                  |  51 ++-
 fs/fuse/file.c                                     |  13 +-
 fs/gfs2/glock.c                                    |  22 +-
 fs/gfs2/lock_dlm.c                                 |   9 +-
 fs/hugetlbfs/inode.c                               |   8 +-
 fs/nfs/nfs4state.c                                 |   4 +
 fs/ocfs2/export.c                                  |  30 +-
 fs/open.c                                          |  18 +
 fs/read_write.c                                    |   5 +-
 fs/ufs/util.h                                      |   2 +-
 fs/userfaultfd.c                                   |  41 ++-
 include/linux/backing-dev-defs.h                   |   1 +
 include/linux/bio.h                                |   2 +-
 include/linux/bitops.h                             |  16 +-
 include/linux/fs.h                                 |   4 +
 include/linux/hid.h                                |   1 +
 include/linux/hugetlb.h                            |   4 +-
 include/linux/iio/adc/ad_sigma_delta.h             |   1 +
 include/linux/list_lru.h                           |   1 +
 include/linux/mfd/da9063/registers.h               |   6 +-
 include/linux/of.h                                 |   4 +-
 include/linux/rcupdate.h                           |   6 +-
 include/linux/sched.h                              |   7 +-
 include/linux/skbuff.h                             |  30 ++
 include/linux/smpboot.h                            |   2 +-
 include/linux/usb/gadget.h                         |   4 +-
 include/uapi/linux/fuse.h                          |   2 +
 include/uapi/linux/tipc_config.h                   |  10 +-
 kernel/auditfilter.c                               |  12 +-
 kernel/rcu/rcutorture.c                            |   5 +
 kernel/sched/core.c                                |   9 +-
 kernel/signal.c                                    |   2 +
 kernel/trace/trace_events.c                        |   3 -
 lib/strncpy_from_user.c                            |   5 +-
 lib/strnlen_user.c                                 |   4 +-
 mm/backing-dev.c                                   |   1 +
 mm/hugetlb.c                                       |  19 +-
 mm/list_lru.c                                      |   8 +-
 mm/mincore.c                                       |  23 +-
 net/core/dev.c                                     |   4 +-
 net/core/ethtool.c                                 |   5 +-
 net/core/neighbour.c                               |   9 +-
 net/core/pktgen.c                                  |  11 +
 net/ipv4/ip_vti.c                                  |   5 +-
 net/ipv4/xfrm4_policy.c                            |  24 +-
 net/ipv6/raw.c                                     |   2 +
 net/ipv6/xfrm6_tunnel.c                            |   4 +
 net/llc/llc_output.c                               |   2 +
 net/mac80211/mlme.c                                |   3 -
 net/rds/ib_rdma.c                                  |  10 +-
 net/sched/sch_tbf.c                                |  10 -
 net/tipc/core.c                                    |  32 +-
 net/tipc/subscr.c                                  |  14 +-
 net/tipc/subscr.h                                  |   5 +-
 net/wireless/nl80211.c                             |   5 +
 net/xfrm/xfrm_user.c                               |   2 +-
 scripts/coccinelle/api/stream_open.cocci           | 363 +++++++++++++++++++++
 sound/pci/hda/patch_hdmi.c                         |   6 +-
 sound/pci/hda/patch_realtek.c                      |   7 +-
 sound/soc/codecs/max98090.c                        |  12 +-
 sound/soc/codecs/rt5677-spi.c                      |  35 +-
 sound/soc/davinci/davinci-mcasp.c                  |   2 +
 sound/soc/fsl/Kconfig                              |   9 +-
 sound/soc/fsl/eukrea-tlv320.c                      |   4 +-
 sound/soc/fsl/fsl_sai.c                            |   2 +
 sound/soc/fsl/fsl_utils.c                          |   1 +
 sound/usb/mixer.c                                  |   2 +
 tools/include/linux/bitops.h                       |   7 +-
 tools/include/linux/bits.h                         |  26 ++
 tools/perf/bench/numa.c                            |   4 +
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |  31 +-
 tools/perf/util/string.c                           |   1 +
 tools/perf/util/util.h                             |   1 -
 240 files changed, 2424 insertions(+), 950 deletions(-)


