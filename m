Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A655B27CC
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 22:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiIHUhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 16:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIHUhG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 16:37:06 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138B51023DA
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 13:37:06 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id u9-20020a17090a1f0900b001fde6477464so3422684pja.4
        for <stable@vger.kernel.org>; Thu, 08 Sep 2022 13:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date;
        bh=qvaOK6j3PxKP4j5xD7XFiriqToq7K2JMUEKsHJLivrk=;
        b=T2teUqFLVeDwCASHIvmjVIwy4w8gW86XzEKRn7knzqWutN5vv40KvjKNzMJcsjuKnn
         uG58WnKi1GsbZtaHYEXckXjNUO0jnPziBtPifmAIF5ZDJwYKZghgRo42b5WbL7xXVjuq
         nFYYjuWMJLqkc3LutWmBtwQ2vqPJzhNkq7smU6VcE2VafaRn60gOMP+sRSZDuSVA0Agw
         h9+Q9DuH0H5pZfeUqKn/JU4O9XwGen4895cAqYiSK/Bw6uEwLZ4uG0TVAdxxLdEuhrOc
         RrRM6gJ3WNknGQZtUhEziVqPwpd0SBLiSQsaRtjZDvFj9WvfNcAeiYPz/fzr6ACSUK7Y
         hofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=qvaOK6j3PxKP4j5xD7XFiriqToq7K2JMUEKsHJLivrk=;
        b=oftrBs5DRCQJSVxgX7Bs4vC5PgOLUV3//6qC5P+XGbWqT0BJXgASkvQNMlO3z9W6Jq
         /mE+VX077ft5EVpb/gHNi+nyPW2XFhI/RC25AqLSOBuAQQQ2Kz86UZbMlQt8AGgvtmVc
         /I2oEvUbstmUK8T5uiYs/13tTGbN8VDvdbmWRxExxiWPbkd/+RlrCe1GgnOgWwW+j7tu
         ZxBzT5Zo7BChg1jWh88hEpdhhZ9IoJMVsFj2m7SM3wIrBffrZvkTTAWLXkvmCs5PHYnm
         M0/Ql17+TYq/ftMWYcff4XLmqdfQOuGt063/ziJh1I1Xfon2n6kpS62akZ00VXe/oT7V
         acWA==
X-Gm-Message-State: ACgBeo3IBM7zd8zbfFUjP8F00sGf29sDYW3O8dI4PGliBhd+a8iaZTcl
        /h25yFcWjUyzrSNG89BYR8Cv8nYn8Ro23tjWXME=
X-Google-Smtp-Source: AA6agR66H23IZkOtbeX/en5zH+CGaUWf7MFl+cUyI+0vx8hmvH19SSQyKP6SljCubjlm2Tyq9vMcb27beYEKd3Erbog=
X-Received: by 2002:a17:90a:4402:b0:1fd:c07d:a815 with SMTP id
 s2-20020a17090a440200b001fdc07da815mr5769698pjg.188.1662669425407; Thu, 08
 Sep 2022 13:37:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7300:7492:b0:77:9efc:8484 with HTTP; Thu, 8 Sep 2022
 13:37:04 -0700 (PDT)
Reply-To: mariaelisabeth84697@gmail.com
From:   Maria Elisabeth <samueledim2019@gmail.com>
Date:   Thu, 8 Sep 2022 13:37:04 -0700
Message-ID: <CAMM+MpBD6QedrAPV9PTO5Lm98o5UAEbjrZH4FXEeMU2nqc1OeA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1044 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5600]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mariaelisabeth84697[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [samueledim2019[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [samueledim2019[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Hallo, guten Tag, ich bin Frau Maria Elisabeth Schaeffler, die Spende
von 1.500.000,00 Euro an Sie steht noch sehr gut zur Verf=C3=BCgung, was
ist das Problem?Kontaktieren Sie mich, wenn Sie verwirrt sind.
