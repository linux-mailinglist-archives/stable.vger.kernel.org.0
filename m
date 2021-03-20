Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A60342C3B
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhCTLeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhCTLdn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Mar 2021 07:33:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D1CA619B9;
        Sat, 20 Mar 2021 09:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616234038;
        bh=cP99hmxs+4WqnF2LPhJ4VVRx6L/RDlQt5xOGNQZIVGQ=;
        h=From:To:Cc:Subject:Date:From;
        b=2p0ilCFVMSNhc/atOECeUtI7ZCbpVt93znLaqUflEw7Yy4M/hfDm2bRFMWZdiKT0P
         JsQR2MqN0VthoevjyFH4SwM2ri3o4tbzBIcpkwjd67Cg04dgczqz2ahu8sFZMQjTwL
         7uKjTQtPQFNEn09lLPCc0oue1AH3DSr1XUrX3lMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.182
Date:   Sat, 20 Mar 2021 10:53:54 +0100
Message-Id: <161623403425070@kroah.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.182 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                         |    2 -
 arch/arm64/include/asm/kvm_hyp.h |    3 ++
 arch/arm64/kvm/hyp/debug-sr.c    |   24 +++++++++++++--------
 arch/arm64/kvm/hyp/switch.c      |    4 ++-
 drivers/net/dsa/b53/b53_common.c |   19 +++++++++++++++++
 drivers/net/dsa/b53/b53_regs.h   |    1 
 drivers/net/dsa/bcm_sf2.c        |    5 ----
 fs/ext4/block_validity.c         |   43 +++++++++++++++++++--------------------
 fs/ext4/ext4.h                   |    6 ++---
 fs/ext4/extents.c                |   16 +++++---------
 fs/ext4/indirect.c               |    6 +----
 fs/ext4/inode.c                  |    5 +---
 fs/ext4/mballoc.c                |    4 +--
 kernel/bpf/verifier.c            |   33 +++++++++++++++++++----------
 net/dsa/tag_mtk.c                |   19 +++++++++++------
 15 files changed, 113 insertions(+), 77 deletions(-)

DENG Qingfang (1):
      net: dsa: tag_mtk: fix 802.1ad VLAN egress

Florian Fainelli (1):
      net: dsa: b53: Support setting learning on port

Greg Kroah-Hartman (1):
      Linux 4.19.182

Jan Kara (1):
      ext4: check journal inode extents more carefully

Piotr Krysiuk (4):
      bpf: Prohibit alu ops for pointer types not defining ptr_limit
      bpf: Fix off-by-one for area size in creating mask to left
      bpf: Simplify alu_limit masking for pointer arithmetic
      bpf: Add sanity check for upper ptr_limit

Suzuki K Poulose (1):
      KVM: arm64: nvhe: Save the SPE context early

