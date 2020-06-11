Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5530A1F62E3
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 09:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgFKHqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 03:46:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbgFKHqH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 03:46:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 745ED20814;
        Thu, 11 Jun 2020 07:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591861564;
        bh=SOtcQ5sEp5tZOSN8p+ynfiPobeBcljGVDMPm4V0fBFE=;
        h=From:To:Cc:Subject:Date:From;
        b=qlCbvN78PQuAUjNuBU9Yi8/tORxQB3FjGWqQiC1njeobi3qV+MQX0awBFsjy3z/xx
         mXTm3pQusgjaGMZz782u8Su88zAsYVOTm6ivGHlL8pSanxBtVbxbztYczK/BgGhECF
         ArwBOj8Kqjnh3LFRx9snqxem4wyY6PDye35JvVRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.184
Date:   Thu, 11 Jun 2020 09:45:55 +0200
Message-Id: <1591861555120247@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.184 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu                          |    1 
 Documentation/admin-guide/hw-vuln/index.rst                                 |    1 
 Documentation/admin-guide/hw-vuln/special-register-buffer-data-sampling.rst |  149 ++++++++++
 Documentation/admin-guide/kernel-parameters.txt                             |   20 +
 Makefile                                                                    |    2 
 arch/arc/kernel/setup.c                                                     |    5 
 arch/arc/plat-eznps/Kconfig                                                 |    1 
 arch/s390/kernel/mcount.S                                                   |    1 
 arch/x86/include/asm/cpu_device_id.h                                        |   27 +
 arch/x86/include/asm/cpufeatures.h                                          |    2 
 arch/x86/include/asm/msr-index.h                                            |    4 
 arch/x86/include/asm/pgtable.h                                              |    1 
 arch/x86/kernel/cpu/bugs.c                                                  |  106 +++++++
 arch/x86/kernel/cpu/common.c                                                |   54 ++-
 arch/x86/kernel/cpu/cpu.h                                                   |    1 
 arch/x86/kernel/cpu/match.c                                                 |    7 
 arch/x86/mm/mmio-mod.c                                                      |    4 
 drivers/base/cpu.c                                                          |    8 
 drivers/hid/hid-sony.c                                                      |   17 +
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c                                    |    8 
 drivers/i2c/busses/i2c-altera.c                                             |   10 
 drivers/iio/light/vcnl4000.c                                                |    6 
 drivers/net/ethernet/apple/bmac.c                                           |    2 
 drivers/net/ethernet/freescale/ucc_geth.c                                   |   13 
 drivers/net/ethernet/smsc/smsc911x.c                                        |    9 
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c                         |   13 
 drivers/net/ppp/pppoe.c                                                     |    3 
 drivers/net/usb/qmi_wwan.c                                                  |    1 
 drivers/net/wireless/cisco/airo.c                                           |   12 
 drivers/net/wireless/intersil/p54/p54usb.c                                  |    1 
 drivers/nfc/st21nfca/dep.c                                                  |    4 
 drivers/nvdimm/btt.c                                                        |    8 
 drivers/nvdimm/namespace_devs.c                                             |    7 
 drivers/nvmem/qfprom.c                                                      |   14 
 drivers/scsi/hisi_sas/hisi_sas_main.c                                       |    3 
 drivers/scsi/scsi_devinfo.c                                                 |   23 -
 drivers/scsi/ufs/ufshcd.c                                                   |    1 
 drivers/spi/spi-dw.c                                                        |    3 
 drivers/staging/rtl8712/wifi.h                                              |    9 
 drivers/tty/hvc/hvc_console.c                                               |   23 -
 drivers/tty/vt/keyboard.c                                                   |   26 +
 drivers/usb/class/cdc-acm.c                                                 |    2 
 drivers/usb/musb/musb_core.c                                                |    7 
 drivers/usb/musb/musb_debugfs.c                                             |   10 
 drivers/usb/serial/option.c                                                 |    4 
 drivers/usb/serial/qcserial.c                                               |    1 
 drivers/usb/serial/usb_wwan.c                                               |    4 
 include/linux/mod_devicetable.h                                             |    6 
 include/linux/virtio_net.h                                                  |   14 
 include/uapi/linux/mmc/ioctl.h                                              |    1 
 kernel/events/uprobes.c                                                     |   14 
 kernel/relay.c                                                              |    5 
 mm/mremap.c                                                                 |    2 
 net/ipv4/devinet.c                                                          |    1 
 net/l2tp/l2tp_core.c                                                        |    2 
 net/l2tp/l2tp_ip.c                                                          |   29 +
 net/l2tp/l2tp_ip6.c                                                         |   30 +-
 net/vmw_vsock/af_vsock.c                                                    |    2 
 58 files changed, 617 insertions(+), 127 deletions(-)

