Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0267F257AD
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 20:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbfEUSnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 14:43:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbfEUSnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 14:43:12 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B4A020862;
        Tue, 21 May 2019 18:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558464191;
        bh=L96gEwhzXS8dH76O3LoMeL1+YYnNfRATLa7ZW46Bgpw=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=rSOf6TJR+EkwkNLjOUJe0ei0k40QHpSAzC8q98LT1tfx5vNIzZzEB8CTXEtbSw4gA
         yH96MX+btZpGrqyqsT3TQo/3RevmwXX4mQAiFnsF7IDCQSbWGm++YUC2rXW3c2HWYW
         t+psVXKLJCCNY/JLTFfMLmUjpKCFIqeWjAiLarfY=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190520021702.3531-1-peng.fan@nxp.com>
References: <20190520021702.3531-1-peng.fan@nxp.com>
Subject: Re: [PATCH V3] clk: imx: imx8mm: fix int pll clk gate
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peng Fan <peng.fan@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
To:     "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Peng Fan <peng.fan@nxp.com>
User-Agent: alot/0.8.1
Date:   Tue, 21 May 2019 11:43:10 -0700
Message-Id: <20190521184311.6B4A020862@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Peng Fan (2019-05-19 19:03:19)
> To Frac pll, the gate shift is 13, however to Int PLL the gate shift
> is 11.
>=20
> Cc: <stable@vger.kernel.org>
> Fixes: ba5625c3e27 ("clk: imx: Add clock driver support for imx8mm")
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> Reviewed-by: Fabio Estevam <festevam@gmail.com>
> Reviewed-by: Jacky Bai <ping.bai@nxp.com>
> ---

Applied to clk-fixes

