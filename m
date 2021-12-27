Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E48F47FE89
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhL0P37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:29:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34694 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237707AbhL0P3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:29:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46309B80E51;
        Mon, 27 Dec 2021 15:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BEBC36AED;
        Mon, 27 Dec 2021 15:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618974;
        bh=Lyf8X2IxvNWDjFpoQB3PCUmBIr+3/J+51kJ6CPUE5Hs=;
        h=From:To:Cc:Subject:Date:From;
        b=dtu6Nji/gxcFeexLWikJGIGSv9NOMkOBdri7/bZXGxhnfwzIFtrV7M7reSI3cD7NJ
         bYAxqImiYnrWGeENvAzQhFOzjFvhOVZ0OdT7d8Plj/sMEUavIDdnk8ixgV02FqIlRH
         J9sVkoCuMDc3JB3iXwUduWckuXMfoicvfd8WtEBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.14 00/29] 4.14.260-rc1 review
Date:   Mon, 27 Dec 2021 16:27:10 +0100
Message-Id: <20211227151318.475251079@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.260-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.260-rc1
X-KernelTest-Deadline: 2021-12-29T15:13+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.260 release.
There are 29 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.260-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.260-rc1

Rémi Denis-Courmont <remi@remlab.net>
    phonet/pep: refuse to enable an unbound pipe

Lin Ma <linma@zju.edu.cn>
    hamradio: improve the incomplete fix to avoid NPD

Lin Ma <linma@zju.edu.cn>
    hamradio: defer ax25 kfree after unregister_netdev

Lin Ma <linma@zju.edu.cn>
    ax25: NPD bug when detaching AX25 device

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Do not report 'busy' status bit as alarm

Samuel Čavoj <samuel@cavoj.net>
    Input: i8042 - enable deferred probe quirk for ASUS UM325UA

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Fix stale docs for kvm-intel.emulate_invalid_guest_state

Marian Postevca <posteuca@mutex.one>
    usb: gadget: u_ether: fix race in setting MAC address in setup phase

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on last xattr entry in __f2fs_setxattr()

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9169/1: entry: fix Thumb2 bug in iWMMXt exception handling

Fabien Dessenne <fabien.dessenne@foss.st.com>
    pinctrl: stm32: consider the GPIO offset to expose all the GPIO lines

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/pkey: Fix undefined behaviour with PKRU_WD_BIT

José Expósito <jose.exposito89@gmail.com>
    Input: atmel_mxt_ts - fix double free in mxt_read_info_block

Colin Ian King <colin.i.king@gmail.com>
    ALSA: drivers: opl3: Fix incorrect use of vp->state

Xiaoke Wang <xkernel.wang@foxmail.com>
    ALSA: jack: Check the return value of kstrdup()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Fix usage of CONFIG2 register in detect function

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    sfc: falcon: Check null pointer of rx_queue->page_ring

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drivers: net: smc911x: Check for error irq

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    fjes: Check for error irq

Fernando Fernandez Mancera <ffmancera@riseup.net>
    bonding: fix ad_actor_system option setting to default

Willem de Bruijn <willemb@google.com>
    net: skip virtio_net_hdr_set_proto if protocol already set

Willem de Bruijn <willemb@google.com>
    net: accept UFOv6 packages in virtio_net_hdr_to_skb

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    qlcnic: potential dereference null pointer of rx_queue->page_ring

Ignacy Gawędzki <ignacy.gawedzki@green-communications.fr>
    netfilter: fix regression in looped (broad|multi)cast's MAC handling

José Expósito <jose.exposito89@gmail.com>
    IB/qib: Fix memory leak in qib_user_sdma_queue_pkts()

Dongliang Mu <mudongliangabcd@gmail.com>
    spi: change clk_disable_unprepare to clk_unprepare

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: holtek: fix mouse probing

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: get CAN clock frequency from device

Greg Jesionowski <jesionowskigreg@gmail.com>
    net: usb: lan78xx: add Allied Telesis AT29M2-AF


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |  8 +++--
 Documentation/networking/bonding.txt               | 11 +++---
 Makefile                                           |  4 +--
 arch/arm/kernel/entry-armv.S                       |  8 ++---
 arch/x86/include/asm/pgtable.h                     |  4 +--
 drivers/hid/hid-holtek-mouse.c                     | 15 ++++++++
 drivers/hwmon/lm90.c                               |  8 ++---
 drivers/infiniband/hw/qib/qib_user_sdma.c          |  2 +-
 drivers/input/serio/i8042-x86ia64io.h              |  7 ++++
 drivers/input/touchscreen/atmel_mxt_ts.c           |  2 +-
 drivers/net/bonding/bond_options.c                 |  2 +-
 drivers/net/can/usb/kvaser_usb.c                   | 41 +++++++++++++++++++---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h  |  2 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   | 12 +++++--
 .../net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c   |  4 ++-
 drivers/net/ethernet/sfc/falcon/rx.c               |  5 ++-
 drivers/net/ethernet/smsc/smc911x.c                |  5 +++
 drivers/net/fjes/fjes_main.c                       |  5 +++
 drivers/net/hamradio/mkiss.c                       |  5 +--
 drivers/net/usb/lan78xx.c                          |  6 ++++
 drivers/pinctrl/stm32/pinctrl-stm32.c              |  8 ++---
 drivers/spi/spi-armada-3700.c                      |  2 +-
 drivers/usb/gadget/function/u_ether.c              | 15 +++-----
 fs/f2fs/xattr.c                                    |  9 ++++-
 include/linux/virtio_net.h                         | 25 +++++++++++--
 net/ax25/af_ax25.c                                 |  4 ++-
 net/netfilter/nfnetlink_log.c                      |  3 +-
 net/netfilter/nfnetlink_queue.c                    |  3 +-
 net/phonet/pep.c                                   |  2 ++
 sound/core/jack.c                                  |  4 +++
 sound/drivers/opl3/opl3_midi.c                     |  2 +-
 31 files changed, 175 insertions(+), 58 deletions(-)


