Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D752C368E
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 03:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgKYCGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 21:06:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbgKYCGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 21:06:23 -0500
Received: from kernel.org (unknown [104.132.1.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66CAE2067D;
        Wed, 25 Nov 2020 02:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606269983;
        bh=iwIWhrMn6QmFc+tknI5JAn3HLJvGt8AXMGD/Vwy263s=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=RJHypOeL30X1wAE/0WLrkf+vjEo4OHYMMmK6+txIyHr0mdGBJkHCj7pmntl8Bu5Ge
         7yq/1C5SKUK6YrhCgi1y+E33+HQ9oecyS2RjhcO91tku5y5pkYtggk0i3GawP1FpKs
         HoeVqfni/Z7L/w6vZ9MUgWxfIgzYM5nvGLEv+O9o=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201120161839.GD3870099@ulmo>
References: <20201029004820.9062-1-nicoleotsuka@gmail.com> <20201120161656.GC3870099@ulmo> <20201120161839.GD3870099@ulmo>
Subject: Re: [PATCH] clk: tegra: Do not return 0 on failure
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     Nicolin Chen <nicoleotsuka@gmail.com>, jonathanh@nvidia.com,
        pgaikwad@nvidia.com, pdeschrijver@nvidia.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-clk@vger.kernel.org
To:     Michael Turquette <mturquette@baylibre.com>,
        Thierry Reding <thierry.reding@gmail.com>
Date:   Tue, 24 Nov 2020 18:06:22 -0800
Message-ID: <160626998208.2717324.3699032150208058364@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Thierry Reding (2020-11-20 08:18:39)
> On Fri, Nov 20, 2020 at 05:16:56PM +0100, Thierry Reding wrote:
> > On Wed, Oct 28, 2020 at 05:48:20PM -0700, Nicolin Chen wrote:
> > > Return values from read_dt_param() will be either TRUE (1) or
> > > FALSE (0), while dfll_fetch_pwm_params() returns 0 on success
> > > or an ERR code on failure.
> > >=20
> > > So this patch fixes the bug of returning 0 on failure.
> > >=20
> > > Fixes: 36541f0499fe ("clk: tegra: dfll: support PWM regulator control=
")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
> > > ---
> > >  drivers/clk/tegra/clk-dfll.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > Mike, Stephen,
> >=20
> > if you don't mind, I'll pick this up in the Tegra tree since there are a
> > few other Tegra clock patches on the list that may require coordination
> > inside the Tegra tree.
>=20
> Also, I do plan on sending the collected set of patches to you for
> inclusion via PR at a later date, if that's okay with you.
>=20

Ok sure.
