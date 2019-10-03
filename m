Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F9CCACFC
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbfJCRdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733013AbfJCQIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:08:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F00A7222C2;
        Thu,  3 Oct 2019 16:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118887;
        bh=5U+KAWdwvvFj0ygF0kOvD8zKP4Qv5vHHftBeYcZy0OA=;
        h=From:To:Cc:Subject:Date:From;
        b=Eos8cKxeEkOlXxBaUBuH4KU1gOqiC4zA5vhyCRNRa8sFqrKwBISXhPHXglLMf6o9d
         fHxnewZz8IIQBwGVHadl0+isKfJlaUVgFi8Tln+OsFjPF/H7uYPuP/8mbvaYmJQ/HA
         fRvNMbCh8JKCDe5THqkZTxROH6vOMPKK/29BAPKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/185] 4.14.147-stable review
Date:   Thu,  3 Oct 2019 17:51:18 +0200
Message-Id: <20191003154437.541662648@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.147-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.147-rc1
X-KernelTest-Deadline: 2019-10-05T15:45+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.147 release.
There are 185 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.147-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.147-rc1

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race setting up and completing qgroup rescan workers

Lu Fengqi <lufq.fnst@cn.fujitsu.com>
    btrfs: qgroup: Drop quota_root and fs_info parameters from update_qgroup_status_item

Yafang Shao <laoar.shao@gmail.com>
    mm/compaction.c: clear total_{migrate,free}_scanned before scanning a new zone

NeilBrown <neilb@suse.de>
    md/raid0: avoid RAID0 data corruption due to layout confusion.

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix oplock handling for SMB 2.1+ protocols

Murphy Zhou <jencce.kernel@gmail.com>
    CIFS: fix max ea value size

Chris Brandt <chris.brandt@renesas.com>
    i2c: riic: Clear NACK in tend isr

Laurent Vivier <lvivier@redhat.com>
    hwrng: core - don't wait on add_early_randomness()

Chao Yu <yuchao0@huawei.com>
    quota: fix wrong condition in is_quota_modification()

Theodore Ts'o <tytso@mit.edu>
    ext4: fix punch hole for inline_data file systems

Rakesh Pandit <rakesh@tuxera.com>
    ext4: fix warning inside ext4_convert_unwritten_extents_endio

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    /dev/mem: Bail out upon SIGKILL.

Denis Kenzior <denkenz@gmail.com>
    cfg80211: Purge frame registrations on iftype change

NeilBrown <neilb@suse.com>
    md: only call set_in_sync() when it is expected to succeed.

NeilBrown <neilb@suse.com>
    md: don't report active array_state until after revalidate_disk() completes.

Xiao Ni <xni@redhat.com>
    md/raid6: Set R5_ReadError when there is read failure on parity disk

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: Fix the wrong target io_tree when freeing reserved data space

Nikolay Borisov <nborisov@suse.com>
    btrfs: Relinquish CPUs in btrfs_compare_trees

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix use-after-free when using the tree modification log

Mark Salyzyn <salyzyn@android.com>
    ovl: filter of trusted xattr results in audit

Michal Hocko <mhocko@suse.com>
    memcg, kmem: do not fail __GFP_NOFAIL charges

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    memcg, oom: don't require __GFP_FS when invoking memcg OOM killer

Bob Peterson <rpeterso@redhat.com>
    gfs2: clear buf_in_tr when ending a transaction in sweep_bh_for_rgrps

Mark Brown <broonie@kernel.org>
    regulator: Defer init completion for a while after late_initcall

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    alarmtimer: Use EOPNOTSUPP instead of ENOTSUPP

Shawn Lin <shawn.lin@rock-chips.com>
    arm64: dts: rockchip: limit clock rate of MMC controllers for RK3328

Luis Araneda <luaraneda@gmail.com>
    ARM: zynq: Use memcpy_toio instead of memcpy on smp bring-up

Lihua Yao <ylhuajnu@outlook.com>
    ARM: samsung: Fix system restart on S3C6410

Amadeusz Sławiński <amadeuszx.slawinski@intel.com>
    ASoC: Intel: Fix use of potentially uninitialized variable

Amadeusz Sławiński <amadeuszx.slawinski@intel.com>
    ASoC: Intel: Skylake: Use correct function to access iomem space

