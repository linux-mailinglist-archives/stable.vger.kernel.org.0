Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BAA616E11
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 20:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiKBTzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 15:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiKBTzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 15:55:17 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13E65FB3
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 12:55:16 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id x23-20020a634857000000b0043c700f6441so10061040pgk.21
        for <stable@vger.kernel.org>; Wed, 02 Nov 2022 12:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1UY8Q4MQxC7RbbGvnLG991F19VImThEl5oTvmjborkU=;
        b=fSCSAi9Xeu9UTof9d55OXLwbH+EXywm2Enl3r0OXWJ/GLLyQuooN3ohBSeIi/lmKyU
         leBOTNlhUNd2KUUMfWz2I6i8RTiJU3pRvjmYjjLxDBZijFoOo58PEZbFaXfuocNyay88
         CKAKV6/f2ZhtNCUm3mJ5fDf19ppM7wVGt7URnmjr/FVnS+hpGVSKIjyZXQ7fgkT6xfet
         nm1e0GI+6g5cftjR63JjERB0/gvNtCJH19PAuvjFT8Y9ZGZ+SKUYAVvSkQ3H2AixNofH
         seFKANxOh9x5VdWF13oyu/DA5RudxuJTE5mpkjFz/aSAz+fHCATN+JqpbdB46ZxSah0g
         5CfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1UY8Q4MQxC7RbbGvnLG991F19VImThEl5oTvmjborkU=;
        b=HJ8Tm7EyaufDxeQ8eS1j6YHzpI2csShn8zYwH+DesDMF4CXeBHOHoiiID8iAPbETUk
         /jyEI7d1DhmODwmDFNuP6SR00uXslZkoPYTf+PZonmpuk8YDeoMAbY1tPquhFGUOTIkv
         JZMSJXFzMzKqNCZKDL4g8FOrAV91llxK2+fxifbBJgV9S/peqyIyW03p5MAz1vk/SQEh
         7XYp5N7DOKIkha+Ygt1K/ROw9D8CH4Skqz2H41TdavtZXKRT21rQEQPyGSc9qog/c6tK
         Zghj0d9zUT9Zn6b5ox220M1d9d8avElgP25b6NvM0XJXOoTVXmRDB7NMdsUJBEEblz5T
         b9lQ==
X-Gm-Message-State: ACrzQf1fxlqiV14wep07mhwiI63dZZj48Yf/JtTT16V8eH2FaJjzGqJ4
        +jTVfuc4uy6VgOgzNWTHqMWzSLs2vCiyQwmbNwavsec04VArHi4FnkDJnXpGJcQULZPVbriXfVx
        z74t2OrrzDq5gTHd9c1zoC05uTWVRaDcKTDapjFzt+54dvt3gsa5a5NBswujSYGpNgtGkHqBgPq
        4IkN+/vTE=
X-Google-Smtp-Source: AMsMyM4/+X9B2HnAWGphiFbcRCyx5PmtE9R+JpqdLSihNRjgRwrfL6fgekngszB6gfBaXfkC4rRs+5c5Iu2G857k//2xQA==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a17:902:e750:b0:186:de24:bbe3 with
 SMTP id p16-20020a170902e75000b00186de24bbe3mr26004173plf.51.1667418916152;
 Wed, 02 Nov 2022 12:55:16 -0700 (PDT)
Date:   Wed,  2 Nov 2022 19:55:01 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102195502.844256-1-meenashanmugam@google.com>
Subject: [PATCH 5.4 0/1] Request to cherry-pick 3c52c6bb831f to 5.4.y
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, kuniyu@amazon.com,
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

The commit 3c52c6bb831f (tcp/udp: Fix memory leak in
ipv6_renew_options()) fixes a memory leak reported by syzbot. This seems
to be a good candidate for the stable trees. This patch didn't apply cleanly
in 5.4 kernel, since release_sock() calls are changed to
sockopt_release_sock() in the latest kernel versions.

Kuniyuki Iwashima (1):
  tcp/udp: Fix memory leak in ipv6_renew_options().

 net/ipv6/ipv6_sockglue.c | 7 +++++++
 1 file changed, 7 insertions(+)

-- 
2.38.1.273.g43a17bfeac-goog

