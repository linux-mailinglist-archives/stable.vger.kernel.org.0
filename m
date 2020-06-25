Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A525209A06
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 08:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390290AbgFYGq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 02:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390175AbgFYGqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 02:46:36 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8ABC0613ED
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:36 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u26so5992183wmn.1
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZzLtCVZ0xnD69Tq7rrN3k4RXzAsRLvX+l/b23e7w5no=;
        b=BoR0BVfFhS9za/tBEuj3YkwiY8nNI24M8p9fmhuCM6IiYJIEKM/q4XFtIYaAjPe2Dk
         +nz7AdEJTpAE6Z+mq1fY/goiHr+ULfYi+dRbajh5fVCoRPVr0Q+zoCiJpLRmGQXpi0nF
         hp5QBIuI6XCJpSCjUX0V3zfIn+ZbWxvJgbgmtqBW+2vkICODU7hu8BBVpkSerVZbYksH
         3F+0fRc9wCbqjlgJjwvTx76agAqHN5CXzt9RhogHKW0HMD0Hsdt+C+QgFL5edj3pUqh/
         qEeWE5X1U9a0rI6T84EX3KqVH/ST5X+6bwNw57W9gxqGVfLBP9icFRkYY03DiWqvKjBD
         zDhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZzLtCVZ0xnD69Tq7rrN3k4RXzAsRLvX+l/b23e7w5no=;
        b=tFdCLZWC15Ez36Zh07Ex2LqkEOego4s0CwHsdUWzQOWDOFQAp4ZgvziiuldqAlkha0
         7m2L6pAFUf73089B5HkjrM8jXpd55Km+z3gCQEAMmCItpS2EQpE+wuOjm+vQ4Q2zqovX
         9BN2DNXXjF/ZBPu78kOkU6+TgZB4eA8cMj6pn4IKhf+JZhxcdKz/p1YEQfyP256yF+jG
         ud7Xktd9V4LsfPYIWlttSog6ZqhMxY5DgzzO9i2unPE1YW+iHhzW4eR2AlC76tig5Cks
         4ud3muNyPQ4YWUgN04rd1fWYOduQuo9QYWXJRHAGnQgCK4wj2APSGlBjhpvuDBHypLgR
         tSXg==
X-Gm-Message-State: AOAM533fC8OC5FGvz+AFt6K7fpnSVRCNsWdlotsoUj6Y2UJC78ZXBS+E
        lhbJfel9eLWNR9ihqKh0w2TcJg==
X-Google-Smtp-Source: ABdhPJwbgPCP3KuminY9vt8AVhB+YH09uHBBW5EhL/706W7PsYH5XWdLmpQqngWOkPmCwNX2J/EVng==
X-Received: by 2002:a1c:de07:: with SMTP id v7mr1737470wmg.56.1593067595221;
        Wed, 24 Jun 2020 23:46:35 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id c20sm27235363wrb.65.2020.06.24.23.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 23:46:34 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 08/10] mfd: atmel-smc: Silence comparison of unsigned expression < 0 is always false warning (W=1)
Date:   Thu, 25 Jun 2020 07:46:17 +0100
Message-Id: <20200625064619.2775707-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200625064619.2775707-1-lee.jones@linaro.org>
References: <20200625064619.2775707-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

GENMASK and it's callees conduct checking to ensure the passed
parameters are valid.  One of those checks is for '< 0'.  So if an
unsigned value is passed, in an invalid comparison takes place.

Judging from the current code, it looks as though 'unsigned int'
is the correct type to use, so simply cast these small values
with no chance of being false negative to signed int for
comparison/error checking purposes.

Squashes the following W=1 warnings:

 In file included from /home/lee/projects/linux/kernel/include/linux/bits.h:23,
 from /home/lee/projects/linux/kernel/include/linux/bitops.h:5,
 from /home/lee/projects/linux/kernel/include/linux/kernel.h:12,
 from /home/lee/projects/linux/kernel/include/linux/mfd/syscon/atmel-smc.h:14,
 from /home/lee/projects/linux/kernel/drivers/mfd/atmel-smc.c:11:
 /home/lee/projects/linux/kernel/drivers/mfd/atmel-smc.c: In function ‘atmel_smc_cs_encode_ncycles’:
 /home/lee/projects/linux/kernel/include/linux/bits.h:26:28: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
 26 | __builtin_constant_p((l) > (h)), (l) > (h), 0)))
 | ^
 /home/lee/projects/linux/kernel/include/linux/build_bug.h:16:62: note: in definition of macro ‘BUILD_BUG_ON_ZERO’
 16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
 | ^
 /home/lee/projects/linux/kernel/include/linux/bits.h:39:3: note: in expansion of macro ‘GENMASK_INPUT_CHECK’
 39 | (GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
 | ^~~~~~~~~~~~~~~~~~~
 /home/lee/projects/linux/kernel/drivers/mfd/atmel-smc.c:49:25: note: in expansion of macro ‘GENMASK’
 49 | unsigned int lsbmask = GENMASK(msbpos - 1, 0);
 | ^~~~~~~
 /home/lee/projects/linux/kernel/include/linux/bits.h:26:40: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
 26 | __builtin_constant_p((l) > (h)), (l) > (h), 0)))
 | ^
 /home/lee/projects/linux/kernel/include/linux/build_bug.h:16:62: note: in definition of macro ‘BUILD_BUG_ON_ZERO’
 16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
 | ^
 /home/lee/projects/linux/kernel/include/linux/bits.h:39:3: note: in expansion of macro ‘GENMASK_INPUT_CHECK’
 39 | (GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
 | ^~~~~~~~~~~~~~~~~~~

Cc: <stable@vger.kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/atmel-smc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/atmel-smc.c b/drivers/mfd/atmel-smc.c
index 1fa2ec950e7df..17bbe9d1fa740 100644
--- a/drivers/mfd/atmel-smc.c
+++ b/drivers/mfd/atmel-smc.c
@@ -46,8 +46,8 @@ static int atmel_smc_cs_encode_ncycles(unsigned int ncycles,
 				       unsigned int msbfactor,
 				       unsigned int *encodedval)
 {
-	unsigned int lsbmask = GENMASK(msbpos - 1, 0);
-	unsigned int msbmask = GENMASK(msbwidth - 1, 0);
+	unsigned int lsbmask = GENMASK((int)msbpos - 1, 0);
+	unsigned int msbmask = GENMASK((int)msbwidth - 1, 0);
 	unsigned int msb, lsb;
 	int ret = 0;
 
-- 
2.25.1

