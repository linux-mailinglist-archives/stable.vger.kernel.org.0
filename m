Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D966744CA0D
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 21:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhKJUHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 15:07:51 -0500
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:50493 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230230AbhKJUHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 15:07:51 -0500
Received: from [128.177.79.46] (helo=[10.118.101.22])
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1mktq9-000YVe-97; Wed, 10 Nov 2021 15:05:01 -0500
Subject: [PATCH v3 1/3] MAINTAINERS: Update maintainers for paravirt ops and
 VMware hypervisor interface
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     jgross@suse.com, x86@kernel.org, pv-drivers@vmware.com
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        Deep Shah <sdeep@vmware.com>, stable@vger.kernel.org,
        amakhalov@vmware.com, sdeep@vmware.com,
        virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com, vithampi@vmware.com,
        linux-kernel@vger.kernel.org, srivatsa@csail.mit.edu,
        namit@vmware.com, joe@perches.com, kuba@kernel.org,
        rostedt@goodmis.org
Date:   Wed, 10 Nov 2021 12:08:16 -0800
Message-ID: <163657487268.84207.5604596767569015608.stgit@srivatsa-dev>
In-Reply-To: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
References: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>

Deep has decided to transfer maintainership of the VMware hypervisor
interface to Srivatsa, and the joint-maintainership of paravirt ops in
the Linux kernel to Srivatsa and Alexey. Update the MAINTAINERS file
to reflect this change.

Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Acked-by: Alexey Makhalov <amakhalov@vmware.com>
Acked-by: Deep Shah <sdeep@vmware.com>
Acked-by: Juergen Gross <jgross@suse.com>
Cc: stable@vger.kernel.org
---

 MAINTAINERS |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0ad926ba362f..0329d67c5bcf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14188,7 +14188,7 @@ F:	include/uapi/linux/ppdev.h
 
 PARAVIRT_OPS INTERFACE
 M:	Juergen Gross <jgross@suse.com>
-M:	Deep Shah <sdeep@vmware.com>
+M:	Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
 M:	"VMware, Inc." <pv-drivers@vmware.com>
 L:	virtualization@lists.linux-foundation.org
 L:	x86@kernel.org
@@ -20038,10 +20038,13 @@ S:	Maintained
 F:	drivers/misc/vmw_balloon.c
 
 VMWARE HYPERVISOR INTERFACE
-M:	Deep Shah <sdeep@vmware.com>
+M:	Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
+M:	Alexey Makhalov <amakhalov@vmware.com>
 M:	"VMware, Inc." <pv-drivers@vmware.com>
 L:	virtualization@lists.linux-foundation.org
+L:	x86@kernel.org
 S:	Supported
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vmware
 F:	arch/x86/include/asm/vmware.h
 F:	arch/x86/kernel/cpu/vmware.c
 

