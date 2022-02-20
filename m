Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048A04BCE32
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 12:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237353AbiBTLjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 06:39:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237687AbiBTLjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 06:39:48 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320D531DDE
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 03:39:28 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d27so22215499wrc.6
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 03:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=T28r8IcApmahqshNb89Vq7Sss5daNXvHX2RvLjpVFBs=;
        b=EYv710q1PhTWzZ/CdtTWXzxhRYjWSI+5maJroipOyCIHe4I+3X60V/3ksOYafCWgme
         0Hx/j2nu87g6u1JxdKKDg+NFkI36xMuGRJnwxRbxJ1qaxFDtoO4hEBwg6EQdNvlzRlcY
         Y+GYbsQ1C9+CjEtCqz4rUKEHMgkAwe2xd6cYl5/F6FIqQel1ukV/e8mcBIWNb/p/Zuh4
         uY1kFQG5lMRXTTYmGnzmy9Da1r2NNYKsng7N0NVktV1gxT3ZPnF7+9wvyX5bUCspAbBN
         ouqTEmMQSJMuZn8W+q5afnCUn+cUrIwawyVmFBkxsAZbibceOlN9Nr8FoYyl2ef+4Srx
         hG8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=T28r8IcApmahqshNb89Vq7Sss5daNXvHX2RvLjpVFBs=;
        b=SUWEyM6jXfdqT23V50hhcIiczXUdLMYJ11tSa5c6cIJepGURzTRu3CX1kEIa+wlwFa
         1cD2GzpwLAUV0pxJ7TLaO5ifSKXbHkgstO6Pa1qGHDrbssFhcEKdnCezG4bY/AG6JlOU
         cTExgIdQwSaYdLD0z9H06twJ1lI9DdY71nYzHKGedVihpj5G2ScLNGxEjEurpX2lzTR0
         j3Qut8WKBBrHtHnaT2LWbeaN4Sp9xoo0VSOCy+Rg5Ntn05WX5wA9jz/uHwE2HpL0er79
         iR9XNqdOjhMsrXpXKfETCvaEZxUZYhS0pCmNBi6rJC6KQQ2H73nLLw4WyicdvCQGPWxW
         XszA==
X-Gm-Message-State: AOAM530dXhk3iFZYrzV6Gs61Yd6ERfl/LUX7neHmX0Zgtta8F5cGzr6w
        5MgpYaFdHT/dKvG7m//+A7I=
X-Google-Smtp-Source: ABdhPJyYqpJEzO0u6Sfkka5ABDjQPpCOu/lPpvR9eFY+ewXAyTK3QtDjdyVLstrjCZWhCEgE4Gc5Pw==
X-Received: by 2002:adf:c38c:0:b0:1db:7e03:a015 with SMTP id p12-20020adfc38c000000b001db7e03a015mr12126657wrf.186.1645357166737;
        Sun, 20 Feb 2022 03:39:26 -0800 (PST)
Received: from [192.168.0.133] ([5.193.8.34])
        by smtp.gmail.com with ESMTPSA id k3sm9938640wrm.69.2022.02.20.03.39.23
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Sun, 20 Feb 2022 03:39:26 -0800 (PST)
Message-ID: <6212286e.1c69fb81.c425a.3dff@mx.google.com>
From:   Mrs Maria Elisabeth Schaeffler <loganethan51@gmail.com>
X-Google-Original-From: Mrs Maria Elisabeth Schaeffler
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Spende
To:     Recipients <Mrs@vger.kernel.org>
Date:   Sun, 20 Feb 2022 15:39:20 +0400
Reply-To: mariaeisaeth001@gmail.com
X-Spam-Status: No, score=2.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,TO_MALFORMED,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hallo, =


Ich bin Frau Maria Elisabeth Schaeffler, eine deutsche Wirtschaftsmagnatin,=
 Investorin und Philanthropin. Ich bin der Vorsitzende von Wipro Limited. I=
ch habe 25 Prozent meines pers=F6nlichen Verm=F6gens f=FCr wohlt=E4tige Zwe=
cke ausgegeben. Und ich habe auch versprochen, die restlichen 25% dieses Ja=
hr 2022 an Einzelpersonen zu verschenken. Ich habe mich entschlossen, Ihnen=
 1.500.000,00 Euro zu spenden. Wenn Sie an meiner Spende interessiert sind,=
 kontaktieren Sie mich bitte f=FCr weitere Informationen.

Sie k=F6nnen auch =FCber den folgenden Link mehr =FCber mich lesen
https://en.wikipedia.org/wiki/Maria-Elisabeth_Schaeffler

Gr=FC=DFe
Gesch=E4ftsf=FChrer Wipro Limited
Maria-Elisabeth_Schaeffler
E-Mail: mariaeisaeth001@gmail.com
