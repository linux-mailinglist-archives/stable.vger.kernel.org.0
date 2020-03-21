Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8F618DC61
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 01:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgCUAI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 20:08:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCUAI7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 20:08:59 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0634320787;
        Sat, 21 Mar 2020 00:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584749339;
        bh=yny377WRpK4XlQfnYzqXIGeWNNtWOQJguIJuybA0pMs=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=L59xcugjt3afJmpVpvTC0rRLoLmLc4TEkzDEMY//UNGHsLFsStgfEv+yBI44EDSv7
         hYbBi7mBuri4x6AnjcdL6S4gO1NEVTD3hpIbAYcub3cHU7Ph8kCGvkBMZZa3gthBOV
         Oxoiap51KmcCjwbsVkMEXJ2WWAMBzRlT9kdYZrEQ=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200213161952.37460-2-paul@crapouillou.net>
References: <20200213161952.37460-1-paul@crapouillou.net> <20200213161952.37460-2-paul@crapouillou.net>
Subject: Re: [PATCH v2 2/2] clk: ingenic/TCU: Fix round_rate returning error
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     od@zcrc.me, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
To:     Michael Turquette <mturquette@baylibre.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Stephen Boyd <sboyd@codeaurora.org>
Date:   Fri, 20 Mar 2020 17:08:58 -0700
Message-ID: <158474933803.125146.5323486613310408237@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Paul Cercueil (2020-02-13 08:19:52)
> When requesting a rate superior to the parent's rate, it would return
> -EINVAL instead of simply returning the parent's rate like it should.
>=20
> Fixes: 4f89e4b8f121 ("clk: ingenic: Add driver for the TCU clocks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---

Applied to clk-next
