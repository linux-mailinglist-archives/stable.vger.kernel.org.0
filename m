Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D12452FD5F
	for <lists+stable@lfdr.de>; Sat, 21 May 2022 16:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235946AbiEUOjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 May 2022 10:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiEUOjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 May 2022 10:39:36 -0400
Received: from mail-yw1-x1141.google.com (mail-yw1-x1141.google.com [IPv6:2607:f8b0:4864:20::1141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF3166690
        for <stable@vger.kernel.org>; Sat, 21 May 2022 07:39:32 -0700 (PDT)
Received: by mail-yw1-x1141.google.com with SMTP id 00721157ae682-2fed823dd32so111182017b3.12
        for <stable@vger.kernel.org>; Sat, 21 May 2022 07:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=C+z24Pl7od6xO10XmMEfecsYemTIfW+XARlPRi62dVY=;
        b=N7amHYR6/tSm0l3XtXesn0EmwzFegyhYYBBu8OGqoWhRHJF4t5HlVajqcvUSYQHMYr
         xTBfcTPTVWLW3Rrr4+I+hLYfdxq218EfdMI0EmAPQ0ouU4lImmhDSRl3/epWNPc1Xk3I
         pD+j2gnEWJbWlTtfLEGEyLe3Y6BzB3B8ww2n+CZnGxiU7Gr1aOTDutyRRdxvTjd5Zr5W
         p+T01wGhi8u1M7vv2Hmpd4S3gEsWAekzXsklK+Juz+EH0H8cjEibE0v9az5+4CO0tYmD
         mkKR2bE79hv6hu5tedVw2GmorLCvOXPDBT3w7I5sNJuLpCvyRYNYQk+yZF9VakdIP6K9
         A6Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=C+z24Pl7od6xO10XmMEfecsYemTIfW+XARlPRi62dVY=;
        b=dYGQ9Unj+BAT4aqDPdy03GB2fxFo9RPEbUQV6wWoiNa/sJ8yLTSIYzW2kCuVGOO1AO
         cQgfvZ4qewv1EgncQ5t+YsWcH+hxHaxplclizn3ERx0N/66GDtIVlGPIfFJQehssDpgy
         UxAFXOEEExzsYpivyNUPH2yq/8brfu8woGxknTR90RYYjHkihfCcIwEZPkEjWXqVDXc2
         WVw4HTPlXqlaI1YJIE+AGlWrq/cRbUnGMdBXdYwp9JrRgBQaFaZpjZBEJpuygwD0fByU
         XgIiFvk23YFhDDEuGdIG2tO12OxJcq7C1ybnh38FVgDbvfXiYEbQU30fmR46M2Jg+oMu
         6yyg==
X-Gm-Message-State: AOAM532TItTLw7lcqbxhvOyQmnDcYNzDVaLtb4IFvAyVwrIsHbX82nEa
        dDnAS/XMdU/+kUJzMEegUDMFEN6oe61sSeMENp0=
X-Google-Smtp-Source: ABdhPJxDIMi0YA36DoUqshGMbuFjG+KjYeHXnA+HzzooGu/JcVtWhidEcCWPoDLIli1tYgt1zy41hJVnoI0+PV/rvIM=
X-Received: by 2002:a81:c305:0:b0:2eb:9875:76fd with SMTP id
 r5-20020a81c305000000b002eb987576fdmr15094445ywk.317.1653143971666; Sat, 21
 May 2022 07:39:31 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:21cb:b0:178:fde:7513 with HTTP; Sat, 21 May 2022
 07:39:31 -0700 (PDT)
Reply-To: paulmichael7707@gmail.com
From:   paul michael <gabrielbenjamin277@gmail.com>
Date:   Sat, 21 May 2022 15:39:31 +0100
Message-ID: <CALo3S2sr3dwaMMZTbU38x_6Lc5dSReY-ZLQnCFyERWES5ruEjA@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1141 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4976]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [paulmichael7707[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [gabrielbenjamin277[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [gabrielbenjamin277[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Every time I retest your email, it tells me to check with my ISP or
Log onto incoming mail server (POP3): Your e-mail server rejected .
Kindly verify if your email is still valid for us to talk.
