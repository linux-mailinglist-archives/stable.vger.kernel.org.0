Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81FF600382
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 23:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiJPVpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 17:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiJPVpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 17:45:11 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A21031EDA
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 14:45:09 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id m15so13518979edb.13
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 14:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a2u/dt0v6gBpMijPO731X1b0TykkrJM2L3vE/ZKIAAo=;
        b=H1gYMJPDa0pUpeRI6eq/RH7X2v1p8G4U18JSadTVk2nWL9K/n2Vsqhomx5leFCUs6Y
         7mti23goZa/U1y4YozmmcOREAtB/unyGQHLqeqZxufYyakKKrFi9aRw9r2uLWr1nga90
         7YZN/OL9q3Ac7siFPcQW2wcQY2cpXQXy6Ie45hWp1TrdGNWxgzE2cKmidO26aWAZdpHp
         WP3wlVSIvaMXs7JxPY+Bnxdss+ImYxxlq3AECoSqGGV8G5O70zagBk1qx2MqvPQ4lxOC
         NF2aqe4mrL49zQfdzOfk5HeoblCR6zQRWEG5vgQQPEnhtY0P+CCSl12uNlPPZZxoe1Rd
         nvsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a2u/dt0v6gBpMijPO731X1b0TykkrJM2L3vE/ZKIAAo=;
        b=Ll9QURtvvzwTj8kENlqPSzHWp50FfxZTycH1ef2m8SbHCtNtUrdAjak9LjZm4gz/LV
         7Mk9Vtm3C1NU478zFiUhfQMwqDu9JNsdN5lFeJ8w85fSV7jQi5l1p06YPpAylcJtUO5o
         n4rGqd8hVlU3sPEcccx3G47Apuioo18LJYawdj6Dg0u9Tmjxs8OrkufWBUgDvYvNwgBP
         C6mx1TC2jClo9BOwFR8nq/fBEu0eRXpgokPnC1nkkke394WHU8kNdoO7Y48mpw11bTT/
         qXvIi71Do1y6C9936BfZRasJCb5Y+GnfX2JOr9yNgtHXAYBsKeFYe8XkGunBGck4OfC3
         E6Jg==
X-Gm-Message-State: ACrzQf3lXjimyAQHfXWJYIVKwjNKHPMhgn2Wb3/XkN0B5Z0JBduzsWG6
        SK/eEDt9acARu0saUEfn2hYUVQVXWMM=
X-Google-Smtp-Source: AMsMyM788XEt+khcsgawum/0IRqrYvzrju9Tg9vUWxiHsOZ/IHMlSKugbJk7GBaeSUY3MmhbdHrPpg==
X-Received: by 2002:a05:6402:3454:b0:45c:a8b0:52d2 with SMTP id l20-20020a056402345400b0045ca8b052d2mr7783791edc.307.1665956707801;
        Sun, 16 Oct 2022 14:45:07 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090676c600b0078c47463277sm5177331ejn.96.2022.10.16.14.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 14:45:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 0/5] io_uring backports
Date:   Sun, 16 Oct 2022 22:42:53 +0100
Message-Id: <cover.1665954636.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

io_uring backports for stable 5.15

Pavel Begunkov (5):
  io_uring/af_unix: defer registered files gc to io_uring release
  io_uring: correct pinned_vm accounting
  io_uring/rw: fix short rw error handling
  io_uring/rw: fix error'ed retry return values
  io_uring/rw: fix unexpected link breakage

 fs/io_uring.c          | 40 ++++++++++++++++++++++++----------------
 include/linux/skbuff.h |  2 ++
 net/unix/garbage.c     | 20 ++++++++++++++++++++
 3 files changed, 46 insertions(+), 16 deletions(-)

-- 
2.38.0

