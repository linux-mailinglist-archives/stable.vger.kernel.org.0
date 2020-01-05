Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFC9B13097A
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 19:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgAESzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 13:55:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:49592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbgAESzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Jan 2020 13:55:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 721BE207FD;
        Sun,  5 Jan 2020 18:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578250542;
        bh=376J87Ntvof2Ixmeyn3nemuBDWSYeM/oYzK8okc0tYU=;
        h=Date:From:To:Cc:Subject:From;
        b=J5RnAt63RF5nAirMa2qJEvS/yOIckfGCT8eA5yRZf5s25XPjqmPUo/t/WPljt/MRd
         2JH+SOVeBSh0L9Iqp3RNVUMo/LG1g6Ch/vfOUcuFlne/92UwvlTPcpbGwN04su4V22
         1D0tsavgbr3CTL66IfKuAdnzpVXapMVBuTBMvO+k=
Date:   Sun, 5 Jan 2020 19:55:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.208
Message-ID: <20200105185539.GA1684718@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.208 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                               |    2=20
 arch/arm/boot/compressed/libfdt_env.h                  |    4=20
 arch/arm64/kernel/psci.c                               |   15 +--
 arch/powerpc/boot/libfdt_env.h                         |    2=20
 arch/powerpc/kernel/irq.c                              |    4=20
 arch/powerpc/kernel/security.c                         |   21 ++--
 arch/powerpc/kernel/time.c                             |    2=20
 arch/powerpc/mm/hash_utils_64.c                        |   10 +-
 arch/powerpc/platforms/pseries/cmm.c                   |    5 +
 arch/s390/kernel/dis.c                                 |   13 +-
 arch/s390/kernel/perf_cpum_sf.c                        |   17 +++
 arch/sh/include/cpu-sh4/cpu/sh7734.h                   |    2=20
 arch/x86/include/asm/crash.h                           |    2=20
 arch/x86/include/asm/fixmap.h                          |    2=20
 arch/x86/kernel/apic/io_apic.c                         |    9 +
 arch/x86/kernel/cpu/mcheck/mce.c                       |    2=20
 arch/x86/kernel/cpu/mcheck/therm_throt.c               |    2=20
 arch/x86/lib/x86-opcode-map.txt                        |   18 ++-
 arch/x86/mm/pgtable.c                                  |    4=20
 drivers/ata/libata-core.c                              |    3=20
 drivers/cdrom/cdrom.c                                  |   12 ++
 drivers/char/hw_random/omap3-rom-rng.c                 |    3=20
 drivers/clk/pxa/clk-pxa27x.c                           |    1=20
 drivers/clk/qcom/clk-rcg2.c                            |    2=20
 drivers/clk/qcom/common.c                              |    3=20
 drivers/clocksource/asm9260_timer.c                    |    4=20
 drivers/cpufreq/cpufreq.c                              |    7 +
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c                |   12 +-
 drivers/crypto/vmx/Makefile                            |    6 -
 drivers/edac/ghes_edac.c                               |   10 +-
 drivers/extcon/extcon-sm5502.c                         |    4=20
 drivers/extcon/extcon-sm5502.h                         |    2=20
 drivers/gpio/gpio-mpc8xxx.c                            |    3=20
 drivers/gpu/drm/bridge/analogix-anx78xx.c              |    8 +
 drivers/gpu/drm/gma500/oaktrail_crtc.c                 |    2=20
 drivers/hid/hid-core.c                                 |    4=20
 drivers/iio/adc/max1027.c                              |    8 +
 drivers/iio/light/bh1750.c                             |    4=20
 drivers/infiniband/ulp/iser/iscsi_iser.c               |    1=20
 drivers/input/touchscreen/atmel_mxt_ts.c               |    4=20
 drivers/iommu/tegra-smmu.c                             |   11 +-
 drivers/irqchip/irq-bcm7038-l1.c                       |    4=20
 drivers/irqchip/irq-ingenic.c                          |   15 ++-
 drivers/md/bcache/btree.c                              |    2=20
 drivers/media/i2c/ov2659.c                             |   18 ++-
 drivers/media/i2c/soc_camera/ov6650.c                  |    9 +
 drivers/media/platform/am437x/am437x-vpfe.c            |    4=20
 drivers/media/platform/ti-vpe/vpe.c                    |   16 ++-
 drivers/media/radio/si470x/radio-si470x-i2c.c          |    2=20
 drivers/media/usb/b2c2/flexcop-usb.c                   |    8 +
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c               |    9 +
 drivers/mmc/host/sdhci-of-esdhc.c                      |    4=20
 drivers/mmc/host/sdhci.c                               |    6 -
 drivers/mmc/host/tmio_mmc_pio.c                        |    2=20
 drivers/net/ethernet/amazon/ena/ena_netdev.c           |   10 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c      |   16 ++-
 drivers/net/ethernet/hisilicon/hip04_eth.c             |    2=20
 drivers/net/ethernet/qlogic/qla3xxx.c                  |    8 -
 drivers/net/fjes/fjes_main.c                           |    3=20
 drivers/net/gtp.c                                      |   43 +++++----
 drivers/net/hamradio/6pack.c                           |    4=20
 drivers/net/hamradio/mkiss.c                           |    4=20
 drivers/net/phy/phy_device.c                           |    4=20
 drivers/net/usb/lan78xx.c                              |    1=20
 drivers/net/wireless/ath/ath10k/txrx.c                 |    2=20
 drivers/net/wireless/intel/iwlwifi/dvm/led.c           |    3=20
 drivers/net/wireless/intel/iwlwifi/mvm/led.c           |    3=20
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c            |    3=20
 drivers/net/wireless/marvell/libertas/if_sdio.c        |    5 +
 drivers/net/wireless/marvell/mwifiex/pcie.c            |    5 -
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h       |    1=20
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |    1=20
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |    3=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |    2=20
 drivers/net/wireless/realtek/rtlwifi/usb.c             |    5 -
 drivers/parport/share.c                                |   21 ++++
 drivers/pinctrl/intel/pinctrl-baytrail.c               |   81 +++++++++---=
