Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57C658D9D5
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 15:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244572AbiHINtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 09:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244282AbiHINtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 09:49:20 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B10E1A05B
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 06:49:19 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id a9so17040880lfm.12
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 06:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=TzY88Uye5os498Ay3xypvHJkoI6JF6bC3vyERXDz7hk=;
        b=NMxX1XnQ2YMiGc/+rrZ/nQoh0KPZ4jeqMn97aTSk/t+dQSOX7rDuJrMrKj5lk51rJz
         fkR7kBZTFQUCvqOuzZHmomtb54XkU2989fxjVdFp00t0a4/zSnnfghWP5ms5XbLBp0Vn
         LmxGjbWdHX7qtUeNPKubLt2DEV3Y44lIS/vTUNjh4QU156WMkwQuufriIvxFFjXRP2j8
         /sZI099zsFtplP8ovlkedSzot44322w7r7ZigLViWA3QDfGdBq+FIUtpMaPPHc/0wbEv
         Q4yM5dCIxeodmZFBBNxlM978/zcoLKskv6K8+xRX5c5Hxc8yFAi4yXbGhvkwolABX+Po
         /yOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=TzY88Uye5os498Ay3xypvHJkoI6JF6bC3vyERXDz7hk=;
        b=b6jMJPs0i9fXa9ZGdv0ZourpS+hS0tgS8KPtYWwnc4u6+ydtRHi4t7NRDpcp/o/RCA
         UCHhWGLgEPOYz7yozYMPGR/4Ubxoip8gRGiZksLSniZCm69Ari9HE2hLGTpj1GPCbzc+
         f7L2imFolBFe6s+RZf8HwykLIxcQs8zAQH1F1K4QTbmoNLCrY1CpDMEBfh/GMq2OnFzs
         NYpDYCNP6y6s04bAUMMVAbQexsFu0T7+Zd47ZHNz0PxkMWOfiVA9esOZ08L+rBvhsblD
         7D9hk/3mG412+l5wpfT5mDC/emMF0NNve42LD3kjK6rHqDiSXjvYpBJLhbo+Sm1iCNej
         zHXA==
X-Gm-Message-State: ACgBeo3AJeAwopJNGCLsSvzFu9yKuY0ZWM77Z4KGBqTLd++GSCD16qP4
        Yj8t0IgvfdjYEmMFe5sCLVEvUxClRX3+PmnJ1oE=
X-Google-Smtp-Source: AA6agR70PIsKZMhyJ1UTRunIqXc6TK8vLM6GO8zGtNpeiD9eZriX46B8S4lZyWSYxXfmhu4XATxOYYRssjDswb3JWGY=
X-Received: by 2002:a05:6512:6ca:b0:48c:ec57:762f with SMTP id
 u10-20020a05651206ca00b0048cec57762fmr3433411lff.139.1660052957208; Tue, 09
 Aug 2022 06:49:17 -0700 (PDT)
MIME-Version: 1.0
Sender: richardharrisonn30@gmail.com
Received: by 2002:a05:6512:e81:0:0:0:0 with HTTP; Tue, 9 Aug 2022 06:49:16
 -0700 (PDT)
From:   Sophia Erick <sdltdkggl3455@gmail.com>
Date:   Tue, 9 Aug 2022 15:49:16 +0200
X-Google-Sender-Auth: Y3YBACU3o9S6k9HIgHYSq6zZ8Fk
Message-ID: <CAPauVpuG=WeUJLEw2OXrByM0r01cDopeWxs=UrJyVtCKpoFTrg@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FROM_LOCAL_NOVOWEL,HK_RANDOM_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:12a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5009]
        *  1.0 HK_RANDOM_FROM From username looks random
        *  0.5 FROM_LOCAL_NOVOWEL From: localpart has series of non-vowel
        *      letters
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sdltdkggl3455[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [richardharrisonn30[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  3.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello ,

It is my pleasure to communicate with you, I know that this message
will be a surprise to you my name is Mrs. Sophia Erick, I am diagnosed
with ovarian cancer which my doctor have confirmed that I have only
some weeks to live so I have decided you handover the sum of($
11,000,000.00) in my account to you for help of the orphanage homes
and the needy once

Please   kindly reply me here as soon as possible to enable me give
you more information but before handing over my details to you please
assure me that you will only take 30%  of the money and share the rest
to the poor orphanage home and the needy once, thank you am waiting to
hear from you

Mrs Sophia Erick.
