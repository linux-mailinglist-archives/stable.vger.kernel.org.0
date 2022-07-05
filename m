Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2063C5665E6
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 11:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiGEJMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 05:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiGEJMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 05:12:05 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDC3397
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 02:12:05 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id r1so10463817plo.10
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 02:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=OhjfXndB/WqBIuXHn8PWeIaSaToUi/u4ar1H0SfnvNg=;
        b=TA+b0SWbp7dNR7zqfoHhpNKwTwyuwZIRq6+4ZBhY7rLdsv6ukioFlE4vGwr1JNUxdk
         7vC0liYzlJ6XWMOGMs6oBSYuGrFua+Go9DYEQ6HuWnpoLlHvy+IyG5fU7KZDkw5KFbsN
         Ly2O2Mbe2E+ueMj+j0YavOYVcubrnFhmUmdX5Q52VT3G/yxL8JXjlxmSqcUCR2QGi2kl
         USayi2GBh3fVo235QXbMVi0sxXwoVz323Nd5jNrxS70bsuokzvZZVxRyf9CUo+MggdMp
         5G0zw7Dcc16BJW6KAa5SoX0BF4t9WvUHpRSkwAtee91rAOd426t04lW0U9GrVmRnpYv5
         dIwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=OhjfXndB/WqBIuXHn8PWeIaSaToUi/u4ar1H0SfnvNg=;
        b=kkuG7CaqlhhQd6NO/s17LvDra9+T2CHDC7J9zRr+Ih2wRhzjPZt7Nn5iGQPKDoNB/g
         /QJfsi+S3diT1PX7FJ+o4GWOup4LPP2czBI4ZrQCWFPUggHwM1qKZOkqYFoPWHAcjjIO
         7D9DVSLBqLbAM9Ce31d5Hvpf+CzJk8kUhc4wTAHXTqygloN3w8N6/x0vgsn+z8P0yKjr
         lT6WGpiSeunpNWnqrYZM92fzwoymMcPawS98qOy/vY+z4V0OS6d6UoRbwvMcO/vs+0wv
         3X9FK9tJ7tAM45fxIqo0gKCU+0NsTLVcRwEDrhSIZ81+IzCzfQNnNHMxdSbYiTcSVKIR
         YhqQ==
X-Gm-Message-State: AJIora9bmbSDvDu3+QzwOEC5DtIq4FoX980bN9iUbdY6W18QXES1BmD9
        8zsO4FuTbfLvmsmUIzFz2iJg88HMfFgPOzjJwyM=
X-Google-Smtp-Source: AGRyM1twtjwNlaO3dl/2gGPeKB1ch+oNKFISoERLVwvUfb2LVC66a2OHtDmzWnRQKF9qHkxjSC580s24vwf+popAhJg=
X-Received: by 2002:a17:902:ec91:b0:16a:32fb:49c5 with SMTP id
 x17-20020a170902ec9100b0016a32fb49c5mr40830214plg.157.1657012324868; Tue, 05
 Jul 2022 02:12:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:440f:b0:2b3:3b97:a33b with HTTP; Tue, 5 Jul 2022
 02:12:04 -0700 (PDT)
Reply-To: lisahugh202@gmail.com
From:   Ms Lisa Hugh <lisa.hugh222@gmail.com>
Date:   Tue, 5 Jul 2022 03:12:04 -0600
Message-ID: <CANubVJra-DR2_cFR=iZr5MU+EVbXpdYRuQmZHK1oL_vKHPdtfw@mail.gmail.com>
Subject: REPLY FOR DETAILS.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:62d listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4769]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [lisahugh202[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [lisa.hugh222[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [lisa.hugh222[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings.

I have a something important to tell you for your benefit,Reply back
to my email to have the details,
Thanks for your time and  Attention,

Ms Lisa Hugh
