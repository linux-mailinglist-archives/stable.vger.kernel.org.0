Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C6445DE52
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 17:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356368AbhKYQMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 11:12:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:35818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356366AbhKYQKo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 11:10:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 630AD60200;
        Thu, 25 Nov 2021 16:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637856452;
        bh=mp+Mziysh7cmoUls3juc40ixQPVOEagfe/lQ1JXotto=;
        h=From:To:Cc:Subject:Date:From;
        b=CMA1Mrnr2e0whabqBGwp93fyKjreSrUmYLtCbivyfn+uBgqQhrKL7R5xHRhXwiz0G
         VtRiUR3CI13UYkaMAoZMWSgsi3tYzxRvAPqH8WQEnc+Oc+d4QAXcE1RxH0JdrNccpS
         wDxDKY9MRuhWFIBj2NZiN9lzIa/uXfL+mHnhW0qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 000/159] 4.4.293-rc3 review
Date:   Thu, 25 Nov 2021 17:07:18 +0100
Message-Id: <20211125160503.347646915@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.293-rc3.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.293-rc3
X-KernelTest-Deadline: 2021-11-27T16:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.293 release.
There are 159 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 27 Nov 2021 16:04:43 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.293-rc3.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.293-rc3

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    usb: max-3421: Use driver data instead of maintaining a list of bound devices

Takashi Iwai <tiwai@suse.de>
    ASoC: DAPM: Cover regression by kctl change notification fix

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid WARN_ON timing related checks

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't always reallocate the fragmentation skb head

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reserve needed_*room for fragments

Sven Eckelmann <sven@narfation.org>
    batman-adv: Consider fragmentation for needed_headroom

Taehee Yoo <ap420073@gmail.com>
    batman-adv: set .owner to THIS_MODULE

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast: fix duplicate mcast packets from BLA backbone to mesh

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast: fix duplicate mcast packets in BLA backbone from mesh

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast: fix duplicate mcast packets in BLA backbone from LAN

Sven Eckelmann <sven@narfation.org>
    batman-adv: Prevent duplicated softif_vlan entry

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: Fix multicast TT issues with bogus ROAM flags

Sven Eckelmann <sven@narfation.org>
    batman-adv: Keep fragments equally sized

hongao <hongao@uniontech.com>
    drm/amdgpu: fix set scaling mode Full/Full aspect/Center not works on vga and dvi connectors

Johan Hovold <johan@kernel.org>
    drm/udl: fix control-message timeout

Nguyen Dinh Phi <phind.uet@gmail.com>
    cfg80211: call cfg80211_stop_ap when switch from P2P_GO type

Sven Schnelle <svens@stackframe.org>
    parisc/sticon: fix reverse colors

Nikolay Borisov <nborisov@suse.com>
    btrfs: fix memory ordering between normal and ordered work functions

Rustam Kovhaev <rkovhaev@gmail.com>
    mm: kmemleak: slob: respect SLAB_NOLEAKTRACE flag

Nathan Chancellor <nathan@kernel.org>
    hexagon: export raw I/O routines for modules

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    tun: fix bonding active backup with arp monitoring

Lin Ma <linma@zju.edu.cn>
    NFC: reorder the logic in nfc_{un,}register_device

Lin Ma <linma@zju.edu.cn>
    NFC: reorganize the functions in nci_request

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    platform/x86: hp_accel: Fix an error handling path in 'lis3lv02d_probe()'

Randy Dunlap <rdunlap@infradead.org>
    mips: bcm63xx: add support for clk_get_parent()

Pavel Skripkin <paskripkin@gmail.com>
    net: bnx2x: fix variable dereferenced before check

Vincent Donnefort <vincent.donnefort@arm.com>
    sched/core: Mitigate race cpus_share_cache()/update_top_cache_domain()

Randy Dunlap <rdunlap@infradead.org>
    mips: BCM63XX: ensure that CPU_SUPPORTS_32BIT_KERNEL is set

Randy Dunlap <rdunlap@infradead.org>
    sh: define __BIG_ENDIAN for math-emu

Randy Dunlap <rdunlap@infradead.org>
    sh: fix kconfig unmet dependency warning for FRAME_POINTER

