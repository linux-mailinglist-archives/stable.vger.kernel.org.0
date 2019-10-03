Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFCF6CAEB7
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 21:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbfJCTCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 15:02:34 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37339 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729781AbfJCTCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 15:02:34 -0400
Received: by mail-ed1-f67.google.com with SMTP id r4so3603230edy.4
        for <stable@vger.kernel.org>; Thu, 03 Oct 2019 12:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E3WHlQ7euoNYZNL7vTJqMDeE0NcoRSL0Yhvqv/UbWnY=;
        b=qACI/nl+ay1fXPgZ0ITe0J/0iQyB7A3w0816/nGu+oAXs245XDhtZs6OtAJr84e2mh
         faY7w9iY27s1Kn4w6b9ERpgwLQ30n9ckXo1Hnp9iotx60M49pCTrwAU6FKCJ4B8KTtPq
         Lfc3Fpx+r9Qw8Z262vxpU7w32twlUwDFGmGinhxTTZ4BiA9aZhHm5lqvn6c4cvsuN05A
         8JvxFr8L3OTrl3UA10RKgyjhchQ/+rBLuoa0671V+H8hMP2KGTSjByr9nrokdGIaZTcc
         wN2nSURaMRuZbKhOEJzAJVVcQJvRbUn33HmDFS3SgEkCp5sOyeGH1QcDLpI2v1jrjcZi
         n+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=E3WHlQ7euoNYZNL7vTJqMDeE0NcoRSL0Yhvqv/UbWnY=;
        b=ii/xkgnZc4VwaPYLIMbkkXiaaWVrooxXPzoTubcfmIVwk5U6Vw9h5zK3b03Y4qNEZr
         qRn0Le0tKOczSzolf+TmJ7fIJ6PjYz9iyUcqfardKNsnjkGIunsh+nWiC5AIXSeeDJBv
         uqfPUULC5RSvueTOKOZXhlZrtg2I6RqLwETtLaOm88Tk8oc9IxFD7fesdjlPMaje2pVj
         Je72h6wbM8577WBzdI5qBK3iCUSRavGeYOWWN2P4YKtyz3Ic8gVZdECY2W7bsyuTB6yM
         7C0RHCLvDxhs8cMPvlY50I2FjYcb0o1w5/GxZS8HNKhatvGuFRJOOJ4Q3wq5LySVJA+v
         Vr8Q==
X-Gm-Message-State: APjAAAVluDyf49CGVFbAISJLHVCZk1b/enyAcWoP24NxaE6pVpsBPRAI
        oxV4Kxt8pdE6BkLHCAFh9gMVuMhx8vdTAg==
X-Google-Smtp-Source: APXvYqxE4rJka0JPHhpreyQyeUniQyD6PNA81NwYRx+8YTTLnFodPoAp1uc91yaHc0FUUxD7lpwyIQ==
X-Received: by 2002:aa7:c71a:: with SMTP id i26mr11282398edq.68.1570129347818;
        Thu, 03 Oct 2019 12:02:27 -0700 (PDT)
Received: from [192.168.1.2] (host-109-89-151-97.dynamic.voo.be. [109.89.151.97])
        by smtp.gmail.com with ESMTPSA id e27sm336538ejc.1.2019.10.03.12.02.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 12:02:26 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/211] 4.19.77-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
References: <20191003154447.010950442@linuxfoundation.org>
From:   =?UTF-8?Q?Fran=c3=a7ois_Valenduc?= <francoisvalenduc@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=francoisvalenduc@gmail.com; keydata=
 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
Message-ID: <ea824819-1047-e74b-2e71-814c3c2756e9@gmail.com>
Date:   Thu, 3 Oct 2019 21:02:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: fr-moderne
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This does not compile. I get this error:

  CC      drivers/ras/debugfs.o
drivers/ras/debugfs.c:9:5: error: redefinition of 'ras_userspace_consumers'
 int ras_userspace_consumers(void)
     ^~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/ras/debugfs.c:2:
./include/linux/ras.h:14:19: note: previous definition of
'ras_userspace_consumers' was here
 static inline int ras_userspace_consumers(void) { return 0; }
                   ^~~~~~~~~~~~~~~~~~~~~~~
drivers/ras/debugfs.c:39:12: error: redefinition of 'ras_add_daemon_trace'
 int __init ras_add_daemon_trace(void)
            ^~~~~~~~~~~~~~~~~~~~
In file included from drivers/ras/debugfs.c:2:
./include/linux/ras.h:16:19: note: previous definition of
'ras_add_daemon_trace' was here
 static inline int ras_add_daemon_trace(void) { return 0; }
                   ^~~~~~~~~~~~~~~~~~~~
drivers/ras/debugfs.c:55:13: error: redefinition of 'ras_debugfs_init'
 void __init ras_debugfs_init(void)
             ^~~~~~~~~~~~~~~~
In file included from drivers/ras/debugfs.c:2:
./include/linux/ras.h:15:20: note: previous definition of
'ras_debugfs_init' was here
 static inline void ras_debugfs_init(void) { }
                    ^~~~~~~~~~~~~~~~
make[2]: *** [scripts/Makefile.build:304: drivers/ras/debugfs.o] Error 1
make[1]: *** [scripts/Makefile.build:544: drivers/ras] Error 2
make: *** [Makefile:1046: drivers] Error 2
zsh: exit 2     LANG="C" make


Does somebody have an idea about this ?

Thanks,

François Valenduc