Amadeusz Sławiński <amadeuszx.slawinski@intel.com>
    ASoC: Intel: NHLT: Fix debug print format

Kees Cook <keescook@chromium.org>
    binfmt_elf: Do not move brk for INTERP-less ET_EXEC

Hans de Goede <hdegoede@redhat.com>
    media: sn9c20x: Add MSI MS-1039 laptop to flip_dmi_table

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Manually calculate reserved bits when loading PDPTRS

Jan Dakinevich <jan.dakinevich@virtuozzo.com>
    KVM: x86: set ctxt->have_exception in x86_decode_insn()

Jan Dakinevich <jan.dakinevich@virtuozzo.com>
    KVM: x86: always stop emulation on page fault

Nathan Chancellor <natechancellor@gmail.com>
    x86/retpolines: Fix up backport of a9d57ef15cbe

Helge Deller <deller@gmx.de>
    parisc: Disable HP HSC-PCI Cards to prevent kernel crash

Vasily Averin <vvs@virtuozzo.com>
    fuse: fix missing unlock_page in fuse_writepage()

Tom Briden <tom@decompile.me.uk>
    ALSA: hda/realtek - Fixup mute led on HP Spectre x360

Joonwon Kang <kjw1627@gmail.com>
    randstruct: Check member structs in is_pure_ops_struct()

Ira Weiny <ira.weiny@intel.com>
    IB/hfi1: Define variables as unsigned long to fix KASAN warning

Vincent Whitchurch <vincent.whitchurch@axis.com>
    printk: Do not lose last line in kmsg buffer dump

Martin Wilck <Martin.Wilck@suse.com>
    scsi: scsi_dh_rdac: zero cdb in send_mode_select()

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-tascam: check intermediate state of clock status and retry

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-tascam: handle error code when getting current source of clock

MyungJoo Ham <myungjoo.ham@samsung.com>
    PM / devfreq: passive: fix compiler warning

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: omap3isp: Set device on omap3isp subdevs

Qu Wenruo <wqu@suse.com>
    btrfs: extent-tree: Make sure we only allocate extents from block groups with the same type

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Blacklist PC beep for Lenovo ThinkCentre M73/93

Tomas Bortoli <tomasbortoli@gmail.com>
    media: ttusb-dec: Fix info-leak in ttusb_dec_send_command()

Ahzo <Ahzo@tutanota.com>
    drm/amd/powerplay/smu7: enforce minimal VBITimeout (v2)

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Drop unsol event handler for Intel HDMI codecs

Kai-Heng Feng <kai.heng.feng@canonical.com>
    e1000e: add workaround for possible stalled packet

Kevin Easton <kevin@guarana.org>
    libertas: Add missing sentinel at end of if_usb.c fw_table

Nigel Croxon <ncroxon@redhat.com>
    raid5: don't increment read_errors on EILSEQ return

Al Cooper <alcooperx@gmail.com>
    mmc: sdhci: Fix incorrect switch to HS mode

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Clarify sdio_irq_pending flag for MMC_CAP2_SDIO_IRQ_NOTHREAD

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    raid5: don't set STRIPE_HANDLE to stripe which is in batch list

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: dmaengine: Make the pcm->name equal to pcm->id if the name is not set

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: xts-aes-s390 fix extra run-time crypto self tests finding

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Prohibit probing on BUG() and WARN() address

Peter Ujfalusi <peter.ujfalusi@ti.com>
    dmaengine: ti: edma: Do not reset reserved paRAM slots

Yufen Yu <yuyufen@huawei.com>
    md/raid1: fail run raid1 array when active disk less than one

Wang Shenran <shenran268@gmail.com>
    hwmon: (acpi_power_meter) Change log level for 'unsafe software power cap'

Wenwen Wang <wenwen@cs.uga.edu>
    ACPI / PCI: fix acpi_pci_irq_enable() memory leak

Wenwen Wang <wenwen@cs.uga.edu>
    ACPI: custom_method: fix memory leaks

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Mark LDO10 as always-on on Peach Pit/Pi Chromebooks

Tzvetomir Stoyanov <tstoyanov@vmware.com>
    libtraceevent: Change users plugin directory

Eric Dumazet <edumazet@google.com>
    iommu/iova: Avoid false sharing on fq_timer_on

Qian Cai <cai@lca.pw>
    iommu/amd: Silence warnings under memory pressure

