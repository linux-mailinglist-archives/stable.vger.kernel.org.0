Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752125B4AFA
	for <lists+stable@lfdr.de>; Sun, 11 Sep 2022 02:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiIKAbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 20:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiIKAa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 20:30:59 -0400
Received: from mail-oa1-x44.google.com (mail-oa1-x44.google.com [IPv6:2001:4860:4864:20::44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E2B32B82
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 17:30:56 -0700 (PDT)
Received: by mail-oa1-x44.google.com with SMTP id 586e51a60fabf-1278a61bd57so13946804fac.7
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 17:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date;
        bh=3rHWukX/982VVQshnDvvj6GQbQddSOFHJAD6q40l/44=;
        b=CkmJfxNjlb053wsRZZFD+Az9gIeF1I35EB1odkZZ5UrZrTPGJPFEdzThMkP/J+5X0V
         peaRQ8JDeYOp5IHemHoZ7Hrpai1VUtPLzXQyrQhWKZdwcJ/m7Jo7UBILg7CnyTF49YN6
         rXbyCYRvXHYow0zCMdbMdpfZ5zMu+YxR8G0pRU0QeXRZ19ghWbakithss4/h2DbrBr2L
         4OUqR4LSUj/E0AREJGrQwM9Orz+aS/mf/CwSlGbm1Yy6/LvC1dtKORqdh+KZKAae3AAb
         6tYGxq/SVuH0fzHzBLa8+BOKLLqE0dqyYUBpIAt4XQxXYwKs1sqFANW33rs6qj7qJQeh
         IlCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=3rHWukX/982VVQshnDvvj6GQbQddSOFHJAD6q40l/44=;
        b=4dv2ZkTavDomo0XZWKyi3hbqe0CD5b6PEf/KE+xjcvjhvhcqo+B2e5gpKoalapMPTJ
         sMMVq51WjJfgpQl88sx/NxPkYbPPSoCkr5iwim8K/hfxmEHfAHrv96hz9Txsr2NcWpI9
         JrrEor4ImqTjjkYMiLyz1qfLbj5ZG/wnHLCz2elx6bBnktTqGhRGzAZVhC0Bulwt0aS1
         aihzKEuIgdAhBDuz4MB9Rk44c4ZmeBqp/vKmCayPE57QmbZOo6XMVUthZ2TxAU62tDpF
         E7AGFjBN+jnHnkufnXVzVM//OdcG7XNS2u+rW0azMEGWYvcGrJe5fQmWFqiEX+lD4UK9
         gulA==
X-Gm-Message-State: ACgBeo3uCfYDH1RANJvXyA7cTJLgjwwwTGXuIAUsBGsVtvTWmH9LG/+u
        91p7VcmH3gfMuKPHsSesJQnoFh31AmCs9MoK6kY=
X-Google-Smtp-Source: AA6agR6PyBlulw3prNmqqwtCMkKG0MiJUyzM1xAzRgK6rJSBSHhkmVIHpCgRwNvb4pfA1UUBziraIi2E2Roq6JrSWos=
X-Received: by 2002:a05:6870:2184:b0:127:d00a:35e9 with SMTP id
 l4-20020a056870218400b00127d00a35e9mr8150750oae.54.1662856255626; Sat, 10 Sep
 2022 17:30:55 -0700 (PDT)
MIME-Version: 1.0
Sender: david.willams231@gmail.com
Received: by 2002:a05:6358:920c:b0:b1:a344:757b with HTTP; Sat, 10 Sep 2022
 17:30:55 -0700 (PDT)
From:   Juliette Morgan <juliettemorgan21@gmail.com>
Date:   Sun, 11 Sep 2022 02:30:55 +0200
X-Google-Sender-Auth: 3pSx0JfbydF8Q-0Bx-9ZsSt89sc
Message-ID: <CAJgkwtZ-PWcOaJNZ1ezLiNZ=YUistkp-UzPdZ6wOD2k41W3c1w@mail.gmail.com>
Subject: READ AND REPLY URGENT
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.4 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_99,BAYES_999,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:44 listed in]
        [list.dnswl.org]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [juliettemorgan21[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [david.willams231[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  0.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear God,s Select Good Day,

I apologized, If this mail find's you disturbing, It might not be the
best way to approach you as we have not met before, but due to the
urgency of my present situation i decided  to communicate this way, so
please pardon my manna, I am writing this mail to you with heavy tears
In my eyes and great sorrow in my heart, My Name is Mrs.Juliette
Morgan, and I am contacting you from my country Norway, I want to tell
you this because I don't have any other option than to tell you as I
was touched to open up to you,

I married to Mr.sami Morgan. Who worked with Norway embassy in Burkina
Faso for nine years before he died in the year 2020.We were married
for eleven years without a child He died after a brief illness that
lasted for only five days. Since his death I decided not to remarry,
When my late husband was alive he deposited the sum of =E2=82=AC 8.5 Millio=
n
Euro (Eight million, Five hundred thousand Euros) in a bank in
Ouagadougou the capital city of Burkina Faso in west Africa Presently
this money is still in bank. He made this money available for
exportation of Gold from Burkina Faso mining.

Recently, My Doctor told me that I would not last for the period of
seven months due to cancer problem. The one that disturbs me most is
my stroke sickness.Having known my condition I decided to hand you
over this money to take care of the less-privileged people, you will
utilize this money the way I am going to instruct herein.

I want you to take 30 Percent of the total money for your personal use
While 70% of the money will go to charity, people in the street and
helping the orphanage. I grew up as an Orphan and I don't have any
body as my family member, just to endeavour that the house of God is
maintained. Am doing this so that God will forgive my sins and accept
my soul because these sicknesses have suffered me so much.

As soon as I receive your reply I shall give you the contact of the
bank in Burkina Faso and I will also instruct the Bank Manager to
issue you an authority letter that will prove you the present
beneficiary of the money in the bank that is if you assure me that you
will act accordingly as I Stated herein.

Always reply to my alternative for security purposes

Hoping to receive your reply:
From Mrs.Juliette Morgan,
