Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6963941E5
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 13:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbhE1Lhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 07:37:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234783AbhE1Lhr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 May 2021 07:37:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2B6A61378;
        Fri, 28 May 2021 11:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622201773;
        bh=C0aVMXibZOmzHQhlrDgIlNwAkDULi5eFT4KubSuHhJw=;
        h=From:To:Cc:Subject:Date:From;
        b=nyiPRgMGFC/AVIKRk/XVTEleQe6zKnT5ygaXURmGuGjrfurj9JYbJrp4KiQ1GWPDe
         WxwfSBdFNYVvMd4hpOLgEE0vmxcoyV/blKIQpYT2t67JVWIzhvZl4Nw6IinoKjpevR
         YFJF+cdgIxDzO/T8nND+kFCs/W0+nuVpiT9oPv/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.12.8
Date:   Fri, 28 May 2021 13:36:01 +0200
Message-Id: <162220176213976@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.12.8 kernel.

All users of the 5.12 kernel series must upgrade.

The updated 5.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.12.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                         |    2 -
 arch/x86/kvm/svm/svm.c           |    6 ++---
 arch/x86/kvm/vmx/vmx.c           |    6 ++---
 arch/x86/kvm/x86.c               |    9 +++++++
 include/linux/context_tracking.h |   25 +++++++++++++++++----
 include/net/nfc/nci_core.h       |    1 
 kernel/bpf/verifier.c            |   46 +++++++++++++++++++++++----------------
 net/nfc/nci/core.c               |    1 
 net/nfc/nci/hci.c                |    5 ++++
 9 files changed, 72 insertions(+), 29 deletions(-)

Daniel Borkmann (3):
      bpf: Wrap aux data inside bpf_sanitize_info container
      bpf: Fix mask direction swap upon off reg sign change
      bpf: No need to simulate speculative domain for immediates

Dongliang Mu (1):
      NFC: nci: fix memory leak in nci_allocate_device

Greg Kroah-Hartman (1):
      Linux 5.12.8

Wanpeng Li (3):
      context_tracking: Move guest exit context tracking to separate helpers
      context_tracking: Move guest exit vtime accounting to separate helpers
      KVM: x86: Defer vtime accounting 'til after IRQ handling