Tom Wu <tomwu@mellanox.com>
    nvmet: fix data units read and written counters in SMART log

Mark Rutland <mark.rutland@arm.com>
    arm64: kpti: ensure patched kernel text is fetched from PoU

Al Stone <ahs3@redhat.com>
    ACPI / CPPC: do not require the _PSD method

Katsuhiro Suzuki <katsuhiro@katsuster.net>
    ASoC: es8316: fix headphone mixer volume table

Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
    media: ov9650: add a sanity check

Benjamin Peterson <benjamin@python.org>
    perf trace beauty ioctl: Fix off-by-one error in cmd->string table

Maciej S. Szmigiero <mail@maciej.szmigiero.name>
    media: saa7134: fix terminology around saa7134_i2c_eeprom_md7134_gate()

Wenwen Wang <wenwen@cs.uga.edu>
    media: cpia2_usb: fix memory leaks

Wenwen Wang <wenwen@cs.uga.edu>
    media: saa7146: add cleanup in hexium_attach()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec-notifier: clear cec_adap in cec_notifier_unregister

Kamil Konieczny <k.konieczny@partner.samsung.com>
    PM / devfreq: exynos-bus: Correct clock enable sequence

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: passive: Use non-devm notifiers

Yazen Ghannam <yazen.ghannam@amd.com>
    EDAC/amd64: Decode syndrome before translating address

Yazen Ghannam <yazen.ghannam@amd.com>
    EDAC/amd64: Recognize DRAM device type ECC capability

Gerald BAEZA <gerald.baeza@st.com>
    libperf: Fix alignment trap with xyarray contents in 'perf stat'

Wenwen Wang <wenwen@cs.uga.edu>
    media: dvb-core: fix a memory leak bug

Mike Christie <mchristi@redhat.com>
    nbd: add missing config put

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: hdpvr: add terminating 0 at end of string

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: radio/si470x: kill urb on error

André Draszik <git@andred.net>
    ARM: dts: imx7d: cl-som-imx7: make ethernet work again

Arnd Bergmann <arnd@arndb.de>
    net: lpc-enet: fix printk format strings

Ezequiel Garcia <ezequiel@collabora.com>
    media: imx: mipi csi-2: Don't fail if initial state times-out

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: omap3isp: Don't set streaming state on random subdevs

Ezequiel Garcia <ezequiel@collabora.com>
    media: i2c: ov5645: Fix power sequence

Tan Xiaojun <tanxiaojun@huawei.com>
    perf record: Support aarch64 random socket_id assignment

Arnd Bergmann <arnd@arndb.de>
    dmaengine: iop-adma: use correct printk format strings

Darius Rad <alpha@area49.net>
    media: rc: imon: Allow iMON RC protocol for ffdc 7e device

Geert Uytterhoeven <geert+renesas@glider.be>
    media: fdp1: Reduce FCP not found message level to debug

Matthias Brugger <matthias.bgg@gmail.com>
    media: mtk-mdp: fix reference count on old device tree

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf test vfs_getname: Disable ~/.perfconfig to get default output

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: gspca: zero usb_buf on error

Phil Auld <pauld@redhat.com>
    sched/fair: Use rq_lock/unlock in online_fair_sched_group

Xiaofei Tan <tanxiaofei@huawei.com>
    efi: cper: print AER info of PCIe fatal error

Stephen Douthit <stephend@silicom-usa.com>
    EDAC, pnd2: Fix ioremap() size in dnv_rd_reg()

Jiri Slaby <jslaby@suse.cz>
    ACPI / processor: don't print errors for processorIDs == 0xff

Valdis Kletnieks <valdis.kletnieks@vt.edu>
    RAS: Fix prototype warnings

Guoqing Jiang <jgq516@gmail.com>
    md: don't set In_sync if array is frozen

Guoqing Jiang <jgq516@gmail.com>
    md: don't call spare_active in md_reap_sync_thread if all member devices can't work

Yufen Yu <yuyufen@huawei.com>
    md/raid1: end bio when the device faulty

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: don't call clk_get_rate() under atomic context

Dan Carpenter <dan.carpenter@oracle.com>
    EDAC/altera: Use the proper type for the IRQ status bits

chenzefeng <chenzefeng2@huawei.com>
    ia64:unwind: fix double free for mod->arch.init_unw_table

