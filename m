Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C38648813
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 18:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiLIR65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 12:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiLIR6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 12:58:54 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2F092FFF
        for <stable@vger.kernel.org>; Fri,  9 Dec 2022 09:58:54 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id jn7so5642560plb.13
        for <stable@vger.kernel.org>; Fri, 09 Dec 2022 09:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bdzXn7lCvEWhARvPzl6hBvMGMireIFLP5QR0DBmSaRE=;
        b=UpHVNCEdNJ+3ONkTNpWYQaY5hKfPLufe+dMRLvrBX37unMo5HqnJk0iBYBjpvl+3kY
         BxwuA2L4hUE0hrTMqB+cWC2X7GIttAc+GtUFP3VDXUdFEEUAb4fTisaWi8rjhBV2uC+Q
         wNYfrciE197TTYXpxs/gskyavKaMpqseY9DUJZ51Q7T+d0WWvuE6pROKC0B9D9wtjWM+
         +z9yU0wiH1xadq6ompA7hTWL9QcSNAySJLMfJry7Z8CcUQBsNcz6nLYBNmMT0lQNbeyv
         0chi/SfLzs+x7lPedqXqioIvZZNMPTSFWHh4WbQ01sX3quZD2aU9gGd1Z00DD2JbXwft
         3GCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bdzXn7lCvEWhARvPzl6hBvMGMireIFLP5QR0DBmSaRE=;
        b=GB9Aajow8BpMgSaM2ibjmTFWuMZNTu3TT26cMpNM27MS2crnw+EGnl9T6jJFjKWjlg
         FryBGqvriKbBhGh4yCOR008q0Aqv1BG8HqGLZRYqN9zap2JYVHC3p4ZVK3UWvKhn3u/+
         to05RTHd+s71kIn6/N1xgvmIgF7CfcA5oazczcl+vjiIAD+T5CpcrMTMSArhKZbvXlKS
         alIRP1JaxaiV/Av/imKC2rPNYu6CRJH3L3kQz/dWlDqG2ZmD6XgM5ZF38+0+G36f5GVK
         DAwNqozk9DVRtjPH1f9z1vFIX7p4Fy/2evaxKVTiBmQrvJht6IhpPquSPxAuzFDhb4Tu
         i29w==
X-Gm-Message-State: ANoB5pm0j27s6W84q1m2ZtintiNjEDdinj4RMgNOlidZ0Wks5zkDn73y
        /bvoU5vzvgxOgjF2ySw2y1p1gkfPdSUd7OF9DOA/9g==
X-Google-Smtp-Source: AA0mqf7VrlDJAbjrA7ksjxx82VGOHt7ZZci0VumGcAvaTwd3qR9nuazScMUIzDvo3/o3XIM3tVmhX10jYMEoAacSnkA=
X-Received: by 2002:a17:90a:1d5:b0:219:55d5:f30e with SMTP id
 21-20020a17090a01d500b0021955d5f30emr44871427pjd.107.1670608733782; Fri, 09
 Dec 2022 09:58:53 -0800 (PST)
MIME-Version: 1.0
References: <cover.1670358255.git.tom.saeger@oracle.com> <9e387b71ce45d8b7fe9f2b9c52694e3df33f0c7a.1670358255.git.tom.saeger@oracle.com>
 <Y5JKYA53GnPrsr+f@kroah.com> <20221208233106.jvss2x4unqvijhgg@oracle.com>
In-Reply-To: <20221208233106.jvss2x4unqvijhgg@oracle.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 9 Dec 2022 09:58:42 -0800
Message-ID: <CAKwvOdkRrNZk_kWp-WvHduPzfqqDj=FyGbeJpNr-26QbCcyqoA@mail.gmail.com>
Subject: Re: [PATCH 5.15 5.10 5.4 1/1] arm64: fix Build ID if CONFIG_MODVERSIONS
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Clifton <nickc@redhat.com>,
        Jose Marchesi <jose.marchesi@oracle.com>,
        stable@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 8, 2022 at 3:31 PM Tom Saeger <tom.saeger@oracle.com> wrote:
>
> Can folks confirm/deny ld behavior is expected (arm64)?
> And whether the above patch would be an acceptable fix for these kernel
> versions?

If you remove `-z noexecstack`, aren't you just going to trigger
warnings from BFD again?

At the least consider adding a fixes tag for 0d362be5b142, and note
that stable doesn't have
7b4537199a4a, in the commit message.
-- 
Thanks,
~Nick Desaulniers
