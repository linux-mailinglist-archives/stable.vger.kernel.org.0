Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929533D6B00
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 02:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhGZXnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 19:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233770AbhGZXnT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 19:43:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1846860F55;
        Tue, 27 Jul 2021 00:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627345427;
        bh=it1r8ZVQDSmGzzDfwDCXufyBA9KAwljaPLoLLA5rKo0=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=E4RVsb7iA1A5LaXjRCHORYv1H19RscrLygQBf+ayI+tYecKHx6KPh26gEMvkRA2fm
         F9NsNw2dRvHVMD3ScTw/m0jFA1u+RsO8kE3mL8+3xKZWE8ks8v9azLfSURrr2Ipj9t
         PUGvF8q+6rszddPkWQmfLLPerbF41J23PI5MC2UMbWxiK9MPVS16KS7UOpB8SiBPG6
         TvZecpvXB17eEqXnVmjuClahuF6wwrIe7Q4E97JJGnBHH+uQb4w380yblBHehNfO8p
         Qs0NC6Gj5Qqi5bjUcXngLwxy19zikYxM7VxTx1ED6bAK815yZuOzls7aux7WIU8PSl
         BbJNvw0wLnbdw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210717043159.12566-1-rdunlap@infradead.org>
References: <20210717043159.12566-1-rdunlap@infradead.org>
Subject: Re: [PATCH] clk: hisilicon: hi3559a: select RESET_HISI
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Dongjiu Geng <gengdongjiu@huawei.com>, stable@vger.kernel.org,
        linux-clk@vger.kernel.org,
        Michael Turquette <mturquette@baylibre.com>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Date:   Mon, 26 Jul 2021 17:23:45 -0700
Message-ID: <162734542596.2368309.11929983891973867074@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Randy Dunlap (2021-07-16 21:31:59)
> The clk-hi3559a driver uses functions from reset.c so it should
> select RESET_HISI to avoid build errors.
>=20
> Fixes these build errors:
> aarch64-linux-ld: drivers/clk/hisilicon/clk-hi3559a.o: in function `hi355=
9av100_crg_remove':
> clk-hi3559a.c:(.text+0x158): undefined reference to `hisi_reset_exit'
> aarch64-linux-ld: drivers/clk/hisilicon/clk-hi3559a.o: in function `hi355=
9av100_crg_probe':
> clk-hi3559a.c:(.text+0x1f4): undefined reference to `hisi_reset_init'
> aarch64-linux-ld: clk-hi3559a.c:(.text+0x238): undefined reference to `hi=
si_reset_exit'
>=20
> Fixes: 6c81966107dc ("clk: hisilicon: Add clock driver for hi3559A SoC")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Dongjiu Geng <gengdongjiu@huawei.com>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: stable@vger.kernel.org
> Cc: linux-clk@vger.kernel.org
> Cc: Michael Turquette <mturquette@baylibre.com>
> ---

Applied to clk-fixes
