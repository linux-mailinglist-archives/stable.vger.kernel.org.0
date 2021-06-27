Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6EA43B55E0
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 01:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhF0XoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 19:44:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231508AbhF0XoJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 19:44:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6D6E619BE;
        Sun, 27 Jun 2021 23:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624837304;
        bh=CxLjwCmcPMGEYxE8OWb3c/4rLoM29VRWE308RvGZTE4=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=MCTmgOHnEoUBPQ2NpmV8JqTzTxiY1YQ6a9otJv4J7zmTf/7Pls1dxveY5kpv8QWeM
         TOs/GviVtHyFgdR/8bwjq8IIU2qURNvHMZxhQQxMOeTmhnTOL1msua8THTYGGITfcW
         +jknjh3cmIGb/q/dLBp57gABuFXeNgi536miGwhfqLXiILlWlGL0bq06FOU1o7oN84
         iBLJInzSY8k2LIDtVBevLxVS9oZVTIwoSVP2Tirj3/3gJ/hOHih/aQpIaN1+8v1w67
         LyqgQlN0xziDoKA5S4uYKaGDUbsBnZWfKA69p+2dQyocLQQOFNIQQxcuVw0hNBVQXa
         Difr7HeWDbFDw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210611025201.118799-3-dinguyen@kernel.org>
References: <20210611025201.118799-1-dinguyen@kernel.org> <20210611025201.118799-3-dinguyen@kernel.org>
Subject: Re: [PATCHv3 3/4] clk: agilex/stratix10: add support for the 2nd bypass
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     dinguyen@kernel.org, mturquette@baylibre.com,
        stable@vger.kernel.org
To:     Dinh Nguyen <dinguyen@kernel.org>, linux-clk@vger.kernel.org
Date:   Sun, 27 Jun 2021 16:41:43 -0700
Message-ID: <162483730359.3259633.4972546127665365840@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Dinh Nguyen (2021-06-10 19:52:00)
> The EMAC clocks on Stratix10/Agilex/N5X have an additional bypass that
> was not being accounted for. The bypass selects between
> emaca_clk/emacb_clk and boot_clk.
>=20
> Because the bypass register offset is different between Stratix10 and
> Agilex/N5X, it's best to create a new function to calculate the bypass.
>=20
> Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agil=
ex platform")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> ---

Applied to clk-next
