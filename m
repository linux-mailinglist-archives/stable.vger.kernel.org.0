Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471296559F4
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 12:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiLXLdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Dec 2022 06:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLXLdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Dec 2022 06:33:00 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037DE645D
        for <stable@vger.kernel.org>; Sat, 24 Dec 2022 03:32:58 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id c129so6728795oia.0
        for <stable@vger.kernel.org>; Sat, 24 Dec 2022 03:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y7XukgsAlfYiKI+yuvdwyFpb/FGCy9p+ybfvm0wRi4Y=;
        b=gNqkFFJ7+213+zzUXwDOSlZ77G8npiJRY/hleBihsc6f38z7jvLC4b+a5hedZEUoVR
         gGlfahA0doIZFgUBpK1/wbYLKUrGd+lrnIWCIZZkel/ly8HElCuitCtyvJz3JLr/e2Ia
         qFsvspJoYQgudxnWXDFM8Tb3DyoSddgakmbUqU7T6afgPpppzMm4EsD/U/nOyu+3VzWG
         z/DXpmSfheg6+kQJi1atk79g6wgc2W8zEIn/64hhawUbSgSjJZxR9wtmdEOE3iadyrNX
         EIiaAUIW6Um99pCBBBxlod9jmOb+i9wC5SmmEx8jWphLN1HFUPjwClAhEDP+b2rijIZ7
         RPxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y7XukgsAlfYiKI+yuvdwyFpb/FGCy9p+ybfvm0wRi4Y=;
        b=PJ9FKySzd+qgAC/PSPyAnG1LKZtdGe4AYSKPEcI+E1/taeREDOEIr4YXdQDY+4wERt
         alWX5UYKZ+B1vyhwHghehpEKAntrkKIDM+u4mCcCO1kdKh+FRVNvL2QGn0kFV9nfcTnS
         AbsE037Aefm7nOKOP0rH/wat8NznKUW1GATL2MCw1aSU4enkoPRrHtxEpYS01rQ8E/Ot
         j8WVLgz2EyGH0oeWsnxx9ZeOJHP4TtDjDh0fCYAxdeNOM8PsDbiTH8Rp8Cib9gxpUaDA
         J7Fo5rq8zAlr+9JWR1OejfTGFijgI8Md8wHFtqYBanW63QHTF8oq3H024skSINSsJZuy
         6+uA==
X-Gm-Message-State: AFqh2kpq7jLyxuS3TnlKFINvH3+QbP1qXUtvHJXeAAjinxJkpSICOvtV
        5JkTmbRMZVL1wX8QzYDsDEdFJ3BT9EsuMGhsXcc=
X-Google-Smtp-Source: AMrXdXsOy6vxrlDXONSQr5nIsKezkJhOf+8TgDlzxt95fLu2AK3xjYsBhiLBMGBZ/evZAJlYH2a2ESHFmZik0Ungr7c=
X-Received: by 2002:a05:6808:4385:b0:35e:694c:49ea with SMTP id
 dz5-20020a056808438500b0035e694c49eamr484166oib.78.1671881577315; Sat, 24 Dec
 2022 03:32:57 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6358:3a01:b0:dc:5408:456e with HTTP; Sat, 24 Dec 2022
 03:32:56 -0800 (PST)
Reply-To: ab8111977@gmail.com
From:   MS NADAGE LASSOU <nadagalassou3@gmail.com>
Date:   Sat, 24 Dec 2022 12:32:56 +0100
Message-ID: <CAAPPVT12EAsyGQCTaga=Db19+mmXNZph1yTE=xnqXWMcA5WFog@mail.gmail.com>
Subject: REPLY FOR DETAILS.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:22c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4998]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [ab8111977[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [nadagalassou3[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [nadagalassou3[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings.

I am Ms Nadage Lassou,I have important business discussIon with you
for our benefit.
Thanks for your time and =C2=A0Attention.
Regards.
Ms Nadage Lassou
