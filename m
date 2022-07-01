Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F125633D5
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 14:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbiGAM6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 08:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235725AbiGAM6I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 08:58:08 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE48F63
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 05:58:07 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id jh14so2328548plb.1
        for <stable@vger.kernel.org>; Fri, 01 Jul 2022 05:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=UaR1NefD75n+13si808lphUXo4PHuRX3UDYDNilXuoM=;
        b=FNP4M7Ih8kG5qqPFpkjKnWYuptFR0N3iEq9L5ksTUAhoDHTN07hhphJkH7yy+n6RKs
         wXx4ziN90fw4xNiXQBG4io0LRlS17ioSRwNHVRvl19XVD9OOHDxNO/cA+f/BWyS9aMAE
         ZqEKvAVAuoh+X4RqW3fbUUtR2+NG9zPFLUnfR3MpLbZO4AFahAFaFZOLyH1w2HHiv3sS
         pN1eXPUOF1qOhD/KKEc28SzKTtbhzB5bL/l3WGOeKbMDw90dUqVByRtLzo5EgLEhP+ss
         /zVJu8TMCWhV7yu+x6ZG6wVvCnXKpyIOk1fZ3mtGkdR9HwwNy2IPsKz9wgzGCRB/kYXg
         cFqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=UaR1NefD75n+13si808lphUXo4PHuRX3UDYDNilXuoM=;
        b=Ewygcv7tDcseWDlNgdlYbonMeK3jIkYY+N65RChGBqxy+BCtJ1/nJjZl9gO3HGLQYW
         2CFttJ6vzFouBKpwx4Lt/YDhIy08K5RAxrGIzTAVab+XXwdRlX3lgQJLf/BSSkJa55QL
         ElMcWmvuwGeTEDwxKYADKbGuYkNEc2QgmyVd5FCVdK+rOpUebylUny3lBBk0KOI7AoZe
         orKVweMoPEeXGhu0P8wqOhu3+YxCKJKW3p/7Xgo3JvOLjk69U7LfqryLqRa/tUQNBv4H
         1t8BicI9uN+oe4AGYmM5P1GgKaks9s5JlqgNYgL7/QmbOzRGHsWRJNa31yPaonkHiLsY
         8BpQ==
X-Gm-Message-State: AJIora+LV7U/L8nCu9FS9dnc1aGDSvHgMJ2G5kdefjNXVKia+KIrT2hM
        qy80EWCn4wcKd09F6XkZ+0dCl0mdTY9zzpU8GnJXou6IF8M=
X-Google-Smtp-Source: AGRyM1vofxGQoT5c4KkG/mE6NbvEKLskI88vEnakhrcE4uwjUHnOpbtluhxgYMWrB5mZymLxFTX2FcK2gQ4ixTIz1dY=
X-Received: by 2002:a17:90b:4a86:b0:1ee:e43e:ba47 with SMTP id
 lp6-20020a17090b4a8600b001eee43eba47mr16206274pjb.241.1656680287167; Fri, 01
 Jul 2022 05:58:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:902:c951:b0:16a:408c:bf3c with HTTP; Fri, 1 Jul 2022
 05:58:06 -0700 (PDT)
Reply-To: christopher@groningenbank.com
From:   Christopher Wright <ps65513337@gmail.com>
Date:   Fri, 1 Jul 2022 14:58:06 +0200
Message-ID: <CA+sNj7=C1W62TCv0ATyAO3yFZp+Q3HA5rs5L_QjQFVZJeBwN_g@mail.gmail.com>
Subject: Re: Christopher Wright
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.4 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_HUNDRED,
        MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,T_SHARE_50_50,UNDISC_MONEY,
        XFER_LOTSA_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:635 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5427]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ps65513337[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ps65513337[at]gmail.com]
        *  0.1 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 T_SHARE_50_50 Share the money 50/50
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 XFER_LOTSA_MONEY Transfer a lot of money
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.5 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Hello, my name is Christopher Wright, Audit Accounting Officer of
Groningen Bank, Groningen, The Netherlands. I got your information
when I was searching for an oversea partner among other names, I ask
for your pardon if my approach is offensive as I never mean't to
invade your privacy through this means, and also i believe this is the
best and secured means I can pass my message across to you in a clear
terms. I have sent you this proposal before now; I do hope this will
get to you in good health.

As the Audit Accounting Officer of the bank, I have access to lots of
documents because I handle some of the bank's sensitive files. In the
course of the last year 2021 business report, I discovered that my
branch in which I am the Audit Accounting Officer made =E2=82=AC5.500.000.
(Five Million Five Hundred Thousand Euro) from some past government
contractors in which my head office is not aware of and will never be
aware of. I have placed this funds on what we call an escrow call
account with no beneficiary.

As an officer of this bank I cannot be directly connected to this
money, since i am still working with the bank. so my aim of contacting
you is to assist me receive this money in your bank account and get
50% of the total funds as commission. There are practically no risks
involved, it will be a bank-to-bank transfer, and all I need from you
is to stand claim as the Original depositor of these funds who made
the deposit with my branch so that my head office can order the
transfer to your designated bank account.

When the fund has been transferred into your bank account, I will come
to your country to share the fund. The fund will be shared 50% for me
and 50% for you.

I await your response.

Yours Faithfully,
Christopher Wright
Audit Accounting Officer
Groningen Bank
christopher@groningenbank.com