-----
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                    |    4=20
 drivers/platform/x86/hp-wmi.c                          |    2=20
 drivers/regulator/max8907-regulator.c                  |   15 ++-
 drivers/scsi/atari_scsi.c                              |    6 -
 drivers/scsi/csiostor/csio_lnode.c                     |   15 +--
 drivers/scsi/lpfc/lpfc_els.c                           |    2=20
 drivers/scsi/lpfc/lpfc_nportdisc.c                     |    4=20
 drivers/scsi/lpfc/lpfc_sli.c                           |   15 ++-
 drivers/scsi/mac_scsi.c                                |    2=20
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                     |    3=20
 drivers/scsi/pm8001/pm80xx_hwi.c                       |    2=20
 drivers/scsi/scsi_debug.c                              |    5 +
 drivers/scsi/scsi_trace.c                              |   11 +-
 drivers/scsi/sun3_scsi.c                               |    4=20
 drivers/scsi/ufs/ufshcd.c                              |    2=20
 drivers/spi/spi-img-spfi.c                             |    2=20
 drivers/spi/spi-pxa2xx.c                               |    6 +
 drivers/spi/spi-st-ssc4.c                              |    3=20
 drivers/spi/spi-tegra20-slink.c                        |    5 -
 drivers/spi/spidev.c                                   |    3=20
 drivers/staging/comedi/drivers/gsc_hpdi.c              |   10 ++
 drivers/staging/fbtft/fbtft-core.c                     |    2=20
 drivers/staging/rtl8188eu/core/rtw_xmit.c              |    4=20
 drivers/staging/rtl8192u/r8192U_core.c                 |   17 ++-
 drivers/target/iscsi/iscsi_target.c                    |   10 +-
 drivers/target/iscsi/iscsi_target_auth.c               |    2=20
 drivers/tty/serial/atmel_serial.c                      |   43 ++++-----
 drivers/usb/core/devio.c                               |   15 ++-
 drivers/usb/host/ehci-q.c                              |   13 ++
 drivers/usb/host/xhci-pci.c                            |    2=20
 drivers/usb/renesas_usbhs/common.h                     |    3=20
 drivers/usb/renesas_usbhs/mod_gadget.c                 |   12 +-
 drivers/usb/usbip/vhci_rx.c                            |   13 +-
 drivers/vhost/vsock.c                                  |    4=20
 fs/btrfs/async-thread.c                                |   56 +++++++++--
 fs/btrfs/ctree.c                                       |    2=20
 fs/btrfs/disk-io.c                                     |    2=20
 fs/btrfs/extent_io.c                                   |    6 -
 fs/btrfs/inode.c                                       |   11 --
 fs/btrfs/ioctl.c                                       |   10 +-
 fs/btrfs/reada.c                                       |   10 --
 fs/btrfs/relocation.c                                  |    1=20
 fs/btrfs/tests/free-space-tree-tests.c                 |    6 -
 fs/btrfs/tests/qgroup-tests.c                          |    4=20
 fs/btrfs/tree-log.c                                    |   23 ++++
 fs/btrfs/uuid-tree.c                                   |    2=20
 fs/ext4/dir.c                                          |    5 +
 fs/ext4/namei.c                                        |   43 ++++-----
 fs/jbd2/commit.c                                       |    4=20
 fs/ocfs2/acl.c                                         |    4=20
 fs/quota/dquot.c                                       |   29 +++---
 fs/readdir.c                                           |   40 ++++++++
 include/drm/drm_dp_mst_helper.h                        |    2=20
 include/linux/cec-funcs.h                              |    6 -
 include/linux/hrtimer.h                                |   14 ++
 include/linux/libfdt_env.h                             |    3=20
 include/linux/mod_devicetable.h                        |    4=20
 include/linux/quota.h                                  |    2=20
 include/linux/rculist_nulls.h                          |   37 +++++++
 include/net/dst.h                                      |    2=20
 include/net/inet_hashtables.h                          |   12 +-
 include/net/sock.h                                     |    5 +
 include/scsi/iscsi_proto.h                             |    1=20
 kernel/sysctl.c                                        |    2=20
 kernel/time/hrtimer.c                                  |   11 +-
 lib/dma-debug.c                                        |    1=20
 net/bluetooth/hci_core.c                               |    9 +
 net/bluetooth/hci_request.c                            |    9 +
 net/bridge/br_netfilter_hooks.c                        |    3=20
 net/bridge/netfilter/ebtables.c                        |   33 +++---
 net/core/sysctl_net_core.c                             |    2=20
 net/ipv4/icmp.c                                        |   11 +-
 net/ipv4/inet_diag.c                                   |    3=20
 net/ipv4/inet_hashtables.c                             |   18 +--
 net/ipv4/tcp_ipv4.c                                    |    7 -
 net/ipv4/tcp_output.c                                  |    8 +
 net/ipv6/inet6_hashtables.c                            |    3=20
 net/nfc/nci/uart.c                                     |    2=20
 net/packet/af_packet.c                                 |    3=20
 net/sctp/protocol.c                                    |    4=20
 samples/pktgen/functions.sh                            |   17 ++-
 scripts/kallsyms.c                                     |    2=20
 sound/core/pcm_native.c                                |    4=20
 sound/core/timer.c                                     |   10 ++
 sound/pci/hda/hda_controller.c                         |    2=20
 sound/pci/hda/patch_ca0132.c                           |    7 +
 sound/soc/codecs/rt5677.c                              |    1=20
 tools/lib/traceevent/parse-filter.c                    |    9 +
 tools/objtool/arch/x86/lib/x86-opcode-map.txt          |   18 ++-
 tools/perf/builtin-report.c                            |    7 +
 tools/perf/tests/task-exit.c                           |    1=20
 tools/perf/util/dwarf-aux.c                            |   80 ++++++++++++=
