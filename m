Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFBE6374DF
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 10:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiKXJMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 04:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiKXJMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 04:12:37 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A623B51C17
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 01:12:36 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id y24so1669152edi.10
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 01:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h94amkrgHMvkPfBIkBV1KEw1F9jj2Brnk1qfqW9jmH4=;
        b=P71LJSW2PFo2OzJDT2pf5wJJSLh2OU3+88Wfw5GHrZHLU0yo2m7QVkb68ivYbKWQ/N
         fluDt4fx6KWK0I0US/A+OiHxCUSzLvILIgZybB9lcsvlYn5JKJTjB7VTbGMG5gfhkWDL
         c+3gpdzR9eNO2oYOgEH5nYhF+jmYEUPxl8EA9jhqEa4ETb0qYTPjOmn9pgru/Db7nCQz
         Q8dCSpnFPkXgymJcshzoaPSTcuO2nR/j8l5XujbEbi6qtcCCO0s+zuF1SjiLQlfeiilx
         d9JVyVaEoNzSUYShWMBEv843oJ71x5o0gj3U8jjUiKhCsh2mef18m4sGR6qwWASRmr3Q
         kGwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h94amkrgHMvkPfBIkBV1KEw1F9jj2Brnk1qfqW9jmH4=;
        b=bgQwNSf5fKmHnQuOd1+Ikk0+1CKYWGJlr6p/7a9lZ8cQECfDt51So6e2BEZKF9WrQ3
         kHQ5cdT8kFHt6pL5DIYn0yYFw1HlRDnOzGn9TN3bt3CmyLZasOns2vBuOdJoDxO6KarD
         cWSg4sJToFv1G6fjoJL9l13lM+XHUUpSROTZLuF2GDMmJwz7Ctp0fEIvSOqetXVZM2Co
         o5T2xzSIOL66wp5bU8We+Hkk0y3NPB2l2yGluZKUkm2rJgyX0MZbDKib8NQeEYw1W1YM
         q1K6QXV81/fmRVLeKk8bOXs++4G3ZrKZTDiR5/U4viLkHoIP+4dmG2fdLdiMAmCvnDN/
         P6gg==
X-Gm-Message-State: ANoB5pnDeS31lS1+FCFUVSGulSYeXPh2op8aSlBx6mDz0JFPL3ZQvz1K
        7pvmgKpj8oBi7KUCS2rJ1LOaWG3IIB70l9ECHaQ=
X-Google-Smtp-Source: AA0mqf6WL+9SU7VJ8pd/JKNRY0fIAgs4kfkO2zqAefB4p9VFErJ5DJoh7huYxTpzU+q8yKpX7/SeNE6Lcu3HnExJh5g=
X-Received: by 2002:aa7:dc19:0:b0:461:f94:913 with SMTP id b25-20020aa7dc19000000b004610f940913mr14409883edu.102.1669281154932;
 Thu, 24 Nov 2022 01:12:34 -0800 (PST)
MIME-Version: 1.0
Sender: rev.benaldjoseph@gmail.com
Received: by 2002:a17:906:199a:b0:7ad:c587:feb1 with HTTP; Thu, 24 Nov 2022
 01:12:33 -0800 (PST)
From:   Doris David <mrs.doris.david02@gmail.com>
Date:   Thu, 24 Nov 2022 01:12:33 -0800
X-Google-Sender-Auth: bLvkWk9ZBaAymntIAYjKt-XxyTE
Message-ID: <CALZVc+Tx_8pjGVjnOfYPKvidZobKjOswaVXK0KGiuH7PADPiXw@mail.gmail.com>
Subject: Re: Greetings My Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.8 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_80,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:52b listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8471]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrs.doris.david02[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  3.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings,

I sent this mail praying it will find you in a good condition, since I
myself am in a very critical health condition in which I sleep every
night  without knowing if I may be alive to see the next day. I am Mrs
David Doris, a widow suffering from a long time illness. I have
some funds I  inherited from my late husband, the sum of ($11,000 000
00) my Doctor told me recently that I have serious sickness which is a
cancer problem. What disturbs me most is my stroke sickness. Having
known my condition, I decided to donate this fund to
a good person that will utilize it the way I am going to instruct
herein. I need a very Honest God.

fearing a person who can claim this money and use it for charity
works, for orphanages, widows and also build schools for less
privileges that will be named after my late husband if possible and to
promote the word of God and the effort that the house of God is
maintained. I do not want a situation where this money will be used in
an ungodly manner. That's why I'making this decision. I'm not afraid
of death so I know where I'm going. I accept this decision because I
do not have any child who will inherit this money after I die. Please
I want your sincere and urgent answer to know if you will be able to
execute this project, and I will give you more information on how
thunder will be transferred to your bank account. I am waiting for
your reply.

May God Bless you,
Mrs David Doris,
