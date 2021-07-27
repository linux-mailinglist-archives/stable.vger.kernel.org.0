Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895973D7F88
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 22:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhG0UvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 16:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231730AbhG0UvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 16:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5585160F58;
        Tue, 27 Jul 2021 20:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627419071;
        bh=ZIAjZ+J0iM89/8iaYAsrzwXlGKwIu50aciYe7xisdIA=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=Iy7h+BBwq9IL6jp3mYo8vrM0zHcirWiozWGO0wtYDmlTqEzgNfSVQhQM8Pl6UoaaV
         AWG2yjLwOCgdde3DOJjOx1n01J83tiv++6yKIlDnEjZ5GPcgCk7mcyfhMt3g/zfcll
         HDrtGr6W4hskPwXO6fgt6ZYEprcCfHvXrooAPXNa27qPtyVwUgpyUMWzlLuBhs50RB
         jNCICm0fT+g3Jlcl4lHuHP63WN41bRTaMANnrcp+vECGOIxIYm9IeD24kFUobLO8JN
         ZXfk3erYuuC3pmGDKudMhw2Se6WN9+hNQSFFOAQaBozPDOOa8jk/iWynW+O+6BxVky
         N4i9BD7r79r2w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YPVWY4h+nSP6IGZc@ryzen>
References: <20210702085438.1988087-1-aisheng.dong@nxp.com> <YPVWY4h+nSP6IGZc@ryzen>
Subject: Re: [PATCH 1/1] clk: imx6q: fix uart earlycon unwork
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dongas86@gmail.com, shawnguo@kernel.org, kernel@pengutronix.de,
        aford173@gmail.com, stable@vger.kernel.org
To:     Abel Vesa <abel.vesa@nxp.com>, Dong Aisheng <aisheng.dong@nxp.com>
Date:   Tue, 27 Jul 2021 13:51:10 -0700
Message-ID: <162741907003.2368309.8765989426815970294@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Abel Vesa (2021-07-19 03:39:31)
> On 21-07-02 16:54:38, Dong Aisheng wrote:
> > The earlycon depends on the bootloader setup UART clocks being retained.
> > There're actually two uart clocks (ipg, per) on MX6QDL,
> > but the 'Fixes' commit change to register only one which means
> > another clock may be disabled during booting phase
> > and result in the earlycon unwork.
> >=20
> > Cc: stable@vger.kernel.org # v5.10+
> > Fixes: 379c9a24cc23 ("clk: imx: Fix reparenting of UARTs not associated=
 with stdout")
> > Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
>=20
>=20
> Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
>=20
> Stephen, will you pick this up ?
>=20

Sure I can pick it up if you need me to pick it to fixes?