+---
 tools/perf/util/dwarf-aux.h                            |    3=20
 tools/perf/util/perf_regs.h                            |    2=20
 tools/perf/util/probe-finder.c                         |   45 ++++++++-
 tools/perf/util/strbuf.c                               |    1=20
 tools/power/cpupower/utils/idle_monitor/hsw_ext_idle.c |    1=20
 174 files changed, 1109 insertions(+), 416 deletions(-)

Adrian Hunter (1):
      x86/insn: Add some Intel instructions to the opcode map

Alexander Lobakin (1):
      net, sysctl: Fix compiler warning when only cBPF is present

Allen Pais (1):
      libertas: fix a potential NULL pointer dereference

Andy Shevchenko (1):
      fbtft: Make sure string is NULL terminated

Aneesh Kumar K.V (2):
      powerpc/pseries: Don't fail hash page table insert for bolted mapping
      powerpc/book3s64/hash: Add cond_resched to avoid soft lockup warning

Anthony Steinhauser (1):
      powerpc/security/book3s64: Report L1TF status in sysfs

Arnaldo Carvalho de Melo (1):
      perf regs: Make perf_reg_name() return "unknown" instead of NULL

Bart Van Assche (2):
      scsi: tracing: Fix handling of TRANSFER LENGTH =3D=3D 0 for READ(6) a=
