Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457392076BF
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404408AbgFXPHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404199AbgFXPHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:07:20 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F6AC061796
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:07:20 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j4so156720wrp.10
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ka6N3pIS5SMpHS3Dkd8MuBcyOJ38IwtNTJ67x9HE/gM=;
        b=Ff5473UIxYPsdW4pi6CB5QPFSge/HWs1GPIn1OasdcMvQPjvlEK+g8lSeufiA1UwKm
         H6KDcmB3IgwAsPz//203sr/5lItNIy2VU8gLEnAju1bDpqSAA+snoMXXBbUKVTtwRhw+
         iYvztLUTfNwIJqWObVgXcpCcC997bPMIODvu8fKaIJsBfDZOWCccn9tKIqHndpm41ykY
         Mq5NnAMV9jctWKT/2bpdtVs0PMXEScf5SNuIIaSmmhtv+vlqdMu/JvyKU4itIlO1CcGf
         tVbYtwzeO0StF89eiamELfZGSFWzF039y0cQjpkDunjzUqt5nyJcW9aNz0PxKD3gXnrL
         vAgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ka6N3pIS5SMpHS3Dkd8MuBcyOJ38IwtNTJ67x9HE/gM=;
        b=drfEJlYizXB7Z5ahGuBRlzaEefSPprf47B47suvBQc5ipI1mWqpXJ2XB9H20AiXdEl
         ShGsOM28r9Y81RmKhHFvEX5Y6rxFIhwkXu2fncpl+2fIc85Q8Tnjv9HaVccq+6Nxivx8
         G06eA7KWHDXGOmW6Vb17AmZKgKa7Ol62VMHGzbJ89D7sxv1vj+56NWiXJvm5hSHgRa7A
         IIaBLGdJCFTCAEAxf2XESfXny3KmRq2/bIsFQrltpJ41lBFmeon5m74wylJco4wwsP4W
         7eIAlTIgOKFPkDpCmFIUWWRFCuUbNcpPJ4/NsXvf2J1c1vgoyk64x5Sa6Xzqa1RILoEr
         4bQA==
X-Gm-Message-State: AOAM5339YHf9rdFhbNpn7PzvZ+bOeuIM3BV/DRZN4MPgYICPgRxR58cy
        Fel05A36YXsxMjae73QbvxAJ+l4+2qQ=
X-Google-Smtp-Source: ABdhPJzsQZaqGp6yo+Gvy/E7GwTgHGlfZMJUpo8UcdCxDQEq3FwvOrTnZtBe+XexIjSK/+7zMSJxFA==
X-Received: by 2002:a5d:6749:: with SMTP id l9mr31134388wrw.63.1593011239284;
        Wed, 24 Jun 2020 08:07:19 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id h14sm11543361wrt.36.2020.06.24.08.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:07:18 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 06/10] mfd: ab3100-core: Fix incompatible types in comparison expression warning
Date:   Wed, 24 Jun 2020 16:07:00 +0100
Message-Id: <20200624150704.2729736-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624150704.2729736-1-lee.jones@linaro.org>
References: <20200624150704.2729736-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Smatch reports:

 drivers/mfd/ab3100-core.c:501:20: error: incompatible types in comparison expression (different type sizes):
 drivers/mfd/ab3100-core.c:501:20:    unsigned int *
 drivers/mfd/ab3100-core.c:501:20:    unsigned long *
 drivers/mfd/ab8500-debugfs.c:1804:20: error: incompatible types in comparison expression (different type sizes):
 drivers/mfd/ab8500-debugfs.c:1804:20:    unsigned int *
 drivers/mfd/ab8500-debugfs.c:1804:20:    unsigned long *

Since the second min() argument can be less than 0 a signed
variable is required for assignment.  However, the non-sized
type size_t is passed in from the userspace handlers.  In order
to firstly compare, then assign the smallest value, we firstly
need to cast them both to the same as the receiving size_t typed
variable.

Cc: <stable@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab3100-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 57723f116bb58..ee71ae04b5e63 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -498,7 +498,7 @@ static ssize_t ab3100_get_set_reg(struct file *file,
 	int i = 0;
 
 	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf)-1));
+	buf_size = min((ssize_t)count, (ssize_t)(sizeof(buf)-1));
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 	buf[buf_size] = 0;
-- 
2.25.1

