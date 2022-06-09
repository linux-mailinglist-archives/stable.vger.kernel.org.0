Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78CA5453BF
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 20:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244500AbiFISK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 14:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbiFISKZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 14:10:25 -0400
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3273AD8A9
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 11:10:24 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id m30so6660069vkf.11
        for <stable@vger.kernel.org>; Thu, 09 Jun 2022 11:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=8d0a50vlXPwK/evqvKND5Qkww0VWt34LxBu4KEjcCqk=;
        b=KX0ENFo/OATf9ORWhZD3pqCTOZvJWcSYC0ePtsdCBkXrLsEJkyf36yku65cTqaGfY7
         EsMafPmBNkEAvzK9iRMZ/yAZqlBEljGBrCQISySi9uhq4E8L719Z3B08RTegqVQhOfT2
         /joboPqPB3ygnL6RmzrTzg7ZRuJnDB6ifycSD8E2o21FC3/Ar9/bvQpkYioVnbHuTuOp
         hEjQBxs6HOPFN52mc2tgR2nMtHVw2aXTH9juE+SdXVLjR8jP+4OEvh7AkA7b3PV63wxT
         /kscGjftY+cCghEKhcRwAQ5W7G9ygFnkdv10ZqhkPmltR6HrLTqBTElB7ZrJ/TFMrV1V
         V55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=8d0a50vlXPwK/evqvKND5Qkww0VWt34LxBu4KEjcCqk=;
        b=eEBuygxJU0Oxnm9qr1nX07kVxD63k5oN4ov0MnS02pSYxQorSL9u+OJllCUcBzhbt5
         GUru5QdC8C3yzx1AQ7qP7rAkmN+Jbf20RzuqAiB/xa+1HMzTVJtglyi/ciGmxsfjoJIg
         dIhM10+8URH1F6yoTu5YWQ7548pZLJRA/bjNQzGRPpVrEciY58qFMQ60EKcIjlEVgJjb
         /bwv0jpnr5pezgGS5ruhhiuWj2rt4GqghbEL4YMTAwUqVmTvC5dWaBTuqG7pC1MUBlug
         iaNkMliQQzwqAvZPzLuAB/cI/6tReVhVofk9r+znO2SjfccGIGMDDZQTLTV3TygRZ45X
         2vtQ==
X-Gm-Message-State: AOAM530WVYovDuGqvuoKvTMAqRuPi0gMA0b9U/tgrqyOIklhgwc21e0i
        CzT13LJkoJHHZE6Yw4GGkCtRh7ui8U/28x9f3Lg=
X-Google-Smtp-Source: ABdhPJwxv8xDWphtb7XzAf6yioVV3mLCfcB8DRQ5AltT+FIqq1KlHvD9ZJ1nCkmwBNi2DDI7HPC+eN3lxPv0KcGGuBM=
X-Received: by 2002:a1f:720c:0:b0:35e:5a32:c827 with SMTP id
 n12-20020a1f720c000000b0035e5a32c827mr7734076vkc.7.1654798223958; Thu, 09 Jun
 2022 11:10:23 -0700 (PDT)
MIME-Version: 1.0
Reply-To: evelynjecob47@gmail.com
Sender: dr.daouda.augustin198@gmail.com
Received: by 2002:a59:d66a:0:b0:2ca:36ed:79d9 with HTTP; Thu, 9 Jun 2022
 11:10:22 -0700 (PDT)
From:   Evelyn Jacob <evelynjecob47@gmail.com>
Date:   Thu, 9 Jun 2022 11:10:22 -0700
X-Google-Sender-Auth: B7vX5oL6GsNqe0J0JP7UeVkNxow
Message-ID: <CAMyj+W4dxgju4pnGCsTa2N9e9oNsvYoLHRSW9k1_9Rc3_gcpmw@mail.gmail.com>
Subject: Ms.Evelyn
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MILLION_HUNDRED,
        MONEY_FORM_SHORT,MONEY_FRAUD_3,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a2e listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6385]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [dr.daouda.augustin198[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dr.daouda.augustin198[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [evelynjecob47[at]gmail.com]
        *  0.0 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
        *  0.0 MONEY_FORM_SHORT Lots of money if you fill out a short form
        *  0.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  1.6 MONEY_FRAUD_3 Lots of money and several fraud phrases
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings dearest

I'm a 75 year old woman. I was born an orphan and GOD blessed me
abundantly with riches but no children nor husband which makes me an
unhappy woman. Now I am affected with cancer of the lung and breast
with a partial stroke which has affected my speech. I can no longer
talk well. and half of my body is paralyzed, I sent this email to you
with the help of my private female nurse.

My condition is really deteriorating day by day and it is really
giving me lots to think about.  This has prompted my decision to
donate all I have for charity; I have made numerous donations all over
the world. After going through your profile, I decided to make my last
donation of Ten Million Five Hundred Thousand United Kingdom Pounds
(UK=C2=A310.500, 000, 00) to you as my investment manager. I want you to
build an Orphanage Home With my name (  Ms.Evelyn Jacob) in your
country.

If you are willing and able to do this task for the sake of humanity
then send me below information for more details to receive the funds.

1. Name...................................................

2. Phone number...............................

3. Address.............................................

4. Country of Origin and residence

 Ms.Evelyn Jecob  ,
