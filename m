Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F138E5ECAE9
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 19:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiI0Rga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 13:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiI0Rg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 13:36:29 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB7F5F7D6
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 10:36:28 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id f12so3800434uam.7
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 10:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date;
        bh=3rHWukX/982VVQshnDvvj6GQbQddSOFHJAD6q40l/44=;
        b=U21o1tHS0oVhVhxMckc/9KMAgvEs/crHfG4PFv1pZkIAX8IGqm0v87snetTJRc6gqE
         wRDWjOEJvmXYhlSZR53tG+FkrTMXHs4NIe7/PkzHGwUc56UsawL0oFfZP8y/8SoxptFh
         PFrIPLQcDW1ssBQHPfMEnNnMy6caI8gTv22MGIU6SDBL3bU0LV/NARZj2FLfmhrQnYVn
         JdUG5w58hwcuDNxneOvCo+raitUAiTZW470/8nIx4TcukyKe7EJu0fzHDl2XWDrVy6VI
         mN5u+uqybfJ+UuWThmBEews97xLEmEuhttyLwHB9SKGtsCWb6g9aqstWACI5Vpc1+Gbn
         I+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=3rHWukX/982VVQshnDvvj6GQbQddSOFHJAD6q40l/44=;
        b=coaygOsLUhwxnuVNpN9Dtn8MvLO4OXqfs/4FjjwjBWQE7EwR9ebNT15iQledtbiNvK
         YL6L+57UniDIPA6eRmd5vOtkjgWO/tFJODf20VHnpQm4nzD9TP+wdfQuc/N6vWQlmll1
         IclvWGMf78cp6BwIskAAwmDf0KI+VM+WSPRZOsfVFDHlWrXcvnz+mQc+bkdt/DVBG9u9
         A7wPjwkgp8bFpCwa/Z08qoWPKhDQrZkgcty4Qh97AX6aAi8Ow02B1lJSraPlVqmMjF0X
         M+MdIU7WfXMkbQGnx0LYqPBKZEznAbtFAjk4Mnw0sHLiZKJblXoIsiKFhHnJCGEwsRX5
         qXEQ==
X-Gm-Message-State: ACrzQf2cxkTfq0kIiGL7G7nZdVwbSwXnY7lG6xRkLiNQsuqletI0gqsZ
        33w/aTBbrVYKme20MPE1bUpvqmPmexoXuY9MhXc=
X-Google-Smtp-Source: AMsMyM6WMYmiBqmqrD6b9EiS3bTQemXWk6DrSKWtLxNKHYLHmwbStGkvdHLIGaikehiVdRcKQ+0Ma3pzuCYohYXpZTU=
X-Received: by 2002:ab0:1c55:0:b0:3b6:3cbe:19ca with SMTP id
 o21-20020ab01c55000000b003b63cbe19camr12637941uaj.114.1664300187833; Tue, 27
 Sep 2022 10:36:27 -0700 (PDT)
MIME-Version: 1.0
Sender: ezeh.onwa.okanumee@gmail.com
Received: by 2002:a05:612c:1243:b0:2f5:f700:dff5 with HTTP; Tue, 27 Sep 2022
 10:36:27 -0700 (PDT)
From:   Juliet Morgan <juliettemorgan21@gmail.com>
Date:   Tue, 27 Sep 2022 19:36:27 +0200
X-Google-Sender-Auth: CAn0XkYAKoLc2L6kUtx2gXXvT34
Message-ID: <CABPUqVY-6tFBOz0gjD6QTWsbfM-iet9ERdbVT5Sy13s8_bfYDQ@mail.gmail.com>
Subject: READ AND REPLY URGENT
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.4 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_MONEY_PERCENT,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:942 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [juliettemorgan21[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
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
