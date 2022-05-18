Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA5652B3F5
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 09:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbiERHle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 03:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbiERHlc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 03:41:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4465857B1A;
        Wed, 18 May 2022 00:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C043B6145E;
        Wed, 18 May 2022 07:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80BDC385A5;
        Wed, 18 May 2022 07:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652859689;
        bh=LuxVNvlkv4g7heSuZDIJVco2E3/VP9SZoe1bQ0sW5e0=;
        h=From:To:Cc:Subject:Date:From;
        b=TAjScpgZ6/CKIAUIqnUeYLg6ACPm8EOmiBIQa4yLyZ2780QXd93RgJJ9gCy9TrDiH
         /FZ/mfZjxt/ADBbhP9mpz2h5EwFq+WbdW+8PbG0EAYQ4Qgj8LAGRFccG5xXCgHs0Kb
         3CpCKlvqqy4djxdJaXo+BNYZx9VmVoiap2CAvH0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.315
Date:   Wed, 18 May 2022 09:41:24 +0200
Message-Id: <165285968418999@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.315 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 +-
 drivers/hwmon/f71882fg.c              |    5 +++--
 drivers/net/ethernet/sfc/ef10.c       |    5 +++++
 drivers/net/wireless/mac80211_hwsim.c |    3 +++
 drivers/s390/net/ctcm_mpc.c           |    6 +-----
 drivers/s390/net/ctcm_sysfs.c         |    5 +++--
 drivers/s390/net/lcs.c                |    7 ++++---
 drivers/tty/serial/digicolor-usart.c  |    2 +-
 drivers/usb/class/cdc-wdm.c           |    1 +
 drivers/usb/serial/option.c           |    4 ++++
 drivers/usb/serial/pl2303.c           |    1 +
 drivers/usb/serial/pl2303.h           |    1 +
 drivers/usb/serial/qcserial.c         |    2 ++
 include/linux/netdev_features.h       |    4 ++--
 net/ipv4/ping.c                       |   12 +++++++++++-
 net/ipv4/route.c                      |    1 +
 net/netlink/af_netlink.c              |    1 -
 sound/soc/codecs/max98090.c           |    5 ++++-
 sound/soc/soc-ops.c                   |   18 +++++++++++++++++-
 19 files changed, 65 insertions(+), 20 deletions(-)

Alexandra Winter (3):
      s390/ctcm: fix variable dereferenced before check
      s390/ctcm: fix potential memory leak
      s390/lcs: fix variable dereferenced before check

Eric Dumazet (1):
      netlink: do not reset transport header in netlink_recvmsg()

Ethan Yang (1):
      USB: serial: qcserial: add support for Sierra Wireless EM7590

Greg Kroah-Hartman (1):
      Linux 4.9.315

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

Nicolas Dichtel (1):
      ping: fix address binding wrt vrf

Scott Chen (1):
      USB: serial: pl2303: add device id for HP LM930 Display

Sergey Ryazanov (1):
      usb: cdc-wdm: fix reading stuck on device close

Sven Schwermer (2):
      USB: serial: option: add Fibocom L610 modem
      USB: serial: option: add Fibocom MA510 modem

Taehee Yoo (1):
      net: sfc: ef10: fix memory leak in efx_ef10_mtd_probe()

Tariq Toukan (1):
      net: Fix features skip in for_each_netdev_feature()

Yang Yingliang (1):
      tty/serial: digicolor: fix possible null-ptr-deref in digicolor_uart_probe()