Aneesh Kumar K.V (1):
      libnvdimm: Fix endian conversion issues 

Atsushi Nemoto (1):
      i2c: altera: Fix race between xfer_msg and isr thread

Bin Liu (2):
      USB: serial: usb_wwan: do not resubmit rx urb on fatal errors
      usb: musb: start session in resume for host port

Can Guo (1):
      scsi: ufs: Release clock if DMA map fails

Chuhong Yuan (1):
      NFC: st21nfca: add missed kfree_skb() in an error path

Dan Carpenter (1):
      airo: Fix read overflows sending packets

Daniel Axtens (1):
      kernel/relay.c: handle alloc_percpu returning NULL in relay_open

Daniele Palmas (2):
      net: usb: qmi_wwan: add Telit LE910C1-EUX composition
      USB: serial: option: add Telit LE910C1-EUX compositions

Dinghao Liu (2):
      net: smsc911x: Fix runtime PM imbalance on error
      usb: musb: Fix runtime PM imbalance on error

Dmitry Torokhov (1):
      vt: keyboard: avoid signed integer overflow in k_ascii

Eric Dumazet (2):
      l2tp: do not use inet_hash()/inet_unhash()
      l2tp: add sk_family checks to l2tp_validate_socket

Eugeniy Paltsev (1):
      ARC: Fix ICCM & DCCM runtime size checks

Fan Yang (1):
      mm: Fix mremap not considering huge pmd devmap

Giuseppe Marco Randazzo (1):
      p54usb: add AirVasT USB stick device-id

Greg Kroah-Hartman (1):
      Linux 4.14.184

Guillaume Nault (1):
      pppoe: only process PADT targeted at local interfaces

Hannes Reinecke (1):
      scsi: scsi_devinfo: fixup string compare

Jeremy Kerr (1):
      net: bmac: Fix read of MAC address from ROM

Jiri Slaby (1):
      tty: hvc_console, fix crashes on parallel open/close

Jonathan McDowell (1):
      net: ethernet: stmmac: Enable interface clocks on probe for IPQ806x

Josh Poimboeuf (1):
      x86/speculation: Add Ivy Bridge to affected list

Julian Sax (1):
      HID: i2c-hid: add Schneider SCL142ALM to descriptor override

Jérôme Pouiller (1):
      mmc: fix compilation of user API

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

Oliver Neukum (1):
      CDC-ACM: heed quirk also in error handling

Pascal Terjan (1):
      staging: rtl8712: Fix IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK

Scott Shumate (1):
      HID: sony: Fix for broken buttons on DS3 USB dongles

Srinivas Kandagatla (1):
      nvmem: qfprom: remove incorrect write support

Stefano Garzarella (1):
      vsock: fix timeout in vsock_accept()

Valentin Longchamp (1):
      net/ethernet/freescale: rework quiesce/activate for ucc_geth

Vasily Gorbik (1):
      s390/ftrace: save traced function caller

Vineet Gupta (1):
      ARC: [plat-eznps]: Restrict to CONFIG_ISA_ARCOMPACT

Willem de Bruijn (1):
      net: check untrusted gso_size at kernel entry

Xiang Chen (1):
      scsi: hisi_sas: Check sas_port before using it

Xinwei Kong (1):
      spi: dw: use "smp_mb()" to avoid sending spi data error

Yang Yingliang (1):
      devinet: fix memleak in inetdev_init()

