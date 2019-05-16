Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568E320C6F
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfEPQEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:04:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42436 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726681AbfEPP6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:42 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0006yx-J0; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001Nk-UQ; Thu, 16 May 2019 16:58:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Jason Baron" <jbaron@akamai.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jonathan Corbet" <corbet@lwn.net>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.223557237@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 18/86] locking/static_keys: Fix a silly typo
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

From: Jonathan Corbet <corbet@lwn.net>

commit edcd591c77a48da753456f92daf8bb50fe9bac93 upstream.

Commit:

  412758cb2670 ("jump label, locking/static_keys: Update docs")

introduced a typo that might as well get fixed.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20150907131803.54c027e1@lwn.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/static-keys.txt | 2 +-
 include/linux/jump_label.h    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/static-keys.txt
+++ b/Documentation/static-keys.txt
@@ -16,7 +16,7 @@ The updated API replacements are:
 DEFINE_STATIC_KEY_TRUE(key);
 DEFINE_STATIC_KEY_FALSE(key);
 static_key_likely()
-statick_key_unlikely()
+static_key_unlikely()
 
 0) Abstract
 
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -22,7 +22,7 @@
  * DEFINE_STATIC_KEY_TRUE(key);
  * DEFINE_STATIC_KEY_FALSE(key);
  * static_key_likely()
- * statick_key_unlikely()
+ * static_key_unlikely()
  *
  * Jump labels provide an interface to generate dynamic branches using
  * self-modifying code. Assuming toolchain and architecture support, if we

