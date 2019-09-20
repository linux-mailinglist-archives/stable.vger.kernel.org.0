Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73876B9271
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbfITOco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:32:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36494 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388282AbfITOZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:10 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqN-00051C-EH; Fri, 20 Sep 2019 15:25:07 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqG-0007wM-DN; Fri, 20 Sep 2019 15:25:00 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Lee Jones" <lee.jones@linaro.org>,
        "Steve Twiss" <stwiss.opensource@diasemi.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.757728856@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 096/132] mfd: da9063: Fix OTP control register names
 to match datasheets for DA9063/63L
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Twiss <stwiss.opensource@diasemi.com>

commit 6b4814a9451add06d457e198be418bf6a3e6a990 upstream.

Mismatch between what is found in the Datasheets for DA9063 and DA9063L
provided by Dialog Semiconductor, and the register names provided in the
MFD registers file. The changes are for the OTP (one-time-programming)
control registers. The two naming errors are OPT instead of OTP, and
COUNT instead of CONT (i.e. control).

Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/mfd/da9063/registers.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mfd/da9063/registers.h
+++ b/include/linux/mfd/da9063/registers.h
@@ -204,9 +204,9 @@
 
 /* DA9063 Configuration registers */
 /* OTP */
-#define	DA9063_REG_OPT_COUNT		0x101
-#define	DA9063_REG_OPT_ADDR		0x102
-#define	DA9063_REG_OPT_DATA		0x103
+#define	DA9063_REG_OTP_CONT		0x101
+#define	DA9063_REG_OTP_ADDR		0x102
+#define	DA9063_REG_OTP_DATA		0x103
 
 /* Customer Trim and Configuration */
 #define	DA9063_REG_T_OFFSET		0x104

