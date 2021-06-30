Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809263B887D
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 20:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbhF3ShN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 14:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232851AbhF3ShN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 14:37:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29741613C3;
        Wed, 30 Jun 2021 18:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625078084;
        bh=slt3L0xwhcyU5y4oLHCcLk6UVpJzC9C2af4jqOAR6Xk=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=rDWkppbUSHim1zeiO6a3QUunPJOR4kWb2Yt/3g2PtqrrtLZLgwFVxE45WO+qA+Aph
         vJC+ke1sG5cGXlGiHVWbCzJW4TXJOEVGrQuhNtqvcWLFfB/vixNDjlaIRzChU1orAI
         LXB9FjwQhnpdQXUbfncgkYeEhsQNkn19EsbrBqF6ifEs+8XlsIPHBRlMCy/mD1Spv5
         QyXGwMSJXmNG6ciWvrkuLZYYi9FsrbUFDfAvvVluDJZUTmnNf8d2ogh1+KY2J2kmsa
         D2A8CzUID5qoNLfMyywWHfPYRSSvKYYzL4GPBL269D5fZkReTCL9jqccAZTz4hyJ2j
         2qK13n9AyyglQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210622064502.14841-1-damien.lemoal@wdc.com>
References: <20210622064502.14841-1-damien.lemoal@wdc.com>
Subject: Re: [PATCH] clk: k210: Fix k210_clk_set_parent()
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     stable@vger.kernel.org
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-clk <linux-clk@vger.kernel.org>
Date:   Wed, 30 Jun 2021 11:34:42 -0700
Message-ID: <162507808293.3331010.16073778280977688458@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Damien Le Moal (2021-06-21 23:45:02)
> In k210_clk_set_parent(), add missing writel() call to update the mux
> register of a clock to change its parent. This also fixes a compilation
> warning with clang when compiling with W=3D1.
>=20
> Fixes: c6ca7616f7d5 ("clk: Add RISC-V Canaan Kendryte K210 clock driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---

Applied to clk-next
