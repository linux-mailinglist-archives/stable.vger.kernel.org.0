Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F113E2080
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 03:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241419AbhHFBMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 21:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236561AbhHFBMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Aug 2021 21:12:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCED2610E7;
        Fri,  6 Aug 2021 01:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628212354;
        bh=/GjrDe7SF7oJ29VB3o02vZjPiBH5nqnsx+U7DvmpZoM=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=UfgMo7mIunC1nc+0+E01yjkdTKAjydgxA/wYNxew1TQxr1GOqNx5awTXnG+RchpmC
         u3g+9z47d6lmWK1TEToxGETha3lgw0aLjLwXe8KzZWhyxtshOKXLVkbAGzoRvGrxQ0
         z/wiK3O1ne8UNwYT/gLY77txAd5+mg7vXNBCoxcv2DSk6UgFcdb9sxqQg9UzKB6mVH
         LXGmeJu7P7uGhAtLoat3c+41fd1wwdi2ATBGwr+5DdZ8pcdHuETkjvKCVrwQD+L7kD
         yRTe+IBtmCMxfge73nB7Vl0TT+f3RI4StA+ANOU89Gj3cofeSls+mCoVzb4j5sTwzG
         iFUzns5f+vYGw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210702085438.1988087-1-aisheng.dong@nxp.com>
References: <20210702085438.1988087-1-aisheng.dong@nxp.com>
Subject: Re: [PATCH 1/1] clk: imx6q: fix uart earlycon unwork
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, dongas86@gmail.com,
        shawnguo@kernel.org, kernel@pengutronix.de, abel.vesa@nxp.com,
        aford173@gmail.com, Dong Aisheng <aisheng.dong@nxp.com>,
        stable@vger.kernel.org
To:     Dong Aisheng <aisheng.dong@nxp.com>, linux-clk@vger.kernel.org
Date:   Thu, 05 Aug 2021 18:12:31 -0700
Message-ID: <162821235155.19113.8776442287518434596@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Dong Aisheng (2021-07-02 01:54:38)
> The earlycon depends on the bootloader setup UART clocks being retained.
> There're actually two uart clocks (ipg, per) on MX6QDL,
> but the 'Fixes' commit change to register only one which means
> another clock may be disabled during booting phase
> and result in the earlycon unwork.
>=20
> Cc: stable@vger.kernel.org # v5.10+
> Fixes: 379c9a24cc23 ("clk: imx: Fix reparenting of UARTs not associated w=
ith stdout")
> Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
> ---

Applied to clk-fixes
