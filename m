Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD106E77FB
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 13:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbjDSLED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 07:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbjDSLEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 07:04:01 -0400
Received: from mail-yw1-x1141.google.com (mail-yw1-x1141.google.com [IPv6:2607:f8b0:4864:20::1141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3760C4C19
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 04:04:00 -0700 (PDT)
Received: by mail-yw1-x1141.google.com with SMTP id 00721157ae682-54fe82d8bf5so181225877b3.3
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 04:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681902239; x=1684494239;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AZtZFW4Yu8/s9hisFwTitWaI2cjRerxPZcc9cSg2rPE=;
        b=eCOranTvGfGyiJwKgEXRuNQIFb6eX/scj2FDRKgQHiCEeo40qDqFmH/fFqjo8zdK+H
         df/2PnOVqqcqKd/WEvtC45s+QaVALEXDCnEAHIwxfjIgr/yTpsZ32ZfjyQqSzavy+DfD
         pfi6/yjYE1uMe1Nsn3iFfdYny5Ln5NT2we4dDMZoGPJmRByVn8kB1DXx1pw8JRQ0nAEK
         ihoVCmgL6ht4eRAmYF6LUIL7zig05FquaA1NDl2I5vQsf7dEHyWra9eReFfq7dTk8wBV
         qA/RwmY70YBPwA+4FpHGFcsbG1xxFxqo2LVxuJMDGKzrD206c45xrMK+qWHvcUUEx/iu
         EQgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681902239; x=1684494239;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZtZFW4Yu8/s9hisFwTitWaI2cjRerxPZcc9cSg2rPE=;
        b=inOhv63Z1KRnPhiW5KACzf0rVWaqguw9T8T+kfJu4HI59xe7ND/2nip53iyL5Bs0qu
         p7eUL8Vbp/BxaB7NweE39xRRxhXW1dUN7vmaXR1nvSmpBLwXP/sL08IEBJyAhQMCmKEO
         0F+IuZG+RoFLKYKipNBTJAXuSoqeh9SatrzyA8fg6qL1OrNSKiW0BxhFSygBrdQ+Uc0U
         UhZFOz7nLNp5ozVCOew764+HX3tYPHIC9SQeOceYOlEGev6rgDgbzIpnmhbcX0VDGlM1
         B6MF3LHuVgOzP2GJIgGm8mcSNc8pxqAJnnpNqNPc2z7NG35xusBEOSGL2sMMfC4hNOeP
         SzYw==
X-Gm-Message-State: AAQBX9cFPh1rlFevUOjgJOl4kJw1CKPyRkSdgame8s09g+Dtpe0TqE0E
        m7IO8C/x9tvVqpQN4oRbbC+uK7Yqk0sPUuQH+QQ=
X-Google-Smtp-Source: AKy350Z29lReMeohrwftgjANcVuqzBtykHw6roLtX6PekNbfJEpAsCVqFy31JekDOMjCwZSCUcoysgKLF+YkRiQ4pwc=
X-Received: by 2002:a81:92d7:0:b0:546:2787:4b93 with SMTP id
 j206-20020a8192d7000000b0054627874b93mr3199305ywg.35.1681902238676; Wed, 19
 Apr 2023 04:03:58 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mis.vera145@gmail.com
Sender: adamsfrancis140@gmail.com
Received: by 2002:a05:7010:218c:b0:344:4f01:f1f with HTTP; Wed, 19 Apr 2023
 04:03:58 -0700 (PDT)
From:   Vera Wilfred <mis.vera145@gmail.com>
Date:   Wed, 19 Apr 2023 12:03:58 +0100
X-Google-Sender-Auth: 6BBMiGukeEzvluwqqcdLTH_RNkc
Message-ID: <CAD3yhOVTx87Z5d4EZFchNzo6DGG4dE8i1jS0AEB1dJBWmYefAw@mail.gmail.com>
Subject: Ich bin Mis Vera Wilfred
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,
        MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Hallo,

Ich bin Mis Vera Wilfred aus Abidjan Cote D'Ivoire (Elfenbeink=C3=BCste)
Ich bin 22 Jahre alt, M=C3=A4dchen, Waise, das hei=C3=9Ft, weil ich keine E=
ltern
habe, ich habe ungef=C3=A4hr (10.500.000,00 US-Dollar) Zehn Millionen,
f=C3=BCnfhunderttausend vereint Staatsdollar.

Was ich von meinem verstorbenen Vater geerbt habe, hat er den Fonds
auf einem Fest- / Wechselkonto bei einer der besten Banken hier in
Abidjan hinterlegt.

mein Vater hat meinen Namen als seine einzige Tochter und einziges
Kind f=C3=BCr die n=C3=A4chsten Angeh=C3=B6rigen des Fonds verwendet.

Zweitens bekunden Sie mit Ihrer vollen Zustimmung, mit mir zu diesem
Zweck zusammenzuarbeiten, Ihr Interesse, indem Sie mir antworten,
damit ich Ihnen die notwendigen Informationen und die Details zum
weiteren Vorgehen zukommen lassen kann. Ich werde Ihnen 20% des Geldes
anbieten deine Hilfe f=C3=BCr mich.

M=C3=B6ge Gott Sie f=C3=BCr Ihre schnelle Aufmerksamkeit segnen. Meine best=
en
und liebensw=C3=BCrdigen Gr=C3=BC=C3=9Fe an Sie und Ihre ganze Familie, wen=
n Sie mich
f=C3=BCr weitere Details kontaktieren.

Ich brauche Ihre Assistentin, um mir zu helfen, diesen Fonds in Ihrem
Land zu investieren. Kontaktieren Sie mich jetzt f=C3=BCr weitere Details.
Vielen Dank

Vera Wilfred.
