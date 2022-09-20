Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44BE55BE2DE
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 12:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiITKRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 06:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiITKRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 06:17:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DEA6D9C8;
        Tue, 20 Sep 2022 03:17:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 450F5B80B6C;
        Tue, 20 Sep 2022 10:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94219C433D6;
        Tue, 20 Sep 2022 10:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663669036;
        bh=TB+sd/64E1ov5Jwn6RAlUDv+L+hmQwudSkprwu2SpCg=;
        h=From:To:Cc:Subject:Date:From;
        b=j4+eD4I4oRl9ZBaLNLnlXpBf/HwSMdVzU8oUlEroKL4do23qme+xmMw8RQaVi1APD
         SQQmI4Mt5jjXyAhJniluvSB0UeKJYfWloTG+7fbMxc+PMGZ6/57ak9OKoBTQS+5Q5Z
         PqC5eBcFcaiH/g5BQuDbmSfwJLq2YWEviMTpeViU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.294
Date:   Tue, 20 Sep 2022 12:17:40 +0200
Message-Id: <1663669061118192@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.294 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 +-
 drivers/gpu/drm/msm/msm_rd.c          |    3 +++
 drivers/hid/intel-ish-hid/ishtp-hid.h |    2 +-
 drivers/net/ethernet/broadcom/tg3.c   |    8 ++++++--
 drivers/net/ieee802154/cc2520.c       |    1 +
 drivers/platform/x86/acer-wmi.c       |    9 ++++++++-
 fs/tracefs/inode.c                    |   31 +++++++++++++++++++++++--------
 mm/mmap.c                             |    9 +++++++--
 8 files changed, 50 insertions(+), 15 deletions(-)

Brian Norris (1):
      tracefs: Only clobber mode/uid/gid on remount if asked

Greg Kroah-Hartman (1):
      Linux 4.14.294

Hans de Goede (1):
      platform/x86: acer-wmi: Acer Aspire One AOD270/Packard Bell Dot keymap fixes

Jann Horn (1):
      mm: Fix TLB flush for not-first PFNMAP mappings in unmap_region()

Jason Wang (1):
      HID: ishtp-hid-clientHID: ishtp-hid-client: Fix comment typo

Kai-Heng Feng (1):
      tg3: Disable tg3 device on system reboot to avoid triggering AER

Li Qiong (1):
      ieee802154: cc2520: add rc code in cc2520_tx()

Rob Clark (1):
      drm/msm/rd: Fix FIFO-full deadlock

