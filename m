Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E27D5A5359
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 19:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiH2RjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 13:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiH2RjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 13:39:03 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9100A9C21A
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 10:39:00 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id lx1so17117985ejb.12
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 10:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=sDbMTVBr3pEhmU7m8JV2wUj7Izif0Eg4XQ/hjSwxjJg=;
        b=PFESTIIlRSCqmkO8gmLBxuK/tsGkEZDkMcEhjT3wzQg9LyrJXLMlJBmVb0H6XGSCR/
         Rd0O78B4ydxJkqMMCNbkD09ZfeWsGgwbvlV/MpIucD9sGlWSEhq99YHwrPzNoCsMwmP/
         s7CwosBKgOUdzfRK20MstX2w1zJoQlR2sT1Qk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=sDbMTVBr3pEhmU7m8JV2wUj7Izif0Eg4XQ/hjSwxjJg=;
        b=m/MjgM96hhrAlcbe6phpHdQH7DX7/hGXPlVPplLhbLB1Cvt8k1uiuDTn9Szc8+Dh4x
         7kTbpwXLO8v5Pqbyd8yI5HwNWGGbjAjX1XFWsnuDRXII4AxBGizwCl0FVE7oWU+HE+BQ
         z0wUXvo8CmZ1AZ4vijKZUeaN5Xg5wC3HKZdqCwmLytlRWP3k9bxS2r0+Vd+T5iiqvXNM
         pHFOOWNPBI/DwE2iwFDwEzSqjkX5JZQ7IwGgLBuguGgC47HMsLegwNEmfHYtIyqF9mTY
         A7vMGY7veLhfukMS6j/9Qk/kvbnT29n+3Euz92Bgtjnldt2MRTGCHwr0KU+LVunPmjHb
         FLNg==
X-Gm-Message-State: ACgBeo0lQgevzbJSM20+rPgaowbxS8YvVbL2zyclnRhw1/E3ZGV5gUF6
        ZJTjJuCgVNoV68N+jRRx0GCw7wrTPZZbDDxf
X-Google-Smtp-Source: AA6agR5U3LkcryJEA63xYe4VloYCaoptYb3lq/VhY3mtimTRbIhMK7QVDPV+11VzErp0BAN2JV+BzA==
X-Received: by 2002:a17:907:7f8b:b0:73d:6f4f:30f7 with SMTP id qk11-20020a1709077f8b00b0073d6f4f30f7mr14208432ejc.323.1661794738567;
        Mon, 29 Aug 2022 10:38:58 -0700 (PDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id 23-20020a170906319700b0073dcc56d3ebsm4688770ejy.220.2022.08.29.10.38.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 10:38:58 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id m16so11083423wru.9
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 10:38:57 -0700 (PDT)
X-Received: by 2002:a5d:6248:0:b0:222:cd3b:94c8 with SMTP id
 m8-20020a5d6248000000b00222cd3b94c8mr7057154wrv.97.1661794737558; Mon, 29 Aug
 2022 10:38:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez3SEqOPcPCYGHVZv4iqEApujD5VtM3Re-tCKLDEFdEdbg@mail.gmail.com>
In-Reply-To: <CAG48ez3SEqOPcPCYGHVZv4iqEApujD5VtM3Re-tCKLDEFdEdbg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 10:38:41 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgrZB20D1mz55ohTWpv9zbik4TLJi+N_UMK_N+y3ofYWQ@mail.gmail.com>
Message-ID: <CAHk-=wgrZB20D1mz55ohTWpv9zbik4TLJi+N_UMK_N+y3ofYWQ@mail.gmail.com>
Subject: Re: stable-backporting the VM_PFNMAP TLB flushing fix (b67fbebd4cf9)
To:     Jann Horn <jannh@google.com>
Cc:     stable <stable@vger.kernel.org>,
        Security Officers <security@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 10:36 AM Jann Horn <jannh@google.com> wrote:
>
> A minimal but also completely different fix would be:

Looks sane to me.

                   Linus
