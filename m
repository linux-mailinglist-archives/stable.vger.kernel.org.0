Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3720B45C9A2
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 17:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhKXQQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 11:16:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241909AbhKXQQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 11:16:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EB0E60D42;
        Wed, 24 Nov 2021 16:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637770421;
        bh=ZERujhwrtdhLO7z5SwbKaCOUX1P6tebGVqd0i9kER8g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A6dtkTgk0SA42UAg5ZdWYN60vwcFLS3oLzaVjd0cuQNkL0E4L/4QcJguIg8KwWtkI
         ud4094UraYSBe4Lr5TOISvWWBzhOH1KzEQG1hunJ52mrwTkDwpUvOIz0EbTgLUAjSY
         eoNW24yhzpvXLRrSOysfO7ozwmL/M5tkIk9GWSDo=
Date:   Wed, 24 Nov 2021 17:13:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        lkft-triage@lists.linaro.org
Subject: Re: cpuidle-tegra.c:349:38: error: 'TEGRA_SUSPEND_NOT_READY'
 undeclared
Message-ID: <YZ5ksupzeLkkmH0H@kroah.com>
References: <CA+G9fYskrxZvmrjhO32Q9r7mb1AtKdLBm4OvDNvt5v4PTgm4pA@mail.gmail.com>
 <CA+G9fYvroifx_0xx-DxRRdDqsR79HV4KTC+a8+3zTL57Cu2TnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvroifx_0xx-DxRRdDqsR79HV4KTC+a8+3zTL57Cu2TnQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 06:10:16PM +0530, Naresh Kamboju wrote:
> On Wed, 24 Nov 2021 at 17:35, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > Regression found on arm gcc-11 builds
> > Following build warnings / errors reported on stable-rc queue/5.10.
> 
>  Following build warnings / errors reported on stable-rc 5.10 also.

I think you mean 5.15, right?

Anyway, now dropped, thanks.

greg k-h
