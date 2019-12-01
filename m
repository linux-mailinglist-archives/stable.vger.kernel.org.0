Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 441CA10E124
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 10:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfLAJjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 04:39:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfLAJjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Dec 2019 04:39:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D45A32073C;
        Sun,  1 Dec 2019 09:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575193139;
        bh=ykSeZYZSLEduhsM6xHUAULFUdFUM384UtwoP8uDvLl0=;
        h=Date:From:To:Cc:Subject:From;
        b=zGxh6feg4wTelAg9LkQJm3Dv0Fm5JJ33I7/sNx7LjWo+Y8ABKf3yI42wiZVwYhFsy
         T02rYj6eIKPt1pzBYk6KkmE34aMuEG/8qLDz9DAVQa+gzw0bV7B9tyHSNPAUqeqwJm
         gFugJkBRD8ryxuhi6V1bXubzVa/fzLG/MV1mm+hY=
Date:   Sun, 1 Dec 2019 10:38:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.204
Message-ID: <20191201093856.GA3774006@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.204 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/hw-vuln/mds.rst                                      |    7 
 Documentation/hw-vuln/tsx_async_abort.rst                          |    5 
 Documentation/kernel-parameters.txt                                |   11 
 Makefile                                                           |    2 
 arch/arc/kernel/perf_event.c                                       |    4 
 arch/arm64/kernel/traps.c                                          |    1 
 arch/powerpc/include/asm/asm-prototypes.h                          |    3 
 arch/powerpc/include/asm/security_features.h                       |    3 
 arch/powerpc/kernel/eeh_pe.c                                       |    2 
 arch/powerpc/kernel/entry_64.S                                     |    6 
 arch/powerpc/kernel/security.c                                     |   74 ++++-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                            |   20 +
 arch/powerpc/platforms/ps3/os-area.c                               |    2 
 arch/s390/kernel/perf_cpum_sf.c                                    |    6 
 arch/sparc/include/asm/cmpxchg_64.h                                |    7 
 arch/sparc/include/asm/parport.h                                   |    2 
 arch/um/drivers/line.c                                             |    2 
 arch/x86/include/asm/ptrace.h                                      |   42 ++
 arch/x86/kernel/cpu/bugs.c                                         |   30 +-
 arch/x86/kvm/vmx.c                                                 |    4 
 arch/x86/tools/gen-insn-attr-x86.awk                               |    4 
 drivers/atm/zatm.c                                                 |   42 +-
 drivers/block/amiflop.c                                            |   84 ++---
 drivers/bluetooth/hci_bcsp.c                                       |    3 
 drivers/char/virtio_console.c                                      |  140 ++++-----
 drivers/clk/mmp/clk-of-mmp2.c                                      |    4 
 drivers/cpufreq/cpufreq.c                                          |    9 
 drivers/firmware/google/gsmi.c                                     |    5 
 drivers/isdn/mISDN/tei.c                                           |    7 
 drivers/macintosh/windfarm_smu_sat.c                               |   25 -
 drivers/md/dm.c                                                    |    4 
 drivers/media/platform/vivid/vivid-kthread-cap.c                   |    8 
 drivers/media/platform/vivid/vivid-kthread-out.c                   |    8 
 drivers/media/platform/vivid/vivid-sdr-cap.c                       |    8 
 drivers/media/platform/vivid/vivid-vid-cap.c                       |    3 
 drivers/media/platform/vivid/vivid-vid-out.c                       |    3 
 drivers/media/rc/imon.c                                            |    3 
 drivers/media/usb/b2c2/flexcop-usb.c                               |    3 
 drivers/media/usb/dvb-usb/cxusb.c                                  |    3 
 drivers/mfd/max8997.c                                              |    8 
 drivers/mfd/mc13xxx-core.c                                         |    3 
 drivers/misc/mic/scif/scif_fence.c                                 |    2 
 drivers/mmc/card/block.c                                           |    3 
 drivers/mmc/host/mtk-sd.c                                          |    2 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                     |    2 
 drivers/net/ethernet/intel/igb/igb_ptp.c                           |    8 
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                    |    1 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c                    |    2 
 drivers/net/ethernet/sfc/ptp.c                                     |    3 
 drivers/net/ntb_netdev.c                                           |    2 
 drivers/net/wireless/airo.c                                        |    2 
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c                     |    2 
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c              |   30 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.h                     |    1 
 drivers/net/wireless/mwifiex/cfg80211.c                            |   13 
 drivers/net/wireless/mwifiex/ioctl.h                               |    1 
 drivers/net/wireless/mwifiex/sta_ioctl.c                           |   11 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c                   |    1 
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c                |    2 
 drivers/net/wireless/ti/wlcore/vendor_cmd.c                        |    2 
 drivers/ntb/hw/intel/ntb_hw_intel.c                                |    2 
 drivers/pci/host/pci-keystone.c                                    |    3 
 drivers/pinctrl/pinctrl-zynq.c                                     |    9 
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c                           |   21 +
 drivers/platform/x86/Kconfig                                       |    1 
 drivers/platform/x86/asus-nb-wmi.c                                 |  148 +++++++++-
 drivers/platform/x86/asus-wmi.c                                    |   59 +++
 drivers/platform/x86/asus-wmi.h                                    |    9 
 drivers/rtc/rtc-s35390a.c                                          |    2 
 drivers/scsi/dc395x.c                                              |   12 
 drivers/scsi/ips.c                                                 |    1 
 drivers/scsi/isci/host.c                                           |    8 
 drivers/scsi/isci/host.h                                           |    2 
 drivers/scsi/isci/request.c                                        |    4 
 drivers/scsi/isci/task.c                                           |    4 
 drivers/scsi/iscsi_tcp.c                                           |    3 
 drivers/scsi/lpfc/lpfc_els.c                                       |    2 
 drivers/scsi/lpfc/lpfc_hbadisc.c                                   |   20 +
 drivers/scsi/lpfc/lpfc_init.c                                      |    2 
 drivers/scsi/lpfc/lpfc_sli.c                                       |   11 
 drivers/scsi/lpfc/lpfc_sli4.h                                      |    1 
 drivers/scsi/megaraid/megaraid_sas_base.c                          |    4 
 drivers/scsi/mpt3sas/mpt3sas_config.c                              |    4 
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                               |   36 ++
 drivers/spi/spi-omap2-mcspi.c                                      |   26 -
 drivers/spi/spi-sh-msiof.c                                         |    4 
 drivers/staging/comedi/drivers/usbduxfast.c                        |   21 -
 drivers/staging/rdma/hfi1/pcie.c                                   |    3 
 drivers/thermal/rcar_thermal.c                                     |    4 
 drivers/tty/synclink_gt.c                                          |   16 -
 drivers/usb/misc/appledisplay.c                                    |   15 -
 drivers/usb/serial/cp210x.c                                        |    1 
 drivers/usb/serial/mos7720.c                                       |    4 
 drivers/usb/serial/mos7840.c                                       |   16 -
 drivers/usb/serial/option.c                                        |    7 
 fs/btrfs/ctree.c                                                   |    4 
 fs/ceph/inode.c                                                    |    1 
 fs/dlm/member.c                                                    |    5 
 fs/dlm/user.c                                                      |    2 
 fs/gfs2/rgrp.c                                                     |   13 
 fs/hfs/brec.c                                                      |    1 
 fs/hfs/btree.c                                                     |   41 +-
 fs/hfs/btree.h                                                     |    1 
 fs/hfs/catalog.c                                                   |   16 +
 fs/hfs/extent.c                                                    |   10 
 fs/hfsplus/attributes.c                                            |   10 
 fs/hfsplus/brec.c                                                  |    1 
 fs/hfsplus/btree.c                                                 |   44 +-
 fs/hfsplus/catalog.c                                               |   24 +
 fs/hfsplus/extents.c                                               |    8 
 fs/hfsplus/hfsplus_fs.h                                            |    2 
 fs/ocfs2/buffer_head_io.c                                          |   77 +++--
 fs/ocfs2/dlm/dlmdebug.c                                            |    2 
 fs/ocfs2/dlmglue.c                                                 |    2 
 fs/ocfs2/move_extents.c                                            |   17 +
 fs/ocfs2/stackglue.c                                               |    6 
 fs/ocfs2/stackglue.h                                               |    3 
 fs/ocfs2/xattr.c                                                   |   56 ++-
 include/linux/bitmap.h                                             |    9 
 include/linux/mfd/max8997.h                                        |    1 
 include/linux/mfd/mc13xxx.h                                        |    1 
 kernel/auditsc.c                                                   |    2 
 kernel/printk/printk.c                                             |    2 
 kernel/sched/fair.c                                                |   13 
 mm/ksm.c                                                           |   14 
 mm/page-writeback.c                                                |   33 +-
 net/core/dev.c                                                     |    2 
 net/core/rtnetlink.c                                               |   16 +
 net/core/sock.c                                                    |    6 
 net/sched/act_pedit.c                                              |    5 
 net/sunrpc/auth_gss/gss_krb5_seal.c                                |    1 
 net/unix/af_unix.c                                                 |    2 
 sound/firewire/isight.c                                            |   10 
 sound/i2c/cs8427.c                                                 |    2 
 tools/perf/util/intel-pt-decoder/gen-insn-attr-x86.awk             |    4 
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_syntax.tc |    3 
 136 files changed, 1165 insertions(+), 492 deletions(-)

