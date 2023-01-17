Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F013B66D3B3
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 01:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbjAQAvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 19:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbjAQAvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 19:51:42 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF3A193E9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:51:41 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id jr10so18748541qtb.7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JjbMwH7wtztxpVEzNDiuMUnQ9Jvb8RCm9+Fyzzo0gjk=;
        b=fzivUWc/bQQY9c2LQrQS7RAuMM3Xeq0pH8yqQ17jRCfzlXQr1iHIWQmYknf2tfqWST
         9IACCRaLsyFLBguxCMDhdVHFV2ZbegoQHitNZMtfIeHIKzdeikNRRe8rPWGxSAYP3WIC
         kY1Ce+tFygyCGbODtibzgNNBcVNsGX44l5Tz8Z3q4uEAvYzRYscKhIcAD1zMHFSKgMbt
         d4LLecE8Ig99bcO83R+XIi6+GdSfvrKUIRVT+szjD+ADtTVRhmGyVoSi7sclOf2xBzNj
         zU2buAPVcZsw3ajox+h/W5wA03k21q9L2GkuzXdl4mjpoDkTKpUtzsS4W7UOIKEaTau7
         AsaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JjbMwH7wtztxpVEzNDiuMUnQ9Jvb8RCm9+Fyzzo0gjk=;
        b=fNnT7kZIxTVKP0Ac2VCq47AFa7Xq61hJjDC3I2n984KWh1jlFQjCP5zpJRZEQ7Chfn
         IJQhoccHAnrZq2gWWWdsRhapblbOZaFzMoSLCjVrtrZ1I6NJENaPke+LIHulvPym8OHo
         gdyDQQoulAd85KBj5XbJyX7Y8zZn/ac6p0wnLNob7xitEdn05m51wyIefOIJCzmSvXWF
         Z55M84PtBp8LMZ0Z52EG3aw+CdJzCNbcpYaz7wi9VWUDjjOx1+UGDk0ba2YlgWyRpaOm
         677YAaE9pV2p1+fKiWsklhjede95XSL/fGHBhb3F9ZWfTUbjVhd47sM7sT5ahV0vhfEy
         d4SA==
X-Gm-Message-State: AFqh2krH9rZlwxfiBUemPyu33L5gB9NV0NPA3+x51pXWrbIyHlu1PBNe
        LeGLqoBsUJ6RUrIveOYvDT8rjrXGwS+h6d6uE4c=
X-Google-Smtp-Source: AMrXdXt9wO6ugxajMcV4JuPk+VDE0tqGrNt41xFsXpkTtLaE1cEIdgT9k8zNh9vjagcU91uJeOfmIPf5YGxzdRtNaYM=
X-Received: by 2002:a05:622a:1c09:b0:3a9:8370:63d7 with SMTP id
 bq9-20020a05622a1c0900b003a9837063d7mr49974qtb.362.1673916700326; Mon, 16 Jan
 2023 16:51:40 -0800 (PST)
MIME-Version: 1.0
Sender: jennehkandeh9@gmail.com
Received: by 2002:ab3:ef8d:0:b0:4b2:a25c:b9b0 with HTTP; Mon, 16 Jan 2023
 16:51:39 -0800 (PST)
From:   Jenneh Kandeh <jennehkandeh07@gmail.com>
Date:   Tue, 17 Jan 2023 01:51:39 +0100
X-Google-Sender-Auth: emS03vTNlbmNtIul3NPMzDDp-Iw
Message-ID: <CAD6_1xqOTRBMA2U8DsE_rHDobWqxt_u83WQMF+SL-HZNe0MUnw@mail.gmail.com>
Subject: Re: Regarding Of My Late Father's Fund $10,200,000..
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_HUNDRED,MILLION_USD,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:844 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5126]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [jennehkandeh9[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [jennehkandeh9[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        *  2.0 MILLION_USD BODY: Talks about millions of dollars
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.9 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

......
Hello
I got your contact through the internet - due to serious searching
fora reliable personality. My name is Jenneh Kandeh birth date
May/23rd/1994 in Free Town Capital of Sierra Leone.

l am a nephew to Foday Sankoh, the rebel leader of Sierra Leone,
opposed to the government of President Ahmad Tejan Kebbah the
ex-leader. I have been on exile in the Benin - Porto- Novo. But l am
current residing in PORTO-NOVO BENIN due to war of my country, my
mother was killed on 04/01/2002 for Sierra Leone civilian war. my father
decided to change another residence country with me because I am the only
child of my family, bad news that my father pass away=C2=A0 on 25/11/2019;
During the war, My father made a lot of money through the
sales of Diamonds.

To the tune of $10,200,000 (Ten Million Two Hundred United States
Dollars). This money is currently and secretly kept in a ECOWAS
security company here in Porto-Novo Benin, but because of the
political turmoil which still exists in this africa, I can not invest
the money myself, hence am soliciting your help, to help me take these fund=
s
into your custody for investment and also advise me on how to invest it; an=
d
=C2=A0I want to add here that if agreed 30% of the total worth of the fund =
will be
yours minus your total expenses incurred during the clearing of the
fund in Cotonou Benin that 30% is a $3,060,000 (Three Million Sixty
Thousand United State Dollars) is yours out of the fund after we
confirmed the fund there. l'm waitting to hear from you soon.
