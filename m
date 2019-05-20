Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B64243A2
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 00:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfETWue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 18:50:34 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41206 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfETWud (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 18:50:33 -0400
Received: by mail-lj1-f193.google.com with SMTP id q16so3022983ljj.8;
        Mon, 20 May 2019 15:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JZGMHVwL/wB6dikUoQRPrzvmQgfUVtWFgGUr1uNGhMY=;
        b=V/jTJmvP07Eut0UjDTwqWaHV4gc4bHSZ082UD2by0Gzoe+KolR+nuoUpYIorvJlzQe
         pGmGfuD7U0kc7XwdiKMYILOW01+SYtvC3pqTWZEm7n54743m4hTycQtcbzJAaWnxwKVG
         gMLR5PjsZO5OWqx8/Zp6mnWGdK5ClN0DgIvkx/lMgLI9CF7+BcDg4N8fu9OWwutJaiac
         7sO5sTq1fPm9oIUOyVgqoJvXOGgQGEW9+gsuC8xmNV6rkMhikyK2QWa0g0C2QdOWmbvO
         hTY+6Zks1mv+LN7w/RFOQ0sx491kJiPuMvSddHrD9ZKsldyoeoxJVOnpzxL6PeAW6fGP
         LjmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JZGMHVwL/wB6dikUoQRPrzvmQgfUVtWFgGUr1uNGhMY=;
        b=YloQeav5qrfD6ApXF1ImfJBXLrfLgvNWzus/tuOHhOleIv9K2YPSydD2P7x/o/r1mq
         frZ0s4l3u//QTMvFDUwZJWfZFkD+2peA6qsLkw56NujdmaeVO6Xp27dGwDzpfM3ubZSq
         Sw8xRx6PR+wKfmsAn5GiqRSeNzmuCNytcreLrZR2qUNa4oqtootB+VmLiNvOkhROpK1v
         Tva2i9LUgxNPG3U+X00QSn+Dv1DR7nQxvvsY9mzAueV+BjoRHyQiAk1dWjoEp5mUM1as
         qwY6dWnu9RXQ6H+QNtg0gsltB1OpTUkF4svZ5+DK0vzTBVTI2boGxiDSrIFLQbRC+lqK
         1E5g==
X-Gm-Message-State: APjAAAVxXJ3aRiybMJyERfS9bnlflX+qKL0wxp8kdT//CP3hbsI12W6F
        YsgPxkNw2LSesiq4n240Th0=
X-Google-Smtp-Source: APXvYqzTQmiSzVMxBmZHErObRzwXMR88rpal8E+LmtTx/hZLsL4qRiLr1OnRrWvcK6Eac7zpqPG4xg==
X-Received: by 2002:a2e:a0d1:: with SMTP id f17mr1721582ljm.117.1558392631490;
        Mon, 20 May 2019 15:50:31 -0700 (PDT)
Received: from z50.gdansk-morena.vectranet.pl (109241207190.gdansk.vectranet.pl. [109.241.207.190])
        by smtp.gmail.com with ESMTPSA id t13sm2371646lji.47.2019.05.20.15.50.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 15:50:30 -0700 (PDT)
From:   Janusz Krzysztofik <jmkrzyszt@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/9] media: ov6650: Fix MODDULE_DESCRIPTION
Date:   Tue, 21 May 2019 00:49:59 +0200
Message-Id: <20190520225007.2308-2-jmkrzyszt@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520225007.2308-1-jmkrzyszt@gmail.com>
References: <20190520225007.2308-1-jmkrzyszt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 23a52386fabe ("media: ov6650: convert to standalone v4l2
subdevice") converted the driver from a soc_camera sensor to a
standalone V4L subdevice driver.  Unfortunately, module description was
not updated to reflect the change.  Fix it.

While being at it, update email address of the module author.

Fixes: 23a52386fabe ("media: ov6650: convert to standalone v4l2 subdevice")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
cc: stable@vger.kernel.org
---
 drivers/media/i2c/ov6650.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index 1b972e591b48..a3d00afcb0c8 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -1045,6 +1045,6 @@ static struct i2c_driver ov6650_i2c_driver = {
 
 module_i2c_driver(ov6650_i2c_driver);
 
-MODULE_DESCRIPTION("SoC Camera driver for OmniVision OV6650");
-MODULE_AUTHOR("Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>");
+MODULE_DESCRIPTION("V4L2 subdevice driver for OmniVision OV6650 camera sensor");
+MODULE_AUTHOR("Janusz Krzysztofik <jmkrzyszt@gmail.com");
 MODULE_LICENSE("GPL v2");
-- 
2.21.0

