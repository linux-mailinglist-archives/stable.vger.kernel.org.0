Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE256515C68
	for <lists+stable@lfdr.de>; Sat, 30 Apr 2022 13:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiD3L0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Apr 2022 07:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiD3L0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Apr 2022 07:26:03 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA81B56207
        for <stable@vger.kernel.org>; Sat, 30 Apr 2022 04:22:41 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id w187so18649593ybe.2
        for <stable@vger.kernel.org>; Sat, 30 Apr 2022 04:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=PNE0aOwENtjgmfgA03oVzYUra/eECIUAF32n8Uzccvg=;
        b=FZ+deiVXnic78XIh23j8JbeYB9+OWn/iR+kDmjHdZ+mlP+kj1bAzr+DSz7KZLfynvC
         Kc+Mti/6JQvrNFCINKTRfumu1nlYeAhBrGP2VgQ2JJlnGDUJzj5+oojcPTqa9Vng2NZA
         mu6a9Ez53OHtvJnIanfcYs7/TPNFYqWPhtlNUBaFUOxKqYno91f666NbTGeqlRkfWYH9
         KMLZf8LtHsS0Hi7DbCb+X/zZBgFPWhU+Rewa/uHiE18dM0Mt8BC5RoMCEcIpyTj9A/IS
         rj/WSmUXJ6HWpsz520z/+f+gRUaitomyZLY2B9w6ClEmXmlhsCmTMtqiP8vcvlyIBws+
         ePjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=PNE0aOwENtjgmfgA03oVzYUra/eECIUAF32n8Uzccvg=;
        b=O2/4z46pHStHP9TTkhJ+vXt/PRvrvwHPLLoYuUTu5hOFkGLSizwNjc47yOkVKoeo8l
         osm2k4wH0081Aif5t9J+S2Ev99c5B7ZGDTw1hU/JrAb0k6Ln2XI7y1SqHDwXfdSm9PzG
         gN6DxnbHrZvusSMuIwCC636aDcNuSXaSJoJbyeZQau4jEqTGHWVgrvoJnYwtShL6UhJ/
         EcBCfD4CCQnGvVJt/6kiMiocAHcNBS4//1Puh4FjVwj63mRo9AtjWvFsT2zN9b2pdHCB
         vVZ8CGpddP8OBkUqcT8gqvW2vamWyDspu8q038JsgOdmbeIrbql4KZc0dyqcUtfzYzKo
         8JEw==
X-Gm-Message-State: AOAM530ddxBmrR0ZOi+fvPRvnSw2fhej7KRwT93H7lca8iA4yorkB8K+
        AdVpPRtxGS4NuuPtdzVdxyNK2qEStvIYVtBPspU=
X-Google-Smtp-Source: ABdhPJzWlmr5YQF7FJIBd6r7P2UX6UGJEQCU20HvGOpAZAihTrAd6rDlI4KWabfHGetVug75NXktsUFtDnLAu9yP0UY=
X-Received: by 2002:a25:4b43:0:b0:649:563f:df2a with SMTP id
 y64-20020a254b43000000b00649563fdf2amr804053yba.290.1651317760917; Sat, 30
 Apr 2022 04:22:40 -0700 (PDT)
MIME-Version: 1.0
Sender: ibrahimvivane65@gmail.com
Received: by 2002:a05:7000:8a0e:0:0:0:0 with HTTP; Sat, 30 Apr 2022 04:22:39
 -0700 (PDT)
From:   Sophia Erick <sdltdkggl3455@gmail.com>
Date:   Sat, 30 Apr 2022 13:22:39 +0200
X-Google-Sender-Auth: zJDA3QAN3wwIOsnwUwCLJBypNvc
Message-ID: <CAGCMmKeAhZVxHX3=wt0JsHtY5sWTN8D1Vjqfaq94UHFfcTPYNA@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.7 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FROM_LOCAL_NOVOWEL,
        HK_RANDOM_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5015]
        *  1.0 HK_RANDOM_FROM From username looks random
        *  0.5 FROM_LOCAL_NOVOWEL From: localpart has series of non-vowel
        *      letters
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b2d listed in]
        [list.dnswl.org]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sdltdkggl3455[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ibrahimvivane65[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.4 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear

I am glad to know you, but God knows you better and he knows why he
has directed me to you at this point in time so do not be surprised at
all. My name is Mrs.Sophia Erick, a widow, i have been suffering from
ovarian cancer disease. At this moment i am about to end the race like
this because the illness has gotten to a very bad stage, without any
family members and no child. I hope that you will not expose or betray
this trust and confidence that I am about to entrust to you for the
mutual benefit of the orphans and the less privileged ones. I have
some funds I inherited from my late husband,the sum of ($11.000.000
Eleven million dollars.) deposited in the Bank. Having known my
present health status, I decided to entrust this fund to you believing
that you will utilize it the way i am going to instruct
herein.Therefore I need you to assist me and reclaim this money and
use it for Charity works, for orphanages and giving justice and help
to the poor, needy and to promote the words of God and the effort that
the house of God will be maintained says The Lord." Jeremiah
22:15-16.=E2=80=9C

It will be my great pleasure to compensate you with 35 % percent of
the total money for your personal use, 5 % percent for any expenses
that may occur during the international transfer process while 60% of
the money will go to the charity project. All I require from you is
sincerity and the ability to complete God's task without any failure.
It will be my pleasure to see that the bank has finally released and
transferred the fund into your bank account therein your country even
before I die here in the hospital, because of my present health status
everything needs to be processed rapidly as soon as possible. Please
kindly respond quickly. Thanks and God bless you,

May God Bless you for your kind help.
Yours sincerely sister Mrs. Sophia Erick.
