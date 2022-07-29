Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCFA585242
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 17:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237232AbiG2PUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 11:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237298AbiG2PUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 11:20:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD2D3C8EC;
        Fri, 29 Jul 2022 08:20:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BCF1B82830;
        Fri, 29 Jul 2022 15:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83199C433C1;
        Fri, 29 Jul 2022 15:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659108029;
        bh=3GIzD6g4X4SJPWe6lx8YgGQyy1pNa8SOC2UO8Xmqp9Q=;
        h=From:To:Cc:Subject:Date:From;
        b=Tqwop40c1edQ37549A7EROrUauwWCxusXKfwwL7ULA7f3Uzc5SbTrQ93iWs83521v
         QdM8BYeEUjgtGelzHPqv3gQgLNty0h0xNYedB6Thoap8lWJgIY3iJHHnMish46Uyf1
         DU+cEXK5/HYGE+eHQliK6PGr/Zlno5gPjLN+Goyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.325
Date:   Fri, 29 Jul 2022 17:20:22 +0200
Message-Id: <1659108023161245@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.325 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                       |    2 
 arch/alpha/kernel/srmcons.c                    |    2 
 drivers/char/random.c                          |    4 -
 drivers/i2c/busses/i2c-cadence.c               |   30 +----------
 drivers/mfd/rtsx_usb.c                         |   27 +++++++---
 drivers/net/ethernet/emulex/benet/be_cmds.c    |   10 +--
 drivers/net/ethernet/emulex/benet/be_cmds.h    |    2 
 drivers/net/ethernet/emulex/benet/be_ethtool.c |   31 +++++++----
 drivers/net/usb/ax88179_178a.c                 |   14 ++---
 drivers/power/reset/arm-versatile-reboot.c     |    1 
 drivers/s390/char/keyboard.h                   |    4 -
 drivers/tty/cyclades.c                         |    6 +-
 drivers/tty/goldfish.c                         |    2 
 drivers/tty/moxa.c                             |    4 -
 drivers/tty/pty.c                              |   14 -----
 drivers/tty/serial/lpc32xx_hs.c                |    2 
 drivers/tty/tty_buffer.c                       |   66 ++++++++++++++++---------
 drivers/tty/vt/keyboard.c                      |    6 +-
 drivers/tty/vt/vt.c                            |    2 
 drivers/xen/gntdev.c                           |    3 -
 include/linux/lsm_hooks.h                      |    7 --
 include/linux/mfd/rtsx_usb.h                   |    2 
 include/linux/security.h                       |    6 --
 include/linux/tty_flip.h                       |    4 +
 include/net/inet_sock.h                        |    3 -
 include/net/ip.h                               |    2 
 include/net/tcp.h                              |    2 
 kernel/bpf/core.c                              |    8 +--
 kernel/events/core.c                           |   45 +++++++++++------
 kernel/exit.c                                  |   19 -------
 mm/mempolicy.c                                 |    2 
 net/ipv4/igmp.c                                |   23 +++++---
 net/ipv4/tcp_output.c                          |    2 
 net/xfrm/xfrm_policy.c                         |    5 +
 security/security.c                            |    6 --
 security/selinux/hooks.c                       |    6 --
 security/smack/smack_lsm.c                     |   20 -------
 sound/core/memalloc.c                          |    1 
 38 files changed, 188 insertions(+), 207 deletions(-)

Demi Marie Obenour (1):
      xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE

Eric Dumazet (1):
      bpf: Make sure mac_header was set before using it

Greg Kroah-Hartman (1):
      Linux 4.9.325

Hangyu Hua (1):
      xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()

Hristo Venev (1):
      be2net: Fix buffer overflow in be_get_module_eeprom

Jason A. Donenfeld (1):
      Revert "Revert "char/random: silence a lockdep splat with printk()""

Jiri Slaby (5):
      tty: drivers/tty/, stop using tty_schedule_flip()
      tty: the rest, stop using tty_schedule_flip()
      tty: drop tty_schedule_flip()
      tty: extract tty_flip_buffer_commit() from tty_flip_buffer_push()
      tty: use new tty_insert_flip_string_and_push_buffer() in pty_write()

Jose Alonso (1):
      net: usb: ax88179_178a needs FLAG_SEND_ZLP

Kuniyuki Iwashima (6):
      ip: Fix a data-race around sysctl_fwmark_reflect.
      tcp/dccp: Fix a data-race around sysctl_tcp_fwmark_accept.
      tcp: Fix a data-race around sysctl_tcp_probe_threshold.
      igmp: Fix data-races around sysctl_igmp_llm_reports.
      igmp: Fix a data-race around sysctl_igmp_max_memberships.
      tcp: Fix a data-race around sysctl_tcp_notsent_lowat.

Miaoqian Lin (1):
      power/reset: arm-versatile: Fix refcount leak in versatile_reboot_probe

Peter Zijlstra (1):
      perf/core: Fix data race between perf_event_set_output() and perf_mmap_close()

Robert Hancock (1):
      i2c: cadence: Change large transfer count reset logic to be unconditional

Shuah Khan (3):
      misc: rtsx_usb: fix use of dma mapped buffer for usb bulk transfer
      misc: rtsx_usb: use separate command and response buffers
      misc: rtsx_usb: set return value in rsp_buf alloc err path

Stephen Smalley (1):
      security,selinux,smack: kill security_task_wait hook

Takashi Iwai (1):
      ALSA: memalloc: Align buffer allocations in page size

Wang Cheng (1):
      mm/mempolicy: fix uninit-value in mpol_rebind_policy()

