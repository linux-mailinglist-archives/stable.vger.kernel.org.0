Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9628594A43
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351282AbiHOX6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346922AbiHOX4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:56:39 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8FF164408
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 13:20:08 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id f192so7505823pfa.9
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 13:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc;
        bh=Pk0lndCs1Bsv7Vzz7KkYpvP0/Q3YOhQIYRP6EPyT3Jg=;
        b=YGUfPUtiq8C/MkHAiTbIyWVxXKtR5TaFtqIZcZLjHy1k7E4oORbmSWLIlCNtdXaymR
         z4gBps8Zdlma12DG97Obwmia32XT8MPmXlKYlejJW/eQ4j2htKvIBUiqrehSLbIf0+u2
         oFX7Wi7B8ZVXNOaiIotEYZkS16zWrl/EqaTblN2TlmOIA5eoxDy0OkGD8kee4PTlPa89
         82wHclGYPpW0A4V0IXNCrFJFSPtrNOOVXMiJDtlspcq7Tj6+sNHCTZjYneAVu9U9rpzr
         EwAIjsVu55bNPfaIr+J8lhUOBKRxk+X0ylp5Vj4H3U3COVX6diRJMqe1Egz0tIy0hdnB
         Ix4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=Pk0lndCs1Bsv7Vzz7KkYpvP0/Q3YOhQIYRP6EPyT3Jg=;
        b=XtoLrFPrCI2iWRW0KrYVRmJgczeXyhnaBK8SqGqPP00bnyUPK2Yfo7TzYiB41+W/1y
         DSooOU5DTCfDrVDRiTFAU/mDUptNWCOnPXFDFUcilpq8r7PA5CDU1OiETVcWj+/7lXwG
         3NBDzQckxBVjeRFDvHBcnklyFpYg1Dj1aqdbNgj5Hfm2SNIx6lB2RBG7QWwBEE40GaF9
         MhxU1FizOcVekakiPCSGWnqYh76/gPCXZdSuyu+UqXvIdeSkRyKSqXJxuEGU/OjcqXR9
         3UPf64CVGtqQJbB+sLmA/pXAfXVN2Fvou9yrGJRWP49SmIw6DtsnB0ZHKFCNR4dEaCrB
         VXoQ==
X-Gm-Message-State: ACgBeo2Q1s4Xz2Nh5tPYgISFPaN8Nv9hJnEWZoMwp1lrmU5UshagTm56
        L5nn8guGyQeLzwV+NO2TxLunD/Z9tm2LcRs590I=
X-Google-Smtp-Source: AA6agR4eZ5NcqtTejx95oUWwLhiuEUW72pJ/Kc2bbTKSTTYJsADlSlhDtjBOeGIt+lFff3Nv+6udsYws1lOBpDt4jZ8=
X-Received: by 2002:a05:6a00:1641:b0:52d:3dde:73c5 with SMTP id
 m1-20020a056a00164100b0052d3dde73c5mr17859608pfc.24.1660594807932; Mon, 15
 Aug 2022 13:20:07 -0700 (PDT)
MIME-Version: 1.0
Reply-To: salkavar2@gmail.com
Sender: iqbalfarrukh70@gmail.com
Received: by 2002:a05:7300:c97:b0:71:f17a:8eed with HTTP; Mon, 15 Aug 2022
 13:20:07 -0700 (PDT)
From:   "Mr.Sal kavar" <salkavar2@gmail.com>
Date:   Mon, 15 Aug 2022 13:20:07 -0700
X-Google-Sender-Auth: LnKxhh4A7ybHpED3XummZU4nUcU
Message-ID: <CAB5UVAcnnysVeFKz5Lhj60qE3OS7fKD26GykZjxRnFKqjQ4_vg@mail.gmail.com>
Subject: Yours Faithful,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MILLION_HUNDRED,
        MONEY_FRAUD_5,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS,T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.7531]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:436 listed in]
        [list.dnswl.org]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [salkavar2[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [iqbalfarrukh70[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [iqbalfarrukh70[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.7 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  1.8 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 MONEY_FRAUD_5 Lots of money and many fraud phrases
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I assume you and your family are in good health. I am the foreign
operations Manager

overdue and unclaimed sum of $15.5m, (Fifteen Million Five Hundred
Thousand Dollars Only) when the account holder suddenly passed on, he
left no beneficiary who would be entitled to the receipt of this fund.
For this reason, I have found it expedient to transfer this fund to a
trustworthy individual with capacity to act as foreign business
partner.

You will take 45% 10% will be shared to Charity in both countries and
45% will be for me. I have decided to confide in you and share with
you this confidential business.

Yours Faithful,
Mr.Sal Kavar.
