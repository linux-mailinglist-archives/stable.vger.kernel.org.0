Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8010F2D7961
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 16:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgLKP3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 10:29:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389737AbgLKP31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 10:29:27 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.212
Date:   Fri, 11 Dec 2020 15:12:52 +0100
Message-Id: <160769597221416@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.212 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 arch/x86/include/asm/insn.h               |   15 ++++++
 arch/x86/kernel/uprobes.c                 |   10 ++--
 drivers/i2c/busses/i2c-imx.c              |   30 +++++++++++--
 drivers/i2c/busses/i2c-qup.c              |    3 -
 drivers/input/serio/i8042.c               |    3 -
 drivers/iommu/amd_iommu_types.h           |    2 
 drivers/pinctrl/intel/pinctrl-baytrail.c  |   67 +++++++++++++++++++++++-------
 drivers/spi/spi-bcm-qspi.c                |   34 +++++----------
 drivers/spi/spi-bcm2835.c                 |   22 ++++-----
 drivers/spi/spi.c                         |   58 +++++++++++++++++++++++++
 drivers/staging/speakup/spk_ttyio.c       |   38 ++++++++++-------
 drivers/tty/tty_io.c                      |    7 ++-
 drivers/tty/tty_jobctrl.c                 |   44 +++++++++++++------
 drivers/usb/gadget/function/f_fs.c        |    6 +-
 drivers/usb/serial/ch341.c                |    5 +-
 drivers/usb/serial/kl5kusb105.c           |   10 +---
 drivers/usb/serial/option.c               |   10 ++--
 fs/cifs/connect.c                         |    2 
 fs/gfs2/rgrp.c                            |    4 +
 include/linux/if_vlan.h                   |   29 +++++++++---
 include/linux/spi/spi.h                   |   19 ++++++++
 include/linux/tty.h                       |    4 +
 include/net/inet_ecn.h                    |    1 
 kernel/trace/ftrace.c                     |   22 +++++++++
 kernel/trace/trace.c                      |    7 +--
 kernel/trace/trace.h                      |    6 +-
 mm/swapfile.c                             |    4 +
 sound/pci/hda/hda_generic.c               |   12 +++--
 sound/pci/hda/hda_generic.h               |    1 
 sound/pci/hda/patch_realtek.c             |    2 
 tools/objtool/arch/x86/include/asm/insn.h |   15 ++++++
 32 files changed, 370 insertions(+), 124 deletions(-)

Bjørn Mork (1):
      USB: serial: option: fix Quectel BG96 matching

Bob Peterson (1):
      gfs2: check for empty rgrp tree in gfs2_ri_update

Christian Eggers (2):
      i2c: imx: Fix reset of I2SR_IAL flag
      i2c: imx: Check for I2SR_IAL after every byte

Giacinto Cifelli (1):
      USB: serial: option: add support for Thales Cinterion EXS82

Greg Kroah-Hartman (1):
      Linux 4.14.212

Hans de Goede (2):
      pinctrl: baytrail: Replace WARN with dev_info_once when setting direct-irq pin to output
      pinctrl: baytrail: Fix pin being driven low for a while on gpiod_get(..., GPIOD_OUT_HIGH)

Jan-Niklas Burfeind (1):
      USB: serial: ch341: add new Product ID for CH341A

Jann Horn (2):
      tty: Fix ->pgrp locking in tiocspgrp()
      tty: Fix ->session locking

Johan Hovold (2):
      USB: serial: kl5kusb105: fix memleak on open
      USB: serial: ch341: sort device-id entries

Kailang Yang (1):
      ALSA: hda/realtek - Add new codec supported for ALC897

Lukas Wunner (3):
      spi: Introduce device-managed SPI controller allocation
      spi: bcm-qspi: Fix use-after-free on unbind
      spi: bcm2835: Fix use-after-free on unbind

Luo Meng (1):
      Input: i8042 - fix error return code in i8042_setup_aux()

Masami Hiramatsu (1):
      x86/uprobes: Do not use prefixes.nbytes when looping over prefixes.bytes

Naveen N. Rao (1):
      ftrace: Fix updating FTRACE_FL_TRAMP

Paulo Alcantara (1):
      cifs: fix potential use-after-free in cifs_echo_request()

Peter Ujfalusi (1):
      spi: bcm2835: Release the DMA channel if probe fails after dma_init

Qian Cai (1):
      mm/swapfile: do not sleep with a spin lock held

Samuel Thibault (1):
      speakup: Reject setting the speakup line discipline outside of speakup

Steven Rostedt (VMware) (1):
      tracing: Fix userstacktrace option for instances

Suravee Suthikulpanit (1):
      iommu/amd: Set DTE[IntTabLen] to represent 512 IRTEs

Takashi Iwai (1):
      ALSA: hda/generic: Add option to enforce preferred_dacs pairs

Toke Høiland-Jørgensen (1):
      vlan: consolidate VLAN parsing code and limit max parsing depth

Vamsi Krishna Samavedam (1):
      usb: gadget: f_fs: Use local copy of descriptors for userspace copy

Vincent Palatin (1):
      USB: serial: option: add Fibocom NL668 variants

Zhihao Cheng (1):
      i2c: qup: Fix error return code in qup_i2c_bam_schedule_desc()

