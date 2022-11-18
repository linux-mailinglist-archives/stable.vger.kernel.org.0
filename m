Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9450662F505
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 13:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbiKRMgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 07:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241733AbiKRMgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 07:36:25 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902AD73BA8
        for <stable@vger.kernel.org>; Fri, 18 Nov 2022 04:36:21 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id f27so12777111eje.1
        for <stable@vger.kernel.org>; Fri, 18 Nov 2022 04:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T18594i4ND0M6+7qM4FmvFUoaGRJLG8kN+deJfFAK20=;
        b=grwxpT10IChbjeteUR3STVhv06jdXr1Co9f5YdYccD10FyugDYLpF8BW+kJOifI+UR
         t3KlOr6SVYY/keJ11xgKuMXolZXpfPcPiNX28bGCnbvz+RGlCMT7ApfdfkEBvlTCl2ND
         uTSoVmxGctca2mjyg1RPrdCpHEOdmqbfW8FPQXT/VYX83L+iVcvdyjqUUs8k3HdrqM7c
         mXKwj0AZS3h66PxW/PsvTJAWVfQCrraGCdfWP7I+tCiyuvbwNt8/OXGrX0eg41lk68Zt
         M72civyzyNq5/jpuYEjhVgrkfWTsRzuY/ZC1dxrecpqsyYsvEQ+J9j6/gBhGTPpjnps/
         +Hfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T18594i4ND0M6+7qM4FmvFUoaGRJLG8kN+deJfFAK20=;
        b=zP5KzqTySJQIzZ2wcAR91zvZ7ZNuaraG7uqSdh0ICQNd8VfNy29ttCBwa+0+hb2T3X
         lZlsrea7DLll+K2HgsW1tT5W6kw0clPOw788Ts+y9FrBt3fmNbciE4+FRl8UjJPf/wOl
         muOsLm+aG1EASIujY+bpavg4HF2WtgSyw/wYmLqMtbBeR7IziEuE/0galPsO4WdqQx8U
         XHUOMzit5zkVGTCY4Q+w91kfLk0uH6aUwDXHpqZ06xgsPbVxZXEK7Ob4Je6upcx1E4VJ
         tUpRqq06Rcj6WSDnd9hwSWKirw+QtkPD/XnHsaIboOCCvFyXTokoTpHiEoyvpheBloIa
         2rdw==
X-Gm-Message-State: ANoB5pndNuy43wdpDxzzVjIWHCEJSf0NoQKfMl2litUhaGrmcW/mS2yp
        f49e/vs7Kk9hyLvp4fzFE1TjR/WO0291x6ZhFkY=
X-Google-Smtp-Source: AA0mqf78cNp1JPTqmavEHFNoBibszRcjNBSYikrvSIwmRGWkCl30QrLnzWVyBlRTAZEaHQ3/sgaWGw3/BqK3EqTNtq0=
X-Received: by 2002:a17:907:7e86:b0:7af:bc9:5e8d with SMTP id
 qb6-20020a1709077e8600b007af0bc95e8dmr5908668ejc.3.1668774980013; Fri, 18 Nov
 2022 04:36:20 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6402:2709:b0:462:a20f:2984 with HTTP; Fri, 18 Nov 2022
 04:36:19 -0800 (PST)
Reply-To: mmichellefamily@gmail.com
From:   Michelle family <bamodml@gmail.com>
Date:   Fri, 18 Nov 2022 13:36:19 +0100
Message-ID: <CABoA1+pRcEZiKJvnWyh6BxLxmxeJUZhEd4TbCWw=88BS-XjKKw@mail.gmail.com>
Subject: Senhorita Michelle
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

pol=C3=ADtica em nosso pa=C3=ADs, meus pais e minhas tr=C3=AAs irm=C3=A3s f=
oram
envenenados pela crueldade. Felizmente para mim, eu estava na escola
quando essa trag=C3=A9dia aconteceu com minha fam=C3=ADlia. Por falar nisso=
. No
momento, ainda estou aqui no pa=C3=ADs, mas muito inseguro para mim. Estou
vivendo com muito medo e escravid=C3=A3o. Pretendo deixar este pa=C3=ADs o =
mais
r=C3=A1pido poss=C3=ADvel, mas apenas uma coisa me atrapalhou. Meu falecido=
 pai
depositou uma quantia em dinheiro de 3,2 milh=C3=B5es de euros em uma das
principais institui=C3=A7=C3=B5es da Europa para transferir
Infelizmente, por=C3=A9m, ele n=C3=A3o concluiu a transa=C3=A7=C3=A3o at=C3=
=A9 morrer
repentinamente. 45% pela ajuda e assist=C3=AAncia, porque acho est=C3=BApid=
o
tentar confiar em um total desconhecido que nunca conheci antes. Estou
instintivamente convencido de que voc=C3=AA =C3=A9 uma pessoa honesta e tem=
 a
capacidade de lidar com essa transa=C3=A7=C3=A3o comigo. Quando estiver pro=
nto,
vou encontr=C3=A1-lo e passar o resto da minha vida em seu pa=C3=ADs. Estou=
 com
medo aqui porque os inimigos dos meus pais, tios e parentes ruins
est=C3=A3o atr=C3=A1s de mim. Por favor, deixe-me saber o que voc=C3=AA ach=
a da minha
proposta para voc=C3=AA.
Miss Michelle
