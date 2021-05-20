Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EBE38AA64
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239413AbhETLND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:13:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239465AbhETLK6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:10:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56F6F61D3B;
        Thu, 20 May 2021 10:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505232;
        bh=LON9U8BWM1OE5RqcwVPAxkZt1HS9sp8P0iW1zzqdbU4=;
        h=From:To:Cc:Subject:Date:From;
        b=eyPc799TsNzAckSI907+SxYGxZB3BlbC3GvGkErQE78tji9M9aVJlZzqBLLELl5X9
         8NOzGBATSBBNNQa+5z3VmAmeHH1ZoAH1/qswDP0EyowXb73oTwLvIukIhRyHp9GkMH
         7ukL7iDHWelWMMU9wAWjmmJr2PsdwGwgRVJJPtuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 000/190] 4.4.269-rc1 review
Date:   Thu, 20 May 2021 11:21:04 +0200
Message-Id: <20210520092102.149300807@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.269-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.269-rc1
X-KernelTest-Deadline: 2021-05-22T09:21+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.269 release.
There are 190 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.269-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.269-rc1

Colin Ian King <colin.king@canonical.com>
    iio: tsl2583: Fix division by a zero lux_val

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    xhci: Do not use GFP_KERNEL in (potentially) atomic context

Eric Dumazet <edumazet@google.com>
    ipv6: remove extra dev_hold() for fallback tunnels

Eric Dumazet <edumazet@google.com>
    ip6_tunnel: sit: proper dev_{hold|put} in ndo_[un]init methods

Eric Dumazet <edumazet@google.com>
    sit: proper dev_{hold|put} in ndo_[un]init methods

Hui Wang <hui.wang@canonical.com>
    ALSA: hda: generic: change the DAC ctl name for LO+SPK or LO+HP

Johannes Berg <johannes.berg@intel.com>
    um: Mark all kernel symbols as local

Feilong Lin <linfeilong@huawei.com>
    ACPI / hotplug / PCI: Fix reference count leak in enable_slot()

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9058/1: cache-v7: refactor v7_invalidate_l1 to avoid clobbering r5/r6

Arnd Bergmann <arnd@arndb.de>
    isdn: capi: fix mismatched prototypes

Kaixu Xia <kaixuxia@tencent.com>
    cxgb4: Fix the -Wmisleading-indentation warning

Arnd Bergmann <arnd@arndb.de>
    usb: sl811-hcd: improve misleading indentation

Arnd Bergmann <arnd@arndb.de>
    kgdb: fix gcc-11 warning on indentation

Arnd Bergmann <arnd@arndb.de>
    x86/msr: Fix wr/rdmsr_safe_regs_on_cpu() prototypes

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kobject_uevent: remove warning in init_uevent_argv()

Mikulas Patocka <mpatocka@redhat.com>
    dm ioctl: fix out of bounds array access when no devices

