Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04E63EC8FB
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 14:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238090AbhHOMaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 08:30:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238040AbhHOMaQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 08:30:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFD4E60EB5;
        Sun, 15 Aug 2021 12:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629030586;
        bh=sTVK7DMdZcZ1LSK6iddEJbZK6AZnU5ymSkE+gl+6Nuw=;
        h=From:To:Cc:Subject:Date:From;
        b=KM2fPrmCCXwXELTubvcl6msjJpRRynh9tnN97pyVH2GVAY6U2OtoksLgVX1fSTk/3
         Wvv5lzd0kxRBEZXI3oK92im0NKrncHwAKzZAeN3QpIthbvSkUr/L74AM80wyNTBJok
         Vg0fECnokTlrNIhG7zBYa1kR0fFNF0VK0ha6jicM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.13.11
Date:   Sun, 15 Aug 2021 14:29:34 +0200
Message-Id: <1629030574212136@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.13.11 kernel.

All users of the 5.13 kernel series must upgrade.

The updated 5.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.13.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 -
 drivers/firmware/broadcom/tee_bnxt_fw.c |   14 ++++++++--
 drivers/net/ppp/ppp_generic.c           |   19 +++++++++++---
 fs/namespace.c                          |   42 +++++++++++++++++++++-----------
 include/linux/security.h                |    1 
 kernel/trace/bpf_trace.c                |    5 ++-
 security/security.c                     |    1 
 sound/core/pcm_native.c                 |    5 +++
 sound/pci/hda/patch_realtek.c           |    2 +
 9 files changed, 66 insertions(+), 25 deletions(-)

Allen Pais (1):
      firmware: tee_bnxt: Release TEE shm, session, and context during kexec

Daniel Borkmann (1):
      bpf: Add lockdown check for probe_write_user helper

Greg Kroah-Hartman (1):
      Linux 5.13.11

Jeremy Szu (1):
      ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 650 G8 Notebook PC

Luke D Jones (1):
      ALSA: hda: Add quirk for ASUS Flow x13

Miklos Szeredi (1):
      ovl: prevent private clone if bind mount is not allowed

Pali Rohár (1):
      ppp: Fix generating ppp unit id when ifname is not specified

Takashi Iwai (1):
      ALSA: pcm: Fix mmap breakage without explicit buffer setup

