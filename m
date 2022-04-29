Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7387A515103
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 18:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344050AbiD2Qn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 12:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiD2Qn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 12:43:27 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366642BD4
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 09:40:09 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id e23so9678444eda.11
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 09:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=CZjU7e2a0fCf/XEsO8nJVQl+HPFT9L7SSPvqpdqz67U=;
        b=gX67ZbkzV7k+s4ToZgIjMGsfNSrYcggYKPirr5a4hS0n9YB6DwR7xwFMRq9YBef6hv
         qXC4u8juBmkzGEyOksZasGPEyNWGwdFM0QHUWXolYfecIWo0ZWh+i4+tVsMeQtg3luMd
         68E5dcmK9RuECLChk35xdU+E8+ywJsNq7KUbVAwimas51ewdS2gt+5hWwya7aGiTK5i5
         GnCBm5q+f1kV0+oj6ecnYlPLIXIFP09qfg57pRYZp4vupl+MYmS5N7TiY4WKW5IbOKO3
         nDDkzVQUtCNzhCHhDLhadmIqy5UDq82Bi6m2/2WBrEyxnALzvkp7R0v5lps08hK0Mdc7
         sI7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=CZjU7e2a0fCf/XEsO8nJVQl+HPFT9L7SSPvqpdqz67U=;
        b=WMrAJcfGEHBJbuEYvpKa66adYrgrdvAQTcoLR2r7X30iuKWztAIDCDjpglarPledV6
         0Q+H+JTIp0ce0d8Hsc9ll2R6cmoxyH7SXyHittjx5fd7Q8xAX+CCkaL377WC5pv1Y7Vx
         cb0y8Ghz0r3IbEOVvqlcA6EotTJKKJ7/RYM/n9Z6kHHNGVH/ywNaDyA2BT2vA5fkhktz
         qdkM4t19KWUvzzdpUULFfFlQwRdoNoMDLdI324vAdDXAsHzFBTJE4FM9DMde/Kr7UANj
         i5xHaE4bSIIzbrs83Bh5UElDoVfQnjC1UN1Rk94QScgqCMItnHiPga68nGLYpopnM7mv
         bIvA==
X-Gm-Message-State: AOAM532orHVBSCfpj2Bp3QCiQraYilfdniLmOZQ8qpxp+yB/uZzRDey3
        wLfQO39ELvJVzMEioJFHCCIqO63X5mT3OD6AEQo=
X-Google-Smtp-Source: ABdhPJxIPxX5GTisJR2fmQwhm1sZahlfkCktEmAjh6hL80ZnGCdZ7HRPA1dmop3N+21ff5ZDKme/KDKzKOCNmSlOva4=
X-Received: by 2002:a05:6402:5286:b0:425:f0fb:5d23 with SMTP id
 en6-20020a056402528600b00425f0fb5d23mr68031edb.243.1651250407780; Fri, 29 Apr
 2022 09:40:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab4:a741:0:0:0:0:0 with HTTP; Fri, 29 Apr 2022 09:40:07
 -0700 (PDT)
Reply-To: abrahamamesse@outlook.com
From:   Abraham Amesse <gmark3575@gmail.com>
Date:   Fri, 29 Apr 2022 16:40:07 +0000
Message-ID: <CAPG1wpOebCNcow=6=h+dHTk4RdX686Y8rVMxSJ9jqqxxN93U3Q@mail.gmail.com>
Subject: //////////Greeting,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:52a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4272]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [gmark3575[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [gmark3575[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I have very important information to give you, but first I must tell
with your confidence before reviewing it because it can cause my work,
so I need someone I can trust to I can check the secret
