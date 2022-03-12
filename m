Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73CFB4D6C42
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 04:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiCLDaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 22:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiCLDaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 22:30:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EA921DF33;
        Fri, 11 Mar 2022 19:29:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 037006118A;
        Sat, 12 Mar 2022 03:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5980FC340E9;
        Sat, 12 Mar 2022 03:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647055749;
        bh=hlLmXD3I16SiK60neWNtvUbjfyYJa8N9Pf4SvoQctFs=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=uWsp72PgHLz/QjpGeExagBgvIcq51RADdT8vKKNFIc3rKJw0zGpe+3FRBk1BPSPEd
         IJ7zMJeUqPM9nvlBR9KcdfQ0re70oZZCBDC3KifG02QfB21aLYzyT+5jNDHyeYj7yl
         jB+Aa/3fB0ALyyTFqZAZyUiw7bxN0yccZwzYaygd8F51faSCsHveA84Q74Hbnzmw/k
         IyidqcOolAvWaSF3J5htxYcYJRuE4kqw5skWxwjVgyK25OHYu+A6lv6zKnUQkDJY4h
         gMUFGyWb2NePUxSGSgjVU7GiKoj+nZY5T702rWySoiYFf0UmTLk8EfCSrH5Zz7f8CH
         RZbvuw5RIdgFg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1646808918-30899-1-git-send-email-hayashi.kunihiko@socionext.com>
References: <1646808918-30899-1-git-send-email-hayashi.kunihiko@socionext.com>
Subject: Re: [PATCH] clk: uniphier: Fix fixed-rate initialization
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        stable@vger.kernel.org
To:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>
Date:   Fri, 11 Mar 2022 19:29:07 -0800
User-Agent: alot/0.10
Message-Id: <20220312032909.5980FC340E9@smtp.kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Kunihiko Hayashi (2022-03-08 22:55:18)
> Fixed-rate clocks in UniPhier don't have any parent clocks, however,
> initial data "init.flags" isn't initialized, so it might be determined
> that there is a parent clock for fixed-rate clock.
>=20
> This sets init.flags to zero as initialization.
>=20
> Cc: <stable@vger.kernel.org>
> Fixes: 734d82f4a678 ("clk: uniphier: add core support code for UniPhier c=
lock driver")
> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> ---

Applied to clk-next
