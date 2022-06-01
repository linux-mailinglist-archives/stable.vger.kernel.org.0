Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67DE53A4B6
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 14:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351027AbiFAMSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 08:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239470AbiFAMSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 08:18:52 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937B75002C
        for <stable@vger.kernel.org>; Wed,  1 Jun 2022 05:18:51 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id e11so1820925pfj.5
        for <stable@vger.kernel.org>; Wed, 01 Jun 2022 05:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=eE/RQgZbAsioeXGGDhy3YNOxe1f8/kg9fI5Pln+oa7c=;
        b=naVIOZhoHL+D7UXI6dkPHyvc67WVdpNkCZ5nG2u8AeTshlGKDmLaAOHSWp6BYDYhSg
         UGesuFjijTLBg90Nxs7Gg25ttiRc284x0GgQx+XrILTBd2AGApLq/gkYNOacs/IGmIlW
         EN9+qfn71z7VR3zuZs/7xXq/RZoho4KUkXCs0qDXo7kCIcVEmhU3oF2x49MProDRVL9M
         3iw2uVgGX4zosgyGqo4vqi6vTQ2GySoTJAlqwEgNcDZCT/ebObFj0eMZbO5dO74i5YxU
         cbe2s3hoOK6rwyfBbyLUqRoLfxa28NEyMuUVN2ZqLKZ26eLUygM6GN8sKNo2cGlIxNbY
         hCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=eE/RQgZbAsioeXGGDhy3YNOxe1f8/kg9fI5Pln+oa7c=;
        b=r8xAjBg48tJLUyH2qJmU785FqEyb0A72bGJRPWtFg3SJgdkDkh6eHGFRFF0zihGCmV
         qp2cZDJ9SlzLy9DtO4sfsRyIsQ8AEGGRrazpiWkfWczYNubaMO+dD2C3GKgi2dXl4ake
         pAUSZY30jkicL5KprhkMmN8jPKWUW6z8grLJ0dcsvDvvwYJsc174AFwoM/+IZ6qhv7PE
         r+aLJtvq3LcBldHE/D+IhUroQQkRqgZx637WxRJkRBDKmFMXvFmu6D+A8/DhhXdQ/cGB
         D8RoY5v9BNwriYgJlkQ1GFI9S/1UD99jIGWLnA4IMyRFBbSIh9+YJGd/2AQ6x7xLBT+p
         Oi3Q==
X-Gm-Message-State: AOAM532D7itfDYyuENy/VwVY2J85spY3xGikDAKW6lIs2bPYQahPI7wu
        J+G6djQB2kK16DTMKYmY2vN1gLr/bfdmtJqqlRA=
X-Google-Smtp-Source: ABdhPJzK40WgEk18oTcbEy1xwY1KngM6kvw3jjPweBJdYcSYxvkuyZ267hS35asJQ3jryyQoyAoxwGex9Ih6yBnBPrA=
X-Received: by 2002:a63:31d0:0:b0:3fc:5770:e779 with SMTP id
 x199-20020a6331d0000000b003fc5770e779mr7133757pgx.376.1654085931013; Wed, 01
 Jun 2022 05:18:51 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7022:6282:b0:40:5c05:c05a with HTTP; Wed, 1 Jun 2022
 05:18:50 -0700 (PDT)
Reply-To: pau1deedee@yandex.com
From:   Paul Deedee <deedeepaul21@gmail.com>
Date:   Wed, 1 Jun 2022 14:18:50 +0200
Message-ID: <CAL-_JaEUkmmLDbH9HYH+-z7rmyUSdinX-vt=LwRPeGgegF1J8g@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.6 required=5.0 tests=BAYES_60,DEAR_BENEFICIARY,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        LOTS_OF_MONEY,MONEY_FORM_SHORT,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:42e listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6126]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [deedeepaul21[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [deedeepaul21[at]gmail.com]
        *  0.0 DEAR_BENEFICIARY BODY: Dear Beneficiary:
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
        *  0.0 MONEY_FORM_SHORT Lots of money if you fill out a short form
        *  0.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear email beneficiary.......Your email has been selected for a donation.

This is to officially inform you that we have been having a meeting
for the past Months now which has already ended with Mr.Antonio
Guterres Secretary-General of United Nations, Mr. David R.Malpass the
World Bank President and,  Your ( e-mail address ) appeared among
those people to be compensated.

You have been compensated with the sum of ($750,000.00) by United
Nations and the World Bank Group because of this Coronavirus pandemic,
which has been terrorizing all over the world.

This money is to empower you to start a business, the payment will be
issued through ATM VISA  CARD and sent to you from our representative
Rev. David Wood, we need Your Full Name Home Address and Your Phone
Numbers.

Contact  Rev. David Wood with this email.id ( davidwood2019@yandex.com
) or you send your details to me. I will be the one to send your
details to him.

Thanks.
Tel:  1 513 452 4395.
Tatiana Valovaya Director-General of the United Nations Office.
CC:  Mr. David R.Malpass the World Bank President
