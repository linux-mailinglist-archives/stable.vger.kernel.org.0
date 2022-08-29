Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489525A53CD
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 20:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiH2SMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 14:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiH2SMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 14:12:23 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF418C02E
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 11:12:21 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id t140so11302479oie.8
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 11:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc;
        bh=TrYLNmHMfL2YwnKDzOCdO7Jrlbbexw6rsutI3mWrjc8=;
        b=C4e2LfHHhD3VI9AYcAd79zU/xDY05gHHfjG5as6HSheMRmJOOly6Y3xMtynCDJMtbr
         bSmDy5sJCrggphzwB6ZpWWZiLxOLrFHBBBr5tL3RYH+s/aj+hkRKiMMHTA9mLLghb2IC
         mxf+lrsR9qyJNSzJSBlGabtI5kXr81MiI4Bl2bTd9Li1QFMsghkejev/KDQaGEzhJQ4b
         rJlTxH3Ad4HyEccHJ04Wd6tySipxIH40sI+zPj6zT6AmeAq0hb4YUXdhbUDC+CjzoVbf
         OZAyI1tZg+33DfHS/x1p1CmYlPhfyL+/Nay4J0EzP0G9OP7W4IdIlaVJDT6vNzOMz141
         oUtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc;
        bh=TrYLNmHMfL2YwnKDzOCdO7Jrlbbexw6rsutI3mWrjc8=;
        b=PDkUvBjRYbTLr68uwMRXkjx/LBwpFPV5fmm/wPesi/dZipC9MJMPVjrPDPcVUY521Y
         Jwcdn9G4ASQxmDM+dJh0HWdfLh3nhO10Wcs6qCs3iHiGPKOO35mRPW/zKlx6+fjE9ceC
         9gJv9OSpjkHhmCRE4NKf5MrMOI08AiJyINHv9mAvBoK0YRmvtHcN32703zvN1JXhKNd/
         i7dPcsfTDPSinmnr069/ScLcXtZQSYvq7Q+k07tclOWf8NgzVZ2BXdVsBqjCmxeRoEAO
         iX8en265G9H2q9OXMHjIkD8GMEiv4Sgv69JQv+Br2iw5C4s5w4kwwOs+p9oeXtsts+Ji
         dagQ==
X-Gm-Message-State: ACgBeo2p++OKw0UL7KsGwYb5vc63x7aGGMp3ntvHwRm8YcGb26Nljziy
        tcryxNwH0ogKfj58vrphd/J0GoxLZJQkJTKWF5A=
X-Google-Smtp-Source: AA6agR42CyXCsxl0rEVjo6rW8BIakUHbLBBwLSGlDDYD6SZQFTi6lFohd+sg22/9wEGDPx/VuAKgjc7a0ZgmlLuZVdc=
X-Received: by 2002:a54:4116:0:b0:343:bcd:88d4 with SMTP id
 l22-20020a544116000000b003430bcd88d4mr7839132oic.47.1661796741180; Mon, 29
 Aug 2022 11:12:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:128f:0:0:0:0:0 with HTTP; Mon, 29 Aug 2022 11:12:20
 -0700 (PDT)
Reply-To: georgebrown0004@gmail.com
From:   george brown <georgemike70300@gmail.com>
Date:   Mon, 29 Aug 2022 20:12:20 +0200
Message-ID: <CAFx-DcEVJ+hXEtsoGydag5G+Kk=PzGk9YV2goqV3AfEEvPTGgQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ahoj

Jmenuji se George Brown, povol=C3=A1n=C3=ADm jsem pr=C3=A1vn=C3=ADk. Chci v=
=C3=A1m nab=C3=ADdnout
nejbli=C5=BE=C5=A1=C3=AD p=C5=99=C3=ADbuzn=C3=BD m=C3=A9ho klienta. Zd=C4=
=9Bd=C3=ADte =C4=8D=C3=A1stku (8,5 milionu $)
dolar=C5=AF, kter=C3=A9 m=C5=AFj klient nechal v bance p=C5=99ed svou smrt=
=C3=AD.

M=C5=AFj klient je ob=C4=8Dan va=C5=A1=C3=AD zem=C4=9B, kter=C3=BD zem=C5=
=99el p=C5=99i autonehod=C4=9B se svou =C5=BEenou
a jedin=C3=BD syn. Budu m=C3=ADt n=C3=A1rok na 50 % z celkov=C3=A9ho fondu,=
 zat=C3=ADmco 50 % ano
b=C3=BDt pro tebe.
Pro v=C3=ADce informac=C3=AD pros=C3=ADm kontaktujte m=C5=AFj soukrom=C3=BD=
 e-mail zde:
georgebrown0004@gmail.com

P=C5=99edem d=C4=9Bkuji,
pane George Browne,
