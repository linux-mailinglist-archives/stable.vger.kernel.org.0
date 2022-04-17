Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C70350478B
	for <lists+stable@lfdr.de>; Sun, 17 Apr 2022 12:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbiDQKUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Apr 2022 06:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbiDQKUw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Apr 2022 06:20:52 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE2826102
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 03:18:17 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id b21so20372803lfb.5
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 03:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=z+v8ugHyK4Bi1bsAOtuex5rzJWIULuLfF++ZnJg6JJs=;
        b=DwODqr4TUbOJQSpkZJekGRmfBBzQs/STdpLc0XJSqZk21MhTESl4oLrVJ+ZS/h+9NB
         OIaH//U+xjsQ3TO5Igc+95qeuf8aI3q7SQMqIuts8s9FsFpBoQOfaZHECO3ODiwQ3c7t
         dPH6Nd3nJH3/4tneb2KkOFo9tG9PGYKpcp3FC0u+n3owgSvj+H9aA9c1b37jTP08xWNH
         003W+9Hv0euAo06SKyCnpanyf5BKg6skb6lPpUbC4VrXag0efwCReHcyI+Q6vxo+QOnC
         P5SQSGJodoKOxooUfnDNKa0Ja6rEk97BUrzngqCao3mfWMhJHmth70a4vzFtiSRdYrYN
         uxAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=z+v8ugHyK4Bi1bsAOtuex5rzJWIULuLfF++ZnJg6JJs=;
        b=EwqWuhp7ldiwLu6EmOoxlzvpdwqCrXqIDTkPxaicoTwvvIL1DgY2A3JNvQ0Ou5RU2j
         TI7pJy7ItyOLkOoQbdrzx++hdRmK/caLCueRevUNlWKd4CBj8nBohBxaA4/xdC6uS98e
         ft/cBKhcopAZsxZEtaY0d0jgmyO+R7S6sYip3/G/MAfwcyLOpcpSNv6PIHSpQhx5XGw+
         tcLElzgjHJQXBWReaXTFA32i055IpeupLZQxIjPbjxdc+A7N/n7RQkaxt5nJ1ZpxmD1e
         agnjTPgR33a65LfgENOHUHn8rY0YH1BK1AnA8WnA5tFuDs1NjL9k/sZSJT4f96+GHE/v
         Bbnw==
X-Gm-Message-State: AOAM533DdHxFmtEJlVW06mWYkrP9b8qkQrNEp06GDx2Qj4vfC3DgJXeZ
        F+cKcH03jwLt/+EItqBhjMbgiDgFl6bPXrIWBdQ=
X-Google-Smtp-Source: ABdhPJzAp/I+fUKgEOdKrHYkT9GhNGT1erJ0YZEWcVeUKTKGNId8isWRqp5YGDQvw6txRxECzzz/CuCjQvzDEhw6yrU=
X-Received: by 2002:a05:6512:3d09:b0:470:e0b0:cf70 with SMTP id
 d9-20020a0565123d0900b00470e0b0cf70mr3220030lfv.146.1650190695305; Sun, 17
 Apr 2022 03:18:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:730a:0:0:0:0:0 with HTTP; Sun, 17 Apr 2022 03:18:14
 -0700 (PDT)
Reply-To: markwillima00@gmail.com
From:   Mark <nnannacollins2019@gmail.com>
Date:   Sun, 17 Apr 2022 03:18:14 -0700
Message-ID: <CAPQqOC1E5z0Tk3Lx8voyb=0pMA3PH2Bd=ZcV5TWWMsMQjVYdGg@mail.gmail.com>
Subject: Re: Greetings!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:142 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [nnannacollins2019[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [markwillima00[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [nnannacollins2019[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

The HSBC Bank is a financial institution in United Kingdom. We
promotes long-term,sustainable and broad-based economic growth in
developing and emerging countries by providing financial support like
loans and investment to large, small and
medium-sized companies (SMEs) as well as fast-growing enterprises
which in turn helps to create secure and permanent jobs and reduce
poverty.

If you need fund to promotes your business, project(Project Funding),
Loan, planning, budgeting and expansion of your business(s) , do not
hesitate to indicate your interest as we are here to serve you better
by granting your request.


Thank you
Mr:Mark
