Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8870448124A
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 12:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240062AbhL2Ltf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 06:49:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44020 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236495AbhL2Ltc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 06:49:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DB2F6147D;
        Wed, 29 Dec 2021 11:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D0DC36AE9;
        Wed, 29 Dec 2021 11:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640778571;
        bh=b32nEQdduPRlw/2R0sNHW6OgukBqMe43ZpZ8Ptn0ZKI=;
        h=From:To:Cc:Subject:Date:From;
        b=MrkU1KServT4b93O/RiTprwXI8FgjsLHE2tqjKEIwkOURA/cf8EWXyz7dzqe8yZho
         tJ8ljaC5YgZ1rJ3bE50N307HPTtwAvCay0Po6iP0W+2lNh32vuUd3L4mqvbF9UV7n/
         SWe3svu5GGtlTe67Bpd1exMmSzbPCwjm6pPQ9JdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.223
Date:   Wed, 29 Dec 2021 12:49:28 +0100
Message-Id: <164077856821921@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.223 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt                |    8 
 Documentation/networking/bonding.txt                           |   11 
 Makefile                                                       |    2 
 arch/arm/kernel/entry-armv.S                                   |    8 
 arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-zero-plus.dts |    2 
 arch/parisc/kernel/syscall.S                                   |    2 
 arch/x86/include/asm/pgtable.h                                 |    4 
 block/bfq-iosched.c                                            |  287 ++++++----
 block/bfq-iosched.h                                            |   76 ++
 block/bfq-wf2q.c                                               |   56 +
 drivers/char/ipmi/ipmi_msghandler.c                            |   21 
 drivers/hid/hid-holtek-mouse.c                                 |   15 
 drivers/hwmon/lm90.c                                           |    8 
 drivers/infiniband/hw/qib/qib_user_sdma.c                      |    2 
 drivers/input/touchscreen/atmel_mxt_ts.c                       |    2 
 drivers/net/bonding/bond_options.c                             |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h              |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c       |   12 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c           |    4 
 drivers/net/ethernet/sfc/falcon/rx.c                           |    5 
 drivers/net/ethernet/smsc/smc911x.c                            |    5 
 drivers/net/fjes/fjes_main.c                                   |    5 
 drivers/net/hamradio/mkiss.c                                   |    5 
 drivers/net/usb/lan78xx.c                                      |    6 
 drivers/pinctrl/stm32/pinctrl-stm32.c                          |    8 
 drivers/spi/spi-armada-3700.c                                  |    2 
 drivers/usb/gadget/function/u_ether.c                          |   15 
 fs/f2fs/xattr.c                                                |    9 
 include/linux/virtio_net.h                                     |   25 
 net/ax25/af_ax25.c                                             |    4 
 net/netfilter/nfnetlink_log.c                                  |    3 
 net/netfilter/nfnetlink_queue.c                                |    3 
 net/phonet/pep.c                                               |    2 
 sound/core/jack.c                                              |    4 
 sound/drivers/opl3/opl3_midi.c                                 |    2 
 35 files changed, 416 insertions(+), 211 deletions(-)

Andrew Cooper (1):
      x86/pkey: Fix undefined behaviour with PKRU_WD_BIT

Ard Biesheuvel (1):
      ARM: 9169/1: entry: fix Thumb2 bug in iWMMXt exception handling

Benjamin Tissoires (1):
      HID: holtek: fix mouse probing

Chao Yu (1):
      f2fs: fix to do sanity check on last xattr entry in __f2fs_setxattr()

Colin Ian King (1):
      ALSA: drivers: opl3: Fix incorrect use of vp->state

Dongliang Mu (1):
      spi: change clk_disable_unprepare to clk_unprepare

Fabien Dessenne (1):
      pinctrl: stm32: consider the GPIO offset to expose all the GPIO lines

Federico Motta (2):
      block, bfq: improve asymmetric scenarios detection
      block, bfq: fix asymmetric scenarios detection

Fernando Fernandez Mancera (1):
      bonding: fix ad_actor_system option setting to default

Greg Jesionowski (1):
      net: usb: lan78xx: add Allied Telesis AT29M2-AF

Greg Kroah-Hartman (1):
      Linux 4.19.223

Guenter Roeck (2):
      hwmon: (lm90) Fix usage of CONFIG2 register in detect function
      hwmon: (lm90) Do not report 'busy' status bit as alarm

Ignacy Gawędzki (1):
      netfilter: fix regression in looped (broad|multi)cast's MAC handling

Jiasheng Jiang (4):
      qlcnic: potential dereference null pointer of rx_queue->page_ring
      fjes: Check for error irq
      drivers: net: smc911x: Check for error irq
      sfc: falcon: Check null pointer of rx_queue->page_ring

John David Anglin (1):
      parisc: Correct completer in lws start

José Expósito (2):
      IB/qib: Fix memory leak in qib_user_sdma_queue_pkts()
      Input: atmel_mxt_ts - fix double free in mxt_read_info_block

Lin Ma (3):
      ax25: NPD bug when detaching AX25 device
      hamradio: defer ax25 kfree after unregister_netdev
      hamradio: improve the incomplete fix to avoid NPD

Marian Postevca (1):
      usb: gadget: u_ether: fix race in setting MAC address in setup phase

Paolo Valente (3):
      block, bfq: fix decrement of num_active_groups
      block, bfq: fix queue removal from weights tree
      block, bfq: fix use after free in bfq_bfqq_expire

Robert Marko (1):
      arm64: dts: allwinner: orangepi-zero-plus: fix PHY mode

Rémi Denis-Courmont (1):
      phonet/pep: refuse to enable an unbound pipe

Sean Christopherson (1):
      KVM: VMX: Fix stale docs for kvm-intel.emulate_invalid_guest_state

Thadeu Lima de Souza Cascardo (2):
      ipmi: bail out if init_srcu_struct fails
      ipmi: fix initialization when workqueue allocation fails

Willem de Bruijn (2):
      net: accept UFOv6 packages in virtio_net_hdr_to_skb
      net: skip virtio_net_hdr_set_proto if protocol already set

Wu Bo (1):
      ipmi: Fix UAF when uninstall ipmi_si and ipmi_msghandler module

Xiaoke Wang (1):
      ALSA: jack: Check the return value of kstrdup()

