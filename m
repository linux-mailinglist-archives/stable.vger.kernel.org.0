Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197D75117F7
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 14:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiD0Lr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 07:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbiD0Lrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 07:47:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FDE47AEB;
        Wed, 27 Apr 2022 04:44:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9958B615E3;
        Wed, 27 Apr 2022 11:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DE7C385A7;
        Wed, 27 Apr 2022 11:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651059883;
        bh=90j+8R/5rNw+jSoz6bgMkXm9S6PWEhVU6N8fGS20bj4=;
        h=From:To:Cc:Subject:Date:From;
        b=OjfHy2pUxLRRgF9P0gs0TUqSM0bXq2T+79N95solHcFHwLCOwGJLQC/g600KNTZeS
         6JFrR0TGe7RmVr3zHEY+aMDLQsZtDe+uiD29d6xz6ay3JlMlgwUaJgjfVfVTWwgDz1
         4+pyqMxN9WjTBH9Lv9ezP7jT/IwImyHICGyEVkdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.277
Date:   Wed, 27 Apr 2022 13:44:35 +0200
Message-Id: <165105987520949@kroah.com>
X-Mailer: git-send-email 2.36.0
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

I'm announcing the release of the 4.14.277 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arc/kernel/entry.S                                 |    1 
 arch/arm/mach-vexpress/spc.c                            |    2 
 arch/powerpc/perf/power9-pmu.c                          |    8 -
 arch/x86/include/asm/compat.h                           |    6 -
 block/compat_ioctl.c                                    |    2 
 drivers/ata/pata_marvell.c                              |    2 
 drivers/dma/at_xdmac.c                                  |   12 +-
 drivers/dma/imx-sdma.c                                  |    4 
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c               |    3 
 drivers/net/can/usb/usb_8dev.c                          |   30 +++----
 drivers/net/ethernet/cadence/macb_main.c                |    8 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c             |    4 
 drivers/net/ethernet/micrel/Kconfig                     |    1 
 drivers/net/vxlan.c                                     |    4 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |    2 
 drivers/platform/x86/samsung-laptop.c                   |    2 
 drivers/staging/android/ion/ion.c                       |    3 
 fs/cifs/cifsfs.c                                        |    2 
 fs/ext4/inode.c                                         |   11 ++
 fs/ext4/page-io.c                                       |    4 
 fs/ext4/super.c                                         |   19 +++-
 fs/gfs2/rgrp.c                                          |    9 +-
 fs/stat.c                                               |   19 ++--
 include/linux/etherdevice.h                             |    5 -
 include/net/ax25.h                                      |   12 ++
 include/net/inet_hashtables.h                           |    5 -
 kernel/trace/trace_events_trigger.c                     |   61 ++++++++++++--
 mm/page_alloc.c                                         |    2 
 net/ax25/af_ax25.c                                      |   38 +++++++-
 net/ax25/ax25_dev.c                                     |   28 +++++-
 net/ax25/ax25_route.c                                   |   13 ++-
 net/ax25/ax25_subr.c                                    |   20 +++-
 net/dccp/ipv4.c                                         |    2 
 net/dccp/ipv6.c                                         |    2 
 net/ipv4/inet_connection_sock.c                         |    2 
 net/ipv4/inet_hashtables.c                              |   68 ++++++++++++++--
 net/ipv4/tcp_ipv4.c                                     |   13 ++-
 net/ipv6/tcp_ipv6.c                                     |   13 ++-
 net/netlink/af_netlink.c                                |    7 +
 net/openvswitch/flow_netlink.c                          |    2 
 net/packet/af_packet.c                                  |   13 ++-
 sound/soc/soc-dapm.c                                    |    6 -
 sound/usb/midi.c                                        |    1 
 sound/usb/usbaudio.h                                    |    2 
 45 files changed, 356 insertions(+), 119 deletions(-)

Athira Rajeev (1):
      powerpc/perf: Fix power9 event alternatives

Bob Peterson (1):
      gfs2: assign rgrp glock before compute_bitstructs

Borislav Petkov (2):
      ALSA: usb-audio: Fix undefined behavior due to shift overflowing the constant
      brcmfmac: sdio: Fix undefined behavior due to shift overflowing the constant

Daniel Bristot de Oliveira (1):
      tracing: Dump stacktrace trigger to the corresponding instance

David Howells (1):
      cifs: Check the IOCB_DIRECT flag, not O_DIRECT

Duoming Zhou (8):
      ax25: add refcount in ax25_dev to avoid UAF bugs
      ax25: fix reference count leaks of ax25_dev
      ax25: fix UAF bugs of net_device caused by rebinding operation
      ax25: Fix refcount leaks caused by ax25_cb_del()
      ax25: fix UAF bug in ax25_send_control()
      ax25: fix NPD bug in ax25_disconnect
      ax25: Fix NULL pointer dereferences in ax25 timers
      ax25: Fix UAF bugs in ax25 timers

Eric Dumazet (1):
      netlink: reset network and mac headers in netlink_dump()

Greg Kroah-Hartman (1):
      Linux 4.14.277

Hangbin Liu (1):
      net/packet: fix packet_sock xmit return value checking

Hangyu Hua (1):
      can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in error path

Hongbin Wang (1):
      vxlan: fix error return code in vxlan_fdb_append

Jiapeng Chong (1):
      platform/x86: samsung-laptop: Fix an unsigned comparison which can never be negative

Kees Cook (2):
      etherdevice: Adjust ether_addr* prototypes to silence -Wstringop-overead
      ARM: vexpress/spc: Avoid negative array index when !SMP

Khazhismel Kumykov (1):
      block/compat_ioctl: fix range check in BLKGETSIZE

Kuniyuki Iwashima (1):
      tcp: Fix potential use-after-free due to double kfree()

Lee Jones (1):
      staging: ion: Prevent incorrect reference counting behavour

Marek Vasut (1):
      Revert "net: micrel: fix KS8851_MLL Kconfig"

Miaoqian Lin (1):
      dmaengine: imx-sdma: Fix error checking in sdma_event_remap

Mikulas Patocka (1):
      stat: fix inconsistency between struct stat and struct compat_stat

Paolo Valerio (1):
      openvswitch: fix OOB access in reserve_sfa_size()

Ricardo Dias (1):
      tcp: fix race condition when creating child sockets from syncookies

Sasha Neftin (1):
      e1000e: Fix possible overflow in LTR decoding

Sergey Matyukevich (1):
      ARC: entry: fix syscall_trace_exit argument

Steven Rostedt (Google) (1):
      tracing: Have traceon and traceoff trigger honor the instance

Tadeusz Struk (1):
      ext4: limit length to bitmap_maxbytes - blocksize in punch_hole

Takashi Iwai (1):
      ALSA: usb-audio: Clear MIDI port active flag after draining

Theodore Ts'o (2):
      ext4: fix overhead calculation to account for the reserved gdt blocks
      ext4: force overhead calculation if the s_overhead_cluster makes no sense

Tomas Melin (1):
      net: macb: Restart tx only if queue pointer is lagging

Xiaoke Wang (1):
      drm/msm/mdp5: check the return of kzalloc()

Xiaomeng Tong (2):
      dma: at_xdmac: fix a missing check on list iterator
      ASoC: soc-dapm: fix two incorrect uses of list iterator

Xiongwei Song (1):
      mm: page_alloc: fix building error on -Werror=array-compare

Ye Bin (1):
      ext4: fix symlink file size not match to file content

Zheyu Ma (1):
      ata: pata_marvell: Check the 'bmdma_addr' beforing reading

