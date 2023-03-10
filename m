Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5114D6B4DA0
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 17:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbjCJQv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 11:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbjCJQuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 11:50:37 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE28311F4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 08:47:52 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id e21so4721544oie.1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 08:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678466872;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RE5l1VpxCufAhFhvUtJmOdSBkyXi7tvoVHorDEIVEKk=;
        b=oWoDqohMRN6/T5RDoxArM6zaZFwxbm+UPooz0vDCVP1jf85j1ny8luUMCkwbw1U0G9
         n9gE8MghXCeXkovHaRlTjE+j32K01oFpepLUrZ3GkSPZgewKNT3/hRxW6YW6p3reDkmR
         gU8Mle/uknwNWzX1icGJlY6lc9TcrJYRlhScm8Cel8nSFX2gGkKBbHWfHud2knmYMdim
         2nDSYkh2nOBcUkOP740jal4Ve3Zb7C0lQfn55x4ThVZIQ7QTKWb9f3CM8ta/+M3ht/4u
         he8G7Ky/qwHZaVfCB78ZLoHLXqiiwTad3zFaTnCRY+qAYQXRMacAnsOy7OGEoiqz8Rju
         TLyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678466872;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RE5l1VpxCufAhFhvUtJmOdSBkyXi7tvoVHorDEIVEKk=;
        b=knvRMOe5ahMEHGMeIxsfqSI97q2uQMQ6igtnmyDqGCNszDvM5VK7V7ixKxyJVGrqXO
         mdxqG3jdEMNhpCcbEjlMxiGjXxqnQv/XANXcaWntD8s3je7I/QgjgO8X2MD+aLImCii5
         1oy8HqIhaOdmSgi9iRm4KXLoquFDF5AVycUfnA/MQSv1+bJi+/Ru/JTtq1H/DCd5fldF
         Ruav6FlgDUG6St/9F/2Pham0bT+8FpXzbR/SqsH/S8N5zZAQjeVLUWx3vhw+vPbBL7zZ
         urN4+2fQ+SnOMLuIlJi8NcmzMmD6MwI192NCa7Z9dA62gMJCFG1UzrvGahLIg8YaIcZR
         7isg==
X-Gm-Message-State: AO0yUKUrV0jsndwe67NynwFuXOid63KB7rVkreDNFo50QUnO3elPJyKM
        /ocm+FcsPZdMZV0zl1E4hvqSifyJESJuAWh8t7M=
X-Google-Smtp-Source: AK7set9afx2LL0F11CE5d/xezodymCLN7BZA0Lxvo8AlPJf6xvMwS0gl7iYfMjcsVUvxyfOZ5R0TSTQ6uvoNGHPROfQ=
X-Received: by 2002:aca:650b:0:b0:384:3e58:672a with SMTP id
 m11-20020aca650b000000b003843e58672amr8769546oim.10.1678466872170; Fri, 10
 Mar 2023 08:47:52 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6358:9ac3:b0:f6:b41a:8514 with HTTP; Fri, 10 Mar 2023
 08:47:51 -0800 (PST)
Reply-To: bintu37999@gmail.com
From:   Bintu Felicia <bimmtu@gmail.com>
Date:   Fri, 10 Mar 2023 16:47:51 +0000
Message-ID: <CAAF5RuwoacHHcoPRF8ySur1LDja0hEGHgkTjhVUiQFANaapPZA@mail.gmail.com>
Subject: HELLO,.....
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.7 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:243 listed in]
        [list.dnswl.org]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [bimmtu[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [bintu37999[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

How are you today? I hope you are fine. My name is Miss
Bintu Felicia . l am single looking for honest and nice
person whom i can partner with . I don't care about
your color, ethnicity, Status or Sex. Upon your reply to
this mail I will tell you more about myself and send you
more of my picture .I am sending you this beautiful mail,
with a wish for much happiness.

Warm regards,

Felicia Bintu
