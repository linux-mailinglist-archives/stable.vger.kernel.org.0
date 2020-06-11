Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726B71F62DC
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 09:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgFKHpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 03:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbgFKHpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 03:45:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64AF92074B;
        Thu, 11 Jun 2020 07:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591861549;
        bh=HHcsutLMdEQy0hYT0qxq+tPnvS7NpBsbzyRAcI6BozI=;
        h=From:To:Cc:Subject:Date:From;
        b=OWUUbmbEtPOu+tT21rSQZRsoxtRhlS6Sn8lxsyAgyqAcj66tcOYQ1wYxIhESMiTg4
         mGhr/gaZi8Km1WclUs28JykMbTbXpx3XJWAvQVwOiSYfrvHKcdaflxMvmXk5ZYA3qq
         59lakZrgmEBjrfw6ETIrm6QJktWitop/DUDEonsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.227
Date:   Thu, 11 Jun 2020 09:45:41 +0200
Message-Id: <1591861541165242@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.227 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu              |    1 
 Documentation/hw-vuln/special-register-buffer-data-sampling.rst |  149 ++++++++++
 Documentation/kernel-parameters.txt                             |   20 +
 Makefile                                                        |    2 
 arch/arc/kernel/setup.c                                         |    5 
 arch/s390/kernel/mcount.S                                       |    1 
 arch/x86/include/asm/acpi.h                                     |    2 
 arch/x86/include/asm/cpu_device_id.h                            |   27 +
 arch/x86/include/asm/cpufeatures.h                              |    2 
 arch/x86/include/asm/msr-index.h                                |    4 
 arch/x86/include/asm/processor.h                                |    2 
 arch/x86/kernel/amd_nb.c                                        |    2 
 arch/x86/kernel/asm-offsets_32.c                                |    2 
 arch/x86/kernel/cpu/amd.c                                       |   26 -
 arch/x86/kernel/cpu/bugs.c                                      |  106 +++++++
 arch/x86/kernel/cpu/centaur.c                                   |    4 
 arch/x86/kernel/cpu/common.c                                    |   62 +++-
 arch/x86/kernel/cpu/cpu.h                                       |    1 
 arch/x86/kernel/cpu/cyrix.c                                     |    2 
 arch/x86/kernel/cpu/intel.c                                     |   20 -
 arch/x86/kernel/cpu/match.c                                     |    7 
 arch/x86/kernel/cpu/microcode/intel.c                           |    4 
 arch/x86/kernel/cpu/mtrr/generic.c                              |    2 
 arch/x86/kernel/cpu/mtrr/main.c                                 |    4 
 arch/x86/kernel/cpu/perf_event_intel.c                          |    2 
 arch/x86/kernel/cpu/perf_event_intel_lbr.c                      |    2 
 arch/x86/kernel/cpu/perf_event_p6.c                             |    2 
 arch/x86/kernel/cpu/proc.c                                      |    4 
 arch/x86/kernel/head_32.S                                       |    4 
 arch/x86/kernel/mpparse.c                                       |    2 
 arch/x86/mm/mmio-mod.c                                          |    4 
 drivers/base/cpu.c                                              |    8 
 drivers/char/hw_random/via-rng.c                                |    2 
 drivers/cpufreq/acpi-cpufreq.c                                  |    2 
 drivers/cpufreq/longhaul.c                                      |    6 
 drivers/cpufreq/p4-clockmod.c                                   |    2 
 drivers/cpufreq/powernow-k7.c                                   |    2 
 drivers/cpufreq/speedstep-centrino.c                            |    4 
 drivers/cpufreq/speedstep-lib.c                                 |    6 
 drivers/crypto/padlock-aes.c                                    |    2 
 drivers/edac/amd64_edac.c                                       |    2 
 drivers/edac/mce_amd.c                                          |    2 
 drivers/hwmon/coretemp.c                                        |    6 
 drivers/hwmon/hwmon-vid.c                                       |    2 
 drivers/hwmon/k10temp.c                                         |    2 
 drivers/hwmon/k8temp.c                                          |    2 
 drivers/iio/light/vcnl4000.c                                    |    6 
 drivers/infiniband/hw/mlx4/mr.c                                 |    7 
 drivers/net/can/slcan.c                                         |    3 
 drivers/net/ethernet/apple/bmac.c                               |    2 
 drivers/net/ethernet/freescale/ucc_geth.c                       |   13 
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c             |   13 
 drivers/net/ppp/pppoe.c                                         |    3 
 drivers/net/slip/slip.c                                         |    3 
 drivers/nfc/st21nfca/dep.c                                      |    4 
 drivers/platform/x86/acer-wmi.c                                 |    9 
 drivers/scsi/scsi_devinfo.c                                     |   23 -
 drivers/scsi/ufs/ufshcd.c                                       |    1 
 drivers/spi/spi-dw.c                                            |    3 
 drivers/staging/rtl8712/wifi.h                                  |    9 
 drivers/tty/vt/keyboard.c                                       |   26 +
 drivers/usb/gadget/function/f_uac2.c                            |    4 
 drivers/usb/serial/option.c                                     |    4 
 drivers/usb/serial/qcserial.c                                   |    1 
 drivers/usb/serial/usb_wwan.c                                   |    4 
 drivers/video/fbdev/geode/video_gx.c                            |    2 
 include/linux/mod_devicetable.h                                 |    6 
 include/uapi/linux/mmc/ioctl.h                                  |    1 
 kernel/events/uprobes.c                                         |   14 
 net/ipv4/devinet.c                                              |    1 
 net/ipv6/esp6.c                                                 |    4 
 net/l2tp/l2tp_core.c                                            |    2 
 net/l2tp/l2tp_ip.c                                              |   28 +
 net/l2tp/l2tp_ip6.c                                             |   28 +
 net/vmw_vsock/af_vsock.c                                        |    2 
 sound/pci/hda/patch_realtek.c                                   |    3 
 76 files changed, 600 insertions(+), 156 deletions(-)

