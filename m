Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE525E6844
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 18:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiIVQTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 12:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiIVQTf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 12:19:35 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3431099
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 09:19:32 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t190so9607912pgd.9
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 09:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=51pxdnyWuflqH2RvjuEZ6HyDxmt8iSvufcZFq9V0LWo=;
        b=IeRFDaDURYCzFTPA5wzDWnOr3HnZw+Lz6rDlc7918j4EGZbqlSrOTW6kR5HhdrmjxW
         jvcSn8lU5g+NpznLa7PDHKx3o16CdiGuQjkY8g37innCU1Azt4pUf11DqwGnxWUj0zi9
         hlarFNjd7U7XjVWN7LMUS5Dnp0tHdgreYO63pLeWV5gk5HBy9S7wNUXJvt3Y+OOeFYBX
         nMqkEgRNTRrnlPiXx6RS5Y2sJF3WyTn8e7I2wQPbsassRaCDrbMckopYxpYSuFAh4lwZ
         46ym6DxFgdyykTpEgxzIQ3WEf3GEub/IpUcelRvF12fDrqC18oQyup2aZ9PHSc/ktr2L
         ZAsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=51pxdnyWuflqH2RvjuEZ6HyDxmt8iSvufcZFq9V0LWo=;
        b=uCAzn/m3Qld7TZ9P+NAnxJ8TqrqEAyuBRZ9HvL6/SEnjm7M0CCbYBddpifl9pkB80b
         1V2eWUTEW3YTKyA4sz09JSqtMnOAgEtII9mK4BoLmLJSB7mvXe33IODR2F35LMqKNgnM
         rzJx6y3WFdDGMnVI1gwm82wEc4y1JWMZxShx/0qY+hPxo8P6tpYo0PnKX8R3XWk2P/wN
         wTVsykpvPw1J3ZX2UMOdEMRyt0lPo9J6kgiyMI6rvBtKZsOsXFtw50rZhxTbLk4+dRB7
         Xc5Pv9rcMa2CnjWHsI3fDunNgesBXZEUiIeFt65DfCWAaUDHTde60+9BA18lPEufCobF
         iggQ==
X-Gm-Message-State: ACrzQf3LEbjRSDUiXLgmkI909UyNXglDcaGzJbZeX7tDJ/WU594jS7ur
        /Q3Nn8w/JDrtizlSscjGjl39y1H8dBbHkqK9+yc=
X-Google-Smtp-Source: AMsMyM5tJcyo94KcSJob5ezyO3vzfVV61o7Q9CAkO8hBIg0JNFFYQyA+nTq+k85b5tdPEldZwz1Pss/Xh1c1gC0Yf/g=
X-Received: by 2002:a05:6a00:114c:b0:528:2c7a:6302 with SMTP id
 b12-20020a056a00114c00b005282c7a6302mr4343697pfm.37.1663863571658; Thu, 22
 Sep 2022 09:19:31 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:90b:4a50:0:0:0:0 with HTTP; Thu, 22 Sep 2022 09:19:30
 -0700 (PDT)
From:   Bright Gawayn <gben74325@gmail.com>
Date:   Thu, 22 Sep 2022 21:49:30 +0530
Message-ID: <CA+nOVsZwD=7+griFN8nMbNuwWWN_r6X9tYQiGf-V780PR068Kw@mail.gmail.com>
Subject: URGENT FOR A BUSINESS PROPOSITION
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.6 required=5.0 tests=ADVANCE_FEE_4_NEW,BAYES_60,
        DEAR_SOMETHING,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_MONEY,URG_BIZ autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:543 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6291]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [gben74325[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [gben74325[at]gmail.com]
        *  2.0 DEAR_SOMETHING BODY: Contains 'Dear (something)'
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 ADVANCE_FEE_4_NEW Appears to be advance fee fraud (Nigerian
        *      419)
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 


Dear Sir Good Day to you.
My name is Mr Bright Gawayn,
it's my pleasure to contact you today in
regards to a very lucrative business proposition.

we use a certain raw material in our
pharmaceutical firm for the manufacture of animal vaccines and many
more but my company can no longer import the material from Ukraine due
to the Russian invasion war to Ukraine.

My intention is to give you the new contact information of the local
manufacturer of this raw material in India and every details regarding
how to supply the material to my company if you're interested, my
company can pay in advance for this material.

Due to some reasons, which I will explain in my next email, I cannot
procure this material and supply it to my company myself due to the
fact that i am a staff in the company.

Please get back to me as soon as possible for full detail if you are interested.

Thanks, and regards
Bright.
