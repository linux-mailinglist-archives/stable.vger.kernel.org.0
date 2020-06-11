Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31791F6222
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 09:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgFKHU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 03:20:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgFKHUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 03:20:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5AA12074B;
        Thu, 11 Jun 2020 07:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591860052;
        bh=wryQOEqCvB3LT1mDnP5wE6WUUMvLji/WCUYOA1o1gXQ=;
        h=From:To:Cc:Subject:Date:From;
        b=bnSDGjECZmkSGIy8rrnZh7jtKj+ldW1m4kaPkaeWBdo/Vho0ofYfIv0oKJBrWHUTH
         hvlJejjLWPUDeFfhy9jwgTyrjRMX8RCmlnCGA0pxwwVuXdcPiIvLzGOZi+yyhSczgm
         rCERBZM8K3Zw+zMJsXkp4uGpO9Ic6vjgGE9oeHlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.46
Date:   Thu, 11 Jun 2020 09:20:36 +0200
Message-Id: <159186003613253@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.46 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
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
 arch/x86/include/asm/cpu_device_id.h                                        |   30 ++
 arch/x86/include/asm/cpufeatures.h                                          |    2 
 arch/x86/include/asm/msr-index.h                                            |    4 
 arch/x86/kernel/cpu/bugs.c                                                  |  106 +++++++
 arch/x86/kernel/cpu/common.c                                                |   63 +++-
 arch/x86/kernel/cpu/cpu.h                                                   |    1 
 arch/x86/kernel/cpu/match.c                                                 |    7 
 drivers/base/cpu.c                                                          |    8 
 drivers/iio/adc/stm32-adc-core.c                                            |   34 --
 drivers/iio/chemical/pms7003.c                                              |   17 -
 drivers/iio/chemical/sps30.c                                                |    9 
 drivers/iio/light/vcnl4000.c                                                |    6 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c                           |    6 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                              |   18 +
 drivers/net/ethernet/netronome/nfp/flower/offload.c                         |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                           |    3 
 drivers/net/usb/qmi_wwan.c                                                  |    1 
 drivers/nfc/st21nfca/dep.c                                                  |    4 
 drivers/nvmem/qfprom.c                                                      |   14 
 drivers/staging/rtl8712/wifi.h                                              |    9 
 drivers/tty/hvc/hvc_console.c                                               |   23 -
 drivers/tty/vt/keyboard.c                                                   |   26 +
 drivers/usb/class/cdc-acm.c                                                 |    2 
 drivers/usb/musb/musb_core.c                                                |    7 
 drivers/usb/musb/musb_debugfs.c                                             |   10 
 drivers/usb/serial/ch341.c                                                  |   53 +++
 drivers/usb/serial/option.c                                                 |    4 
 drivers/usb/serial/qcserial.c                                               |    1 
 drivers/usb/serial/usb_wwan.c                                               |    4 
 include/linux/mod_devicetable.h                                             |    6 
 include/linux/virtio_net.h                                                  |   25 +
 kernel/events/uprobes.c                                                     |   16 -
 net/ipv4/devinet.c                                                          |    1 
 net/l2tp/l2tp_core.c                                                        |    3 
 net/l2tp/l2tp_ip.c                                                          |   29 +
 net/l2tp/l2tp_ip6.c                                                         |   30 +-
 net/vmw_vsock/af_vsock.c                                                    |    2 
 42 files changed, 626 insertions(+), 134 deletions(-)

Bin Liu (2):
      USB: serial: usb_wwan: do not resubmit rx urb on fatal errors
      usb: musb: start session in resume for host port

Chuhong Yuan (1):
      NFC: st21nfca: add missed kfree_skb() in an error path

Daniele Palmas (2):
      net: usb: qmi_wwan: add Telit LE910C1-EUX composition
      USB: serial: option: add Telit LE910C1-EUX compositions

Dinghao Liu (1):
      usb: musb: Fix runtime PM imbalance on error

Dmitry Torokhov (1):
      vt: keyboard: avoid signed integer overflow in k_ascii

Eric Dumazet (3):
      l2tp: add sk_family checks to l2tp_validate_socket
      l2tp: do not use inet_hash()/inet_unhash()
      net: be more gentle about silly gso requests coming from user

Fabrice Gasnier (1):
      iio: adc: stm32-adc: fix a wrong error message when probing interrupts

Fugang Duan (1):
      net: stmmac: enable timestamp snapshot for required PTP packets in dwmac v5.10a

Greg Kroah-Hartman (2):
      Revert "net/mlx5: Annotate mutex destroy for root ns"
      Linux 5.4.46

Heinrich Kuhn (1):
      nfp: flower: fix used time of merge flow statistics

Jiri Slaby (1):
      tty: hvc_console, fix crashes on parallel open/close

Jonathan Cameron (2):
      iio:chemical:sps30: Fix timestamp alignment
      iio:chemical:pms7003: Fix timestamp alignment and prevent data leak.

Josh Poimboeuf (1):
      x86/speculation: Add Ivy Bridge to affected list

Mark Bloch (1):
      net/mlx5: Fix crash upon suspend/resume

Mark Gross (4):
      x86/cpu: Add a steppings field to struct x86_cpu_id
      x86/cpu: Add 'table' argument to cpu_matches()
      x86/speculation: Add Special Register Buffer Data Sampling (SRBDS) mitigation
      x86/speculation: Add SRBDS vulnerability and mitigation documentation

Mathieu Othacehe (1):
      iio: vcnl4000: Fix i2c swapped word reading.

Matt Jolly (1):
      USB: serial: qcserial: add DW5816e QDL support

Michael Hanselmann (1):
      USB: serial: ch341: add basis for quirk detection

Oleg Nesterov (1):
      uprobes: ensure that uprobe->offset and ->ref_ctr_offset are properly aligned

Oliver Neukum (1):
      CDC-ACM: heed quirk also in error handling

Pascal Terjan (1):
      staging: rtl8712: Fix IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK

Srinivas Kandagatla (1):
      nvmem: qfprom: remove incorrect write support

Stefano Garzarella (1):
      vsock: fix timeout in vsock_accept()

Tony W Wang-oc (1):
      x86/speculation/spectre_v2: Exclude Zhaoxin CPUs from SPECTRE_V2

Willem de Bruijn (1):
      net: check untrusted gso_size at kernel entry

Yang Yingliang (1):
      devinet: fix memleak in inetdev_init()

