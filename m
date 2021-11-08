Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B84449D2E
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 21:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhKHUrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 15:47:42 -0500
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:51196 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229832AbhKHUrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 15:47:41 -0500
X-Greylist: delayed 1102 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Nov 2021 15:47:41 EST
Received: from [128.177.79.46] (helo=[10.118.101.22])
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1mkBDs-000DLJ-Cy; Mon, 08 Nov 2021 15:26:32 -0500
Subject: [PATCH 1/2] MAINTAINERS: Update maintainers for paravirt ops and
 VMware hypervisor interface
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     jgross@suse.com, x86@kernel.org, pv-drivers@vmware.com
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        Deep Shah <sdeep@vmware.com>, stable@vger.kernel.org,
        srivatsa@csail.mit.edu, sdeep@vmware.com, amakhalov@vmware.com,
        virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com, vithampi@vmware.com,
        linux-kernel@vger.kernel.org
Date:   Mon, 08 Nov 2021 12:29:45 -0800
Message-ID: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>
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
Cc: stable@vger.kernel.org
---

 MAINTAINERS |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0ad926ba362f..118cf8170d02 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14188,8 +14188,8 @@ F:	include/uapi/linux/ppdev.h
 
 PARAVIRT_OPS INTERFACE
 M:	Juergen Gross <jgross@suse.com>
-M:	Deep Shah <sdeep@vmware.com>
-M:	"VMware, Inc." <pv-drivers@vmware.com>
+M:	Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
+L:	pv-drivers@vmware.com (private)
 L:	virtualization@lists.linux-foundation.org
 L:	x86@kernel.org
 S:	Supported
@@ -20038,10 +20038,13 @@ S:	Maintained
 F:	drivers/misc/vmw_balloon.c
 
 VMWARE HYPERVISOR INTERFACE
-M:	Deep Shah <sdeep@vmware.com>
-M:	"VMware, Inc." <pv-drivers@vmware.com>
+M:	Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
+M:	Alexey Makhalov <amakhalov@vmware.com>
+L:	pv-drivers@vmware.com (private)
 L:	virtualization@lists.linux-foundation.org
+L:	x86@kernel.org
 S:	Supported
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vmware
 F:	arch/x86/include/asm/vmware.h
 F:	arch/x86/kernel/cpu/vmware.c
 

