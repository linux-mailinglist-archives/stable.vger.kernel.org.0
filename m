Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840936C5E57
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 06:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjCWFDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 01:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCWFDf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 01:03:35 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81739C651
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 22:03:33 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id p1-20020a631e41000000b0050bdffd4995so5461348pgm.16
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 22:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679547813;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Aubntc6H3pvgz0bCmKGPax9xoh48RfITQh8Dav3SYKg=;
        b=cid9WB+jO0h/aEJJDjNPbSrQV1Z4uEsZwO17Vl13xKFpUPn6P2A0C7DoYvEf3jXwDa
         vC66zKmq3NAqKBlAgWbOWe/7zq02v9Dxqd0fcnR0+y4IdENr9NLR/6+gKmTJYJIKfwPQ
         rPgIPnwXc+EFxvaTd1nB+h/5ggvgmSjav4ZQHf5ylZutb7jy1ck6RYjfmxmMgIS3/XoZ
         JquLplWWimzzCRO0sZw7DBfz0p/EftKdB+SYThW1x3Nv1mNjCxOpbvFq44eGNk2Bco36
         jyE5JBIA532YOJEu3izOLv9u3wxKJLaUk9B0CST9bc54hfuFArEx81px6QCicfLT/3Rj
         V74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679547813;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Aubntc6H3pvgz0bCmKGPax9xoh48RfITQh8Dav3SYKg=;
        b=Av+8dadt0bMtwdJrHFVGzJdTE1aRXU14Q7XuLyMIhxstSE7ewrYNfLB8+FU4UdZg4z
         u+bBU1cJas4aT7jL5fclUdAHl1ZjEfyAjIs3C0+4ynZo/Ng33VmsgFhQ9zl0KTEoAUzW
         X0ifKbw3sVoeoiqpD4OLbLvkYzHm97Abxr3BdbWCcw/hoxthdRBZZbh4OLKFsyyuEcgA
         mWnpi9rLZ1LSXynHMq90erBXAPjw84YodsKlIRSuDlqpJHJo0SNH1pfsH2Wm8FQzxn4J
         O/RMt9JXFXUlENN9yrAUnIIWS6NDHF4m9R8ABn2F6gWY8eiEbQQDJtdofMqugHzBrwaC
         FqHA==
X-Gm-Message-State: AO0yUKUKLY+UebBecjHq0HviyAUngmXYbuh7kWASBhoCa2QDVO+6xc/P
        K37vp3OFKPzYn5djRunY0tCS3MtHoC/A7QjjzgD5WyJP3P8oxcI3jEoiWTrFxYM1pIgCRE4a1Sv
        DzBRt/Qm0KmRRbV5f2dytyi4KeEoQgSKBwVly6mDw33QNgAxqyNGlykNToSuO2N3YgKhzMGHxCT
        dYSa91ZEM=
X-Google-Smtp-Source: AK7set8MlzLtxmpOsMFuWj6WC90TqkecuzWpzf9bDe0i2MuJteGxStCZi09SDEFnwq9DxioxsS+ty1B7ZrV4pozyQ7l07A==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a65:6457:0:b0:50f:a9e4:e09 with
 SMTP id s23-20020a656457000000b0050fa9e40e09mr1455872pgv.4.1679547812964;
 Wed, 22 Mar 2023 22:03:32 -0700 (PDT)
Date:   Thu, 23 Mar 2023 05:03:21 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230323050323.634232-1-meenashanmugam@google.com>
Subject: [PATCH 5.10 0/1] Request to cherry-pick 49c47cc21b5b to 5.10.y
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, hbh25y@gmail.com,
        Meena Shanmugam <meenashanmugam@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit 49c47cc21b5b (net: tls: fix possible race condition between
do_tls_getsockopt_conf() and do_tls_setsockopt_conf()) fixes race
condition and use after free. This patch didn't apply cleanly in 5.10
kernel due to the added cipher_types in do_tls_getsockopt_conf function.

Hangyu Hua (1):
  net: tls: fix possible race condition between do_tls_getsockopt_conf()
    and do_tls_setsockopt_conf()

 net/tls/tls_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.40.0.348.gf938b09366-goog

