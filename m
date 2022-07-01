Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2247356314C
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 12:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbiGAKWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 06:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbiGAKWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 06:22:51 -0400
Received: from mail-yw1-x1141.google.com (mail-yw1-x1141.google.com [IPv6:2607:f8b0:4864:20::1141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8912E0A8
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 03:22:51 -0700 (PDT)
Received: by mail-yw1-x1141.google.com with SMTP id 00721157ae682-31780ad7535so18870307b3.8
        for <stable@vger.kernel.org>; Fri, 01 Jul 2022 03:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=zkRKKkHvNmeWqvRVOQLK4rfH21duyawXjkMEAhn/9YU=;
        b=CVPLrDXHoypB5/Cj7KOLDhxRz4Ui0yZ+IsE1j9GqfVqotMn9b3WsW6BJXgAmjlajxu
         cvmJQ+5H6WvesjomWH11OTMIb1yfkomD4THoC71ZKtInuK5DEkfcPYHAn7JU2vZuSxpM
         9/MUGiB2+el/IEVOMhagDk5XM9WJD2rBLEO0n3QuCytXLNZeJP+dAS/M5G+CGaQfV2bJ
         Cb3VXZ9Yt2EoUafAeeeW5Q1SPqhQyCkvHoT0NSD1RRvDLrzlDr37C+zLcDbuLVHrCAJx
         Ug/xq2ZJtb+8t/RrF6lADEq9E4c2fLKx7JibNxT3x8w8l9Jv//g+Guwpg0bht2rGmgAf
         CJlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=zkRKKkHvNmeWqvRVOQLK4rfH21duyawXjkMEAhn/9YU=;
        b=a9goTVhHz6CUziIAyN6k8dykpHDVmTyLT4J8CQbD0dhsDKIS0Bqt7tLMQxLQSv9lbC
         uX1BOLtuheFU4ktJg0kZPgjW04jCbziCbep5v8k9uI+kGj26VyjWOI1UrtfpZh8uyzhK
         Zpdvo/rAhlgc1BcX53j/EBTpqCKSTdqil2nLowuB9D3J5/D+qDsSgw+yMdHYIZXLPVRa
         esQ0kX64FnMbiJ1PgczOcC/6fUa7n2Rkv3VvzQhv1hLEFWbtjeD2DhqkQvOf2UYi2kpQ
         +HFVFSq4S60v7FJ5VG8YJenm2Te0BHkYf3f389unQY1sPdzDoD2Ltwbo4llEMKZ8Qj7F
         hxBQ==
X-Gm-Message-State: AJIora80I7EAk83o+lmHJrszVz88Ur2V/xBOXvHUbRLhpUMeLrjiZSOi
        U+xRVdUp1lxdzSIXf1EV3iJIBYI7Dlatnm3o66E=
X-Google-Smtp-Source: AGRyM1t18FRG+a2OhGp9Qo4ddKlr+gca8IW4bI26kf0lOpEieOsyvQIfhVCCkX/Cr/b8uAPsFqYfVQWRYumSJz1JDPs=
X-Received: by 2002:a81:2358:0:b0:2ff:995a:a536 with SMTP id
 j85-20020a812358000000b002ff995aa536mr16304497ywj.429.1656670969750; Fri, 01
 Jul 2022 03:22:49 -0700 (PDT)
MIME-Version: 1.0
Sender: samsonka22@gmail.com
Received: by 2002:a05:7000:9993:0:0:0:0 with HTTP; Fri, 1 Jul 2022 03:22:49
 -0700 (PDT)
From:   HANAH VANDRAD <h.vandrad@gmail.com>
Date:   Fri, 1 Jul 2022 03:22:49 -0700
X-Google-Sender-Auth: nM4n2Har7g2Nk_NEmPcdwpcPNyI
Message-ID: <CAKY8iZrd6qXo0jChbRyXpFvdtvj63iwOHQvxStofzadBtZ_SJA@mail.gmail.com>
Subject: Greetings dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.3 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1141 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5001]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [samsonka22[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [h.vandrad[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.5 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings dear


   This letter might be a surprise to you, But I believe that you will
be honest to fulfill my final wish. I bring peace and love to you. It
is by the grace of god, I had no choice than to do what is lawful and
right in the sight of God for eternal life and in the sight of man for
witness of god's mercy and glory upon my life. My dear, I sent this
mail praying it will find you in a good condition, since I myself am
in a very critical health condition in which I sleep every night
without knowing if I may be alive to see the next day. I am Mrs.Hannah
Vandrad, a widow suffering from a long time illness. I have some funds
I inherited from my late husband, the sum of ($11,000,000.00,)
my Doctor told me recently that I have serious
sickness which is a cancer problem. What disturbs me most is my stroke
sickness. Having known my condition, I decided to donate this fund to
a good person that will utilize it the way I am going to instruct
herein. I need a very honest and God fearing person who can claim this
money and use it for Charity works, for orphanages and gives justice
and help to the poor, needy and widows says The Lord." Jeremiah
22:15-16.=E2=80=9C and also build schools for less privilege that will be
named after my late husband if possible and to promote the word of god
and the effort that the house of god is maintained.

 I do not want a situation where this money will be used in an ungodly
manner. That's why I'm taking this decision. I'm not afraid of death,
so I know where I'm going. I accept this decision because I do not
have any child who will inherit this money after I die. Please I want
your sincere and urgent answer to know if you will be able to execute
this project, and I will give you more information on how the fund
will be transferred to your bank account. May the grace, peace, love
and the truth in the Word of god be with you and all those that you
love and  care for.

I am waiting for your reply.

May God Bless you,

 Mrs.Hannah Vandrad.
