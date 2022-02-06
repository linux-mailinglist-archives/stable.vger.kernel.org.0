Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC074AB217
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 21:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245391AbiBFU3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 15:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245464AbiBFU3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 15:29:38 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46D4C043184
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 12:29:37 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id og43so12247991ejc.0
        for <stable@vger.kernel.org>; Sun, 06 Feb 2022 12:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=+8DDhZ2DvUUwsc7BBk/PCXx/FTX8nQeg+hQxTso4xHY=;
        b=pGUILzPu1LxyoeyXl0DUvMg1FA/OdzHGvv6Pkw3B9KH55OsNOhgukCJl9rQ3hBGmU8
         Id4s1sxergShYVP6zK6fa4ABqiAnpgH9Vc/NeEO7HU0f1Kcel+zcV9UXrbSkoovoE1GB
         ReuwVRt4CsHY+tCNGJp/phHFcwYZj6ZHkgWm5oQLGEIiEfvDqNelfjwpshRRJRwkPwR2
         rVUf9azL7qZaZPS+tY2FqNysS8ej5DWX0OcLbguElnAwwK07QvQROdubBpLAtkAxxh+7
         Mb5tpH6QB+KAKZh5f+SUwhhOdZbkvhlmzMyWstDjrrU1gb7zoxzhy47XdDUAGCgP7394
         XBkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=+8DDhZ2DvUUwsc7BBk/PCXx/FTX8nQeg+hQxTso4xHY=;
        b=NFBhPTtmEPo0wtQZZGAr9APpBd9QpuYhAF9T0cziNT/Tn8sTLz01hLMkrJsuPnpsjf
         7nOTBUu5TrGzg2g4FRrhZRlTNGD1/YOieX4AwdsgKTI5paZ1Mn/dbbH8UpG3HVHsXRAv
         78Gv7ASTX/Cj33zblvBMzCM/bmU8UR89/qftxjeX535KVsN0N7EIjVFaxPX3rHH7oj+q
         FBNB+Ej2txOfgpE41BFKaRW4oi+54NdSxCidJcvSww3leeWX9HNwZIM1l8OI3PRqpQMl
         T3zzyJKIePFr1FkEout3MdypdZEGErBAtb64oeuAIFSL5rphQpIuUuBvxFa4BqKcxT5s
         d9Ww==
X-Gm-Message-State: AOAM533E5Im6or8Foop0opEr8ZxnZkfli+ifEe5jntZHOfNBEnWXpmae
        ZYy8Q+F6QnIrtGUJta3UEz99u11qOvZ1VoZCWrU=
X-Google-Smtp-Source: ABdhPJzY8QNUWm1DQ2Sf8O4sbrPoBYeajgVKuUQU9kNI1gNgZav5IZhPM0lORO/VIk7XK50kKygrvuTpZh3lHZS2aO4=
X-Received: by 2002:a17:906:fd4f:: with SMTP id wi15mr3398625ejb.728.1644179375183;
 Sun, 06 Feb 2022 12:29:35 -0800 (PST)
MIME-Version: 1.0
Sender: petersgarry3@gmail.com
Received: by 2002:a7c:9b15:0:b0:145:63a7:aa58 with HTTP; Sun, 6 Feb 2022
 12:29:34 -0800 (PST)
From:   "Mrs.Candice Marie Benbow" <mrscandicebenbowmarie@gmail.com>
Date:   Sun, 6 Feb 2022 20:29:34 +0000
X-Google-Sender-Auth: rryHQlkI4SYkuaA1aYHVEpT7FuM
Message-ID: <CAB1rweE_muTyaJKGoysBkezrZGL_W03QChWgrQJAdGzDUvN4Fg@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.6 required=5.0 tests=BAYES_50,DEAR_FRIEND,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:62e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrscandicebenbowmarie[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [petersgarry3[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  2.6 DEAR_FRIEND BODY: Dear Friend? That's not very dear!
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  3.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Friend,

It is my pleasure to communicate with you, I know that this message
will be a surprise to you my name is Mrs.Candice Marie Benbow, I am
diagnosed with ovarian cancer which my doctor have confirmed that I
have only some weeks to live so I have decided you handover the sum
of($12,000.000 Million Dollars) through I decided handover the money
in my account to you for help of the orphanage homes and the needy
once

Please   kindly reply me here as soon as possible to enable me give
you more information but before handing over my bank to you please
assure me that you will only take 40%  of the money and share the rest
to the poor orphanage home and the needy once, thank you am waiting to
hear from you

Mrs,Candice Marie Benbow.
