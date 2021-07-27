Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769963D6B5B
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 02:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhG0AQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 20:16:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhG0AQS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 20:16:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AEE760F41;
        Tue, 27 Jul 2021 00:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627347406;
        bh=qlGKSJ4EL7mvtr7ElvScM+1IFJxmpuGzKcsyNCHIVcc=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=MvaQi3gtxMbx0amcxkUcq99ZyZxI3f9DYr0Fpwde+dFQDJSjNb5x6xEsy2OTHG9IX
         qMz8N3jab7SwVd4KF0FwQuimNlY6VCyF4YsLvjm3yrAMniAyi+YisEgsou7PB8hcHq
         szw5nhgweFsOAVBUr0QPOEpdzlayH5BbWWAgfX+Se0JiCSRxWeGy0KxGfzhXuU5tyU
         OV3Y1vC8EK1X6BCNPiEHNhCltNk1nss7naDa3vwwHXi8zFwtu0gCQWlR5YeeXu/XVd
         VKREVfhLUUCIpKWonNH7qNU2Rv+rT2ArdSqZVSOQ3fjmmRjAdRe/OoLELzXm5Lvvpo
         U6PaokmcqH68w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210713144621.605140-3-dinguyen@kernel.org>
References: <20210713144621.605140-1-dinguyen@kernel.org> <20210713144621.605140-3-dinguyen@kernel.org>
Subject: Re: [PATCH 3/3] clk: socfpga: agilex: add the bypass register for s2f_usr0 clock
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     dinguyen@kernel.org, mturquette@baylibre.com,
        stable@vger.kernel.org, Kris Chaplin <kris.chaplin@intel.com>
To:     Dinh Nguyen <dinguyen@kernel.org>, linux-clk@vger.kernel.org
Date:   Mon, 26 Jul 2021 17:56:44 -0700
Message-ID: <162734740487.2368309.18311166445023866381@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Dinh Nguyen (2021-07-13 07:46:21)
> Add the bypass register for the s2f_user0_clk.
>=20
> Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agil=
ex platform")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kris Chaplin <kris.chaplin@intel.com>
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> ---

Applied to clk-next