Ard van Breemen <ard@kwaak.net>
    ALSA: usb-audio: Skip bSynchAddress endpoint check if it is invalid

Vinod Koul <vkoul@kernel.org>
    base: soc: Export soc_device_register/unregister APIs

Oliver Neukum <oneukum@suse.com>
    media: iguanair: add sanity checks

Robert Richter <rrichter@marvell.com>
    EDAC/mc: Fix grain_bits calculation

Jia-Ju Bai <baijiaju1990@gmail.com>
    ALSA: i2c: ak4xxx-adda: Fix a possible null pointer dereference in build_adc_controls()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Show the fatal CORB/RIRB error more clearly

Thomas Gleixner <tglx@linutronix.de>
    x86/apic: Soft disable APIC before initializing it

Grzegorz Halat <ghalat@redhat.com>
    x86/reboot: Always use NMI fallback when shutdown via reboot vector IPI fails

Juri Lelli <juri.lelli@redhat.com>
    sched/core: Fix CPU controller for !RT_GROUP_SCHED

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix imbalance due to CPU affinity

Fabio Estevam <festevam@gmail.com>
    media: i2c: ov5640: Check for devm_gpiod_get_optional() error

Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
    media: hdpvr: Add device num check and handling

Wen Yang <wen.yang99@zte.com.cn>
    media: exynos4-is: fix leaked of_node references

Sean Young <sean@mess.org>
    media: mtk-cir: lower de-glitch counter for rc-mm protocol

Arnd Bergmann <arnd@arndb.de>
    media: dib0700: fix link error for dibx000_i2c_set_speed

Nick Stoughton <nstoughton@logitech.com>
    leds: leds-lp5562 allow firmware files up to the maximum length

Stefan Wahren <wahrenst@gmx.net>
    dmaengine: bcm2835: Print error in case setting DMA mask fails

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ASoC: sgtl5000: Fix charge pump source assignment

Axel Lin <axel.lin@ingics.com>
    regulator: lm363x: Fix off-by-one n_voltages for lm3632 ldo_vpos/ldo_vneg

Chris Wilson <chris@chris-wilson.co.uk>
    ALSA: hda: Flush interrupts on disabling

Ori Nimron <orinimron123@gmail.com>
    nfc: enforce CAP_NET_RAW for raw sockets

Ori Nimron <orinimron123@gmail.com>
    ieee802154: enforce CAP_NET_RAW for raw sockets

Ori Nimron <orinimron123@gmail.com>
    ax25: enforce CAP_NET_RAW for raw sockets

Ori Nimron <orinimron123@gmail.com>
    appletalk: enforce CAP_NET_RAW for raw sockets

Ori Nimron <orinimron123@gmail.com>
    mISDN: enforce CAP_NET_RAW for raw sockets

Bodong Wang <bodong@mellanox.com>
    net/mlx5: Add device ID of upcoming BlueField-2

Oliver Neukum <oneukum@suse.com>
    usbnet: sanity checking of packet sizes and device mtu

Bjørn Mork <bjorn@mork.no>
    usbnet: ignore endpoints with invalid wMaxPacketSize

Stephen Hemminger <stephen@networkplumber.org>
    skge: fix checksum byte order

Eric Dumazet <edumazet@google.com>
    sch_netem: fix a divide by zero in tabledist()

Takeshi Misawa <jeliantsurux@gmail.com>
    ppp: Fix memory leak in ppp_write

Li RongQing <lirongqing@baidu.com>
    openvswitch: change type of UPCALL_PID attribute to NLA_UNSPEC

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: add max len check for TCA_KIND

Davide Caratti <dcaratti@redhat.com>
    net/sched: act_sample: don't push mac header on ip6gre ingress

Bjorn Andersson <bjorn.andersson@linaro.org>
    net: qrtr: Stop rx_worker before freeing node

Peter Mamonov <pmamonov@gmail.com>
    net/phy: fix DP83865 10 Mbps HDX loopback disable function

Xin Long <lucien.xin@gmail.com>
    macsec: drop skb sk before calling gro_cells_receive

Bjørn Mork <bjorn@mork.no>
    cdc_ncm: fix divide-by-zero caused by invalid wMaxPacketSize

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    arcnet: provide a buffer big enough to actually receive packets