Lu Wei <luwei32@huawei.com>
    maple: fix wrong return value of maple_bus_init().

Nick Desaulniers <ndesaulniers@google.com>
    sh: check return code of request_irq

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/dcr: Use cmplwi instead of 3-argument cmpli

Chengfeng Ye <cyeaa@connect.ust.hk>
    ALSA: gus: fix null pointer dereference on pointer block

Anatolij Gustschin <agust@denx.de>
    powerpc/5200: dts: fix memory node unit name

Mike Christie <michael.christie@oracle.com>
    scsi: target: Fix alua_tg_pt_gps_count tracking

Mike Christie <michael.christie@oracle.com>
    scsi: target: Fix ordered tag handling

Bart Van Assche <bvanassche@acm.org>
    MIPS: sni: Fix the build

Guanghui Feng <guanghuifeng@linux.alibaba.com>
    tty: tty_buffer: Fix the softlockup issue in flush_to_ldisc

Yang Yingliang <yangyingliang@huawei.com>
    usb: host: ohci-tmio: check return value after calling platform_get_resource()

Roger Quadros <rogerq@kernel.org>
    ARM: dts: omap: fix gpmc,mux-add-data type

Guo Zhi <qtxuning1999@sjtu.edu.cn>
    scsi: advansys: Fix kernel pointer leak

Yang Yingliang <yangyingliang@huawei.com>
    usb: musb: tusb6010: check return value after calling platform_get_resource()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix list_add() corruption in lpfc_drain_txq()

Pavel Skripkin <paskripkin@gmail.com>
    net: batman-adv: fix error handling

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Destroy sysfs before freeing entries

Sven Schnelle <svens@stackframe.org>
    parisc/entry: fix trace test in syscall exit path

Pali Rohár <pali@kernel.org>
    PCI: Add PCI_EXP_DEVCTL_PAYLOAD_* macros

Vasily Averin <vvs@virtuozzo.com>
    mm, oom: pagefault_out_of_memory: don't force global OOM for dying tasks

Arnd Bergmann <arnd@arndb.de>
    ARM: 9156/1: drop cc-option fallbacks for architecture selection

Johan Hovold <johan@kernel.org>
    USB: chipidea: fix interrupt deadlock

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    vsock: prevent unnecessary refcnt inc for nonblocking connect

Chengfeng Ye <cyeaa@connect.ust.hk>
    nfc: pn533: Fix double free when pn533_fill_fragment_skbs() fails

Eric Dumazet <edumazet@google.com>
    llc: fix out-of-bound array index in llc_sk_dev_hash()

Huang Guobin <huangguobin4@huawei.com>
    bonding: Fix a use-after-free problem when bond_sysfs_slave_add() failed

Maxim Kiselev <bigunclemax@gmail.com>
    net: davinci_emac: Fix interrupt pacing disable

YueHaibing <yuehaibing@huawei.com>
    xen-pciback: Fix return in pm_ctrl_init()

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Turn off target reset during issue_lip

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: fix inaccurate report in WDIOC_GETTIMEOUT

Randy Dunlap <rdunlap@infradead.org>
    m68k: set a default value for MEMORY_RESERVE

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_queue: fix OOB when mac header was cleared

Claudiu Beznea <claudiu.beznea@microchip.com>
    dmaengine: at_xdmac: fix AT_XDMAC_CC_PERID() macro

Leon Romanovsky <leonro@nvidia.com>
    RDMA/mlx4: Return missed an error if device doesn't support steering

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: csiostor: Uninitialized data in csio_ln_vnp_read_cbfn()

Jakob Hauser <jahau@rocketmail.com>
    power: supply: rt5033_battery: Change voltage values to µV

Dan Carpenter <dan.carpenter@oracle.com>
    usb: gadget: hid: fix error code in do_config()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_dw: Drop wrong use of ACPI_PTR()

Christophe Leroy <christophe.leroy@csgroup.eu>
    video: fbdev: chipsfb: use memset_io() instead of memset()

Dongliang Mu <mudongliangabcd@gmail.com>
    memory: fsl_ifc: fix leak of irq and nand_irq in fsl_ifc_ctrl_probe

