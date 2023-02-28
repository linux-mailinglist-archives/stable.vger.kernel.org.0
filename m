Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCA36A575C
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 12:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjB1LAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 06:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjB1LAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 06:00:30 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424A11EFE1
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 03:00:28 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id x6so4118462ljq.1
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 03:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8srtPqHGa40CVslrURYXsHSOfQqBi5LmheASbuMqgVc=;
        b=BHR15gx3l7u/mRHKYtT9hfK8nKyp7owVlh1ehpGqaRMgdyPxlzxutZkcm2RaH4KG9c
         4XMQyK7GfRen/d0PPcSxMCvONg24i78avP4dwnWWoSPhQpSnhycLmNANS+FcCSij/TrB
         6ol2uNS03xjZlCj07BY1fzO7Fav1ot1HKGOsFPGqUjoocMzXBATneLSCrOURrcfWfiJK
         tAN/QUn1MthvXi7Jp8Her0ugH/mr4Si17c0uVlnsBq7mF/SHodXaD55X3lVcBGc8b9Cy
         bsvVQbYzjg3ong6rqXKMn+xZX2SVfKLR+0COZH1eGj8XrpdmOz20mpo6rSXFqxpA0tLz
         DFIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8srtPqHGa40CVslrURYXsHSOfQqBi5LmheASbuMqgVc=;
        b=a1D9AhyG1J90s144rMT13HC3KlUx2Vg+CzYciM46seg9pd0ohzlPbNkeLej8pgV7sg
         WfxtWOKov365KWvAZlGzLWcBMmyWW2lrbOpI0PVAwGRK9C8TdwwPZIz+sJcwwk3QxaTw
         u5T0QV1tuEeXxdV5h3Dhjz6W/P+lObp1bMzDcbNXmOYkc69z+ufOq9zaq78LhAo44tlz
         QKcH9KORE4vkLK0w0q4vMK6mH4LWOy4MFq+FjbQcB5TN7SAzxUbldig/AiBA0nZukIXM
         pS7UK3wWrNyAmRhoQiFAMgemnmpb2YVSnmWaJXhRFcdf3/YUNTza0hH8AOKw8uPs8QjK
         RcMg==
X-Gm-Message-State: AO0yUKWpDOJKlLIWoU60ilxJYlavAYxNkKR3odwDhsEvZNI43IGW5CB0
        20UwTN7KTB3Im/RgidKiH9wkvq6Flu1iU+ZAwTc=
X-Google-Smtp-Source: AK7set+gnFxtkC/VFWxighh0nNW6/xVJHMyMySCzC09gep3HLdAMwPkLaMt7XwV+koEhdL6dEQxHdz1BacTj2EylwQA=
X-Received: by 2002:a2e:b750:0:b0:295:a8bd:d938 with SMTP id
 k16-20020a2eb750000000b00295a8bdd938mr693885ljo.0.1677582026304; Tue, 28 Feb
 2023 03:00:26 -0800 (PST)
MIME-Version: 1.0
Sender: lruby0209@gmail.com
Received: by 2002:ab3:3ce:0:b0:222:37d5:65d5 with HTTP; Tue, 28 Feb 2023
 03:00:25 -0800 (PST)
From:   Aisha Al-Gaddafi <aishaalgaddafi112@gmail.com>
Date:   Tue, 28 Feb 2023 12:00:25 +0100
X-Google-Sender-Auth: bW_YozN4sHUHHDKDyxaUqN9V6lE
Message-ID: <CAEPObtPTut0+r+YM6nztaOGj_uJG1BmyD2OsyDQPCA7MaMaP8w@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.8 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:22f listed in]
        [list.dnswl.org]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [lruby0209[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [aishaalgaddafi112[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dearly Beloved In Christ,

Please forgive me for stressing you with my predicaments as I directly
believe that you will be honest to fulfill my final wish before i die.

I am Mrs.Sophia Erick, and i was Diagnosed with Cancer about 2 years
ago, before i go for a surgery i have to do this by helping the
Orphanages home, Motherless babies home, less privileged and disable
citizens and widows around the world,

So If you are interested to fulfill my final wish by using the sum of
$ 11,000,000.00, Eleven Million Dollars, to help them as I mentioned,
kindly get back to me for more information on how the fund will be
transferred to your account.

Warm Regards,
Sincerely Mrs. Sophia Erick.
