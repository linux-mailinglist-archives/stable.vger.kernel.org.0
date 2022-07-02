Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62E056417A
	for <lists+stable@lfdr.de>; Sat,  2 Jul 2022 18:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbiGBQa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 12:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbiGBQa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 12:30:57 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA7CE09D
        for <stable@vger.kernel.org>; Sat,  2 Jul 2022 09:30:57 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g7so5450506pjj.2
        for <stable@vger.kernel.org>; Sat, 02 Jul 2022 09:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=2Eru+hOoOi2VGzBsLVHaFvHpaUzKcSX0qaf8f04LjOw=;
        b=EJCuaLrS6Rmk0fHkLykdkB8A88a2RC9ViyjhvrggumTKfytOBMBPuQSCd82Y+wHewO
         3QU8XQTolFrxGNhH+LznuvOln3GAxqunfQhygPKqFBQF+/0aO+svNfFAg59LEmuhwxZb
         zzMFikMfhlxxuZDorLzJpRI27PgoC+jk5nCP8TnQhWjBAsGlNTwNEXvsXKoI9Vs4cQ/5
         28HCAoyhYrqLVGffs/bRZHdVvegMeGv8t03B0EYkG/V3nz0r2scBNj0JCs3/W16BtptF
         CKSNb5HjACFr5apKynilkdLERAixbWjaLxCl/npzGBHqvSglQKKKERlS64uMj6T+J5HW
         YObg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=2Eru+hOoOi2VGzBsLVHaFvHpaUzKcSX0qaf8f04LjOw=;
        b=U8tCvknbsl2J/E4AarFfpVExmSNtmorY8oXgktM7OvvnXpjO2T7fJAHwN5fRSMDVap
         7J9vt5Y9ugkNze0qh/ic6Z/5ocToFyzqCS3PKCA5DDj2UYWdJCHUM2KLqccqfgewX/Ie
         7r/TJyDMcs9moobwpIYS10Wtz84IaM03H9yeHnnSq9tgKbCGROo7T60ECSeRA14BE5fl
         oCTAcqX/fISUE7TtxE7SMYqFeEWqfhlFXo0+mzsTNzp+Nlf9BL3nIbgdqgSF1mfr9UU/
         f0UdoEZ1BWBSJEDLsYoYQs1ec0ML+wkRXSNiLw6f+6N0eERLYNxckaTp8SRYyYjFuxX1
         skVQ==
X-Gm-Message-State: AJIora9G96an+uj/Pnx4YEJD37UmNmj0CY6KSapcpvcJ1ZRz8P4L+U+/
        zPnli3LuF578ScuJKqU0aYgSnpesbGSII4mtP00=
X-Google-Smtp-Source: AGRyM1uAKP4omCPz4ORbqG65f38Z2iTPKYBW0FGvp/J+wy0ocZJO/F4iJaWSFSjV3pX4Gabd8YOY6uyKs7QinLAtwbc=
X-Received: by 2002:a17:902:d542:b0:16a:5016:7a18 with SMTP id
 z2-20020a170902d54200b0016a50167a18mr27576861plf.94.1656779456496; Sat, 02
 Jul 2022 09:30:56 -0700 (PDT)
MIME-Version: 1.0
Sender: amakpuohafia@gmail.com
Received: by 2002:a17:90a:928d:0:0:0:0 with HTTP; Sat, 2 Jul 2022 09:30:55
 -0700 (PDT)
From:   "Doris.David" <mrs.doris.david02@gmail.com>
Date:   Sat, 2 Jul 2022 09:30:55 -0700
X-Google-Sender-Auth: R2xLFJzVUWQdTdOUGBwgkh5d2gk
Message-ID: <CAPK2mwHAyvo5LGBpuPTaQ1zpe5xb=-vK-xCdTrTAQjpLNb+eMw@mail.gmail.com>
Subject: Re: Greetings My Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.0 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:102b listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrs.doris.david02[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.5 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings,

I sent this mail praying it will find you in a good condition, since I
myself am in a very critical health condition in which I sleep every
night  without knowing if I may be alive to see the next day. I am Mrs
Doris David, a widow suffering from a long time illness. I have
some funds I  inherited from my late husband, the sum of
($11,000,000.00) my Doctor told me recently that I have serious
sickness which is a cancer problem. What disturbs me most is my stroke
sickness. Having known my condition, I decided to donate this fund to
a good person that will utilize it the way I am going to instruct
herein. I need a very honest God.

fearing a person who can claim this money and use it for Charity
works, for orphanages, widows and also build schools for less
privileges that will be named after my late husband if possible and to
promote the word of God and the effort that the house of God is
maintained. I do not want a situation where this money will be used in
an ungodly manner. That's why I' making this decision. I'm not afraid
of death so I know where I'm going. I accept this decision because I
do not have any child who will inherit this money after I die. Please
I want your sincere and urgent answer to know if you will be able to
execute this project, and I will give you more information on how
thunder will be transferred to your bank account. I am waiting for
your reply.

May God Bless you,
Mrs.Doris David,