Chao Yu <yuchao0@huawei.com>
    f2fs: use generic EFSBADCRC/EFSCORRUPTED

Jian-Hong Pan <jian-hong@endlessm.com>
    Bluetooth: btrtl: Additional Realtek 8822CE Bluetooth devices

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: don't crash on null attr fork xfs_bmapi_read

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add new hw_changes_brightness quirk, set it on PB Easynote MZ35

Stephen Hemminger <stephen@networkplumber.org>
    net: don't warn in inet diag when IPV6 is disabled

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Flush output polling on shutdown

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to do sanity check on segment bitmap of LFS curseg

Mikulas Patocka <mpatocka@redhat.com>
    dm zoned: fix invalid memory access

Chao Yu <yuchao0@huawei.com>
    Revert "f2fs: avoid out-of-range memory access"

zhengbin <zhengbin13@huawei.com>
    blk-mq: move cancel of requeue_work to the front of blk_exit_queue

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Avoid use of hv_pci_dev->pci_slot after freeing it

Surbhi Palande <f2fsnewbie@gmail.com>
    f2fs: check all the data segments against all node ones

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3-its: Fix LPI release for Multi-MSI devices

Waiman Long <longman@redhat.com>
    locking/lockdep: Add debug_locks check in __lock_downgrade()

David Lechner <david@lechnology.com>
    power: supply: sysfs: ratelimit property read error message

Nathan Chancellor <natechancellor@gmail.com>
    pinctrl: sprd: Use define directive for sprd_pinconf_params values

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Clobber user CFLAGS variable

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Apply AMD controller workaround for Raven platform

Shih-Yuan Lee (FourDollars) <fourdollars@debian.org>
    ALSA: hda - Add laptop imic fixup for ASUS M9V laptop

Will Deacon <will.deacon@arm.com>
    arm64: kpti: Whitelist Cortex-A CPUs that don't implement the CSV3 field

Takashi Iwai <tiwai@suse.de>
    ASoC: fsl: Fix of-node refcount unbalance in fsl_ssi_probe_from_dt()

Marco Felsch <m.felsch@pengutronix.de>
    media: tvp5150: fix switch exit in set control handler

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: send BCAST management frames to the right station

Gustavo A. R. Silva <gustavo@embeddedor.com>
    crypto: talitos - fix missing break in switch statement

Tokunori Ikegami <ikegami.t@gmail.com>
    mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()

Alan Stern <stern@rowland.harvard.edu>
    HID: hidraw: Fix invalid read in hidraw_ioctl

Alan Stern <stern@rowland.harvard.edu>
    HID: logitech: Fix general protection fault caused by Logitech driver

Roderick Colenbrander <roderick.colenbrander@sony.com>
    HID: sony: Fix memory corruption issue on cleanup.

Alan Stern <stern@rowland.harvard.edu>
    HID: prodikeys: Fix general protection fault during probe

Jack Morgenstein <jackm@dev.mellanox.co.il>
    IB/core: Add an unbound WQ type to the new CQ API

Rolf Eike Beer <eb@emlix.com>
    objtool: Query pkg-config for libelf location

Greg Kurz <groug@kaod.org>
    powerpc/xive: Fix bogus error code returned by OPAL

Marcel Holtmann <marcel@holtmann.org>
    Revert "Bluetooth: validate BLE connection interval updates"


-------------

