Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFDB61754
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfGGTr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:47:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56810 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727443AbfGGTiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:00 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCyz-0006ct-W1; Sun, 07 Jul 2019 20:37:58 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCyz-0005WQ-0V; Sun, 07 Jul 2019 20:37:57 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
        "Jeremy Fertic" <jeremyfertic@gmail.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.759915938@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 001/129] staging: iio: adt7316: fix register and bit
 definitions
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Fertic <jeremyfertic@gmail.com>

commit 53a6f022b4fe8645468adaffca901dbf8c3c547e upstream.

Change two register addresses and one bit definition to match the
datasheet.

Note that there are many issues in this driver so I would
not suggest backporting these fixes to stable trees.

Signed-off-by: Jeremy Fertic <jeremyfertic@gmail.com>
Fixes: 35f6b6b86ede ("staging: iio: new ADT7316/7/8 and ADT7516/7/9 driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/iio/addac/adt7316.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/staging/iio/addac/adt7316.c
+++ b/drivers/staging/iio/addac/adt7316.c
@@ -59,8 +59,8 @@
 #define ADT7316_CONFIG1			0x18
 #define ADT7316_CONFIG2			0x19
 #define ADT7316_CONFIG3			0x1A
-#define ADT7316_LDAC_CONFIG		0x1B
-#define ADT7316_DAC_CONFIG		0x1C
+#define ADT7316_DAC_CONFIG		0x1B
+#define ADT7316_LDAC_CONFIG		0x1C
 #define ADT7316_INT_MASK1		0x1D
 #define ADT7316_INT_MASK2		0x1E
 #define ADT7316_IN_TEMP_OFFSET		0x1F
@@ -117,7 +117,7 @@
  */
 #define ADT7316_ADCLK_22_5		0x1
 #define ADT7316_DA_HIGH_RESOLUTION	0x2
-#define ADT7316_DA_EN_VIA_DAC_LDCA	0x4
+#define ADT7316_DA_EN_VIA_DAC_LDCA	0x8
 #define ADT7516_AIN_IN_VREF		0x10
 #define ADT7316_EN_IN_TEMP_PROP_DACA	0x20
 #define ADT7316_EN_EX_TEMP_PROP_DACB	0x40

