Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83C050F007
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 06:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244109AbiDZEuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 00:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiDZEuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 00:50:32 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052BA37003
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 21:47:26 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x18so23722812wrc.0
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 21:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=wOncCm4D5xaKJK+xUihNEE4S2KHHwIL9rFi6rUKg53w=;
        b=ZXx6rCgU8U64M6ndJX0OIIi8muJmths3Rek451RmxlvnpHC1oykT14WYsyfsu7mNhp
         sBqQ7/hEMo72OfKQ4gPYKHEsXoBymizI2vq8P3czpC9fJVWFyyB6HmOpDhPLlrAYI+29
         d/hiRQNXx8AD7c5gaNwbc19bPAs/GJoDh9YrgZcNxyNAQvQfp7DwOHeH5js0wlXhZ8Wb
         ehIJi1yhxJcSyYC2Dca7qrTBAxUiOwyMyE93HOSdS7pn9++0CKIP5eNxvYhSmzxFGUlX
         BCXfkrVNg3f94fYE/8RDnHPL2Is/pqZnPVNM5oIpwR2dneXEqB+xN8KrGMzLkfQ7aaix
         OEyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=wOncCm4D5xaKJK+xUihNEE4S2KHHwIL9rFi6rUKg53w=;
        b=2jcZZPqh8Zazs/LhIjurt0CtMyT02bF3ox9CumDlKofR07c8cnof07IwDESHUHXHN1
         pEK4nAf6viJN0dKjYGxTYGJX9Twa7Cn+gLeD3rvYLDOL0p5SObbfxggnG5pdd+jpzORA
         SmY9MNqqNfPB0g98o7TQBFWlF3H2dRKca9jF2L9C2xpjMf90usYeMbINwdLtbQXw6wLm
         r1TdPIJwMgy4q7i0Ps137t4LVeZ3TnB1fxBNLyXdqdMNZxmqOWSalHDfnNJ2xsnd3ZT/
         Fa97k6NpGjHZUYUEukefmP43GFeAtA0txpZCMtgdGI5io0K8fUZOUvMS91P7xFnNOv0p
         FLsg==
X-Gm-Message-State: AOAM530EUfvF3TOVXj48Z75oWinztxWs1KTPH4racmUVR8qeEJupQcmr
        5ahRR7xFRYh2vPVyUyT266I=
X-Google-Smtp-Source: ABdhPJykqyYcAexPlClCIYDR3UYCq4hzzjO5HF5BjHILpLLf0nz9A8XETayC5XN79cPQ+RDCUybarw==
X-Received: by 2002:adf:fc52:0:b0:20a:e296:6e8a with SMTP id e18-20020adffc52000000b0020ae2966e8amr2249000wrs.432.1650948444545;
        Mon, 25 Apr 2022 21:47:24 -0700 (PDT)
Received: from [192.168.43.217] ([102.89.45.245])
        by smtp.gmail.com with ESMTPSA id u19-20020a05600c19d300b00393f081d49fsm2018745wmq.2.2022.04.25.21.47.10
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 25 Apr 2022 21:47:23 -0700 (PDT)
Message-ID: <6267795b.1c69fb81.47772.c30e@mx.google.com>
From:   "''Sharon Sanosy''" <sillr429@gmail.com>
X-Google-Original-From: ''Sharon Sanosy''  <m.milan@att.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: SANOSYL ENERGY, OIL & GAS
To:     Recipients <m.milan@att.net>
Date:   Tue, 26 Apr 2022 12:47:33 +0800
Reply-To: info@sanosylenergy.com
X-Antivirus: AVG (VPS 220425-8, 4/25/2022), Outbound message
X-Antivirus-Status: Clean
X-Spam-Status: No, score=4.4 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,US_DOLLARS_3
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Good day! I know this email might be a surprise to you, due to the
fact that we have never met before, I got your email contact from
WORLD TRADE UNION and I believed that you will be of help to this deal
I am proposing to you.

I am Mrs. Sharon Sanosy, I need your assistant to help me  retrieve my
late husband=E2=80=99s Fund $500,000,000.00 which he deposited in a SECURIT=
Y
BANK. He was  CEO of  SANOSYL ENERGY, OIL & GAS. TEXAS. My husband Dr.
PAUL POLMAN SANOSY died last year of the COVID19 pandemic, I wish to 
have a deal with you regarding the fund.

As a result of his sudden death his business associates are trying to
rip me off my late husband=E2=80=99s assets and heirlooms which he had left=

for me before his painful demise. I want you to help me retrieve the
FUND from the Bank, as my late Husband=E2=80=99s Business partner.

l ready and willing to divulge more information to you upon your
positive response. Please let me know your thoughts . Kindly reply
through this  email: info@sanosylenergy.com

Yours faithfully,
Mrs. Sharon Sanosy

-- 
This email has been checked for viruses by AVG.
https://www.avg.com

