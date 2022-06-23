Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7025578D0
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 13:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiFWLgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 07:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiFWLgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 07:36:04 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD124BB8B
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 04:36:04 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id m13so4096430ioj.0
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 04:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=lp5Ki9jCdAEKAL/BIdLF4ecoeZC99gwKjjFWmT5NI5k=;
        b=Cod9I1x8gCmbw9fCFdffdTB6Tey12x5nxgs0VZx3GuXMWHoM3VyYCCM1HZgSGVynCe
         gc5c9k8YkJgDEGNPFgXrRb+B/BJk9P3ze7BVg75pGWPEigauExf8KubXOS0aIAWU1aLA
         KY+h0CXXrxFoMS5YpE55gqirUqXl0phi41ZHr7zOnLfOSZ46PIoVyOQZ7NlDd2HiItt5
         EeMh4V3Zznwd4cFIGiZS44HL0eaeConx1bSm2/6o+PZw+1uKemZ5W1HjY5xFV6pGTx5l
         icP5BdkOuYaA3VC+rDJ/+TpfHUEWNC7U4sUWnvkKREdGWenzJzFBvUbNnYL1Gnp7X2Zw
         lE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=lp5Ki9jCdAEKAL/BIdLF4ecoeZC99gwKjjFWmT5NI5k=;
        b=gMSl2/2pWkU7XBCeCw+NuduDQ0WFohK2oKEEl7yTENS2DvuWStsazLNk9502BiFxzQ
         msDAK9KpLP3U4Yb6nN4a185OJakKsmmpal1DtOwvKu8dOJC2s1M0PAqmUNFvMOAa4vOC
         gr/MbBMzl0m1WCbd0FBz6wZjxtUTnyfv4qREEVKmhltjAHhq6YpTK2vzGeSLdg9EsC3z
         y1Yuc4em/gTz73P7GQEzYXKimy2lj/K1yoUifL4WPLTSZEAgHMbZ2fS1f3U6+AWY+MnW
         5W+H+Sp99YJ50/Ixz/fx/tXkiAOVtP4YE2LLlONwml9iOD/NXXVhyX9Etp5lxAYOyq9x
         Y00w==
X-Gm-Message-State: AJIora/mZ9mEwt+ozJdVs2OszN/x0MnAI5oZIrcOpmnV6l3aih6Tal1r
        RX15bO0eSAU1HQyXYIGyvhOrLtKkrKyS3OPKFQ==
X-Google-Smtp-Source: AGRyM1vcG9S8ba74g4OwItEe2OFmYqs2YHQAKLKkFbO2PleZ3Ayt9LBzhO5tPcb4mxPyLM6UyIsHTmAcgeZJ+lqti14=
X-Received: by 2002:a05:6602:27cc:b0:5f0:876e:126b with SMTP id
 l12-20020a05660227cc00b005f0876e126bmr4425100ios.129.1655984163684; Thu, 23
 Jun 2022 04:36:03 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6638:3d08:0:0:0:0 with HTTP; Thu, 23 Jun 2022 04:36:03
 -0700 (PDT)
From:   robert anderson <robertandersongood12@gmail.com>
Date:   Thu, 23 Jun 2022 11:36:03 +0000
Message-ID: <CAEbqAVQYOgUeuAtmq6ZbzaA5i=gVk5z-Ow7deaYz8uHawKfSnA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.1 required=5.0 tests=ADVANCE_FEE_3_NEW_FRM_MNY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FILL_THIS_FORM,FILL_THIS_FORM_LONG,FORM_FRAUD_5,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLY,LOTS_OF_MONEY,
        MONEY_FORM,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d35 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5306]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [robertandersongood12[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [robertandersongood12[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.0 FREEMAIL_REPLY From and body contain different freemails
        *  0.0 FILL_THIS_FORM Fill in a form with personal information
        *  2.0 FILL_THIS_FORM_LONG Fill in a form with personal information
        *  0.0 MONEY_FORM Lots of money if you fill out a form
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  1.3 ADVANCE_FEE_3_NEW_FRM_MNY Advance Fee fraud form and lots of
        *      money
        *  0.0 MONEY_FRAUD_5 Lots of money and many fraud phrases
        *  0.0 FORM_FRAUD_5 Fill a form and many fraud phrases
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Congratulations!

The United Nations has concluded that the payment of a US$6 million
($6,000,000.00) compensation fund to fortunate beneficiaries around
the world with the help of the newly elected President due to Covid-19
(coronavirus) , which has led to economic collapse, cheap different
countries and global danger to so many lives.

 The United Nations has instructed the Swiss World Bank, in
cooperation with the IBE Bank in Great Britain, to release the payment
of the compensation fund.

Payment will be made out on an ATM visa card and sent to the lucky
beneficiary who applies for it through IBE bank in the UK via a
diplomatic courier company close to the beneficiary country.

This is the information UK management needs to deliver the
Compensation Fund payment to the beneficiary country's doorstep.

1. Your name:
2. Home address:
3rd city:
4. Country:
5. Profession:
6. Gender:
7. Marital status:
8. Age:
9. Passport/ID card/driver's license
10. Telephone number:
Contact our agent email id:
Name Solomon Brandy

EMIL ADDRESS (solomonbrandyfiveone@gmail.com) for your payment without
any delay,

Best regard
Mrs Mary J Robertson.
