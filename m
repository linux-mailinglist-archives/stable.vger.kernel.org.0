Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20F3511751
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 14:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbiD0Lru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 07:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbiD0Lrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 07:47:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05CE47ACB;
        Wed, 27 Apr 2022 04:44:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69DBEB82663;
        Wed, 27 Apr 2022 11:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D84C385A9;
        Wed, 27 Apr 2022 11:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651059874;
        bh=a1Bdh7pj0/0TpjFX8dRBWJERdACuvsll+euv/r/89dI=;
        h=From:To:Cc:Subject:Date:From;
        b=qLcRDid6Y+6HLtGMsCAI/duMShDx/boij0OLrJe/pjs/9yvZ15GHxSdGCRvPkaxCN
         OxoryO+GLhBVIWD0AgS1Ea2cfpmvJJZ75tvkJn4x34V6vgpz+a17sYaMFd/t/NKS4r
         MAuANO3vpRXYiG0iZvhaNrwpAvkugVaR6v2Aa0u0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.312
Date:   Wed, 27 Apr 2022 13:44:30 +0200
Message-Id: <1651059870207100@kroah.com>
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

I'm announcing the release of the 4.9.312 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 -
 arch/arc/kernel/entry.S                                 |    1 
 arch/arm/mach-vexpress/spc.c                            |    2 -
 block/compat_ioctl.c                                    |    2 -
 drivers/ata/pata_marvell.c                              |    2 +
 drivers/dma/at_xdmac.c                                  |   12 +++++-----
 drivers/dma/imx-sdma.c                                  |    4 +--
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c               |    3 ++
 drivers/net/ethernet/intel/e1000e/ich8lan.c             |    4 +--
 drivers/net/vxlan.c                                     |    4 +--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |    2 -
 drivers/platform/x86/samsung-laptop.c                   |    2 -
 fs/cifs/cifsfs.c                                        |    2 -
 fs/ext4/inode.c                                         |   11 ++++++++-
 fs/ext4/super.c                                         |   19 ++++++++++++----
 fs/gfs2/rgrp.c                                          |    9 ++++---
 include/linux/etherdevice.h                             |    5 +---
 mm/page_alloc.c                                         |    2 -
 net/netlink/af_netlink.c                                |    7 +++++
 net/openvswitch/flow_netlink.c                          |    2 -
 net/packet/af_packet.c                                  |   13 +++++++---
 sound/soc/soc-dapm.c                                    |    6 +----
 sound/usb/midi.c                                        |    1 
 sound/usb/usbaudio.h                                    |    2 -
 24 files changed, 78 insertions(+), 41 deletions(-)

Bob Peterson (1):
      gfs2: assign rgrp glock before compute_bitstructs

Borislav Petkov (2):
      ALSA: usb-audio: Fix undefined behavior due to shift overflowing the constant
      brcmfmac: sdio: Fix undefined behavior due to shift overflowing the constant

David Howells (1):
      cifs: Check the IOCB_DIRECT flag, not O_DIRECT

Eric Dumazet (1):
      netlink: reset network and mac headers in netlink_dump()

Greg Kroah-Hartman (1):
      Linux 4.9.312

Hangbin Liu (1):
      net/packet: fix packet_sock xmit return value checking

Hongbin Wang (1):
      vxlan: fix error return code in vxlan_fdb_append

Jiapeng Chong (1):
      platform/x86: samsung-laptop: Fix an unsigned comparison which can never be negative

Kees Cook (2):
      etherdevice: Adjust ether_addr* prototypes to silence -Wstringop-overead
      ARM: vexpress/spc: Avoid negative array index when !SMP

Khazhismel Kumykov (1):
      block/compat_ioctl: fix range check in BLKGETSIZE

Miaoqian Lin (1):
      dmaengine: imx-sdma: Fix error checking in sdma_event_remap

Paolo Valerio (1):
      openvswitch: fix OOB access in reserve_sfa_size()

Sasha Neftin (1):
      e1000e: Fix possible overflow in LTR decoding

Sergey Matyukevich (1):
      ARC: entry: fix syscall_trace_exit argument

Tadeusz Struk (1):
      ext4: limit length to bitmap_maxbytes - blocksize in punch_hole

Takashi Iwai (1):
      ALSA: usb-audio: Clear MIDI port active flag after draining

Theodore Ts'o (2):
      ext4: fix overhead calculation to account for the reserved gdt blocks
      ext4: force overhead calculation if the s_overhead_cluster makes no sense

Xiaoke Wang (1):
      drm/msm/mdp5: check the return of kzalloc()

Xiaomeng Tong (2):
      dma: at_xdmac: fix a missing check on list iterator
      ASoC: soc-dapm: fix two incorrect uses of list iterator

Xiongwei Song (1):
      mm: page_alloc: fix building error on -Werror=array-compare

Zheyu Ma (1):
      ata: pata_marvell: Check the 'bmdma_addr' beforing reading

