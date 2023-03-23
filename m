Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820DA6C5ED5
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 06:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjCWFbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 01:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjCWFas (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 01:30:48 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9548D20A12
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 22:30:36 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id j7-20020a17090aeb0700b0023d19dfe884so416159pjz.4
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 22:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679549436;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Aubntc6H3pvgz0bCmKGPax9xoh48RfITQh8Dav3SYKg=;
        b=bYlxzfg8+VvSbOgJR2Qi7O9hxojIzfvQhcJnxKvefzmxR7BIEY4dODLSl3XCDuJd6O
         2qMXb39HU6xqBlwQMQJPJyQ5juXO0IvIiAN3Qta4/Z1ZNrySn+P1EwUJLbZlZwE50wRv
         mOa9qzbvRYsjsH5a6LcFz6S9eOFARcxaicY0QGdJtVyPJJsgk5sGzfHNLcZYYU3W9H1y
         nzX/9thx4rj3unZl97xZWSRY7qmyODAzhUG0Fn8NdGzbkTlWu719FAhCH9+CIuHX1tfw
         yXo7F4UzHebNepZZfr4yc74YB9arLvT2kpgyhxNdS2EMkQwHpsTyM3Tpa0d9TQ0XySX2
         uXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679549436;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Aubntc6H3pvgz0bCmKGPax9xoh48RfITQh8Dav3SYKg=;
        b=sktPYdJwfwlHhXGIjsdiDCdFNggtNcpj/9iO2GVQ2RbuR6ihwPmLWY+GYbzEnG34TU
         aEnDxuI+G/dQ2wu4Ws5VY2z1iWNqr3iDhlAqtcaTPeBPAq4wuGB4YvOPwC/R42McSYSk
         +sQmhbMOCYBa/ulNuFjVjk6Vstx1+s1PmyBsko777innCCI3ih9RCxyRiNybpP3mKODP
         5N3FfoVEOQBgkxqaumg6Q7o4PI5Qd95LUNYW4FyNxwcl/kbJzbejIe+++zm9cwVOyxTf
         +IvcOKA+v44V4Xib7VU4GE8iJhh7c5uve3k85SSatgm8y4UuYxnDlMVaqVvEpwvJgObV
         DYOg==
X-Gm-Message-State: AO0yUKXRv9IY2F6j50vB9QleoQ829V/oxVuXg3yqlAG+HU/SU2Lreo3k
        g0eDYJlaPCUV/OKdYOoCdz8hXHD+hP9eMIUFehOk/fW7+tuHtLO1Lzyx6fTO3pLQ0BU6ErvOXKy
        9UCQU5DPbJ5DMv8tmOl9RXgujvVVE7XkR+2Xo8yOkkHOFgXbHfgfeZy32jqeLgoo7bN8DrLmjGv
        qg+kKGrL4=
X-Google-Smtp-Source: AK7set9N3xctWEFuwnRhTUfbockJG6R8uV1XM9VqT5aPtcZZmeNeDnsXnBYkc2WOEoW/1upEInFJ05HU3Z7tq+ZjBvIJiA==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a65:52c5:0:b0:50c:cdc:e861 with
 SMTP id z5-20020a6552c5000000b0050c0cdce861mr1300277pgp.3.1679549436026; Wed,
 22 Mar 2023 22:30:36 -0700 (PDT)
Date:   Thu, 23 Mar 2023 05:30:31 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230323053032.720729-1-meenashanmugam@google.com>
Subject: [PATCH 5.4 0/1] Request to cherry-pick 49c47cc21b5b to 5.4.y
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

