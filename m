Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32A265CA47
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 00:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjACXVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 18:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjACXVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 18:21:46 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FB313D0A
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 15:21:46 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id n63so17361978iod.7
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 15:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q3Vk8EpiGjXnHF6YekaZg/U6Ld4mrMRuJRWQz+va2YU=;
        b=LVUxLEFEiViZ6BSCDiS/FOy4amsaQNhUpo6v2VJBNKRNkRua5V81kTAK/+icfWghqt
         ZIkL6Y0S97OcXPvO+1bjDvb/ov+8DrQWz9VK1KMlr+XTQVaBluPxjoHh94EoCcH0Vuhj
         2gRGeUiebG0JENCORMOLpzgMq2TPznCuMUihPAP1mR5wxQpHFo4UmvT68CEtSEhZwrgS
         ekGsalWPcJrmij4YSp89HkvYfKdyYqfyTYYOBFsWwVivdfGcT3Mfe2OlqFMsdDC5tyJF
         CUeyalCqMtgJloptPe1fBqBVIL+fMCtaE+/mBlF7UfIqOOe8ZqgVfqcW0A/oDJser8LM
         ITKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q3Vk8EpiGjXnHF6YekaZg/U6Ld4mrMRuJRWQz+va2YU=;
        b=oftnaUERzTvSwaSC2MeEPEbYHfmEx/bn1H7ZiLWw8pbiE08xHlm7uJq2/CD9XrjYwC
         777EOX+qn3jDMr2PPrSzOk0fyaDN6yF1y2OlasvKQzLwQRbT7762z/wI/eol/BpqjdpI
         tg7AWnRv/2qbeQAI88KDcYsrqV1WDHQWcDZWwXGZ89uPYoANdYCbhIgzGA6LZ6uPL53z
         J0bEzB4fbl2Ue6pRGtkLQqG4Ah7hS++8l3aEbYom9FMZOP8mz1jTHmuDkuJEpAiGMVI/
         O+Vv3JiumB5A5e+12rTpGEAZGNuxsHqsCko/s/AEW2OIPVTbVXyylFyg1rjxvg/KQ7Sm
         EsMQ==
X-Gm-Message-State: AFqh2kozxaVrNmpCi9i+ePpNeq+ZVgWaejE1/x2xiiDhTKN4qXSVkNMr
        YNMC3IkEUi3KL2DQg1LDnrdqMa3r1Ejy62Cnv5Y=
X-Google-Smtp-Source: AMrXdXtvppkGO9J5r4KIcUkOgVxIxcR1lTD2WioCVupIJHegmVjBoQalWeC3sejYUtgcJjLTYah9IG5cWp8e3V95K2E=
X-Received: by 2002:a02:cd90:0:b0:375:3be7:2908 with SMTP id
 l16-20020a02cd90000000b003753be72908mr4345499jap.275.1672788105692; Tue, 03
 Jan 2023 15:21:45 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a4f:3b55:0:0:0:0:0 with HTTP; Tue, 3 Jan 2023 15:21:44 -0800 (PST)
Reply-To: michellefanilly0@gmail.com
From:   Michelle family <nguessanhenriette02@gmail.com>
Date:   Wed, 4 Jan 2023 00:21:44 +0100
Message-ID: <CAMm817mOoV8c-v-wGPMUu2gfZJyx10jnPJVVWMc+OTtt+XZNFg@mail.gmail.com>
Subject: Senhorita Michelle
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PROCURANDO SUA AJUDA
sincero e honesto como voc=C3=AA, que possa me ajudar neste momento de
necessidade, durante a crise civil e pol=C3=ADtica em nosso pa=C3=ADs, meus=
 pais
e minhas tr=C3=AAs irm=C3=A3s foram envenenados pela crueldade. Felizmente =
para
mim, eu estava na escola quando essa trag=C3=A9dia aconteceu com minha
fam=C3=ADlia. Por falar nisso. No momento, ainda estou aqui no pa=C3=ADs, m=
as
muito inseguro para mim. Estou vivendo com muito medo e escravid=C3=A3o.
Pretendo deixar este pa=C3=ADs o mais r=C3=A1pido poss=C3=ADvel, mas apenas=
 uma coisa
me atrapalhou. Meu falecido pai depositou uma quantia em dinheiro de
3,2 milh=C3=B5es de euros em uma das principais institui=C3=A7=C3=B5es da E=
uropa para
transferir
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
