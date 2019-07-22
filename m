Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 459CB70C53
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 00:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733029AbfGVWGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 18:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733025AbfGVWGq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jul 2019 18:06:46 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C51BC219BE;
        Mon, 22 Jul 2019 22:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563833205;
        bh=ct5XMG5jd8SEOqNhHTmwrTDKIvFXpl4CC8wJlVMQuow=;
        h=In-Reply-To:References:Subject:To:Cc:From:Date:From;
        b=fKJ9hUVSZGiz0iODpcVGiw9VIVgyz32eLhKWS1N6bvVUOlzFe/rwEXimamHEaj+oa
         QcADkjMe1jckx3IojJzEvbO8DlBeeGNb52J/HWfS85IDmIHL2wDiILqtx/Ue8xGDmg
         +on2k8vM9n7KJOkBKk2nm7d2iEVtLyUL6I0NnylQ=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1563157783-31846-1-git-send-email-peng.fan@nxp.com>
References: <1563157783-31846-1-git-send-email-peng.fan@nxp.com>
Subject: Re: [PATCH] clk: imx: imx8mm: fix audio pll setting
To:     "festevam@gmail.com" <festevam@gmail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Peng Fan <peng.fan@nxp.com>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Anson Huang <anson.huang@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "van.freenix@gmail.com" <van.freenix@gmail.com>,
        Peng Fan <peng.fan@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Stephen Boyd <sboyd@kernel.org>
User-Agent: alot/0.8.1
Date:   Mon, 22 Jul 2019 15:06:44 -0700
Message-Id: <20190722220645.C51BC219BE@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Peng Fan (2019-07-14 19:55:43)
> From: Peng Fan <peng.fan@nxp.com>
>=20
> The AUDIO PLL max support 650M, so the original clk settings violate
> spec. This patch makes the output 786432000 -> 393216000,
> and 722534400 -> 361267200 to aligned with NXP vendor kernel without any
> impact on audio functionality and go within 650MHz PLL limit.
>=20
> Cc: <stable@vger.kernel.org>
> Fixes: ba5625c3e272 ("clk: imx: Add clock driver support for imx8mm")
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---

Is this a problem right now, i.e. should I apply this to clk-fixes? Or
can this wait until next merge window?

