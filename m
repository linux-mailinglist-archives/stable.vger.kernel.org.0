Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6DF62F66B
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 14:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242131AbiKRNjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 08:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242155AbiKRNj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 08:39:29 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0C791C17
        for <stable@vger.kernel.org>; Fri, 18 Nov 2022 05:39:02 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id k84so5669936ybk.3
        for <stable@vger.kernel.org>; Fri, 18 Nov 2022 05:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bIY3TPZTVnWea00k4Qcne3TRu4UILnkul61ceLO7Q90=;
        b=nkVxlm1YlQcNNUfhHA47p9c/F9PbS5LwejtXdyCDeEmQnOocxjDsU1GhMb5fBlC+pc
         jlbdxf/h0kOxtljzQi6wilT2zBvTwnScf1O31wOjF5H9QkjtIJZA8jt3I9wOxDFgKRIX
         kA6wEi/KIrXQ/+gt2qeYGpfaw5+O5PRZbVcVbWLnpnnzmMygwfj021i1/orXmbIIx7XR
         p2Mr59uwSCUjmvEMyKODpH86ShElEAi4TsIKNg7L2cEUDVNEF6O52w0RWPtN9p920pvN
         jsUapXyzUi7kBSbE17dOiywTDKAucplYemzvRn8DMhzbEYY5ZpHdsl8z5Wx5YFTyAJj6
         IJ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bIY3TPZTVnWea00k4Qcne3TRu4UILnkul61ceLO7Q90=;
        b=2mCmzAtvUEwFf/lrUmEKeqms1PsuM56gbK2HMzENeNdJpzroKzjM0GaBSmSKA4IWbt
         G3b2aIUlniEBeCzzkoejOBzpKaCGahDZeW2UKgAM8wUesOaZCXP1kSAsttnsYhjCx1jp
         XNViSDyAJYDA+9gqA+A0P/4yVvlQLrdDc/fSSO9FSvBvVp9uU8j3FE0J6vCzRcqNuv30
         YZW7oLgqlZ6jILTWkPZqgdNS3pyu4ww5NCMQ862xLXze1m6pKjmIGS6iF79OJs+yKahe
         Uu95DjZKi1N4XciPKZ67u0Hdgn7dtHEnU5AGpezQ4QVxzmhwn1xcn8Bxy95Wic1gf35D
         wXFQ==
X-Gm-Message-State: ANoB5pk3ZTEgIEmS3WaC5eVNiVecAirHuD9RqLcXedwBGiPGecwJM21Q
        kVrcK1mFgoexBmAUIZBywdPQzpMvlsVP9pZvaQ==
X-Google-Smtp-Source: AA0mqf6hctJd0z6WSY5g/l+c6jJxt2jfDlQDTnCORUJ/I0Dkj2SMJJ6PYnJW8CuqAC5b9iZAc0tuKMWQyi731e0pKXA=
X-Received: by 2002:a5b:b:0:b0:6d1:e501:396c with SMTP id a11-20020a5b000b000000b006d1e501396cmr6700713ybp.318.1668778741174;
 Fri, 18 Nov 2022 05:39:01 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7000:a00d:b0:3de:70b3:6b92 with HTTP; Fri, 18 Nov 2022
 05:39:00 -0800 (PST)
Reply-To: tn0056454@gmail.com
From:   BELARBI MALIK <louisemoses98@gmail.com>
Date:   Fri, 18 Nov 2022 13:39:00 +0000
Message-ID: <CACVZsqqfA5dSmDc-63vH3fuNVsWi6cqujNNeU7PhV+bz-31hFQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b2b listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [louisemoses98[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [louisemoses98[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [tn0056454[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Sch=C3=B6nen Tag

Mein Name ist Belarbi Malik. Ich bin von Beruf Rechtsanwalt. Nachdem
das Ecowas-Gericht die Kisten/Erbverm=C3=B6gen unserer verstorbenen
Mandanten freigegeben hat, m=C3=BCssen Sie diese Kisten erhalten. Ihr
Cousin, mein verstorbener Klient, hat hier in meinem Land an der
Goldk=C3=BCste nicht abgeholte Kisten zur=C3=BCckgelassen. Ich erwarte Ihre
Antwort bez=C3=BCglich des Verfahrens und Kopien der Dokumente werden Ihnen
zugesandt.

Belarbi Malik
+22897822988
