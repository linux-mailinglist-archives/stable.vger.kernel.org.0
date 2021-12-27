Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA0D47FEDD
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbhL0PdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:33:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34156 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237817AbhL0PdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:33:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39439610AA;
        Mon, 27 Dec 2021 15:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B9BC36AE7;
        Mon, 27 Dec 2021 15:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619184;
        bh=IsE24FpmPUazOHG27INMdUQZzGEJwPyOubWRJisB4PY=;
        h=From:To:Cc:Subject:Date:From;
        b=DGVpoJv3dt3P2hmRZ0//tzTDfP9W4Cd6rvt8toLn0FlrlRUyy5l9iZwcMh/Knb0mx
         ony6JhzuoghfF7zpkBJhWc+jDlhsNsljJjvMQI7n9JQ1el5CgAMkDdfr2KfQYiOgzN
         ItLKwhx0/fL9hZmWAtSdT0hSxSqgkfkvM+rdLb3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/38] 4.19.223-rc1 review
Date:   Mon, 27 Dec 2021 16:30:37 +0100
Message-Id: <20211227151319.379265346@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.223-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.223-rc1
X-KernelTest-Deadline: 2021-12-29T15:13+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.223 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.223-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.223-rc1

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

John David Anglin <dave.anglin@bell.net>
    parisc: Correct completer in lws start

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    ipmi: fix initialization when workqueue allocation fails

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    ipmi: bail out if init_srcu_struct fails

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

Wu Bo <wubo40@huawei.com>
    ipmi: Fix UAF when uninstall ipmi_si and ipmi_msghandler module

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

Robert Marko <robert.marko@sartura.hr>
    arm64: dts: allwinner: orangepi-zero-plus: fix PHY mode

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: holtek: fix mouse probing

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: fix use after free in bfq_bfqq_expire

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: fix queue removal from weights tree

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: fix decrement of num_active_groups

Federico Motta <federico@willer.it>
    block, bfq: fix asymmetric scenarios detection

Federico Motta <federico@willer.it>
    block, bfq: improve asymmetric scenarios detection

Greg Jesionowski <jesionowskigreg@gmail.com>
    net: usb: lan78xx: add Allied Telesis AT29M2-AF


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   8 +-
 Documentation/networking/bonding.txt               |  11 +-
 Makefile                                           |   4 +-
 arch/arm/kernel/entry-armv.S                       |   8 +-
 .../dts/allwinner/sun50i-h5-orangepi-zero-plus.dts |   2 +-
 arch/parisc/kernel/syscall.S                       |   2 +-
 arch/x86/include/asm/pgtable.h                     |   4 +-
 block/bfq-iosched.c                                | 287 +++++++++++++--------
 block/bfq-iosched.h                                |  76 ++++--
 block/bfq-wf2q.c                                   |  56 ++--
 drivers/char/ipmi/ipmi_msghandler.c                |  21 +-
 drivers/hid/hid-holtek-mouse.c                     |  15 ++
 drivers/hwmon/lm90.c                               |   8 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c          |   2 +-
 drivers/input/serio/i8042-x86ia64io.h              |   7 +
 drivers/input/touchscreen/atmel_mxt_ts.c           |   2 +-
 drivers/net/bonding/bond_options.c                 |   2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h  |   2 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |  12 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c   |   4 +-
 drivers/net/ethernet/sfc/falcon/rx.c               |   5 +-
 drivers/net/ethernet/smsc/smc911x.c                |   5 +
 drivers/net/fjes/fjes_main.c                       |   5 +
 drivers/net/hamradio/mkiss.c                       |   5 +-
 drivers/net/usb/lan78xx.c                          |   6 +
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   8 +-
 drivers/spi/spi-armada-3700.c                      |   2 +-
 drivers/usb/gadget/function/u_ether.c              |  15 +-
 fs/f2fs/xattr.c                                    |   9 +-
 include/linux/virtio_net.h                         |  25 +-
 net/ax25/af_ax25.c                                 |   4 +-
 net/netfilter/nfnetlink_log.c                      |   3 +-
 net/netfilter/nfnetlink_queue.c                    |   3 +-
 net/phonet/pep.c                                   |   2 +
 sound/core/jack.c                                  |   4 +
 sound/drivers/opl3/opl3_midi.c                     |   2 +-
 36 files changed, 424 insertions(+), 212 deletions(-)


