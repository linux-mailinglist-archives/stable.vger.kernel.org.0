Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5903D6B57
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 02:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhG0AQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 20:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhG0AQE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 20:16:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DFC360F41;
        Tue, 27 Jul 2021 00:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627347392;
        bh=R9ZEOy1r6Or/Ss0ePV658bz1gFs2gX6O0vcWBLL2grk=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=B1Bgtt9A0rMPwkE4Ua8NfQANTF9lPhTfHpJz1ejibFjaU1wg3h5F30Gxa6VhTOWkF
         zZeaeO1U25Bu2gBR8mY2f9xdYFWyCNxSjk5FVtxXal422AYDEhUzFlNn0bhdtLzMSS
         inzHyqnWScq+ByMo8Hw79JdxrEYPgH7WWY/zxb9uFSaipZQgDoSaTpfGhueVifhhSG
         CQMRd91Cfkl5tumyvKR+2PgTSeSkiQ956+v73BUygknTb2HiqZHYUsJJHzdzU/uOYi
         ORfkCze+z/bdj0omfRUOTXJrimy6kqIb1kOUgcwNhLChC7eMM2lgrUcqT1MV//ypa1
         vXZg49R8o0pag==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210713144621.605140-1-dinguyen@kernel.org>
References: <20210713144621.605140-1-dinguyen@kernel.org>
Subject: Re: [PATCH 1/3] clk: socfpga: agilex: fix the parents of the psi_ref_clk
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     dinguyen@kernel.org, mturquette@baylibre.com,
        stable@vger.kernel.org, Kris Chaplin <kris.chaplin@intel.com>
To:     Dinh Nguyen <dinguyen@kernel.org>, linux-clk@vger.kernel.org
Date:   Mon, 26 Jul 2021 17:56:31 -0700
Message-ID: <162734739123.2368309.12149628043516066651@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Dinh Nguyen (2021-07-13 07:46:19)
> The psi_ref_clk comes from the C2 node of the main_pll and periph_pll,
> not the C3.
>=20
> Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agil=
ex platform")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kris Chaplin <kris.chaplin@intel.com>
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> ---

Applied to clk-next
