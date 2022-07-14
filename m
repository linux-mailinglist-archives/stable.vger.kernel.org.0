Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74D75751D2
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 17:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240097AbiGNPby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 11:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiGNPbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 11:31:53 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28594E616
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 08:31:52 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id b11so4042474eju.10
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 08:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Gm7h5mP67Bv2Gaqq+A+Fxjv8gfVt0GtJbJAJjw2Fw/Y=;
        b=kF+nDFtaKjBY5DFh+ZpFRp8yPR/0iooaWDY6/vWW8mWyw3Q9ztsnISIw5WK5iCXwOJ
         dqNV/XWWF5CvNtjyx1XYoy9uYeSQJu6ZljTKq4Q2RpDJw7QKq5MyxQSLIP8wQk0/wQmu
         9OzMB8LX+sk0TlwgBVN8p7oL6sFsP0gPWMjbwtIy7q6yrmYg0uEPxmF/VEdk0wEAFWfm
         9MiZzop5wbhEYfkY1Sgzb7MbR9yERKqqs8wzXu+l8gkoy3AtjaSCEg7evEW+JpyMXChr
         MJmcQ1k+LBl/2VP6X3RJLl7E2R2KBIgAtqJ78IUDDB8dFb0U4klg//Yhy7VqsX9GzzYd
         kYXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=Gm7h5mP67Bv2Gaqq+A+Fxjv8gfVt0GtJbJAJjw2Fw/Y=;
        b=cMnDfxHR8aLnyKFeE0EwMZY7z5DaZ8tEKxqph3M7i7T9PgycfmmbybSXx/BX8G6fd3
         uxAC4R71Iw2jTzF1oeGKLAoog3zU5rncv+Zu7U7BKE6naDkSDezwxIVZwYf6zoTxtPFq
         Ngzd/tMShdcm/plXAOa4ISxc66YLxkhUG/OlE+gbsR49ydD4bPAzgFye11SHU+93AZmg
         jwnCfkP6jYkFrch8EmEsjShSn/fFA4DFG0UhDWFpmAkM4+KdTRwFBfGHNxeV4VFxmRg1
         MqOEOQNFZfnvPDGqniGvHTQZu1pLpCYP4k+bArmU78j+aTQ/K3SGtYXgTmJJDw2y9xbB
         dC0A==
X-Gm-Message-State: AJIora+g9BpNe+KjxkAqI/xPZ3dyo9HqxB0V8qcAvFHJnaYw8aZJq/8F
        RdaQ0daWjoNluaVfNldsiQSuVjc6NzPSY2mEVlo=
X-Google-Smtp-Source: AGRyM1scQfldBEcNuq8OJC7KuAKb2wG/022U1AAjEaWqOtiLLmBy0FeNNm3iz1/p35Rfr2skGGF7yTpiygKkxuN8mV0=
X-Received: by 2002:a17:906:7482:b0:722:edf9:e72f with SMTP id
 e2-20020a170906748200b00722edf9e72fmr9252059ejl.92.1657812711100; Thu, 14 Jul
 2022 08:31:51 -0700 (PDT)
MIME-Version: 1.0
Sender: micheallover32@gmail.com
Received: by 2002:a17:906:d7aa:b0:72b:7649:670c with HTTP; Thu, 14 Jul 2022
 08:31:50 -0700 (PDT)
From:   Alary Jean Claude <claudealaryjean@gmail.com>
Date:   Thu, 14 Jul 2022 15:31:50 +0000
X-Google-Sender-Auth: EnZ5FrJLQgWipEv4CT4TVNz5nPs
Message-ID: <CAMaa8as4JtMs=hDZ+tsSc0-hsoJ3aHnjD_4T0q2dceuUr75+Cw@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.5 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:62e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5332]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [micheallover32[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [micheallover32[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings,
  I am glad to know you, but God knows you better and he knows why he
has directed me to you at this point in time so do not be surprised at
all. My name is Mrs.Claude Jean Alary, a widow, i have been suffering
from ovarian cancer disease. At this moment i am about to end the race
like this because the illness has gotten to a very bad stage, without
any family members and no child. I hope that you will not expose or
betray this trust and confidence that I am about to entrust to you for
the mutual benefit of the orphans and the less privileged ones. I have
some funds I inherited from my late husband,the sum of ($12,000.000,
dollars.) deposited in the Bank.  Having known my present health
status, I decided to entrust this fund to you believing that you will
utilize it the way i am going to instruct herein.
Therefore I need you to assist me and reclaim this money and use it
for Charity works, for orphanages and giving justice and help to the
poor, needy and to promote the words of God and the effort that the
house of God will be maintained says The Lord." Jeremiah 22:15-16.=E2=80=9C
It will be my great pleasure to compensate you with 35 % percent of
the total money for your personal use, 5 % percent for any expenses
that may occur during the international transfer process while 60% of
the money will go to the charity project.
All I require from you is sincerity and the ability to complete God's
task without any failure. It will be my pleasure to see that the bank
has finally released and transferred the fund into your bank account
therein your country even before I die here in the hospital, because
of my present health status everything needs to be processed rapidly
as soon as possible. Please I am waiting for your immediate reply on
my email for further details of the transaction and execution of this
charitable project.
Best Regards.
Mrs.Claude Jean Alary.