nd WRITE(6)
      scsi: target: iscsi: Wait for all commands to finish before freeing a=
 session

Bean Huo (1):
      scsi: ufs: fix potential bug which ends in system hang

Ben Hutchings (1):
      net: qlogic: Fix error paths in ql_alloc_large_buffers()

Ben Zhang (1):
      ASoC: rt5677: Mark reg RT5677_PWR_ANLG2 as volatile

Benjamin Berg (1):
      x86/mce: Lower throttling MCE messages' priority to warning

Benoit Parrot (6):
      media: am437x-vpfe: Setting STD to current value is not an error
      media: i2c: ov2659: fix s_stream return value
      media: i2c: ov2659: Fix missing 720p register config
      media: ti-vpe: vpe: fix a v4l2-compliance warning about invalid pixel=
 format
      media: ti-vpe: vpe: fix a v4l2-compliance failure about frame sequenc=
e number
      media: ti-vpe: vpe: Make sure YUYV is set as default format

Bla=C5=BE Hrastnik (1):
      HID: Improve Windows Precision Touchpad detection.

Brian Masney (1):
      drm/bridge: analogix-anx78xx: silence -EPROBE_DEFER warnings

Chris Chiu (1):
      rtl8xxxu: fix RTL8723BU connection failure issue after warm reboot

Christophe Leroy (1):
      powerpc/irq: fix stack overflow verification

Chuhong Yuan (6):
      media: si470x-i2c: add missed operations in remove
      spi: pxa2xx: Add missed security checks
      spi: tegra20-slink: add missed clk_unprepare
      spi: st-ssc4: add missed pm_runtime_disable
      fjes: fix missed check in fjes_acpi_add
      clocksource/drivers/asm9260: Add a check for of_clk_get

Coly Li (1):
      bcache: at least try to shrink 1 node in bch_mca_scan()

Connor Kuehl (1):
      staging: rtl8188eu: fix possible null dereference

Corentin Labbe (1):
      crypto: sun4i-ss - Fix 64-bit size_t warnings on sun4i-ss-hash.c

Cristian Birsan (1):
      net: usb: lan78xx: Fix suspend/resume PHY register access error

Dan Carpenter (2):
      btrfs: return error pointer from alloc_test_extent_buffer
      scsi: csiostor: Don't enable IRQs too early

Daniel T. Lee (1):
      samples: pktgen: fix proc_cmd command result check logic

David Disseldorp (1):
      scsi: target: compare full CHAP_A Algorithm strings

David Engraf (1):
      tty/serial: atmel: fix out of range clock divider handling

David Hildenbrand (1):
      powerpc/pseries/cmm: Implement release() function for sysfs device

Diego Elio Petten=C3=B2 (1):
      cdrom: respect device capabilities during opening action

Ding Xiang (1):
      ocfs2: fix passing zero to 'PTR_ERR' warning

Eric Dumazet (7):
      dma-debug: add a schedule point in debug_dma_dump_mappings()
      6pack,mkiss: fix possible deadlock
      netfilter: bridge: make sure to pull arp header in br_nf_forward_arp()
      net: icmp: fix data-race in cmp_global_allow()
      hrtimer: Annotate lockless access to timer->state
      tcp/dccp: fix possible race __inet_lookup_established()
      tcp: do not send empty skb from tcp_write_xmit()

