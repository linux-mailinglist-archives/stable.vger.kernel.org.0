Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BA841CBD2
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 20:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346150AbhI2S3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 14:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346121AbhI2S3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 14:29:10 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5E2C061764
        for <stable@vger.kernel.org>; Wed, 29 Sep 2021 11:27:29 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id az15so4130772vsb.8
        for <stable@vger.kernel.org>; Wed, 29 Sep 2021 11:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=okE6uYssVxlrHpNZxYNSY75OjjqU1G8ZWpy8hg3xuB0=;
        b=m9jNO6Te3WPz86OxLpUmoWaDf2Ra9kqeN/DfyaHrG0STjJcMIADYv9u12PdeKX8aP1
         hO8OXlbzXC/xhc2UPyh0iY/gdgNUkST46zyqnfeBQpQnnQVihCMwllMV58iwGeQmXHDB
         QPTiCzTDq/nidtgcxo6qY7AFrkluvwtiFW5il7QLSNhG9Svs5Pf/KZKpOxmPQNt67yWa
         Jfh+Tt49wsuTSoieurIMZVocRTDsR5OZ35FRAy/uhXAQ9y50MPd0f5WOE/ie+WKszjnS
         o/QyA9H69wdJTnB6e+VJG9LXg6XI3GlN2Sp+n4umg+7Ob5Ea7zdjqeGbud5xWUGQpAJx
         3MPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=okE6uYssVxlrHpNZxYNSY75OjjqU1G8ZWpy8hg3xuB0=;
        b=0FboDLQ97oAGQa1cmf4Ftm4fDQBiqKN79CnLJvGi0hE7A9r6IDv8ZTHmpSC/FX4TEf
         7TOWt62sW4AKTRkRilf3mwfEykAT2fe0eDuws+g2WB+nNOK6WTej09an5g/d1mcyELb1
         Lr7MSzVtcrwxUOppdqEtH3y6cKZJXp07KoewR1Bph+bxVlgF5O2lUTWkZ4Arqwshmvkr
         qB/ewHSQNVdoMW9YT08XXT0AQD2ntWx4vuwnFakNGfI3rFCU2QbuSXJFw1W7YyCDNmmJ
         ye/M7GHab6AByTihUAhqICLAJeToN7x44AdGIutX04s+4mtuYVbk9DmCDpe5xrNTxOwx
         htSA==
X-Gm-Message-State: AOAM533eBjcu2RZSt+wh9FI4WDyVpEpABJRhNYUCGCTV41/dB3Zla2F5
        LA7GuA+S4hjqzRwWpeyIQTx4gMggYKRoCqW66Zk=
X-Google-Smtp-Source: ABdhPJxnJ/vj5i8MrgGuRKcw6m5Q2XEuylV0nyT3W2prXejKl5sYqhhrJrBOZgBLcR8Y5mhGCB3JpZ1tOILdheLyHbc=
X-Received: by 2002:a05:6102:a8d:: with SMTP id n13mr1920318vsg.17.1632940048563;
 Wed, 29 Sep 2021 11:27:28 -0700 (PDT)
MIME-Version: 1.0
Reply-To: martinafrancis022@gmail.com
Sender: edwinasmith933@gmail.com
Received: by 2002:ab0:4883:0:0:0:0:0 with HTTP; Wed, 29 Sep 2021 11:27:27
 -0700 (PDT)
From:   Martina Francis <martinafrancis655@gmail.com>
Date:   Wed, 29 Sep 2021 11:27:27 -0700
X-Google-Sender-Auth: ixruka1Lxiqy37ihsenl3lxwa5M
Message-ID: <CAHbqCvQqP-gMhgixrRN7hq-0f3+URFMy3fuY35RczQAFwAWdog@mail.gmail.com>
Subject: =?UTF-8?B?RG9icsO9IGRlxYggbW9qYSBkcmFow6E=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Dobr=C3=BD de=C5=88 moja drah=C3=A1,
Ako sa m=C3=A1=C5=A1 dnes a tvoja rodina?
Som pani Martina Francis. M=C3=A1m fond (2 700 000,00 MILI=C3=93N USD), kto=
r=C3=BD
som zdedil po svojom zosnulom man=C5=BEelovi a chcem prostredn=C3=ADctvom v=
=C3=A1s
darova=C5=A5 chudobn=C3=BDm =C4=BEu=C4=8Fom, t=C3=BDran=C3=BDm de=C5=A5om, =
menej privilegovan=C3=BDm osob=C3=A1m,
cirkv=C3=A1m, sirotincom a trpiacim vdov=C3=A1m v spolo=C4=8Dnosti. Ale ja =
tak dlho
trp=C3=ADm rakovinou, =C5=BEe som bol hospitalizovan=C3=BD na lie=C4=8Denie=
. Teraz m=C3=A1m
strach z toho, =C4=8Do mi lek=C3=A1r ozn=C3=A1mil po s=C3=A9rii testov na m=
ne, =C5=BEe kv=C3=B4li
chorobe mo=C5=BEno nebudem dlho =C5=BEi=C5=A5 a ob=C3=A1vam sa, =C5=BEe pr=
=C3=ADdem o tento fond pre
vl=C3=A1du, preto=C5=BEe sa nestaraj=C3=BA o chudobn=C3=BDch v spolo=C4=8Dn=
osti.

Ocen=C3=ADm va=C5=A1u =C3=BAprimnos=C5=A5 a odvahu zvl=C3=A1dnu=C5=A5 tento=
 projekt.
Kontaktujte ma ihne=C4=8F po pre=C4=8D=C3=ADtan=C3=AD tejto spr=C3=A1vy a z=
=C3=ADskajte =C4=8Fal=C5=A1ie
podrobnosti o tejto humanit=C3=A1rnej agende.

Boh v=C3=A1m =C5=BEehnaj, k=C3=BDm =C4=8Dak=C3=A1m na va=C5=A1u odpove=C4=
=8F.
Va=C5=A1a sestra.

Pani Martina Francis.
