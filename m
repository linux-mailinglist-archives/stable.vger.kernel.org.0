Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E7C1F03FA
	for <lists+stable@lfdr.de>; Sat,  6 Jun 2020 02:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbgFFAeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 20:34:31 -0400
Received: from condef-06.nifty.com ([202.248.20.71]:17798 "EHLO
        condef-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbgFFAea (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 20:34:30 -0400
Received: from conssluserg-06.nifty.com ([10.126.8.85])by condef-06.nifty.com with ESMTP id 0560S0wc000506
        for <stable@vger.kernel.org>; Sat, 6 Jun 2020 09:28:00 +0900
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id 0560RQ6i024237;
        Sat, 6 Jun 2020 09:27:27 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 0560RQ6i024237
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1591403247;
        bh=DLK1Q03Ke1bnSHppdytRjHujmJK/0OEZ1kYZjRB6CI4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ddTVoKvlVyv/voN4alwJUC8DWobrKIBuyQibXfbzsJWUghEKvmskocAfmpVYiZuY9
         K8YImTzQILFHsZrZF6CJrIN2MB93GS0daT3YM2bDZycuks53EMgpxAEXdRrnyM66oA
         L5K64b9sYm213btEt0kxaLHXGEU2TDDxDtO5wDnPclc2mrNOGAu6d9VhOfLVVlmNLP
         mPS6cNCc3s8dqEknl89mc58eFhHl8QbXIFUlDU/9a2ct+Rof+Nji2TJYE3waF3f/3P
         qvGAg4EiAHwR46qN/2QXPubXkKSCiAQr9FbuKHOHv74I1yN6Q0btdaPwPVf5TO93Ko
         s9WlTwJC+Si5g==
X-Nifty-SrcIP: [209.85.222.45]
Received: by mail-ua1-f45.google.com with SMTP id b10so2741616uaf.0;
        Fri, 05 Jun 2020 17:27:27 -0700 (PDT)
X-Gm-Message-State: AOAM5316OLfB1sQaBgkxJhJduIgBFd5SaYEIi4QofpByeXZ7RuMRIxpT
        k8EGoWipnF4Xli7N6t2LBLbBzmSi9hvZKvcZUIA=
X-Google-Smtp-Source: ABdhPJy5/1Ln8ibWBHn8oD6mXyWec4MPBsOcArPhylfj3/vXvIOHEM4MIK2r/O0q7A+coE3QpGPOOz8YaK2H+19bo1w=
X-Received: by 2002:a9f:2204:: with SMTP id 4mr9869288uad.40.1591403245887;
 Fri, 05 Jun 2020 17:27:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200531084707.1238909-1-masahiroy@kernel.org> <20200605141059.E85BA2074B@mail.kernel.org>
In-Reply-To: <20200605141059.E85BA2074B@mail.kernel.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Sat, 6 Jun 2020 09:26:49 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQwJk1RN=DDYUhMCZ=7oDLDb2mfZ7U8O7EEAT8ghFh3WQ@mail.gmail.com>
Message-ID: <CAK7LNAQwJk1RN=DDYUhMCZ=7oDLDb2mfZ7U8O7EEAT8ghFh3WQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: force to build vmlinux if CONFIG_MODVERSION=y
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi.

On Fri, Jun 5, 2020 at 11:11 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: 2.5.71+
>
> The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182, v4.9.225, v4.4.225.
>
> v5.6.15: Build OK!
> v5.4.43: Build OK!
> v4.19.125: Build OK!
> v4.14.182: Build OK!
> v4.9.225: Failed to apply! Possible dependencies:
>     2c1f4f125159 ("kbuild: re-order the code to not parse unnecessary variables")
>     312a3d0918bb ("kbuild: trivial cleanups on the comments")
>     a9d9a400e075 ("kbuild: split exported generic header creation into uapi-asm-generic")
>
> v4.4.225: Failed to apply! Possible dependencies:
>     23121ca2b56b ("kbuild: create/adjust generated/autoksyms.h")
>     2441e78b1919 ("kbuild: better abstract vmlinux sequential prerequisites")
>     2c1f4f125159 ("kbuild: re-order the code to not parse unnecessary variables")
>     2e8d696b79e9 ("kbuild: drop FORCE from PHONY targets")
>     312a3d0918bb ("kbuild: trivial cleanups on the comments")
>     a9d9a400e075 ("kbuild: split exported generic header creation into uapi-asm-generic")
>     b9ab5ebb14ec ("objtool: Add CONFIG_STACK_VALIDATION option")
>     ba79d401f1ae ("kbuild: fix call to adjust_autoksyms.sh when output directory specified")
>     dd92478a15fa ("kbuild: build sample modules along with the rest of the kernel")
>     fbe6e37dab97 ("kbuild: add arch specific post-link Makefile")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?


I will send a pull request to Linus shortly.

After it hands, please cherry-pick it
for v4.14, v4.19, v5.4, v5.6


I will resolve the conflict and send a patch
for v4.4 and v4.9 later.

Thanks.





-- 
Best Regards
Masahiro Yamada
