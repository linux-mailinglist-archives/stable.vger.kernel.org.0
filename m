Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867EE616DED
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 20:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiKBTnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 15:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiKBTnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 15:43:16 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E99C10D9
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 12:43:16 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id bt19-20020a17090af01300b00213c7cd1083so4729206pjb.8
        for <stable@vger.kernel.org>; Wed, 02 Nov 2022 12:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o5q1Fb1XdPsSc/kquxMZ65SpffKeM0PlLnPl0Vobqws=;
        b=Xe4FB6vJObzObc2Jc9ncFtsLMfa83ZWBzd7yLvy8Jh6OEQeIn2oUkhLbt6daywa3Hc
         jyxP1ZWhWtBNh8LoTIYoOiuM4+DepqB+dpTkhjlHxgSZe1ncan5h32MuKUaabs/K6S+K
         D5OppB5Y44K6BZ9luBQqTe3Z8oNxuLK6ul6281+Cm5VWuQJjh4QcBRbCZkP7F00lGA30
         RbsIFS/UHCkPrvAodeWJjKeygvlF189yA+eIa4zr0a4qsmYbpFSeAmZ2d3mO834YeWP6
         wZC1d6mA9JH3o8OIj//xnjrPVnbJKMhisxu+C4vQykBvecUWBu6Y0dqgSeMCteYTfIVZ
         6gEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o5q1Fb1XdPsSc/kquxMZ65SpffKeM0PlLnPl0Vobqws=;
        b=u7c/Ubt6vVvgc1qhIruGAPZllx2lhD+2dQkvC16fNvZ5I/0TjSFJKmNkFpUiqGQNb2
         4XQbaCaaGop/76xhSi3pLrju4j2jWHHhywQ6/GhpyUvFZGwdgY5EusBr3pCT07uBsj/V
         iNpAwH3V2Cwh736yrjyketJU8NFTrLBWS+Hpd2WhAJ+/jfpBcJCejZASAR3wThn82SzV
         RVnqclpHtO7vwa6xBGW1n2SizkKecq6oh0HswLvDV4aIWHC5XLrADEmygCZ4eqEZZKh4
         omayIGLlhIVGvRrPmZ8qp4Mf9DSlP0E+ktYggDYnH+ARk/fVZnOITd4EWEgmjA3qYnzN
         8xUg==
X-Gm-Message-State: ACrzQf0V5TWkgnecmUgZzWodvadV2ftI8+VypFngl541FCdSsFep+4VW
        QvJWt+T7mW9+L4oF56bVsmr+OEyi46Grc3ekjmyPmrQNmX5XMijP3GoilTQ5WK+zcy2IHZsu8bk
        oes+/zoffkMhYY6plKJJtyWg6mkvqjxrjb6bz519DAvHgJTcPyknmt0VCXLMUx/qLmSxojPvXOQ
        VkbzvPuMc=
X-Google-Smtp-Source: AMsMyM7Ryrr09LPapS0qAqqfXvctvlGxrMp8TGLjIryVmcfuYJ+YzXjFNFk8nZjQbH7zhV9qgplOWZGrHRgPZwufRsMRoA==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a17:902:d54c:b0:186:c092:97db with
 SMTP id z12-20020a170902d54c00b00186c09297dbmr26553733plf.28.1667418195679;
 Wed, 02 Nov 2022 12:43:15 -0700 (PDT)
Date:   Wed,  2 Nov 2022 19:43:12 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102194313.840129-1-meenashanmugam@google.com>
Subject: [PATCH 5.10 0/1] Request to cherry-pick 3c52c6bb831f to 5.10.y
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
in 5.10 kernel, since release_sock() calls are changed to
sockopt_release_sock() in the latest kernel versions.

Kuniyuki Iwashima (1):
  tcp/udp: Fix memory leak in ipv6_renew_options().

 net/ipv6/ipv6_sockglue.c | 7 +++++++
 1 file changed, 7 insertions(+)

-- 
2.38.1.273.g43a17bfeac-goog

