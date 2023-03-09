Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9DF6B2B45
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 17:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjCIQ4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 11:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjCIQzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 11:55:55 -0500
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194F94495
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 08:47:40 -0800 (PST)
Received: by mail-vs1-xe35.google.com with SMTP id o2so2184678vss.8
        for <stable@vger.kernel.org>; Thu, 09 Mar 2023 08:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678380459;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zFJAUi5KyLD6fIk55XlMyY79J+2FRjDBltr7pPM+boQ=;
        b=dX7wJ/0I2zP7CX7ZhL73Fk4yuKcp7ljOv5MijUyYcGJE0859iZMa26xZJvPpGHkki8
         kFtdrGOadEOialePVZUUORw6y3cvjOhPFo9mxDHqM/8Mc2Z7Q0uCbtjjGoXaWAcW5yVT
         syKNM7B368UwlPxubsxYhA/bQzcgDcvSApACoqHuaY5pQhuavqzojHnOQiy4NHptlAGm
         Lb6WiqviytStGfGmT6DQKdlfY3KHruFwJ39XTPqEO32Cbrf95aJv00km5F3rT8XAfsY1
         6o6u2CMzgvDheswAQkfaHCEs2gW2qqYdSxdVvb9jN5xcv1Fn4kBJZrXIYIsZOMeHpWT7
         7ymQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678380459;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zFJAUi5KyLD6fIk55XlMyY79J+2FRjDBltr7pPM+boQ=;
        b=T5xDpX/t8g/AMeRBjOGBxHxvoVq113TT4UnD/2aswfab+S3fISNHQvAjhUBBehAdOr
         fl9wUNCss/hFDMMcwFjDqNy9MiuBCK9CsN5rnDkxVUKjpPCzYcNFfIsyXRZFotR7tXdJ
         sWzOaRDXKJtyE0GDYYe1qLX8iAnI9bydC1ap+JRoJXov2XfS/4baanPuDQCD0m5fNBUb
         0zYIGsAHZXw7IjEoWl7e7H+QH11xEMlkxXCw7Wi9qNDQltFbICRnEW8nSXdYBFhDR3Gq
         DiSZ3RdrAFFTuR3gNI9f5HDoz8YaKht4qCUuaVJu5m8G7qYsNrm2M+jlPnDFpLLk7wMa
         h+vw==
X-Gm-Message-State: AO0yUKVeDm7z3FAPCnz2kelPPyDNBFbZHTKWvgTrMtVFXfbNq6BKGnTh
        cUYjQChtvIh8att66pCAYcAGgqGBYYiNY/pzrLw=
X-Google-Smtp-Source: AK7set9N4AKVeMpS0IDdrBtoC8eeX/7ZveqqKw775lOI/8rmp5VlrDig29e9q0R5ke42pm0oafjaoBIxYoF199q/NXM=
X-Received: by 2002:a05:6102:80b:b0:421:7f84:f3d9 with SMTP id
 g11-20020a056102080b00b004217f84f3d9mr14715882vsb.3.1678380459210; Thu, 09
 Mar 2023 08:47:39 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:d6c4:0:b0:3a2:7a18:ed55 with HTTP; Thu, 9 Mar 2023
 08:47:38 -0800 (PST)
Reply-To: a54111045@outlook.com
From:   Audu BELLO <jaa30a@gmail.com>
Date:   Thu, 9 Mar 2023 17:47:38 +0100
Message-ID: <CAOxk4dP5Lau_dac=2GZDrr9W7oxjAf47jLq=wk3LA-sjzLdnkQ@mail.gmail.com>
Subject: Hola
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.7946]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e35 listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [jaa30a[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [a54111045[at]outlook.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
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
=C2=BFPodr=C3=ADa ayudarme a recibir dinero en causas ben=C3=A9ficas? p=C3=
=B3ngase en
contacto conmigo para obtener m=C3=A1s informaci=C3=B3n.
Audu
