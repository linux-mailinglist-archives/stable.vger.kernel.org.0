Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98F83941DF
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 13:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbhE1Lhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 07:37:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234546AbhE1Lhj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 May 2021 07:37:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9796613D1;
        Fri, 28 May 2021 11:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622201765;
        bh=bb/E0D5EQAodXvkdBgr9zcu4Ss6/2jmx7boMrJHriWI=;
        h=From:To:Cc:Subject:Date:From;
        b=AW+ZXrMHy8fDmUrJfnsUbFtdzU/7taPjiHlSvp4FwBpcJrVIG/jGVlfCuPRNDdEIB
         WZoeeOVD3Rk89FkIUb+do/7S/UTBwZqCwoJM18L/y7UoRjqOIdDstIVElPy6fbttfH
         q2N/ce2+XgZqvBtwAVuDaLFdwG/N2vQTygojqu34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.41
Date:   Fri, 28 May 2021 13:35:56 +0200
Message-Id: <16222017579575@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.41 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
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
 tools/perf/util/unwind-libdw.c   |   35 ++++++++++++++++++++++++++---
 10 files changed, 103 insertions(+), 33 deletions(-)

Daniel Borkmann (3):
      bpf: Wrap aux data inside bpf_sanitize_info container
      bpf: Fix mask direction swap upon off reg sign change
      bpf: No need to simulate speculative domain for immediates

Dave Rigby (1):
      perf unwind: Set userdata for all __report_module() paths

Dongliang Mu (1):
      NFC: nci: fix memory leak in nci_allocate_device

Greg Kroah-Hartman (1):
      Linux 5.10.41

Jan Kratochvil (1):
      perf unwind: Fix separate debug info files when using elfutils' libdw's unwinder

Wanpeng Li (3):
      context_tracking: Move guest exit context tracking to separate helpers
      context_tracking: Move guest exit vtime accounting to separate helpers
      KVM: x86: Defer vtime accounting 'til after IRQ handling

