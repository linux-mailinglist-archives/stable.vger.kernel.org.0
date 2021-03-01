Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAB4327CA3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbhCAKxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:53:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234863AbhCAKxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 05:53:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94E4F64E46
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 10:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614595954;
        bh=UjrpazgrFkbV0M3n5GVHLizajslB1rISHCu992F78Gc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=botbnrNAdHPpz1K7Oytu2rVggswR5iyRy6KkKzcR5NsADcGkOqVPB0P+sdmGHCckQ
         APl9/lWx4e6PwzKC1FzBXMi98/EyaR/DJLqVefnXmviBdLdS5fEQnzNPSXUxWFMYju
         nLXQe4yVde9Ma7aH28VnGWVokgzjqaPQeuzhhc3/a6p9qnuCBCmR3Dwxot+v3Kf6l3
         WFcr4hEKfPBhfIxtxx1FwgZh0FGu4ckh8nTjZUHsoFaTWKwjwJb0mDBT9sGS7pdQ+U
         PmAL9PDMfgj0jddCld+b8IWI2fz70kkIFllmOrig2PNO1Uoj3P8ilPYiC9eAwKd9hv
         BZ2b7shV2VEtQ==
Received: by mail-oi1-f182.google.com with SMTP id f3so17547525oiw.13
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 02:52:34 -0800 (PST)
X-Gm-Message-State: AOAM532eI/1gqnD5Vbse70gzh6IxvOsNUfn7/+jdT8FYNM4sylnwUbP9
        3UqTESE0UnoqJ+paQZUfey6NsDlwpJAhu8V98Xs=
X-Google-Smtp-Source: ABdhPJygmSEaB9gNh67ZoafCG5hzkZ1ZmDsSk4BscVmYdXjPTj6Fd5ywjx14+iu8qJA3O2ALZEDBELTGoz2e82cnHcg=
X-Received: by 2002:aca:4fd3:: with SMTP id d202mr10585155oib.11.1614595953857;
 Mon, 01 Mar 2021 02:52:33 -0800 (PST)
MIME-Version: 1.0
References: <1614594762206238@kroah.com>
In-Reply-To: <1614594762206238@kroah.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 1 Mar 2021 11:52:17 +0100
X-Gmail-Original-Message-ID: <CAK8P3a27HB89omfNGBWbbztB6Fg1qfOzjqtKJ7sDurMRi4AAPg@mail.gmail.com>
Message-ID: <CAK8P3a27HB89omfNGBWbbztB6Fg1qfOzjqtKJ7sDurMRi4AAPg@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] drivers: soc: atmel: add null entry at the
 end of" failed to apply to 5.4-stable tree
To:     gregkh <gregkh@linuxfoundation.org>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 1, 2021 at 11:32 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

> Fixes: caab13b49604 ("drivers: soc: atmel: Avoid calling at91_soc_init on non AT91 SoCs")
> Cc: stable@vger.kernel.org #4.12+

Hi Greg,

Did you add a backport of the caab13b49604 patch to 5.4 and earlier?

Without that patch, this one will not apply, but if you did apply caab13b49604,
we need this one as well, and should do a backport.

        Arnd
