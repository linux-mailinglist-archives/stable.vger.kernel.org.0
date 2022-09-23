Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C40B5E714B
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 03:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiIWBSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 21:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiIWBSD (ORCPT
        <rfc822;Stable@vger.kernel.org>); Thu, 22 Sep 2022 21:18:03 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF03115F61
        for <Stable@vger.kernel.org>; Thu, 22 Sep 2022 18:18:03 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 9so10912557pfz.12
        for <Stable@vger.kernel.org>; Thu, 22 Sep 2022 18:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date;
        bh=aFU7vI8uPXu7Vi9JdYshVrmH0KwnbZHsJeAT55jVwKU=;
        b=MHDKHCK5XxPgYupoKSpCLMlaxcDtFei4N22PVq//uMbbkwnIoy1b5gnTw5B9ii/6rM
         GGhbtGXROXf+RjE1hrqpsu0gCbEJ08uwXO8f/3OaabY9uO8wViZXCrxRGfNc1EWL80st
         LDi0Jx+lqlxo5U5lRQ7zdnrhf+5EkLsBFqS357+8SNONX63/ig3aprsALjA0crk+QlB8
         QSvR6i51sQ7c5bwZY/SkiDeJmN/yLC30zthMIAVVbASLgSBks+AUK8iJtSp9w1JV+BnI
         SjTZZW7JaDSTTk+peG8W1kEc4copBh7xZH/NkgZX3ucTtT/AYNpwlFc5y4xZnessfCTc
         QTxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=aFU7vI8uPXu7Vi9JdYshVrmH0KwnbZHsJeAT55jVwKU=;
        b=eYou33H4yC16fNn1xghNb+MMqt/xkSqR58Y8gfeVWkjUgmFoDA9fJMIvTNgHZ1B7wO
         /y5+Ph3qj1gfMKUcHbeGxhZt8cc/gEVfnX0wPbaIkLGoDA3CR6Yh23Vh8S/X9ZBfuc75
         BQINV+VB5ie6CiYi9Sq1C9Z0PitvX4LBx1LVqf7ReJ367SFPKQ1rayOIqIDJAj3TaAWE
         3TH2az5uQht5Swr7ly6ja+3WR3yi+DsZ2LrOxLUN8OhhC1Bk4VZROeirfSmlHddyAvY9
         IjEc7El+yQIydo1ncGSKGYPj50A1GrO6fgMvZo3j4jsSQ38r4nOTiZ3RXwcNJ/BNAwT+
         egDA==
X-Gm-Message-State: ACrzQf0sY71MCsRR0QHuCy7mYkLYYIuFuRvRClcg2Lr+1tDqtJH5+jdn
        bRAz0iYP6VzX9D48x8F9vUydzTcAGaHI0kTqSxY=
X-Google-Smtp-Source: AMsMyM5S4oDUGv8nZcP7SCfLGbAkG3IhhfX7Nj7ycd+T7Jm8QUIbBSWmhqz+OTeaJJOevUpfIYOihkHHgf97U0mYBgo=
X-Received: by 2002:aa7:9851:0:b0:53e:87eb:1ffa with SMTP id
 n17-20020aa79851000000b0053e87eb1ffamr6501309pfq.35.1663895882787; Thu, 22
 Sep 2022 18:18:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a06:1888:b0:577:4d4:a7d5 with HTTP; Thu, 22 Sep 2022
 18:18:02 -0700 (PDT)
From:   "Dr. Ogala Solution Temple" <ogalasolutiontemple@gmail.com>
Date:   Thu, 22 Sep 2022 18:18:02 -0700
Message-ID: <CAD58yf8X3BzsUqow9m9iLFarHbemDcFOEp3iw4nAYtP++myrzg@mail.gmail.com>
Subject: =?UTF-8?B?UHLDqXN0YW1v?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bienvenido a la FIRMA DE PR=C3=89STAMOS GARRY JONES. Ofrecemos pr=C3=A9stam=
os
comerciales y personales seguros y confidenciales con tasas de inter=C3=A9s
m=C3=ADnimas, tan bajas como el 2 % anual, con un per=C3=ADodo de reembolso=
 de 1
a 10 a=C3=B1os, y puede obtener financiamiento para necesidades personales,
empresas de peque=C3=B1a y mediana escala (PYME) y grandes empresas.
negocios/corporaciones. Puede pedir prestado entre $ 10,000 a $
50,000,000 d=C3=B3lares.

Saludos,
Sr. Garry Jones.
CEO
FIRMA DE PR=C3=89STAMOS GARRY JONES
