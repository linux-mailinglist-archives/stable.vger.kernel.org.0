Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D9A5AF3B9
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 20:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiIFSgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 14:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiIFSgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 14:36:10 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E038034D
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:36:06 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-345753b152fso27982187b3.7
        for <stable@vger.kernel.org>; Tue, 06 Sep 2022 11:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date;
        bh=i0R53TAK8Pvv1dqj3X6sLp/mYhXJAf8bewUjnJrtogc=;
        b=oiA1uT/TkBmmqbTWbkabtss704rsOio/xfNZfZkhOW8PVou+H8Sv8ARoqgMaM+bH2c
         lsZWIaE+KwXDl4TaNk8A3Lp4MLSqKCjh7EspIfr2aukRK0hhUp8PA3GJp3LzzCNs6n5Y
         25F5Ee2zOh8ZUuD3dbNEj20UEMQO9BsEqIRTqlIWk7wh6i2HATLmFT9HW8nPRNdUq3Xu
         CkLUW2U9hBCCzIRQyFuO7a/KALCtcGG10BeaMiFp3NucRsG7fJyBBw7vg2kkjJMLuQrs
         M5HYZcOsqT5kk6KlIzWYt8jR8UiEyF8kYKHcxNQxfCHecs7htrEolEeoYl2YKgUx589X
         EQfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date;
        bh=i0R53TAK8Pvv1dqj3X6sLp/mYhXJAf8bewUjnJrtogc=;
        b=0gL2c8bM1Kc6NektXAJOZsDLaPFO3OUa5etex70sjp9oE7HA2aq+ZqSry2FporUd/h
         04VYKYX5PsVDo/ig+ZGm2aWCoGpvLcHRHkIcYuCg6a4VHY6oUEWMhB20mdxweu8H+upw
         acQPz5/6waKIAyOyWC+1jL8Wwzzi+B8dJFFPkPX+qp6R0Wu75zXfhVZFUpMtnfCPChfV
         NcY06X3YIc2wWwhg1TRnEAvL2+xOvtW+bJMqst1VlzEu5+loPLOaF+CjgZCQqCHU6x1Q
         tuwjs7hhG8q4GWzqpud3PFfSxPkbj3lis0mYVfhsSkTQ/Vrs72XODgNFG/hiEcDpg1pi
         vn4w==
X-Gm-Message-State: ACgBeo37shpZn/orDI03mfiiNyAkBemY16cxRfyiKKOi/dJa7u92i3/2
        v7lSbVebLWRCnbfL/AVK4u4uLylzzSHHupxI4g==
X-Google-Smtp-Source: AA6agR68wmtnyd+6tLLKnKjrQMkTdwVdgbm15czxZnqbkWTAuhNE9Qc+94GhH3giQsB+i4aE5T/pLqg/pkNM/mwcTw==
X-Received: from varshat.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:a35])
 (user=teratipally job=sendgmr) by 2002:a5b:84a:0:b0:67c:1db1:2069 with SMTP
 id v10-20020a5b084a000000b0067c1db12069mr35622834ybq.507.1662489365256; Tue,
 06 Sep 2022 11:36:05 -0700 (PDT)
Date:   Tue,  6 Sep 2022 18:35:59 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220906183600.1926315-1-teratipally@google.com>
Subject: Request to cherry-pick 01ea173e103edd5ec41acec65b9261b87e123fc2 to v5.10
From:   Varsha Teratipally <teratipally@google.com>
To:     Amir Goldstein <amir73il@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

Commit 01ea173e103edd5ec41acec65b9261b87e123fc2 (upstream: xfs: fix up
non-directory creation in SGID directories) fixes an issue where in xfs
sometimes, a local user could create files with an unitended group
permissions as an owner and execution where a directory is SGID and belongs=
 to a certain group and is writable by a user who is not a member of this g=
roup and seems like a good candidate for the v5.10 stable tree given that 5=
.10 is used in versions of debian, ubuntu.

This patch applies cleanly. Let me know what you think


