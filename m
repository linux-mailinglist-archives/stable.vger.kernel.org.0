Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB1D5BFD47
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 13:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiIULsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 07:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiIULrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 07:47:15 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083E095E5C
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 04:46:50 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id q21so8241130edc.9
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 04:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date;
        bh=aMioWMQ5lVJKEiDBUkqZkMsP+xqmAfQusNjWWrMJHWU=;
        b=VZFX/owpW60m19RjbPDQr6fJwu1BQwBrYNFp0MU0SVl2LwMBU2G/xBXej+R4r0xB3O
         Mw5CqB/A4ZcGSyqQBj4uQhDhFBFyyxi/65yYf9ieBR64Zo8X7RgSurXDA2dF6JKBOTqj
         qL3AD1E0ghm5Dgl8rYbmAo+1dAQ90/ZijyEecHaA9rL1rxBfIBwb8Ex4DWVQ/rsg4txH
         oE4x7HVWJ8/C7NoPsiAnuUbaopfIn3j2hiwCW51LTqO03fsuZROY/z1fekb+ikDMF61c
         BvdBrCUpxdcQtjJuvJ+04aM2SkUfrwu11zPe+w1sc2giP3Tff6r4XzzwjrUYiGRZHNZB
         NgIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=aMioWMQ5lVJKEiDBUkqZkMsP+xqmAfQusNjWWrMJHWU=;
        b=TRZefkbRaAKnbv53CMG+g+gZF63uN0qn2fzjFe32WIWL8zbD9ekcp+ESjmV64ZpHCn
         9IG6C3n26CUWZCwAWKnHD2NYrohrI+S9UnbFzPzvj3fNrMWjmZiS1VXwS4YuNxAjVK1/
         CV2T5la+JuVnMWYDCPrb7j3a7yNWrgQgstDnC3upMJ5ignGUKe2qN+xkjBDvybxDDM0I
         q/SnN6HkMmfa1B6VZxduOWJ/si211ie7zPt83Nozo3TLNJO3PX0SlfO9ve5+Kxz6imyv
         nAV8CPnYdIjm2lgziRMVHzIaXwM4XjDTVUACBVc9g5DuQy34Jxa6uoadHsl7jqi5p35M
         KkvA==
X-Gm-Message-State: ACrzQf3bJnVMGpkuod3B+qkINBXduWow6frfokwM9r5A0oxsVxH0tZho
        BVpdUzIraPf3US40whYXODw8KXmouf+oOLk7p9o=
X-Google-Smtp-Source: AMsMyM7PLCpiqrkjmjrmDj1KR/mk4ePW9w0awszk8YeXGr/SLqntn5EkKDN2QA3ANCaGK1psqj0omDetCSRVg9pyIOI=
X-Received: by 2002:a05:6402:1e8c:b0:44f:f70:e75e with SMTP id
 f12-20020a0564021e8c00b0044f0f70e75emr23806361edf.405.1663760808985; Wed, 21
 Sep 2022 04:46:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:b099:b0:781:9b2e:3103 with HTTP; Wed, 21 Sep 2022
 04:46:48 -0700 (PDT)
Reply-To: albertabossi2020@gmail.com
From:   Barrister Albert Abossi <albertabossi04@gmail.com>
Date:   Wed, 21 Sep 2022 11:46:48 +0000
Message-ID: <CABNWvX1ph9YCO_U3gJzN5D7hY5DJ7N9xUx88s+iEqiZKbsCthQ@mail.gmail.com>
Subject: Lieber Freund
To:     albertabossi2020@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.0 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:529 listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [albertabossi04[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [albertabossi2020[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [albertabossi04[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Lieber Freund
Ich bin von Beruf Rechtsanwalt hier in meinem Heimatland Togo in
Westafrika. Einer meiner Mandanten aus Ihrem Land hat hier in der
Republik Togo mit einer Briefkastenentwicklungsfirma
zusammengearbeitet. Mein Mandant, seine Frau und ihre einzige Tochter
waren hier in meinem Land in einen Autounfall verwickelt. Ich habe
beschlossen, Sie zu kontaktieren, damit die 10,5 Millionen Dollar, die
er hier in einer Bank hinterlassen hat, sofort auf Ihr Bankkonto
=C3=BCberwiesen werden.
Mit freundlichen Gr=C3=BC=C3=9Fen.
Rechtsanwalt Albert ABOSSI