Dongliang Mu <mudongliangabcd@gmail.com>
    JFS: fix memleak in jfs_mount

Tong Zhang <ztong0001@gmail.com>
    scsi: dc395: Fix error case unwinding

Jackie Liu <liuyun01@kylinos.cn>
    ARM: s3c: irq-s3c24xx: Fix return value check for s3c24xx_init_intc()

Daniel Jordan <daniel.m.jordan@oracle.com>
    crypto: pcrypt - Delay write to padata->info

Wang Hai <wanghai38@huawei.com>
    libertas: Fix possible memory leak in probe and disconnect

Wang Hai <wanghai38@huawei.com>
    libertas_tf: Fix possible memory leak in probe and disconnect

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    smackfs: use netlbl_cfg_cipsov4_del() for deleting cipso_v4_doi

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Send DELBA requests according to spec

Nathan Chancellor <nathan@kernel.org>
    platform/x86: thinkpad_acpi: Fix bitwise vs. logical warning

Jakub Kicinski <kuba@kernel.org>
    net: stream: don't purge sk_error_queue in sk_stream_kill_queues()

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm: uninitialized variable in msm_gem_import()

Dan Carpenter <dan.carpenter@oracle.com>
    memstick: jmb38x_ms: use appropriate free function in jmb38x_ms_alloc_host()

Arnd Bergmann <arnd@arndb.de>
    memstick: avoid out-of-range warning

Dan Carpenter <dan.carpenter@oracle.com>
    b43: fix a lower bounds test

Dan Carpenter <dan.carpenter@oracle.com>
    b43legacy: fix a lower bounds test

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - detect PFVF collision after ACK

Linus Lüssing <ll@simonwunderlich.de>
    ath9k: Fix potential interrupt storm on queue reset

Anel Orazgaliyeva <anelkz@amazon.de>
    cpuidle: Fix kobject memory leaks in error paths

Kees Cook <keescook@chromium.org>
    media: si470x: Avoid card name truncation

Pavel Skripkin <paskripkin@gmail.com>
    media: dvb-usb: fix ununit-value in az6027_rc_query

Sven Schnelle <svens@stackframe.org>
    parisc/kgdb: add kgdb_roundup() to make kgdb work with idle polling

Sven Schnelle <svens@stackframe.org>
    parisc: fix warning in flush_tlb_all

Arnd Bergmann <arnd@arndb.de>
    ARM: 9136/1: ARMv7-M uses BE-8, not BE-32

Masami Hiramatsu <mhiramat@kernel.org>
    ARM: clang: Do not rely on lr register for stacktrace

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    smackfs: use __GFP_NOFAIL for smk_cipso_doi()

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: disable RX-diversity in powersave

Ye Bin <yebin10@huawei.com>
    PM: hibernate: Get block device exclusively in swsusp_check()

Zheyu Ma <zheyuma97@gmail.com>
    mwl8k: Fix use-after-free in mwl8k_fw_state_machine()

Lasse Collin <lasse.collin@tukaani.org>
    lib/xz: Validate the value before assigning it to an enum variable

Lasse Collin <lasse.collin@tukaani.org>
    lib/xz: Avoid overlapping memcpy() with invalid input with in-place decompression

Zheyu Ma <zheyuma97@gmail.com>
    memstick: r592: Fix a UAF bug when removing the driver

André Almeida <andrealmeid@collabora.com>
    ACPI: battery: Accept charges over the design capacity as full

Tuo Li <islituo@gmail.com>
    ath: dfs_pattern_detector: Fix possible null-pointer dereference in channel_detector_create()

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracefs: Have tracefs directories not set OTH permission bits by default

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    media: usb: dvd-usb: fix uninit-value bug in dibusb_read_eeprom_byte()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Avoid evaluating methods too early during system resume

Randy Dunlap <rdunlap@infradead.org>
    ia64: don't do IA64_CMPXCHG_DEBUG without CONFIG_PRINTK

Rajat Asthana <rajatasthana4@gmail.com>
    media: mceusb: return without resubmitting URB in case of -EPROTO error.

