Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F3120C1C
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfEPQBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:01:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42900 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727033AbfEPP6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:46 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImJ-0006zE-HD; Thu, 16 May 2019 16:58:43 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImF-0001T1-7h; Thu, 16 May 2019 16:58:39 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.212257863@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 83/86] Documentation: Correct the possible MDS sysfs
 values
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

From: Tyler Hicks <tyhicks@canonical.com>

commit ea01668f9f43021b28b3f4d5ffad50106a1e1301 upstream.

Adjust the last two rows in the table that display possible values when
MDS mitigation is enabled. They both were slightly innacurate.

In addition, convert the table of possible values and their descriptions
to a list-table. The simple table format uses the top border of equals
signs to determine cell width which resulted in the first column being
far too wide in comparison to the second column that contained the
majority of the text.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/hw-vuln/mds.rst | 29 ++++++++++-------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/Documentation/hw-vuln/mds.rst
+++ b/Documentation/hw-vuln/mds.rst
@@ -95,22 +95,19 @@ mitigations are active. The relevant sys
 
 The possible values in this file are:
 
-  =========================================   =================================
-  'Not affected'				The processor is not vulnerable
+  .. list-table::
 
-  'Vulnerable'					The processor is vulnerable,
-						but no mitigation enabled
-
-  'Vulnerable: Clear CPU buffers attempted'	The processor is vulnerable but
-						microcode is not updated.
-						The mitigation is enabled on a
-						best effort basis.
-						See :ref:`vmwerv`
-
-  'Mitigation: CPU buffer clear'		The processor is vulnerable and the
-						CPU buffer clearing mitigation is
-						enabled.
-  =========================================   =================================
+     * - 'Not affected'
+       - The processor is not vulnerable
+     * - 'Vulnerable'
+       - The processor is vulnerable, but no mitigation enabled
+     * - 'Vulnerable: Clear CPU buffers attempted, no microcode'
+       - The processor is vulnerable but microcode is not updated.
+
+         The mitigation is enabled on a best effort basis. See :ref:`vmwerv`
+     * - 'Mitigation: Clear CPU buffers'
+       - The processor is vulnerable and the CPU buffer clearing mitigation is
+         enabled.
 
 If the processor is vulnerable then the following information is appended
 to the above information:

