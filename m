Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9856A548A
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 09:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjB1Iip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 03:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjB1Iio (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 03:38:44 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE6DD9
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 00:38:43 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id h16so36548216edz.10
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 00:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aPR3wybdLDGQ751O+Ph+iKip/50WSjBMbLi5cBgGIUQ=;
        b=H2+d8SmgeGUFOzrLPfv6kZESU38nBN022JPF7p3P9qeMy84O/EW/kkABf8Z16RT8BY
         IQ0Ps0py3dH7FA5Nv1V+XxfYK56qF1XzbTNoiEI2VKZXq0J0U/t3QNt0V1Qj5OTCqK9Y
         Yisis3pYs5A6WmkCx/8QRAX3JZDpQzDWVEIsK541bTmUtJZs2eVQnWEfcZdw4NTPLVoR
         pAFfD7i/yMe0RzZjEHzIpFbexKCpLQypd6ikZ1G0vR57VduasjEqpdZFzp0tK2p8qpJf
         6laWHYo79QrW4eSTMzGeTlFwlHWarv80Y1HFr0reO8wW6hWLzX/1EwU9K2jTixYpTx3Y
         C3Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aPR3wybdLDGQ751O+Ph+iKip/50WSjBMbLi5cBgGIUQ=;
        b=AS3bgUddxm1ZmISnBDPX9AHs0l3LjcO2t/YnITZAQYVJMApo1O2pRCF7Z7m9DIO5PV
         Fhyq/V/hxGHZ9XLmSWrzZZUjuGmFTNxJT3RjnET194uP/KxeTxSjEKtYHFCeqpb0Cypp
         K4rn7JCmcs00yQWKIMC94YWUUB9ID6LotvMCIAujesbjUDQM6v3qjrXB1mxFiceVIOZC
         DFYVSr0c5nfTRhRSAAF4YjPjJYJ7h5dvWrCxGsnp1wNTAfWrTbtJ49Lpo3F6Mg1cclAF
         ZmCLxwYGkXdj7MHJmjHI7ac9+kF0BTlPKfMTXfyLch2NQWF1wlCA7NG/D646MI0mHLNX
         9cFg==
X-Gm-Message-State: AO0yUKVO+QcZ1+6imXnDg4kmeB5nyvO7yCgS13hrDdazdgiei4K4+5W2
        qjZ4TBj0zwi2KgOjXK9d4Fm9pREHcUT6Zy9F1sI=
X-Google-Smtp-Source: AK7set+P55MzD6BRQ4BtT42Ls2LQ94IO3ROe65BMh3dBYQGIOasPVafN9WfQoHYUUWMNX4dOjeZASgRyn/ZCItGg5HY=
X-Received: by 2002:a17:907:98eb:b0:8af:3930:c38e with SMTP id
 ke11-20020a17090798eb00b008af3930c38emr796070ejc.10.1677573521943; Tue, 28
 Feb 2023 00:38:41 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:640c:1fcb:b0:1a8:2275:f59a with HTTP; Tue, 28 Feb 2023
 00:38:41 -0800 (PST)
Reply-To: leighhimworth1@gmail.com
From:   Leigh Himsworth <okorogregory2017@gmail.com>
Date:   Tue, 28 Feb 2023 16:38:41 +0800
Message-ID: <CAAMQ0aAqvbwGvwAFhvVYL3AL6RHnO2h6Q_HjdvwnYt-_4E3Yew@mail.gmail.com>
Subject: =?UTF-8?B?T2zDoQ==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:534 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [okorogregory2017[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [leighhimworth1[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [okorogregory2017[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ol=C3=A1,

Sou Leigh Himsworth, de Massachusetts, estou procurando investir um
ativo avaliado em US $ 350 milh=C3=B5es, no Astronaut Asteroid e em
qualquer outro projeto comercial lucrativo em seu pa=C3=ADs que possa gerar
nosso retorno esperado sobre o investimento.

Por favor, deixe-me saber se voc=C3=AA est=C3=A1 interessado para que possa=
mos
falar sobre isso com mais detalhes.

Cumprimentos.
Leigh Himsworth
