Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22F961432D
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 03:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiKACYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 22:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKACYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 22:24:40 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C531DB
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 19:24:38 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r18so12242256pgr.12
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 19:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S9+wd/d26nPzxPMD3za/Xjqe3tTkigkq7OyKBI7dvzc=;
        b=LtUgwO31jv6dxBHEpz56CTCbEBXGym+HPwggwLoHBbxpy7rG86C9uHniOR668pvRnS
         bOyOuKwBLojNu5V02hk1aN0GkvQFz0bxKarLampj8x/GNzvaCDQO87QD+rVH9k3PuxLd
         httLCirmqvAWEq8APw5eKpV4irAgBwgF0/q1Oswdj0JfFBXz5El+Yjswq100BQQcpKcU
         UCaw67yoqTUgn2rH1VFnRW7yahTQTshJg8PeXproWkfEoI7HB6biRK5cH5uiTydJyA2w
         +rSQjl+25e3gfOXeIyBzBC4xIEaWCMBwg4+nJNs3y3b438g4+Z7gflKkHYkbJIteBreT
         NfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S9+wd/d26nPzxPMD3za/Xjqe3tTkigkq7OyKBI7dvzc=;
        b=JsXxEP1aK0Nh4g/SxuYt8SwxbtjiUhwgXdtjH9nK2xVjNKxoX5pZn5QLk8SGUqSE1M
         gQqFBE5uPHLqb4/p5cpnDYJCdE/yekMfFvp1gCk4PcRZtEuZk10XZitznQfcsSXqi7nV
         XdXGYFfoLUGVm1jjTGNhKakrnfCjPEmQh5fQ9ZSXbf2mI4WBjZs+RKdQwFu3nZ4y3SHU
         UnylFj0nZUT2BiJlzrkxVmgCM9LniK+Ftz4TS8aHYDB5AZl66fImWeysTfOIsB5RlwEQ
         ILnB2rxB9ArIlau48cpjHVh3KefxzIcQv6pIhg50LWfYvFFz2AY/75ndC9MROcVBWhwp
         iUBQ==
X-Gm-Message-State: ACrzQf39tXDZcrCQtCNW+QJcXW2CFv10aILmGe8KMIM7s5rEYWj5cKsA
        PhWDPiZgBQ0ivRZxLBVXe9x8r5xlAd87x5JKtbg=
X-Google-Smtp-Source: AMsMyM4wUPCfnfpTQ7N72Bbl1EQLVUX1QjV6gqjlQWEQSHa8zbzu2p42yBi+swto7xoDV1odqXqjaQ==
X-Received: by 2002:a63:5415:0:b0:439:e932:e025 with SMTP id i21-20020a635415000000b00439e932e025mr15154978pgb.63.1667269478337;
        Mon, 31 Oct 2022 19:24:38 -0700 (PDT)
Received: from localhost.localdomain ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id 129-20020a630387000000b0043a1c0a0ab1sm4849062pgd.83.2022.10.31.19.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 19:24:37 -0700 (PDT)
From:   TGSP <tgsp002@gmail.com>
To:     xiongxin@kylinos.cn
Cc:     stable@vger.kernel.org
Subject: [PATCH -next 1/2] PM: hibernate: fix spelling mistake for annotation
Date:   Tue,  1 Nov 2022 10:23:41 +0800
Message-Id: <20221101022342.1345980-2-tgsp002@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221101022342.1345980-1-tgsp002@gmail.com>
References: <20221101022342.1345980-1-tgsp002@gmail.com>
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

