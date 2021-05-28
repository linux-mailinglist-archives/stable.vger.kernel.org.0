Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E883941DC
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 13:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbhE1Lha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 07:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233081AbhE1Lha (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 May 2021 07:37:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59A8961378;
        Fri, 28 May 2021 11:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622201755;
        bh=+SwGezilNKapmM9DTVaJp9Mz2qiQQNCBZft31LLZVZA=;
        h=From:To:Cc:Subject:Date:From;
        b=US5HTDjKvsL+JiTMUDMqK4LKW2Yy+G7NvAdgLft3LhFQ/Ix6QWo1wMvsQSBF2Q5aL
         6R7cYrFMfwOsyRourHM2rDBfjETzkcIYoGXlbQm7f8qUmmh9oCBQCO7f1oqVXRCybv
         wJSqJxS394Y+mPeDyCZHbbNWSpKzXb+zAMaptbgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.123
Date:   Fri, 28 May 2021 13:35:52 +0200
Message-Id: <162220175217266@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.123 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                       |    2 -
 drivers/usb/dwc3/gadget.c      |    4 +++
 include/net/nfc/nci_core.h     |    1 
 kernel/bpf/verifier.c          |   46 ++++++++++++++++++++++++-----------------
 net/nfc/nci/core.c             |    1 
 net/nfc/nci/hci.c              |    5 ++++
 tools/perf/util/unwind-libdw.c |   35 +++++++++++++++++++++++++++----
 7 files changed, 71 insertions(+), 23 deletions(-)

Daniel Borkmann (3):
      bpf: Wrap aux data inside bpf_sanitize_info container
      bpf: Fix mask direction swap upon off reg sign change
      bpf: No need to simulate speculative domain for immediates

Dave Rigby (1):
      perf unwind: Set userdata for all __report_module() paths

Dongliang Mu (1):
      NFC: nci: fix memory leak in nci_allocate_device

Greg Kroah-Hartman (1):
      Linux 5.4.123

Jack Pham (1):
      usb: dwc3: gadget: Enable suspend events

Jan Kratochvil (1):
      perf unwind: Fix separate debug info files when using elfutils' libdw's unwinder

