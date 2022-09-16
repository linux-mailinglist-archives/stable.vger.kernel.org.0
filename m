Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1775BABB1
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiIPKxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiIPKxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:53:20 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC89413EB3
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 03:33:42 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id e18so9636253wmq.3
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 03:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date;
        bh=KUO+kgQEAoM5aXSSbQHEnaSgbpm7WvhWNqvDfGLWvyg=;
        b=ZBMmGVsznRDB3dSAwH1J0FLZ0uKn3M7mc39bggoH63fjitO5/Ao5i363Bkr6TdAZJR
         Z8puO6xY1Y7A9ZUaLm0L6VWDGsucLoOlYeUYuzhH2kYoHb+17c3kJbzfJp0uG4ZKUWqA
         r+De+JKNvGxGfXxNt/nn6eClphniIHqJ8LKCJL7emgS5Z5lPmP9wmLHCtPST/7XlSXJJ
         bsn3AirW0DOaS+KYDSKPEGqlW+SGp3Z5tPlHr3fBDQEprf0tTp2uy9GPszgVzkjVtrht
         n/aav6B4beMkGmA0WRtBFVGjGi52DWhK0j8ci+eGlDLuIN46KQO/ZmfekFrAz8BoE9bC
         mk1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=KUO+kgQEAoM5aXSSbQHEnaSgbpm7WvhWNqvDfGLWvyg=;
        b=MR2bOWRIeFAsdp6BmQyPx3iaSrXr+rmLUyg2PwiU66ZMpjBBZRIOrbqXqJz+G4YaW9
         U8nFArTkCnZXh0GTccHgIkH8RykCUOm6JGsk78CYr5dWAPWlRqeuPMr9nMzyEh/R8lD8
         rML7BTCKrPw6xDOIDtV5hVmBUqTAEjg3h3UVoews0fnnnGHrePxCiM9hFOQhxp6dXpRu
         EZd6xluOUz4QInDI03mmD/rRwKI9eDbRm96mgybGIVOCnBv95Ta2w+0kFVTL5BpdLF7z
         m56Rk8WP0USUqWUNXBBBzqvnRdYH1f2oBnI7b7qSYnbwLebZLrs/LTr2/cajWc9kUg5A
         xomw==
X-Gm-Message-State: ACgBeo2mYQUGLQg+eZX2z/Ndqa4TtplsXazfPwSWquLHJK8mSMehfCIm
        O4WM8yF3rY4dbQaWzN/ncxXZ+AHdXLGnUJZWRso=
X-Google-Smtp-Source: AA6agR4vNToH5Xq3dGNH67y6L3R5tX7/D7UO2ogonWvtde3oxFJxBidtw9H+HCfvdLQVzfb8DlrI0JQi9ASPYvBdb4A=
X-Received: by 2002:a1c:a1c4:0:b0:3b4:75f0:e924 with SMTP id
 k187-20020a1ca1c4000000b003b475f0e924mr9290993wme.99.1663324421318; Fri, 16
 Sep 2022 03:33:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:584a:0:0:0:0:0 with HTTP; Fri, 16 Sep 2022 03:33:40
 -0700 (PDT)
Reply-To: susanne.klattn01@gmail.com
From:   Susanne Klatten <rukaiyyaadamu4@gmail.com>
Date:   Fri, 16 Sep 2022 03:33:40 -0700
Message-ID: <CAFUU7=Wyj9_oESxzunMeYOMi2ynohi-QAuUVMeLgVzCBSyc46Q@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:334 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5002]
        *  1.0 HK_RANDOM_ENVFROM Envelope sender username looks random
        *  1.0 HK_RANDOM_FROM From username looks random
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [rukaiyyaadamu4[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [susanne.klattn01[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [rukaiyyaadamu4[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Hallo

Ich bin Susanne Klatten und komme aus Deutschland, ich kann Ihre
finanziellen Probleme ohne R=C3=BCckgriff auf Banken im Bereich Kreditgeld
in den Griff bekommen. Wir bieten Privatkredite und Gesch=C3=A4ftskredite
an, ich bin ein zugelassener und zertifizierter Kreditgeber mit
jahrelanger Erfahrung in der Kreditvergabe und wir vergeben besicherte
und unbesicherte Kreditbetr=C3=A4ge von 10.000,00 =E2=82=AC ($) bis maximal
50,000,000,00 =E2=82=AC mit einem festen Zinssatz von 2 % j=C3=A4hrlich. Br=
auchen
Sie einen Kredit? Senden Sie uns eine E-Mail an:
susanneklatten56@gmail.com


Mit freundlichen Gr=C3=BC=C3=9Fen.
Unterzeichnet
Susanne Klatten
