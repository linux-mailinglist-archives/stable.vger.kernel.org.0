Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713773E394A
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 09:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhHHHPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 03:15:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229504AbhHHHPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 03:15:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FD1060F02;
        Sun,  8 Aug 2021 07:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628406922;
        bh=19MyriqWL0i0qp9NyBtdeUE7ylhEu80OW3mYoLdtfl8=;
        h=From:To:Cc:Subject:Date:From;
        b=qpIDBy05kNsGtLSBztZuNwZe+zk3RgqdR59eLmU5v0m3yctfFzspIjyJccARlhS3B
         25VvBibDAfAGebf6NM1O8YjSy0hRMrthvNpuAecWgDlPB6S7hCEnilev9m8DgWWQYn
         F3qNezH/BnxX70c7YzZwIiNHlvK1z0VzXZHLk2Gc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.243
Date:   Sun,  8 Aug 2021 09:15:18 +0200
Message-Id: <1628406918121186@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.243 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 -
 drivers/net/ethernet/qlogic/qed/qed_mcp.c |   23 ++++++++++++++-----
 drivers/net/usb/r8152.c                   |    3 +-
 drivers/spi/spi-mt65xx.c                  |   19 ++++-----------
 drivers/watchdog/iTCO_wdt.c               |   12 ++--------
 fs/btrfs/compression.c                    |    2 -
 include/linux/mfd/rt5033-private.h        |    4 +--
 net/bluetooth/hci_core.c                  |   16 ++++++-------
 net/core/skbuff.c                         |    5 +++-
 virt/kvm/kvm_main.c                       |   36 +++++++++++++++++++++++++-----
 10 files changed, 73 insertions(+), 49 deletions(-)

Axel Lin (1):
      regulator: rt5033: Fix n_voltages settings for BUCK and LDO

Goldwyn Rodrigues (1):
      btrfs: mark compressed range uptodate only if all bio succeed

Greg Kroah-Hartman (3):
      Revert "Bluetooth: Shutdown controller after workqueues are flushed or cancelled"
      Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"
      Linux 4.14.243

Guenter Roeck (1):
      spi: mediatek: Fix fifo transfer

Jia He (1):
      qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()

Nicholas Piggin (1):
      KVM: do not allow mapping valid but non-reference-counted pages

Paolo Bonzini (1):
      KVM: do not assume PTE is writable after follow_pfn

Pravin B Shelar (1):
      net: Fix zero-copy head len calculation.

Sean Christopherson (1):
      KVM: Use kvm_pfn_t for local PFN variable in hva_to_pfn_remapped()

Takashi Iwai (1):
      r8152: Fix potential PM refcount imbalance

