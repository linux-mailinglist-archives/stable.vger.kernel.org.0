Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A831668F5DE
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 18:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjBHRob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 12:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbjBHRoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 12:44:03 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43216564B9
        for <stable@vger.kernel.org>; Wed,  8 Feb 2023 09:42:36 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id q4so18313915ybu.7
        for <stable@vger.kernel.org>; Wed, 08 Feb 2023 09:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYBdSnATUWMl7OrRUexNOS9yLXpWnh++iwl+4xO2WaQ=;
        b=NyiHbqRW/fgihn5AOk5k9ppA8Cq5GHXhX1ds885i8obdMhf0yoYcCN+PlFosbY5K1t
         vo0tbWlvD9B6egiMeWY0bi7Jc6cCs6AmwD3hcH5zyyylqHh1ckqfvLOw+y/fIGw6gtlA
         Pe/DyaOgX3K/b2CMCPbWCKT7xHgNStC7OdN/yA6wbMwW2muYOImVBQTrDWAAre1c+lRX
         4iT9gznVtRaAz4p7Do2xulbxDiW2fgIARJtXap41yzsgvjhrbHON4/kaQMVHROW3HJX6
         kSebDmPtG64NoPCx9hvboOkYo+5RhjjimV7n/KL57DkB3EB/B8zvbBuLYkXMYTSseScd
         jPig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PYBdSnATUWMl7OrRUexNOS9yLXpWnh++iwl+4xO2WaQ=;
        b=vON0JpzzvxlBVN61CEdDpWeiExt2l+xfmiHuu9pyeXfNSNEx6ogbgWnYLxwpqgJJJX
         cxqJladtDC1lAMl34gpDRgK1QhoDvHeE4nYjfQ03HYpWpNqOQjzL1IxCwm2TF8e7mboz
         yDRuTfgB0rRjzr0CxXc4M+4qsIHHKXzYdbOOyBzyCf7x0J6KgOjGbBwpDnQQ2cyHub/h
         3AvI6B/ViX3GvvZXhr+0pMu98l6x6abwjZXmKAGToBBT8zgu5B8norc08w907oOy56r/
         vpGLPRufb6BenUyWuPq5jHtbVXkGaSbVYwYE3LblWXbctzUtVmJYpktogjdzXc8W9VfC
         wLqQ==
X-Gm-Message-State: AO0yUKUiUEO9QKKUlmKp3N/dpMdKfVZ9ogGE0wLioXl1YvP5oLqpDvV4
        Oa0NTTx5IIkq9Oikr1TL4GsFZG7PY/mw9Yyq6b8=
X-Google-Smtp-Source: AK7set9g1btprXCTsWrOm1m/T7W+NP4gBSJEtVa11gH87mu9AIPEBj+4YWMthzw0AN5VmiOgayBuRvve/3DJ/WsGfxA=
X-Received: by 2002:a25:557:0:b0:85d:a190:4de0 with SMTP id
 84-20020a250557000000b0085da1904de0mr851331ybf.447.1675878099302; Wed, 08 Feb
 2023 09:41:39 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7000:8587:b0:3b8:c255:de68 with HTTP; Wed, 8 Feb 2023
 09:41:38 -0800 (PST)
Reply-To: lassounadage563@gmail.com
From:   MS NADAGE LASSOU <hasjfhkfjasdg356@gmail.com>
Date:   Wed, 8 Feb 2023 18:41:38 +0100
Message-ID: <CAB+mkdQ62yHKWauTa-_S2SD7tFGEWV7+njmEwyosAoh3PUDmNA@mail.gmail.com>
Subject: YOUR URGENT ATTENTION
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,SUBJ_ATTENTION,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b41 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [hasjfhkfjasdg356[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [hasjfhkfjasdg356[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [lassounadage563[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.5 SUBJ_ATTENTION ATTENTION in Subject
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings.

I am Ms Nadage lassou,I have something important to tell before is too late
Thanks, i will send you the details once i hear from you.
Regards.
Ms Nadage Lassou
