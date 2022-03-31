Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872354EE48A
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 01:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbiCaXOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 19:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242870AbiCaXOm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 19:14:42 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B3E24B5C9
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 16:12:53 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id 125so1299812iov.10
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 16:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=j/xy20XFf1kHy8TR2k7muZOA2WshcHFFaw2UWxVTMgk=;
        b=fifUVIGS76doudzXdPLazz8jMpLWfIEZdyZynmmtHLiqh5o/AUEok+c5zY1UL7l/q4
         SLK82aEftxXEl8W4QiRVnKZzAm7Z8RtoZQx3iDdp9Sj8FE1kpzVjMg3MVO+THcBf2l0z
         ETL85wemDc9zQM6eSyTr+BWdk5k9OCbk5UTgSso3FTOQOHJow0nIKEGNtf2NpXCyMbU0
         J8udRruhmepFC4gqOs+qnkfEQIlDnQEpFceWWaRMmwn1PKJkaUEacb1gic0kVcpaHWjf
         jOkFEgsS5BebyRU/zOvBOFIMnQHQ72vV910OuWS2sAqgVy3Xb/As4m8YajD/vpXSuf8r
         jljA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=j/xy20XFf1kHy8TR2k7muZOA2WshcHFFaw2UWxVTMgk=;
        b=6iecP5ds4t/+1hF2wHhrE2x1kh8HlZ4WJv0+6VbfiGCRxod/Fdz97aF0xLDAFNopTX
         wa16SWaljB0g43W5WDJC51GpzOv05pZVYf6lswfx0156VYo4P3SYiQ5PJ/jZrlzUsc22
         BZGEUmr/wfBidj/R5jfVydQ2igQRi/3KuXw56vTeL3Ek5S8MJS9b6YR5MDrCoQsfzbV6
         i/O4xgBaVzuCLo8F73IJ8tHTy06gpg9y1IzGD2KhSxMkaQLiuIOflEHSoXQZ6QfwmRRv
         NapMUDTDzse/4t//bLS8pV85Z8+zH2yoO0yovjHO+jpbCXjcyhtQlt79HD7vkYvyChWb
         x5Vg==
X-Gm-Message-State: AOAM531TG6zNpoAjo21tDSpuhRFGoMz9rKlwy8Wmko06BEqim3vBdc2I
        vhp9JHwIcEKyAeN9DMPVvAOzRlOSNh0f+Wq9rbA=
X-Google-Smtp-Source: ABdhPJwNhFxkCvVlV8y+iK9Ul03/VtRStEFCETyCSPX6xHbnwX1E60SzMOCuU0MS2deJLbXUCJ21yD9Ns0y8g/2cMGw=
X-Received: by 2002:a6b:e20a:0:b0:648:b6aa:6615 with SMTP id
 z10-20020a6be20a000000b00648b6aa6615mr15386707ioc.209.1648768372802; Thu, 31
 Mar 2022 16:12:52 -0700 (PDT)
MIME-Version: 1.0
Sender: yagboyaju28@gmail.com
Received: by 2002:a05:6638:f95:0:0:0:0 with HTTP; Thu, 31 Mar 2022 16:12:51
 -0700 (PDT)
From:   "higginsnigel.ceomydesk@barclays.co.uk" <nigelhiggins.md5@gmail.com>
Date:   Fri, 1 Apr 2022 00:12:51 +0100
X-Google-Sender-Auth: yl7YRpETFv9oEBVWVBiTT0S_HXk
Message-ID: <CAH1v_Ja4u+T-eadf9nnCmQbkKA-jKw3KDsi43cmTp3R0dQPdQA@mail.gmail.com>
Subject: PAYMENT NOTIFICATION UPDATE
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_SCAM,LOTS_OF_MONEY,MILLION_USD,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d35 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5005]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [yagboyaju28[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [yagboyaju28[at]gmail.com]
        *  0.6 MILLION_USD BODY: Talks about millions of dollars
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  1.1 HK_SCAM No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Dear E-mail User,

I am Nigel Higgins, Group Chairman of Barclays Bank Plc, London UK. I
would like to inform you that the British Overseas NGOs for
Development (commonly called Bond) has instructed our Bank, Barclays
Bank PLC through my desk to issue a Bank Draft for $1.5 Million USD
only in your name. The draft has be raised for the same amount in your
name. A copy of the draft will be sent to you for your perusal as soon
as you contact me with your current address and direct telephone
number.

The money is a humanitarian service for those less privileged around
your locality due to the Global pandemic and the crises in Asian
Countries.

Looking forward to hearing from you,

Yours sincerely,

Nigel Higgins, (Group Chairman),
Barclays Bank Plc,
Registered number: 1026167,
1 Churchill Place, London, ENG E14 5HP,
SWIFT Code: BARCGB21,
Direct Telephone: +44 770 000 8965,
www.barclays.co.uk
