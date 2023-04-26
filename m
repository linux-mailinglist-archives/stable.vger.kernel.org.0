Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247876EF428
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 14:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240753AbjDZMSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 08:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240073AbjDZMSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 08:18:41 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B0035AD
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 05:18:40 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-54f8af6dfa9so101011227b3.2
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 05:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682511520; x=1685103520;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cOd+Ds7KFnoaekJ490RgZGRU/abwwF9KDQ9a6orHR2g=;
        b=LAbNgWz2pesCdanBe3w7v0Tz/TLFtRDd5s9pIf3akP8PSCSjr/n9CYqUCXXohSIKDe
         KINr64uZYWOOaoQ0cUyt40Wc/IbHwKnLgYCMVLup2PvMBdjwQASmyKwEM3AKQcyhIAeq
         D5xOyL9RhXAoeMwP7aTduD/dgeeoRszft8qZuiTFHOjOdRR4kW6CUq7HMI7yJ+BTTBD3
         YCrhhwl/VOu5DBaiTsUHOvuTpQjYpNP27qPUZkjHNjLNv7qjKyfS+YwK2ZjZnxEYqEu3
         CS3ehGUcNmUImjX95EaBq/cDjnW0dR4FezfTt8ZXYXxhNwS5piG6Q50iF9/QkRfV2nMI
         tcuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682511520; x=1685103520;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cOd+Ds7KFnoaekJ490RgZGRU/abwwF9KDQ9a6orHR2g=;
        b=VCzONDeTd5EmqPIE9xqfjQQ0dho5zHHPX5sC2LyJWfZuerwHjNUgrplPE3Y6hLYVW/
         vwb3qZfpCpwhw9m0oD+Twl4xPN+BgGKRy+weGGsoZ1LV4fp7ufRlZwqM+2eas4RjnDwj
         rOAbI09GcNRP/MOTf6U53R7V9+P4BoMVxBouTjQI23FbVX4jHL9Iak89ZNT6IJdP9s7Z
         NnLzteROmi1brY32hl5iD5RcfkRgT6jmXW+K/C/GVUTfo6tj765ZbzfwXdYcQX+zMZgB
         4Gl7gnFVfyuTEOUiCNIGFuMLn9h6NXVHAwQ6G2xh3t/e01jwhGiRniTWoDmsihtrKebi
         FsJw==
X-Gm-Message-State: AAQBX9c3YEMvy4VD1LcL1xY9AHTkei359Qm7hqspi9UqrLMAF4aJxdxT
        hkTzU8eNcBn1pwIP8dLV5HZR/+sd/3ZnQy1v06Q=
X-Google-Smtp-Source: AKy350Zuqte5ojNEeonBcC7Gzt4kqhfDTDX/+dwREFBq8M0YideCerD5YufJoWF8bch2o99NNNyAlEKsMoubjGgminA=
X-Received: by 2002:a81:53d7:0:b0:54f:752e:9b09 with SMTP id
 h206-20020a8153d7000000b0054f752e9b09mr14447637ywb.15.1682511519863; Wed, 26
 Apr 2023 05:18:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:89c:b0:480:31ea:54ac with HTTP; Wed, 26 Apr 2023
 05:18:39 -0700 (PDT)
Reply-To: jon768266@gmail.com
From:   john <loukoutama@gmail.com>
Date:   Wed, 26 Apr 2023 12:18:39 +0000
Message-ID: <CAA=aZZWR2JpbK9+NpJO4zPQT7myD1+DqiEH=FRh9VEXWRwX9Sg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:112d listed in]
        [list.dnswl.org]
        * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [loukoutama[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jon768266[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.1 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  3.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jsem r=C3=A1d, =C5=BEe v=C3=A1s mohu informovat o m=C3=A9m =C3=BAsp=C4=9Bch=
u p=C5=99i p=C5=99evodu t=C4=9Bchto
prost=C5=99edk=C5=AF ve spolupr=C3=A1ci s nov=C3=BDm partnerem z Indie. V s=
ou=C4=8Dasn=C3=A9 dob=C4=9B
jsem v Indii kv=C5=AFli investi=C4=8Dn=C3=ADm projekt=C5=AFm s vlastn=C3=AD=
m pod=C3=ADlem na celkov=C3=A9
sum=C4=9B. Mezit=C3=ADm jsem nezapomn=C4=9Bl na va=C5=A1e minul=C3=A9 snahy=
 a pokusy pomoci mi
s p=C5=99evodem t=C4=9Bch prost=C5=99edk=C5=AF, p=C5=99esto=C5=BEe se n=C3=
=A1m to n=C4=9Bjak nepoda=C5=99ilo. Nyn=C3=AD
kontaktujte m=C3=A9ho sekret=C3=A1=C5=99e v Lome Togo s jeho n=C3=AD=C5=BEe=
 uveden=C3=BDm kontaktem,
upustil jsem certifikovanou v=C3=ADzovou kartu do bankomatu, po=C5=BE=C3=A1=
dejte ho,
aby v=C3=A1m poslal v=C3=ADzovou kartu do bankomatu ve v=C3=BD=C5=A1i 250 0=
00,00 USD,
kterou jsem mu nechal za va=C5=A1i kompenzaci za ve=C5=A1ker=C3=A9 minul=C3=
=A9 =C3=BAsil=C3=AD a
pokusy pomozte mi v t=C3=A9to v=C4=9Bci. Velmi jsem si v=C3=A1=C5=BEil va=
=C5=A1eho tehdej=C5=A1=C3=ADho
=C3=BAsil=C3=AD. kone=C4=8Dn=C4=9B si pamatujte, =C5=BEe jsem p=C5=99edal p=
okyn sv=C3=A9 sekret=C3=A1=C5=99ce na
va=C5=A1e jm=C3=A9no, aby vydala kartu s v=C3=ADzem do bankomatu jen v=C3=
=A1m a v=C3=A1m, tak=C5=BEe
se s n=C3=ADm spojte a p=C5=99epo=C5=A1lete mu sv=C3=A9 informace, va=C5=A1=
e cel=C3=A1 jm=C3=A9na, adresu
a kontaktn=C3=AD =C4=8D=C3=ADslo pro snadnou komunikaci, dokud nebudete z=
=C3=ADskat
v=C3=ADzovou kartu do bankomatu. (jon768266@gmail.com
S pozdravem
Orlando Morison.
