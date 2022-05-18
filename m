Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3363B52B4F4
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 10:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbiERIWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 04:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbiERIWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 04:22:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239B21059F8;
        Wed, 18 May 2022 01:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE01E615C5;
        Wed, 18 May 2022 08:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B01C385A5;
        Wed, 18 May 2022 08:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652862155;
        bh=4FN2wx6ydsNTy8dh8Pw500UygIT7HpfSHxI/txUhZbk=;
        h=From:To:Cc:Subject:Date:From;
        b=l+j0XWVKpHioptuKuKt4Fik2J31Z490g3NzD4pJX0W7OEng+KbvJCDBzs8aQ6KzWr
         jwLvKiPGP9zHJ41eKAW8OLUBPdgzhngqMN2Tz+6CGgLeBZvCRm2Xz91XCTnsH8b2MX
         27LwNY72IBn38ci71FsZ+U/0QPyAwzZXKxTqWyZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.244
Date:   Wed, 18 May 2022 10:22:31 +0200
Message-Id: <165286215191133@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.244 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 +-
 arch/mips/generic/board-ocelot_pcb123.its.S |   10 +++++-----
 arch/s390/Makefile                          |   10 ++++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c          |    2 +-
 drivers/hwmon/Kconfig                       |    2 +-
 drivers/hwmon/f71882fg.c                    |    5 +++--
 drivers/hwmon/tmp401.c                      |   11 +++++++++++
 drivers/net/ethernet/sfc/ef10.c             |    5 +++++
 drivers/net/wireless/mac80211_hwsim.c       |    3 +++
 drivers/s390/net/ctcm_mpc.c                 |    6 +-----
 drivers/s390/net/ctcm_sysfs.c               |    5 +++--
 drivers/s390/net/lcs.c                      |    7 ++++---
 drivers/slimbus/qcom-ctrl.c                 |    4 ++--
 drivers/tty/serial/digicolor-usart.c        |    2 +-
 drivers/usb/class/cdc-wdm.c                 |    1 +
 drivers/usb/serial/option.c                 |    4 ++++
 drivers/usb/serial/pl2303.c                 |    1 +
 drivers/usb/serial/pl2303.h                 |    1 +
 drivers/usb/serial/qcserial.c               |    2 ++
 drivers/usb/typec/tcpci.c                   |    2 +-
 fs/gfs2/bmap.c                              |   11 +++++------
 include/linux/netdev_features.h             |    4 ++--
 include/net/tc_act/tc_pedit.h               |    1 +
 kernel/cgroup/cpuset.c                      |    7 +++++--
 net/batman-adv/fragmentation.c              |   11 +++++++++++
 net/core/secure_seq.c                       |   12 +++++++++---
 net/ipv4/ping.c                             |   12 +++++++++++-
 net/ipv4/route.c                            |    1 +
 net/netlink/af_netlink.c                    |    1 -
 net/sched/act_pedit.c                       |   26 ++++++++++++++++++++++----
 net/smc/smc_rx.c                            |    4 ++--
 sound/soc/codecs/max98090.c                 |    5 ++++-
 sound/soc/soc-ops.c                         |   18 +++++++++++++++++-
 33 files changed, 151 insertions(+), 47 deletions(-)

Alexandra Winter (3):
      s390/ctcm: fix variable dereferenced before check
      s390/ctcm: fix potential memory leak
      s390/lcs: fix variable dereferenced before check

Andreas Gruenbacher (1):
      gfs2: Fix filesystem block deallocation for short writes

Camel Guo (1):
      hwmon: (tmp401) Add OF device ID table

Eric Dumazet (2):
      netlink: do not reset transport header in netlink_recvmsg()
      tcp: resalt the secret every 10 seconds

Ethan Yang (1):
      USB: serial: qcserial: add support for Sierra Wireless EM7590

Greg Kroah-Hartman (1):
      Linux 4.19.244

Guangguan Wang (1):
      net/smc: non blocking recvmsg() return -EAGAIN when no data and signal_pending

Ji-Ze Hong (Peter Hong) (1):
      hwmon: (f71882fg) Fix negative temperature

Johannes Berg (1):
      mac80211_hwsim: call ieee80211_tx_prepare_skb under RCU protection

Lokesh Dhoundiyal (1):
      ipv4: drop dst in multicast routing path

Mark Brown (3):
      ASoC: max98090: Reject invalid values in custom control put()
      ASoC: max98090: Generate notifications on changes for custom control
      ASoC: ops: Validate input values in snd_soc_put_volsw_range()

Miaoqian Lin (1):
      slimbus: qcom: Fix IRQ check in qcom_slim_probe

Nicolas Dichtel (1):
      ping: fix address binding wrt vrf

Paolo Abeni (1):
      net/sched: act_pedit: really ensure the skb is writable

Randy Dunlap (1):
      hwmon: (ltq-cputemp) restrict it to SOC_XWAY

Scott Chen (1):
      USB: serial: pl2303: add device id for HP LM930 Display

Sergey Ryazanov (1):
      usb: cdc-wdm: fix reading stuck on device close

Sudip Mukherjee (1):
      MIPS: fix allmodconfig build with latest mkimage

Sven Eckelmann (1):
      batman-adv: Don't skb_split skbuffs with frag_list

Sven Schnelle (1):
      s390: disable -Warray-bounds

Sven Schwermer (2):
      USB: serial: option: add Fibocom L610 modem
      USB: serial: option: add Fibocom MA510 modem

Taehee Yoo (1):
      net: sfc: ef10: fix memory leak in efx_ef10_mtd_probe()

Tariq Toukan (1):
      net: Fix features skip in for_each_netdev_feature()

Uwe Kleine-König (1):
      usb: typec: tcpci: Don't skip cleanup in .remove() on error

Waiman Long (1):
      cgroup/cpuset: Remove cpus_allowed/mems_allowed setup in cpuset_init_smp()

Yang Yingliang (1):
      tty/serial: digicolor: fix possible null-ptr-deref in digicolor_uart_probe()

Zack Rusin (1):
      drm/vmwgfx: Initialize drm_mode_fb_cmd2

