Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA9B61426E
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 01:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiKAAwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 20:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKAAwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 20:52:36 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91ACA14D3E
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 17:52:35 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m11-20020a170902db0b00b00186d72ea4b8so9172817plx.23
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 17:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/bOk8Nw8q6yCV6bZoY0M/Z45IGR0Qe6dCEbbdHD0Bt4=;
        b=r6xjsdWi2D/1sA+9SnbqC64BheiJXnVJt+vtpPAaB5q53sToR1Tju/UEPuqDfkkyNG
         r7TvfXwuJfXKpcz7EEWW0AjqZsjgRd7LpM1XPJkeSSCWqh2ncpZ+CjssNMMmv3aeR2yP
         oEAiiDGudXKlmVBU/pFMJ/DeMPP8OryfPrLuBHDPlT7Wh4M78kULTFVAYw6KqG+QIe2Y
         pRI5EZGSDLJ9uoQozKxn0ws/lrOqQf8Iwjs44R/Z6arADAz1V5T7EIKH8uVfCBrT9L++
         U3hnu4H45usqEr6QZ57uUyAS0ighBRc84rMakROWDvFfXKv36MzVFW7IqSSBui0BxxcC
         3xQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/bOk8Nw8q6yCV6bZoY0M/Z45IGR0Qe6dCEbbdHD0Bt4=;
        b=erQagkkZbIucV89Sf5R7zTfPZWnztkojyNp9e0c1YLw8/U4MADLdx9MwstNSVbisxx
         DS41c7a7TJV8fQbL7jypeNLNjJ9ZC7LyhB4K4IkT3w7X/aFYqzbyZ5yPTfJ0ipLMUiSo
         BTinlPZsOPglBLq9bVBI+D4jAIWaJp18CInpfflUv7+UCEmfReY7vq/9nLYcjs/CQdnv
         H1o+Ujl17nMHrVvOoiJGCaV42lrBjhciFEmHv283vDliN/y5DZE35Oi/nbHBHKIp257S
         vrv4fdTZvCsr3SeUTtBObMNLBkJxe3Pguz1Ai6HwZfBgXRqHt0P3tvKXgFqIVgm8Dzyh
         hncA==
X-Gm-Message-State: ACrzQf34tjH2YyUkgDDC4wFrxgOcN42ruAoWg4Qfwngi6DeRYz3LRgRx
        CaTSg+YGM47sVoDJpBEVHHY+/3e8l5JmzOaSynaqiqXDw7E2aYbbVzAYpP0KcyzUW/OuB+8naf5
        8kLVf3sWmYNr2NGotE9UQF2wm5VFNvXW1htI5hFSzksCapjnpezPWYuT9s6kvKHDDkdVOdXkWrl
        +bSstzYz4=
X-Google-Smtp-Source: AMsMyM753dqZiFOMsAKK/dF1GqLkvGG3LDo1McF2vUiLdeGjBDDQTqgJB8r6M65TbvtYpFUgXVRh9UEy5XyLADYxeV+DGA==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a05:6a00:2987:b0:56c:636a:ac94 with
 SMTP id cj7-20020a056a00298700b0056c636aac94mr34942pfb.38.1667263954932; Mon,
 31 Oct 2022 17:52:34 -0700 (PDT)
Date:   Tue,  1 Nov 2022 00:52:01 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221101005202.50231-1-meenashanmugam@google.com>
Subject: [PATCH 5.15 0/1] Request to backport 3c52c6bb831f to 5.15.y
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
in 5.15 kernel, since release_sock() calls are changed to
sockopt_release_sock() in the latest kernel versions.

Kuniyuki Iwashima (1):
  tcp/udp: Fix memory leak in ipv6_renew_options().

 net/ipv6/ipv6_sockglue.c | 7 +++++++
 1 file changed, 7 insertions(+)

-- 
2.38.1.273.g43a17bfeac-goog

