Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 794B9E6133
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 08:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfJ0HCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 03:02:54 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43865 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfJ0HCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 03:02:54 -0400
Received: by mail-lj1-f196.google.com with SMTP id s4so7100201ljj.10
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 00:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WbzSRQt5qIw+XRs0Y4yak3c9V2c/gN+ESY6j8JKZjh8=;
        b=su2sP+/c5Tkf4ApHQr6rhd5g1ReODP4zmklKVoQnYuKOVNRgJN76XMkZ7UW5sAC3Ri
         /LFuzwkBjke8VniDVad1Mbaq4VblBjxHtOhtI7hUczPFx0s4MgwO5O2ykvkrH3kff2rv
         Tg05Agc726dlaTUZ1EhKQwqyJ2FZQWBOs53M5F49r77PDUPB0ziParcjagyUM5CFZe0O
         9Nz46PVhxUM3XLlstgo1RPGMGAysfqMSgXYLnYnIFjWZISNPShbvNsw13cWYb+hfDwmm
         2GWx67Y5JiJvUQScXQuKuWDkwRThI86s4DoJ+432UxmPkG4j2K+HnjcMbgJWt4AOpI6m
         kDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WbzSRQt5qIw+XRs0Y4yak3c9V2c/gN+ESY6j8JKZjh8=;
        b=BFtA64CwFtoX6LIoWK8iaQ7tHxGx/Vxgo+GWXiN6BTKaqqO0ZTNd2TCgs2F6dg97TS
         4Nj/rMYg398efhkEtjnljwQmwUVaGirldsoMnuQlJOgaenXStrGpxoV7EDfSt9w8WpVW
         iJMt1FjwS6wBHo/wIdmoFOY3XqTzI5VxT5z5DvRQyA7YL/HwiY/ttIb2BcjzMEhUn6hl
         BIfn8IXIoGTZqATC0E0mLVt4LImMkI8qQd1poA9IZt1DWRfHgVJaRRg13K7zMChxg0pk
         /xy9BPlVLfS8Q+mx74x+gWM2vGBpWnOkkTlThe492KUmVTotbY9NpsLX0x2q9DNokcr0
         NsCw==
X-Gm-Message-State: APjAAAWXaC1dc8z9YOzoIZ5b4RNEjaiVdT2xD8p7G6I48uQp4XpVjXFi
        O0yFLjbi5zSQYB124akPVQIdfK+Rm9BxZG0ce07w4g==
X-Google-Smtp-Source: APXvYqzZwRTstUkVBEcMzOfBJbn7HwzU45H2hY8nLiDvI3Un36vmjMpoot3RraSkeKCu9MoX0QPYx1BTuI0w4VvZZm4=
X-Received: by 2002:a2e:9702:: with SMTP id r2mr7178392lji.194.1572159772172;
 Sun, 27 Oct 2019 00:02:52 -0700 (PDT)
MIME-Version: 1.0
References: <cki.61C56EFD16.AR8ITWHB7P@redhat.com>
In-Reply-To: <cki.61C56EFD16.AR8ITWHB7P@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 27 Oct 2019 12:32:39 +0530
Message-ID: <CA+G9fYurG8gSO+xFc5LJvLMrqTyHG85oxH9=pSQ1LmPCa6PkqQ@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOKdjCBGQUlMOiBTdGFibGUgcXVldWU6IHF1ZXVlLTUuMw==?=
To:     Jan Stancek <jstancek@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Memory Management <mm-qe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jan,

On Sun, 27 Oct 2019 at 04:04, CKI Project <cki-project@redhat.com> wrote:
>
>
> Hello,
>
> We ran automated tests on a patchset that was proposed for merging into t=
his
> kernel tree. The patches were applied to:
>
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stabl=
e/linux.git
>             Commit: 365dab61f74e - Linux 5.3.7
>
> The results of these automated tests are provided below.
>
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
>
> All kernel binaries, config files, and logs are available for download he=
re:
>
>   https://artifacts.cki-project.org/pipelines/249576
>
> One or more kernel tests failed:
>
>     x86_64:
>      =E2=9D=8C LTP lite

I see these three failures from the logs,

LTP syscalls:
fallocate05                                        FAIL       1

LTP mm:
oom03                                              FAIL       2
oom05                                              FAIL       2

- Naresh
