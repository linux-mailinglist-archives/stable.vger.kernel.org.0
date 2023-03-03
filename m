Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27BE6A9611
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 12:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjCCLYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 06:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjCCLY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 06:24:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1326461892;
        Fri,  3 Mar 2023 03:24:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98712617B4;
        Fri,  3 Mar 2023 11:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC63BC433EF;
        Fri,  3 Mar 2023 11:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677842646;
        bh=TGLZ32kWBoODh5SOSPjmqwAlKM1VGgm71qUZU2b6Mn0=;
        h=From:To:Cc:Subject:Date:From;
        b=zBubpGUn+QCzAA2JNEDRL6PaDTq7ZmC+UxCU1wSJq+ZdooUZrFWSMqCJvaiA1XpDM
         I9zyanvzbx8pIRMcmgE4KomIPb8gDz6fTMBC1/LBmIXTf++i2a/WpxboI58bPNcIr3
         eEFD8POQYfGyixdzZfGUKXDM81fw7n5McjGEhPPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.97
Date:   Fri,  3 Mar 2023 12:23:51 +0100
Message-Id: <167784263216220@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.97 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 
 arch/arm/boot/dts/rk3288.dtsi                    |    1 
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts   |    2 
 arch/x86/include/asm/intel-family.h              |    2 
 drivers/acpi/nfit/core.c                         |    2 
 drivers/hid/hid-core.c                           |    3 +
 drivers/hid/hid-elecom.c                         |   16 +++++-
 drivers/hid/hid-ids.h                            |    3 -
 drivers/hid/hid-quirks.c                         |    3 -
 drivers/infiniband/hw/hfi1/user_exp_rcv.c        |    9 ---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c |   23 +++++----
 drivers/staging/mt7621-dts/gbpc1.dts             |    2 
 drivers/tty/vt/vc_screen.c                       |    7 +-
 drivers/usb/core/hub.c                           |    5 --
 drivers/usb/core/sysfs.c                         |    5 --
 drivers/usb/dwc3/dwc3-pci.c                      |    4 +
 drivers/usb/gadget/function/u_serial.c           |   23 ++++++++-
 drivers/usb/serial/option.c                      |    4 +
 fs/btrfs/send.c                                  |    6 +-
 io_uring/io_uring.c                              |   25 ++++++----
 net/caif/caif_socket.c                           |    1 
 net/core/filter.c                                |    4 -
 net/core/neighbour.c                             |   18 ++++++-
 net/core/stream.c                                |    1 
 net/xfrm/xfrm_interface.c                        |   54 +++++++++++++++++++++--
 net/xfrm/xfrm_policy.c                           |    3 +
 scripts/tags.sh                                  |   11 ++--
 sound/soc/codecs/rt715-sdca-sdw.c                |    2 
 28 files changed, 172 insertions(+), 69 deletions(-)

Alan Stern (1):
      USB: core: Don't hold device lock while reading the "descriptors" sysfs file

Benedict Wong (1):
      Fix XFRM-I support for nested ESP tunnels

Bing-Jhong Billy Jheng (1):
      io_uring: add missing lock in io_get_file_fixed

Carlos Llamas (1):
      scripts/tags.sh: fix incompatibility with PCRE2

Cristian Ciocaltea (1):
      scripts/tags.sh: Invoke 'realpath' via 'xargs'

David Sterba (1):
      btrfs: send: limit number of clones and allocated memory size

Dean Luick (1):
      IB/hfi1: Assign npages earlier

Florian Zumbiehl (1):
      USB: serial: option: add support for VW/Skoda "Carstick LTE"

Greg Kroah-Hartman (1):
      Linux 5.15.97

Heikki Krogerus (1):
      usb: dwc3: pci: add support for the Intel Meteor Lake-M

Jack Yu (1):
      ASoC: rt715-sdca: fix clock stop prepare timeout issue

Johan Jonker (1):
      ARM: dts: rockchip: add power-domains property to dp node on rk3288

Julian Anastasov (1):
      neigh: make sure used and confirmed times are valid

Kan Liang (1):
      x86/cpu: Add Lunar Lake M

Krzysztof Kozlowski (1):
      arm64: dts: rockchip: drop unused LED mode property from rk3328-roc-cc

Kuniyuki Iwashima (1):
      net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().

Martin KaFai Lau (1):
      bpf: bpf_fib_lookup should not return neigh in NUD_FAILED state

Neel Patel (1):
      ionic: refactor use of ionic_rx_fill()

Prashanth K (1):
      usb: gadget: u_serial: Add null pointer check in gserial_resume

Sergio Paracuellos (1):
      staging: mt7621-dts: change palmbus address to lower case

Takahiro Fujii (1):
      HID: elecom: add support for TrackBall 056E:011C

Thomas Weißschuh (1):
      vc_screen: don't clobber return value in vcs_read

Vishal Verma (1):
      ACPI: NFIT: fix a potential deadlock during NFIT teardown

Xin Zhao (1):
      HID: core: Fix deadloop in hid_apply_multiplier.

