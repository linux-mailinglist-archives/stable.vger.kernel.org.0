Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D8E8D802
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 18:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbfHNQX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 12:23:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbfHNQXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 12:23:25 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF27020665;
        Wed, 14 Aug 2019 16:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565799804;
        bh=drGNaWF+vbPLIhKZdjKaaAPYvonVJd9CaHrHmd7Db8U=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=BfLdpAsRgcAHE6/V4EuMthY7eNveF0c0kyuZ7nri6Ps958ns7xt1B7NC3NHgv/d2W
         +Aanff4PLlE3dD67YkQYWgcDx+TmHu7G3EhhX/Mw7EADl0qa3uEGtoK0pvk2BqHV6U
         oqMzQV5FThqB2TLjsJN7LlAk8/IJjFVs0UEZ80+w=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190814153014.12962-1-dinguyen@kernel.org>
References: <20190814153014.12962-1-dinguyen@kernel.org>
Subject: Re: [PATCH] clk: socfpga: stratix10: fix rate caclulationg for cnt_clks
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     dinguyen@kernel.org, linux-kernel@vger.kernel.org,
        mturquette@baylibre.com, stable@vger.kernel.org
To:     Dinh Nguyen <dinguyen@kernel.org>, linux-clk@vger.kernel.org
User-Agent: alot/0.8.1
Date:   Wed, 14 Aug 2019 09:23:23 -0700
Message-Id: <20190814162324.BF27020665@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Dinh Nguyen (2019-08-14 08:30:14)
> Checking bypass_reg is incorrect for calculating the cnt_clk rates.
> Instead we should be checking that there is a proper hardware register
> that holds the clock divider.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> ---

Applied to clk-fixes

