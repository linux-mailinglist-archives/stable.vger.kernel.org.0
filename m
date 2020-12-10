Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B897F2D65A2
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 19:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390517AbgLJSzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 13:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388938AbgLJObm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:31:42 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.14 00/31] 4.14.212-rc1 review
Date:   Thu, 10 Dec 2020 15:26:37 +0100
Message-Id: <20201210142602.099683598@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.212-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.212-rc1
X-KernelTest-Deadline: 2020-12-12T14:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.212 release.
There are 31 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.212-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.212-rc1

Masami Hiramatsu <mhiramat@kernel.org>
    x86/uprobes: Do not use prefixes.nbytes when looping over prefixes.bytes

Luo Meng <luomeng12@huawei.com>
    Input: i8042 - fix error return code in i8042_setup_aux()

Zhihao Cheng <chengzhihao1@huawei.com>
    i2c: qup: Fix error return code in qup_i2c_bam_schedule_desc()

Bob Peterson <rpeterso@redhat.com>
    gfs2: check for empty rgrp tree in gfs2_ri_update

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Fix userstacktrace option for instances

Peter Ujfalusi <peter.ujfalusi@ti.com>
    spi: bcm2835: Release the DMA channel if probe fails after dma_init

Lukas Wunner <lukas@wunner.de>
    spi: bcm2835: Fix use-after-free on unbind

Lukas Wunner <lukas@wunner.de>
    spi: bcm-qspi: Fix use-after-free on unbind

Lukas Wunner <lukas@wunner.de>
    spi: Introduce device-managed SPI controller allocation

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Set DTE[IntTabLen] to represent 512 IRTEs

Samuel Thibault <samuel.thibault@ens-lyon.org>
    speakup: Reject setting the speakup line discipline outside of speakup

Christian Eggers <ceggers@arri.de>
    i2c: imx: Check for I2SR_IAL after every byte

Christian Eggers <ceggers@arri.de>
    i2c: imx: Fix reset of I2SR_IAL flag

Qian Cai <qcai@redhat.com>
    mm/swapfile: do not sleep with a spin lock held

Paulo Alcantara <pc@cjr.nz>
    cifs: fix potential use-after-free in cifs_echo_request()

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    ftrace: Fix updating FTRACE_FL_TRAMP

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/generic: Add option to enforce preferred_dacs pairs

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add new codec supported for ALC897

Jann Horn <jannh@google.com>
    tty: Fix ->session locking

Jann Horn <jannh@google.com>
    tty: Fix ->pgrp locking in tiocspgrp()

Bjørn Mork <bjorn@mork.no>
    USB: serial: option: fix Quectel BG96 matching

Giacinto Cifelli <gciofono@gmail.com>
    USB: serial: option: add support for Thales Cinterion EXS82

Vincent Palatin <vpalatin@chromium.org>
    USB: serial: option: add Fibocom NL668 variants

Johan Hovold <johan@kernel.org>
    USB: serial: ch341: sort device-id entries

Jan-Niklas Burfeind <kernel@aiyionpri.me>
    USB: serial: ch341: add new Product ID for CH341A

Johan Hovold <johan@kernel.org>
    USB: serial: kl5kusb105: fix memleak on open

Vamsi Krishna Samavedam <vskrishn@codeaurora.org>
    usb: gadget: f_fs: Use local copy of descriptors for userspace copy

Eric Dumazet <edumazet@google.com>
    geneve: pull IP header before ECN decapsulation

Toke Høiland-Jørgensen <toke@redhat.com>
    vlan: consolidate VLAN parsing code and limit max parsing depth

Hans de Goede <hdegoede@redhat.com>
    pinctrl: baytrail: Fix pin being driven low for a while on gpiod_get(..., GPIOD_OUT_HIGH)

Hans de Goede <hdegoede@redhat.com>
    pinctrl: baytrail: Replace WARN with dev_info_once when setting direct-irq pin to output


-------------

Diffstat:

 Makefile                                  |  4 +-
 arch/x86/include/asm/insn.h               | 15 +++++++
 arch/x86/kernel/uprobes.c                 | 10 +++--
 drivers/i2c/busses/i2c-imx.c              | 30 +++++++++++---
 drivers/i2c/busses/i2c-qup.c              |  3 +-
 drivers/input/serio/i8042.c               |  3 +-
 drivers/iommu/amd_iommu_types.h           |  2 +-
 drivers/net/geneve.c                      | 20 +++++++--
 drivers/pinctrl/intel/pinctrl-baytrail.c  | 67 ++++++++++++++++++++++++-------
 drivers/spi/spi-bcm-qspi.c                | 34 ++++++----------
 drivers/spi/spi-bcm2835.c                 | 22 +++++-----
 drivers/spi/spi.c                         | 58 +++++++++++++++++++++++++-
 drivers/staging/speakup/spk_ttyio.c       | 38 +++++++++++-------
 drivers/tty/tty_io.c                      |  7 +++-
 drivers/tty/tty_jobctrl.c                 | 44 ++++++++++++++------
 drivers/usb/gadget/function/f_fs.c        |  6 ++-
 drivers/usb/serial/ch341.c                |  5 ++-
 drivers/usb/serial/kl5kusb105.c           | 10 ++---
 drivers/usb/serial/option.c               | 10 +++--
 fs/cifs/connect.c                         |  2 +
 fs/gfs2/rgrp.c                            |  4 ++
 include/linux/if_vlan.h                   | 29 +++++++++----
 include/linux/spi/spi.h                   | 19 +++++++++
 include/linux/tty.h                       |  4 ++
 include/net/inet_ecn.h                    |  1 +
 kernel/trace/ftrace.c                     | 22 +++++++++-
 kernel/trace/trace.c                      |  7 ++--
 kernel/trace/trace.h                      |  6 ++-
 mm/swapfile.c                             |  4 +-
 sound/pci/hda/hda_generic.c               | 12 ++++--
 sound/pci/hda/hda_generic.h               |  1 +
 sound/pci/hda/patch_realtek.c             |  2 +
 tools/objtool/arch/x86/include/asm/insn.h | 15 +++++++
 33 files changed, 387 insertions(+), 129 deletions(-)


