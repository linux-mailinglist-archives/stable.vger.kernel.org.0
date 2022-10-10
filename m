Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1935F9BC8
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 11:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbiJJJWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 05:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiJJJWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 05:22:10 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA026554D
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 02:22:07 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id b5so9838749pgb.6
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 02:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PXUl3DqLFbTtFtCoMEclQM3ZbKkw2ZlACbyEiXC/hso=;
        b=frjGwOUN/C461E38SP1EgstF5HxS7j/JvR0EZ67URwvAq8iMIVFBEWHguG4wLx7NW0
         yOkyTUi+SIz/W82FFvCTcAlvAOA6vzE9cPg5vqolF2QzfgC+7L7FC3fd/vQtMuIgdi4F
         8gLAW0zEX6xnZZyZDOTb6E7qqag+uJwl2WNv7z+CIVuM62lN0EtSHYDrV9KZk+eDiCk6
         ec8fz5laVbDmbjmM6lqbzt5C7iAEHpbQqJAIb2HiCTVGJMSRwLVjc/+CZiLNVsmiWVPI
         IH9pzPvz0RepA3miGprXi/0sQCj8g8+ewgQsI6wJ0c4C3xu9X2pqCEOJdaIZrkCVMOHB
         SIHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PXUl3DqLFbTtFtCoMEclQM3ZbKkw2ZlACbyEiXC/hso=;
        b=vhhzQ9yhOW9RmtEoJ8t2g2z3aq7N1L/kyRDaUlcM8PkNe8BGkeX+OgUzTJPbSLSCtd
         cLMOQfTFRSswtWWtq4qNVpWENtzuFA2LobUPOLxfjJoPkfj62/MOfgpiZcswOwVpCUqB
         2bradvsc+Q5Jc6rmNwGtON1hXxJlpfOkdtCWrUiQl96/FIj5zS45pCw3BVjwtBTjPqCm
         x6XCoC68dJHLrHxqOj266l3OPT9mhpzZHzxLgaAcYg/2tj0wnDw2ndIrIVFgJKBOADgP
         Jstq29PCIlSIXsGeXyHna0cG7DxkJh/++kw36HFpxD20mFVt8lf3czwJaydudZxdv5PP
         uVog==
X-Gm-Message-State: ACrzQf3LlrKzJSG11+uTuZofcASpjDVUQlZrYB1zD/hYuIrpcV7bMmRf
        lcCmaeGJ7YWLepCBCdt4b3PHTyFCDIi4fRoSGDc=
X-Google-Smtp-Source: AMsMyM4/DtCbW1dGOJ5Q/4VkSDD2DqLInlGBN3ni8skZ/GbS/Q0+QRilpgJJ17iFtSIpjz76MJuG/pGOABiBgULOvxI=
X-Received: by 2002:a65:6bca:0:b0:420:712f:ab98 with SMTP id
 e10-20020a656bca000000b00420712fab98mr15922210pgw.350.1665393726096; Mon, 10
 Oct 2022 02:22:06 -0700 (PDT)
MIME-Version: 1.0
Sender: chijosco1990@gmail.com
Received: by 2002:a05:7300:760c:b0:7a:d83b:ebf0 with HTTP; Mon, 10 Oct 2022
 02:22:05 -0700 (PDT)
From:   "Mr. Ibrahim Idewu" <ibrahimidewu4@gmail.com>
Date:   Mon, 10 Oct 2022 10:22:05 +0100
X-Google-Sender-Auth: pMGLQY9BfDmbv7Cfb42B9ahnwX4
Message-ID: <CAMsCVzDauCOwsoHTpmMhsJXugz=F6=5wF02h3uimWfO5=aNEGg@mail.gmail.com>
Subject: I Need Your Respond
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.2 required=5.0 tests=ADVANCE_FEE_5_NEW_FRM_MNY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FILL_THIS_FORM,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,HK_SCAM,
        LOTS_OF_MONEY,MONEY_FORM,MONEY_FRAUD_8,NA_DOLLARS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,T_MONEY_PERCENT,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:52e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5362]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ibrahimidewu4[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [chijosco1990[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 NA_DOLLARS BODY: Talks about a million North American dollars
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.8 HK_SCAM No description available.
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  0.0 FILL_THIS_FORM Fill in a form with personal information
        *  0.0 MONEY_FORM Lots of money if you fill out a form
        *  2.8 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  0.0 ADVANCE_FEE_5_NEW_FRM_MNY Advance Fee fraud form and lots of
        *      money
        *  2.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

HELLO..,

My name is Mr. Ibrahim Idewu, I work in the bank here in Burkina faso.
I got your contact
from internet search i hope that you will not expose or betray this
trust and confident that am about to entrust in you for the benefit of
our both families.

I discovered an abandoned fund here in our bank belonging to a dead
businessman who lost his life and entire family in a motor accident,
I am in need of your help as a foreigner to present you as the next of
kin and to transfer the
sum of $19.3 million U.S dollars (nineteen. Three million U.S dollars) into your
account risk is completely %100 free.

This is paid or shared in these percentages, 60% for me and 40% for
you. I have secured legal documents that can be used to substantiate
this claim. The only thing I have to do is put your names in the
documents and legalize them here in court to prove you as the rightful
beneficiary. All I need now is your honest cooperation,
confidentiality and your trust, so that we can complete this
transaction. I guarantee that this transaction is 100% risk-free, as
the transfer is subject to international banking law

Please give me this as we have 5 days to work through this. This is very urgent.

1. Full Name:
2. Your direct mobile number:
3. Your contact address:
4. Your job:
5. Your nationality:
6. Your gender / age:

Please confirm your message and interest to provide further
information. Please do get back to me on time.

Best regards
Mr. Ibrahim idewu
