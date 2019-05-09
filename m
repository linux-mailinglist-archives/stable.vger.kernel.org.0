Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D09818B57
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 16:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfEIONL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 10:13:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46932 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726687AbfEIONK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 10:13:10 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOjnI-000125-H0; Thu, 09 May 2019 15:13:08 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOjnI-0006M5-Bm; Thu, 09 May 2019 15:13:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Mark Brown" <broonie@linaro.org>,
        "Nick Krause" <xerofoiffy@gmail.com>
Date:   Thu, 09 May 2019 15:08:17 +0100
Message-ID: <lsq.1557410897.75263673@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 04/10] spi: omap-100k: Remove unused definitions
In-Reply-To: <lsq.1557410896.171359878@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.67-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Krause <xerofoiffy@gmail.com>

commit 9f5b8b4f56dd194fd33021810636879036d2acdd upstream.

Remove unused definition which cause the following warnings

drivers/spi/spi-omap-100k.c:73:0: warning: "WRITE" redefined [enabled by default]
include/linux/fs.h:193:0: note: this is the location of the previous definition
drivers/spi/spi-omap-100k.c:74:0: warning: "READ" redefined [enabled by default]
include/linux/fs.h:192:0: note: this is the location of the previous definition

Signed-off-by: Nick Krause <xerofoiffy@gmail.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/spi/spi-omap-100k.c | 4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -70,10 +70,6 @@
 #define SPI_STATUS_WE                   (1UL << 1)
 #define SPI_STATUS_RD                   (1UL << 0)
 
-#define WRITE 0
-#define READ  1
-
-
 /* use PIO for small transfers, avoiding DMA setup/teardown overhead and
  * cache operations; better heuristics consider wordsize and bitrate.
  */

