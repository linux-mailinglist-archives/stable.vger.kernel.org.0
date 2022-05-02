Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29199516D58
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 11:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235746AbiEBJaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 05:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239143AbiEBJan (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 05:30:43 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB61A19B
        for <stable@vger.kernel.org>; Mon,  2 May 2022 02:27:14 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id w187so25065807ybe.2
        for <stable@vger.kernel.org>; Mon, 02 May 2022 02:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=ltdLotf7TOkPFkMNnpKMJjlXSXpBUKnlJRGRDLUcIj4=;
        b=qIPSHcfmYdMwTD6fVw5m1B9TJ3ZV3bipXZAoGQXOd/wOpbhXEOL1zPGptpewETWzwt
         N9IEcKAikZggznYWzPS0bNRivtkS3mMdR9Vpste8cUfyf1Dttuh4gep4PaxS5Qd5yD4E
         o5TZoI6g7HWnC/cr335o3Tzc2DcK7cSWFnCJ3Ag4bep7/r5P0lDXj8h+X1XEf8SvZnGp
         GAElIvGqfWUjDMFv5WUiLRMGuNo8T6WFYAJhzfhjQDmspmMWhGPz1xkpo0ZfUT7m+FG8
         L6yi1tE/BB/gVn0xf3bxU0V3+pF581zznF/W90HgfU2ubtLRhgCo76gltHg/HE0cMh5S
         Yb6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=ltdLotf7TOkPFkMNnpKMJjlXSXpBUKnlJRGRDLUcIj4=;
        b=ldbwUm2UB6VvM9In3XTHilIEFtm7vO4A/SC9GS0JwhWmbz/vqYOkBMl9DyGF0x4iVx
         VmIdKBbMTPOYsif1XbUjffIA0w2XiZVhrBeefwZjYtAJnakfzvtmNyL8UdWDOKokgVLl
         iuqnJjnnr3hAp2Qn4gbA2Z/xE0h/gEgJMrEh5xDK4EGXa5URLB+gNQl6wbBKEwlcVHF+
         Y+rj+SYrHjB+bk19FWkPY8ddFEdsPnljUUobLTAi6rcGfzcM+tV6KI70nyPErGWb24al
         plbF2pS/DfPvXMFwpDOmkHnlqnxtyX0K/n9+RaPhDpVEDUxGBTceZ5Ld82SOg2+VMum8
         LKmA==
X-Gm-Message-State: AOAM530xXaReu+vqaklQz3e2UyJSBZruYVa4rSJqS6XQrDVf+gTRsOAY
        yUy2QCMuWyWotXzcxVuBj+AotpE00R3qm6SWicw=
X-Google-Smtp-Source: ABdhPJxHzHbIUtlOnZPYpr+LAbnB1X5G1zqQJU2DhqFQuAP6NNEcEWmoQ9XhPwmgPlEzkurBviE2Ck0rE+maWSz9ZTw=
X-Received: by 2002:a25:ea49:0:b0:623:1f19:4cf7 with SMTP id
 o9-20020a25ea49000000b006231f194cf7mr9817024ybe.371.1651483633074; Mon, 02
 May 2022 02:27:13 -0700 (PDT)
MIME-Version: 1.0
Sender: ll1786535@gmail.com
Received: by 2002:a05:7010:7e29:b0:28b:2c2f:de13 with HTTP; Mon, 2 May 2022
 02:27:12 -0700 (PDT)
From:   Lila Lucas <lila69148@gmail.com>
Date:   Mon, 2 May 2022 11:27:12 +0200
X-Google-Sender-Auth: rzEwTUaW_zCO_3uTTHBIJT0Gkys
Message-ID: <CAG5cJ=wwk72LphSUWijKNUH9fBtT45fY0yAXdO5+j-bsukBcPQ@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.6 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b34 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ll1786535[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ll1786535[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  1.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear

I am glad to know you, but God knows you better and he knows why he
has directed me to you at this point in time so do not be surprised at
all. My name is Mrs.Lila Lucas, a widow, i have been suffering from
ovarian cancer disease. At this moment i am about to end the race like
this because the illness has gotten to a very bad stage, without any
family members and no child. I hope that you will not expose or betray
this trust and confidence that I am about to entrust to you for the
mutual benefit of the orphans and the less privileged ones. I have
some funds I inherited from my late husband,the sum of ($11.000.000
Eleven million dollars.) deposited in the Bank. Having known my
present health status, I decided to entrust this fund to you believing
that you will utilize it the way i am going to instruct
herein.Therefore I need you to assist me and reclaim this money and
use it for Charity works, for orphanages and giving justice and help
to the poor, needy and to promote the words of God and the effort that
the house of God will be maintained says The Lord." Jeremiah
22:15-16.=E2=80=9C

It will be my great pleasure to compensate you with 35 % percent of
the total money for your personal use, 5 % percent for any expenses
that may occur during the international transfer process while 60% of
the money will go to the charity project. All I require from you is
sincerity and the ability to complete God's task without any failure.
It will be my pleasure to see that the bank has finally released and
transferred the fund into your bank account therein your country even
before I die here in the hospital, because of my present health status
everything needs to be processed rapidly as soon as possible. Please
kindly respond quickly. Thanks and God bless you,

May God Bless you for your kind help.
Yours sincerely sister Mrs. Lila Lucas.
