Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0AC527033
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 11:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiENJF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 05:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiENJF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 05:05:28 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2064B1F0
        for <stable@vger.kernel.org>; Sat, 14 May 2022 02:05:24 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-ed9a75c453so13318535fac.11
        for <stable@vger.kernel.org>; Sat, 14 May 2022 02:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=SUWQMmwZSct1NUq5pHL/uGOr0m/f9iWjJQkP63QJuAY=;
        b=V8SGJYny+q6OoJj2NtNAHC58HVCaKHqJmb3zLSAqSC3+rk527kzDHFptO309SXRvSD
         vI6uHRnqCJSE2w+qLV3dpX7rZgEqQT2S3rWe0QjOGvNWv2apJH0K2iJqpWoyu6hQg+XH
         7/1MVXBJxRK36UrvYIcZYFB48YJxPonHzV29wHEr7diG/6T8QfeEmDtlSbiEBrsBtD0s
         PFq7OPDuA0G6JvqmmsfjoZ4ocu10hb2COKX/gkeF4rK8zGGP/jx7VaiAXlrRx/sRUVBV
         4mgBD2CmpWnRJLr77yQ07lWpk1KRNGtgNIKijb3YNM4Dl3LigyhIKRzeUt9iApc67Pia
         EiaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=SUWQMmwZSct1NUq5pHL/uGOr0m/f9iWjJQkP63QJuAY=;
        b=4wV7Gxb63ttK2s4o6uXu2GPrng4fiYrRTD59D59DGE49j9GNE4rmH7DKoA9sAKx/nw
         opF5+WRvONQB8warAfRmMtWh9lXC+2HW6hjMh1CONNZLoPSsEqNEQm2f7CU/5bZMvqCX
         WEfKSk9lwckxbKcMcvJ+/QZZD3tgK8nVgcumUqJgRTKbBB4IXxaG37606tcsDg0p8DK4
         vzwQjMGLpsesW1Jjx4a4hXiRtxZ+voXO+dnxxZbEqZE+ErwibImaFDgcMonMB6hkMPSh
         6KhFrdNPDbRVLBTd8/U5Wr0X2WDl/8OMwH7TSVHhaBb0b9irI+eSxYYwqj0Zrv4QpFBn
         kdTg==
X-Gm-Message-State: AOAM530XG4zR0nDmZybF0fBBH+3t4kC3tHEIfR3T409FJSLGKbDvSC95
        KskF+yKbHlog4S1iQJ5bXf9sYL6l25buAh0JBtI=
X-Google-Smtp-Source: ABdhPJwgcNb/MD3jIf7VfwtPBAZ9d/KA6relYSQqEso7yz2KeYE8QpIiTbXhlCxqX4iOelK9pGZ9yeP3D0uebsUSR8Q=
X-Received: by 2002:a05:6870:3c1b:b0:ee:1585:7a58 with SMTP id
 gk27-20020a0568703c1b00b000ee15857a58mr10350030oab.110.1652519123187; Sat, 14
 May 2022 02:05:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:7aba:0:0:0:0 with HTTP; Sat, 14 May 2022 02:05:22
 -0700 (PDT)
Reply-To: jub47823@gmail.com
From:   Julian Bikarm <micheladanlessome@gmail.com>
Date:   Sat, 14 May 2022 09:05:22 +0000
Message-ID: <CAJFV=6BmOVHsqTeS73eyaKZaOmyV-s=A4_TuHOL-DXVc0cs9gg@mail.gmail.com>
Subject: Please can i have your attention
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:33 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [micheladanlessome[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jub47823[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear ,


Please can I have your attention and possibly help me for humanity's
sake please. I am writing this message with a heavy heart filled with
sorrows and sadness.

Please if you can respond, i have an issue that i will be most
grateful if you could help me deal with it please.

Julian
