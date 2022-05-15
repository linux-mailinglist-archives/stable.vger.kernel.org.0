Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F55A52794D
	for <lists+stable@lfdr.de>; Sun, 15 May 2022 20:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238482AbiEOSsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 14:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238527AbiEOSrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 14:47:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD6A13D0F;
        Sun, 15 May 2022 11:47:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0022B80E07;
        Sun, 15 May 2022 18:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4E4C385B8;
        Sun, 15 May 2022 18:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652640452;
        bh=FIvlbiY6ukvgFMx4phwzTKqj816KLXPTZX8Z9W6dFao=;
        h=From:To:Cc:Subject:Date:From;
        b=xbFCsNTZjTVpuR1JfBSUZIGyuyFoTGmiVtpnJBcQ5mxDiNQS9k+hqgjFv1Tt/dYVg
         wwDoSlThgpSCvaT+gC0dTNP1LOj5yied7gCMH6nxiWKUT1ExRGSG4w3Lv7WTsCSOzS
         DblSzONcPMapTLyVsmrFc02hnCkjGxS1iMUVz70E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.243
Date:   Sun, 15 May 2022 20:47:20 +0200
Message-Id: <16526404411830@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
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

I'm announcing the release of the 4.19.243 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                     |    2 
 arch/mips/bmips/setup.c                                      |    2 
 arch/mips/lantiq/prom.c                                      |    2 
 arch/mips/pic32/pic32mzda/init.c                             |    2 
 arch/mips/ralink/of.c                                        |    2 
 drivers/block/drbd/drbd_nl.c                                 |   13 -
 drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c           |   12 -
 drivers/gpu/drm/amd/display/include/gpio_service_interface.h |    4 
 drivers/net/can/grcan.c                                      |   38 +--
 drivers/net/ethernet/netronome/nfp/nfp_asm.c                 |    4 
 fs/namespace.c                                               |    9 
 include/net/bluetooth/hci_core.h                             |    3 
 include/sound/pcm.h                                          |    2 
 mm/memory.c                                                  |    2 
 mm/userfaultfd.c                                             |    3 
 net/bluetooth/hci_core.c                                     |    6 
 sound/core/pcm.c                                             |    3 
 sound/core/pcm_lib.c                                         |    5 
 sound/core/pcm_memory.c                                      |   11 -
 sound/core/pcm_native.c                                      |  110 +++++++----
 20 files changed, 153 insertions(+), 82 deletions(-)

Andreas Larsson (2):
      can: grcan: grcan_probe(): fix broken system id check for errata workaround needs
      can: grcan: only use the NAPI poll budget for RX

ChenXiaoSong (1):
      VFS: Fix memory leak caused by concurrently mounting fs with subtype

Greg Kroah-Hartman (1):
      Linux 4.19.243

Itay Iellin (1):
      Bluetooth: Fix the creation of hdev->name

Lee Jones (2):
      block: drbd: drbd_nl: Make conversion to 'enum drbd_ret_code' explicit
      drm/amd/display/dc/gpio/gpio_service: Pass around correct dce_{version, environment} types

Muchun Song (2):
      mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()
      mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()

Nathan Chancellor (2):
      MIPS: Use address-of operator on section symbols
      nfp: bpf: silence bitwise vs. logical OR warning

Takashi Iwai (5):
      ALSA: pcm: Fix races among concurrent hw_params and hw_free calls
      ALSA: pcm: Fix races among concurrent read/write and buffer changes
      ALSA: pcm: Fix races among concurrent prepare and hw_params/hw_free calls
      ALSA: pcm: Fix races among concurrent prealloc proc writes
      ALSA: pcm: Fix potential AB/BA lock with buffer_mutex and mmap_lock

