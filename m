Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118BB465F9
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 19:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbfFNRnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 13:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbfFNRnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 13:43:43 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBED2217D6;
        Fri, 14 Jun 2019 17:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560534223;
        bh=BtDCf12TGdb1xn6LpgZ0JJLH/0SL+ngyj/+nSlrc6Es=;
        h=In-Reply-To:References:To:From:Subject:Cc:Date:From;
        b=vsFm6CaywHnFbxL0coOrDPK9iTyz03GVrC6NChXvyDD9cOdQMwR3X/S/mHfqsNA/E
         K0NPrm27dMLVr8svfuhNq77NUgNETjucsJpVVW+xEO6k1RfnoI/ianDlZs5gVGtoo0
         Bq2DRwEPGVfdXZGiVbq1pk5QV1CBPXydhxHUOuuo=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1559743299-11576-1-git-send-email-jonathanh@nvidia.com>
References: <1559743299-11576-1-git-send-email-jonathanh@nvidia.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
From:   Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH V2] clk: tegra210: Fix default rates for HDA clocks
Cc:     linux-clk@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sameer Pujar <spujar@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>, stable@vger.kernel.org
User-Agent: alot/0.8.1
Date:   Fri, 14 Jun 2019 10:43:42 -0700
Message-Id: <20190614174342.DBED2217D6@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Jon Hunter (2019-06-05 07:01:39)
> Currently the default clock rates for the HDA and HDA2CODEC_2X clocks
> are both 19.2MHz. However, the default rates for these clocks should
> actually be 51MHz and 48MHz, respectively. The current clock settings
> results in a distorted output during audio playback. Correct the default
> clock rates for these clocks by specifying them in the clock init table
> for Tegra210.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> Acked-by: Thierry Reding <treding@nvidia.com>
> ---

Applied to clk-fixes

