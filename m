Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980B168EC54
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 11:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjBHKFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 05:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjBHKFf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 05:05:35 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB8842DD7
        for <stable@vger.kernel.org>; Wed,  8 Feb 2023 02:05:22 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so1773020pjb.5
        for <stable@vger.kernel.org>; Wed, 08 Feb 2023 02:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2R7u1B9huXeTwYGwisMYMDWi/V1Cx5ZTUdTzwGn73I=;
        b=L6Iq0tdhu9HdGh3UreSoHHqAnt5kV515xL8K0OJYqQy6MAl4vXlbmqIU318Uqraa0J
         CK+6j/7ut/k0ssQMx6VPodWlrLXIlhctri+zLZf7+aGsSnJUeDV4SkCZzeYORdzXz1z4
         Dd//j33SbKRdbi0cXn/p2++DZ1YFKgGcsoQykutGfbr1Uej/PfIA4D7eFBDM2w651ZFZ
         G82ffGhwlo3/EufNKpBVMpNpO3UmiW91rZkA6Pod7NssaVI40QYNL756fg/osZO4A3oD
         4L4CoSTxFVR6PH8iEYfsK77krDlNiigpeUza0Hy0LmEYIbjCd9YeHr8HJBohCtWFE7Iz
         qSCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z2R7u1B9huXeTwYGwisMYMDWi/V1Cx5ZTUdTzwGn73I=;
        b=EXzGSCH2DpirrROpdqk4Bh681uCWaojrkA65wKCPqGXFRhL8rml/wTC5l7k2fRIP2s
         mi3Q5OuNZ4jQP1z5N+SLnezTnVfNIXW78L72jixi1Fm8JcrTKYQTwAJmMneHLA0kpLqK
         0XQRdyCJM0I/4IePd9uSkaJktWy+1DZUDESrY0/C/T8r4NUMMHsObQE+dkfh4aAjn8mj
         91lIYcMlSJur4SHLoGeTZl/khUdrMwLY1BG79Tqt9uYOrYykayOFSA7yLbGi4VYp5Vuu
         mLQ+j6IAs4S0Pe5aZFxnSXKJMCIMRlwQbYuGJQmxatJdBHoplV6IKLqhI4qmz3KA7kiV
         Ut/Q==
X-Gm-Message-State: AO0yUKUES5WcqHK4LfPym8xnw8R0XsoYvXhuV131weHZW8ulQSYRh6Cw
        486enrFAmNKlyXMgIonM9ZfO3FzVROhnJHZsOfk=
X-Google-Smtp-Source: AK7set8wpN7Y4bXvDadmDMTZC2eRETCBigZhyiZBvkdg6dIq00qhKGepKOtO0jSfR6Xc2/efExR916jCF9Bs+LS+wuE=
X-Received: by 2002:a17:90a:1de:b0:230:be01:56ef with SMTP id
 30-20020a17090a01de00b00230be0156efmr556746pjd.45.1675850721436; Wed, 08 Feb
 2023 02:05:21 -0800 (PST)
MIME-Version: 1.0
Sender: jeanclaudeoulai0@gmail.com
Received: by 2002:a05:6a10:dc1d:b0:415:afc4:e5fe with HTTP; Wed, 8 Feb 2023
 02:05:20 -0800 (PST)
From:   Sandrina Omaru <sandrina.omaru2022@gmail.com>
Date:   Wed, 8 Feb 2023 11:05:20 +0100
X-Google-Sender-Auth: fEWOmSKo3eYJhccSnOD5PcZLX-c
Message-ID: <CAJStGf6DOQi+4ckYqiv+qBsvE6oGKYU6vcibeB6dTzKFT64rCg@mail.gmail.com>
Subject: Sveiciens jums,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sveiciens jums,

Es izsaku to dzi=C4=BC=C4=81 cie=C5=86=C4=81 un pazem=C4=ABg=C4=81 padev=C4=
=ABb=C4=81. Es l=C5=ABdzu izteikt da=C5=BEas
turpm=C4=81k=C4=81s rindi=C5=86as j=C5=ABsu laipnai izskat=C4=AB=C5=A1anai.=
 Es ceru, ka j=C5=ABs velt=C4=ABsit
da=C5=BEas v=C4=93rt=C4=ABg=C4=81s min=C5=ABtes, lai ar l=C4=ABdzj=C5=ABt=
=C4=ABbu izlas=C4=ABtu =C5=A1o aicin=C4=81jumu. Man
j=C4=81atz=C4=ABst, ka ar liel=C4=81m cer=C4=ABb=C4=81m, prieku un entuzias=
mu rakstu jums =C5=A1o
e-pasta zi=C5=86ojumu, kuru zinu un tic=C4=ABb=C4=81 ticu, ka tam noteikti =
j=C4=81atrod
j=C5=ABsu vesel=C4=ABba.

Es esmu Sandrina Omaru jaunkundze, nelai=C4=B7a Viljamsa Omaru meita. Pirms
mana t=C4=93va n=C4=81ves vi=C5=86=C5=A1 man piezvan=C4=ABja un inform=C4=
=93ja, ka vi=C5=86am ir tr=C4=ABs
miljoni se=C5=A1simt t=C5=ABksto=C5=A1u eiro. (3=C2=A0600=C2=A0000,00 eiro)=
 vi=C5=86=C5=A1 noguld=C4=ABja
priv=C4=81t=C4=81 banka =C5=A1eit, Abid=C5=BEanas Kotdivu=C4=81r=C4=81.

Vi=C5=86=C5=A1 man teica, ka noguld=C4=ABjis naudu uz mana v=C4=81rda, k=C4=
=81 ar=C4=AB iedeva visus
nepiecie=C5=A1amos juridiskos dokumentus par =C5=A1o noguld=C4=ABjumu bank=
=C4=81, esmu
bakalaura un =C4=ABsti nezinu, ko dar=C4=ABt. Tagad es v=C4=93los god=C4=AB=
gu un DIEVA
baido=C5=A1u partneri =C4=81rzem=C4=93s, kuram ar vi=C5=86a pal=C4=ABdz=C4=
=ABbu var=C4=93tu p=C4=81rskait=C4=ABt =C5=A1o
naudu un p=C4=93c dar=C4=ABjuma es atbrauk=C5=A1u un past=C4=81v=C4=ABgi dz=
=C4=ABvo=C5=A1u j=C5=ABsu valst=C4=AB
l=C4=ABdz tikm=C4=93r, ka man b=C5=ABs =C4=93rti atgriezties m=C4=81j=C4=81=
s, ja es to dar=C4=AB=C5=A1u.
v=C4=93lme. Tas ir t=C4=81p=C4=93c, ka =C5=A1eit, Kotdivu=C4=81ras krast=C4=
=81, nemit=C4=ABg=C4=81s politisk=C4=81s
kr=C4=ABzes d=C4=93=C4=BC esmu daudz cietis.

L=C5=ABdzu, apsveriet to un sazinieties ar mani p=C4=93c iesp=C4=93jas =C4=
=81tr=C4=81k.
Nekav=C4=93joties apstiprin=C4=81=C5=A1u j=C5=ABsu v=C4=93lmi, nos=C5=ABt=
=C4=AB=C5=A1u jums savu att=C4=93lu, k=C4=81
ar=C4=AB inform=C4=93=C5=A1u s=C4=ABk=C4=81ku inform=C4=81ciju par =C5=A1o =
lietu.

Ar cie=C5=86u,
Sandrina Omaru jaunkundze
