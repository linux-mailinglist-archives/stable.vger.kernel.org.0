Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7948020BE3
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfEPP6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:58:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43072 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727090AbfEPP6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:48 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImJ-0006zc-PA; Thu, 16 May 2019 16:58:43 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001SY-Ve; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.883686563@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 77/86] x86/speculation/mds: Fix comment
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

commit cae5ec342645746d617dd420d206e1588d47768a upstream.

s/L1TF/MDS/

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/bugs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -276,7 +276,7 @@ static void x86_amd_ssb_disable(void)
 #undef pr_fmt
 #define pr_fmt(fmt)	"MDS: " fmt
 
-/* Default mitigation for L1TF-affected CPUs */
+/* Default mitigation for MDS-affected CPUs */
 static enum mds_mitigations mds_mitigation = MDS_MITIGATION_FULL;
 
 static const char * const mds_strings[] = {