Lukasz Luba <lukasz.luba@arm.com>
    thermal/core/fair share: Lock the thermal zone while looping over instances

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Avoid handcoded DIVU in `__div64_32' altogether

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Avoid DIVU in `__div64_32' is result would be zero

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Reinstate platform `__div64_32' handler

Maciej W. Rozycki <macro@orcam.me.uk>
    FDDI: defxx: Make MMIO the configuration default except for EISA

Thomas Gleixner <tglx@linutronix.de>
    KVM: x86: Cancel pvclock_gtod_work on module removal

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: core: hub: fix race condition about TRSMRCY of resume

Phil Elwell <phil@raspberrypi.com>
    usb: dwc2: Fix gadget DMA unmap direction

Maximilian Luz <luzmaximilian@gmail.com>
    usb: xhci: Increase timeout for HC halt

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: fotg210-hcd: Fix an error message

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: fix divide error in calculate_skip()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Fix crashes when toggling entry flush barrier

Vineet Gupta <vgupta@synopsys.com>
    ARC: entry: fix off-by-one error in syscall number validation

Jia-Ju Bai <baijiaju1990@gmail.com>
    kernel: kexec_file: fix error return code of kexec_calculate_store_digests()

Miaohe Lin <linmiaohe@huawei.com>
    ksm: fix potential missing rmap_item for stable_node

Kees Cook <keescook@chromium.org>
    drm/radeon: Fix off-by-one power_state index heap overwrite

Xin Long <lucien.xin@gmail.com>
    sctp: fix a SCTP_MIB_CURRESTAB leak in sctp_sf_do_dupcook_b

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.2 fix handling of sr_eof in SEEK's reply

Nikola Livic <nlivic@gmail.com>
    pNFS/flexfiles: fix incorrect size check in decode_nfs_fh()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Deal correctly with attribute generation counter overflow

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    PCI: Release OF node in pci_scan_device()'s error path

David Ward <david.ward@gatech.edu>
    ASoC: rt286: Make RT286_SET_GPIO_* readable and writable

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/iommu: Annotate nested lock for lockdep

Gustavo A. R. Silva <gustavoars@kernel.org>
    wl3501_cs: Fix out-of-bounds warnings in wl3501_mgmt_join

Gustavo A. R. Silva <gustavoars@kernel.org>
    wl3501_cs: Fix out-of-bounds warnings in wl3501_send_pkt

David Ward <david.ward@gatech.edu>
    ASoC: rt286: Generalize support for ALC3263 codec

Gustavo A. R. Silva <gustavoars@kernel.org>
    sctp: Fix out-of-bounds warning in sctp_process_asconf_param()

Mihai Moldovan <ionic@ionic.de>
    kconfig: nconf: stop endless search loops

Yonghong Song <yhs@fb.com>
    selftests: Set CC to clang in lib.mk if LLVM is set

Miklos Szeredi <mszeredi@redhat.com>
    cuse: prevent clone

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    mac80211: clear the beacon's CRC after channel switch

Eric Dumazet <edumazet@google.com>
    ip6_vti: proper dev_{hold|put} in ndo_[un]init methods

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Bluetooth: initialize skb_queue_head at l2cap_chan_create()

Archie Pusaka <apusaka@chromium.org>
    Bluetooth: Set CONF_NOT_COMPLETE as l2cap_chan default

Tong Zhang <ztong0001@gmail.com>
    ALSA: rme9652: don't disable if not enabled

Tong Zhang <ztong0001@gmail.com>
    ALSA: hdspm: don't disable if not enabled

Tong Zhang <ztong0001@gmail.com>
    ALSA: hdsp: don't disable if not enabled

Jonathan McDowell <noodles@earth.li>
    net: stmmac: Set FIFO sizes for ipq806x

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: convert dest node's address to network order

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix debugfs dump

Xin Long <lucien.xin@gmail.com>
    sctp: delay auto_asconf init until binding the first addr

Xin Long <lucien.xin@gmail.com>
    Revert "net/sctp: fix race condition in sctp_destroy_sock"

Dan Carpenter <dan.carpenter@oracle.com>
    kfifo: fix ternary sign extension bugs

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    net:nfc:digital: Fix a double free in digital_tg_recv_dep_req

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/52xx: Fix an invalid ASM expression ('addi' used instead of 'add')

Toke Høiland-Jørgensen <toke@redhat.com>
    ath9k: Fix error check in ath9k_hw_read_revisions() for PCI devices

Colin Ian King <colin.king@canonical.com>
    net: davinci_emac: Fix incorrect masking of tx and rx error channel

Stefano Garzarella <sgarzare@redhat.com>
    vsock/vmci: log once the failed queue pair allocation

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    mwl8k: Fix a double Free in mwl8k_probe_hw

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: sh7760: fix IRQ error path

Tyrel Datwyler <tyreld@linux.ibm.com>
    powerpc/pseries: extract host bridge from pci_bus prior to bus removal

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: sh7760: add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: jz4780: add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: cadence: add IRQ check

Colin Ian King <colin.king@canonical.com>
    net: thunderx: Fix unintentional sign extension issue

Colin Ian King <colin.king@canonical.com>
    mt7601u: fix always true expression

Johannes Berg <johannes.berg@intel.com>
    mac80211: bail out if cipher schemes are invalid

Randy Dunlap <rdunlap@infradead.org>
    powerpc: iommu: fix build when neither PCI or IBMVIO is set

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add error checks for usb_driver_claim_interface() calls

Dan Carpenter <dan.carpenter@oracle.com>
    nfc: pn533: prevent potential memory corruption

Jia Zhou <zhou.jia2@zte.com.cn>
    ALSA: core: remove redundant spin_lock pair in snd_card_disconnect

Nathan Chancellor <nathan@kernel.org>
    powerpc/prom: Mark identical_pvr_fixup as __init

Xie He <xie.he.0141@gmail.com>
    net: lapbether: Prevent racing when checking whether the netif is running

Maxim Mikityanskiy <maxtram95@gmail.com>
    HID: plantronics: Workaround for double volume key presses

Nathan Chancellor <nathan@kernel.org>
    x86/events/amd/iommu: Fix sysfs type mismatch

Dan Carpenter <dan.carpenter@oracle.com>
    HSI: core: fix resource leaks in hsi_add_client_from_dt()

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    scsi: sni_53c710: Add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    scsi: sun3x_esp: Add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    scsi: jazz_esp: Add IRQ check

Arnd Bergmann <arnd@arndb.de>
    media: dvb-usb-remote: fix dvb_usb_nec_rc_key_to_event type mismatch

Arnd Bergmann <arnd@arndb.de>
    scsi: fcoe: Fix mismatched fcoe_wwn_from_mac declaration

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    ata: libahci_platform: fix IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    sata_mv: add IRQ checks

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    pata_ipx4xx_cf: fix IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    pata_arasan_cf: fix IRQ check

Colin Ian King <colin.king@canonical.com>
    media: m88rs6000t: avoid potential out-of-bounds reads on arrays

Yang Yingliang <yangyingliang@huawei.com>
    media: omap4iss: return error code when omap4iss_get() failed

Colin Ian King <colin.king@canonical.com>
    media: vivid: fix assignment of dev->fbuf_out_flags

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    ttyprintk: Add TTY hangup callback.

Johan Hovold <johan@kernel.org>
    tty: fix return value for unsupported ioctls

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix unprivileged TIOCCSERIAL

Colin Ian King <colin.king@canonical.com>
    usb: gadget: r8a66597: Add missing null check on return from platform_get_resource

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    crypto: qat - Fix a double free in adf_create_ring

Colin Ian King <colin.king@canonical.com>
    staging: rtl8192u: Fix potential infinite loop

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix error path in adf_isr_resource_alloc()

Michael Walle <michael@walle.cc>
    mtd: require write permissions for locking and badblock ioctls

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Complete OUT requests on short packets

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Don't DMA more than the buffer can take

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Mask GRP2 interrupts we don't handle

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Remove a dubious condition leading to fotg210_done

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Fix EP0 IN requests bigger than two packets

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Fix DMA on EP0 for length > max packet size

Tong Zhang <ztong0001@gmail.com>
    crypto: qat - don't release uninitialized resources

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Check for DMA mapping error

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Check if driver is present before calling ->setup()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Replace cpu_to_le32() by lower_32_bits()

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Snow

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on SMDK5250

Colin Ian King <colin.king@canonical.com>
    memory: gpmc: fix out of bounds read and dereference on gpmc_cs[]

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Revert d3cb25a12138 completely

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: split kvm_s390_real_to_abs

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Remove redundant entry for ALC861 Haier/Uniwill devices

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 Sony quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC882 Sony quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC882 Acer quirk table entries

Colin Ian King <colin.king@canonical.com>
    drm/radeon: fix copy of uninitialized variable back to userspace

Johannes Berg <johannes.berg@intel.com>
    cfg80211: scan: drop entry from hidden_list on overflow

Dan Carpenter <dan.carpenter@oracle.com>
    ipw2x00: potential buffer overflow in libipw_wx_set_encodeext()

Zhao Heming <heming.zhao@suse.com>
    md: md_open returns -EBUSY when entering racing area

Christoph Hellwig <hch@lst.de>
    md: factor out a mddev_find_locked helper from mddev_find

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Restructure trace_clock_global() to never block

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Map all PIDs to command lines

Joel Fernandes <joelaf@google.com>
    tracing: Treat recording comm for idle task as a success

Amey Telawane <ameyt@codeaurora.org>
    tracing: Use strlcpy() instead of strcpy() in __trace_find_cmdline()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    misc: vmw_vmci: explicitly initialize vmci_datagram payload

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    misc: vmw_vmci: explicitly initialize vmci_notify_bm_set_msg struct

Hans de Goede <hdegoede@redhat.com>
    misc: lis3lv02d: Fix false-positive WARN on various HP models

Maciej W. Rozycki <macro@orcam.me.uk>
    FDDI: defxx: Bail out gracefully with unassigned PCI resource for CSR

Or Cohen <orcohen@paloaltonetworks.com>
    net/nfc: fix use-after-free llcp_sock_bind/connect

Taehee Yoo <ap420073@gmail.com>
    hsr: use netdev_err() instead of WARN_ONCE()

Archie Pusaka <apusaka@chromium.org>
    Bluetooth: verify AMP hci_chan before amp_destroy

Joe Thornber <ejt@redhat.com>
    dm space map common: fix division bug in sm_ll_find_free_block()

Joe Thornber <ejt@redhat.com>
    dm persistent data: packed struct should have an aligned() attribute too

Dean Anderson <dean@sensoray.com>
    usb: gadget/function/f_fs string table fix for multiple languages

Anirudh Rayabharam <mail@anirudhrb.com>
    usb: gadget: dummy_hcd: fix gpf in gadget_setup

Fengnan Chang <changfengnan@vivo.com>
    ext4: fix error code in ext4_commit_super

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix check to prevent false positive report of incorrect used inodes

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Handle commands when closing set_ftrace_filter file

Yang Yang <yang.yang29@zte.com.cn>
    jffs2: check the validity of dstlen in jffs2_zlib_compress()

Tony Ambardar <tony.ambardar@gmail.com>
    powerpc: fix EDEADLOCK redefinition error in uapi/asm/errno.h

Mahesh Salgaonkar <mahesh@linux.ibm.com>
    powerpc/eeh: Fix EEH handling for hugepages in ioremap space.

lizhe <lizhe67@huawei.com>
    jffs2: Fix kasan slab-out-of-bounds problem

Davide Caratti <dcaratti@redhat.com>
    openvswitch: fix stack OOB read while fragmenting IPv4 packets

Bill Wendling <morbo@google.com>
    arm64/vdso: Discard .note.gnu.property sections in vDSO

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    ALSA: sb: Fix two use after free in snd_sb_qsound_build

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    ALSA: emu8000: Fix a use after free in snd_emu8000_create_mixer

Bart Van Assche <bvanassche@acm.org>
    scsi: libfc: Fix a format specifier

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix crash when a REG_RPI mailbox fails triggering a LOGO response

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: fix NULL pointer dereference

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/mdp5: Configure PP_SYNC_HEIGHT to double the vtotal

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: gscpa/stv06xx: fix memory leak

Pavel Skripkin <paskripkin@gmail.com>
    media: dvb-usb: fix memory leak in dvb_usb_adapter_init

Yang Yingliang <yangyingliang@huawei.com>
    media: i2c: adv7511-v4l2: fix possible use-after-free in adv7511_remove()

Yang Yingliang <yangyingliang@huawei.com>
    power: supply: s3c_adc_battery: fix possible use-after-free in s3c_adc_bat_remove()

Yang Yingliang <yangyingliang@huawei.com>
    power: supply: generic-adc-battery: fix possible use-after-free in gab_remove()

Colin Ian King <colin.king@canonical.com>
    clk: socfpga: arria10: Fix memory leak of socfpga_clk on error return

Muhammad Usama Anjum <musamaanjum@gmail.com>
    media: em28xx: fix memory leak

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: gspca/sq905.c: fix uninitialized variable

Daniel Niv <danielniv3@gmail.com>
    media: media/saa7164: fix saa7164_encoder_register() memory leak bugs

Sean Young <sean@mess.org>
    media: ite-cir: check for receive overflow

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    scsi: target: pscsi: Fix warning in pscsi_complete_cmd()

Josef Bacik <josef@toxicpanda.com>
    btrfs: convert logic BUG_ON()'s in replace_path to ASSERT()'s

Yang Yingliang <yangyingliang@huawei.com>
    phy: phy-twl4030-usb: Fix possible use-after-free in twl4030_usb_remove()

Pavel Machek <pavel@ucw.cz>
    intel_th: Consistency and off-by-one fix

Wei Yongjun <weiyongjun1@huawei.com>
    spi: omap-100k: Fix reference leak to master

Wei Yongjun <weiyongjun1@huawei.com>
    spi: dln2: Fix reference leak to master

John Millikin <john@john-millikin.com>
    x86/build: Propagate $(CLANG_FLAGS) to $(REALMODE_FLAGS)

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Do not read power state in pci_enable_device_flags()

Pawel Laszczak <pawell@cadence.com>
    usb: gadget: uvc: add bInterval checking for HS mode

karthik alapati <mail@karthek.com>
    staging: wimax/i2400m: fix byte-order issue

Phillip Potter <phil@philpotter.co.uk>
    fbdev: zero-fill colormap in fbcmap.c

Seunghui Lee <sh043.lee@samsung.com>
    mmc: core: Set read only for SD cards with permanent write protect bit

DooHyun Hwang <dh0421.hwang@samsung.com>
    mmc: core: Do a power cycle when the CMD11 fails

Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
    ecryptfs: fix kernel panic with null dev_name

Mark Langsdorf <mlangsdo@redhat.com>
    ACPI: custom_method: fix a possible memory leak

Mark Langsdorf <mlangsdo@redhat.com>
    ACPI: custom_method: fix potential use-after-free issue

Vasily Gorbik <gor@linux.ibm.com>
    s390/disassembler: increase ebpf disasm buffer size

Mark Pearson <markpearson@lenovo.com>
    platform/x86: thinkpad_acpi: Correct thermal sensor allocation

Chris Chiu <chris.chiu@canonical.com>
    USB: Add reset-resume quirk for WD19's Realtek Hub

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: Add LPM quirk for Lenovo ThinkPad USB-C Dock Gen2 Ethernet

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add MIDI quirk for Vox ToneLab EX

Jiri Kosina <jkosina@suse.cz>
    iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_enqueue_hcmd()

Phillip Potter <phil@philpotter.co.uk>
    net: usb: ax88179_178a: initialize local variables before use

Eric Caruso <ejcaruso@google.com>
    timerfd: Reject ALARM timerfds without CAP_WAKE_ALARM


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arc/kernel/entry.S                            |  4 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |  2 +-
 arch/arm/boot/dts/exynos5250-snow-common.dtsi      |  2 +-
 arch/arm/mm/cache-v7.S                             | 51 +++++++++---------
 arch/arm64/kernel/vdso/vdso.lds.S                  |  8 ++-
 arch/mips/include/asm/div64.h                      | 55 ++++++++++++++------
 arch/powerpc/Kconfig.debug                         |  1 +
 arch/powerpc/include/uapi/asm/errno.h              |  1 +
 arch/powerpc/kernel/eeh.c                          | 11 ++--
 arch/powerpc/kernel/iommu.c                        |  4 +-
 arch/powerpc/kernel/prom.c                         |  2 +-
 arch/powerpc/lib/feature-fixups.c                  | 17 +++++-
 arch/powerpc/platforms/52xx/lite5200_sleep.S       |  2 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c         |  4 +-
 arch/s390/kernel/dis.c                             |  2 +-
 arch/s390/kvm/gaccess.h                            | 23 ++++++---
 arch/um/kernel/dyn.lds.S                           |  6 +++
 arch/um/kernel/uml.lds.S                           |  6 +++
 arch/x86/Makefile                                  |  1 +
 arch/x86/kernel/cpu/perf_event_amd_iommu.c         |  6 +--
 arch/x86/kvm/x86.c                                 |  1 +
 arch/x86/lib/msr-smp.c                             |  4 +-
 drivers/acpi/custom_method.c                       |  4 +-
 drivers/ata/libahci_platform.c                     |  4 +-
 drivers/ata/pata_arasan_cf.c                       | 15 ++++--
 drivers/ata/pata_ixp4xx_cf.c                       |  6 ++-
 drivers/ata/sata_mv.c                              |  4 ++
 drivers/char/ttyprintk.c                           | 11 ++++
 drivers/clk/socfpga/clk-gate-a10.c                 |  1 +
 drivers/crypto/qat/qat_common/adf_transport.c      |  1 +
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c          | 29 ++++++++---
 drivers/crypto/qat/qat_dh895xccvf/adf_isr.c        | 17 ++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  2 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cmd_encoder.c    | 10 +++-
 drivers/gpu/drm/radeon/radeon_atombios.c           |  6 +--
 drivers/gpu/drm/radeon/radeon_kms.c                |  1 +
 drivers/hid/hid-ids.h                              |  1 +
 drivers/hid/hid-plantronics.c                      | 60 +++++++++++++++++++++-
 drivers/hsi/hsi.c                                  |  3 +-
 drivers/hwtracing/intel_th/gth.c                   |  4 +-
 drivers/i2c/busses/i2c-cadence.c                   |  5 +-
 drivers/i2c/busses/i2c-jz4780.c                    |  5 +-
 drivers/i2c/busses/i2c-sh7760.c                    |  5 +-
 drivers/isdn/capi/kcapi.c                          |  4 +-
 drivers/md/dm-ioctl.c                              |  2 +-
 drivers/md/md.c                                    | 35 +++++++------
 drivers/md/persistent-data/dm-btree-internal.h     |  4 +-
 drivers/md/persistent-data/dm-space-map-common.c   |  2 +
 drivers/md/persistent-data/dm-space-map-common.h   |  8 +--
 drivers/media/i2c/adv7511-v4l2.c                   |  2 +-
 drivers/media/pci/saa7164/saa7164-encoder.c        | 20 ++++----
 drivers/media/platform/vivid/vivid-vid-out.c       |  2 +-
 drivers/media/rc/ite-cir.c                         |  8 ++-
 drivers/media/tuners/m88rs6000t.c                  |  6 +--
 drivers/media/usb/dvb-usb/dvb-usb-init.c           | 20 ++++++--
 drivers/media/usb/dvb-usb/dvb-usb.h                |  3 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |  1 +
 drivers/media/usb/gspca/gspca.c                    |  2 +
 drivers/media/usb/gspca/gspca.h                    |  1 +
 drivers/media/usb/gspca/sq905.c                    |  2 +-
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |  9 ++++
 drivers/memory/omap-gpmc.c                         |  7 ++-
 drivers/misc/kgdbts.c                              | 26 +++++-----
 drivers/misc/lis3lv02d/lis3lv02d.c                 | 21 ++++++--
 drivers/misc/vmw_vmci/vmci_doorbell.c              |  2 +-
 drivers/misc/vmw_vmci/vmci_guest.c                 |  2 +-
 drivers/mmc/core/core.c                            |  2 +-
 drivers/mmc/core/sd.c                              |  6 +++
 drivers/mtd/mtdchar.c                              |  8 +--
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |  2 +
 drivers/net/ethernet/ti/davinci_emac.c             |  4 +-
 drivers/net/fddi/Kconfig                           | 15 +++---
 drivers/net/fddi/defxx.c                           | 47 +++++++++++------
 drivers/net/usb/ax88179_178a.c                     |  4 +-
 drivers/net/wan/lapbether.c                        | 32 +++++++++---
 drivers/net/wimax/i2400m/op-rfkill.c               |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |  2 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  2 +-
 drivers/net/wireless/ipw2x00/libipw_wx.c           |  6 ++-
 drivers/net/wireless/iwlwifi/pcie/tx.c             |  7 +--
 drivers/net/wireless/mediatek/mt7601u/eeprom.c     |  2 +-
 drivers/net/wireless/mwl8k.c                       |  1 +
 drivers/net/wireless/wl3501.h                      | 47 +++++++++--------
 drivers/net/wireless/wl3501_cs.c                   | 54 ++++++++++---------
 drivers/nfc/pn533.c                                |  3 ++
 drivers/pci/hotplug/acpiphp_glue.c                 |  1 +
 drivers/pci/pci.c                                  | 16 ++----
 drivers/pci/probe.c                                |  1 +
 drivers/phy/phy-twl4030-usb.c                      |  2 +-
 drivers/platform/x86/thinkpad_acpi.c               | 31 +++++++----
 drivers/power/generic-adc-battery.c                |  2 +-
 drivers/power/s3c_adc_battery.c                    |  2 +-
 drivers/scsi/jazz_esp.c                            |  4 +-
 drivers/scsi/libfc/fc_lport.c                      |  2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  2 -
 drivers/scsi/lpfc/lpfc_sli.c                       |  1 -
 drivers/scsi/sni_53c710.c                          |  5 +-
 drivers/scsi/sun3x_esp.c                           |  4 +-
 drivers/spi/spi-dln2.c                             |  2 +-
 drivers/spi/spi-omap-100k.c                        |  6 +--
 drivers/staging/iio/light/tsl2583.c                |  9 ++++
 drivers/staging/media/omap4iss/iss.c               |  4 +-
 drivers/staging/rtl8192u/r8192U_core.c             |  2 +-
 drivers/target/target_core_pscsi.c                 |  3 +-
 drivers/thermal/fair_share.c                       |  4 ++
 drivers/tty/tty_io.c                               |  8 +--
 drivers/usb/class/cdc-acm.c                        |  2 -
 drivers/usb/core/hub.c                             |  6 +--
 drivers/usb/core/quirks.c                          |  4 ++
 drivers/usb/dwc2/core.h                            |  2 +
 drivers/usb/dwc2/gadget.c                          |  3 +-
 drivers/usb/gadget/function/f_fs.c                 |  3 +-
 drivers/usb/gadget/function/f_uvc.c                |  7 ++-
 drivers/usb/gadget/udc/dummy_hcd.c                 | 23 ++++++---
 drivers/usb/gadget/udc/fotg210-udc.c               | 26 +++++++---
 drivers/usb/gadget/udc/pch_udc.c                   | 49 ++++++++++++------
 drivers/usb/gadget/udc/r8a66597-udc.c              |  2 +
 drivers/usb/host/fotg210-hcd.c                     |  4 +-
 drivers/usb/host/sl811-hcd.c                       |  9 ++--
 drivers/usb/host/xhci-ext-caps.h                   |  5 +-
 drivers/usb/host/xhci.c                            |  6 +--
 drivers/video/fbdev/core/fbcmap.c                  |  8 +--
 fs/btrfs/relocation.c                              |  6 +--
 fs/dlm/debug_fs.c                                  |  1 +
 fs/ecryptfs/main.c                                 |  6 +++
 fs/ext4/ialloc.c                                   | 48 +++++++++++------
 fs/ext4/super.c                                    |  6 ++-
 fs/fuse/cuse.c                                     |  2 +
 fs/jffs2/compr_rtime.c                             |  3 ++
 fs/jffs2/scan.c                                    |  2 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |  2 +-
 fs/nfs/inode.c                                     |  8 +--
 fs/nfs/nfs42proc.c                                 |  5 +-
 fs/squashfs/file.c                                 |  6 +--
 fs/timerfd.c                                       | 10 ++++
 include/linux/hid.h                                |  2 +
 include/linux/tty_driver.h                         |  2 +-
 include/net/bluetooth/hci_core.h                   |  1 +
 include/scsi/libfcoe.h                             |  2 +-
 kernel/kexec_file.c                                |  4 +-
 kernel/trace/ftrace.c                              |  5 +-
 kernel/trace/trace.c                               | 45 +++++++---------
 kernel/trace/trace_clock.c                         | 44 +++++++++++-----
 lib/kobject_uevent.c                               |  9 ++--
 mm/ksm.c                                           |  1 +
 net/bluetooth/hci_event.c                          |  3 +-
 net/bluetooth/l2cap_core.c                         |  4 ++
 net/hsr/hsr_framereg.c                             |  3 +-
 net/ipv6/ip6_gre.c                                 |  3 --
 net/ipv6/ip6_tunnel.c                              |  3 +-
 net/ipv6/ip6_vti.c                                 |  3 +-
 net/ipv6/sit.c                                     |  5 +-
 net/mac80211/main.c                                |  7 ++-
 net/mac80211/mlme.c                                |  5 ++
 net/nfc/digital_dep.c                              |  2 +
 net/nfc/llcp_sock.c                                |  4 ++
 net/openvswitch/actions.c                          |  8 +--
 net/sctp/sm_make_chunk.c                           |  2 +-
 net/sctp/sm_statefuns.c                            |  3 +-
 net/sctp/socket.c                                  | 38 ++++++++------
 net/tipc/netlink_compat.c                          |  2 +-
 net/vmw_vsock/vmci_transport.c                     |  3 +-
 net/wireless/scan.c                                |  2 +
 samples/kfifo/bytestream-example.c                 |  8 ++-
 samples/kfifo/inttype-example.c                    |  8 ++-
 samples/kfifo/record-example.c                     |  8 ++-
 scripts/kconfig/nconf.c                            |  2 +-
 sound/core/init.c                                  |  2 -
 sound/isa/sb/emu8000.c                             |  4 +-
 sound/isa/sb/sb16_csp.c                            |  8 ++-
 sound/pci/hda/hda_generic.c                        | 16 ++++--
 sound/pci/hda/patch_realtek.c                      | 17 +++---
 sound/pci/rme9652/hdsp.c                           |  3 +-
 sound/pci/rme9652/hdspm.c                          |  3 +-
 sound/pci/rme9652/rme9652.c                        |  3 +-
 sound/soc/codecs/rt286.c                           | 23 +++++----
 sound/usb/card.c                                   | 14 ++---
 sound/usb/quirks-table.h                           | 10 ++++
 sound/usb/quirks.c                                 | 16 ++++--
 sound/usb/usbaudio.h                               |  2 +
 tools/testing/selftests/lib.mk                     |  4 ++
 184 files changed, 1050 insertions(+), 541 deletions(-)


