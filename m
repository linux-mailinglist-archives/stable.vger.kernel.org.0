Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE4B614336
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 03:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiKAC2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 22:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiKAC2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 22:28:50 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723F317898;
        Mon, 31 Oct 2022 19:28:48 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so17583664pjc.3;
        Mon, 31 Oct 2022 19:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S9+wd/d26nPzxPMD3za/Xjqe3tTkigkq7OyKBI7dvzc=;
        b=CatEbRowU2ywt45dREKrkgA7CaFmvOdufAQ0prUMQblLdiEr+iKFatlv66jcBINXKt
         BApC7Xq10xrVvUJNyzzsYb6w7UYCDm2ZU0ICuFiPFNJPBCJEhs7jSZJMZf5E8fDvxhfn
         b/0TFgJlISYH/Kr/0JJ3sk9+ibPyMsgWoxKqBCcs/xMqGEcji1pxsNIT18YQGcJCQM9S
         uE4bHHtz6pUYZ9M9S9Y9n/j6NOuCxwkh7gnIFO2bGXnEc5MRBGK3IE6IbtEzFAWf/2Jj
         rVRvpfP6nbazaH5dSuFOdExlFpHQAlRezOlx6BviCcu5q9ogFYyKl2F1kGL5GZUYK2Is
         JsXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S9+wd/d26nPzxPMD3za/Xjqe3tTkigkq7OyKBI7dvzc=;
        b=QLsPe0pCkMYmQ68yQgK+vzDLzo/8D4dsKoFypv782Cyze/yNLqZ91c+/G58Sd8l+9G
         5ANMS0qnj0Zq3MDAYI4eZP5MwNO8eoQEM1bwLagln2BAViFRAyMa6PEYGIe/Dlifc7BL
         0WIRQV6+lJ+4Jo5/lnJaXm2APu2jt3oXklEN5Ajl/Ht6bzDfcJiR2EDu9ypve/c3nEWE
         tgKNWNdwpuUVFbaMGr51/HJ9uSBry3Pt9X1BcSxr3xKBadDDMNRxQjrOGGXlUioDApTB
         1iperZOyOJo6UdWggsoj1viXUcC7DXVLHvJT6BipVa+JTiw2gWY6OpI9VwjrIDy3ygf8
         wXhg==
X-Gm-Message-State: ACrzQf2pnW+tWXlqBfavPjnb8XKrfru4Z9hm+33CsCdPzSdsutJYizV7
        GHK6ZA+O7ES6HYylM4hk+zw=
X-Google-Smtp-Source: AMsMyM6nc4eVpjuycwaedY8rS0v2bmpXj5xPgGwZChT1lD2VzXnww3zHJpoSD/oS/IVo5d0JiSTF6Q==
X-Received: by 2002:a17:902:f686:b0:187:16a0:fd2b with SMTP id l6-20020a170902f68600b0018716a0fd2bmr11499574plg.91.1667269728041;
        Mon, 31 Oct 2022 19:28:48 -0700 (PDT)
Received: from localhost.localdomain ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id t5-20020a625f05000000b005385e2e86eesm5126925pfb.18.2022.10.31.19.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 19:28:47 -0700 (PDT)
From:   TGSP <tgsp002@gmail.com>
To:     rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz,
        huanglei@kylinos.cn
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiongxin <xiongxin@kylinos.cn>, stable@vger.kernel.org
Subject: [PATCH -next 1/2] PM: hibernate: fix spelling mistake for annotation
Date:   Tue,  1 Nov 2022 10:28:39 +0800
Message-Id: <20221101022840.1351163-2-tgsp002@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221101022840.1351163-1-tgsp002@gmail.com>
References: <20221101022840.1351163-1-tgsp002@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xiongxin <xiongxin@kylinos.cn>

The actual calculation formula in the code below is:

max_size = (count - (size + PAGES_FOR_IO)) / 2
	    - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE);

But function comments are written differently, the comment is wrong?

By the way, what exactly do the "/ 2" and "2 *" mean?

Cc: stable@vger.kernel.org
Signed-off-by: xiongxin <xiongxin@kylinos.cn>
---
 kernel/power/snapshot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 2a406753af90..c20ca5fb9adc 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1723,8 +1723,8 @@ static unsigned long minimum_image_size(unsigned long saveable)
  * /sys/power/reserved_size, respectively).  To make this happen, we compute the
  * total number of available page frames and allocate at least
  *
- * ([page frames total] + PAGES_FOR_IO + [metadata pages]) / 2
- *  + 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
+ * ([page frames total] - PAGES_FOR_IO - [metadata pages]) / 2
+ *  - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
  *
  * of them, which corresponds to the maximum size of a hibernation image.
  *
-- 
2.25.1

