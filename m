Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09655B0CE7
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 21:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiIGTLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 15:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiIGTLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 15:11:40 -0400
Received: from mail-oa1-x42.google.com (mail-oa1-x42.google.com [IPv6:2001:4860:4864:20::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE49B5E79
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 12:11:40 -0700 (PDT)
Received: by mail-oa1-x42.google.com with SMTP id 586e51a60fabf-127ba06d03fso14861123fac.3
        for <stable@vger.kernel.org>; Wed, 07 Sep 2022 12:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=9JgfdaIQvQZ9l5SmCOLciVHAQhMDxaoqktdhOO0g2kU=;
        b=mrbp58oFtVeEUF93q+VT/oPhFkA8Bx8j0IY3KA4xkaXQRb1XSkwdpRh6lyyQvkSujS
         X3x07jOzd6i/CBSa9NIwEEXf8OOV/4zF/bTYCnvWSafOtcDuTN5j1F1gNnmL0bq8m79D
         eIOBzaeGnMFVG0NoPcJMN0FDBL5pPqjSUPfivhT0Z8DBxzUlKZl1c0G/GylG3VXHKFa9
         Y7JaEPBjaDOOXyoeTYhs6wxOjIa19G+kCMw5RDMTxpSgfggvG2T9tgbutJUOcOEhV8ms
         f+fgmFwlHC7NN0AbVkrseAfCibFsdCmRxIjczir05OCmw+/0GKdBIfY+sZCjSFst77Zj
         fgrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=9JgfdaIQvQZ9l5SmCOLciVHAQhMDxaoqktdhOO0g2kU=;
        b=lWzLKXquWMHTvrXrELbY9rpro7StW1h0l8pd+phAIFL3tEMWJiUroutP1MiYj36CU9
         9KOz55ul0Dp6QE+XYB+jFcPhyh259qT2rqLri6mBuchJdkP786YUZinmwnELMD2BLorL
         hxwSvpBXDLYIF+97/qK65xOJ30Ani6ClsS8FLHhd19EuBwJWovgjfOVt7EMX5YyYLZ75
         Wd76W3l6+WSUYARh7EM1osMbI50/YA2TR8PKoYEf1CqB09fctrY6KFzQTwAoV3Sp0xTy
         n3rIFvTcEipfGmpNi6/Pz1e6CRq7J6G6DOw4DxhUYvlTbEYkD7YOcbki8Lw9i8Jpx/bw
         hyyA==
X-Gm-Message-State: ACgBeo0B9t9YBTzZwjuTDOjz8zEKAOLbJ3x6KWu9AlvO+dUEpQ8AWxnl
        jUhv/uY/npreCdHjy2UNDvYC+icDMg+xsq4JQyQ=
X-Google-Smtp-Source: AA6agR7QqYnyI/vU8SjG+dRov5Y/dYWq7wlR1159Bvz5vBXoUriJc1zuriri/JmD8m2hrWk5HTY6mjolewUUoAV5Vto=
X-Received: by 2002:a05:6808:1482:b0:343:6755:a7df with SMTP id
 e2-20020a056808148200b003436755a7dfmr48735oiw.288.1662577899248; Wed, 07 Sep
 2022 12:11:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:71ca:b0:b2:5ff5:98bb with HTTP; Wed, 7 Sep 2022
 12:11:38 -0700 (PDT)
Reply-To: stefanopessina14@gmail.com
From:   Stefano Pessina <saiduumargeidam@gmail.com>
Date:   Wed, 7 Sep 2022 12:11:38 -0700
Message-ID: <CAMwN_Rd7DWOo5UVK1cbKsDAnQHCOZd+toejrHyFFTv=Ah1bzdg@mail.gmail.com>
Subject: Donation
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:42 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [saiduumargeidam[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [stefanopessina14[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
I am Stefano Pessina, an Italian business tycoon, investor, and
philanthropist. the vice chairman, chief executive officer (CEO), and
the single largest shareholder of Walgreens Boots Alliance. I gave
away 25 percent of my personal wealth to charity. And I also pledged
to give away the rest of 25% this year 2022 to Individuals.. I have
decided to donate $2,200,000.00 to you. If you are interested in my
donation, do contact me for more details.......
