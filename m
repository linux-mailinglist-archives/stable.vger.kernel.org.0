Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6898615B1E5
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 21:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgBLUc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 15:32:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgBLUc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Feb 2020 15:32:58 -0500
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A647924671
        for <stable@vger.kernel.org>; Wed, 12 Feb 2020 20:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581539577;
        bh=V9VyxKzfYIKf9VtsnordIWaam8t73E49S8DNnAueIq0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vT1e2f7TUdqvh664uuU8BB+7xkT6nw9k5xvJ8hLssM4n2EmNS3w2G46Ual5aE2SvB
         dJbOe8X58FwRb2Cvdvc5m08vtxQAsjUhzDrnM5NnPmCNv5/tsIT/ETOWJ5QNdNEth3
         K1G72GJdYfy72D3u8euOZJPNmkvudVBiwDdo41/Q=
Received: by mail-qt1-f170.google.com with SMTP id w47so2666762qtk.4
        for <stable@vger.kernel.org>; Wed, 12 Feb 2020 12:32:57 -0800 (PST)
X-Gm-Message-State: APjAAAXxIa9Qg8Y+/2zTJkkRoxoDOwlZPtIuprDRH/kyVnOr7Cf03W/5
        VWt6E2StSMfU05tkXbQmqA2KWhT4+Uuki48SEg==
X-Google-Smtp-Source: APXvYqz0go2FPjNTnDnmXjjdtP1WbfxbUtV3PkQip537yESGdY4MxxAo1/ie4PEdRuXCxmYV4nfdfyuy9cz4Qvvh7Z0=
X-Received: by 2002:ac8:59:: with SMTP id i25mr21097269qtg.110.1581539576653;
 Wed, 12 Feb 2020 12:32:56 -0800 (PST)
MIME-Version: 1.0
References: <20200206141327.446127-1-boris.brezillon@collabora.com>
In-Reply-To: <20200206141327.446127-1-boris.brezillon@collabora.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 12 Feb 2020 14:32:45 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKLcZ=R0kYX+Bqw=NqoqsL6En21t_gPMCHEOBkK-xN7vg@mail.gmail.com>
Message-ID: <CAL_JsqKLcZ=R0kYX+Bqw=NqoqsL6En21t_gPMCHEOBkK-xN7vg@mail.gmail.com>
Subject: Re: [PATCH] drm/panfrost: perfcnt: Reserve/use the AS attached to the
 perfcnt MMU context
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Antonio Caggiano <antonio.caggiano@collabora.com>,
        Icecream95 <ixn@keemail.me>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 6, 2020 at 8:13 AM Boris Brezillon
<boris.brezillon@collabora.com> wrote:
>
> We need to use the AS attached to the opened FD when dumping counters.
>
> Reported-by: Antonio Caggiano <antonio.caggiano@collabora.com>
> Fixes: 7282f7645d06 ("drm/panfrost: Implement per FD address spaces")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> ---
>  drivers/gpu/drm/panfrost/panfrost_mmu.c     |  7 ++++++-
>  drivers/gpu/drm/panfrost/panfrost_perfcnt.c | 11 ++++-------
>  2 files changed, 10 insertions(+), 8 deletions(-)

Applied to drm-misc-fixes.

Rob
