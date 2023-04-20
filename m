Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317F06E9028
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 12:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbjDTK1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 06:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234727AbjDTK1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 06:27:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F196E9D;
        Thu, 20 Apr 2023 03:26:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB57A6134C;
        Thu, 20 Apr 2023 10:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E25C433D2;
        Thu, 20 Apr 2023 10:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681986368;
        bh=+IddnfRfT9pMoLX32C/CO2IG0NekrTCOUtF81V+b8Sg=;
        h=From:To:Cc:Subject:Date:From;
        b=jY/IVp8kwLh+jWN0UIqNU70e3mc44mVQ0g8zeqCV2ltcxCN6CaOa/yxvqwOK1HUZf
         MkHuAsRe8XZaI8gfS1i6hRvo96yOR9wQ8GaDL3Co+rJcoJFbnFco+Pu4C2I33SZnoY
         myPqBACIFseL3tDLUuhhgsZ8hHKIxDqAjmocqRho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.281
Date:   Thu, 20 Apr 2023 12:26:02 +0200
Message-Id: <2023042002-rockfish-material-b52d@gregkh>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.281 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/sound/hd-audio/models.rst         |    2 
 Makefile                                        |    2 
 arch/arm64/kvm/guest.c                          |   83 +++++++++++++++++++-----
 arch/x86/kernel/sysfb_efi.c                     |    8 ++
 arch/x86/kvm/vmx/vmx.c                          |   10 ++
 arch/x86/pci/fixup.c                            |   21 ++++++
 crypto/asymmetric_keys/verify_pefile.c          |   12 ++-
 drivers/gpio/gpio-davinci.c                     |    2 
 drivers/hwtracing/coresight/coresight-etm4x.c   |    2 
 drivers/i2c/busses/i2c-imx-lpi2c.c              |    2 
 drivers/iio/dac/cio-dac.c                       |    4 -
 drivers/mtd/mtdblock.c                          |   12 ++-
 drivers/mtd/ubi/build.c                         |   21 ++++--
 drivers/mtd/ubi/wl.c                            |    5 -
 drivers/net/ethernet/cadence/macb_main.c        |    4 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c |    8 ++
 drivers/net/ethernet/sun/niu.c                  |    2 
 drivers/pinctrl/pinctrl-amd.c                   |   56 ++++++++++++----
 drivers/power/supply/cros_usbpd-charger.c       |    2 
 drivers/pwm/pwm-cros-ec.c                       |    1 
 drivers/scsi/ses.c                              |   20 ++---
 drivers/tty/serial/sh-sci.c                     |    9 ++
 drivers/usb/serial/cp210x.c                     |    1 
 drivers/usb/serial/option.c                     |   10 ++
 drivers/watchdog/sbsa_gwdt.c                    |    1 
 fs/nfs/nfs4_fs.h                                |    2 
 fs/nfs/nfs4proc.c                               |   25 ++++---
 fs/nfs/nfs4state.c                              |    8 +-
 fs/nilfs2/segment.c                             |    3 
 fs/nilfs2/super.c                               |    2 
 fs/nilfs2/the_nilfs.c                           |   12 ++-
 include/linux/ftrace.h                          |    2 
 kernel/cgroup/cpuset.c                          |    4 -
 kernel/events/core.c                            |    2 
 kernel/trace/ring_buffer.c                      |   13 +++
 mm/swapfile.c                                   |    3 
 net/9p/trans_xen.c                              |    4 +
 net/bluetooth/hidp/core.c                       |    2 
 net/bluetooth/l2cap_core.c                      |   24 +-----
 net/core/netpoll.c                              |   19 +++++
 net/ipv4/icmp.c                                 |    5 +
 net/ipv6/ip6_output.c                           |    7 +-
 net/ipv6/udp.c                                  |    8 +-
 net/mac80211/sta_info.c                         |    3 
 net/sctp/socket.c                               |    4 +
 net/sctp/stream_interleave.c                    |    3 
 sound/i2c/cs8427.c                              |    7 +-
 sound/pci/emu10k1/emupcm.c                      |    4 -
 sound/pci/hda/patch_realtek.c                   |    1 
 sound/pci/hda/patch_sigmatel.c                  |   10 ++
 50 files changed, 349 insertions(+), 128 deletions(-)

Alexander Stein (1):
      i2c: imx-lpi2c: clean rx/tx buffers upon new message

Bang Li (1):
      mtdblock: tolerate corrected bit-flips

Basavaraj Natikar (1):
      x86/PCI: Add quirk for AMD XHCI controller that loses MSI-X state in D3hot

