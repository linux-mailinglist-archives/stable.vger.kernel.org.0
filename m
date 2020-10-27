Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE8929C713
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752970AbgJ0N5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752959AbgJ0N5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:57:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 585852068D;
        Tue, 27 Oct 2020 13:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807072;
        bh=JWbGA9u+7tPTEQwlqnDBeqxCCWckF7tWai9NnFTy56E=;
        h=From:To:Cc:Subject:Date:From;
        b=tV6s7UikyFxwIJ7tvTcomppak6hedqCGBKcRBBMvmXsPajOWMoKNWkx9OlTeTcQRy
         o36/wU5wpHWbDpnrJSer2fDf/ioiAK8eqfrDPBgQBE26/0QcCXheT0G6h7LxKf5jdT
         Ct5TP5JiVDEGJWMcJQtAkIa4VnBK6ISHnzHbLIYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.4 000/112] 4.4.241-rc1 review
Date:   Tue, 27 Oct 2020 14:48:30 +0100
Message-Id: <20201027134900.532249571@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.241-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.241-rc1
X-KernelTest-Deadline: 2020-10-29T13:49+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.241 release.
There are 112 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 29 Oct 2020 13:48:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.241-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.241-rc1

Oliver Neukum <oneukum@suse.com>
    USB: cdc-wdm: Make wdm_flush() interruptible and add wdm_fsync().

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    usb: cdc-acm: add quirk to blacklist ETAS ES58X devices

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    net: korina: cast KSEG0 address to pointer in kfree

Zekun Shen <bruceshenzk@gmail.com>
    ath10k: check idx validity in __ath10k_htt_rx_ring_fill_n()

Eli Billauer <eli.billauer@gmail.com>
    usb: core: Solve race condition in anchor cleanup functions

Wang Yufen <wangyufen@huawei.com>
    brcm80211: fix possible memleak in brcmf_proto_msgbuf_attach

Jan Kara <jack@suse.cz>
    reiserfs: Fix memory leak in reiserfs_parse_options()

Peilin Ye <yepeilin.cs@gmail.com>
    ipvs: Fix uninit-value in do_ip_vs_set_ctl()

Tong Zhang <ztong0001@gmail.com>
    tty: ipwireless: fix error handling

Doug Horn <doughorn@google.com>
    Fix use after free in get_capset_info callback.

Chris Chiu <chiu@endlessm.com>
    rtl8xxxu: prevent potential memory leak

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    brcmsmac: fix memory leak in wlc_phy_attach_lcnphy

Jing Xiangfeng <jingxiangfeng@huawei.com>
    scsi: ibmvfc: Fix error return in ibmvfc_probe()

Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
    Bluetooth: Only mark socket zapped after unlocking

Hamish Martin <hamish.martin@alliedtelesis.co.nz>
    usb: ohci: Default to per-port over-current protection

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: make sure the rt allocator doesn't run off the end

Eric Biggers <ebiggers@google.com>
    reiserfs: only call unlock_new_inode() if I_NEW

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    misc: rtsx: Fix memory leak in rtsx_pci_probe

Brooke Basile <brookebasile@gmail.com>
    ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()

Jan Kara <jack@suse.cz>
    udf: Avoid accessing uninitialized data on failed inode read

Jan Kara <jack@suse.cz>
    udf: Limit sparing table size

Zqiang <qiang.zhang@windriver.com>
    usb: gadget: function: printer: fix use-after-free in __lock_acquire

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: target: core: Add CONTROL field for trace events

Jing Xiangfeng <jingxiangfeng@huawei.com>
    scsi: mvumi: Fix error return in mvumi_io_attach()

Christoph Hellwig <hch@lst.de>
    PM: hibernate: remove the bogus call to get_gendisk() in software_resume()

Rustam Kovhaev <rkovhaev@gmail.com>
    ntfs: add check for mft record size in superblock

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: saa7134: avoid a shift overflow

Pali Rohár <pali@kernel.org>
    mmc: sdio: Check for CISTPL_VERS_1 buffer size

Adam Goode <agoode@google.com>
    media: uvcvideo: Ensure all probed info is returned to v4l2

