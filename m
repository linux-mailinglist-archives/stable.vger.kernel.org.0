Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2905676433
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 07:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjAUGjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Jan 2023 01:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjAUGjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Jan 2023 01:39:32 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8203AB1
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 22:39:31 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id d62so9246411ybh.8
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 22:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9Lt7d8tKOpnghFUCeL4ZvrJ/wHXrklZjZ12mTYdnFQ4=;
        b=TGwqSgGZs+qV9kRBPSHL5HoZYwgHJFcD99zYdgmypVUZY7bMOqTi/ra/HyThSPEyae
         +pJVVKEK1ML66HybWa8gIyqXl1FHELr81oC9RvDtPDF2lmpxi+yDgPGxtYNzyEfY4/G3
         2ysP7G7yINIbheJz7cQHXAFXwbGRmLRMNgiKq4Rs4I3Jw7FFLcCil638IzN6ASJNxU+C
         K49Qn8845daHPw/Unoe9V6RkWLKxDrZrrHURKTyuSzzO8jDHbQ2jhF49nh0yDHKw0o3R
         ouKXaQ/CN5HkPWqXm3bVh881cFWGUGV7I6Nqbqwyt3iMCN4OWBE1lTedUUTildoxXeSn
         QZ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Lt7d8tKOpnghFUCeL4ZvrJ/wHXrklZjZ12mTYdnFQ4=;
        b=us0+RTeouVN2dq8fZ4OZhhOB+KjRt2KcWDWsTlh6pPoErKGsHSeGhugBEAt+38b70s
         66n2lC4y46gcTgIAHzNqO3qm9Tsj0xi0mIJdxi89p3f2Pznjuimjt7tXPY7UsNlX6p+L
         dAvY8ZtjmErKdY+lGHXe9RE8YeEjBlJLzRColh9LIwerTAWo1VfzVUZC2N7tWzm1Yb1Q
         Yl85AA5e1OEJtJ2ZmUCrJ1FtRr2UGHcrwMQ7Lby/xQ93CVuHFe/VTDWXBYIRcHmZ8b4T
         5MFKXo/f6SGkEJBDMWR7uxjCgJNmu2NtZ5y0A/KL0QVQQRNSuJ5Cpr8/NNuruNftkxPG
         KbfA==
X-Gm-Message-State: AFqh2kp/hKYI4BM8MorxjIDyruCJwOI6B4xq61EGSaSfzyb/nuB0DmvX
        XYsws/kBIWJRKxuo9CNkSh9MT6FMCsH5WtHVedA=
X-Google-Smtp-Source: AMrXdXszpVBIj0FUeLWRUY0CHxSmdSHvJesqcyDQUH/PeUPx7QMaftWNC6320fymRiEN0gwWCC/w8WA2wjdi7EwGBOE=
X-Received: by 2002:a25:aaca:0:b0:6f7:f225:d623 with SMTP id
 t68-20020a25aaca000000b006f7f225d623mr1961757ybi.169.1674283170972; Fri, 20
 Jan 2023 22:39:30 -0800 (PST)
MIME-Version: 1.0
Sender: mrs.umasinha66@gmail.com
Received: by 2002:a05:7010:438b:b0:325:16df:a4ae with HTTP; Fri, 20 Jan 2023
 22:39:30 -0800 (PST)
From:   Ibrahim Idewu <ibrahimidewu4@gmail.com>
Date:   Sat, 21 Jan 2023 07:39:30 +0100
X-Google-Sender-Auth: QNafKsWxWKjSDxNIVM7ei8Ahf0g
Message-ID: <CAH0-YCmD3icG3asazx8bg2PyMif1=ovF49Xua6unnFhMeRCyZA@mail.gmail.com>
Subject: URGENT RESPONSE
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.8 required=5.0 tests=ADVANCE_FEE_5_NEW_FRM_MNY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FILL_THIS_FORM,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,
        MILLION_USD,MONEY_FORM,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,T_FILL_THIS_FORM_LOAN,T_MONEY_PERCENT,
        UNDISC_MONEY,URG_BIZ autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b42 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5892]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrs.umasinha66[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrs.umasinha66[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  2.0 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  0.0 FILL_THIS_FORM Fill in a form with personal information
        *  0.0 T_FILL_THIS_FORM_LOAN Answer loan question(s)
        *  0.0 MONEY_FORM Lots of money if you fill out a form
        *  0.0 ADVANCE_FEE_5_NEW_FRM_MNY Advance Fee fraud form and lots of
        *      money
        *  2.9 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 MONEY_FRAUD_5 Lots of money and many fraud phrases
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I have a business proposal in the region of $19.3million USD for you to han=
dle
with me. I have the opportunity to transfer this abandoned fund to your ban=
k
account in your country which belongs to our dead client.

I am inviting you in this transaction where this money can be shared
between us at the ratio of 50/50% and help the needy around us don=E2=80=99=
t be
afraid of anything I am with you and will instruct you what you will do
to maintain this fund.

below is my information.

Full name...Mr.Ibrahim idewu

country.....Burkina faso

Occupation.....Banker

Age...55years

Telephone number...+22665604193

send me your own so we can proceed.

THANKS.

REPLY ME
