Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD754103F43
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732176AbfKTPm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:42:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52908 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731661AbfKTPkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:20 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004ay-NP; Wed, 20 Nov 2019 15:40:13 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004In-1z; Wed, 20 Nov 2019 15:40:12 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Henk van der Laan" <opensource@henkvdlaan.com>
Date:   Wed, 20 Nov 2019 15:37:52 +0000
Message-ID: <lsq.1574264230.151146159@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 42/83] usb-storage: Add new JMS567 revision to
 unusual_devs
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Henk van der Laan <opensource@henkvdlaan.com>

commit 08d676d1685c2a29e4d0e1b0242324e564d4589e upstream.

Revision 0x0117 suffers from an identical issue to earlier revisions,
therefore it should be added to the quirks list.

Signed-off-by: Henk van der Laan <opensource@henkvdlaan.com>
Link: https://lore.kernel.org/r/20190816200847.21366-1-opensource@henkvdlaan.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/storage/unusual_devs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1987,7 +1987,7 @@ UNUSUAL_DEV(  0x14cd, 0x6600, 0x0201, 0x
 		US_FL_IGNORE_RESIDUE ),
 
 /* Reported by Michael Büsch <m@bues.ch> */
-UNUSUAL_DEV(  0x152d, 0x0567, 0x0114, 0x0116,
+UNUSUAL_DEV(  0x152d, 0x0567, 0x0114, 0x0117,
 		"JMicron",
 		"USB to ATA/ATAPI Bridge",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,