Erkka Talvitie (1):
      USB: EHCI: Do not return -EPIPE when hub is disconnected

Eugeniu Rosca (1):
      mmc: tmio: Add MMC_CAP_ERASE to allow erase/discard/trim requests

Evan Green (1):
      Input: atmel_mxt_ts - disable IRQ across suspend

Faiz Abbas (2):
      Revert "mmc: sdhci: Fix incorrect switch to HS mode"
      mmc: sdhci: Update the tuning failed messages to pr_debug level

Filipe Manana (1):
      Btrfs: fix removal logic of the tree mod log that leads to use-after-=
free issues

Finn Thain (1):
      scsi: atari_scsi: sun3_scsi: Set sg_tablesize to 1 instead of SG_NONE

Florian Fainelli (1):
      irqchip/irq-bcm7038-l1: Enable parent IRQ if necessary

Florian Westphal (1):
      netfilter: ebtables: compat: reject all padding in matches/watchers

Geert Uytterhoeven (2):
      pinctrl: sh-pfc: sh7734: Fix duplicate TCLK1_B
      net: dst: Force 4-byte alignment of dst_metrics

Greg Kroah-Hartman (1):
      Linux 4.9.208

Guenter Roeck (1):
      usb: xhci: Fix build warning seen with CONFIG_PM=3Dn

Gustavo L. F. Walbon (1):
      powerpc/security: Fix wrong message when RFI Flush is disable

Hans Verkuil (1):
      media: cec-funcs.h: add status_req checks

Hans de Goede (2):
      platform/x86: hp-wmi: Make buffer for HPWMI_FEATURE2_QUERY 128 bytes
      pinctrl: baytrail: Really serialize all register accesses

Hewenliang (1):
      libtraceevent: Fix memory leakage in copy_filter_type

Ian Abbott (1):
      staging: comedi: gsc_hpdi: check dma_alloc_coherent() return value

Ilya Leoshkevich (1):
      s390/disassembler: don't hide instruction addresses

Ingo Rohloff (1):
      usb: usbfs: Suppress problematic bind and unbind uevents.

James Smart (4):
      scsi: lpfc: Fix locking on mailbox command completion
      scsi: lpfc: Fix SLI3 hba in loop mode not discovering devices
      scsi: lpfc: Fix duplicate unreg_rpi error in port offline flow
      scsi: lpfc: fix: Coverity: lpfc_cmpl_els_rsp(): Null pointer derefere=
nces

Jan H. Sch=C3=B6nherr (1):
      x86/mce: Fix possibly incorrect severity calculation on AMD

Jan Kara (3):
      ext4: fix ext4_empty_dir() for directories with holes
      ext4: check for directory entries too close to block end
      jbd2: Fix statistics for the number of logged blocks

Janusz Krzysztofik (1):
      media: ov6650: Fix stored frame format not in sync with hardware

Jeffrey Hugo (1):
      clk: qcom: Allow constant ratio freq tables for rcg

Jia-Ju Bai (1):
      net: nfc: nci: fix a possible sleep-in-atomic-context bug in nci_uart=
_tty_receive()

Jiangfeng Xiao (1):
      net: hisilicon: Fix a BUG trigered by wrong bytes_compl

Jin Yao (1):
      perf report: Add warning when libunwind not compiled in

Johannes Berg (1):
      iwlwifi: check kasprintf() return value

Johannes Weiner (1):
      kernel: sysctl: make drop_caches write-only

John Garry (1):
      libata: Ensure ata_port probe has completed before detach

Josef Bacik (6):
      btrfs: skip log replay on orphaned roots
      btrfs: do not leak reloc root if we fail to read the fs root
      btrfs: handle ENOENT in btrfs_uuid_tree_iterate
      btrfs: don't double lock the subvol_sem for rename exchange
      btrfs: do not call synchronize_srcu() in inode_tree_del
      btrfs: abort transaction after failed inode updates in create_subvol

Kangjie Lu (1):
      drm/gma500: fix memory disclosures due to uninitialized bytes

Konstantin Khlebnikov (1):
      fs/quota: handle overflows of sysctl fs.quota.* and report as unsigne=
