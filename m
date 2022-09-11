Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400EB5B50EC
	for <lists+stable@lfdr.de>; Sun, 11 Sep 2022 21:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiIKTnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Sep 2022 15:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIKTnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Sep 2022 15:43:23 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEE32611C
        for <stable@vger.kernel.org>; Sun, 11 Sep 2022 12:43:22 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id q26so1516310vsr.7
        for <stable@vger.kernel.org>; Sun, 11 Sep 2022 12:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=cN23DHaJBStKFcEZbZj6/dLYpS6V5R+rJX3+QwUiahw=;
        b=flyrzUyJN1qvzuydWLTtfFCof2EbUeWBB6GFL4QmPaWqDN0+CFyf5TiwmH0zDRygKp
         4obA8XQcVmueEMU9vXrgQoH0Mz72vEpFl2CnjV26MDUeNRCSd2IS+MRDjO6quvwcHLHZ
         FaXrRfLreMOzY+LVcpAj/DdamThMngB9o9K9PWsQTZoWaprC1HUySc9L+bxStXx27hUe
         gkghp+08ClYm9pXpKWxDkcBY3dcGDNjqg7wpgj3XuF/zT/ZmTKrNSGm6IbBi0cCyhUXd
         H3Vu+0ABhdkEq4lKipu0vc6oft1toz409ND0WiTqYLdvtjVNp6DNrp8QbLCm2iH4geqE
         61yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=cN23DHaJBStKFcEZbZj6/dLYpS6V5R+rJX3+QwUiahw=;
        b=liseRdKTpHPVSv+RXOR3jT2thV4Jj/mulJ74vXxKIp6TJ7SSFP7aiDKC62p8928YO5
         vcLqUsf8Mn7XeOWCOxYataeK6HrlCQAWuKh9rSlrpsJXCOJSoXPHwTNYrv8YE54SrTSu
         3pvyc7REk9OwxMmhFpdzb7M7+iu89IZeQ45QDr8kDTvvxU1Y6FfacOAW8lags4G/r9Sn
         ZibzZI+1LIAnZmt9+NhsGp5y8+QR9/wxiBiZPQwul2CS4VtnwxmEzjDJhGmCh4LfRO+Y
         pebXeahbg0VfKXc0lb9OwsRSy7gUN1eJt+X2Ic7GwHLvR81PH77loTA71+5gkL86rOQm
         gNPw==
X-Gm-Message-State: ACgBeo00/1GOOpB5M8Us4mpVmt6rlWtiO6HdPWomrR1ET6LjQ1F7bguf
        0NK1BoubJx0GmSTO31C4USTPeRsoEkC2pqRcmec=
X-Google-Smtp-Source: AA6agR7iYWiS0BVV+z13DChGGj/6z9uqTTHVg12PhJaUeTqkAaiJLH+6vX1D/0qXigE0ViWZ13S8fxf9FJrClILyPzY=
X-Received: by 2002:a67:bb0c:0:b0:398:4c35:eddf with SMTP id
 m12-20020a67bb0c000000b003984c35eddfmr5095897vsn.46.1662925401214; Sun, 11
 Sep 2022 12:43:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6124:c9c:b0:310:9292:f8ff with HTTP; Sun, 11 Sep 2022
 12:43:20 -0700 (PDT)
Reply-To: te463602@gmail.com
From:   "Mrs. Mimi Aminu" <mimiaminu319@gmail.com>
Date:   Sun, 11 Sep 2022 12:43:20 -0700
Message-ID: <CAD-C4f4h5s5MhHP8C5VArt-6EA_-Bpo9uUn5=sQDvQF_EOC==w@mail.gmail.com>
Subject: =?UTF-8?B?7KKL7J2AIO2VmOujqOyXkOyalCBHb29kIERheSw=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e2d listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mimiaminu319[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [te463602[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mimiaminu319[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Greetings,
The Board Directors believe you are in good health, doing great and
with the hope that this mail will meet you in good condition, We are
privileged and delighted to reach you via email" And we are urgently
waiting to hear from you. and again your number is not connecting.

My regards,
Mrs. Mimi Aminu.


Sincerely,
Dr. Kim Chang Jung
