Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C663A37EEAC
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 01:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348047AbhELWEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 18:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390242AbhELVFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 17:05:20 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DB6C06138E;
        Wed, 12 May 2021 14:03:58 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id h4so35748776lfv.0;
        Wed, 12 May 2021 14:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IYCcqhA4jjPs/ANEIfCfO///pYaMA2YdDaIjqCycNn4=;
        b=O9VfHIuYU7eXbYs8Xx8Cy2cOa6L5uhV8BFh/ym4dLtFd8+ejjhr6FjUObFYjD5cbVG
         teyF9UNlPoD/sty318Xa566r1rKKE0T8XSz4zD9js7wZCq4vKPwX6D/xvl41YzAT4DbS
         wjsVZKDZYlxKKWSsPEpKOt0cSe4TYjkxl0Iuwh5Yd+sJUw2lT8X3cFfPTfcGB357ISRT
         YZcV8o40VpqoLSBRwMyBgaZDqhf2Cniul3s7pG0ENijf8y/oDKnQezL/VijNWpeDsi+g
         PUMSkXhrc6nBQzB2b5CzIobOHmAMN16Xdj59BsRNCHiE4PedDzD7ECqOxGpJJGA/T9XF
         eBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IYCcqhA4jjPs/ANEIfCfO///pYaMA2YdDaIjqCycNn4=;
        b=aZbwqMay4nmqjuy/ZQ8C4sImpoKDslmgJXOqyHN5eN4UgxnbWn0elMRKDuNL9u33o9
         9rm8txfDQMxJuw9GRMmMPToZ9Ez8ODvDbuxH9RcigmGxdv3ij/HY97SaTpOo1/wBiAmM
         QWZSf4ossimppdl0LzqHTkgxfgVwVvWu2QNWSrBtiSEYYwf07wEvllbHwj3a9YAtuTv8
         J762vezI0djCQDn4x1heZBxVScFrB0bMqJ9BfqKnSHAKgCjDTKfO7EXO4Rbq3mB2gvMF
         T8WkKDSf2HvjUoZ4B/Fq0bS/LXqEAuWLaXKv+fuKCYYfk4/O7+fTh7kO/vjIIAgxAV6v
         wq1w==
X-Gm-Message-State: AOAM533RRBjZxcJe+niG0l6nlJmKfPnupHbyI5lmhMlMiwEFjYRE6+wm
        UTj4uRqREqIB1EbHyyr4E80=
X-Google-Smtp-Source: ABdhPJzSmADJBLkBvSUbSMC7Y8hBJz476Fp0YVx1KR4TnQxnDvbd0iY4geDWfVhSr4ikUJbaaFscLg==
X-Received: by 2002:a05:6512:ba8:: with SMTP id b40mr25271323lfv.285.1620853437148;
        Wed, 12 May 2021 14:03:57 -0700 (PDT)
Received: from xws.localdomain ([37.58.58.229])
        by smtp.gmail.com with ESMTPSA id q27sm77183lfd.266.2021.05.12.14.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 14:03:56 -0700 (PDT)
From:   Maximilian Luz <luzmaximilian@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Sachi King <nakato@nakato.io>
Subject: [PATCH] pinctrl/amd: Add device HID for new AMD GPIO controller
Date:   Wed, 12 May 2021 23:03:16 +0200
Message-Id: <20210512210316.1982416-1-luzmaximilian@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add device HID AMDI0031 to the AMD GPIO controller driver match table.
This controller can be found on Microsoft Surface Laptop 4 devices and
seems similar enough that we can just copy the existing AMDI0030 entry.

Cc: <stable@vger.kernel.org> # 5.10+
Tested-by: Sachi King <nakato@nakato.io>
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
---
 drivers/pinctrl/pinctrl-amd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 2d4acf21117c..c5950a3b4e4c 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -991,6 +991,7 @@ static int amd_gpio_remove(struct platform_device *pdev)
 static const struct acpi_device_id amd_gpio_acpi_match[] = {
 	{ "AMD0030", 0 },
 	{ "AMDI0030", 0},
+	{ "AMDI0031", 0},
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, amd_gpio_acpi_match);
-- 
2.31.1

