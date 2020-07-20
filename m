Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41BF226378
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgGTPhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728816AbgGTPhb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:37:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3928122D07;
        Mon, 20 Jul 2020 15:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259450;
        bh=qYrmhFTOiEp5cJSK3mWIfUp7ld+eLOS9ED4iaBd++0c=;
        h=From:To:Cc:Subject:Date:From;
        b=TfR7X4PCkpQvDcOGLF+XAiKuOairK7C12fQFkAfi/Evo9QcY9RI79ylGLeTxxGlQe
         6I4fVlMla7Z2oQYdh/kDWErrRU3alf4mF2/DO32QAmuYlNyTqpAxoY7UIe6ALKQVxr
         90DUvvpeG9EuniuyAQg06IIrzhYeGI7oFdEK54xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/58] 4.4.231-rc1 review
Date:   Mon, 20 Jul 2020 17:36:16 +0200
Message-Id: <20200720152747.127988571@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.231-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.231-rc1
X-KernelTest-Deadline: 2020-07-22T15:27+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.231 release.
There are 58 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.231-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.231-rc1

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: handle case of task_h_load() returning 0

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    misc: atmel-ssc: lock with mutex instead of spinlock

Krzysztof Kozlowski <krzk@kernel.org>
    dmaengine: fsl-edma: Fix NULL pointer exception in fsl_edma_tx_handler

Vishwas M <vishwas.reddy.vr@gmail.com>
    hwmon: (emc2103) fix unable to change fan pwm1_enable attribute

Huacai Chen <chenhc@lemote.com>
    MIPS: Fix build for LTS kernel caused by backporting lpj adjustment

Esben Haabendal <esben@geanix.com>
    uio_pdrv_genirq: fix use without device tree and no interrupt

David Pedersen <limero1337@gmail.com>
    Input: i8042 - add Lenovo XiaoXin Air 12 to i8042 nomux list

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: bus: don't clean driver pointer

Chirantan Ekbote <chirantan@chromium.org>
    fuse: Fix parameter for FS_IOC_{GET,SET}FLAGS

Alexander Lobakin <alobakin@pm.me>
    virtio: virtio_console: add missing MODULE_DEVICE_TABLE() for rproc serial

AceLan Kao <acelan.kao@canonical.com>
    USB: serial: option: add Quectel EG95 LTE modem

Jörgen Storvist <jorgen.storvist@gmail.com>
    USB: serial: option: add GosunCn GM500 series

Igor Moura <imphilippini@gmail.com>
    USB: serial: ch341: add new Product ID for CH340

James Hilliard <james.hilliard1@gmail.com>
    USB: serial: cypress_m8: enable Simply Automated UPB PIM

Johan Hovold <johan@kernel.org>
    USB: serial: iuu_phoenix: fix memory corruption

Zhang Qiang <qiang.zhang@windriver.com>
    usb: gadget: function: fix missing spinlock in f_uac1_legacy

Peter Chen <peter.chen@nxp.com>
    usb: chipidea: core: add wakeup support for extcon

Tom Rix <trix@redhat.com>
    USB: c67x00: fix use after free in c67x00_giveback_urb

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix race against the error recovery URB submission

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Perform sanity check for each URB creation

Takashi Iwai <tiwai@suse.de>
    usb: core: Add a helper function to check the validity of EP type in URB

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: magicmouse: do not set up autorepeat

Álvaro Fernández Rojas <noltari@gmail.com>
    mtd: rawnand: brcmnand: fix CS0 layout

Jin Yao <yao.jin@linux.intel.com>
    perf stat: Zero all the 'ena' and 'run' array slot stats for interval mode

Dan Carpenter <dan.carpenter@oracle.com>
    staging: comedi: verify array index is correct before using it

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    usb: gadget: udc: atmel: fix uninitialized read in debug printk

Sasha Levin <sashal@kernel.org>
    Revert "usb/ohci-platform: Fix a warning when hibernating"

Sasha Levin <sashal@kernel.org>
    Revert "usb/xhci-plat: Set PM runtime as active on resume"

Sasha Levin <sashal@kernel.org>
    Revert "usb/ehci-platform: Set PM runtime as active on resume"

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i2c: eg20t: Load module automatically if ID matches

Eric Dumazet <edumazet@google.com>
    tcp: md5: allow changing MD5 keys in all socket states

Eric Dumazet <edumazet@google.com>
    tcp: md5: refine tcp_md5_do_add()/tcp_md5_hash_key() barriers

Eric Dumazet <edumazet@google.com>
    tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()

Christoph Paasch <cpaasch@apple.com>
    tcp: make sure listeners don't initialize congestion-control state

Sean Tranchetti <stranche@codeaurora.org>
    genetlink: remove genl_bind

Martin Varghese <martin.varghese@nokia.com>
    net: Added pointer check for dst->ops->neigh_lookup in dst_neigh_lookup_skb

Eric Dumazet <edumazet@google.com>
    llc: make sure applications use ARPHRD_ETHER

Xin Long <lucien.xin@gmail.com>
    l2tp: remove skb_dst_set() from l2tp_xmit_skb()

Sabrina Dubroca <sd@queasysnail.net>
    ipv4: fill fl4_icmp_{type,code} in ping_v4_sendmsg

Davide Caratti <dcaratti@redhat.com>
    bnxt_en: fix NULL dereference in case SR-IOV configuration fails

Vineet Gupta <vgupta@synopsys.com>
    ARC: elf: use right ELF_ARCH

