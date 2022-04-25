Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FD050DF90
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 13:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237409AbiDYMA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 08:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240126AbiDYMAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 08:00:18 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3E9BC83
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 04:56:42 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id m22-20020a05600c3b1600b00393ed50777aso1084824wms.3
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 04:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=7va6PYBEaxzVzOFHDSxBigUPhGrAPiX/eRU/9Co02p4=;
        b=BPzZp+aKMGT7x0BqVNBLAQx5RZmpGtJvaeehktAH1ENzXOd7DSExXv8PIZKVbPGFXE
         kqOsO/xPh0w2niMYEltbGGW9PFKKS1AaL0Z98b0UUSN9FJ+ubLBSgfwdRJh/ZMbkDCE9
         IfkM3HD9BGjishC6xr7eQ8qW1kJi2JJV7Q/xnvrHmPcrlb1QaurjnFhTWl9McaVUQiji
         BJMEFnBoPdmiRQiFTX+ZBwT8yBf26ayWHqIgmg8Ec1cScuYHY+RmgaAjWkGfG8Ey9vWz
         gyLKAuegT3n7XtFAlzth9CdJJ3iminenG56MkgVso8ci0tSst8tSxKMU8PYqHPSDfZMx
         A8Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=7va6PYBEaxzVzOFHDSxBigUPhGrAPiX/eRU/9Co02p4=;
        b=pUmyIOs6eSzspGWcOCCfKQs/0jokN9CPj3rhkGLyPD63MK+F+zwAGiAUcF/B1M/eso
         /q+OnD9wA3sE6bFASbwyAqkGuL82+pAvOdcQmp0iifW9bD4Je66PMkfh+1cKPDoyimPM
         QXaRp+9v8gDmq7h2p/WjRv7jzbt8HxQfV/EyVNp+NaRo9M6JcJ0xcJTy7A2FgKPuA4Xt
         zKFoItEvgiyutpi9FaAul1Q6XoVSTbwt8ipCFs57oLaU+zml1W+6sqI6Mk662oX+BSpV
         pBRjFp3ceKcaWZiv/TxIBAK80fLfYm99vWuNOKoQEc15QZeha5ecnUMui8mEDh5ydIoV
         ixrw==
X-Gm-Message-State: AOAM532AnU8BbW6aTADA18SH4WBM+o9exGfFCcox01Z4/TaDqh3NX2Ll
        UtA7CJT+Q2QtZqGW1CjBbGcbTuhC3z6nUGYMBA==
X-Google-Smtp-Source: ABdhPJyefDuH+3+dDfVDtInlzkW3PfxgzUj6HiXOoswY4IJkYYeRlSGpwD+7OVjozYTK7nCI8c9x8tT6ytVXYFkPU1E=
X-Received: by 2002:a05:600c:3789:b0:38c:bd93:77d6 with SMTP id
 o9-20020a05600c378900b0038cbd9377d6mr16670005wmr.12.1650887800406; Mon, 25
 Apr 2022 04:56:40 -0700 (PDT)
MIME-Version: 1.0
Sender: felyikpuckan@gmail.com
Received: by 2002:a05:600c:a07:0:0:0:0 with HTTP; Mon, 25 Apr 2022 04:56:40
 -0700 (PDT)
From:   dr adama ali <dradamaali4@gmail.com>
Date:   Sun, 24 Apr 2022 23:56:40 -1200
X-Google-Sender-Auth: bL-DdHXSfm8xhMrkcSAYSzm-41g
Message-ID: <CACF60Hj0H2tVEX+JUZ3MF6T2yULAxJLsfPq4Au8gMX9keOJAyw@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.0 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_80,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:332 listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8027]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [felyikpuckan[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings My Dear Friend,

Before I introduce myself, I wish to inform you that this letter is not a
hoax mail and I urge you to treat it serious. This letter must come to you
as a big surprise, but I believe it is only a day that people meet and
become great friends and business partners. Please I want you to read this
letter very carefully and I must apologize for barging this message into
your mail box without any formal introduction due to the urgency and
confidentiality of this business and I know that this message will come to
you as a surprise. Please


this is not a joke and I will not like you to joke with it ok, With due
respect to your person and much sincerity of purpose, I make this contact
with you as I believe that you can be of great assistance to me. My name is
DR.ADAMA ALI, from Burkina Faso, West Africa. I work in Bank Of Africa
(BOA) as telex manager, please see this as a confidential message and do
not reveal it to another person and let me know whether you can be of
assistance regarding my proposal below because it is top secret.


I am about to retire from active Banking service to start a new life but I
am skeptical to reveal this particular secret to a stranger. You must
assure me that everything will be handled confidentially because we are not
going to suffer again in life. It has been 10 years now that most of the
greedy African Politicians used our bank to launder money overseas through
the help of their Political advisers. Most of the funds which they
transferred out of the shores of Africa were gold and oil money that was
supposed to have been used to develop the continent. Their Political
advisers always inflated the amounts before transferring to foreign
accounts, so I also used the opportunity to divert part of the funds hence
I am aware that there is no official trace of how much was transferred as
all the accounts used for such transfers were being closed after transfer.
I acted as the Bank Officer to most of the politicians and when I
discovered that they were using me to succeed in their greedy act; I also
cleaned some of their banking records from the Bank files and no one cared
to ask me


because the money was too much for them to control. They laundered over
$5billion Dollars during the process.Before I send this message to you, I
have already diverted ($10.5million Dollars) to an escrow account belonging
to no one in the bank. The bank is anxious now to know who the beneficiary
to the funds is because they have made a lot of profits with the funds. It
is more than Eight years now and most of the politicians are no longer
using our bank to transfer funds overseas. The ($10.5million Dollars) has
been laying waste in our bank and I don=E2=80=99t want to retire from the b=
ank
without transferring the funds to a foreign account to enable me share the
proceeds with the receiver (a foreigner). The money will be shared 60% for
me and 40% for you. There is no one coming to ask you about the funds
because I secured everything. I only want you to assist me by providing a
reliable bank account where the funds can be transferred.


You are not to face any difficulties or legal implications as I am going to
handle the transfer personally. If you are capable of receiving the funds,
do let me know immediately to enable me give you a detailed information on
what to do. For me, I have not stolen the money from anyone because the
other people that took the whole money did not face any problems. This is
my chance to grab my own life opportunity but you must keep the details of
the funds secret to avoid any leakages as no one in the bank knows about my
plans Please get back to me if you are interested and capable to handle
this project, I shall intimate you on what to do when I hear from your
confirmation and acceptance.If you are capable of being my trusted
associate do declare your consent to me. I am looking forward to hear from
you immediately for further information.



Thanks with my best regards.
DR.ADAMA ALI
Telex Manager
Bank Of Africa(BOA)
Burkina Faso
