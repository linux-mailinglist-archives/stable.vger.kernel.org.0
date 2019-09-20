Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEE4B928A
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387583AbfITOdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:33:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36322 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388233AbfITOZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:07 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqK-000514-Sg; Fri, 20 Sep 2019 15:25:04 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-0007zj-Qc; Fri, 20 Sep 2019 15:25:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Bork" <tom@eisfair.net>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.604781684@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 131/132] media: poseidon: Depend on PM_RUNTIME
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

From: Ben Hutchings <ben@decadent.org.uk>

This is a stable-only patch as the driver has been removed upstream.

Commit c2b71462d294 "USB: core: Fix bug caused by duplicate interface
PM usage counter" switched USB to using only the standard runtime PM
mechanism.  In my backport I changed poseidon to read the runtime PM
counter, but that means it now needs to depend on PM_RUNTIME.

Reported-by: Thomas Bork <tom@eisfair.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/media/usb/tlg2300/Kconfig
+++ b/drivers/media/usb/tlg2300/Kconfig
@@ -7,6 +7,7 @@ config VIDEO_TLG2300
 	select VIDEOBUF_VMALLOC
 	select SND_PCM
 	select VIDEOBUF_DVB
+	depends on PM_RUNTIME
 
 	---help---
 	  This is a video4linux driver for Telegent tlg2300 based TV cards.

