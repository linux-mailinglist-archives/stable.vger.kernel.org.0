Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353E73088D2
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 13:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhA2ME5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 07:04:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232544AbhA2MCL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Jan 2021 07:02:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E976D64F50;
        Fri, 29 Jan 2021 11:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611918734;
        bh=MVW6R+rETXbR+XXYw48sJy9crjkdaF/bIztnEvIrKZ4=;
        h=From:To:Cc:Subject:Date:From;
        b=Be2j1OHH2XfCrC5Qlu6vMG9bCVzPC0yAJs7IwBXooMM0hmCDMjLdxhDxRU8aejelG
         kQnGTPLMR+s+xajU5h+b+65NTRVdK4eZGtTcaUmWZNdMHnMaaQfwZNH2noJ/WC0Pt9
         7Hft5Ip9d6MO1IcH8eFmDIByMJJ0HDZSk8Rmk8IU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.9 00/30] 4.9.254-rc1 review
Date:   Fri, 29 Jan 2021 12:06:36 +0100
Message-Id: <20210129105910.583037839@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.254-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.254-rc1
X-KernelTest-Deadline: 2021-01-31T10:59+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.254 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.254-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.254-rc1

Arvind Sankar <nivedita@alum.mit.edu>
    x86/boot/compressed: Disable relocation relaxation

Gaurav Kohli <gkohli@codeaurora.org>
    tracing: Fix race in trace_open and buffer resize call

Wang Hai <wanghai38@huawei.com>
    Revert "mm/slub: fix a memory leak in sysfs_slab_add()"

Dan Carpenter <dan.carpenter@oracle.com>
    net: dsa: b53: fix an off by one in checking "vlan->vid"

Eric Dumazet <edumazet@google.com>
    net_sched: avoid shift-out-of-bounds in tcindex_set_parms()

Matteo Croce <mcroce@microsoft.com>
    ipv6: create multicast route with RTPROT_KERNEL

Alexander Lobakin <alobakin@pm.me>
    skbuff: back tiny skbs with kmalloc() in __netdev_alloc_skb() too

Geert Uytterhoeven <geert+renesas@glider.be>
    sh_eth: Fix power down vs. is_opened flag ordering

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    sh: dma: fix kconfig dependency for G2_DMA

Guillaume Nault <gnault@redhat.com>
    netfilter: rpfilter: mask ecn bits before fib lookup

Will Deacon <will@kernel.org>
    compiler.h: Raise minimum version of GCC to 5.1 for arm64

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix buggy rsh min/max bounds tracking

JC Kuo <jckuo@nvidia.com>
    xhci: tegra: Delay for disabling LFPS detector

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: make sure TRB is fully written before giving it to the controller

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    usb: bdc: Make bdc pci driver depend on BROKEN

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: udc: core: Use lock when write to soft_connect

Longfang Liu <liulongfang@huawei.com>
    USB: ehci: fix an interrupt calltrace error

Eugene Korenevsky <ekorenevsky@astralinux.ru>
    ehci: fix EHCI host controller initialization sequence

Wang Hui <john.wanghui@huawei.com>
    stm class: Fix module init return on allocation failure

Lars-Peter Clausen <lars@metafoo.de>
    iio: ad5504: Fix setting power-down state

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: dev: can_restart: fix use after free bug

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: octeon: check correct size of maximum RECV_LEN packet

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/i2c/gm200: increase width of aux semaphore owner fields

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/bios: fix issue shadowing expansion ROMs

Can Guo <cang@codeaurora.org>
    scsi: ufs: Correct the LUN used in eh_device_reset_handler() callback

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: haswell: Add missing pm_ops

Hannes Reinecke <hare@suse.de>
    dm: avoid filesystem lookup in dm_get_dev_t()

Hans de Goede <hdegoede@redhat.com>
    ACPI: scan: Make acpi_bus_get_device() clear return pointer on error

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/via: Add minimum mute flag

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Fix missing error check in snd_seq_oss_synth_make_info()


-------------

Diffstat:

 Makefile                                           |  4 ++--
 arch/sh/drivers/dma/Kconfig                        |  3 +--
 arch/x86/boot/compressed/Makefile                  |  2 ++
 drivers/acpi/scan.c                                |  2 ++
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c  |  2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c |  8 ++++----
 drivers/hwtracing/stm/heartbeat.c                  |  6 ++++--
 drivers/i2c/busses/i2c-octeon-core.c               |  2 +-
 drivers/iio/dac/ad5504.c                           |  4 ++--
 drivers/md/dm-table.c                              | 15 ++++++++++++---
 drivers/net/can/dev.c                              |  4 ++--
 drivers/net/dsa/b53/b53_common.c                   |  2 +-
 drivers/net/ethernet/renesas/sh_eth.c              |  4 ++--
 drivers/scsi/ufs/ufshcd.c                          | 11 ++++-------
 drivers/usb/gadget/udc/bdc/Kconfig                 |  2 +-
 drivers/usb/gadget/udc/core.c                      | 13 ++++++++++---
 drivers/usb/host/ehci-hcd.c                        | 12 ++++++++++++
 drivers/usb/host/ehci-hub.c                        |  3 +++
 drivers/usb/host/xhci-ring.c                       |  2 ++
 drivers/usb/host/xhci-tegra.c                      |  7 +++++++
 include/linux/compiler-gcc.h                       |  6 ++++++
 kernel/bpf/verifier.c                              |  7 +++----
 kernel/trace/ring_buffer.c                         |  4 ++++
 mm/slub.c                                          |  4 +---
 net/core/skbuff.c                                  |  6 +++++-
 net/ipv4/netfilter/ipt_rpfilter.c                  |  2 +-
 net/ipv6/addrconf.c                                |  1 +
 net/sched/cls_tcindex.c                            |  8 ++++++--
 sound/core/seq/oss/seq_oss_synth.c                 |  3 ++-
 sound/pci/hda/patch_via.c                          |  1 +
 sound/soc/intel/boards/haswell.c                   |  1 +
 31 files changed, 106 insertions(+), 45 deletions(-)


