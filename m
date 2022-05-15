Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E071C52793A
	for <lists+stable@lfdr.de>; Sun, 15 May 2022 20:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbiEOSrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 14:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbiEOSrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 14:47:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A993AE031;
        Sun, 15 May 2022 11:47:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58A07B80DE1;
        Sun, 15 May 2022 18:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5175C385B8;
        Sun, 15 May 2022 18:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652640423;
        bh=XLpQh99cVdG4ef+QHkLXjgHH5CeF/ijJN8X9p2mpON8=;
        h=From:To:Cc:Subject:Date:From;
        b=sFEspVzMNj6N6hoL4VoGzxFKlE3HyBt4rktp2hhSE7CE9eITj7C6P5zejnxPXi3Qj
         hVhLqBhd8NJdJdVnCHz+FEuXxWsvb8N4m2VxwfOcoplLRupx3GStsknxIsCix/r8Bv
         /Fu7pYuOY4Uuwons67JpiGA3LKHRKfcb/zTgF5ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.314
Date:   Sun, 15 May 2022 20:46:59 +0200
Message-Id: <1652640419140242@kroah.com>
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

I'm announcing the release of the 4.9.314 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                          |    2 +-
 arch/mips/bmips/setup.c           |    2 +-
 arch/mips/lantiq/prom.c           |    2 +-
 arch/mips/pic32/pic32mzda/init.c  |    2 +-
 drivers/block/drbd/drbd_nl.c      |   13 ++++++++-----
 drivers/mmc/host/rtsx_pci_sdmmc.c |   30 ++++++++++++++++++++----------
 drivers/net/can/grcan.c           |   38 ++++++++++++++++++--------------------
 include/net/bluetooth/hci_core.h  |    3 +++
 mm/userfaultfd.c                  |    3 +++
 net/bluetooth/hci_core.c          |    6 +++---
 10 files changed, 59 insertions(+), 42 deletions(-)

Andreas Larsson (2):
      can: grcan: grcan_probe(): fix broken system id check for errata workaround needs
      can: grcan: only use the NAPI poll budget for RX

Greg Kroah-Hartman (1):
      Linux 4.9.314

Itay Iellin (1):
      Bluetooth: Fix the creation of hdev->name

Lee Jones (1):
      block: drbd: drbd_nl: Make conversion to 'enum drbd_ret_code' explicit

Muchun Song (1):
      mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()

Nathan Chancellor (1):
      MIPS: Use address-of operator on section symbols

Ricky WU (1):
      mmc: rtsx: add 74 Clocks in power on flow