Vineet Gupta <vgupta@synopsys.com>
    ARC: entry: fix potential EFA clobber when TIF_SYSCALL_TRACE

Tom Rix <trix@redhat.com>
    drm/radeon: fix double free

Boris Burkov <boris@bur.io>
    btrfs: fix fatal extent_buffer readahead vs releasepage race

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb"

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: bit 8 of non-leaf PDPEs is not reserved

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: add quirk for MacroSilicon MS2109

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - let hs_mic be picked ahead of hp_mic

xidongwang <wangxidong_97@163.com>
    ALSA: opl3: fix infoleak in opl3

Wei Li <liwei391@huawei.com>
    arm64: kgdb: Fix single-step exception handling oops

Vinod Koul <vkoul@kernel.org>
    ALSA: compress: fix partial_drain completion state

Andre Edich <andre.edich@microchip.com>
    smsc95xx: avoid memory leak in smsc95xx_bind

Andre Edich <andre.edich@microchip.com>
    smsc95xx: check return value of smsc95xx_reset

Li Heng <liheng40@huawei.com>
    net: cxgb4: fix return error value in t4_prep_fw

Tomas Henzl <thenzl@redhat.com>
    scsi: mptscsih: Fix read sense data size

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    spi: spidev: fix a potential use-after-free in spidev_release()

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    spi: spidev: fix a race between spidev_release and spidev_remove

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: reduce number of IO pins to 1


-------------

Diffstat:

 Makefile                                        |  4 +-
 arch/arc/include/asm/elf.h                      |  2 +-
 arch/arc/kernel/entry.S                         | 16 +++-----
 arch/arm64/kernel/kgdb.c                        |  2 +-
 arch/mips/kernel/time.c                         | 13 ++-----
 arch/s390/include/asm/kvm_host.h                |  8 ++--
 arch/x86/kvm/mmu.c                              |  2 +-
 drivers/char/virtio_console.c                   |  3 +-
 drivers/dma/fsl-edma.c                          |  7 ++++
 drivers/gpu/drm/radeon/ci_dpm.c                 |  7 ++--
 drivers/hid/hid-magicmouse.c                    |  6 +++
 drivers/hwmon/emc2103.c                         |  2 +-
 drivers/i2c/busses/i2c-eg20t.c                  |  1 +
 drivers/input/serio/i8042-x86ia64io.h           |  7 ++++
 drivers/message/fusion/mptscsih.c               |  4 +-
 drivers/misc/atmel-ssc.c                        | 24 ++++++------
 drivers/misc/mei/bus.c                          |  3 +-
 drivers/mtd/nand/brcmnand/brcmnand.c            |  5 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c      |  8 ++--
 drivers/net/usb/smsc95xx.c                      |  9 ++++-
 drivers/net/wireless/ath/ath9k/hif_usb.c        | 48 ++++++-----------------
 drivers/net/wireless/ath/ath9k/hif_usb.h        |  5 ---
 drivers/spi/spidev.c                            | 24 ++++++------
 drivers/staging/comedi/drivers/addi_apci_1500.c | 10 +++--
 drivers/uio/uio_pdrv_genirq.c                   |  2 +-
 drivers/usb/c67x00/c67x00-sched.c               |  2 +-
 drivers/usb/chipidea/core.c                     | 24 ++++++++++++
 drivers/usb/core/urb.c                          | 30 ++++++++++++--
 drivers/usb/gadget/function/f_uac1.c            |  2 +
 drivers/usb/gadget/udc/atmel_usba_udc.c         |  2 +-
 drivers/usb/host/ehci-platform.c                |  5 ---
 drivers/usb/host/ohci-platform.c                |  5 ---
 drivers/usb/host/xhci-plat.c                    | 11 +-----
 drivers/usb/serial/ch341.c                      |  1 +
 drivers/usb/serial/cypress_m8.c                 |  2 +
 drivers/usb/serial/cypress_m8.h                 |  3 ++
 drivers/usb/serial/iuu_phoenix.c                |  8 ++--
 drivers/usb/serial/option.c                     |  6 +++
 fs/btrfs/extent_io.c                            | 40 +++++++++++--------
 fs/fuse/file.c                                  | 12 +++++-
 include/linux/usb.h                             |  2 +
 include/net/dst.h                               | 10 ++++-
 include/net/genetlink.h                         |  8 ----
 include/sound/compress_driver.h                 | 10 ++++-
 kernel/sched/fair.c                             | 10 ++++-
 net/ipv4/ping.c                                 |  3 ++
 net/ipv4/tcp.c                                  | 13 ++++---
 net/ipv4/tcp_cong.c                             |  2 +-
 net/ipv4/tcp_ipv4.c                             | 15 +++++--
 net/l2tp/l2tp_core.c                            |  5 +--
 net/llc/af_llc.c                                | 10 +++--
 net/netlink/genetlink.c                         | 52 -------------------------
 sound/core/compress_offload.c                   |  4 ++
 sound/drivers/opl3/opl3_synth.c                 |  2 +
 sound/pci/hda/hda_auto_parser.c                 |  6 +++
 sound/usb/line6/capture.c                       |  2 +
 sound/usb/line6/playback.c                      |  2 +
 sound/usb/midi.c                                | 17 +++++---
 sound/usb/quirks-table.h                        | 52 +++++++++++++++++++++++++
 tools/perf/util/stat.c                          |  6 ++-
 61 files changed, 358 insertions(+), 250 deletions(-)


