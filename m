Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349A66247EF
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 18:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiKJRJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 12:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiKJRJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 12:09:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF13E1EEF9;
        Thu, 10 Nov 2022 09:09:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87845B8224A;
        Thu, 10 Nov 2022 17:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D71C433D6;
        Thu, 10 Nov 2022 17:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668100158;
        bh=33yaFqQhuafSh8dR4w2vgyRTKih5rrgpP3mCcvLamnQ=;
        h=From:To:Cc:Subject:Date:From;
        b=uU4ZJUgPo80YijpbfTzfyoK6lBcdG+WZuoyaG2AbBhalFHy0dRlYWfPUn8AYMXDH9
         9zAvBk4llZ7oshDHDr2TTpWGNNR6JoRgmOn6OLM8VgZGvX4DxpeIKa35nsfgxWX2a9
         kEaCZ4/L2xeb+q/hrR+LMoW5t23CNkM11bjCn9Ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.333
Date:   Thu, 10 Nov 2022 18:09:14 +0100
Message-Id: <1668100154253222@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.333 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/x86/kvm/cpuid.c                                    |    1 
 arch/x86/kvm/emulate.c                                  |  102 +++++++++++-----
 drivers/ata/pata_legacy.c                               |    5 
 drivers/i2c/busses/i2c-xiic.c                           |    1 
 drivers/isdn/hardware/mISDN/netjet.c                    |    2 
 drivers/isdn/mISDN/core.c                               |    5 
 drivers/media/dvb-frontends/drxk_hard.c                 |    2 
 drivers/net/ethernet/freescale/fec_main.c               |    4 
 drivers/net/phy/mdio_bus.c                              |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c |    4 
 drivers/nfc/nfcmrvl/i2c.c                               |    7 -
 drivers/nfc/s3fwrn5/core.c                              |    8 -
 drivers/parisc/iosapic.c                                |    1 
 drivers/staging/media/s5p-cec/s5p_cec.c                 |    2 
 drivers/tty/serial/8250/Kconfig                         |    2 
 fs/btrfs/export.c                                       |    2 
 fs/btrfs/export.h                                       |    2 
 fs/btrfs/tests/qgroup-tests.c                           |   20 ++-
 fs/ext4/migrate.c                                       |    3 
 fs/nfs/nfs4client.c                                     |    1 
 fs/nfs/nfs4state.c                                      |    2 
 net/bluetooth/l2cap_core.c                              |   52 ++++++--
 net/netfilter/ipvs/ip_vs_conn.c                         |    4 
 net/rose/rose_link.c                                    |    3 
 net/sched/sch_red.c                                     |    4 
 sound/usb/quirks-table.h                                |   58 +++++++++
 sound/usb/quirks.c                                      |    1 
 28 files changed, 240 insertions(+), 62 deletions(-)

Dan Carpenter (1):
      net: sched: Fix use after free in red_enqueue()

David Sterba (1):
      btrfs: fix type of parameter generation in btrfs_get_dentry

Dokyung Song (1):
      wifi: brcmfmac: Fix potential buffer overflow in brcmf_fweh_event_worker()

Filipe Manana (1):
      btrfs: fix ulist leaks in error paths of qgroup self tests

Gaosheng Cui (1):
      net: mdio: fix undefined behavior in bit shift for __mdiobus_register

Greg Kroah-Hartman (1):
      Linux 4.9.333

Hans Verkuil (2):
      media: s5p_cec: limit msg.len to CEC_MAX_MSG_SIZE
      media: dvb-frontends/drxk: initialize err to 0

Helge Deller (2):
      parisc: Make 8250_gsc driver dependend on CONFIG_PARISC
      parisc: Export iosapic_serial_irq() symbol for serial port driver

Jason A. Donenfeld (1):
      ipvs: use explicitly signed chars

Jim Mattson (1):
      KVM: x86: Mask off reserved bits in CPUID.80000008H

John Veness (1):
      ALSA: usb-audio: Add quirks for MacroSilicon MS2100/MS2106 devices

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix attempting to access uninitialized memory

Martin Tůma (1):
      i2c: xiic: Add platform module alias

Maxim Levitsky (3):
      KVM: x86: emulator: em_sysexit should update ctxt->mode
      KVM: x86: emulator: introduce emulator_recalc_and_set_mode
      KVM: x86: emulator: update the emulation mode after CR0 write

Maxim Mikityanskiy (1):
      Bluetooth: L2CAP: Fix use-after-free caused by l2cap_reassemble_sdu

Sergey Shtylyov (1):
      ata: pata_legacy: fix pdc20230_set_piomode()

Shang XiaoJing (2):
      nfc: s3fwrn5: Fix potential memory leak in s3fwrn5_nci_send()
      nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()

Trond Myklebust (2):
      NFSv4.1: Handle RECLAIM_COMPLETE trunking errors
      NFSv4.1: We must always send RECLAIM_COMPLETE after a reboot

Yang Yingliang (2):
      mISDN: fix possible memory leak in mISDN_register_device()
      isdn: mISDN: netjet: fix wrong check of device registration

Ye Bin (1):
      ext4: fix warning in 'ext4_da_release_space'

Zhang Changzhong (1):
      net: fec: fix improper use of NETDEV_TX_BUSY

Zhang Qilong (1):
      rose: Fix NULL pointer dereference in rose_send_frame()

Zhang Xiaoxu (1):
      nfs4: Fix kmemleak when allocate slot failed

Zhengchao Shao (1):
      Bluetooth: L2CAP: fix use-after-free in l2cap_conn_del()