Adrian Bunk (1):
      mwifiex: Fix NL80211_TX_POWER_LIMITED

Adrian Hunter (1):
      mmc: block: Fix tag condition with packed writes

Al Viro (1):
      synclink_gt(): fix compat_ioctl()

Aleksander Morgado (2):
      USB: serial: option: add support for DW5821e with eSIM support
      USB: serial: option: add support for Foxconn T77W968 LTE modules

Alexander Kapshuk (1):
      x86/insn: Fix awk regexp warnings

Alexander Popov (1):
      media: vivid: Fix wrong locking that causes race conditions on streaming stop

Alexey Brodkin (1):
      ARC: perf: Accommodate big-endian CPU

Ali MJ Al-Nasrawy (2):
      brcmsmac: AP mode: update beacon when TIM changes
      brcmsmac: never log "tid x is not agg'able" by default

Andreas Gruenbacher (1):
      gfs2: Fix marking bitmaps non-full

Andrey Ryabinin (1):
      mm/ksm.c: don't WARN if page is still mapped in remove_stable_node()

Anton Ivanov (1):
      um: Make line/tty semantics use true write IRQ

Arnd Bergmann (1):
      platform/x86: asus-wmi: add SERIO_I8042 dependency

Bart Van Assche (1):
      dm: use blk_set_queue_dying() in __dm_destroy()

