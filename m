Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9036E9022
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 12:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbjDTK1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 06:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbjDTK1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 06:27:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EC01BC;
        Thu, 20 Apr 2023 03:26:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4843561704;
        Thu, 20 Apr 2023 10:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B49CC433D2;
        Thu, 20 Apr 2023 10:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681986360;
        bh=4zi7psDIbWrl5wkKDuhAu1xkdD4Y7CPf/MEwp3oKVQY=;
        h=From:To:Cc:Subject:Date:From;
        b=OXfnxoSnSFVFhRvRemOl+EjD5tVWLmBA5O1DjrfJY5WdV93DVZZnIL7XfsPGqezlg
         +7sEj+TXpyAEOy6ImBYOKDWRdSdQUGrEYB9QMpVfQk3mzd+0AcqI4hoG0xkt0e9C1e
         4gsG2nY4MamJoWVn6LA3IjhZ8uptqTuCyejdPPVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.313
Date:   Thu, 20 Apr 2023 12:25:57 +0200
Message-Id: <2023042057-kosher-pastor-0c82@gregkh>
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

I'm announcing the release of the 4.14.313 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/sound/hd-audio/models.rst         |    2 
 Makefile                                        |    2 
 arch/arm64/kvm/guest.c                          |   83 +++++++++++++++++++-----
 arch/x86/kernel/sysfb_efi.c                     |    8 ++
 crypto/asymmetric_keys/verify_pefile.c          |   12 ++-
 drivers/gpio/gpio-davinci.c                     |    2 
 drivers/hwtracing/coresight/coresight-etm4x.c   |    2 
 drivers/i2c/busses/i2c-imx-lpi2c.c              |    2 
 drivers/iio/dac/cio-dac.c                       |    4 -
 drivers/mtd/mtdblock.c                          |   12 ++-
 drivers/mtd/ubi/build.c                         |   21 ++++--
 drivers/net/ethernet/cadence/macb_main.c        |    4 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c |    8 ++
 drivers/net/ethernet/sun/niu.c                  |    2 
 drivers/pwm/pwm-cros-ec.c                       |    1 
 drivers/tty/serial/sh-sci.c                     |    2 
 drivers/usb/serial/cp210x.c                     |    1 
 drivers/usb/serial/option.c                     |   10 ++
 drivers/watchdog/sbsa_gwdt.c                    |    1 
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
 net/ipv4/icmp.c                                 |    5 +
 net/ipv6/ip6_output.c                           |    7 +-
 net/mac80211/sta_info.c                         |    3 
 sound/i2c/cs8427.c                              |    7 +-
 sound/pci/emu10k1/emupcm.c                      |    4 -
 sound/pci/hda/patch_sigmatel.c                  |   10 ++
 36 files changed, 210 insertions(+), 76 deletions(-)

Alexander Stein (1):
      i2c: imx-lpi2c: clean rx/tx buffers upon new message

Bang Li (1):
      mtdblock: tolerate corrected bit-flips

Biju Das (1):
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

Eric Dumazet (1):
      icmp: guard against too small mtu

Felix Fietkau (1):
      wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta

George Cherian (1):
      watchdog: sbsa_wdog: Make sure the timeout programming is within the limits

Greg Kroah-Hartman (1):
      Linux 4.14.313

Hans de Goede (1):
      efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L

Harshit Mogalapalli (1):
      niu: Fix missing unwind goto in niu_alloc_channels()

John Keeping (1):
      ftrace: Mark get_lock_parent_ip() __always_inline

Kan Liang (1):
      perf/core: Fix the same task check in perf_event_set_output

Kees Jan Koster (1):
      USB: serial: cp210x: add Silicon Labs IFS-USB-DATACABLE IDs

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

Robbie Harwood (1):
      verify_pefile: relax wrapper length check

Roman Gushchin (1):
      net: macb: fix a memory corruption in extended buffer descriptor mode

Rongwei Wang (1):
      mm/swap: fix swap_info_struct race between swapoff and get_swap_pages()

Ryusuke Konishi (2):
      nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()
      nilfs2: fix sysfs interface lifetime

Steve Clevenger (1):
      coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug

Uwe Kleine-König (1):
      pwm: cros-ec: Explicitly set .polarity in .get_state()

Waiman Long (1):
      cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()

William Breathitt Gray (1):
      iio: dac: cio-dac: Fix max DAC write value check for 12-bit

Zheng Wang (1):
      9p/xen : Fix use after free bug in xen_9pfs_front_remove due to race condition

Zheng Yejian (1):
      ring-buffer: Fix race while reader and writer are on the same page

Zhihao Cheng (1):
      ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size

Ziyang Xuan (1):
      ipv6: Fix an uninit variable access bug in __ip6_make_skb()

