Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99551242E3A
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 19:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgHLRob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 13:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgHLRoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Aug 2020 13:44:30 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31ABD20781;
        Wed, 12 Aug 2020 17:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597254270;
        bh=28DUEag+8EHTAqymbd12JJo2CcoS2UDf2nbADDMAw8o=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=TD1K2eLRsFkw1pUi6MRPtrhRIEWAKzNvstiEGr0NudRvwcqMv9bBJzasuUao9Wca4
         9zB4zfWRjRp7MbfjoWUO/B9qDO8avGbG9BlQMsnY6PRmyeP47R2LjL7wYlLfokUpgI
         VjIoZG+ogWktoIfhIGCKTytYWHNyZCHvkpSced3Y=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <159549996283.3847286.2480782726716664105@swboyd.mtv.corp.google.com>
References: <CA+G9fYvGXOcsF=70FVwOxqVYOeGTUuzhUzh5od1cKV1hshsW_g@mail.gmail.com> <CAK8P3a1ReCDR8REM7AWMisiEJ_D45pC8dXaoYFFVG3aZj91e7Q@mail.gmail.com> <159549159798.3847286.18202724980881020289@swboyd.mtv.corp.google.com> <CA+G9fYte5U-D7fqps2qJga_LSuGrb6t9Y1rOvPCPzz46BwchyA@mail.gmail.com> <159549996283.3847286.2480782726716664105@swboyd.mtv.corp.google.com>
Subject: Re: stable-rc 4.14: arm64: Internal error: Oops: clk_reparent __clk_set_parent_before on db410c
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        linux- stable <stable@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        freedreno <freedreno@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Clark <robdclark@chromium.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Eric Anholt <eric@anholt.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        samuel@sholland.org
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 12 Aug 2020 10:44:28 -0700
Message-ID: <159725426896.33733.4908725817224764584@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Stephen Boyd (2020-07-23 03:26:02)
> Quoting Naresh Kamboju (2020-07-23 03:10:37)
> > On Thu, 23 Jul 2020 at 13:36, Stephen Boyd <sboyd@kernel.org> wrote:
> > >
> > > It sounds like maybe you need this patch?
> > >
> > > bdcf1dc25324 ("clk: Evict unregistered clks from parent caches")
> >=20
> > Cherry-pick did not work on stable-rc 4.14
> > this patch might need backporting.
> > I am not sure.
> >=20
>=20
> Ok. That commit fixes a regression in the 3.x series of the kernel so it
> should go back to any LTS kernels. It looks like at least on 4.14 it's a
> trivial conflict. Here's a backport to 4.14

Did this help?