Benjamin Herrenschmidt (1):
      macintosh/windfarm_smu_sat: Fix debug output

Bernd Porr (1):
      staging: comedi: usbduxfast: usbduxfast_ai_cmdtest rounding error

Bo Yan (1):
      cpufreq: Skip cpufreq resume if it's not suspended

Brian Masney (1):
      pinctrl: qcom: spmi-gpio: fix gpio-hog related boot issues

Changwei Ge (1):
      ocfs2: don't put and assigning null to bh allocated outside

Chaotian Jing (1):
      mmc: mediatek: fix cannot receive new request when msdc_cmd_is_ready fail

Christoph Hellwig (2):
      scsi: dc395x: fix dma API usage in srb_done
      scsi: dc395x: fix DMA API usage in sg_update_list

Christophe JAILLET (1):
      wlcore: Fix the return value in case of error in 'wlcore_vendor_cmd_smart_config_start()'

Christopher M. Riedl (1):
      powerpc/64s: support nospectre_v2 cmdline option

Colin Ian King (1):
      fs/hfs/extent.c: fix array out of bounds read of array extent

Dan Carpenter (4):
      net: rtnetlink: prevent underflows in do_setvfinfo()
      powerpc: Fix signedness bug in update_flash_db()
      qlcnic: fix a return in qlcnic_dcb_get_capability()
      wireless: airo: potential buffer overflow in sprintf()

Dave Chinner (1):
      mm/page-writeback.c: fix range_cyclic writeback vs writepages deadlock

Dave Jiang (1):
      ntb: intel: fix return value for ndev_vec_mask()

David Barmann (1):
      sock: Reset dst when changing sk_mark via setsockopt

David S. Miller (2):
      sparc: Fix parport build warnings.
      sparc64: Rework xchg() definition to avoid warnings.