Le 3/10/19 à 17:51, Greg Kroah-Hartman a écrit :
> This is the start of the stable review cycle for the 4.19.77 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.77-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 4.19.77-rc1
> 
> Kai-Heng Feng <kai.heng.feng@canonical.com>
>     drm/amd/display: Restore backlight brightness after system resume
> 
> Yafang Shao <laoar.shao@gmail.com>
>     mm/compaction.c: clear total_{migrate,free}_scanned before scanning a new zone
> 
> Eric Biggers <ebiggers@google.com>
>     fuse: fix deadlock with aio poll and fuse_iqueue::waitq.lock
> 
> NeilBrown <neilb@suse.de>
>     md/raid0: avoid RAID0 data corruption due to layout confusion.
> 
> Pavel Shilovsky <pshilov@microsoft.com>
>     CIFS: Fix oplock handling for SMB 2.1+ protocols
> 
> Murphy Zhou <jencce.kernel@gmail.com>
>     CIFS: fix max ea value size
> 
> Chris Brandt <chris.brandt@renesas.com>
>     i2c: riic: Clear NACK in tend isr
> 
> Laurent Vivier <lvivier@redhat.com>
>     hwrng: core - don't wait on add_early_randomness()
> 
> Chao Yu <yuchao0@huawei.com>
>     quota: fix wrong condition in is_quota_modification()
> 
> Theodore Ts'o <tytso@mit.edu>
>     ext4: fix punch hole for inline_data file systems
> 
> Rakesh Pandit <rakesh@tuxera.com>
>     ext4: fix warning inside ext4_convert_unwritten_extents_endio
> 
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>     /dev/mem: Bail out upon SIGKILL.
> 
> Denis Kenzior <denkenz@gmail.com>
>     cfg80211: Purge frame registrations on iftype change
> 
> NeilBrown <neilb@suse.com>
>     md: only call set_in_sync() when it is expected to succeed.
> 
> NeilBrown <neilb@suse.com>
>     md: don't report active array_state until after revalidate_disk() completes.
> 
> Xiao Ni <xni@redhat.com>
>     md/raid6: Set R5_ReadError when there is read failure on parity disk
> 
> Filipe Manana <fdmanana@suse.com>
>     Btrfs: fix race setting up and completing qgroup rescan workers
> 
> Qu Wenruo <wqu@suse.com>
>     btrfs: qgroup: Fix reserved data space leak if we have multiple reserve calls
> 
> Qu Wenruo <wqu@suse.com>
>     btrfs: qgroup: Fix the wrong target io_tree when freeing reserved data space
> 
> Nikolay Borisov <nborisov@suse.com>
>     btrfs: Relinquish CPUs in btrfs_compare_trees
> 
> Filipe Manana <fdmanana@suse.com>
>     Btrfs: fix use-after-free when using the tree modification log
> 
> Christophe Leroy <christophe.leroy@c-s.fr>
>     btrfs: fix allocation of free space cache v1 bitmap pages
> 
> Mark Salyzyn <salyzyn@android.com>
>     ovl: filter of trusted xattr results in audit
> 
> Ding Xiang <dingxiang@cmss.chinamobile.com>
>     ovl: Fix dereferencing possible ERR_PTR()
> 
> Steve French <stfrench@microsoft.com>
>     smb3: allow disabling requesting leases
> 
> Yufen Yu <yuyufen@huawei.com>
>     block: fix null pointer dereference in blk_mq_rq_timed_out()
> 
> Stefan Assmann <sassmann@kpanic.de>
>     i40e: check __I40E_VF_DISABLE bit in i40e_sync_filters_subtask
> 
> Michal Hocko <mhocko@suse.com>
>     memcg, kmem: do not fail __GFP_NOFAIL charges
> 
> Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
>     memcg, oom: don't require __GFP_FS when invoking memcg OOM killer
> 
> Bob Peterson <rpeterso@redhat.com>
>     gfs2: clear buf_in_tr when ending a transaction in sweep_bh_for_rgrps
> 
> Hans de Goede <hdegoede@redhat.com>
>     efifb: BGRT: Improve efifb_bgrt_sanity_check
> 
> Mark Brown <broonie@kernel.org>
>     regulator: Defer init completion for a while after late_initcall
> 
> Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
>     alarmtimer: Use EOPNOTSUPP instead of ENOTSUPP
> 
> Shawn Lin <shawn.lin@rock-chips.com>
>     arm64: dts: rockchip: limit clock rate of MMC controllers for RK3328
> 
> Will Deacon <will@kernel.org>
>     arm64: tlb: Ensure we execute an ISB following walk cache invalidation
> 
> Will Deacon <will@kernel.org>
>     Revert "arm64: Remove unnecessary ISBs from set_{pte,pmd,pud}"
> 
> Luis Araneda <luaraneda@gmail.com>
>     ARM: zynq: Use memcpy_toio instead of memcpy on smp bring-up
> 
> Lihua Yao <ylhuajnu@outlook.com>
>     ARM: samsung: Fix system restart on S3C6410
> 
> Amadeusz Sławiński <amadeuszx.slawinski@intel.com>
>     ASoC: Intel: Fix use of potentially uninitialized variable
> 
> Amadeusz Sławiński <amadeuszx.slawinski@intel.com>
>     ASoC: Intel: Skylake: Use correct function to access iomem space
> 
> Amadeusz Sławiński <amadeuszx.slawinski@intel.com>
>     ASoC: Intel: NHLT: Fix debug print format
> 
> Kees Cook <keescook@chromium.org>
>     binfmt_elf: Do not move brk for INTERP-less ET_EXEC
> 
> Arnd Bergmann <arnd@arndb.de>
>     media: don't drop front-end reference count for ->detach
> 
> Hans de Goede <hdegoede@redhat.com>
>     media: sn9c20x: Add MSI MS-1039 laptop to flip_dmi_table
> 
> Sean Christopherson <sean.j.christopherson@intel.com>
>     KVM: x86: Manually calculate reserved bits when loading PDPTRS
> 
> Jan Dakinevich <jan.dakinevich@virtuozzo.com>
>     KVM: x86: set ctxt->have_exception in x86_decode_insn()
> 
> Jan Dakinevich <jan.dakinevich@virtuozzo.com>
>     KVM: x86: always stop emulation on page fault
> 
> Helge Deller <deller@gmx.de>
>     parisc: Disable HP HSC-PCI Cards to prevent kernel crash
> 
> Vasily Averin <vvs@virtuozzo.com>
>     fuse: fix missing unlock_page in fuse_writepage()
> 
> Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
>     powerpc/imc: Dont create debugfs files for cpu-less nodes
> 
> Ming Lei <ming.lei@redhat.com>
>     scsi: implement .cleanup_rq callback
> 
> Ming Lei <ming.lei@redhat.com>
>     blk-mq: add callback of .cleanup_rq
> 
> Jan-Marek Glogowski <glogow@fbihome.de>
>     ALSA: hda/realtek - PCI quirk for Medion E4254
> 
> Yan, Zheng <zyan@redhat.com>
>     ceph: use ceph_evict_inode to cleanup inode's resource
> 
> Sasha Levin <sashal@kernel.org>
>     Revert "ceph: use ceph_evict_inode to cleanup inode's resource"
> 
> Joonwon Kang <kjw1627@gmail.com>
>     randstruct: Check member structs in is_pure_ops_struct()
> 
> Ira Weiny <ira.weiny@intel.com>
>     IB/hfi1: Define variables as unsigned long to fix KASAN warning
> 
> Danit Goldberg <danitg@mellanox.com>
>     IB/mlx5: Free mpi in mp_slave mode
> 
> Vincent Whitchurch <vincent.whitchurch@axis.com>
>     printk: Do not lose last line in kmsg buffer dump
> 
> Quinn Tran <qutran@marvell.com>
>     scsi: qla2xxx: Fix Relogin to prevent modifying scan_state flag
> 
> Martin Wilck <Martin.Wilck@suse.com>
>     scsi: scsi_dh_rdac: zero cdb in send_mode_select()
> 
> Takashi Sakamoto <o-takashi@sakamocchi.jp>
>     ALSA: firewire-tascam: check intermediate state of clock status and retry
> 
> Takashi Sakamoto <o-takashi@sakamocchi.jp>
>     ALSA: firewire-tascam: handle error code when getting current source of clock
> 
> Luca Coelho <luciano.coelho@intel.com>
>     iwlwifi: fw: don't send GEO_TX_POWER_LIMIT command to FW version 36
> 
> MyungJoo Ham <myungjoo.ham@samsung.com>
>     PM / devfreq: passive: fix compiler warning
> 
> Sakari Ailus <sakari.ailus@linux.intel.com>
>     media: omap3isp: Set device on omap3isp subdevs
> 
> Qu Wenruo <wqu@suse.com>
>     btrfs: extent-tree: Make sure we only allocate extents from block groups with the same type
> 
> Kai-Heng Feng <kai.heng.feng@canonical.com>
>     iommu/amd: Override wrong IVRS IOAPIC on Raven Ridge systems
> 
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/realtek - Blacklist PC beep for Lenovo ThinkCentre M73/93
> 
> Tomas Bortoli <tomasbortoli@gmail.com>
>     media: ttusb-dec: Fix info-leak in ttusb_dec_send_command()
> 
> Ahzo <Ahzo@tutanota.com>
>     drm/amd/powerplay/smu7: enforce minimal VBITimeout (v2)
> 
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda - Drop unsol event handler for Intel HDMI codecs
> 
> Kai-Heng Feng <kai.heng.feng@canonical.com>
>     e1000e: add workaround for possible stalled packet
> 
> Kevin Easton <kevin@guarana.org>
>     libertas: Add missing sentinel at end of if_usb.c fw_table
> 
> Nigel Croxon <ncroxon@redhat.com>
>     raid5: don't increment read_errors on EILSEQ return
> 
> Ulf Hansson <ulf.hansson@linaro.org>
>     mmc: dw_mmc: Re-store SDIO IRQs mask at system resume
> 
> Ulf Hansson <ulf.hansson@linaro.org>
>     mmc: core: Add helper function to indicate if SDIO IRQs is enabled
> 
> Al Cooper <alcooperx@gmail.com>
>     mmc: sdhci: Fix incorrect switch to HS mode
> 
> Ulf Hansson <ulf.hansson@linaro.org>
>     mmc: core: Clarify sdio_irq_pending flag for MMC_CAP2_SDIO_IRQ_NOTHREAD
> 
> Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
>     raid5: don't set STRIPE_HANDLE to stripe which is in batch list
> 
> Peter Ujfalusi <peter.ujfalusi@ti.com>
>     ASoC: dmaengine: Make the pcm->name equal to pcm->id if the name is not set
> 
> M. Vefa Bicakci <m.v.b@runbox.com>
>     platform/x86: intel_pmc_core: Do not ioremap RAM
> 
> Gayatri Kammela <gayatri.kammela@intel.com>
>     x86/cpu: Add Tiger Lake to Intel family
> 
> Harald Freudenberger <freude@linux.ibm.com>
>     s390/crypto: xts-aes-s390 fix extra run-time crypto self tests finding
> 
> Masami Hiramatsu <mhiramat@kernel.org>
>     kprobes: Prohibit probing on BUG() and WARN() address
> 
> Peter Ujfalusi <peter.ujfalusi@ti.com>
>     dmaengine: ti: edma: Do not reset reserved paRAM slots
> 
> Yufen Yu <yuyufen@huawei.com>
>     md/raid1: fail run raid1 array when active disk less than one
> 
> Wang Shenran <shenran268@gmail.com>
>     hwmon: (acpi_power_meter) Change log level for 'unsafe software power cap'
> 
> Kent Overstreet <kent.overstreet@gmail.com>
>     closures: fix a race on wakeup from closure_sync
> 
> Wenwen Wang <wenwen@cs.uga.edu>
>     ACPI / PCI: fix acpi_pci_irq_enable() memory leak
> 
> Wenwen Wang <wenwen@cs.uga.edu>
>     ACPI: custom_method: fix memory leaks
> 
> Marek Szyprowski <m.szyprowski@samsung.com>
>     ARM: dts: exynos: Mark LDO10 as always-on on Peach Pit/Pi Chromebooks
> 
> Tzvetomir Stoyanov <tstoyanov@vmware.com>
>     libtraceevent: Change users plugin directory
> 
> Eric Dumazet <edumazet@google.com>
>     iommu/iova: Avoid false sharing on fq_timer_on
> 
> Dan Williams <dan.j.williams@intel.com>
>     libata/ahci: Drop PCS quirk for Denverton and beyond
> 
> Qian Cai <cai@lca.pw>
>     iommu/amd: Silence warnings under memory pressure
> 
> Takashi Sakamoto <o-takashi@sakamocchi.jp>
>     ALSA: firewire-motu: add support for MOTU 4pre
> 
> Anton Eidelman <anton@lightbitslabs.com>
>     nvme-multipath: fix ana log nsid lookup when nsid is not found
> 
> Tom Wu <tomwu@mellanox.com>
>     nvmet: fix data units read and written counters in SMART log
> 
> Song Liu <songliubraving@fb.com>
>     x86/mm/pti: Handle unaligned address gracefully in pti_clone_pagetable()
> 
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: fsl_ssi: Fix clock control issue in master mode
> 
> Thomas Gleixner <tglx@linutronix.de>
>     x86/mm/pti: Do not invoke PTI functions when PTI is disabled
> 
> Mark Rutland <mark.rutland@arm.com>
>     arm64: kpti: ensure patched kernel text is fetched from PoU
> 
> Neil Horman <nhorman@tuxdriver.com>
>     x86/apic/vector: Warn when vector space exhaustion breaks affinity
> 
> Douglas RAILLARD <douglas.raillard@arm.com>
>     sched/cpufreq: Align trace event behavior of fast switching
> 
> Al Stone <ahs3@redhat.com>
>     ACPI / CPPC: do not require the _PSD method
> 
> Katsuhiro Suzuki <katsuhiro@katsuster.net>
>     ASoC: es8316: fix headphone mixer volume table
> 
> Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
>     media: ov9650: add a sanity check
> 
> Benjamin Peterson <benjamin@python.org>
>     perf trace beauty ioctl: Fix off-by-one error in cmd->string table
> 
> Maciej S. Szmigiero <mail@maciej.szmigiero.name>
>     media: saa7134: fix terminology around saa7134_i2c_eeprom_md7134_gate()
> 
> Wenwen Wang <wenwen@cs.uga.edu>
>     media: cpia2_usb: fix memory leaks
> 
> Wenwen Wang <wenwen@cs.uga.edu>
>     media: saa7146: add cleanup in hexium_attach()
> 
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: cec-notifier: clear cec_adap in cec_notifier_unregister
> 
> Kamil Konieczny <k.konieczny@partner.samsung.com>
>     PM / devfreq: exynos-bus: Correct clock enable sequence
> 
> Leonard Crestez <leonard.crestez@nxp.com>
>     PM / devfreq: passive: Use non-devm notifiers
> 
> Yazen Ghannam <yazen.ghannam@amd.com>
>     EDAC/amd64: Decode syndrome before translating address
> 
> Yazen Ghannam <yazen.ghannam@amd.com>
>     EDAC/amd64: Recognize DRAM device type ECC capability
> 
> Gerald BAEZA <gerald.baeza@st.com>
>     libperf: Fix alignment trap with xyarray contents in 'perf stat'
> 
> Wenwen Wang <wenwen@cs.uga.edu>
>     media: dvb-core: fix a memory leak bug
> 
> Thomas Gleixner <tglx@linutronix.de>
>     posix-cpu-timers: Sanitize bogus WARNONS
> 
> Sean Young <sean@mess.org>
>     media: dvb-frontends: use ida for pll number
> 
> A Sun <as1033x@comcast.net>
>     media: mceusb: fix (eliminate) TX IR signal length limit
> 
> Mike Christie <mchristi@redhat.com>
>     nbd: add missing config put
> 
> Wenwen Wang <wenwen@cs.uga.edu>
>     led: triggers: Fix a memory leak bug
> 
> Maxime Ripard <maxime.ripard@bootlin.com>
>     ASoC: sun4i-i2s: Don't use the oversample to calculate BCLK
> 
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     tools headers: Fixup bitsperlong per arch includes
> 
> Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>     ASoC: uniphier: Fix double reset assersion when transitioning to suspend state
> 
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: hdpvr: add terminating 0 at end of string
> 
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: radio/si470x: kill urb on error
> 
> Stefan Agner <stefan.agner@toradex.com>
>     ARM: dts: imx7-colibri: disable HS400
> 
> André Draszik <git@andred.net>
>     ARM: dts: imx7d: cl-som-imx7: make ethernet work again
> 
> Finn Thain <fthain@telegraphics.com.au>
>     m68k: Prevent some compiler warnings in Coldfire builds
> 
> Arnd Bergmann <arnd@arndb.de>
>     net: lpc-enet: fix printk format strings
> 
> Ezequiel Garcia <ezequiel@collabora.com>
>     media: imx: mipi csi-2: Don't fail if initial state times-out
> 
> Sakari Ailus <sakari.ailus@linux.intel.com>
>     media: omap3isp: Don't set streaming state on random subdevs
> 
> Ezequiel Garcia <ezequiel@collabora.com>
>     media: i2c: ov5645: Fix power sequence
> 
> Colin Ian King <colin.king@canonical.com>
>     media: vsp1: fix memory leak of dl on error return path
> 
> Tan Xiaojun <tanxiaojun@huawei.com>
>     perf record: Support aarch64 random socket_id assignment
> 
> Arnd Bergmann <arnd@arndb.de>
>     dmaengine: iop-adma: use correct printk format strings
> 
> Darius Rad <alpha@area49.net>
>     media: rc: imon: Allow iMON RC protocol for ffdc 7e device
> 
> Sean Young <sean@mess.org>
>     media: em28xx: modules workqueue not inited for 2nd device
> 
> Geert Uytterhoeven <geert+renesas@glider.be>
>     media: fdp1: Reduce FCP not found message level to debug
> 
> Matthias Brugger <matthias.bgg@gmail.com>
>     media: mtk-mdp: fix reference count on old device tree
> 
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf test vfs_getname: Disable ~/.perfconfig to get default output
> 
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf config: Honour $PERF_CONFIG env var to specify alternate .perfconfig
> 
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: gspca: zero usb_buf on error
> 
> Peter Zijlstra <peterz@infradead.org>
>     idle: Prevent late-arriving interrupts from disrupting offline
> 
> Phil Auld <pauld@redhat.com>
>     sched/fair: Use rq_lock/unlock in online_fair_sched_group
> 
> Sudeep Holla <sudeep.holla@arm.com>
>     firmware: arm_scmi: Check if platform has released shmem before using
> 
> Xiaofei Tan <tanxiaofei@huawei.com>
>     efi: cper: print AER info of PCIe fatal error
> 
> Stephen Douthit <stephend@silicom-usa.com>
>     EDAC, pnd2: Fix ioremap() size in dnv_rd_reg()
> 
> Alessio Balsini <balsini@android.com>
>     loop: Add LOOP_SET_DIRECT_IO to compat ioctl
> 
> Jiri Slaby <jslaby@suse.cz>
>     ACPI / processor: don't print errors for processorIDs == 0xff
> 
> Valdis Kletnieks <valdis.kletnieks@vt.edu>
>     RAS: Fix prototype warnings
> 
> Randy Dunlap <rdunlap@infradead.org>
>     media: media/platform: fsl-viu.c: fix build for MICROBLAZE
> 
> Guoqing Jiang <jgq516@gmail.com>
>     md: don't set In_sync if array is frozen
> 
> Guoqing Jiang <jgq516@gmail.com>
>     md: don't call spare_active in md_reap_sync_thread if all member devices can't work
> 
> Yufen Yu <yuyufen@huawei.com>
>     md/raid1: end bio when the device faulty
> 
> Qian Cai <cai@lca.pw>
>     arm64/prefetch: fix a -Wtype-limits warning
> 
> Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>     ASoC: rsnd: don't call clk_get_rate() under atomic context
> 
> Dan Carpenter <dan.carpenter@oracle.com>
>     EDAC/altera: Use the proper type for the IRQ status bits
> 
> chenzefeng <chenzefeng2@huawei.com>
>     ia64:unwind: fix double free for mod->arch.init_unw_table
> 
> Ard van Breemen <ard@kwaak.net>
>     ALSA: usb-audio: Skip bSynchAddress endpoint check if it is invalid
> 
> Vinod Koul <vkoul@kernel.org>
>     base: soc: Export soc_device_register/unregister APIs
> 
> Oliver Neukum <oneukum@suse.com>
>     media: iguanair: add sanity checks
> 
> Robert Richter <rrichter@marvell.com>
>     EDAC/mc: Fix grain_bits calculation
> 
> Jia-Ju Bai <baijiaju1990@gmail.com>
>     ALSA: i2c: ak4xxx-adda: Fix a possible null pointer dereference in build_adc_controls()
> 
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda - Show the fatal CORB/RIRB error more clearly
> 
> Thomas Gleixner <tglx@linutronix.de>
>     x86/apic: Soft disable APIC before initializing it
> 
> Grzegorz Halat <ghalat@redhat.com>
>     x86/reboot: Always use NMI fallback when shutdown via reboot vector IPI fails
> 
> Juri Lelli <juri.lelli@redhat.com>
>     sched/deadline: Fix bandwidth accounting at all levels after offline migration
> 
> Thomas Gleixner <tglx@linutronix.de>
>     x86/apic: Make apic_pending_intr_clear() more robust
> 
> Juri Lelli <juri.lelli@redhat.com>
>     sched/core: Fix CPU controller for !RT_GROUP_SCHED
> 
> Vincent Guittot <vincent.guittot@linaro.org>
>     sched/fair: Fix imbalance due to CPU affinity
> 
> Paul E. McKenney <paulmck@linux.ibm.com>
>     time/tick-broadcast: Fix tick_broadcast_offline() lockdep complaint
> 
> Fabio Estevam <festevam@gmail.com>
>     media: i2c: ov5640: Check for devm_gpiod_get_optional() error
> 
> Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
>     media: hdpvr: Add device num check and handling
> 
> Wen Yang <wen.yang99@zte.com.cn>
>     media: exynos4-is: fix leaked of_node references
> 
> Sean Young <sean@mess.org>
>     media: mtk-cir: lower de-glitch counter for rc-mm protocol
> 
> Arnd Bergmann <arnd@arndb.de>
>     media: dib0700: fix link error for dibx000_i2c_set_speed
> 
> Nick Stoughton <nstoughton@logitech.com>
>     leds: leds-lp5562 allow firmware files up to the maximum length
> 
> Stefan Wahren <wahrenst@gmx.net>
>     dmaengine: bcm2835: Print error in case setting DMA mask fails
> 
> Stephen Boyd <swboyd@chromium.org>
>     firmware: qcom_scm: Use proper types for dma mappings
> 
> Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
>     ASoC: sgtl5000: Fix charge pump source assignment
> 
> Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
>     ASoC: sgtl5000: Fix of unmute outputs on probe
> 
> Lucas Stach <l.stach@pengutronix.de>
>     ASoC: tlv320aic31xx: suppress error message for EPROBE_DEFER
> 
> Axel Lin <axel.lin@ingics.com>
>     regulator: lm363x: Fix off-by-one n_voltages for lm3632 ldo_vpos/ldo_vneg
> 
> Chris Wilson <chris@chris-wilson.co.uk>
>     ALSA: hda: Flush interrupts on disabling
> 
> Navid Emamdoost <navid.emamdoost@gmail.com>
>     nfp: flower: prevent memory leak in nfp_flower_spawn_phy_reprs
> 
> Ori Nimron <orinimron123@gmail.com>
>     nfc: enforce CAP_NET_RAW for raw sockets
> 
> Ori Nimron <orinimron123@gmail.com>
>     ieee802154: enforce CAP_NET_RAW for raw sockets
> 
> Ori Nimron <orinimron123@gmail.com>
>     ax25: enforce CAP_NET_RAW for raw sockets
> 
> Ori Nimron <orinimron123@gmail.com>
>     appletalk: enforce CAP_NET_RAW for raw sockets
> 
> Ori Nimron <orinimron123@gmail.com>
>     mISDN: enforce CAP_NET_RAW for raw sockets
> 
> Bodong Wang <bodong@mellanox.com>
>     net/mlx5: Add device ID of upcoming BlueField-2
> 
> Eric Dumazet <edumazet@google.com>
>     tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state
> 
> Eric Dumazet <edumazet@google.com>
>     net: sched: fix possible crash in tcf_action_destroy()
> 
> Oliver Neukum <oneukum@suse.com>
>     usbnet: sanity checking of packet sizes and device mtu
> 
> Bjørn Mork <bjorn@mork.no>
>     usbnet: ignore endpoints with invalid wMaxPacketSize
> 
> Stephen Hemminger <stephen@networkplumber.org>
>     skge: fix checksum byte order
> 
> Eric Dumazet <edumazet@google.com>
>     sch_netem: fix a divide by zero in tabledist()
> 
> Takeshi Misawa <jeliantsurux@gmail.com>
>     ppp: Fix memory leak in ppp_write
> 
> Li RongQing <lirongqing@baidu.com>
>     openvswitch: change type of UPCALL_PID attribute to NLA_UNSPEC
> 
> Navid Emamdoost <navid.emamdoost@gmail.com>
>     nfp: flower: fix memory leak in nfp_flower_spawn_vnic_reprs
> 
> Cong Wang <xiyou.wangcong@gmail.com>
>     net_sched: add max len check for TCA_KIND
> 
> Davide Caratti <dcaratti@redhat.com>
>     net/sched: act_sample: don't push mac header on ip6gre ingress
> 
> Bjorn Andersson <bjorn.andersson@linaro.org>
>     net: qrtr: Stop rx_worker before freeing node
> 
> Peter Mamonov <pmamonov@gmail.com>
>     net/phy: fix DP83865 10 Mbps HDX loopback disable function
> 
> Xin Long <lucien.xin@gmail.com>
>     macsec: drop skb sk before calling gro_cells_receive
> 
> Bjørn Mork <bjorn@mork.no>
>     cdc_ncm: fix divide-by-zero caused by invalid wMaxPacketSize
> 
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>     arcnet: provide a buffer big enough to actually receive packets
> 
> 
> -------------
> 
> Diffstat:
> 
>  Makefile                                          |   4 +-
>  arch/arm/boot/dts/exynos5420-peach-pit.dts        |   1 +
>  arch/arm/boot/dts/exynos5800-peach-pi.dts         |   1 +
>  arch/arm/boot/dts/imx7-colibri.dtsi               |   1 +
>  arch/arm/boot/dts/imx7d-cl-som-imx7.dts           |   4 +-
>  arch/arm/mach-zynq/platsmp.c                      |   2 +-
>  arch/arm/plat-samsung/watchdog-reset.c            |   1 +
>  arch/arm64/boot/dts/rockchip/rk3328.dtsi          |   3 +
>  arch/arm64/include/asm/cputype.h                  |  21 +-
>  arch/arm64/include/asm/pgtable.h                  |   6 +-
>  arch/arm64/include/asm/tlbflush.h                 |   1 +
>  arch/arm64/kernel/cpufeature.c                    |   2 +-
>  arch/arm64/mm/proc.S                              |   9 +
>  arch/ia64/kernel/module.c                         |   8 +-
>  arch/m68k/include/asm/atarihw.h                   |   9 -
>  arch/m68k/include/asm/io_mm.h                     |   6 +-
>  arch/m68k/include/asm/macintosh.h                 |   1 +
>  arch/powerpc/platforms/powernv/opal-imc.c         |  12 +-
>  arch/s390/crypto/aes_s390.c                       |   6 +
>  arch/x86/include/asm/intel-family.h               |   3 +
>  arch/x86/kernel/apic/apic.c                       | 115 +++++---
>  arch/x86/kernel/apic/vector.c                     |  11 +
>  arch/x86/kernel/smp.c                             |  46 +--
>  arch/x86/kvm/emulate.c                            |   2 +
>  arch/x86/kvm/x86.c                                |  21 +-
>  arch/x86/mm/pti.c                                 |   8 +-
>  block/blk-flush.c                                 |  10 +
>  block/blk-mq.c                                    |   5 +-
>  block/blk.h                                       |   7 +
>  drivers/acpi/acpi_processor.c                     |  10 +-
>  drivers/acpi/cppc_acpi.c                          |   6 +-
>  drivers/acpi/custom_method.c                      |   5 +-
>  drivers/acpi/pci_irq.c                            |   4 +-
>  drivers/ata/ahci.c                                | 116 +++++---
>  drivers/ata/ahci.h                                |   2 +
>  drivers/base/soc.c                                |   2 +
>  drivers/block/loop.c                              |   1 +
>  drivers/block/nbd.c                               |   4 +-
>  drivers/char/hw_random/core.c                     |   2 +-
>  drivers/char/mem.c                                |  21 ++
>  drivers/devfreq/exynos-bus.c                      |  31 +-
>  drivers/devfreq/governor_passive.c                |   7 +-
>  drivers/dma/bcm2835-dma.c                         |   4 +-
>  drivers/dma/iop-adma.c                            |  18 +-
>  drivers/dma/ti/edma.c                             |   9 +-
>  drivers/edac/altera_edac.c                        |   4 +-
>  drivers/edac/amd64_edac.c                         |  28 +-
>  drivers/edac/edac_mc.c                            |   8 +-
>  drivers/edac/pnd2_edac.c                          |   7 +-
>  drivers/firmware/arm_scmi/driver.c                |   8 +
>  drivers/firmware/efi/cper.c                       |  15 +
>  drivers/firmware/qcom_scm.c                       |   7 +-
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   1 +
>  drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c  |   5 +
>  drivers/hwmon/acpi_power_meter.c                  |   4 +-
>  drivers/i2c/busses/i2c-riic.c                     |   1 +
>  drivers/infiniband/hw/hfi1/mad.c                  |  45 ++-
>  drivers/infiniband/hw/mlx5/main.c                 |   1 +
>  drivers/iommu/Makefile                            |   2 +-
>  drivers/iommu/amd_iommu.c                         |   4 +-
>  drivers/iommu/amd_iommu.h                         |  14 +
>  drivers/iommu/amd_iommu_init.c                    |   5 +-
>  drivers/iommu/amd_iommu_quirks.c                  |  92 ++++++
>  drivers/iommu/iova.c                              |   4 +-
>  drivers/isdn/mISDN/socket.c                       |   2 +
>  drivers/leds/led-triggers.c                       |   1 +
>  drivers/leds/leds-lp5562.c                        |   6 +-
>  drivers/md/bcache/closure.c                       |  10 +-
>  drivers/md/dm-rq.c                                |   1 +
>  drivers/md/md.c                                   |  28 +-
>  drivers/md/md.h                                   |   3 +
>  drivers/md/raid0.c                                |  33 ++-
>  drivers/md/raid0.h                                |  14 +
>  drivers/md/raid1.c                                |  39 ++-
>  drivers/md/raid5.c                                |  10 +-
>  drivers/media/cec/cec-notifier.c                  |   2 +
>  drivers/media/dvb-core/dvb_frontend.c             |   4 +-
>  drivers/media/dvb-core/dvbdev.c                   |   4 +-
>  drivers/media/dvb-frontends/dvb-pll.c             |  40 +--
>  drivers/media/i2c/ov5640.c                        |   5 +
>  drivers/media/i2c/ov5645.c                        |  26 +-
>  drivers/media/i2c/ov9650.c                        |   5 +
>  drivers/media/pci/saa7134/saa7134-i2c.c           |  12 +-
>  drivers/media/pci/saa7146/hexium_gemini.c         |   3 +
>  drivers/media/platform/exynos4-is/fimc-is.c       |   1 +
>  drivers/media/platform/exynos4-is/media-dev.c     |   2 +
>  drivers/media/platform/fsl-viu.c                  |   2 +-
>  drivers/media/platform/mtk-mdp/mtk_mdp_core.c     |   4 +-
>  drivers/media/platform/omap3isp/isp.c             |   8 +
>  drivers/media/platform/omap3isp/ispccdc.c         |   1 +
>  drivers/media/platform/omap3isp/ispccp2.c         |   1 +
>  drivers/media/platform/omap3isp/ispcsi2.c         |   1 +
>  drivers/media/platform/omap3isp/isppreview.c      |   1 +
>  drivers/media/platform/omap3isp/ispresizer.c      |   1 +
>  drivers/media/platform/omap3isp/ispstat.c         |   2 +
>  drivers/media/platform/rcar_fdp1.c                |   2 +-
>  drivers/media/platform/vsp1/vsp1_dl.c             |   4 +-
>  drivers/media/radio/si470x/radio-si470x-usb.c     |   5 +-
>  drivers/media/rc/iguanair.c                       |  15 +-
>  drivers/media/rc/imon.c                           |   7 +-
>  drivers/media/rc/mceusb.c                         | 334 +++++++++++++---------
>  drivers/media/rc/mtk-cir.c                        |   8 +
>  drivers/media/usb/cpia2/cpia2_usb.c               |   4 +
>  drivers/media/usb/dvb-usb/dib0700_devices.c       |   8 +
>  drivers/media/usb/dvb-usb/pctv452e.c              |   8 -
>  drivers/media/usb/em28xx/em28xx-cards.c           |   1 -
>  drivers/media/usb/gspca/konica.c                  |   5 +
>  drivers/media/usb/gspca/nw80x.c                   |   5 +
>  drivers/media/usb/gspca/ov519.c                   |  10 +
>  drivers/media/usb/gspca/ov534.c                   |   5 +
>  drivers/media/usb/gspca/ov534_9.c                 |   1 +
>  drivers/media/usb/gspca/se401.c                   |   5 +
>  drivers/media/usb/gspca/sn9c20x.c                 |  12 +
>  drivers/media/usb/gspca/sonixb.c                  |   5 +
>  drivers/media/usb/gspca/sonixj.c                  |   5 +
>  drivers/media/usb/gspca/spca1528.c                |   5 +
>  drivers/media/usb/gspca/sq930x.c                  |   5 +
>  drivers/media/usb/gspca/sunplus.c                 |   5 +
>  drivers/media/usb/gspca/vc032x.c                  |   5 +
>  drivers/media/usb/gspca/w996Xcf.c                 |   5 +
>  drivers/media/usb/hdpvr/hdpvr-core.c              |  13 +-
>  drivers/media/usb/ttusb-dec/ttusb_dec.c           |   2 +-
>  drivers/mmc/core/sdio_irq.c                       |   9 +-
>  drivers/mmc/host/dw_mmc.c                         |   4 +
>  drivers/mmc/host/sdhci.c                          |   4 +-
>  drivers/net/arcnet/arcnet.c                       |  31 +-
>  drivers/net/ethernet/intel/e1000e/ich8lan.c       |  10 +
>  drivers/net/ethernet/intel/e1000e/ich8lan.h       |   2 +-
>  drivers/net/ethernet/intel/i40e/i40e_main.c       |   5 +
>  drivers/net/ethernet/marvell/skge.c               |   2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/main.c    |   1 +
>  drivers/net/ethernet/netronome/nfp/flower/main.c  |   6 +
>  drivers/net/ethernet/nxp/lpc_eth.c                |  13 +-
>  drivers/net/macsec.c                              |   1 +
>  drivers/net/phy/national.c                        |   9 +-
>  drivers/net/ppp/ppp_generic.c                     |   2 +
>  drivers/net/usb/cdc_ncm.c                         |   6 +-
>  drivers/net/usb/usbnet.c                          |   8 +
>  drivers/net/wireless/intel/iwlwifi/mvm/fw.c       |   8 +-
>  drivers/net/wireless/marvell/libertas/if_usb.c    |   3 +-
>  drivers/nvme/host/multipath.c                     |   8 +-
>  drivers/nvme/target/admin-cmd.c                   |  14 +-
>  drivers/parisc/dino.c                             |  24 ++
>  drivers/platform/x86/intel_pmc_core.c             |   8 +-
>  drivers/ras/cec.c                                 |   1 +
>  drivers/ras/debugfs.c                             |   2 +
>  drivers/regulator/core.c                          |  42 ++-
>  drivers/regulator/lm363x-regulator.c              |   2 +-
>  drivers/scsi/device_handler/scsi_dh_rdac.c        |   2 +
>  drivers/scsi/qla2xxx/qla_init.c                   |  25 +-
>  drivers/scsi/qla2xxx/qla_os.c                     |   1 +
>  drivers/scsi/qla2xxx/qla_target.c                 |   1 -
>  drivers/scsi/scsi_lib.c                           |  13 +
>  drivers/staging/media/imx/imx6-mipi-csi2.c        |  12 +-
>  drivers/video/fbdev/efifb.c                       |  27 +-
>  fs/binfmt_elf.c                                   |   3 +-
>  fs/btrfs/ctree.c                                  |   5 +-
>  fs/btrfs/ctree.h                                  |   1 +
>  fs/btrfs/extent-tree.c                            |   8 +
>  fs/btrfs/free-space-cache.c                       |  18 +-
>  fs/btrfs/inode.c                                  |   8 +
>  fs/btrfs/qgroup.c                                 |  38 ++-
>  fs/ceph/inode.c                                   |   3 +
>  fs/ceph/super.c                                   |   1 +
>  fs/ceph/super.h                                   |   1 +
>  fs/cifs/cifsfs.c                                  |   2 +
>  fs/cifs/cifsglob.h                                |   2 +
>  fs/cifs/connect.c                                 |   9 +-
>  fs/cifs/smb2ops.c                                 |   5 +
>  fs/cifs/smb2pdu.c                                 |   2 +-
>  fs/cifs/xattr.c                                   |   2 +-
>  fs/ext4/extents.c                                 |   4 +-
>  fs/ext4/inode.c                                   |   9 +
>  fs/fuse/dev.c                                     |  89 +++---
>  fs/fuse/file.c                                    |   1 +
>  fs/fuse/fuse_i.h                                  |   3 +
>  fs/fuse/inode.c                                   |   1 +
>  fs/gfs2/bmap.c                                    |   1 +
>  fs/overlayfs/export.c                             |   3 +-
>  fs/overlayfs/inode.c                              |   3 +-
>  include/linux/blk-mq.h                            |  13 +
>  include/linux/bug.h                               |   5 +
>  include/linux/mmc/host.h                          |   9 +
>  include/linux/quotaops.h                          |   2 +-
>  kernel/kprobes.c                                  |   3 +-
>  kernel/printk/printk.c                            |   2 +-
>  kernel/sched/core.c                               |  61 +++-
>  kernel/sched/cpufreq_schedutil.c                  |   7 +-
>  kernel/sched/deadline.c                           |  33 +++
>  kernel/sched/fair.c                               |  11 +-
>  kernel/sched/idle.c                               |   5 +-
>  kernel/time/alarmtimer.c                          |   4 +-
>  kernel/time/posix-cpu-timers.c                    |  20 +-
>  mm/compaction.c                                   |  35 +--
>  mm/memcontrol.c                                   |  10 +
>  mm/oom_kill.c                                     |   5 +-
>  net/appletalk/ddp.c                               |   5 +
>  net/ax25/af_ax25.c                                |   2 +
>  net/ieee802154/socket.c                           |   3 +
>  net/ipv4/tcp_timer.c                              |   5 +-
>  net/nfc/llcp_sock.c                               |   7 +-
>  net/openvswitch/datapath.c                        |   2 +-
>  net/qrtr/qrtr.c                                   |   1 +
>  net/sched/act_sample.c                            |   1 +
>  net/sched/cls_api.c                               |   6 +-
>  net/sched/sch_api.c                               |   3 +-
>  net/sched/sch_netem.c                             |   2 +-
>  net/wireless/util.c                               |   1 +
>  scripts/gcc-plugins/randomize_layout_plugin.c     |  10 +-
>  sound/firewire/motu/motu.c                        |  12 +
>  sound/firewire/tascam/tascam-pcm.c                |   3 +
>  sound/firewire/tascam/tascam-stream.c             |  42 ++-
>  sound/hda/hdac_controller.c                       |   2 +
>  sound/i2c/other/ak4xxx-adda.c                     |   7 +-
>  sound/pci/hda/hda_controller.c                    |   5 +-
>  sound/pci/hda/hda_intel.c                         |   2 +-
>  sound/pci/hda/patch_hdmi.c                        |   9 +-
>  sound/pci/hda/patch_realtek.c                     |  16 ++
>  sound/soc/codecs/es8316.c                         |   7 +-
>  sound/soc/codecs/sgtl5000.c                       |  21 +-
>  sound/soc/codecs/tlv320aic31xx.c                  |   7 +-
>  sound/soc/fsl/fsl_ssi.c                           |  18 +-
>  sound/soc/intel/common/sst-ipc.c                  |   2 +
>  sound/soc/intel/skylake/skl-debug.c               |   2 +-
>  sound/soc/intel/skylake/skl-nhlt.c                |   2 +-
>  sound/soc/sh/rcar/adg.c                           |  21 +-
>  sound/soc/soc-generic-dmaengine-pcm.c             |   6 +
>  sound/soc/sunxi/sun4i-i2s.c                       |   9 +-
>  sound/soc/uniphier/aio-cpu.c                      |  31 +-
>  sound/soc/uniphier/aio.h                          |   1 +
>  sound/usb/pcm.c                                   |   1 +
>  tools/include/uapi/asm/bitsperlong.h              |  18 +-
>  tools/lib/traceevent/Makefile                     |   6 +-
>  tools/lib/traceevent/event-plugin.c               |   2 +-
>  tools/perf/perf.c                                 |   3 +
>  tools/perf/tests/shell/trace+probe_vfs_getname.sh |   4 +
>  tools/perf/trace/beauty/ioctl.c                   |   2 +-
>  tools/perf/util/header.c                          |   4 +-
>  tools/perf/util/xyarray.h                         |   3 +-
>  239 files changed, 1877 insertions(+), 776 deletions(-)
> 
> 
> 

