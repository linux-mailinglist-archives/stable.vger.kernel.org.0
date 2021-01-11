Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450B82F12C0
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbhAKNAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:00:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:48386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbhAKNAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:00:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7BD72250E;
        Mon, 11 Jan 2021 13:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370001;
        bh=zzJVh/yjAhPWRqX6iGIp6BeqtU3Ne3J2p8bIklDTxFY=;
        h=From:To:Cc:Subject:Date:From;
        b=txbKvCKpWx8ClFfV4O62hCTovDPwf3yFyQhnJurU7ZGhULftVFItOCk9R01pxKat5
         DKALtWvsyB0pg9dCqETLnfx1j/+cGqbl48als9ww0bDflZai76BGRPR987DI9f/q5D
         fzDQCEOT9vLPR7qdhBTNQfG8zP1+I9AonAtYye4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.4 00/38] 4.4.251-rc1 review
Date:   Mon, 11 Jan 2021 14:00:32 +0100
Message-Id: <20210111130032.469630231@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.251-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.251-rc1
X-KernelTest-Deadline: 2021-01-13T13:00+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.251 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.251-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.251-rc1

Ying-Tsun Huang <ying-tsun.huang@amd.com>
    x86/mtrr: Correct the range check before performing MTRR type lookups

Florian Westphal <fw@strlen.de>
    netfilter: xt_RATEEST: reject non-null terminated string from userspace

Vasily Averin <vvs@virtuozzo.com>
    netfilter: ipset: fix shift-out-of-bounds in htable_bits()

Bard Liao <yung-chuan.liao@linux.intel.com>
    Revert "device property: Keep secondary firmware node secondary by type"

bo liu <bo.liu@senarytech.com>
    ALSA: hda/conexant: add a new hda codec CX11970

Dan Williams <dan.j.williams@intel.com>
    x86/mm: Fix leak of pmd ptlock

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: remove unused variable

Chandana Kishori Chiluveru <cchiluve@codeaurora.org>
    usb: gadget: configfs: Preserve function ordering after bind failure

Sriharsha Allenki <sallenki@codeaurora.org>
    usb: gadget: Fix spinlock lockup on usb_function_deactivate

Yang Yingliang <yangyingliang@huawei.com>
    USB: gadget: legacy: fix return error code in acm_ms_bind()

Zqiang <qiang.zhang@windriver.com>
    usb: gadget: function: printer: Fix a memory leak for interface descriptor

Jerome Brunet <jbrunet@baylibre.com>
    usb: gadget: f_uac2: reset wMaxPacketSize

Arnd Bergmann <arnd@arndb.de>
    usb: gadget: select CONFIG_CRC32

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix UBSAN warnings for MIDI jacks

Johan Hovold <johan@kernel.org>
    USB: usblp: fix DMA to stack

Johan Hovold <johan@kernel.org>
    USB: yurex: fix control-URB timeout handling

Daniel Palmer <daniel@0x0f.com>
    USB: serial: option: add LongSung M5710 module support

Johan Hovold <johan@kernel.org>
    USB: serial: iuu_phoenix: fix DMA from stack

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: uas: Add PNY USB Portable SSD to unusual_uas

Michael Grzeschik <m.grzeschik@pengutronix.de>
    USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk set

Yu Kuai <yukuai3@huawei.com>
    usb: chipidea: ci_hdrc_imx: add missing put_device() call in usbmisc_get_init_data()

Sean Young <sean@mess.org>
    USB: cdc-acm: blacklist another IR Droid device

taehyun.cho <taehyun.cho@samsung.com>
    usb: gadget: enable super speed plus

Dexuan Cui <decui@microsoft.com>
    video: hyperv_fb: Fix the mmap() regression for v5.4.y and older

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    ethernet: ucc_geth: fix use-after-free in ucc_geth_remove()

Jeff Dike <jdike@akamai.com>
    virtio_net: Fix recursive call to cpus_read_lock()

Randy Dunlap <rdunlap@infradead.org>
    net: sched: prevent invalid Scell_log shift count

