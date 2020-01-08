Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED374134BBD
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbgAHTqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:46:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43798 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730472AbgAHTqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:05 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006p3-DX; Wed, 08 Jan 2020 19:45:59 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-007dnf-In; Wed, 08 Jan 2020 19:45:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Roman Kiryanov" <rkir@google.com>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>,
        "Christoffer Dall" <christoffer.dall@linaro.org>,
        "Peter Maydell" <peter.maydell@linaro.org>,
        "Arnd Bergmann" <arnd@arndb.de>
Date:   Wed, 08 Jan 2020 19:43:38 +0000
Message-ID: <lsq.1578512578.579572019@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 40/63] video: fbdev: Set pixclock = 0 in goldfishfb
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Dall <christoffer.dall@linaro.org>

commit ace6033ec5c356615eaa3582fb1946e9eaff6662 upstream.

User space Android code identifies pixclock == 0 as a sign for emulation
and will set the frame rate to 60 fps when reading this value, which is
the desired outcome.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Roman Kiryanov <rkir@google.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/fbdev/goldfishfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/goldfishfb.c
+++ b/drivers/video/fbdev/goldfishfb.c
@@ -234,7 +234,7 @@ static int goldfish_fb_probe(struct plat
 	fb->fb.var.activate	= FB_ACTIVATE_NOW;
 	fb->fb.var.height	= readl(fb->reg_base + FB_GET_PHYS_HEIGHT);
 	fb->fb.var.width	= readl(fb->reg_base + FB_GET_PHYS_WIDTH);
-	fb->fb.var.pixclock	= 10000;
+	fb->fb.var.pixclock	= 0;
 
 	fb->fb.var.red.offset = 11;
 	fb->fb.var.red.length = 5;

