Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C42A50DDA3
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 12:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237106AbiDYKNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 06:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241601AbiDYKNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 06:13:22 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606ABBAE
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 03:10:19 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id i8so9008879ila.5
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 03:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=s9IGPqOTuFEFxKMxMPq1P/MfyJrhGXNasZNiCUUGkGw=;
        b=oATFQgcTpIhi2bU7Nc12kTsyAaCUjP8cTLyIy+H8gUTSGWuJhYQUBAd/Gyb8woyQBj
         NSRbGY+S/DQpwyng+lZRZPmHZo34ijJP4qw0K40SKye7sY6ZLVWV9CLaIWsUXUGRsVth
         dlCItRpXw+Zkaz/34T5h7Y6WSw3RGyHwHWPTsGf3pQCES4zB2h/L3UpTrGdVkpZPzO3j
         IyVI8t4+Cf8kDIV3/jQDNmn3OGPWqmCYXes+s1ZiPet4VFdxi09SYZVWLGVDjKk9YhtA
         Pg+KqFIQfKjseUSidhW+J6A2SwJmGhn1lAEaCHj30pIXV1OuqHgNJ4NT0h+3r2xZknW5
         mDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=s9IGPqOTuFEFxKMxMPq1P/MfyJrhGXNasZNiCUUGkGw=;
        b=efmhaXlSXB7aNLyOwXhtaedHwZeQj2+KUi5jOnZEeCjGqVoZ9acvTr2Y0jzdGMr5Px
         WJhmb9txgflWcqq/imoN0UpjelSCIV1Vp6CsjioE5qFZQm9lGNPplYJDnkqEItfETXbB
         2VJ150YPD7OwMPKFGrjjD/OuC5HpiILH5scTVDyTdScTJV+Sl3Cle5wuWeoKXuZp2f9w
         uSVlNV/xoAubLVdP3aVPEgXR7ulUDlZrmHOKpkzQZbaJNJ+l1SjYADfZarkx3m5Iemuv
         nt0o6FxqEd9WrmuodqoidU7EQN9C+P5NeDcdVeDbKskzjsxdBm7OdjeiYWVHao5181iw
         iYOg==
X-Gm-Message-State: AOAM5309cBdzYzJLLYOCUtI5ni8hsV7H4EW+q+nBcj5UZ2Sd4yzsflOh
        vlHSZ1dB42VTtgX/QozzDi30CKx8ycFbFrWjBAU=
X-Google-Smtp-Source: ABdhPJx1ul5vtDOEV1lMrRVnEH880vBTJOgxzYZ4QUn5Y5stCSX0K8FQ1H4+tECIwm1coHrTBM9B2ddy4ZaAA6JYPj0=
X-Received: by 2002:a92:d01:0:b0:2c5:daa4:77e0 with SMTP id
 1-20020a920d01000000b002c5daa477e0mr6743582iln.154.1650881418762; Mon, 25 Apr
 2022 03:10:18 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4f:cf93:0:0:0:0:0 with HTTP; Mon, 25 Apr 2022 03:10:18
 -0700 (PDT)
Reply-To: lawrencetansanco.y@gmail.com
From:   Lawrence Tansanco <lt01102204@gmail.com>
Date:   Mon, 25 Apr 2022 10:10:18 +0000
Message-ID: <CAFdNJhhqtq0OQpvqa6-SLOYCFEbA4hDGY1hrKk5oidY6wQCahQ@mail.gmail.com>
Subject: THANKS FOR YOUR RESPONSE AND GOD BLESS
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:143 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4260]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [lt01102204[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [lt01102204[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

.
I will like to disclose something very important to you,
get back for more details please.

Regards.
Mr Lawrence Tansanco Y.
