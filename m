Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D597915669C
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgBHSfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:35:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34008 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727836AbgBHS3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:42 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrJ-0003fa-OL; Sat, 08 Feb 2020 18:29:37 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrJ-000CRf-IX; Sat, 08 Feb 2020 18:29:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Oliver Neukum" <oneukum@suse.com>
Date:   Sat, 08 Feb 2020 18:20:40 +0000
Message-ID: <lsq.1581185940.703517754@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 101/148] USB: documentation: flags on usb-storage
 versus UAS
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 65cc8bf99349f651a0a2cee69333525fe581f306 upstream.

Document which flags work storage, UAS or both

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20191114112758.32747-4-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: Drop change relating to ALWAYS_SYNC]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 .../kernel-parameters.txt         | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3730,13 +3730,13 @@ bytes respectively. Such letter suffixes
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
@@ -3751,17 +3751,18 @@ bytes respectively. Such letter suffixes
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

