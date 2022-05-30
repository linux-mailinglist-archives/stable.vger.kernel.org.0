Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D7653799F
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 13:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiE3LQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 07:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235602AbiE3LQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 07:16:23 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A695A79816
        for <stable@vger.kernel.org>; Mon, 30 May 2022 04:16:21 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c2so10060362plh.2
        for <stable@vger.kernel.org>; Mon, 30 May 2022 04:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=33Igllj9tfLyGSvJIhbu1oHlrScc1HW+kabxB9lZ0T0=;
        b=LzqIOHialgEsH9Ix1F8iLmtEfyuzPluauxpS75uaeBjgfz9bZGJpu1iO/OC0jbZ52e
         /6ai3gRbtA0rDWY8W3oehmqAqSHbbKv7q3jCo8tmsZBmsTgvgxTU1FFEwYxPKGcatop9
         8S+j06vgJrittZvUJn6gm2HdSOO/Wso0n5QDO8LZlyg94jttK6DwxrgbtLlHbevf6Jh+
         DvkU8smHAVrI0NbWzV1O0F/6k4BMiOqtz/iLSSCKkIotlRhY70NTZvB9M1tKEL+4iZz6
         IEb11k0+ZTBYnl3bilMcOLesKsLQ7Sp0ni5Pm1GsKyJhjSwzzcY/l1aD6GcLCJ4RiSmJ
         Ru3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=33Igllj9tfLyGSvJIhbu1oHlrScc1HW+kabxB9lZ0T0=;
        b=j8XhzoEkJtOP1hz8QVAgK8TdXbSXv46Q61cpjRNyVodWvEnq0JCRcMaLwtjt9aLiic
         4+0nznJygBDwcfOhmTXcnhQQsL/tvwwgqjiY1cyHKhSXB1ZXzDnZraOcDvUdhQHOhxas
         m7qk7/e9Rf1nGyj0B64xuX9StEjsPCZQBaMY4UJuEQ45jTgbWlfx7JdGVqEO7ydHqTwM
         ufkeetUeiq9mG+SNC1Hlw93F3fw7eJWFtCVRDgQ5OBo/MHKVYNDo4CZpwfFL2MdJYVv6
         2gqsugQaHul30nJRkMcJL0dNgpSz8rKmM0mpRJdKSHug9VznttjQoBLVoPPgLB/sOGWQ
         wThA==
X-Gm-Message-State: AOAM531uGUR6WJP+LyqHp74GrAI36pqpfKNRQfP2rMKXI76OWwMUkpcN
        R/XmuoAobr0wbtF6f6jXuF6MC3jC9G4K70NXNHU=
X-Google-Smtp-Source: ABdhPJxB/pES8nTU/wbtU7fZCTywZqX/hQdCmKSCcBPeuATRJ0+gR5zXUXQM9PZq73eyn13m6+nyr7J6fAnLaWpR/dw=
X-Received: by 2002:a17:902:8501:b0:15f:173:40e1 with SMTP id
 bj1-20020a170902850100b0015f017340e1mr55462101plb.74.1653909381223; Mon, 30
 May 2022 04:16:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:8f26:0:0:0:0 with HTTP; Mon, 30 May 2022 04:16:20
 -0700 (PDT)
Reply-To: georgebrown0004@gmail.com
From:   george brown <eddywilliam0002@gmail.com>
Date:   Mon, 30 May 2022 13:16:20 +0200
Message-ID: <CAP8JzxKU2YBu--tpiLkn_dgifnSeAnyzSSwR=_KfNEb9K0ZX_g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5421]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:62b listed in]
        [list.dnswl.org]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [eddywilliam0002[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [georgebrown0004[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [eddywilliam0002[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hallo

Mein Name ist George Brown. Ich bin von Beruf Rechtsanwalt. m=C3=B6chte ich
Ihnen anbieten
die n=C3=A4chsten Angeh=C3=B6rigen meines Mandanten. Sie werden die Summe v=
on
($8,5 Millionen) erben
Dollar, die mein Mandant vor seinem Tod auf der Bank gelassen hat.

Mein Mandant ist ein B=C3=BCrger Ihres Landes, der mit seiner Frau bei
einem Autounfall ums Leben kam
und einziger Sohn. Ich habe Anspruch auf 50 % des Gesamtfonds, w=C3=A4hrend
50 % Anspruch haben
sein f=C3=BCr dich.
Bitte kontaktieren Sie meine private E-Mail hier f=C3=BCr weitere Details:
georgebrown0004@gmail.com

Vielen Dank im Voraus,
Herr George Brown,
