Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EDB3373A4
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 14:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbhCKNVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 08:21:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233014AbhCKNVv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 08:21:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71DCE64ECB;
        Thu, 11 Mar 2021 13:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615468910;
        bh=vm7SODZNT796hkkn731NJkDFfI+qPh4Y+bZ9US/HUrA=;
        h=From:To:Cc:Subject:Date:From;
        b=OFwtyKgNKC4D7mb+Dkaruh8AhuZxSKhmEl1rNMmWFAvCdxyMNjl7snccflvL10Olb
         BxPjA8OU6TQy1iPpPZPIDukOCCll4RXvBzez6u5ax5MVVc4xBWd/GKknkAIS3PeLjY
         SU5urUawBpLXA5v7zCokEdOv1gVD9RR/uZH7TLyY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.261
Date:   Thu, 11 Mar 2021 14:21:44 +0100
Message-Id: <161546890424630@kroah.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I'm announcing the release of the 4.4.261 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                        |    2 
 drivers/block/rsxx/core.c       |    8 ++-
 drivers/md/dm-table.c           |   83 +++++++++++++++++++++++++---------------
 drivers/pci/quirks.c            |    3 +
 drivers/platform/x86/acer-wmi.c |    8 +++
 kernel/futex.c                  |    4 +
 sound/pci/ctxfi/cthw20k2.c      |    2 
 7 files changed, 73 insertions(+), 37 deletions(-)

Bjorn Helgaas (1):
      PCI: Add function 1 DMA alias quirk for Marvell 9215 SATA controller

Colin Ian King (1):
      ALSA: ctxfi: cthw20k2: fix mask on conf to allow 4 bits

Dan Carpenter (1):
      rsxx: Return -EFAULT if copy_to_user() fails

Greg Kroah-Hartman (1):
      Linux 4.4.261

Hans de Goede (1):
      platform/x86: acer-wmi: Add new force_caps module parameter

Jeffle Xu (1):
      dm table: fix iterate_devices based device capability checks

Thomas Schoebel-Theuer (2):
      futex: fix irq self-deadlock and satisfy assertion
      futex: fix spin_lock() / spin_unlock_irq() imbalance

