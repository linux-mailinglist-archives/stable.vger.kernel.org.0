Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9499051EAC1
	for <lists+stable@lfdr.de>; Sun,  8 May 2022 03:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbiEHBH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 May 2022 21:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiEHBH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 May 2022 21:07:58 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD1A26E4
        for <stable@vger.kernel.org>; Sat,  7 May 2022 18:04:10 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id i186so10685096vsc.9
        for <stable@vger.kernel.org>; Sat, 07 May 2022 18:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=e7Q4y7iPGLCVPWqTkoNkP7leQjTRit1YqVpiGh/1AQo=;
        b=h2M6CuRuevROfB8zrdIA6RNhUaYWZHF/tFqZQTfKnNTZQ5Z+bRt9qTeyXPzaPAVR5C
         UbJTWNFh+rrRPENYoAzbOCCvoo1u4Xg8v9h+fa+VkxuMb/87Y8a7cJFNbvKQZ+O6pTBb
         T0+F95VWDn4Qe1Vr3YGWUb0bMUHZAAdnvMgaiq+eztcbIYILMizWjBaAYPsAIfOHnDyo
         QaQor5bTZYgAEp+Da1Aaq9a5+XmtWuhumXXo9lKWM/fiisz6tYpUQdipj2ww2R294U4o
         GIREXR3eohTYlp3Xdp7/fzaa8/b+iNLC7xPMSPk74zIN7bA8A8cIdo7liEkaeFMJhHU3
         6ikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=e7Q4y7iPGLCVPWqTkoNkP7leQjTRit1YqVpiGh/1AQo=;
        b=t0W2GAttgjlONaRDHjFcusQ36CPwaxUlGEX6KLZ+/PeXGD3ihqCIcFDjP2HdVgKxUM
         NVE1tpw93lfQNDbrkt0+0Wn1m/PamVGr9e41YRfGCpZJsse2sClcaus+Jzx/bsSdqQKs
         6N30REykWpKNqBgXlvFs0PIs/wfl4yfuHD31K/Y5x0O2lYkOaE3HTlVabNh/f4eTGLuZ
         VRgFqkbMsU67v7uJuuATGHxV9/TRWgqTZw2EL35GGmN04nVxF50QCM1aEXxFWina1oDm
         s+STguDtHUbwovraiOS8xq+v4PwHEJRMiuyds2e/8j1DJ4skOiZ9Kz0s/DIUl9FmBefx
         ObNA==
X-Gm-Message-State: AOAM533z55eyUypQLWRx8jf6NJ07LPtR/obXWsXNOeDybx/5bzFG6PwG
        699L438EdtoMvos1ti8tI3UUfW/+JwWiqmbH3Mo=
X-Google-Smtp-Source: ABdhPJxPTKLwoRzU2xyajFaUXMOXq5Y0RGvAMelfQdXcQnh3u1HX4dJHRz+KEyV4/KdMOC7OOQV6looBhrxrM6wmWhw=
X-Received: by 2002:a05:6102:538:b0:32c:bb2d:ddce with SMTP id
 m24-20020a056102053800b0032cbb2dddcemr5233601vsa.6.1651971848805; Sat, 07 May
 2022 18:04:08 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:3c4f:0:0:0:0:0 with HTTP; Sat, 7 May 2022 18:04:08 -0700 (PDT)
Reply-To: wijh555@gmail.com
From:   "Mr. Ahmed Osane" <osane706@gmail.com>
Date:   Sat, 7 May 2022 18:04:08 -0700
Message-ID: <CAC7Oyrro3cpQN+Wgq0gGmPrdP78rpYiQDj2NpwaxJKM00g8Dtw@mail.gmail.com>
Subject: Good Day,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        HK_NAME_FM_MR_MRS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e29 listed in]
        [list.dnswl.org]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [wijh555[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [osane706[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [osane706[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 HK_NAME_FM_MR_MRS No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Greetings,
I'm Mr. Ahmed Osane, how are you doing hope you are in good health,
the Board director try to reach you on phone several times Meanwhile,
your number was not
connecting. before he ask me to send you an email to hear from you if
you are fine. hope to hear you are in good Health.

Thanks,
Mr. Ahmed Osane.
