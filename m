Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACD43B908C
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 12:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236045AbhGAKhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 06:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235300AbhGAKhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 06:37:18 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4EEC061756
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 03:34:48 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id i13so5893884ilu.4
        for <stable@vger.kernel.org>; Thu, 01 Jul 2021 03:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=zJC6vFSlisCfwN523NvKGB8c9gswKFdqKMnOWqU/a6U=;
        b=SIuJNeFlC/7IVoNCvLlromCeid/w3KbFu1j/jTbBgmwcA43pxHlnU6tf2eGVN20Gyo
         m0Is7MKzsvjTZAl9ZGxeho+BTr1H4nkcZu7g1EVenHLXGYG0HgiypiJvJIkgl2XsVSUo
         62+VA3Oj9PD7xO3FBS7p9HhuMH16bBrsb4AsZuKbXrfafmLhX1D2SsU9b5QeUUAqxxGI
         rG/yl8JuORYoLBO/DqBFp2/UcXbzHH51sxybRJsx1BIUxOugUwcZmmP63I8EL3A0l+Si
         t3iCfKEphqKY4g50bx34hvV0j84hmmRM0vWQi15LBKClf9eAGCccMEKij5i8OByMInAB
         iiJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=zJC6vFSlisCfwN523NvKGB8c9gswKFdqKMnOWqU/a6U=;
        b=FP7PuppmGyHEI56196F+yOEih3AH7pI+konXsQa9aKINc5BwZ9609zH08WYhDJMaO8
         8Mu/4Au1D8WJFjICjMgp/II131mLzNtmhYfnmcXlNdkMwe1NlBhqif+1BmRrSZtVAVur
         O7QSQm6hKGK0Uo0SK4pCtwnJOzga7P7kbQN5UL3GBUzIR4tO9VtR5Z9lwoQ94JsMvP3n
         1MHZHPtWxLbKOwXA+8bl9o4toWr23EGym8T6KwNHSBXMFy3amXkpsRwX22a1Rp3SPDiU
         bsUHL3gulx7Rm2zXB8EZuISUkbf2dj9r/5wxnJCkr7Q0HvEmCCWuEZd4bRwPGX9mWd6p
         ky1g==
X-Gm-Message-State: AOAM532D+uKukYN0watnjUWTP1YclZQ3zrBSEYN3Ip9apEpXWQrLCed6
        h9/uDWBywhDVkpMuz9fy9A/4JXlRUxdFQr3y8QM=
X-Google-Smtp-Source: ABdhPJz90+mZoJH1leR8P4OVvoalxuW5GC/h3eP9GQFYiCPU8jt7dA+E+7AwHg5qMBf/pLjePElMNp2ChsXAW7D+qJE=
X-Received: by 2002:a92:d2c5:: with SMTP id w5mr16046481ilg.174.1625135687842;
 Thu, 01 Jul 2021 03:34:47 -0700 (PDT)
MIME-Version: 1.0
Reply-To: d807vfh57p@gmail.com
Sender: kashmiri90933miri@gmail.com
Received: by 2002:a02:cddb:0:0:0:0:0 with HTTP; Thu, 1 Jul 2021 03:34:47 -0700 (PDT)
From:   Prichard Dixie <m568987k@gmail.com>
Date:   Thu, 1 Jul 2021 11:34:47 +0100
X-Google-Sender-Auth: 0UVh8llweHRBLbVZs8DCHdYakRk
Message-ID: <CABxN3a6TEC+p12zftnJGT39RHtCvJK3KkV-=pE3USDnzD4bOwg@mail.gmail.com>
Subject: =?UTF-8?B?UE9KxI5NRSBQUkFDT1ZBVCBTUE9MRcSMTsSa?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ahoj,

P=C5=99ijm=C4=9Bte pros=C3=ADm mou omluvu za to, =C5=BEe jsem v=C3=A1m naps=
al p=C5=99ekvapiv=C3=BD dopis.
Jmenuji se Dixie Prichard, hlavn=C3=AD provoz / region=C3=A1ln=C3=AD =C3=BA=
=C4=8Detn=C3=AD First
Pillar Finance Bank ve Velk=C3=A9 Brit=C3=A1nii. Jsem =C3=BA=C4=8Detn=C3=AD=
 jednoho z na=C5=A1ich
klient=C5=AF ve va=C5=A1=C3=AD zemi, kter=C3=BD m=C4=9Bl v roce 2006 u na=
=C5=A1=C3=AD banky projektov=C3=BD
=C3=BA=C4=8Det v hodnot=C4=9B 6 300 000 GBP GBP (=C5=A1est milion=C5=AF t=
=C5=99i sta britsk=C3=BDch
liber). Byl =C3=BA=C4=8Dastn=C3=ADkem leteck=C3=A9ho ne=C5=A1t=C4=9Bst=C3=
=AD, ke kter=C3=A9mu do=C5=A1lo 1. ledna
2007; b=C4=9Bhem t=C3=A9to katastrofy zem=C5=99el s celou svou rodinou. Zpr=
=C3=A1vy
najdete na tomto webu:
https://www.flightglobal.com/final-report-adam-air-737-plunged-into-sea-aft=
er-pilots-lost-control/79402.article

Cht=C4=9Bl bych tyto prost=C5=99edky investovat a p=C5=99edstavit v=C3=A1m =
banku jako
p=C5=99=C3=ADjemce zesnul=C3=A9ho klienta pro tuto transakci. V=C5=A1e, co =
pot=C5=99ebuji, je
va=C5=A1e up=C5=99=C3=ADmn=C3=A1 spolupr=C3=A1ce a slibuji, =C5=BEe se tak =
stane na z=C3=A1klad=C4=9B
legitimn=C3=AD dohody, kter=C3=A1 n=C3=A1s ochr=C3=A1n=C3=AD p=C5=99ed jak=
=C3=BDmkoli poru=C5=A1en=C3=ADm z=C3=A1kona.
Souhlas=C3=ADm, =C5=BEe 40% z t=C4=9Bchto pen=C4=9Bz poputuje v=C3=A1m jako=
 m=C3=A9mu zahrani=C4=8Dn=C3=ADmu
partnerovi, 50% mn=C4=9B, zat=C3=ADmco 10% p=C5=AFjde na zalo=C5=BEen=C3=AD=
 nadace pro
znev=C3=BDhodn=C4=9Bn=C3=A9 lidi ve va=C5=A1=C3=AD zemi. Pokud byste m=C4=
=9B cht=C4=9Bli vyslechnout,
poskytnu v=C3=A1m v odpov=C4=9Bdi na tento dopis ve=C5=A1ker=C3=A9 podrobno=
sti o t=C3=A9to
transakci.

D=C4=9Bkuji za va=C5=A1i nal=C3=A9havou odpov=C4=9B=C4=8F.

S pozdravem,
Pan=C3=AD Dixie Prichard.
