Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADF537BC9B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbhELMgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:36:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232493AbhELMgD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 08:36:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C65D613F9
        for <stable@vger.kernel.org>; Wed, 12 May 2021 12:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620822895;
        bh=DePr4GdsWRh2rEdbVTVw4jZQK0fpFxVPpvyxFfZUQIs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OSul6G8WOYukRSdq/LFJ4d8bXvdafhMBzB+s2o3sN51KbJ6BpoCIt/4F5sG38B5Eu
         6VB7Fw+BSDlZcHbNjf5U00YokvRfQ98eDxz/6wLY/xW+65DlWduhbJE6SqjWDPy9Di
         WOQsZTKQoqAbxQqz4uH6a/Hxto2a8sVtyHhEDYxvIqf4fjDaqGXX0JVXxHFxlRnj2w
         BiB3ADM3ZJeSfNIhnwM3Uf7eB0/EOrdC8KthFnSAHcUaZBpbMeZ57An+C+LXEHFmfY
         WTg00nQdQS5ZC6eCYtex+4M6EvrhElM31Hd8Dylk8OPja7GHML51bh0qMJTBpktodu
         otYQW9a7rLNwg==
Received: by mail-oi1-f172.google.com with SMTP id x15so8335624oic.13
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:34:55 -0700 (PDT)
X-Gm-Message-State: AOAM531wUBkwxbNFUxi9WA6Ut/2S8Wn5NAfQAn/0sQrEj68yLE0PoEHk
        bYNZgbbfW5u4z91B4X7z7fXAPyXVAmC25J3j5Hk=
X-Google-Smtp-Source: ABdhPJxmQcJxvOoR3wmYNPfqVpB23Z4pE1LuY7iutNls9bfWbT5vbX/CbQPhp6vPPMbjAn3jFbCoVUmRAUgeJoJRkx0=
X-Received: by 2002:a54:4395:: with SMTP id u21mr25719000oiv.174.1620822894775;
 Wed, 12 May 2021 05:34:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210512122853.3243417-1-qperret@google.com>
In-Reply-To: <20210512122853.3243417-1-qperret@google.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 12 May 2021 14:34:43 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE5rNDJ7Lq17R-SbQCeQ9Sx-boV+MnrVnSjBA3uVyRGOA@mail.gmail.com>
Message-ID: <CAMj1kXE5rNDJ7Lq17R-SbQCeQ9Sx-boV+MnrVnSjBA3uVyRGOA@mail.gmail.com>
Subject: Re: Revert memblock backports with missing dependencies
To:     Quentin Perret <qperret@google.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Alexandre TORGUE <alexandre.torgue@foss.st.com>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 May 2021 at 14:28, Quentin Perret <qperret@google.com> wrote:
>
> Hi all,
>
> A breakage in 5.4.102 has been reported [1] due to the backport of the
> two following upstream commits:
>
>   8a5a75e5e9e5 ("of/fdt: Make sure no-map does not remove already reserved regions")
>   86588296acbf ("fdt: Properly handle "no-map" field in the memory region")
>
> As Alexandre noted in the original thread, the backport missed
> dependencies. But since these patches were not really fixes in the first
> place, it seems preferable to simply revert them from 5.4 and earlier.
>
> [1] https://lore.kernel.org/linux-arm-kernel/CAL_Jsq+LUPZFhXd+j-xM67rZB=pvEvZM+1sfckip0Lqq02PkZQ@mail.gmail.com/
>
> Quentin Perret (2):
>   Revert "of/fdt: Make sure no-map does not remove already reserved
>     regions"
>   Revert "fdt: Properly handle "no-map" field in the memory region"
>
>  drivers/of/fdt.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
