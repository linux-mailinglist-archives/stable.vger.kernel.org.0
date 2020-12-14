Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9BF2DA0EC
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502801AbgLNT47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:56:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502835AbgLNT4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 14:56:51 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.1
Date:   Mon, 14 Dec 2020 20:57:40 +0100
Message-Id: <16079746727695@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.1 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile             |    2 +-
 drivers/md/dm-raid.c |   12 +++++-------
 drivers/md/md.h      |    4 ++--
 3 files changed, 8 insertions(+), 10 deletions(-)

Greg Kroah-Hartman (3):
      Revert "md: change mddev 'chunk_sectors' from int to unsigned"
      Revert "dm raid: fix discard limits for raid1 and raid10"
      Linux 5.10.1

