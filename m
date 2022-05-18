Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C0D52C292
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 20:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241422AbiERSkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 14:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241280AbiERSkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 14:40:18 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AEC20D4EE
        for <stable@vger.kernel.org>; Wed, 18 May 2022 11:40:15 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id g7-20020a655947000000b003c6bf87efdaso1538267pgu.14
        for <stable@vger.kernel.org>; Wed, 18 May 2022 11:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=f/comq+ddVDYT2RlD0vyOKDSOz2g9CoYNs4IMPWBYNk=;
        b=eszR7fNAx1yOwEylj87I6WF9X003QddFZ+XxmXc6ElPBpC/KYg/ja3f0JSeQDaPs39
         oyLYY3gl3maAL555NBQSjk5IsG7h/4VWMHwG3v5wWJ3RFpLgNMKuZLOgqYZeLGpzoZC/
         ubHALTafEWNfD8QehKq5jvLQFr7SkU6KF2naJcgp0hLvGfhjF5/0JM3xGro9XH4mI1G5
         RX5VVJFb1yVPytu0IAgc++n4/LAl8yN6V4YporNUdjIwvHwSoI2NHIknECZJao2HRP/O
         u3gVaF8JKduG/9cAsLnbdrOCKOAUALaakHUFD5XnNYwAK97M6tSVzLxTZOpss6Utxhtk
         074A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=f/comq+ddVDYT2RlD0vyOKDSOz2g9CoYNs4IMPWBYNk=;
        b=cTUAbmrcneNGKrZGScxVQZ4NKn38e45+/AQvDQ8sZvBxiHn+EFampu/z9qm8qd1Hfy
         UIpwoHCftlXLIho6UneN452J6Ic5yRajE0VevdmdLiiZOQsIHfBd2v17pwRILoLyrFve
         F/joEzxbnBZXaIjoxX3S2EIYDatFr4iVFTG6npyj9o/mC6VNLBu5yYBPF8E9ut+B/2VZ
         kC2EggnOMOAEK9ieFkzMBqXl0zAdZ7e5VZeq6G1f8AXA1GSAlhFPLz/eVbvp7v/L4RED
         voxLNxnpVR/WNEtE9dKN2d9nQ8Wz6KytwRo6/07fJaej16qOMwK5jnWlXZHSIfCc0wK6
         gYoQ==
X-Gm-Message-State: AOAM5338S1gXdJssRbYt+qBZSi+tP2mk5mJYfZHvQIojmLEFyRS5XUUy
        NgunrzugdSggQi3xwOKVz/CwBkqdB/suNhjsJGGUxy4QyGxaJ0xrCJVNp40fQocT3zMlZGnzgKX
        KIX++SPntHfBHXYtLRXPdd90V3OMLErySBSmod3WilfVUY21UkNv6VVQHZodSeKB/2jCGf7goLk
        4rQRBF048=
X-Google-Smtp-Source: ABdhPJySSPg+5fDl2dJ2BVjhlnk+tFSU0MnYU0IFG/54cUwZ+OzQAjxhPfDTmETGwDxop7Jt9AINWHqXxBrP/I9Tv2zcBQ==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a17:902:da91:b0:15e:b782:c60f with
 SMTP id j17-20020a170902da9100b0015eb782c60fmr972500plx.39.1652899215137;
 Wed, 18 May 2022 11:40:15 -0700 (PDT)
Date:   Wed, 18 May 2022 18:40:07 +0000
Message-Id: <20220518184011.789699-1-meenashanmugam@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 5.4 0/4] Request to cherry-pick f00432063db1 to 5.4.y
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, trond.myklebust@hammerspace.com,
        Meena Shanmugam <meenashanmugam@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit f00432063db1a0db484e85193eccc6845435b80e (SUNRPC:
Ensure we flush any closed sockets before xs_xprt_free()) upstream fixes
CVE-2022-28893, hence good candidate for stable trees.
The above commit depends on 3be232f11a3c (SUNRPC: Prevent immediate
close+reconnect)  and  89f42494f92f (SUNRPC: Don't call connect() more than
once on a TCP socket). Commit 3be232f11a3c depends on commit
e26d9972720e (SUNRPC: Clean up scheduling of autoclose).

Commits e26d9972720e, 3be232f11a3c apply cleanly on 5.4
kernel. commit 89f42494f92f and f00432063db1 didn't apply cleanly.
This patch series includes all the commits required for back porting
f00432063db1.


Trond Myklebust (4):
  SUNRPC: Clean up scheduling of autoclose
  SUNRPC: Prevent immediate close+reconnect
  SUNRPC: Don't call connect() more than once on a TCP socket
  SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()

 fs/file_table.c                 |  1 +
 include/linux/sunrpc/xprtsock.h |  1 +
 net/sunrpc/xprt.c               | 34 ++++++++++++++++---------------
 net/sunrpc/xprtsock.c           | 36 ++++++++++++++++++++++-----------
 4 files changed, 44 insertions(+), 28 deletions(-)

-- 
2.36.1.124.g0e6072fb45-goog