Xiaolong Huang <butterflyhuangxx@gmail.com>
    media: media/pci: prevent memory leak in bttv_probe

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: bdisp: Fix runtime PM imbalance on error

Qiushi Wu <wu000273@umn.edu>
    media: exynos4-is: Fix a reference count leak

Qiushi Wu <wu000273@umn.edu>
    media: exynos4-is: Fix a reference count leak due to pm_runtime_get_sync

Qiushi Wu <wu000273@umn.edu>
    media: exynos4-is: Fix several reference count leaks due to pm_runtime_get_sync

Oliver Neukum <oneukum@suse.com>
    media: ati_remote: sanity check for both endpoints

Pavel Machek <pavel@ucw.cz>
    media: firewire: fix memory leak

Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
    powerpc/powernv/dump: Fix race while processing OPAL dump

Michal Simek <michal.simek@xilinx.com>
    arm64: dts: zynqmp: Remove additional compatible string for i2c IPs

Krzysztof Kozlowski <krzk@kernel.org>
    memory: fsl-corenet-cf: Fix handling of platform_get_irq() error

Dan Carpenter <dan.carpenter@oracle.com>
    memory: omap-gpmc: Fix a couple off by ones

Robert Hoo <robert.hu@linux.intel.com>
    KVM: x86: emulating RDPID failure shall return #UD rather than #GP

Krzysztof Kozlowski <krzk@kernel.org>
    Input: sun4i-ps2 - fix handling of platform_get_irq() error

Krzysztof Kozlowski <krzk@kernel.org>
    Input: omap4-keypad - fix handling of platform_get_irq() error

Krzysztof Kozlowski <krzk@kernel.org>
    Input: ep93xx_keypad - fix handling of platform_get_irq() error

Dan Carpenter <dan.carpenter@oracle.com>
    Input: imx6ul_tsc - clean up some errors in imx6ul_tsc_resume()

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Clear token on bypass registration failure

Tobias Jordan <kernel@cdqe.de>
    lib/crc32.c: fix trivial typo in preprocessor condition

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    cpufreq: powernv: Fix frame-size-overflow in powernv_cpufreq_reboot_notifier

Kajol Jain <kjain@linux.ibm.com>
    powerpc/perf/hv-gpci: Fix starting index value

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Fix pager search for multi-line strings

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix "context_switch event has no tid" error

Finn Thain <fthain@telegraphics.com.au>
    powerpc/tau: Disable TAU between measurements

Finn Thain <fthain@telegraphics.com.au>
    powerpc/tau: Remove duplicated set_thresholds() call

Finn Thain <fthain@telegraphics.com.au>
    powerpc/tau: Use appropriate temperature sample interval

Guillaume Tucker <guillaume.tucker@collabora.com>
    ARM: 9007/1: l2c: fix prefetch bits init in L2X0_AUX_CTRL using DT values

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    mtd: mtdoops: Don't write panic data twice

Arnd Bergmann <arnd@arndb.de>
    mtd: lpddr: fix excessive stack usage with clang

Nicholas Mc Guire <hofrat@osadl.org>
    powerpc/icp-hv: Fix missing of_node_put() in success path

Nicholas Mc Guire <hofrat@osadl.org>
    powerpc/pseries: Fix missing of_node_put() in rng_init()

Håkon Bugge <haakon.bugge@oracle.com>
    IB/mlx4: Adjust delayed work when a dup is observed

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    net: korina: fix kfree of rx/tx descriptor array

Tom Rix <trix@redhat.com>
    mwifiex: fix double free

Johannes Berg <johannes.berg@intel.com>
    nl80211: fix non-split wiphy information

Lorenzo Colitti <lorenzo@google.com>
    usb: gadget: u_ether: enable qmult on SuperSpeed Plus as well

Dan Carpenter <dan.carpenter@oracle.com>
    mfd: sm501: Fix leaks in probe()

Thomas Gleixner <tglx@linutronix.de>
    net: enic: Cure the enic api locking trainwreck

