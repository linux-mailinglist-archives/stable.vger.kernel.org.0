Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E0F2E977
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 01:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfE2Xfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 19:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726454AbfE2Xfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 19:35:48 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7F6F2435D;
        Wed, 29 May 2019 23:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559172947;
        bh=aHRGWmrf5rXnGBiMo5ak6Pc0Hv90kyBqNX7HV998xic=;
        h=In-Reply-To:References:Cc:To:From:Subject:Date:From;
        b=jaP6SePRwzRnxN+ij5bLWVtNYpu/iF9tyV5WGHmrc8Q5SzcUP2k2bI/+uvhOKqeaT
         hJUM0s/lPFbJHfEiJ7AhNx7ktcnq+WFF8qVegWcHmNX9L3ZpK49i93+RAHpYAXwoLo
         ivyZqOm4nh2trqHx4QCtEtnTzdy3P1IDNhF3B9+M=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190523132235.GZ9261@dragon>
References: <20190522014832.29485-1-peng.fan@nxp.com> <20190523132235.GZ9261@dragon>
Cc:     "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
To:     Peng Fan <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>
From:   Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH] clk: imx: imx8mm: correct audio_pll2_clk to audio_pll2_out
User-Agent: alot/0.8.1
Date:   Wed, 29 May 2019 16:35:46 -0700
Message-Id: <20190529233547.B7F6F2435D@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Shawn Guo (2019-05-23 06:22:36)
> On Wed, May 22, 2019 at 01:34:46AM +0000, Peng Fan wrote:
> > There is no audio_pll2_clk registered, it should be audio_pll2_out.
> >=20
> > Cc: <stable@vger.kernel.org>
> > Fixes: ba5625c3e27 ("clk: imx: Add clock driver support for imx8mm")
> > Signed-off-by: Peng Fan <peng.fan@nxp.com>
>=20
> Stephen,
>=20
> I leave this to you, since it's a fix.
>=20

Is it a critical fix? Or is it an annoyance that can wait in -next until
the next merge window?