Diffstat:

 Makefile                                          |  8 ++--
 arch/arm/boot/dts/exynos5420-peach-pit.dts        |  1 +
 arch/arm/boot/dts/exynos5800-peach-pi.dts         |  1 +
 arch/arm/boot/dts/imx7d-cl-som-imx7.dts           |  4 +-
 arch/arm/mach-zynq/platsmp.c                      |  2 +-
 arch/arm/plat-samsung/watchdog-reset.c            |  1 +
 arch/arm64/boot/dts/rockchip/rk3328.dtsi          |  3 ++
 arch/arm64/kernel/cpufeature.c                    |  5 +++
 arch/arm64/mm/proc.S                              |  9 +++++
 arch/ia64/kernel/module.c                         |  8 +++-
 arch/powerpc/include/asm/opal.h                   |  2 +-
 arch/powerpc/platforms/powernv/opal-wrappers.S    |  2 +-
 arch/powerpc/sysdev/xive/native.c                 | 11 +++++
 arch/s390/crypto/aes_s390.c                       |  6 +++
 arch/x86/Makefile                                 |  2 +-
 arch/x86/kernel/apic/apic.c                       |  8 ++++
 arch/x86/kernel/smp.c                             | 46 ++++++++++++---------
 arch/x86/kvm/emulate.c                            |  2 +
 arch/x86/kvm/x86.c                                | 21 ++++++++--
 block/blk-mq.c                                    |  2 -
 block/blk-sysfs.c                                 |  3 ++
 drivers/acpi/acpi_processor.c                     | 10 +++--
 drivers/acpi/acpi_video.c                         | 37 +++++++++++++++++
 drivers/acpi/cppc_acpi.c                          |  6 ++-
 drivers/acpi/custom_method.c                      |  5 ++-
 drivers/acpi/pci_irq.c                            |  4 +-
 drivers/base/soc.c                                |  2 +
 drivers/block/nbd.c                               |  4 +-
 drivers/bluetooth/btusb.c                         |  3 ++
 drivers/char/hw_random/core.c                     |  2 +-
 drivers/char/mem.c                                | 21 ++++++++++
 drivers/crypto/talitos.c                          |  1 +
 drivers/devfreq/exynos-bus.c                      | 31 +++++++-------
 drivers/devfreq/governor_passive.c                |  7 ++--
 drivers/dma/bcm2835-dma.c                         |  4 +-
 drivers/dma/edma.c                                |  9 +++--
 drivers/dma/iop-adma.c                            | 18 ++++-----
 drivers/edac/altera_edac.c                        |  4 +-
 drivers/edac/amd64_edac.c                         | 28 ++++++++-----
 drivers/edac/edac_mc.c                            |  8 +++-
 drivers/edac/pnd2_edac.c                          |  7 +++-
 drivers/firmware/efi/cper.c                       | 15 +++++++
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c  |  5 +++
 drivers/gpu/drm/drm_probe_helper.c                |  9 ++++-
 drivers/hid/hid-lg.c                              | 10 +++--
 drivers/hid/hid-lg4ff.c                           |  1 -
 drivers/hid/hid-prodikeys.c                       | 12 +++++-
 drivers/hid/hid-sony.c                            |  2 +-
 drivers/hid/hidraw.c                              |  2 +-
 drivers/hwmon/acpi_power_meter.c                  |  4 +-
 drivers/i2c/busses/i2c-riic.c                     |  1 +
 drivers/infiniband/core/cq.c                      |  8 +++-
 drivers/infiniband/core/device.c                  | 15 ++++++-
 drivers/infiniband/core/mad.c                     |  2 +-
 drivers/infiniband/hw/hfi1/mad.c                  | 45 +++++++++------------
 drivers/iommu/amd_iommu.c                         |  4 +-
 drivers/iommu/iova.c                              |  4 +-
 drivers/irqchip/irq-gic-v3-its.c                  |  9 ++---
 drivers/isdn/mISDN/socket.c                       |  2 +
 drivers/leds/leds-lp5562.c                        |  6 ++-
 drivers/md/dm-zoned-target.c                      |  2 -
 drivers/md/md.c                                   | 28 +++++++++----
 drivers/md/md.h                                   |  3 ++
 drivers/md/raid0.c                                | 33 ++++++++++++++-
 drivers/md/raid0.h                                | 14 +++++++
 drivers/md/raid1.c                                | 39 ++++++++++++------
 drivers/md/raid5.c                                | 10 +++--
 drivers/media/cec/cec-notifier.c                  |  2 +
 drivers/media/dvb-core/dvbdev.c                   |  4 +-
 drivers/media/i2c/ov5640.c                        |  5 +++
 drivers/media/i2c/ov5645.c                        | 26 ++++++++----
 drivers/media/i2c/ov9650.c                        |  5 +++
 drivers/media/i2c/tvp5150.c                       |  2 +-
 drivers/media/pci/saa7134/saa7134-i2c.c           | 12 ++++--
 drivers/media/pci/saa7146/hexium_gemini.c         |  3 ++
 drivers/media/platform/exynos4-is/fimc-is.c       |  1 +
 drivers/media/platform/exynos4-is/media-dev.c     |  2 +
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c     |  4 +-
 drivers/media/platform/omap3isp/isp.c             |  8 ++++
 drivers/media/platform/omap3isp/ispccdc.c         |  1 +
 drivers/media/platform/omap3isp/ispccp2.c         |  1 +
 drivers/media/platform/omap3isp/ispcsi2.c         |  1 +
 drivers/media/platform/omap3isp/isppreview.c      |  1 +
 drivers/media/platform/omap3isp/ispresizer.c      |  1 +
 drivers/media/platform/omap3isp/ispstat.c         |  2 +
 drivers/media/platform/rcar_fdp1.c                |  2 +-
 drivers/media/radio/si470x/radio-si470x-usb.c     |  5 ++-
 drivers/media/rc/iguanair.c                       | 15 ++++---
 drivers/media/rc/imon.c                           |  7 +++-
 drivers/media/rc/mtk-cir.c                        |  8 ++++
 drivers/media/usb/cpia2/cpia2_usb.c               |  4 ++
 drivers/media/usb/dvb-usb/dib0700_devices.c       |  8 ++++
 drivers/media/usb/gspca/konica.c                  |  5 +++
 drivers/media/usb/gspca/nw80x.c                   |  5 +++
 drivers/media/usb/gspca/ov519.c                   | 10 +++++
 drivers/media/usb/gspca/ov534.c                   |  5 +++
 drivers/media/usb/gspca/ov534_9.c                 |  1 +
 drivers/media/usb/gspca/se401.c                   |  5 +++
 drivers/media/usb/gspca/sn9c20x.c                 | 12 ++++++
 drivers/media/usb/gspca/sonixb.c                  |  5 +++
 drivers/media/usb/gspca/sonixj.c                  |  5 +++
 drivers/media/usb/gspca/spca1528.c                |  5 +++
 drivers/media/usb/gspca/sq930x.c                  |  5 +++
 drivers/media/usb/gspca/sunplus.c                 |  5 +++
 drivers/media/usb/gspca/vc032x.c                  |  5 +++
 drivers/media/usb/gspca/w996Xcf.c                 |  5 +++
 drivers/media/usb/hdpvr/hdpvr-core.c              | 13 +++++-
 drivers/media/usb/ttusb-dec/ttusb_dec.c           |  2 +-
 drivers/mmc/core/sdio_irq.c                       |  9 +++--
 drivers/mmc/host/sdhci.c                          |  4 +-
 drivers/mtd/chips/cfi_cmdset_0002.c               | 18 ++++++---
 drivers/net/arcnet/arcnet.c                       | 31 +++++++-------
 drivers/net/ethernet/intel/e1000e/ich8lan.c       | 10 +++++
 drivers/net/ethernet/intel/e1000e/ich8lan.h       |  2 +-
 drivers/net/ethernet/marvell/skge.c               |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c    |  1 +
 drivers/net/ethernet/nxp/lpc_eth.c                | 13 +++---
 drivers/net/macsec.c                              |  1 +
 drivers/net/phy/national.c                        |  9 +++--
 drivers/net/ppp/ppp_generic.c                     |  2 +
 drivers/net/usb/cdc_ncm.c                         |  6 ++-
 drivers/net/usb/usbnet.c                          |  8 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       |  2 +-
 drivers/net/wireless/marvell/libertas/if_usb.c    |  3 +-
 drivers/nvme/target/admin-cmd.c                   | 14 ++++---
 drivers/parisc/dino.c                             | 24 +++++++++++
 drivers/pci/host/pci-hyperv.c                     |  2 +-
 drivers/pinctrl/sprd/pinctrl-sprd.c               |  6 +--
 drivers/power/supply/power_supply_sysfs.c         |  3 +-
 drivers/ras/cec.c                                 |  1 +
 drivers/ras/debugfs.c                             |  2 +
 drivers/regulator/core.c                          | 42 ++++++++++++++-----
 drivers/regulator/lm363x-regulator.c              |  2 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c        |  2 +
 drivers/staging/media/imx/imx6-mipi-csi2.c        | 12 ++----
 fs/binfmt_elf.c                                   |  3 +-
 fs/btrfs/ctree.c                                  |  5 ++-
 fs/btrfs/extent-tree.c                            |  8 ++++
 fs/btrfs/qgroup.c                                 | 45 ++++++++++++---------
 fs/cifs/smb2ops.c                                 |  5 +++
 fs/cifs/xattr.c                                   |  2 +-
 fs/ext4/extents.c                                 |  4 +-
 fs/ext4/inode.c                                   |  9 +++++
 fs/f2fs/checkpoint.c                              |  8 +++-
 fs/f2fs/data.c                                    |  8 ++--
 fs/f2fs/f2fs.h                                    |  4 ++
 fs/f2fs/inline.c                                  |  4 +-
 fs/f2fs/inode.c                                   |  4 +-
 fs/f2fs/node.c                                    |  4 +-
 fs/f2fs/recovery.c                                |  2 +-
 fs/f2fs/segment.c                                 | 49 +++++++++++++++++++----
 fs/f2fs/segment.h                                 |  4 +-
 fs/f2fs/super.c                                   |  6 +--
 fs/fuse/file.c                                    |  1 +
 fs/gfs2/bmap.c                                    |  1 +
 fs/overlayfs/inode.c                              |  3 +-
 fs/xfs/libxfs/xfs_bmap.c                          | 29 ++++++++++----
 include/linux/bug.h                               |  5 +++
 include/linux/quotaops.h                          |  2 +-
 include/rdma/ib_verbs.h                           |  9 +++--
 kernel/kprobes.c                                  |  3 +-
 kernel/locking/lockdep.c                          |  3 ++
 kernel/printk/printk.c                            |  2 +-
 kernel/sched/core.c                               |  4 --
 kernel/sched/fair.c                               | 11 ++---
 kernel/time/alarmtimer.c                          |  4 +-
 mm/compaction.c                                   | 35 ++++++----------
 mm/memcontrol.c                                   | 10 +++++
 mm/oom_kill.c                                     |  5 ++-
 net/appletalk/ddp.c                               |  5 +++
 net/ax25/af_ax25.c                                |  2 +
 net/bluetooth/hci_event.c                         |  5 ---
 net/bluetooth/l2cap_core.c                        |  9 +----
 net/ieee802154/socket.c                           |  3 ++
 net/ipv4/raw_diag.c                               |  3 --
 net/nfc/llcp_sock.c                               |  7 +++-
 net/openvswitch/datapath.c                        |  2 +-
 net/qrtr/qrtr.c                                   |  1 +
 net/sched/act_sample.c                            |  1 +
 net/sched/sch_api.c                               |  3 +-
 net/sched/sch_netem.c                             |  2 +-
 net/wireless/util.c                               |  1 +
 scripts/gcc-plugins/randomize_layout_plugin.c     | 10 ++---
 sound/firewire/tascam/tascam-pcm.c                |  3 ++
 sound/firewire/tascam/tascam-stream.c             | 42 ++++++++++++-------
 sound/hda/hdac_controller.c                       |  2 +
 sound/i2c/other/ak4xxx-adda.c                     |  7 ++--
 sound/pci/hda/hda_controller.c                    |  5 ++-
 sound/pci/hda/hda_intel.c                         |  5 +--
 sound/pci/hda/patch_analog.c                      |  1 +
 sound/pci/hda/patch_hdmi.c                        |  9 ++++-
 sound/pci/hda/patch_realtek.c                     | 22 ++++++++++
 sound/soc/codecs/es8316.c                         |  7 +++-
 sound/soc/codecs/sgtl5000.c                       | 15 ++++---
 sound/soc/fsl/fsl_ssi.c                           |  5 ++-
 sound/soc/intel/common/sst-ipc.c                  |  2 +
 sound/soc/intel/skylake/skl-debug.c               |  2 +-
 sound/soc/intel/skylake/skl-nhlt.c                |  2 +-
 sound/soc/sh/rcar/adg.c                           | 21 +++++++---
 sound/soc/soc-generic-dmaengine-pcm.c             |  6 +++
 sound/usb/pcm.c                                   |  1 +
 tools/lib/traceevent/Makefile                     |  6 +--
 tools/lib/traceevent/event-plugin.c               |  2 +-
 tools/objtool/Makefile                            |  7 +++-
 tools/perf/tests/shell/trace+probe_vfs_getname.sh |  4 ++
 tools/perf/trace/beauty/ioctl.c                   |  2 +-
 tools/perf/util/header.c                          |  4 +-
 tools/perf/util/xyarray.h                         |  3 +-
 208 files changed, 1200 insertions(+), 437 deletions(-)