Davide Caratti (1):
      net/sched: act_pedit: fix WARN() in the traffic path

Denis Efremov (1):
      ath9k_hw: fix uninitialized variable data

Duncan Laurie (1):
      gsmi: Fix bug in append_to_eventlog sysfs handler

Eric Dumazet (1):
      net: do not abort bulk send on BQL status

Ernesto A. Fernández (6):
      hfsplus: fix BUG on bnode parent update
      hfs: fix BUG on bnode parent update
      hfsplus: prevent btree data loss on ENOSPC
      hfs: prevent btree data loss on ENOSPC
      hfsplus: fix return value of hfsplus_get_block()
      hfs: fix return value of hfs_get_block()

Fabio Estevam (1):
      mfd: mc13xxx-core: Fix PMIC shutdown when reading ADC values

Gang He (1):
      ocfs2: remove ocfs2_is_o2cb_active()

Geert Uytterhoeven (1):
      thermal: rcar_thermal: Prevent hardware access during system suspend

Greg Kroah-Hartman (2):
      usb-serial: cp201x: support Mark-10 digital force gauge
      Linux 4.4.204

Gustavo A. R. Silva (2):
      scsi: ips: fix missing break in switch
      rtl8xxxu: Fix missing break in switch

Hans de Goede (1):
      platform/x86: asus-wmi: Only Tell EC the OS will handle display hotkeys from asus_nb_wmi

Hari Vyas (1):
      arm64: fix for bad_mode() handler to always result in panic

James Erwin (1):
      IB/hfi1: Ensure full Gen3 speed in a Gen4 system

James Smart (1):
      scsi: lpfc: fcoe: Fix link down issue after 1000+ link bounces

Jia-Ju Bai (1):
      fs/ocfs2/dlm/dlmdebug.c: fix a sleep-in-atomic-context bug in dlm_print_one_mle()

Johan Hovold (2):
      USB: serial: mos7720: fix remote wakeup
      USB: serial: mos7840: fix remote wakeup

Jon Mason (1):
      ntb_netdev: fix sleep time mismatch

Joseph Qi (1):
      Revert "fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa_prepare_entry()"

João Paulo Rechi Vita (5):
      asus-wmi: Create quirk for airplane_mode LED
      asus-wmi: Add quirk_no_rfkill_wapf4 for the Asus X456UF
      asus-wmi: Add quirk_no_rfkill for the Asus N552VW
      asus-wmi: Add quirk_no_rfkill for the Asus U303LB
      asus-wmi: Add quirk_no_rfkill for the Asus Z550MA

Kai Shen (1):
      cpufreq: Add NULL checks to show() and store() methods of cpufreq

Kai-Chuan Hsieh (1):
      platform/x86: asus-wmi: Set specified XUSB2PR value for X550LB

Kiernan Hager (1):
      platform/x86: asus-nb-wmi: Support ALS on the Zenbook UX430UQ

Kishon Vijay Abraham I (1):
      PCI: keystone: Use quirk to limit MRRS for K2G

Kyeongdon Kim (1):
      net: fix warning in af_unix

Larry Chen (1):
      ocfs2: fix clusters leak in ocfs2_defrag_extent()

Laurent Vivier (1):
      virtio_console: allocate inbufs in add_port() only if it is needed

Lubomir Rintel (1):
      clk: mmp2: fix the clock id for sdh2_clk and sdh3_clk

Luigi Rizzo (1):
      net/mlx4_en: fix mlx4 ethtool -N insertion

Marek Szyprowski (1):
      mfd: max8997: Enale irq-wakeup unconditionally

Martin Habets (1):
      sfc: Only cancel the PPS workqueue if it exists

Masami Hiramatsu (1):
      selftests/ftrace: Fix to test kprobe $comm arg only if available

Mattias Jacobsson (1):
      USB: misc: appledisplay: fix backlight update_status return code

Michael Ellerman (2):
      powerpc/book3s64: Fix link stack flush on context switch
      KVM: PPC: Book3S HV: Flush link stack on guest exit to host kernel

Michael S. Tsirkin (5):
      virtio_console: reset on out of memory
      virtio_console: don't tie bufs to a vq
      virtio_console: fix uninitialized variable use
      virtio_console: drop custom control queue cleanup
      virtio_console: move removal code

