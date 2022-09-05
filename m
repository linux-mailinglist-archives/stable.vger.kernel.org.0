Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0CE45AD433
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 15:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237738AbiIENmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 09:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237401AbiIENms (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 09:42:48 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340264DB03
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 06:42:47 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bj12so17139787ejb.13
        for <stable@vger.kernel.org>; Mon, 05 Sep 2022 06:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date;
        bh=6iyQDafiYBXnSsgnRlfbKAxcwMtuNVs3v7T0vJde0mE=;
        b=VTCEk5OnVzeHsW3Uh732EeYnbO8ORxqJy/rd9MHzTU6uSBa2B0+Iz9hrfE1qUTgii0
         YtMwup19cgx1v3Xnil3PBxCZihTCd3erO6agLJmIztCeGRWZjbfKZ0SvMYuOo/MeryOk
         zECR/CmU5EA5gD1GWjsm8YBDsWYSw8uDAR4QnARH7r5/suf4ZRUSvJaPADW6e3ZG9eiC
         FueEO4GgM0CjGEyPDR9QN7klRHt4BjFBFv7azzVEi/Dcuckc9ygMZQTtngDnAxomLCW1
         YPmKw4RWpC9P7aHaWCkOLphpROVE5bauqhUZjjBWD1mgPgQ5wpljr5dyNHVmYUsPFnkW
         uMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=6iyQDafiYBXnSsgnRlfbKAxcwMtuNVs3v7T0vJde0mE=;
        b=Pe/8GpWxC18d3esaWOlvDA1vveS3TTr+V18vunw3+OF+Efb45RR2lSSxUcWFWBystn
         Xl7ci+fgZp7qN/01nzsolCOY/+6CVfmbP7eJaoCCkEROesNa3AWYPRYEYgkyUsWS1L5D
         7bXSP9iCvqIFwOIH/cRkF70zqg0tRU2G6SaEpn4cVxKQr3u6/5zI7Fdegaa6R2pNVSbU
         MDw6NtKQnGlnbAXwC+B5wkNcz9tU1X4adt3z2BIioTUQxlmgB8vuwpwqfIaRUWPEnM8T
         Tia2y1Jk2r+kMfO8wmvH07dGwfMIq+ezsnj7A+nzbYEYkIZvWzXRHhnR6RED1CgLLWTs
         VEEg==
X-Gm-Message-State: ACgBeo0rhPpqtJMIlDgUvvN9/8UFb93Kn37X7RM/jmyxz+0jGocFmqnn
        Zr376qlysy44ZItQlJJyvhqeLDEYUl/FsRhjMhU=
X-Google-Smtp-Source: AA6agR6lOLw//C3vejv6M4CjNP9ooy40+8HMDDNptdILGHypBt9O7CALo0Ye4d2cpM8b/3860CvjD9/lk0DIutJ93j8=
X-Received: by 2002:a17:906:cc4a:b0:73d:d3b9:b263 with SMTP id
 mm10-20020a170906cc4a00b0073dd3b9b263mr34085666ejb.130.1662385365802; Mon, 05
 Sep 2022 06:42:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:b057:b0:731:5c70:4fd1 with HTTP; Mon, 5 Sep 2022
 06:42:45 -0700 (PDT)
Reply-To: lemrtino@outlook.fr
From:   Lene Martino <lemrtin06@gmail.com>
Date:   Mon, 5 Sep 2022 15:42:45 +0200
Message-ID: <CAGWLuk1f9jfuewDCH4DhYJ7s5AYeHmpJXynjEobtz=gvKm3Nsw@mail.gmail.com>
Subject: =?UTF-8?Q?Ihre_Hilfe_wird_ben=C3=B6tigt?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.8 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:629 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6132]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [lemrtin06[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [lemrtin06[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mit geb=C3=BChrendem Respekt und Menschlichkeit war ich gezwungen, Ihnen
aus humanit=C3=A4ren Gr=C3=BCnden zu schreiben. Mein Name ist Lene Martino,=
 ich
komme von der Elfenbeink=C3=BCste und bin 57 Jahre alt. Ich bin mit dem
verstorbenen Dr. Joseph Samuel Martino verheiratet, der in einer
=C3=96lfirma in der Elfenbeink=C3=BCste gearbeitet hat und nach einer
Herzoperation gestorben ist. Wenn es Ihnen nichts ausmacht, w=C3=BCrde ich
gerne ein wichtiges Gespr=C3=A4ch mit Ihnen f=C3=BChren, in dem es um meine
Entscheidung geht, mein Erbe, das ich in einer der Banken hier
hinterlegt habe, f=C3=BCr den Dienst an der Menschheit durch Sie zu
verwenden, weil ich nicht wei=C3=9F, wann mein Sch=C3=B6pfer meine Seele ab=
holen
wird.Der Betrag betr=C3=A4gt nur 5,5 Millionen US-Dollar. Sehr, sehr
wichtig. Wenn Sie interessiert und =C3=BCberzeugt sind, mir bei der
Verwirklichung dieses wohlt=C3=A4tigen Projekts zu helfen, lassen Sie es
mich wissen, um weitere Einzelheiten zu erfahren. Ich werde auf Ihre
dringende Antwort warten.
Mit freundlichen Gr=C3=BC=C3=9Fen,
Frau Lene Martino,
