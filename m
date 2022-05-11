Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625C0523D68
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 21:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346832AbiEKT3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 15:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346827AbiEKT3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 15:29:13 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272D9F136B
        for <stable@vger.kernel.org>; Wed, 11 May 2022 12:29:12 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id o22so2981523ljp.8
        for <stable@vger.kernel.org>; Wed, 11 May 2022 12:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=CZjU7e2a0fCf/XEsO8nJVQl+HPFT9L7SSPvqpdqz67U=;
        b=SJ2S4d/vFT4BPp63Uj76qBkTMdfsDNY/MrLf7Dh4d30ugBqDleXtyYGoz/FKcBdqhw
         XmLJdh5NjnWcK66UngRxNiGwYueq1+ETlrq4EdQT3mU+dcrz36ahUBvLXjERzT5IatgN
         cYP9XLGLuFHAtlXoh4wq0xOqKI0MYF9UwnMn6PRvLPZ9kQGjxIjbIkLjkP81o/IkVuxG
         UU6npwpjpQPeicg+yqJeVeCABsUimUPwG5YvGbasUQaQXMJIQP60LNd9lH+g8t8pwIdO
         MX/J2pvK9V8tjV6udeq9kT0+PiG8ijJ62oPPHul/Zd0WSR3Zc1YKC5fE0pU9WKhF4bw3
         9CQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=CZjU7e2a0fCf/XEsO8nJVQl+HPFT9L7SSPvqpdqz67U=;
        b=fAoeGHVZNY3lt9exRQ70zwzG1MJDGUAWmVpPuVesP/wNJobF3ZXIPGhszLxp+J+I/Z
         TdkXNa+NfXW/z/GacIoKosoDTwDtNm4xs3Bp5JWhJ2Se2YyhL+cVqYMw/8AbICBewkAe
         eivkS05ESRN/jqTEqQMXxz85BZ4Tel+TMOa4WG29FJ7ml52cp/WbOZ5jHuzj0L0hvyA4
         NbsRjZWLnsfDyhHR0xEtiic0r2ISxlI9T2LCVx1VYbh/GLuo5feufA2fxzlwbOFpz+4h
         5eCwl5y0GD5mp7i1S+POAp9ODcNzLQ2xkkxCCEmNS4pR/RsqkAxcXBisPmPS3tkyLwi8
         RphQ==
X-Gm-Message-State: AOAM531B+W50T6wGYK+Ai3YuhxKfZXywW3slRx3YVkKCm8GAwiGYjepe
        Usy0wc7SuAdV6uOMDNmMD5t8naDLORwFXWIb34k=
X-Google-Smtp-Source: ABdhPJxpDyCAaWtzZX/QmKUrHoAZZ6zyMa7Edkp6aQRYjdrf7DWUxdh6fi7We8CRlxP7S+ZYwgX53c2pTcUXRkJylQ8=
X-Received: by 2002:a2e:84d0:0:b0:24f:13ac:e5ed with SMTP id
 q16-20020a2e84d0000000b0024f13ace5edmr17699386ljh.175.1652297350535; Wed, 11
 May 2022 12:29:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a19:5f08:0:0:0:0:0 with HTTP; Wed, 11 May 2022 12:29:10
 -0700 (PDT)
Reply-To: abrahamamesse@outlook.com
From:   Abraham Amesse <georgemark351@gmail.com>
Date:   Wed, 11 May 2022 19:29:10 +0000
Message-ID: <CAN7n4TSWHX7_6o3xNfOhaL0pAfKML-CBmC6Un52GzjFsRyn8yQ@mail.gmail.com>
Subject: //////Good Dey
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:22c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4267]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [georgemark351[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [georgemark351[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I have very important information to give you, but first I must tell
with your confidence before reviewing it because it can cause my work,
so I need someone I can trust to I can check the secret
