Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923DB5FFC9E
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 01:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJOX07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Oct 2022 19:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJOX05 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sat, 15 Oct 2022 19:26:57 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700D836DF5
        for <Stable@vger.kernel.org>; Sat, 15 Oct 2022 16:26:55 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id e18so11385259edj.3
        for <Stable@vger.kernel.org>; Sat, 15 Oct 2022 16:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6aF9nFwwA4H8y+DQySeTN9I4LSFxeOQ6cH2LPftSBU4=;
        b=PylwGucp8DT/F1QFDw2FtDbSSwSvUVHllt57G/O0Tk9zAnQtE1XBU941y9DY9sPzZL
         IGmB/KsMRAMLUVoxgHWJwKrc4+USJ7vwNR+0E1Blo8f77Vkmp8mxGhWeyO2vJqgcxeir
         VoPFdoUeKmE53h704uXLL5c0K75eVG5GvPGA6Yii60pZIPHGoYW6aGTvukFgKwcPZtsG
         Gkj5U682jaml2bixgQCcnr+4rXxN7heF3Ayq89zMqXL/2m1pGnA1LOlC3NydNU7ICvM2
         gKew6+l4NTv3c6EJ4VtjmblcrlmSkpvHikhhAd88xjpgypG+MmZ/RyG4plDft1YWJDq9
         XqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6aF9nFwwA4H8y+DQySeTN9I4LSFxeOQ6cH2LPftSBU4=;
        b=nnqEGMHfN+aHLJs9HOMFKxpy4ABJ0QMZkMxk3IaCGUgdbqGSW4LPrXgwK9cyu5m2Pu
         w88LctiFXXRIE0iPgMdJXTwd++l5DPsbHhYaZS4A4c0nXEZpExeCbQqnfKol/pa/AAXr
         bxdaQZhEYEDMJZ8whz8/kbS757OZwhKI1uG0R3H9aLrcrbUEEjGcuoumROOSgfYJVJ5+
         w/sof00siMraL0LiBn1VYZv1MPkDn4y23nA+W/KpZUVrN4uiBvXLHYwPklYmYJOyh2bt
         I+86nOnyGP4iuUf03fNt77KOYiUTBlwGPPCQnjzyY/MwEu2mzpt9Xz2GSus/RWVTdEHl
         6R4g==
X-Gm-Message-State: ACrzQf2ErV1GFSbAQEWO4hYS6JTvarxCoYrG8jgV1MeKmAx875n7Gjyd
        8QG52Ovp48bfhm9RAj/IkoyIxTIILAgxNdkFjwg=
X-Google-Smtp-Source: AMsMyM7yVoSkrE4F3B0rWm2IIEKC4BFe3t2vzAqxjv7XXaXqik7GdvLrqF8ZfyK3Bu0xQiadrwoPzQB+cVJvecc9sIY=
X-Received: by 2002:a05:6402:14c9:b0:459:1a5b:6c47 with SMTP id
 f9-20020a05640214c900b004591a5b6c47mr4132818edx.426.1665876413682; Sat, 15
 Oct 2022 16:26:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab4:8b06:0:0:0:0:0 with HTTP; Sat, 15 Oct 2022 16:26:52
 -0700 (PDT)
Reply-To: richardwahl9035@gmail.com
From:   Richard Wahl <awinokotieno@gmail.com>
Date:   Sun, 16 Oct 2022 02:26:52 +0300
Message-ID: <CAHRfjSBmgVQqxeOhEdxWFi09gju+fhytZJ=dVwkhUEAb37zsBQ@mail.gmail.com>
Subject: Re,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,REPTO_419_FRAUD_GM_LOOSE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:52e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [richardwahl9035[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [awinokotieno[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  1.0 REPTO_419_FRAUD_GM_LOOSE Ends-in-digits Reply-To is similar to
        *      known advance fee fraud collector mailbox
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Sch=C3=B6nen Tag,

Ich bin Herr Richard Wahl, Sie haben eine Spende von 700.000,00 =E2=82=AC. =
Ich
habe ein gewonnen
Gl=C3=BCck in der Power-Ball-Lotterie und ich spende einen Teil davon an Te=
n
Lucky People und Ten Charity Organisation. Ihre E-Mail kam heraus
siegreich, also antworte mir dringend f=C3=BCr weitere Informationen unter:
richardwahl9035@gmail.com
Aufrichtig,
Herr Richard Wah7
