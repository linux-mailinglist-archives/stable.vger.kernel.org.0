Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF0F3CCC70
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 04:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbhGSC6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 22:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhGSC6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 22:58:44 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD593C061762;
        Sun, 18 Jul 2021 19:55:44 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 23so15408189qke.0;
        Sun, 18 Jul 2021 19:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iNXlxu41QAi9eyXyEp9P4BgFOZiugUdeuIzu212ysvs=;
        b=V6b+NmivyRSSIkWo9qNI8PdtQvoet39umINKYQvmFV3Ibk8dDcLbnezTU2TL3xVuwX
         lxx2g0Ie3iY7hoaJX6L660D24e67DqEYVhla1z0HNqfy/y+BI3+J6pptyMaNSOExyt9g
         eyLD5IfT05e00WXxfe2SpXCQKR6s4ezib/xSKVm7rVb8d2PqMrG5BoxOAmpKpQWvyNEM
         YYUV5Zgy3TNTHVgWNn2qH5QZL1Hh0o74isy/24unaCkkimHnJ6MQruXwkblRxzuvlxzi
         uHN21iSpu5XdyLaT6g/d4pM4bXzsNlRSacqFKeXjThvqnJacjYwCVvLv/i18gbby2pPF
         0YVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iNXlxu41QAi9eyXyEp9P4BgFOZiugUdeuIzu212ysvs=;
        b=Q2lomFf2rUAfMWOaBFX22hR81a/EeJtV+L98fvNAdOXOwkz8x8v5qYi6yVjXR6kFLI
         s7CcgomEyo1GmfrIwY8AKWGqBS1Lxcp9lTmyeR1GUjtgImZJGOR9PT4dYmxnZ509ejOd
         3PlXJDPpxXzgJc3P63EapsBD1WTvF5lnbEjn2ItwaxZ0FYUAPZWulykh9JbhdaAIOceP
         G5dMzEDIVNq+YxRIvLLS4UdaGX1sXvkjGOTmw3o6QcnKuKMljvJ0do2WpnfeMa12TwqO
         vHPpCigUQr2gJSkJ4dE95yg5va3gsScmDnyF4Ee4Sh5uQsum/UsqtUfISW/FUlJgnvbg
         aMUQ==
X-Gm-Message-State: AOAM533+bfHxFqFKVA9+L4paWYUhkohN1x00uaMBUdaiULU7iqv4EJhz
        d6KK4N7GKuh6kSX8POvakD+UxZmwvmI/4C/D5FI=
X-Google-Smtp-Source: ABdhPJwB1y+j+sdeR4vc3gg4ZAWtWNDHGEX12CxUO8SxSeJWWN0gV4rMiFEYtb/b/PQi3QMyw20pv7/8kplWmcPQI1w=
X-Received: by 2002:a05:620a:6c9:: with SMTP id 9mr22232077qky.303.1626663344173;
 Sun, 18 Jul 2021 19:55:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210717043159.12566-1-rdunlap@infradead.org>
In-Reply-To: <20210717043159.12566-1-rdunlap@infradead.org>
From:   Dongjiu Geng <gengdongjiu1@gmail.com>
Date:   Mon, 19 Jul 2021 10:55:36 +0800
Message-ID: <CABSBigROX2sYdcOOt=L45_hhdz9reff3t1rD-6M2vDLQ35LcOQ@mail.gmail.com>
Subject: Re: [PATCH] clk: hisilicon: hi3559a: select RESET_HISI
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dongjiu Geng <gengdongjiu@huawei.com>,
        Stephen Boyd <sboyd@kernel.org>, stable@vger.kernel.org,
        linux-clk@vger.kernel.org,
        Michael Turquette <mturquette@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> =E4=BA=8E2021=E5=B9=B47=E6=9C=8817=E6=
=97=A5=E5=91=A8=E5=85=AD =E4=B8=8B=E5=8D=8812:34=E5=86=99=E9=81=93=EF=BC=9A
>
> The clk-hi3559a driver uses functions from reset.c so it should
> select RESET_HISI to avoid build errors.
>
> Fixes these build errors:
> aarch64-linux-ld: drivers/clk/hisilicon/clk-hi3559a.o: in function `hi355=
9av100_crg_remove':
> clk-hi3559a.c:(.text+0x158): undefined reference to `hisi_reset_exit'
> aarch64-linux-ld: drivers/clk/hisilicon/clk-hi3559a.o: in function `hi355=
9av100_crg_probe':
> clk-hi3559a.c:(.text+0x1f4): undefined reference to `hisi_reset_init'
> aarch64-linux-ld: clk-hi3559a.c:(.text+0x238): undefined reference to `hi=
si_reset_exit'
>
> Fixes: 6c81966107dc ("clk: hisilicon: Add clock driver for hi3559A SoC")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Dongjiu Geng <gengdongjiu@huawei.com>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: stable@vger.kernel.org
> Cc: linux-clk@vger.kernel.org
> Cc: Michael Turquette <mturquette@baylibre.com>
> ---
>  drivers/clk/hisilicon/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> --- linux-next-20210716.orig/drivers/clk/hisilicon/Kconfig
> +++ linux-next-20210716/drivers/clk/hisilicon/Kconfig
> @@ -18,6 +18,7 @@ config COMMON_CLK_HI3519
>  config COMMON_CLK_HI3559A
>         bool "Hi3559A Clock Driver"
>         depends on ARCH_HISI || COMPILE_TEST
> +       select RESET_HISI
>         default ARCH_HISI
>         help
>           Build the clock driver for hi3559a.

Reviewed-by: Dongjiu Geng <gengdongjiu1@gmail.com>