Tuo Li <islituo@gmail.com>
    media: s5p-mfc: fix possible null-pointer dereference in s5p_mfc_probe()

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Set capability in s_param

Zheyu Ma <zheyuma97@gmail.com>
    media: netup_unidvb: handle interrupt properly according to the firmware

Dirk Bender <d.bender@phytec.de>
    media: mt9p031: Fix corrupted frame after restarting stream

Peter Zijlstra <peterz@infradead.org>
    x86: Increase exception stack sizes

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    smackfs: Fix use-after-free in netlbl_catmap_walk()

Aleksander Jan Bajkowski <olek2@wp.pl>
    MIPS: lantiq: dma: reset correct number of channel

Aleksander Jan Bajkowski <olek2@wp.pl>
    MIPS: lantiq: dma: add small delay after reset

Barnabás Pőcze <pobrn@protonmail.com>
    platform/x86: wmi: do not fail if disabling fails

Wang ShaoBo <bobo.shaobowang@huawei.com>
    Bluetooth: fix use-after-free error in lock_sock_nested()

Takashi Iwai <tiwai@suse.de>
    Bluetooth: sco: Fix lock_sock() blockage by memcpy_from_msg()

Johan Hovold <johan@kernel.org>
    USB: iowarrior: fix control-message timeouts

Wang Hai <wanghai38@huawei.com>
    USB: serial: keyspan: fix memleak on probe errors

Pekka Korpinen <pekka.korpinen@iki.fi>
    iio: dac: ad5446: Fix ad5622_write() return value

Zhang Yi <yi.zhang@huawei.com>
    quota: correct error number in free_dqentry()

Zhang Yi <yi.zhang@huawei.com>
    quota: check block number when reading the block in quota file

Pavel Skripkin <paskripkin@gmail.com>
    ALSA: mixer: fix deadlock in snd_mixer_oss_set_volume

Takashi Iwai <tiwai@suse.de>
    ALSA: mixer: oss: Fix racy access to slots

Henrik Grimler <henrik@grimler.se>
    power: supply: max17042_battery: use VFSOC for capacity when no rsns

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    power: supply: max17042_battery: Prevent int underflow in set_soc_threshold

Eric W. Biederman <ebiederm@xmission.com>
    signal: Remove the bogus sigkill_pending in ptrace_stop

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Read a PCI register after writing the TX ring write pointer

Loic Poulain <loic.poulain@linaro.org>
    wcn36xx: Fix HT40 capability for 2Ghz band

Ingmar Klein <ingmar_klein@web.de>
    PCI: Mark Atheros QCA6174 to avoid bus reset

Johan Hovold <johan@kernel.org>
    ath6kl: fix control-message timeout

Johan Hovold <johan@kernel.org>
    ath6kl: fix division by zero in send path

Johan Hovold <johan@kernel.org>
    mwifiex: fix division by zero in fw download path

Eric Badger <ebadger@purestorage.com>
    EDAC/sb_edac: Fix top-of-high-memory value for Broadwell/Haswell

Zev Weiss <zev@bewilderbeest.net>
    hwmon: (pmbus/lm25066) Add offset coefficients

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost error handling when replaying directory deletes

Dongli Zhang <dongli.zhang@oracle.com>
    vmxnet3: do not stop tx queues after netif_device_detach()

Thomas Perrot <thomas.perrot@bootlin.com>
    spi: spl022: fix Microwire full duplex mode

Dongli Zhang <dongli.zhang@oracle.com>
    xen/netfront: stop tx queues during live migration

Randy Dunlap <rdunlap@infradead.org>
    mmc: winbond: don't build on M68K

Arnd Bergmann <arnd@arndb.de>
    hyperv/vmbus: include linux/bitops.h

Sean Christopherson <seanjc@google.com>
    x86/irq: Ensure PI wakeup handler is unregistered before module unload

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Unconditionally unlink slave instances, too

Wang Wensheng <wangwensheng4@huawei.com>
    ALSA: timer: Fix use-after-free problem

Austin Kim <austin.kim@lge.com>
    ALSA: synth: missing check for possible NULL after the call to kstrdup

