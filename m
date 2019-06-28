Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E66675A46F
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 20:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfF1Sp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 14:45:58 -0400
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:48196 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726620AbfF1Sp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 14:45:57 -0400
Received: from [4.30.142.84] (helo=[127.0.1.1])
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1hgvsV-000T1S-1n; Fri, 28 Jun 2019 14:45:43 -0400
Subject: [4.4.y PATCH 0/4] Backported fixes for 4.4 stable tree
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, Wei Wu <ww9210@gmail.com>,
        Gen Zhang <blackgod016574@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, akaher@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, amakhalov@vmware.com,
        srivatsab@vmware.com, srivatsa@csail.mit.edu
Date:   Fri, 28 Jun 2019 11:45:40 -0700
Message-ID: <156174751125.35226.7600381640894671668.stgit@srivatsa-ubuntu>
User-Agent: StGit/0.18
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This patchset includes a few backported fixes for the 4.4 stable tree.
I would appreciate if you could kindly consider including them in the
next release.

Thank you!

Regards,
Srivatsa

---

Gen Zhang (2):
      ip_sockglue: Fix missing-check bug in ip_ra_control()
      ipv6_sockglue: Fix a missing-check bug in ip6_ra_control()

Vivek Goyal (1):
      ovl: modify ovl_permission() to do checks on two inodes

Wanpeng Li (1):
      KVM: X86: Fix scan ioapic use-before-initialization


 arch/x86/kvm/x86.c       |    3 ++-
 fs/overlayfs/inode.c     |   13 +++++++++++++
 net/ipv4/ip_sockglue.c   |    2 ++
 net/ipv6/ipv6_sockglue.c |    2 ++
 4 files changed, 19 insertions(+), 1 deletion(-)