d long

Krzysztof Wilczynski (1):
      iio: light: bh1750: Resolve compiler warning and make code more reada=
ble

Leo Yan (1):
      perf test: Report failure for mmap events

Lianbo Jiang (1):
      x86/crash: Add a forward declaration of struct kimage

Linus Torvalds (2):
      Make filldir[64]() verify the directory entry filename is valid
      filldir[64]: remove WARN_ON_ONCE() for bad directory entries

Luiz Augusto von Dentz (1):
      Bluetooth: Fix advertising duplicated flags

Lukasz Majewski (1):
      spi: Add call to spi_slave_abort() function when spidev driver is rel=
eased

Manish Chopra (1):
      bnx2x: Fix PF-VF communication over multi-cos queues.

Mao Wenan (1):
      af_packet: set defaule value for tmo

Masahiro Yamada (2):
      scripts/kallsyms: fix definitely-lost memory leak
      libfdt: define INT32_MAX and UINT32_MAX in libfdt_env.h

Masami Hiramatsu (13):
      perf probe: Fix to find range-only function instance
      perf probe: Fix to list probe event with correct line number
      perf probe: Walk function lines in lexical blocks
      perf probe: Fix to probe an inline function which has no entry pc
      perf probe: Fix to show ranges of variables in functions without entr=
y_pc
      perf probe: Fix to show inlined function callsite without entry_pc
      perf probe: Fix to probe a function which has no entry pc
      perf probe: Skip overlapped location on searching variables
      perf probe: Return a better scope DIE if there is no best scope
      perf probe: Fix to show calling lines of inlined functions
      perf probe: Skip end-of-sequence and non statement lines
      perf probe: Filter out instances except for inlined subroutine and su=
bprogram
      perf probe: Fix to show function entry line as probe-able

Mattias Jacobsson (1):
      perf strbuf: Remove redundant va_end() in strbuf_addv()

Mattijs Korpershoek (1):
      Bluetooth: hci_core: fix init for HCI_USER_CHANNEL

Maurizio Lombardi (1):
      scsi: scsi_debug: num_tgts must be >=3D 0

Max Gurtovoy (1):
      IB/iser: bound protection_sg size by data_sg size

Miaoqing Pan (1):
      ath10k: fix get invalid tx rate for Mesh metric

Michael Ellerman (2):
      crypto: vmx - Avoid weird build failures
      powerpc/pseries: Mark accumulate_stolen_time() as notrace

Mike Isely (1):
      media: pvrusb2: Fix oops on tear-down when radio support is not prese=
nt

Miquel Raynal (1):
      iio: adc: max1027: Reset the device at probe time

Nathan Chancellor (1):
      tools/power/cpupower: Fix initializer override in hsw_ext_cstates

Navid Emamdoost (3):
      staging: rtl8192u: fix multiple memory leaks on error path
      rtlwifi: prevent memory leak in rtl_usb_probe
      mwifiex: pcie: Fix memory leak in mwifiex_pcie_init_evt_ring

Netanel Belgazal (1):
      net: ena: fix napi handler misbehavior when the napi budget is zero

Omar Sandoval (3):
      btrfs: don't prematurely free work in end_workqueue_fn()
      btrfs: don't prematurely free work in run_ordered_work()
      btrfs: don't prematurely free work in reada_start_machine_worker()

Pan Bian (1):
      spi: img-spfi: fix potential double release

Paul Cercueil (1):
      irqchip: ingenic: Error out if IRQ domain creation failed

Ping-Ke Shih (1):
      rtlwifi: fix memory leak in rtl92c_set_fw_rsvdpagepkt()

Robert Jarzmik (1):
      clk: pxa: fix one of the pxa RTC clocks

Robert Richter (1):
      EDAC/ghes: Fix grain calculation

Russell King (2):
      net: phy: initialise phydev speed and duplex sanely
      mod_devicetable: fix PHY module format

Sami Tolvanen (1):
      x86/mm: Use the correct function type for native_set_fixmap()

Sean Paul (1):
      drm: mst: Fix query_payload ack reply struct

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix clear pending bit in ioctl status

