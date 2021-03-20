Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC78D342BF8
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhCTLSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:18:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhCTLSo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Mar 2021 07:18:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D808B619BE;
        Sat, 20 Mar 2021 10:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616235799;
        bh=UGOQCo8pA0DDbYCQ9ppmpSojvBGQpxgFlUrUYRi74Zg=;
        h=From:To:Cc:Subject:Date:From;
        b=nv+CJ3L1BZu9XkqVk/x4B+AA3UWIARDV6gfBdBgrkGFt/Qxvq8qFlIbK7rxT9IX8E
         GvTsA7rx/vz433y+jpV8x5VLfLKgLRGOOP0dHLiJ1UEGc3SFRGccpGFxM86VC5LqN/
         w/7LA4xxtBlChsjDhBwUT1+r2Euii5cdsQ4BDm2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.25
Date:   Sat, 20 Mar 2021 11:23:15 +0100
Message-Id: <161623579648126@kroah.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.25 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/x86/crypto/aesni-intel_asm.S                       |  133 +++++++++-------
 arch/x86/crypto/aesni-intel_avx-x86_64.S                |   20 +-
 arch/x86/crypto/aesni-intel_glue.c                      |   25 +--
 drivers/infiniband/ulp/srp/ib_srp.c                     |  110 +++++--------
 drivers/net/dsa/b53/b53_common.c                        |   18 ++
 drivers/net/dsa/b53/b53_regs.h                          |    1 
 drivers/net/dsa/bcm_sf2.c                               |   15 -
 fs/fuse/fuse_i.h                                        |    1 
 fs/locks.c                                              |    3 
 fs/nfsd/nfs4state.c                                     |   53 +-----
 kernel/bpf/verifier.c                                   |   33 ++-
 sound/usb/endpoint.c                                    |    3 
 sound/usb/pcm.c                                         |    5 
 tools/testing/selftests/bpf/verifier/bounds_deduction.c |   27 ++-
 tools/testing/selftests/bpf/verifier/map_ptr.c          |    4 
 tools/testing/selftests/bpf/verifier/unpriv.c           |   15 +
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c  |   23 ++
 18 files changed, 265 insertions(+), 226 deletions(-)

Amir Goldstein (1):
      fuse: fix live lock in fuse_iget()

Ard Biesheuvel (1):
      crypto: x86/aes-ni-xts - use direct calls to and 4-way stride

Florian Fainelli (1):
      net: dsa: b53: Support setting learning on port

Greg Kroah-Hartman (1):
      Linux 5.10.25

J. Bruce Fields (2):
      Revert "nfsd4: remove check_conflicting_opens warning"
      Revert "nfsd4: a client's own opens needn't prevent delegations"

Nicolas Morey-Chaisemartin (1):
      RDMA/srp: Fix support for unpopulated and unbalanced NUMA nodes

Piotr Krysiuk (5):
      bpf: Prohibit alu ops for pointer types not defining ptr_limit
      bpf: Fix off-by-one for area size in creating mask to left
      bpf: Simplify alu_limit masking for pointer arithmetic
      bpf: Add sanity check for upper ptr_limit
      bpf, selftests: Fix up some test_verifier cases for unprivileged

Takashi Iwai (1):
      ALSA: usb-audio: Don't avoid stopping the stream at disconnection

Uros Bizjak (1):
      crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%reg