Ben Hutchings (1):
      slcan: Fix double-free on slcan_open() error path

Bin Liu (1):
      USB: serial: usb_wwan: do not resubmit rx urb on fatal errors

Can Guo (1):
      scsi: ufs: Release clock if DMA map fails

Christophe Jaillet (1):
      IB/mlx4: Fix an error handling path in 'mlx4_ib_rereg_user_mr()'

Chuhong Yuan (1):
      NFC: st21nfca: add missed kfree_skb() in an error path

Daniele Palmas (1):
      USB: serial: option: add Telit LE910C1-EUX compositions

Dmitry Torokhov (1):
      vt: keyboard: avoid signed integer overflow in k_ascii

Eric Dumazet (2):
      l2tp: add sk_family checks to l2tp_validate_socket
      l2tp: do not use inet_hash()/inet_unhash()

Eugeniu Rosca (1):
      usb: gadget: f_uac2: fix error handling in afunc_bind (again)

Eugeniy Paltsev (1):
      ARC: Fix ICCM & DCCM runtime size checks

Greg Kroah-Hartman (1):
      Linux 4.4.227

Guillaume Nault (1):
      pppoe: only process PADT targeted at local interfaces

Hannes Reinecke (1):
      scsi: scsi_devinfo: fixup string compare

Jeremy Kerr (1):
      net: bmac: Fix read of MAC address from ROM

Jia Zhang (1):
      x86/cpu: Rename cpu_data.x86_mask to cpu_data.x86_stepping

Jonathan McDowell (1):
      net: ethernet: stmmac: Enable interface clocks on probe for IPQ806x

Josh Poimboeuf (1):
      x86/speculation: Add Ivy Bridge to affected list

Jérôme Pouiller (1):
      mmc: fix compilation of user API

Lee, Chun-Yi (1):
      platform/x86: acer-wmi: setup accelerometer when ACPI device was found

Mark Gross (4):
      x86/cpu: Add a steppings field to struct x86_cpu_id
      x86/cpu: Add 'table' argument to cpu_matches()
      x86/speculation: Add Special Register Buffer Data Sampling (SRBDS) mitigation
      x86/speculation: Add SRBDS vulnerability and mitigation documentation

Mathieu Othacehe (1):
      iio: vcnl4000: Fix i2c swapped word reading.

Matt Jolly (1):
      USB: serial: qcserial: add DW5816e QDL support

Nathan Chancellor (1):
      x86/mmiotrace: Use cpumask_available() for cpumask_var_t variables

Oleg Nesterov (1):
      uprobes: ensure that uprobe->offset and ->ref_ctr_offset are properly aligned

Pascal Terjan (1):
      staging: rtl8712: Fix IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK

Stefano Garzarella (1):
      vsock: fix timeout in vsock_accept()

Takashi Iwai (1):
      ALSA: hda - No loopback on ALC299 codec

Valentin Longchamp (1):
      net/ethernet/freescale: rework quiesce/activate for ucc_geth

Vasily Gorbik (1):
      s390/ftrace: save traced function caller

Xinwei Kong (1):
      spi: dw: use "smp_mb()" to avoid sending spi data error

Yang Yingliang (1):
      devinet: fix memleak in inetdev_init()

Zhen Lei (1):
      esp6: fix memleak on error path in esp6_input

yangerkun (1):
      slip: not call free_netdev before rtnl_unlock in slip_open