Johan Hovold <johan@kernel.org>
    ALSA: line6: fix control and interrupt message timeouts

Johan Hovold <johan@kernel.org>
    ALSA: 6fire: fix control and bulk message timeouts

Johan Hovold <johan@kernel.org>
    ALSA: ua101: fix division by zero at probe

Sean Young <sean@mess.org>
    media: ite-cir: IR receiver stop working after receive overflow

Helge Deller <deller@gmx.de>
    parisc: Fix ptrace check on syscall return

Christian Löhle <CLoehle@hyperstone.com>
    mmc: dw_mmc: Dont wait for DRTO on Write RSP error

Jan Kara <jack@suse.cz>
    ocfs2: fix data corruption on truncate

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    libata: fix read log timeout value

Takashi Iwai <tiwai@suse.de>
    Input: i8042 - Add quirk for Fujitsu Lifebook T725

Phoenix Huang <phoenix@emc.com.tw>
    Input: elantench - fix misreporting trackpoint coordinates

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix USB 3.1 enumeration issues by increasing roothub power-on-good delay

Todd Kjos <tkjos@google.com>
    binder: use cred instead of task for selinux checks

Todd Kjos <tkjos@google.com>
    binder: use euid from cred instead of using task


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/Makefile                                  |  22 ++--
 arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi          |   2 +-
 arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi  |   2 +-
 arch/arm/kernel/stacktrace.c                       |   3 +-
 arch/arm/mm/Kconfig                                |   2 +-
 arch/hexagon/lib/io.c                              |   4 +
 arch/ia64/Kconfig.debug                            |   2 +-
 arch/m68k/Kconfig.machine                          |   1 +
 arch/mips/Kconfig                                  |   3 +
 arch/mips/bcm63xx/clk.c                            |   6 +
 arch/mips/lantiq/xway/dma.c                        |  14 +-
 arch/mips/sni/time.c                               |   4 +-
 arch/parisc/kernel/entry.S                         |   4 +-
 arch/parisc/kernel/smp.c                           |  19 ++-
 arch/parisc/mm/init.c                              |   4 +-
 arch/powerpc/boot/dts/charon.dts                   |   2 +-
 arch/powerpc/boot/dts/digsy_mtc.dts                |   2 +-
 arch/powerpc/boot/dts/lite5200.dts                 |   2 +-
 arch/powerpc/boot/dts/lite5200b.dts                |   2 +-
 arch/powerpc/boot/dts/media5200.dts                |   2 +-
 arch/powerpc/boot/dts/mpc5200b.dtsi                |   2 +-
 arch/powerpc/boot/dts/o2d.dts                      |   2 +-
 arch/powerpc/boot/dts/o2d.dtsi                     |   2 +-
 arch/powerpc/boot/dts/o2dnt2.dts                   |   2 +-
 arch/powerpc/boot/dts/o3dnt.dts                    |   2 +-
 arch/powerpc/boot/dts/pcm032.dts                   |   2 +-
 arch/powerpc/boot/dts/tqm5200.dts                  |   2 +-
 arch/powerpc/sysdev/dcr-low.S                      |   2 +-
 arch/sh/Kconfig.debug                              |   1 +
 arch/sh/include/asm/sfp-machine.h                  |   8 ++
 arch/sh/kernel/cpu/sh4a/smp-shx3.c                 |   5 +-
 arch/x86/include/asm/page_64_types.h               |   2 +-
 arch/x86/kernel/irq.c                              |   4 +-
 crypto/pcrypt.c                                    |  12 +-
 drivers/acpi/acpica/acglobal.h                     |   2 +
 drivers/acpi/acpica/hwesleep.c                     |   8 +-
 drivers/acpi/acpica/hwsleep.c                      |  11 +-
 drivers/acpi/acpica/hwxfsleep.c                    |   7 +
 drivers/acpi/battery.c                             |   2 +-
 drivers/android/binder.c                           |  23 ++--
 drivers/ata/libata-eh.c                            |   8 ++
 drivers/cpuidle/sysfs.c                            |   5 +-
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |   7 +
 drivers/dma/at_xdmac.c                             |   2 +-
 drivers/edac/sb_edac.c                             |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |   1 +
 drivers/gpu/drm/msm/msm_gem.c                      |   4 +-
 drivers/gpu/drm/udl/udl_connector.c                |   2 +-
 drivers/hv/hyperv_vmbus.h                          |   1 +
 drivers/hwmon/pmbus/lm25066.c                      |  23 ++++
 drivers/iio/dac/ad5446.c                           |   9 +-
 drivers/infiniband/hw/mlx4/qp.c                    |   4 +-
 drivers/input/mouse/elantech.c                     |  13 ++
 drivers/input/serio/i8042-x86ia64io.h              |  14 ++
 drivers/irqchip/irq-s3c24xx.c                      |  22 +++-
 drivers/media/i2c/mt9p031.c                        |  28 +++-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  27 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   2 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   2 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |   2 +-
 drivers/media/rc/ite-cir.c                         |   2 +-
 drivers/media/rc/mceusb.c                          |   1 +
 drivers/media/usb/dvb-usb/az6027.c                 |   1 +
 drivers/media/usb/dvb-usb/dibusb-common.c          |   2 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |   7 +-
 drivers/memory/fsl_ifc.c                           |  13 +-
 drivers/memstick/core/ms_block.c                   |   2 +-
 drivers/memstick/host/jmb38x_ms.c                  |   2 +-
 drivers/memstick/host/r592.c                       |   8 +-
 drivers/mmc/host/Kconfig                           |   2 +-
 drivers/mmc/host/dw_mmc.c                          |   3 +-
 drivers/net/bonding/bond_sysfs_slave.c             |  36 ++----
 .../net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h   |   4 +-
 drivers/net/ethernet/ti/davinci_emac.c             |  16 ++-
 drivers/net/tun.c                                  |   5 +
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   1 -
 drivers/net/wireless/ath/ath6kl/usb.c              |   7 +-
 drivers/net/wireless/ath/ath9k/main.c              |   4 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c    |  10 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   4 +-
 drivers/net/wireless/b43/phy_g.c                   |   2 +-
 drivers/net/wireless/b43legacy/radio.c             |   2 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c           |   3 +
 drivers/net/wireless/libertas/if_usb.c             |   2 +
 drivers/net/wireless/libertas_tf/if_usb.c          |   2 +
 drivers/net/wireless/mwifiex/11n.c                 |   5 +-
 drivers/net/wireless/mwifiex/pcie.c                |   8 ++
 drivers/net/wireless/mwifiex/usb.c                 |  16 +++
 drivers/net/wireless/mwl8k.c                       |   2 +-
 drivers/net/xen-netfront.c                         |   8 ++
 drivers/nfc/pn533.c                                |   6 +-
 drivers/pci/msi.c                                  |  24 ++--
 drivers/pci/quirks.c                               |   1 +
 drivers/platform/x86/hp_accel.c                    |   2 +
 drivers/platform/x86/thinkpad_acpi.c               |   2 +-
 drivers/platform/x86/wmi.c                         |   9 +-
 drivers/power/max17042_battery.c                   |   8 +-
 drivers/power/rt5033_battery.c                     |   2 +-
 drivers/scsi/advansys.c                            |   4 +-
 drivers/scsi/csiostor/csio_lnode.c                 |   2 +-
 drivers/scsi/dc395x.c                              |   1 +
 drivers/scsi/lpfc/lpfc_sli.c                       |   1 +
 drivers/scsi/qla2xxx/qla_gbl.h                     |   2 -
 drivers/scsi/qla2xxx/qla_mr.c                      |  23 ----
 drivers/scsi/qla2xxx/qla_os.c                      |  27 +---
 drivers/sh/maple/maple.c                           |   5 +-
 drivers/spi/spi-pl022.c                            |   5 +-
 drivers/target/target_core_alua.c                  |   1 -
 drivers/target/target_core_device.c                |   2 +
 drivers/target/target_core_internal.h              |   1 +
 drivers/target/target_core_transport.c             |  76 +++++++----
 drivers/tty/serial/8250/8250_dw.c                  |   2 +-
 drivers/tty/tty_buffer.c                           |   3 +
 drivers/usb/chipidea/core.c                        |  21 ++-
 drivers/usb/gadget/legacy/hid.c                    |   4 +-
 drivers/usb/host/max3421-hcd.c                     |  25 +---
 drivers/usb/host/ohci-tmio.c                       |   2 +-
 drivers/usb/host/xhci-hub.c                        |   3 +-
 drivers/usb/misc/iowarrior.c                       |   8 +-
 drivers/usb/musb/tusb6010.c                        |   5 +
 drivers/usb/serial/keyspan.c                       |  15 +--
 drivers/video/console/sticon.c                     |  12 +-
 drivers/video/fbdev/chipsfb.c                      |   2 +-
 drivers/watchdog/f71808e_wdt.c                     |   4 +-
 drivers/xen/xen-pciback/conf_space_capability.c    |   2 +-
 fs/btrfs/async-thread.c                            |  14 ++
 fs/btrfs/tree-log.c                                |   4 +-
 fs/jfs/jfs_mount.c                                 |  51 ++++----
 fs/ocfs2/file.c                                    |   8 +-
 fs/quota/quota_tree.c                              |  15 +++
 fs/tracefs/inode.c                                 |   3 +-
 include/linux/libata.h                             |   2 +-
 include/linux/lsm_hooks.h                          |  32 ++---
 include/linux/security.h                           |  28 ++--
 include/net/llc.h                                  |   4 +-
 include/target/target_core_base.h                  |   6 +-
 include/uapi/linux/pci_regs.h                      |   6 +
 kernel/power/swap.c                                |   5 +-
 kernel/sched/core.c                                |   3 +
 kernel/signal.c                                    |  17 +--
 lib/decompress_unxz.c                              |   2 +-
 lib/xz/xz_dec_lzma2.c                              |  21 ++-
 lib/xz/xz_dec_stream.c                             |   6 +-
 mm/oom_kill.c                                      |   3 +
 mm/slab.h                                          |   2 +-
 net/batman-adv/bat_iv_ogm.c                        |   4 +-
 net/batman-adv/bridge_loop_avoidance.c             | 141 +++++++++++++++++----
 net/batman-adv/bridge_loop_avoidance.h             |   4 +-
 net/batman-adv/debugfs.c                           |   1 +
 net/batman-adv/fragmentation.c                     |  41 ++++--
 net/batman-adv/hard-interface.c                    |   3 +
 net/batman-adv/main.c                              |  44 +++++--
 net/batman-adv/multicast.c                         |  31 +++++
 net/batman-adv/multicast.h                         |  15 +++
 net/batman-adv/network-coding.c                    |   4 +-
 net/batman-adv/soft-interface.c                    |  31 +++--
 net/batman-adv/translation-table.c                 |  10 +-
 net/bluetooth/l2cap_sock.c                         |  10 +-
 net/bluetooth/sco.c                                |  24 ++--
 net/core/stream.c                                  |   3 -
 net/netfilter/nfnetlink_queue.c                    |   2 +-
 net/nfc/core.c                                     |  32 +++--
 net/nfc/nci/core.c                                 |  11 +-
 net/vmw_vsock/af_vsock.c                           |   2 +
 net/wireless/util.c                                |   1 +
 security/security.c                                |  14 +-
 security/selinux/hooks.c                           |  31 ++---
 security/smack/smackfs.c                           |  11 +-
 sound/core/oss/mixer_oss.c                         |  43 +++++--
 sound/core/timer.c                                 |  17 ++-
 sound/isa/gus/gus_dma.c                            |   2 +
 sound/soc/soc-dapm.c                               |  29 ++++-
 sound/synth/emux/emux.c                            |   2 +-
 sound/usb/6fire/comm.c                             |   2 +-
 sound/usb/6fire/firmware.c                         |   6 +-
 sound/usb/line6/driver.c                           |  12 +-
 sound/usb/line6/driver.h                           |   2 +-
 sound/usb/line6/toneport.c                         |   2 +-
 sound/usb/misc/ua101.c                             |   4 +-
 180 files changed, 1122 insertions(+), 578 deletions(-)


