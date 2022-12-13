Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4198364BEE9
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 22:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237696AbiLMV4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 16:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237646AbiLMVzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 16:55:33 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C12C22508
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 13:53:45 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id k16-20020a635a50000000b0042986056df6so634244pgm.2
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 13:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f4sOvkOvE8RS0wJGc1OB2ntzBs1NswtvkA9PFIyUy8M=;
        b=ZPcklG86kPG9w7vjESP8rFazSxwOZPQ1HyhQKiTS1rwpb9zyvrK9J/mqhiZlStd9ZC
         wv3W9wL7t8YuJgrGRBWZMRkLBUuJIa/IHZ7NsJjMP6zkUx8KXGOd4jkbE//0h2y2Q0Yg
         49pgFV5npMWKHk857ilTyP8t8EZAfIVGAMVc8uKliTe5Xx2ri9oloqh31ol3zB/Djnwm
         fARqduGHO6ZNMtV9JnUzCLQ0qiXofHmGOkOMA5kJuJjZXQUW2C6bhj0oBQ4RMC6TZmhD
         oyw3WncpO8LBZc0MBAEgRw9F8AUGQBoK+cr6joUI7KDeiJpI1SzmnLlJh9F8znrl+pkt
         pCIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f4sOvkOvE8RS0wJGc1OB2ntzBs1NswtvkA9PFIyUy8M=;
        b=Y3hsu9SZm2nsFe0i3C+6jtXebHKPWDjmEZgbrfKNdK7uZp6+uU1j/RHNpUJ1PVS4Oh
         s+v78yf2smllw4aRBGd0oYCg6hk93Bc2rxegWTH3QN/0cz5AKoKhjrnX1KKwd/iHWPFs
         Y3kc+f0JNFKZTMkj/efdfiyovUpyKOnfO3Lk8sU2ueUj9Sz+caC80O/DcFPxBk2aJPSW
         vQkVojZl3gC/HcXvD4Z0GtwAzboEzNAu7Q6tX6ipNuQ3bTuSWzswo/uJkQJfnvZ3qw1Y
         iB4Wo0UJMpmrvrYxH3MlgQu8AqjfrcMtJrQI9Sy2Qw+e67JL2NP69d9veceXRcVdYhUD
         7+kQ==
X-Gm-Message-State: ANoB5pkci9L3fJOAXoI+D6JT0rzW+LbcmM9CJFBg9NdCmC3Df8+PnA0F
        EHj/lb+U0MsdaLWwCh8Pszle3k3rZkNOcy9oL5uWkwnv1PdER+0LG50FdDo7+b98/IvXvA8w8rP
        Gghuqr6kmdecXDF99mkrCTcmW8JLQcis27khO0Om/9hqDuQ4hFG7Mh4rmBZ2R+YFWVWgUaTGzhF
        lgJI5KqTk=
X-Google-Smtp-Source: AA0mqf7NVCz1NVhHx4Bf5oeqJhgGhGEvGMEthWHjzOtMK+Xh/Wf3bd4l0BpDUltKSkaO9giMK9KIrJj7Xhs7EVwb4hMHUw==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a62:3006:0:b0:554:7525:7acf with
 SMTP id w6-20020a623006000000b0055475257acfmr78767559pfw.44.1670968424711;
 Tue, 13 Dec 2022 13:53:44 -0800 (PST)
Date:   Tue, 13 Dec 2022 21:53:38 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213215339.3697182-1-meenashanmugam@google.com>
Subject: [PATCH 5.15 0/1] Request to cherry-pick 74e7e1efdad4 to 5.15.y
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, jgross@suse.com,
        Meena Shanmugam <meenashanmugam@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit 74e7e1efdad4 (xen/netback: don't call kfree_skb() with
interrupts disabled) fixes deadlock in Linux netback driver. This seems
to be a good candidate for the stable trees. This patch didn't apply
cleanly in 5.15 kernel due to difference in function prototypes in
drivers/net/xen-netback/common.h.

Juergen Gross (1):
  xen/netback: don't call kfree_skb() with interrupts disabled

 drivers/net/xen-netback/common.h    | 2 +-
 drivers/net/xen-netback/interface.c | 6 ++++--
 drivers/net/xen-netback/rx.c        | 8 +++++---
 3 files changed, 10 insertions(+), 6 deletions(-)

-- 
2.39.0.rc1.256.g54fd8350bd-goog