Stefano Garzarella (1):
      vhost/vsock: accept only packets with the right dst_cid

Stephan Gerhold (1):
      extcon: sm5502: Reset registers during initialization

Sudip Mukherjee (1):
      parport: load lowlevel driver if ports not found

Suwan Kim (1):
      usbip: Fix error path of vhci_recv_ret_submit()

Taehee Yoo (2):
      gtp: fix wrong condition in gtp_genl_dump_pdp()
      gtp: avoid zero size hashtable

Takashi Iwai (5):
      ALSA: pcm: Avoid possible info leaks from PCM stream buffers
      ALSA: hda/ca0132 - Keep power on during processing DSP response
      ALSA: hda/ca0132 - Avoid endless loop
      ALSA: timer: Limit max amount of slave instances
      ALSA: hda - Downgrade error message for single-cmd fallback

Theodore Ts'o (1):
      ext4: work around deleting a file with i_nlink =3D=3D 0 safely

Thierry Reding (1):
      iommu/tegra-smmu: Fix page tables in > 4 GiB memory

Thomas Gleixner (1):
      x86/ioapic: Prevent inconsistent state when moving an interrupt

Thomas Richter (1):
      s390/cpum_sf: Check for SDBT and SDB consistency

Tony Lindgren (1):
      hwrng: omap3-rom - Call clk_disable_unprepare() on exit only if not i=
dled

Veeraiyan Chidambaram (1):
      usb: renesas_usbhs: add suspend event support in gadget mode

Viresh Kumar (1):
      cpufreq: Register drivers only after CPU devices have been registered

Vladimir Oltean (1):
      gpio: mpc8xxx: Don't overwrite default irq_set_type callback

Wang Xuerui (1):
      iwlwifi: mvm: fix unaligned read of rx_pkt_status

Xin Long (1):
      sctp: fully initialize v4 addr in some functions

Yang Yingliang (1):
      media: flexcop-usb: fix NULL-ptr deref in flexcop_usb_transfer_init()

Yangbo Lu (1):
      mmc: sdhci-of-esdhc: fix P2020 errata handling

Yizhuo (1):
      regulator: max8907: Fix the usage of uninitialized variable in max890=
7_regulator_probe()

Yunfeng Ye (1):
      arm64: psci: Reduce the waiting time for cpu_psci_cpu_kill()

peter chang (1):
      scsi: pm80xx: Fix for SATA device discovery


--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4SMSkACgkQONu9yGCS
aT5kkw//QAs7pPq3fj5cydXK/5GxzXI6Tki0Xtz7ZWFKZJei4JnnZ/Q4AgnLCywz
sU4zQyobDUG3wjg2IO+TzCq1n56Va7WdSPdylRVNxNR8/JkEa2K+JeSwEeskM82v
0RrM/e3x+iZf0C72QmLbdqT0116k+S9y9qbxCKgsvCNMfARdYIcHu1GOyngxMZqe
VDopbKUTQGIv5/XRaV7hONI3NBbl60SqgKVWw/623DYW6jWEZlWcH3XHW9ndgHfa
UfPagJSIJ4NzzWtRGKctNHrgngGHthMrVxEt5uN4GNKfJ0F9rDTBSKDGIc5ANRPp
6uZGFl3or5XsAz6Aa8Hh9uMShyGne75qUKtKn4Otqo2yCkrOvHN9oefMF/DSFuSN
xYBD0Od7LRo2Ad8R89/BIg+fllZrq7kU0WoUU24/wYQGBOMycQug/9PSLptJKE4Z
kyXsiyoG9i6p3FkQeOs3N8WfIJqKjPwI5gUUqCqdAMAexntwVFVB9DmswCUOGqcE
ZZs2IRJIOTeFBI4eA30YM5hzqa1sQo6G8hE6KcdSB50+wIhNeXSMT6M6A8xyEcZW
TjHw1FnGs8POdsR6MqXXMNIKEmYeU8wDplgpM7X/P2gEPLxoVfIfDBxTKa3+EW94
WYftgeNEms6R/WXtw5TwCich0/RuuKyMZ32U4VP7rEnl9HYYkVA=
=uGIX
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
