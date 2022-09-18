Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDA15BBF17
	for <lists+stable@lfdr.de>; Sun, 18 Sep 2022 19:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiIRRTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Sep 2022 13:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIRRT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Sep 2022 13:19:29 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195CE120B3
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 10:19:26 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id s6so32077763lfo.7
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 10:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date;
        bh=lAdqUFLbfInbPlQSmqMtnpus1qI43ZF9JU60ST1bHc4=;
        b=BWDtFqD9tCd647ndaNCU4Rq2+G/dyccrhid3HuzA0K9RJtkZAodwUpe7xlmELXnErb
         Ol6pHgQ6ld8Bml5lTUo0gx19BpqbUgrNV7vCyTGYStJpptzFlVPY1pJ6tnOXs5S8qz8M
         DFBQyxauL2g6z4MEHNCH4e8WNHOeXRCDZ1A8iOFVY72EOOsRzsy+++y78TJMyoMndVoS
         2o2lVqWZ1Z++6pWEU8opBkV62771Htxfg3TaTPLi8avzg5Xg/eoJ2P7frLFquYzPkDh8
         zmeMBScmEfnRBYLqaHdQtpSEuqK0NgGB8UljI1Dnx8+A74WjaCqyi7fO+qkMaoFBIfTL
         b1lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=lAdqUFLbfInbPlQSmqMtnpus1qI43ZF9JU60ST1bHc4=;
        b=H7o4uJyIT3AP2GS3su7SUFqy+Pu5QMea6GLOdtlaL3wiiBXLnhk3mdXXrFTYu2QsPr
         afuw/B1eZnL/IUJ1DLtpYjGctHhesLF7iDSs/EUsq5HJFZOZl11O3PYOx0StdQH+iuVV
         gSyhhe+KRxDo1mifgh6oPasiRzBOEtgTAhrC/OheDn7exKXv0h0ho55hYDMPDsUWzUP6
         p3FI0fmOh0h9qinE+osRvWsoNYCq7eMdOGZ7RBk2J9ROGDGJcfr9OXUgMNPauQgRZIse
         k3w4tZoZml4vCf8v1q+4ZSKdg1IF7qmotH0MZqiy05/r7SCVthPGzC2mAVfkIXdFl7id
         48AQ==
X-Gm-Message-State: ACrzQf1XzCcG9STVJ7WQQasxIZdmRVeK4azQD8NagFyFft2tygAlAciP
        MuFiiCzyFOR/DPX3rgorb4L9V1RkLLJXr84XQGU=
X-Google-Smtp-Source: AMsMyM42q5WjqOv7wr8hO1D5yWVPQuLdCrk661Moh8jq9HMc2vRMFUKgDkM2bDmealuKEwxYSMIGcFge5sB2y6trhnU=
X-Received: by 2002:a05:6512:38b2:b0:493:9a:ac2e with SMTP id
 o18-20020a05651238b200b00493009aac2emr4581851lft.126.1663521563895; Sun, 18
 Sep 2022 10:19:23 -0700 (PDT)
MIME-Version: 1.0
Sender: maiga4327@gmail.com
Received: by 2002:aa6:c42c:0:b0:21e:bfe3:b85d with HTTP; Sun, 18 Sep 2022
 10:19:23 -0700 (PDT)
From:   "Mrs.Yu  Ging" <qing9560yu@gmail.com>
Date:   Sun, 18 Sep 2022 17:19:23 +0000
X-Google-Sender-Auth: lCE7T_r-lDNgg4l_ZzmrEkqUVT8
Message-ID: <CAE_49OR1_JYHzgpw4kXiEriHhRR0t19hEOcoLxOcfx-A4erB2w@mail.gmail.com>
Subject: Hello!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_USD,MONEY_FRAUD_3,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I am Mrs Yu. Ging Yunnan, and i have Covid-19 and the doctor said I
will not survive it because all vaccines has been given to me but to
no avian, am a China woman but I base here in France because am
married here and I have no child for my late husband and now am a
widow.

My reason of communicating you is that i have $9.2million USD which
was deposited in BNP Paribas Bank here in France by my late husband
which=C2=A0 am the next of=C2=A0 kin to and I want you to stand as the
beneficiary for the claim now that am about to end my race according
to my doctor.I will want you to use the fund to build an orphanage
home in my name there in=C2=A0 country, please kindly reply to this message
urgently if willing to handle this project. God bless you and i wait
your swift response asap.

Mrs.Yunnan Ging.
