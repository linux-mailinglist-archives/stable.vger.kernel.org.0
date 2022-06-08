Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532AE543012
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 14:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbiFHMP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 08:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238971AbiFHMPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 08:15:25 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2082E9D5
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 05:15:24 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id f12so16423147ilj.1
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 05:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=RqvhwLxpoWsPOdPHLQ+kBu2OEWvgdFg9DMc+/a8ko9E=;
        b=aEYMPkyI8YMDlve7F66cWtFTfgfkST7aCIZq8oq9xUWhneMPDwgTZtPVn7h5vSqRll
         zf2rPY5EPKvvvEy2yl6KUO0yYociz0QSed2xmisdcf2xQ4smPLucJ9uGUs+t7+FZnPFe
         mAWJ4wF2kkfbIrF9l8BylMi1zVspDE2wlQOnEXWQ+3XVGZz3Mkio8V4qi2AEqefUZrNB
         vlKO6GAHwQvKf6XcuMBP7H+mU2lC5+arIcIwUep173+7dkzV/KTBQ6zYEKI6afKu4Q8P
         RdfgNHznhwFFCd6h3f/bSRcidXIwLBIRDkloDPQbFWXf+BhF5ehc+LtfQXj/7oyD7vwV
         ejwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=RqvhwLxpoWsPOdPHLQ+kBu2OEWvgdFg9DMc+/a8ko9E=;
        b=uGd8Tj4akRyOEBFH6L2B+aRW1eDqp4wxPDiWcoQD68kKdcpsafvBLvowaQRew8djty
         zyoNtZam+6zpSSQjX19vAS6B/DHN3LjaGx6MG8CAN0E60PetvlW8YQeegEEkhIBTgXZa
         tfx+zXavDw5RTWB/d0v7C1u7owBOckdwS1qPlPKc5EYL+oWXemDE/6cyaPZP/RWg0ToG
         ML5a8o/EZqbKnoKgM+C8pLLwIvSUebd2IO/y1O9M1uKoZDYHdguqCkqPjnYHAYivnffS
         mVpYVHOI3/jUz2r0zEnhBUSwRNvCwzTyQEFh0OXKbRz6mTiC2nAigc8o/p5UO0x3D0/B
         vlqQ==
X-Gm-Message-State: AOAM533OuO506d7M4P+mMXwZ/ExPGee6BejuEGBFtEmo8m10QBJD1xYm
        TS60gdyMTFzA9qccU1IO9uN8JCX4heC2oyRyc+s=
X-Google-Smtp-Source: ABdhPJze9spJtiyfdLXyPBPKZ2+KTl/vxWWUL5KaU4BYYN2LRaJl7ZFrAHUaOtWO7eSIlhpKQRSWs9GKA8Dt4JzFHOQ=
X-Received: by 2002:a05:6e02:18c5:b0:2d3:f02a:aba0 with SMTP id
 s5-20020a056e0218c500b002d3f02aaba0mr16933407ilu.196.1654690523390; Wed, 08
 Jun 2022 05:15:23 -0700 (PDT)
MIME-Version: 1.0
Sender: lucassophia770@gmail.com
Received: by 2002:a4f:8603:0:0:0:0:0 with HTTP; Wed, 8 Jun 2022 05:15:22 -0700 (PDT)
From:   Sophia Erick <sdltdkggl3455@gmail.com>
Date:   Wed, 8 Jun 2022 14:15:22 +0200
X-Google-Sender-Auth: giCT70VEktbouUChvFddfdBFiIc
Message-ID: <CADgTK4k3zXzkT_Rd8b9JtMjdoc7zB-fai-6Ks+X5GJdagwdoWA@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FROM_LOCAL_NOVOWEL,HK_RANDOM_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello ,

It is my pleasure to communicate with you, I know that this message
will be a surprise to you my name is Mrs. Sophia Erick, I am diagnosed
with ovarian cancer which my doctor have confirmed that I have only
some weeks to live so I have decided you handover the sum of( Eleven
Million Dollars) through I decided handover the money in my account to
you for help of the orphanage homes and the needy once

Please   kindly reply me here as soon as possible to enable me give
you more information but before handing over my details to you please
assure me that you will only take 30%  of the money and share the rest
to the poor orphanage home and the needy once, thank you am waiting to
hear from you

Mrs Sophia Erick.
