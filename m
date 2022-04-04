Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609B24F124A
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 11:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354694AbiDDJre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 05:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354620AbiDDJrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 05:47:33 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C5631356
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 02:45:38 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id y38so16502001ybi.8
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 02:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D3FbfWatxEsujuPIGrbMZAMIayKIkEr0jKXELDvSGgw=;
        b=NvutLfiFIsQf5SAAy0DeoD6pYhL1vFIuwuVnSCliu9uFHWGaJb72CP23Dqej//uSlZ
         4fPz8yUUKLwm/0MQ8P9JJbcUgA907rOoIv91wIvkZP+yFat4CqlekYNy7o2wbEaXgOXQ
         BKhOpeJ3QuYN0vLuiX0F1veB5Gm+Wpv3HM3enTEQ2LCSvXEXAg7yqZuGzketZWmpSIuA
         hIZxta8L04aOGeLtnWzYEMGGHFzr6MVNwHnmtGA9uilLKXU2+i4AZh7rohTBAq8VxHRY
         +blECw0JeyE+06kywsnEyin1XMV4AeBRKICwRXs8VHxAaL5fYPeo4FVHLeCFQ5pzFpR6
         NQIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D3FbfWatxEsujuPIGrbMZAMIayKIkEr0jKXELDvSGgw=;
        b=Xbkz9feCsTkEeDwWNvNrNjUsJFH4XNt/DKw97LpFSo+8KslkGI0b5jWOnf4UX5jakJ
         TSNCD/u2uLEGv/j1EI3rQKqpGoVgOqBJaGYmGhxglegr0ei771RzDQe0+dviVKmubEmR
         wNyrUK/kZTlvwLbbmXfQxp+inW2XIrcY5Q0RFlCxGp9pWZtfaEd+WWHiG3nz9zZNAJvT
         hlcFcSKRrfkDtwuO7KH6SR0t/3MM+k43icTfXzlBjkAVgBb/k+l0BkuNnDtRpc0nWtO6
         wfGXP/yzZz8ERERt9L6DwyXeY1PZ5zsElHmZ8E6hDgWUv1vjOh6ksk8Zdwbw8YhEdItv
         zabg==
X-Gm-Message-State: AOAM531MmegBO1Q1leucKgqflW/U/kkG8G/uXE/QTdeKsEFPJfYtqdDX
        LXAHnvNSYon9PnWATEnGiKQ2UOSfqEsK2SMG9pRFzQ==
X-Google-Smtp-Source: ABdhPJyVtaO3rE3SNMkdpOEM5acd/uyflN5rUZ6Vpd89YVc5ZX0tFE58A3JG0aVWNf4S+1cz30gVCIr7m1m9ZI2k1GY=
X-Received: by 2002:a25:6e85:0:b0:63d:b37a:3d3b with SMTP id
 j127-20020a256e85000000b0063db37a3d3bmr5659770ybc.128.1649065537486; Mon, 04
 Apr 2022 02:45:37 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYs-zEGZghAXK9cqi-6avLVa_3mS62Y2jGsM9+x6+jJzcg@mail.gmail.com>
In-Reply-To: <CA+G9fYs-zEGZghAXK9cqi-6avLVa_3mS62Y2jGsM9+x6+jJzcg@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 4 Apr 2022 15:15:26 +0530
Message-ID: <CA+G9fYsEGR9KX3+Nw64ga1ysXnsWhvku7DpUkgHdoN=nOJ1Gnw@mail.gmail.com>
Subject: Re: stable-rc: queues/5.15, 5.16 and 5.17 : arm64 tinyconfig builds failed
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Vijay Balakrishna <vijayb@linux.microsoft.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 4 Apr 2022 at 15:09, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> Following arm64 tinyconfig builds failed on queue/5.15..5.17.
>    arm64-gcc-11-tinyconfig - FAILED
>    arm64-gcc-10-tinyconfig- FAILED
>    arm64-clang-12-tinyconfig- FAILED
>    arm64-clang-13-tinyconfig- FAILED

The most recent builds are getting PASSED now.
Thanks for fixing this build problem.

- Naresh