Yunjian Wang <wangyunjian@huawei.com>
    vhost_net: fix ubuf refcount incorrectly when sendmsg fails

Roland Dreier <roland@kernel.org>
    CDC-NCM: remove "connected" log message

Xie He <xie.he.0141@gmail.com>
    net: hdlc_ppp: Fix issues when mod_timer is called while timer is running

Yunjian Wang <wangyunjian@huawei.com>
    net: hns: fix return value check in __lb_other_process()

Guillaume Nault <gnault@redhat.com>
    ipv4: Ignore ECN bits for fib lookups in fib_compute_spec_dst()

Petr Machata <me@pmachata.org>
    net: dcb: Validate netlink message in DCB handler

Dan Carpenter <dan.carpenter@oracle.com>
    atm: idt77252: call pci_disable_device() on error path

Linus Torvalds <torvalds@linux-foundation.org>
    depmod: handle the case of /sbin/depmod without /sbin in PATH

Huang Shijie <sjhuang@iluvatar.ai>
    lib/genalloc: fix the overflow when size is too big

Yunfeng Ye <yeyunfeng@huawei.com>
    workqueue: Kick a worker based on the actual activation of delayed works

Dominique Martinet <asmadeus@codewreck.org>
    kbuild: don't hardcode depmod path


-------------

Diffstat:

 Makefile                                         |  6 +--
 arch/x86/kernel/cpu/mtrr/generic.c               |  6 +--
 arch/x86/mm/pgtable.c                            |  2 +
 drivers/atm/idt77252.c                           |  2 +-
 drivers/base/core.c                              |  2 +-
 drivers/net/ethernet/freescale/ucc_geth.c        |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c |  4 ++
 drivers/net/usb/cdc_ncm.c                        |  3 --
 drivers/net/virtio_net.c                         | 12 +++--
 drivers/net/wan/hdlc_ppp.c                       |  7 +++
 drivers/usb/chipidea/ci_hdrc_imx.c               |  6 ++-
 drivers/usb/class/cdc-acm.c                      |  4 ++
 drivers/usb/class/usblp.c                        | 21 +++++++-
 drivers/usb/gadget/Kconfig                       |  2 +
 drivers/usb/gadget/composite.c                   | 10 +++-
 drivers/usb/gadget/configfs.c                    |  8 +--
 drivers/usb/gadget/function/f_printer.c          |  1 +
 drivers/usb/gadget/function/f_uac2.c             | 69 +++++++++++++++++++-----
 drivers/usb/gadget/legacy/acm_ms.c               |  4 +-
 drivers/usb/host/xhci.c                          | 24 ++++-----
 drivers/usb/misc/yurex.c                         |  3 ++
 drivers/usb/serial/iuu_phoenix.c                 | 20 +++++--
 drivers/usb/serial/keyspan_pda.c                 |  2 -
 drivers/usb/serial/option.c                      |  1 +
 drivers/usb/storage/unusual_uas.h                |  7 +++
 drivers/vhost/net.c                              |  6 +--
 drivers/video/fbdev/hyperv_fb.c                  |  6 +--
 include/net/red.h                                |  4 +-
 kernel/workqueue.c                               | 13 +++--
 lib/genalloc.c                                   | 25 ++++-----
 net/dcb/dcbnl.c                                  |  2 +
 net/ipv4/fib_frontend.c                          |  2 +-
 net/netfilter/ipset/ip_set_hash_gen.h            | 20 ++-----
 net/netfilter/xt_RATEEST.c                       |  3 ++
 net/sched/sch_choke.c                            |  2 +-
 net/sched/sch_gred.c                             |  2 +-
 net/sched/sch_red.c                              |  2 +-
 net/sched/sch_sfq.c                              |  2 +-
 scripts/depmod.sh                                |  2 +
 sound/pci/hda/patch_conexant.c                   |  1 +
 sound/usb/midi.c                                 |  4 ++
 41 files changed, 221 insertions(+), 103 deletions(-)


