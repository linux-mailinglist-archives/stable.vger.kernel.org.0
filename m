Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3F34CF198
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 07:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235470AbiCGGHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 01:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbiCGGHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 01:07:05 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED475F27D
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 22:06:11 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2dc28791ecbso137835397b3.4
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 22:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=7Im1JG6q3q15hqSa7NWQHVGGERLfnPf1iBbuaSTqgJQ=;
        b=WuuqZePnQCTYyW3vdlf8CE2U4f8fpBttgfXFoOCnA7Fl/9FkSGMg3D41XBFEMgGjzv
         Ty/XpCgaCNzHlHjd3eCcF6N+/YSR+T/Zp0ng38dbMtWAdqKkd+lYGXW+Y7MfCA1TV/m8
         +Cm+TY8HhY5qu8tmMnRowC2tFygclMbeI5y8QxyAJ4m2jAXpabrAlwJd5ehe8zjFYZNO
         tcwNk8Snsv3jembZByLJ6Xc4iNMBs2y43wxsEKWS2hl2bklxexVjYAkirRxNqTjz5DUe
         FshcjFuvWBjoYqRwebdwLEX3/v9CDVooCIHZXgeCOIYc+VAxnOJbRNxGy8RwKemdfuzp
         KVWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=7Im1JG6q3q15hqSa7NWQHVGGERLfnPf1iBbuaSTqgJQ=;
        b=RXPN7Bp207ZIdSaKRoxA0UYbVQViwnnJ7OF59RAJ/brFEB0PZIHUFQVz8tIQ7Fx6Pi
         jkNW2qwhMgbItb5iXZs0MzERxsU5jFFCuDhKM8jYsukcxhenB615zYHYZyH81W3rEo7E
         oUERW+hEZPNhVnMAcZFTxHosh4DiNKZ4/yfiwYP4T6hyTjUFHVMGo5N75DaAQZGrjoLT
         jIvWRbSVhKO3yvNYkZkpyP7sM/tQ655oH0oR2ZMOQOe0G1X/1CreZfA2Vbe8878yaGCH
         n7CWZUffiZZgZHib4Sbn26zCLQrZ3/yq6mIZpl/y4nM14qEM7/yqsKJC279s4sdrkaIM
         HMWg==
X-Gm-Message-State: AOAM533SoGD44oXHH93YJQrvvKa0fApuCUaVchr0PdUXblwrhT7Sj6k4
        dBUVe5029kLhoKH/rELmogwrWLkRuaE9nuki0dw=
X-Google-Smtp-Source: ABdhPJyLxikFIn3jXgVw+YYgX/loIs0xij5gGPaqfj+uWdInK6QT6cXmPQajXl+MuRLinyUfN432g+6vv3cxyx5RVrI=
X-Received: by 2002:a0d:da45:0:b0:2d0:bd53:b39 with SMTP id
 c66-20020a0dda45000000b002d0bd530b39mr7196673ywe.463.1646633170407; Sun, 06
 Mar 2022 22:06:10 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6918:b986:b0:a4:b698:78d9 with HTTP; Sun, 6 Mar 2022
 22:06:09 -0800 (PST)
Reply-To: markwillima00@gmail.com
From:   Mark <markpeterdavid@gmail.com>
Date:   Sun, 6 Mar 2022 22:06:09 -0800
Message-ID: <CAC_St2_SE7zwPDwxo2c1sYPkpyBkqPNSy0rtdi4BFYSnYi0wvw@mail.gmail.com>
Subject: Re: Greetings!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:112f listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [markwillima00[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [markpeterdavid[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
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
Good day,

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