Eric Dumazet <edumazet@google.com>
    quota: clear padding in v2r1_mem2diskdqb()

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Avoid mutex lock for a long-time ioctl

Souptick Joarder <jrdr.linux@gmail.com>
    misc: mic: scif: Fix error handling path

Dan Carpenter <dan.carpenter@oracle.com>
    ath6kl: wmi: prevent a shift wrapping bug in ath6kl_wmi_delete_pstream_cmd()

Dan Carpenter <dan.carpenter@oracle.com>
    HID: roccat: add bounds checking in kone_sysfs_write_settings()

Tom Rix <trix@redhat.com>
    video: fbdev: sis: fix null ptr dereference

Colin Ian King <colin.king@canonical.com>
    video: fbdev: vga16fb: fix setting of pixclock because a pass-by-value error

Souptick Joarder <jrdr.linux@gmail.com>
    drivers/virt/fsl_hypervisor: Fix error handling path

Artem Savkov <asavkov@redhat.com>
    pty: do tty_flip_buffer_push without port->lock in pty_write

Tyrel Datwyler <tyreld@linux.ibm.com>
    tty: hvcs: Don't NULL tty->driver_data until hvcs_cleanup()

Tong Zhang <ztong0001@gmail.com>
    tty: serial: earlycon dependency

Alex Dewar <alex.dewar90@gmail.com>
    VMCI: check return value of get_user_pages_fast() for errors

dinghao.liu@zju.edu.cn <dinghao.liu@zju.edu.cn>
    backlight: sky81452-backlight: Fix refcount imbalance on error

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    scsi: csiostor: Fix wrong return value in csio_hw_prep_fw()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: qla4xxx: Fix an error handling path in 'qla4xxx_get_host_stats()'

Tom Rix <trix@redhat.com>
    drm/gma500: fix error check

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mwifiex: Do not use GFP_KERNEL in atomic context

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    wcn36xx: Fix reported 802.11n rx_highest rate wcn3660/wcn3680

Dan Carpenter <dan.carpenter@oracle.com>
    ath9k: Fix potential out of bounds in ath9k_htc_txcompletion_cb()

Dan Carpenter <dan.carpenter@oracle.com>
    ath6kl: prevent potential array overflow in ath6kl_add_new_sta()

Qiushi Wu <wu000273@umn.edu>
    media: ti-vpe: Fix a missing check and reference count leak

Tom Rix <trix@redhat.com>
    media: tc358743: initialize variable

Tero Kristo <t-kristo@ti.com>
    crypto: omap-sham - fix digcnt register handling with export/import

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: omap3isp: Fix memleak in isp_probe

Tom Rix <trix@redhat.com>
    media: m5mols: Check function pointer in m5mols_sensor_power

Sylwester Nawrocki <s.nawrocki@samsung.com>
    media: Revert "media: exynos4-is: Add missed check for pinctrl_lookup_state()"

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: ixp4xx - Fix the size used in a 'dma_free_coherent()' call

Dinghao Liu <dinghao.liu@zju.edu.cn>
    EDAC/i5100: Fix error handling order in i5100_init_one()

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Don't ignore errors from crypto_shash_update()

Dan Carpenter <dan.carpenter@oracle.com>
    cifs: remove bogus debug code

Eric Dumazet <edumazet@google.com>
    icmp: randomize the global rate limiter

Neal Cardwell <ncardwell@google.com>
    tcp: fix to update snd_wl1 in bulk receiver fast path

Defang Bo <bodefang@126.com>
    nfc: Ensure presence of NFC_ATTR_FIRMWARE_NAME attribute in nfc_genl_fw_download()

Xie He <xie.he.0141@gmail.com>
    net: hdlc_raw_eth: Clear the IFF_TX_SKB_SHARING flag after calling ether_setup

Xie He <xie.he.0141@gmail.com>
    net: hdlc: In hdlc_rcv, check to make sure dev is an HDLC device

Andrey Ryabinin <aryabinin@virtuozzo.com>
    x86/mm/ptdump: Fix soft lockup in page table walker

