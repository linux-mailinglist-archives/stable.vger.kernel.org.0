Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0FF156FEE3
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiGKKaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiGKK3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:29:54 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56AD8AEC6
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 02:40:39 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-10be0d7476aso6106514fac.2
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 02:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=B/ps/HaihXN/x4cigP+9hMtke5ajI2cfpnLJOMnelEs=;
        b=PSfTf7kZ+5iISLUgu8KX60LWPKl1/Y6JulCl9yGaXG5Szvowyv1S7zkx2qhm+Zo29y
         QDm++GeGwnzoTXK1lPdFusoi1TocXkJse1r4fzeD+wSNhw4BUPs45Pv4ub9HzYgyiDwh
         8IoTdGQqCny0kyuVX2J93Ml0oDaN1RT33H8X9gM+4Lq32IrYjVD0h0INXzs7eNvDP//i
         y/AqMDNpT7kZEd2k5NccmN7t5YqZFwM4vjhRyMH+jFHCDQ6l6JP7LAAKXQUOUWV47c36
         HVzx9AXte+iLgmh5Cue/FDktwym4CToZAdOHptYpN8TGGhjDvJDLRieGi0ei1BK1TEzo
         XgYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=B/ps/HaihXN/x4cigP+9hMtke5ajI2cfpnLJOMnelEs=;
        b=R9cyW61ebbcsbiLmq/28i+WmDECJP/f9vor0wJI6G/x31AWsaiYm0p7JYbZbd2AD8J
         dVi2cAmWTKA65hgYqLzK93Pv0OzcPjM79S8W5cyGkshS0aWlfxmzFMvfRhh/5er+4Goi
         4Onr274/XpeMhT9xhLpJABnnHmXR1yHbXPiZRlZqfJWlXdJ6504FpY87oapO3qx6u/mC
         DySsqOZPuNUffX98q6IJ7zid+KbHvzJqXusXj5Tl6+6wb3OrvO6jUraCYTQyc2V2ZVhl
         zZ3SEdU+g463+OKfXvRACHX4QMVvHRauCn0/e9ZzAA202oI1KLA6QURiHInRsEaWMuZw
         n0CA==
X-Gm-Message-State: AJIora9rKL4q6F1XUrkIDtHVjAwUbGlOpZ1t6ZU15KyPoxZS1fpqHRa5
        J0hPpfClWCyM58g2dZS0AIew5oTlR/GRtZIpkQk=
X-Google-Smtp-Source: AGRyM1vSNwqxlXGqiiOTmUgOYMXmowmU/PGQ8V+yzHHJvYdH3GWcPUZZkL9b3OPK6o1HpH6OyVsoVpQnXx3Yl8zYkL0=
X-Received: by 2002:a05:6870:581d:b0:101:dc4f:51 with SMTP id
 r29-20020a056870581d00b00101dc4f0051mr6967760oap.247.1657532438819; Mon, 11
 Jul 2022 02:40:38 -0700 (PDT)
MIME-Version: 1.0
References: <CABGpxzf309-UjngfN_Cas4uGneUdpsyZf=fz1FhvtGazk7=D+g@mail.gmail.com>
 <CABGpxzcD95tTHsG0mfsD8qsgFOsdXnpESG3YwsgDNBMoybE5kQ@mail.gmail.com>
In-Reply-To: <CABGpxzcD95tTHsG0mfsD8qsgFOsdXnpESG3YwsgDNBMoybE5kQ@mail.gmail.com>
From:   myleswatson161@gmail.com
Date:   Mon, 11 Jul 2022 09:40:27 +0000
Message-ID: <CABGpxzf+cza42Z+RVe+3vNQbG-Kv9iT+LpEozrWtffWpiEtT0Q@mail.gmail.com>
Subject: ??????
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pozdravljeni, dober dan,

Opravi=C4=8Dujem se za poseg v va=C5=A1o zasebnost. Zelo mi je =C5=BEal, da=
 sem vas
kontaktiral na tak na=C4=8Din. Moje ime je Myles Watson, =C5=BEe sem vas
kontaktiral brez odgovora glede va=C5=A1ega dru=C5=BEinskega sklada za
dedi=C5=A1=C4=8Dino. Za ve=C4=8D informacij me kontaktirajte.

S spo=C5=A1tovanjem.
G. Myles Watson
................................................................

Hello good day,

I apologize for invading your privacy. I am so sorry that I contacted
you in this way. My name is Myles Watson, I have contacted you before
with no response regarding your family inheritance fund. Please
contact me for more information.

Regards.

Mr.Myles Watson
