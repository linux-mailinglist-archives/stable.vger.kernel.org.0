Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889BA3C3BC6
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 13:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhGKLYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 07:24:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232481AbhGKLYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Jul 2021 07:24:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 470F161220;
        Sun, 11 Jul 2021 11:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626002485;
        bh=f+biP7pVln/wvqfCEZcClck16jxtb8qYVOIEDUGH5lc=;
        h=From:To:Cc:Subject:Date:From;
        b=cFh6wjtmhE4ANir1o3BNsLyb2Y8LPegK09U92uh2RQ0lzMgqWeMLr6dpJq25ZrLK0
         Y0oOcxEtnULP3nM1d9fJ1MTW0bCm5TwrTyBkfVQ0nNPOZ1LnT2QzoKvPESPLE+NfLc
         W/0nRWIhzABY/Otn/4vv9wcbeDYN/6Ieapv9uAis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.131
Date:   Sun, 11 Jul 2021 13:21:19 +0200
Message-Id: <16260024781516@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.131 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    2 +-
 arch/s390/include/asm/stacktrace.h |   18 +++++++++++-------
 arch/x86/kvm/svm.c                 |   33 ++++++++++++++++++++++-----------
 drivers/xen/events/events_base.c   |   23 +++++++++++++++++++----
 4 files changed, 53 insertions(+), 23 deletions(-)

Alper Gun (1):
      KVM: SVM: Call SEV Guest Decommission if ASID binding fails

David Rientjes (1):
      KVM: SVM: Periodically schedule when unregistering regions on destroy

Greg Kroah-Hartman (1):
      Linux 5.4.131

Heiko Carstens (1):
      s390/stack: fix possible register corruption with stack switch helper

Juergen Gross (1):
      xen/events: reset active flag for lateeoi events later