Biju Das (2):
      tty: serial: sh-sci: Fix transmit end interrupt handler
      tty: serial: sh-sci: Fix Rx on RZ/G2L SCI

Bjørn Mork (1):
      USB: serial: option: add Quectel RM500U-CN modem

Dave Martin (2):
      KVM: arm64: Factor out core register ID enumeration
      KVM: arm64: Filter out invalid core register IDs in KVM_GET_REG_LIST

Denis Plotnikov (1):
      qlcnic: check pci_reset_function result

Dhruva Gole (1):
      gpio: davinci: Add irq chip flag to skip set wake

Enrico Sau (1):
      USB: serial: option: add Telit FE990 compositions

Eric Dumazet (2):
      icmp: guard against too small mtu
      udp6: fix potential access to stale information

Felix Fietkau (1):
      wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta

George Cherian (1):
      watchdog: sbsa_wdog: Make sure the timeout programming is within the limits

Grant Grundler (1):
      power: supply: cros_usbpd: reclassify "default case!" as debug

Greg Kroah-Hartman (1):
      Linux 4.19.281

Hans de Goede (1):
      efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L

Harshit Mogalapalli (1):
      niu: Fix missing unwind goto in niu_alloc_channels()

Jakub Kicinski (1):
      net: don't let netpoll invoke NAPI if in xmit context

Jeremy Soller (1):
      ALSA: hda/realtek: Add quirk for Clevo X370SNW

Jiri Kosina (1):
      scsi: ses: Handle enclosure with just a primary component gracefully

John Keeping (1):
      ftrace: Mark get_lock_parent_ip() __always_inline

Kan Liang (1):
      perf/core: Fix the same task check in perf_event_set_output

Kees Jan Koster (1):
      USB: serial: cp210x: add Silicon Labs IFS-USB-DATACABLE IDs

Kornel Dulęba (2):
      pinctrl: amd: Disable and mask interrupts on resume
      Revert "pinctrl: amd: Disable and mask interrupts on resume"

Lee Jones (1):
      mtd: ubi: wl: Fix a couple of kernel-doc issues

Linus Walleij (1):
      pinctrl: amd: Use irqchip template

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}

Marc Zyngier (1):
      arm64: KVM: Fix system register enumeration

Min Li (1):
      Bluetooth: Fix race condition in hidp_session_thread

Oswald Buddenhagen (4):
      ALSA: emu10k1: fix capture interrupt handler unlinking
      ALSA: hda/sigmatel: add pin overrides for Intel DP45SG motherboard
      ALSA: i2c/cs8427: fix iec958 mixer control deactivation
      ALSA: hda/sigmatel: fix S/PDIF out on Intel D*45* motherboards

Paolo Bonzini (1):
      KVM: nVMX: add missing consistency checks for CR0 and CR4

Robbie Harwood (1):
      verify_pefile: relax wrapper length check

Roman Gushchin (1):
      net: macb: fix a memory corruption in extended buffer descriptor mode

Rongwei Wang (1):
      mm/swap: fix swap_info_struct race between swapoff and get_swap_pages()

Ryusuke Konishi (2):
      nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()
      nilfs2: fix sysfs interface lifetime

Sachi King (1):
      pinctrl: amd: disable and mask interrupts on probe

Sandeep Singh (1):
      pinctrl: Added IRQF_SHARED flag for amd-pinctrl driver

Steve Clevenger (1):
      coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug

Trond Myklebust (3):
      NFSv4: Convert struct nfs4_state to use refcount_t
      NFSv4: Check the return value of update_open_stateid()
      NFSv4: Fix hangs when recovering open state after a server reboot

Uwe Kleine-König (1):
      pwm: cros-ec: Explicitly set .polarity in .get_state()

Waiman Long (1):
      cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()

William Breathitt Gray (1):
      iio: dac: cio-dac: Fix max DAC write value check for 12-bit

Xin Long (2):
      sctp: check send stream number after wait_for_sndbuf
      sctp: fix a potential overflow in sctp_ifwdtsn_skip

ZhaoLong Wang (1):
      ubi: Fix deadlock caused by recursively holding work_sem

Zheng Wang (1):
      9p/xen : Fix use after free bug in xen_9pfs_front_remove due to race condition

Zheng Yejian (1):
      ring-buffer: Fix race while reader and writer are on the same page

Zhihao Cheng (1):
      ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size

Ziyang Xuan (1):
      ipv6: Fix an uninit variable access bug in __ip6_make_skb()