Miroslav Lichvar (1):
      igb: shorten maximum PHC timecounter update interval

Nathan Chancellor (7):
      scsi: isci: Use proper enumerated type in atapi_d2h_reg_frame_handler
      scsi: isci: Change sci_controller_start_task's return type to sci_status
      scsi: iscsi_tcp: Explicitly cast param in iscsi_sw_tcp_host_get_param
      atm: zatm: Fix empty body Clang warnings
      rtc: s35390a: Change buf's type to u8 in s35390a_init
      mISDN: Fix type of switch control variable in ctrl_teimanager
      pinctrl: zynq: Use define directive for PIN_CONFIG_IO_STANDARD

Nikolay Borisov (1):
      btrfs: handle error of get_old_root

Oleksij Rempel (3):
      platform/x86: asus-wmi: Filter buggy scan codes on ASUS Q500A
      asus-wmi: provide access to ALS control
      platform/x86: asus-wmi: try to set als by default

Oliver Neukum (2):
      media: b2c2-flexcop-usb: add sanity checking
      appledisplay: fix error handling in the scheduled work

Omar Sandoval (1):
      amiflop: clean up on errors during setup

Pavel Löbl (1):
      USB: serial: mos7840: add USB ID to support Moxa UPort 2210

Philipp Klocke (1):
      ALSA: i2c/cs8427: Fix int to char conversion

Rasmus Villemoes (2):
      linux/bitmap.h: handle constant zero-size bitmaps correctly
      linux/bitmap.h: fix type of nbits in bitmap_shift_right()

Richard Guy Briggs (1):
      audit: print empty EXECVE args

Sam Bobroff (1):
      powerpc/eeh: Fix use of EEH_PE_KEEP on wrong field

Sean Young (1):
      media: imon: invalid dereference in imon_touch_event

Sergei Shtylyov (1):
      spi: sh-msiof: fix deferred probing

Sergey Senozhatsky (1):
      printk: fix integer overflow in setup_log_buf()

Shaokun Zhang (1):
      rtlwifi: rtl8192de: Fix misleading REG_MCUFWDL information

Shivasharan S (1):
      scsi: megaraid_sas: Fix msleep granularity

Steven Rostedt (VMware) (1):
      kprobes, x86/ptrace.h: Make regs_get_kernel_stack_nth() not fault on bad stack

Suganath Prabu (2):
      scsi: mpt3sas: Fix Sync cache command failure during driver unload
      scsi: mpt3sas: Fix driver modifying persistent data in Manufacturing page11

Takashi Sakamoto (1):
      ALSA: isight: fix leak of reference to firewire unit in error path of .probe callback

Thomas Richter (1):
      s390/perf: Return error when debug_register fails

Tomas Bortoli (1):
      Bluetooth: Fix invalid-free in bcsp_close()

Trond Myklebust (1):
      SUNRPC: Fix a compile warning for cmpxchg64()

Tycho Andersen (2):
      dlm: fix invalid free
      dlm: don't leak kernel pointer to userspace

Uros Bizjak (1):
      KVM/x86: Fix invvpid and invept register operand size in 64-bit mode

Valentin Schneider (1):
      sched/fair: Don't increase sd->balance_interval on newidle balance

Vandana BN (1):
      media: vivid: Set vid_cap_streaming and vid_out_streaming to true

Vignesh R (2):
      spi: omap2-mcspi: Set FIFO DMA trigger level to word length
      spi: omap2-mcspi: Fix DMA and FIFO event trigger size mismatch

Vito Caputo (1):
      media: cxusb: detect cxusb_ctrl_msg error in query

Waiman Long (2):
      x86/speculation: Fix incorrect MDS/TAA mitigation status
      x86/speculation: Fix redundant MDS mitigation message

Wenwen Wang (1):
      misc: mic: fix a DMA pool free failure

Yan, Zheng (1):
      ceph: fix dentry leak in ceph_readdir_prepopulate

YueHaibing (1):
      net: bcmgenet: return correct value 'ret' from bcmgenet_power_down

zino lin (1):
      platform/x86: asus-wmi: fix asus ux303ub brightness issue

