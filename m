Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18CE250B7EA
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 15:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444406AbiDVNLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 09:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbiDVNLA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 09:11:00 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE6557B03
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 06:08:05 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2ef4a241cc5so84683987b3.2
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 06:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=K/QYeJ6Kr5gfIU7Fpl89QyGTQtjDb8YQe7UgywJHBLM=;
        b=aSi72HwRkNKeCnsdRQ5H8lrYQf9zUbzdguuAWV4Jzn+uS7+lADcBRtTuSzqC18xC7n
         kbOgteEcYjWlmmx3DghdqDSlXUKJfILysvGG6Qp79b3pIfpXQdGMmmuHxnhZhX5xiFOj
         c/4SoBycgKeA+9iWe5kNnG8PFLQQMtyj16l4XHK5Fa2VKM7p1VxVZXDYnpXAXheZ5Lhk
         +hpnGxZW34aqtzgGwRDlDeS38lNpOhnzxZgFk8p52yFLfMBDg3skdvKbLgV2WclSJ/Ig
         4eoCPPYYDvPbQkJ2IL/LzFvfcPtB0ZveH2TLFrfotrWnMhgmDgA7ScXEkFilFL9mdewM
         Cv6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=K/QYeJ6Kr5gfIU7Fpl89QyGTQtjDb8YQe7UgywJHBLM=;
        b=RzU1sctwRFjKCpoeJZmK+S2siLdYzQ5QdjkqEVnj4MYa3Ho2/Tz+LhwdIqmZnWV0SU
         c0p4qhYddOt7IypY5CqDn2XHZDHZRI5phYiSkFnwQQxdDBa6Foq85IkDFja0UZYZF+ds
         K3V8VUmlXm1dXCLq0ydCTFmcgU04ITWWorRZDpLBXIiHGrxosvo2VS1w8ybpw4d2WZwa
         u9f7UOn24IGfqMOR779VP8PimofdCZhufqHAFqrSFAF/n9CQTdZ72V2AMsx4A+WBcMCD
         JFJLIXD4KXesn4Suz1YFZeqiBM0nFhDpoclcWBatHTUZNGImsGzJkuYT5tybybqfZ3s5
         7p9w==
X-Gm-Message-State: AOAM530Bz9+rUcuLihlsq2hHotSuVXT3Xva+A7TnFVKMczIt94Pxi5Of
        FTcQFjRYLNVFwPCfc6+EWhFmIzS6pHsh1Kx2eyk=
X-Google-Smtp-Source: ABdhPJyFWpwXRoWc3PmCfzBrHYTet+SEHWqxkHRayj9SZprzXeSD18agxerfqz0VyiYpcSs4cy4tZPTBkuJO1sXL5OA=
X-Received: by 2002:a81:52c8:0:b0:2ec:8fa:ebfd with SMTP id
 g191-20020a8152c8000000b002ec08faebfdmr4611244ywb.502.1650632882945; Fri, 22
 Apr 2022 06:08:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:a8a4:b0:24c:a8cb:c13b with HTTP; Fri, 22 Apr 2022
 06:08:02 -0700 (PDT)
Reply-To: regkabbah@naver.com
From:   Regis Kabbah <jonegoce2@gmail.com>
Date:   Fri, 22 Apr 2022 13:08:02 +0000
Message-ID: <CA+kmhPteHcNPSD5+npSefwVvu04GE2U6MKPy9Z8iw+TYYwMVFA@mail.gmail.com>
Subject: Project
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.4 required=5.0 tests=BAYES_50,DEAR_SOMETHING,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1131 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4851]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [jonegoce2[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [jonegoce2[at]gmail.com]
        *  2.0 DEAR_SOMETHING BODY: Contains 'Dear (something)'
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Dear Sir,

How are you?
I am Regis Kabbah. I have a business opportunity to discuss with you.
If you will be interested in listening further on this project, do
reply to enable me elaborate you on the subject.

Best Regards,

Regis Kabbah.
