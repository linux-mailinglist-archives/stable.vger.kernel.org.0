Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82DDF1008C1
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 16:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfKRPzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 10:55:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbfKRPzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 10:55:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36E84217D6;
        Mon, 18 Nov 2019 15:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574092517;
        bh=YZnjVOt6yX2qLVx9+Tl9hPYlxzt5VspoypeIPjjJjA8=;
        h=Subject:To:From:Date:From;
        b=PPbJCXKzJEOGJGLIDojTOEvlwu6cS/hwMZu6kLyGWN0xEnR9N4RjOunXPcsV0Z5SU
         uxJuQqdlnNWBAV6j603mUYRrfBrp72hmVhOfDQFyCpWy6sjz2KApjVrVDxVuS3Bp8K
         x9LRLMwFO9yyGsKNJyLGjlXxlGq00zI/Y1bzmhhE=
Subject: patch "USB: documentation: flags on usb-storage versus UAS" added to usb-next
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Nov 2019 16:53:13 +0100
Message-ID: <157409239351242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: documentation: flags on usb-storage versus UAS

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 65cc8bf99349f651a0a2cee69333525fe581f306 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Thu, 14 Nov 2019 12:27:58 +0100
Subject: USB: documentation: flags on usb-storage versus UAS

Document which flags work storage, UAS or both

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191114112758.32747-4-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../admin-guide/kernel-parameters.txt         | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a84a83f8881e..a02b1799a756 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4998,13 +4998,13 @@
 			Flags is a set of characters, each corresponding
 			to a common usb-storage quirk flag as follows:
 				a = SANE_SENSE (collect more than 18 bytes
-					of sense data);
+					of sense data, not on uas);
 				b = BAD_SENSE (don't collect more than 18
-					bytes of sense data);
+					bytes of sense data, not on uas);
 				c = FIX_CAPACITY (decrease the reported
 					device capacity by one sector);
 				d = NO_READ_DISC_INFO (don't use
-					READ_DISC_INFO command);
+					READ_DISC_INFO command, not on uas);
 				e = NO_READ_CAPACITY_16 (don't use
 					READ_CAPACITY_16 command);
 				f = NO_REPORT_OPCODES (don't use report opcodes
@@ -5019,17 +5019,18 @@
 				j = NO_REPORT_LUNS (don't use report luns
 					command, uas only);
 				l = NOT_LOCKABLE (don't try to lock and
-					unlock ejectable media);
+					unlock ejectable media, not on uas);
 				m = MAX_SECTORS_64 (don't transfer more
-					than 64 sectors = 32 KB at a time);
+					than 64 sectors = 32 KB at a time,
+					not on uas);
 				n = INITIAL_READ10 (force a retry of the
-					initial READ(10) command);
+					initial READ(10) command, not on uas);
 				o = CAPACITY_OK (accept the capacity
-					reported by the device);
+					reported by the device, not on uas);
 				p = WRITE_CACHE (the device cache is ON
-					by default);
+					by default, not on uas);
 				r = IGNORE_RESIDUE (the device reports
-					bogus residue values);
+					bogus residue values, not on uas);
 				s = SINGLE_LUN (the device has only one
 					Logical Unit);
 				t = NO_ATA_1X (don't allow ATA(12) and ATA(16)
@@ -5038,7 +5039,8 @@
 				w = NO_WP_DETECT (don't test whether the
 					medium is write-protected).
 				y = ALWAYS_SYNC (issue a SYNCHRONIZE_CACHE
-					even if the device claims no cache)
+					even if the device claims no cache,
+					not on uas)
 			Example: quirks=0419:aaf5:rl,0421:0433:rc
 
 	user_debug=	[KNL,ARM]
-- 
2.24.0


