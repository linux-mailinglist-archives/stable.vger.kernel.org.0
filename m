Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA386637B1
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 04:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbjAJDJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 22:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237663AbjAJDJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 22:09:17 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7F9273D
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 19:09:17 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id c85so4469197pfc.8
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 19:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/krrOzf32PMDRBi/P9qe9m671OONK8NSr+9AstJjJkE=;
        b=oBYZYsv77L0PwOdrPH2EJaan0L6Oe2Gg0o/cxZAUqcFrqTSUV5f1SbXJhtIuxJrdlO
         HHOpzs5wlcTcBIXuXZgrhKNjX9d/qMSHRnA+IlpXu2eaCTMZbyHVZVEJVLCeqfmEqJgI
         BKOvn8k6bYbtDaHaV39XzPhDXzb7sVBo6K4LIM9kvH6o39USDdRwsluakYdTNdkdS6Cx
         GS4G1lIjjsnbZ+qY5Fy+2bGnhbhH7HQWOOhfKC72wkMyss+K1q3jKMPP92547H+aer8d
         MzE954/h0gfm5GGgu99q/tfwYvZ5Z6XnbECc7I4n+VTnEeEcCBs33IWyD7iVaO16tRzE
         yCMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/krrOzf32PMDRBi/P9qe9m671OONK8NSr+9AstJjJkE=;
        b=5OmCrzgbDWMs3Fmv9diZ9dq2f/hbGjCrBWhhknGvxXPX1KiCs2kvZVwWARgS2GJ8tn
         NkNWGNL00VKBdChP++iBYIivhR/TaZO7vga0U9WjL35azP/aZIzH9KyK44/EMCMwdc7M
         tl/lbDYmDNGKCx6yXWUDPWkQw0//uY2yHHmLycvKnBqc2JANeI5WNJTndRGtu61GXRVL
         sVq1AGSzm9dsY6AuaxU+oowME110N4GfJwwFzE7am0r4rVbUgsiw1vUfsawAWMeaWXRP
         MicAWBLO10vY4Gc+pd/nBK4ZWu/Umb4ed2GVWghaV0DC3FBM6/MlGZOzQq/iVSgyRPZ5
         yEiQ==
X-Gm-Message-State: AFqh2kp7jTKAa25HVTswkM08GK0a/JRyhV1jz6ekKpECBcvwwVvl94+y
        hOLDF0SUHMv9eWQFyVSaqNSHhN4GvEIyPVTVmNE=
X-Google-Smtp-Source: AMrXdXtWVtjzqAivk7hg7I+++ZwZeiq29WpkzuY9J5CXxBEftkwgV1NQ0xCIaK4w7M5W0Ro2khbtla3aHYUkiFVCQPY=
X-Received: by 2002:a05:6a02:30e:b0:477:e302:ee5d with SMTP id
 bn14-20020a056a02030e00b00477e302ee5dmr2689733pgb.335.1673320156501; Mon, 09
 Jan 2023 19:09:16 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a20:6da6:b0:af:752d:83c8 with HTTP; Mon, 9 Jan 2023
 19:09:15 -0800 (PST)
Reply-To: avamedicinemed3@gmail.com
From:   Dr Ava Smith <tracy4love1035@gmail.com>
Date:   Tue, 10 Jan 2023 04:09:15 +0100
Message-ID: <CA+3ub-4t0gvhB=2VEX2OZfq=XxDTFMr8MG67nBm6MiizryvZQQ@mail.gmail.com>
Subject: From Dr Ava Smith in United States
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello Dear
My name is Dr Ava Smith,a medical doctor from United States.
I have Dual citizenship which is English and French.
I will share pictures and more details about me as soon as i get
a response from you
Thanks
Ava
