Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C1E66A94D
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 05:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjANE7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 23:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjANE7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 23:59:00 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514D935AA
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 20:58:59 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id pj1so11805934qkn.3
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 20:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QzBF4eWm48K1rkBM1tff25rPM9mkOGlP3BXDd2no/0g=;
        b=ISnPFHmkdBczqxmmixo9IxPacdtDygFymswcEMhVdVAG+u9tPgDzfAFICztw4HkLIr
         ZZwqtrW+skkIno7ljRS1m1LH4KeR3LSS+2gd8sSmE7tEuuqNP+CXNk5NXE9NJrMq8+K9
         GxTqZBLn+ZVJVeb9Y8w9bbyLY7SsyiSHNVAW5vlMCzJEvcph6vfW1l70NCHuxI5uSTqh
         Bdf3RpZ2Hmya+vBO7iMxdJ7O7v9NOjMdjZYq7HSBbNXjbAPIUvUcv+zxiOIZvNdd1z3O
         up6e4BfumsdomJiDhZQLUWxui0EdWk+9z34J8HoTZZkvRhO8HHLIdApy34bV/I8ZEHD+
         JrLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QzBF4eWm48K1rkBM1tff25rPM9mkOGlP3BXDd2no/0g=;
        b=wx6/Icy+IWtQZ3JuPGk+WvPv9VNhj55ETkHVtQ37hqcLZLW+lvBigLg8dznwrK6yG6
         J+xvSItj14gIvuUCeerZMUCRZ0jpAeEuIDL2QD8c2sljjtjcuIqS8C/MtUZv7w9sjUZK
         OS+IRS4LwQonE2aa7Oi5Cu+yE/egKV/W+jG6tevpk2njSwi+1ld/V7Ym2nkTv+f/AA83
         jcHAUriwFgfesgY9Kb0TGvoMQoDr1uy5rAb4HJpiD56CH5DfcimjRE2My15OhmYpl5jg
         wx7Zu6FL2mEWeGr0Bh7UawCk53xQyONnkc4dgq0ZoEv9DyJlJdV7fyfRsv6qMrv88sj6
         uNbw==
X-Gm-Message-State: AFqh2kpxSiuXSU13BlONvMaBXvROdCUrGcou436dgHJHn+q8ITb/US31
        JltypvkZdmRKuhWLCw8nGPKKcH9/tBdNF4JocdfKOCG+wtI=
X-Google-Smtp-Source: AMrXdXvuQQzygfW99KEhhj7+yRWXI1G2dqqdpnuzY4ku9nY7rYRTeODRxLC8RgAFOlsZcidOVieFqPJXVeLfnnuLHiY=
X-Received: by 2002:a37:9447:0:b0:6fe:ae3e:418d with SMTP id
 w68-20020a379447000000b006feae3e418dmr5106283qkd.170.1673672338367; Fri, 13
 Jan 2023 20:58:58 -0800 (PST)
MIME-Version: 1.0
From:   Matthew Fahner <mdfahner@gmail.com>
Date:   Fri, 13 Jan 2023 23:58:47 -0500
Message-ID: <CADsncqR2mTUArTv2HhRnsfmQx5iNgUZo=JVgkUcZT7MtjxEoYw@mail.gmail.com>
Subject: Second Monitor Issue on Kernel 6.1.5
To:     stable@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I'm running Ubuntu 20.10 and experienced a regression when trying
kernel 6.1.5 that was not present in previous kernels such as 6.0.19
or 6.0.9

I have two monitors attached using DisplayPort MST (daisy chaining the
displays).

Normally, this works without issue and both monitors are detected and
display properly.

With kernel 6.1.5, the second monitor (the monitor that's not directly
connected to the computer) was detected but would not display.  I
didn't spend much time troubleshooting the issue and instead reverted
to 6.0.19 where it again worked without issue.  The first monitor
worked without issue.

Let me know what steps I can take to help identify the root cause.

  -Matt
