Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3361619011
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 06:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiKDFla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 01:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiKDFl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 01:41:29 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94A8275CD;
        Thu,  3 Nov 2022 22:41:28 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id k22so3615158pfd.3;
        Thu, 03 Nov 2022 22:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S9+wd/d26nPzxPMD3za/Xjqe3tTkigkq7OyKBI7dvzc=;
        b=pNnLMLpBzc+72sVwLQ4rebigm5zWOx4LYczRbHPQpI7CDybS5XeVsceGIwLeSpM7iT
         qikW5kfEFH0tn4B3m0b8GBR+xb64tfFFQN1sBE+4ZpNe5FrTozqrXThq5FeSgqctCGUV
         sEDRCq5byPTXSz/yigP8CyE+iM/G76pQ9LoveN4Aod8jUCYpqpCddm7oPxlT7HipBHsA
         9KL6bCRRbkZFLXEbagVgott+y+tlk5CIcRDsxFpxOFGUJjiwjvRyzLJjLcXZ0uPpc5nE
         mu20rOG63OERUuwa7Obmq+ZPzK2Td0Os0Q0BhxdusOoJ4ecigPbuXx7txImUyGbkrc6I
         8H2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S9+wd/d26nPzxPMD3za/Xjqe3tTkigkq7OyKBI7dvzc=;
        b=UTZEJIPHdhV+6FXCPXDqC1FtpvJQzsR4YlCTlQxq1+TqvuoAaJCzJIpZ85NMTg4jSx
         qvNqjzYYLEG/YNg1CNaYnCn92ZShEmCn8F1YB6ioXQwUhzw0MCUGFJ1b8elCroKxMuO+
         G3YGFZhMtH5BbFmwHmG9XqwFIJYnAZh5odfp+yjt8iem7f+RHOg1dWU8S+Xd/9iJIIZv
         Dv1FtYvrg0YAqXk8foMrGnFUQajlV2bGY63ubFsQcsig1NxkWjsPdh1Caqmtqq9Kc2A2
         NKMOp5F0lYV/Bx08RrJVXu0uWYxlvLftfmeatD+krOwzJ9JGz19DgTU2vSyJ4HAXAT5Q
         yeXw==
X-Gm-Message-State: ACrzQf005+rrUEhGcnFTsyrNPvnMPNBMZ6z91tzkgdBTlZqm1Y3pD21x
        p+HmbCNSm0Sd1Nk8+qv1P8U=
X-Google-Smtp-Source: AMsMyM5+xDjLH+Oq7iEZdYP59T9pKYUB8E3/RSYRSrK0qf1eCZuQMh+V6Dlt7ivSiulzcBS9lGdCpQ==
X-Received: by 2002:a05:6a00:1905:b0:566:2a02:e1a1 with SMTP id y5-20020a056a00190500b005662a02e1a1mr34370199pfi.1.1667540488374;
        Thu, 03 Nov 2022 22:41:28 -0700 (PDT)
Received: from localhost.localdomain ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id q15-20020aa7960f000000b0056bdc3f5b29sm1684043pfg.186.2022.11.03.22.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 22:41:27 -0700 (PDT)
From:   TGSP <tgsp002@gmail.com>
To:     rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz,
        huanglei@kylinos.cn
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiongxin <xiongxin@kylinos.cn>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] PM: hibernate: fix spelling mistake for annotation
Date:   Fri,  4 Nov 2022 13:41:18 +0800
Message-Id: <20221104054119.1946073-2-tgsp002@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104054119.1946073-1-tgsp002@gmail.com>
References: <20221104054119.1946073-1-tgsp002@gmail.com>
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