Andrey Ryabinin <aryabinin@virtuozzo.com>
    lib/strscpy: Shut up KASAN false-positives in strscpy()

Andrey Ryabinin <aryabinin@virtuozzo.com>
    compiler.h: Add read_word_at_a_time() function.

Andrey Ryabinin <aryabinin@virtuozzo.com>
    compiler.h, kasan: Avoid duplicating __read_once_size_nocheck()

Andrey Ryabinin <aryabinin@virtuozzo.com>
    mm/kasan: add API to check memory regions

Andrey Ryabinin <aryabinin@virtuozzo.com>
    mm/kasan: print name of mem[set,cpy,move]() caller in report

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: bebob: potential info leak in hwdep_read()

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix data corruption issue on RTL8402

Maciej Żenczykowski <maze@google.com>
    net/ipv4: always honour route mtu during forwarding

Cong Wang <xiyou.wangcong@gmail.com>
    tipc: fix the skb_unshare() in tipc_buf_append()

David Wilder <dwilder@us.ibm.com>
    ibmveth: Identify ingress large send packets.


-------------

Diffstat:

 Documentation/networking/ip-sysctl.txt             |   4 +-
 Makefile                                           |   4 +-
 arch/arm/mm/cache-l2x0.c                           |  16 ++-
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   4 +-
 arch/powerpc/include/asm/reg.h                     |   2 +-
 arch/powerpc/kernel/tau_6xx.c                      |  82 +++++----------
 arch/powerpc/perf/hv-gpci-requests.h               |   6 +-
 arch/powerpc/platforms/Kconfig                     |   9 +-
 arch/powerpc/platforms/powernv/opal-dump.c         |  41 +++++---
 arch/powerpc/platforms/pseries/rng.c               |   1 +
 arch/powerpc/sysdev/xics/icp-hv.c                  |   1 +
 arch/x86/kvm/emulate.c                             |   2 +-
 arch/x86/mm/dump_pagetables.c                      |   2 +
 drivers/cpufreq/powernv-cpufreq.c                  |   9 +-
 drivers/crypto/ixp4xx_crypto.c                     |   2 +-
 drivers/crypto/omap-sham.c                         |   3 +
 drivers/edac/i5100_edac.c                          |  11 +-
 drivers/gpu/drm/gma500/cdv_intel_dp.c              |   2 +-
 drivers/gpu/drm/virtio/virtgpu_kms.c               |   2 +
 drivers/gpu/drm/virtio/virtgpu_vq.c                |  10 +-
 drivers/hid/hid-roccat-kone.c                      |  23 ++--
 drivers/infiniband/hw/mlx4/cm.c                    |   3 +
 drivers/input/keyboard/ep93xx_keypad.c             |   4 +-
 drivers/input/keyboard/omap4-keypad.c              |   6 +-
 drivers/input/serio/sun4i-ps2.c                    |   9 +-
 drivers/input/touchscreen/imx6ul_tsc.c             |  27 +++--
 drivers/media/firewire/firedtv-fw.c                |   6 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |   3 +-
 drivers/media/i2c/tc358743.c                       |   2 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |  13 ++-
 drivers/media/pci/saa7134/saa7134-tvaudio.c        |   3 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |   4 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   8 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   4 +-
 drivers/media/platform/omap3isp/isp.c              |   6 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |   3 +-
 drivers/media/platform/ti-vpe/vpe.c                |   2 +
 drivers/media/rc/ati_remote.c                      |   4 +
 drivers/media/usb/uvc/uvc_v4l2.c                   |  30 ++++++
 drivers/memory/fsl-corenet-cf.c                    |   6 +-
 drivers/memory/omap-gpmc.c                         |   4 +-
 drivers/mfd/rtsx_pcr.c                             |   4 +-
 drivers/mfd/sm501.c                                |   8 +-
 drivers/misc/mic/scif/scif_rma.c                   |   4 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c            |  10 +-
 drivers/mmc/core/sdio_cis.c                        |   3 +
 drivers/mtd/lpddr/lpddr2_nvm.c                     |  35 ++++---
 drivers/mtd/mtdoops.c                              |  11 +-
 drivers/net/ethernet/cisco/enic/enic.h             |   1 +
 drivers/net/ethernet/cisco/enic/enic_api.c         |   6 ++
 drivers/net/ethernet/cisco/enic/enic_main.c        |  27 +++--
 drivers/net/ethernet/ibm/ibmveth.c                 |  13 ++-
 drivers/net/ethernet/korina.c                      |   3 +-
 drivers/net/ethernet/realtek/r8169.c               | 116 +++++++++++----------
 drivers/net/wan/hdlc.c                             |  10 +-
 drivers/net/wan/hdlc_raw_eth.c                     |   1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   8 ++
 drivers/net/wireless/ath/ath6kl/main.c             |   3 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |   5 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  19 ++++
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   2 +
 drivers/net/wireless/ath/wcn36xx/main.c            |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |   2 +
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |   4 +-
 drivers/net/wireless/mwifiex/scan.c                |   2 +-
 drivers/net/wireless/mwifiex/sdio.c                |   2 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   |  10 +-
 drivers/scsi/csiostor/csio_hw.c                    |   2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   1 +
 drivers/scsi/mvumi.c                               |   1 +
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +-
 drivers/tty/hvc/hvcs.c                             |  14 +--
 drivers/tty/ipwireless/network.c                   |   4 +-
 drivers/tty/ipwireless/tty.c                       |   2 +-
 drivers/tty/pty.c                                  |   2 +-
 drivers/tty/serial/Kconfig                         |   1 +
 drivers/usb/class/cdc-acm.c                        |  11 ++
 drivers/usb/class/cdc-wdm.c                        |  72 ++++++++++---
 drivers/usb/core/urb.c                             |  89 +++++++++-------
 drivers/usb/gadget/function/f_printer.c            |  16 ++-
 drivers/usb/gadget/function/u_ether.c              |   2 +-
 drivers/usb/host/ohci-hcd.c                        |  16 +--
 drivers/vfio/pci/vfio_pci_intrs.c                  |   4 +-
 drivers/video/backlight/sky81452-backlight.c       |   1 +
 drivers/video/fbdev/sis/init.c                     |  11 +-
 drivers/video/fbdev/vga16fb.c                      |  14 +--
 drivers/virt/fsl_hypervisor.c                      |  17 ++-
 fs/cifs/asn1.c                                     |  16 +--
 fs/ntfs/inode.c                                    |   6 ++
 fs/quota/quota_v2.c                                |   1 +
 fs/reiserfs/inode.c                                |   3 +-
 fs/reiserfs/super.c                                |   8 +-
 fs/udf/inode.c                                     |  25 +++--
 fs/udf/super.c                                     |   6 ++
 fs/xfs/xfs_rtalloc.c                               |  11 ++
 include/linux/compiler.h                           |  22 ++--
 include/linux/kasan-checks.h                       |  12 +++
 include/net/ip.h                                   |   6 ++
 include/scsi/scsi_common.h                         |   7 ++
 include/trace/events/target.h                      |  12 +--
 kernel/debug/kdb/kdb_io.c                          |   8 +-
 kernel/power/hibernate.c                           |  11 --
 lib/crc32.c                                        |   2 +-
 lib/string.c                                       |   2 +-
 mm/kasan/kasan.c                                   |  76 ++++++++------
 net/bluetooth/l2cap_sock.c                         |   7 +-
 net/ipv4/icmp.c                                    |   7 +-
 net/ipv4/tcp_input.c                               |   2 +
 net/netfilter/ipvs/ip_vs_ctl.c                     |   7 +-
 net/nfc/netlink.c                                  |   2 +-
 net/tipc/msg.c                                     |   3 +-
 net/wireless/nl80211.c                             |   5 +-
 security/integrity/ima/ima_crypto.c                |   2 +
 sound/core/seq/oss/seq_oss.c                       |   7 +-
 sound/firewire/bebob/bebob_hwdep.c                 |   3 +-
 tools/perf/util/intel-pt.c                         |   8 +-
 117 files changed, 812 insertions(+), 453 deletions(-)


