Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223AD31FB4B
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 15:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBSOu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 09:50:28 -0500
Received: from smtp-out.xnet.cz ([178.217.244.18]:31330 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229925AbhBSOt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 09:49:57 -0500
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 7F09A18404;
        Fri, 19 Feb 2021 15:49:08 +0100 (CET)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 3ba7593b;
        Fri, 19 Feb 2021 15:48:50 +0100 (CET)
Date:   Fri, 19 Feb 2021 15:49:06 +0100
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Jonathan Cameron <jic23@kernel.org>
Cc:     Tomasz Duszynski <tomasz.duszynski@octakon.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: chemical: scd30: fix Oops due to missing parent
 device
Message-ID: <20210219144906.GA28573@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <20210208223947.32344-1-ynezz@true.cz>
 <20210212191219.7b16abbb@archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212191219.7b16abbb@archlinux>
X-PGP-Key: https://gist.githubusercontent.com/ynezz/477f6d7a1623a591b0806699f9fc8a27/raw/a0878b8ed17e56f36ebf9e06a6b888a2cd66281b/pgp-key.pub
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jonathan Cameron <jic23@kernel.org> [2021-02-12 19:12:19]:

Hi Jonathan,

> >  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.96+ #473
> 
> So, we moved this into the core a while back (to avoid exactly this sort of issue).
> That change predates this introduction of this driver as it went in
> in v5.8

sorry for the noise, I've missed that commit 8525df47b3d1 ("iio: core:
fix/re-introduce back parent assignment"), thank you for the hint.

> So I think you've hit an issue with a backport here to an earlier kernel?

Indeed, I've backported it to 5.4.96 as you can see in the dmesg output above.
I'll try to reproduce it again on 5.10 in the upcoming days.

Cheers,

Petr
