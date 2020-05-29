Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351A41E74D6
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 06:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgE2E0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 00:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbgE2E0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 May 2020 00:26:37 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0B7E2074D;
        Fri, 29 May 2020 04:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590726397;
        bh=biY26RlQtZl+eOvAa3r0qNI+95AZPiHE6MWy69incsQ=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=uR/4VKmjPeu7nUm0lkHtc5fQuVyg9Cv8k9mjBTofLk9uGIZ+gv7NcC1inBtBriBu5
         ydFYWUvxalNlqlw/nKCPjTvH8jWZ1TRiCEu7pDvB5+NSVdzR97iRZSQekgx7ct8aTp
         2NgFtT9YMZWTQ17NB/enzc0fLu2TBOXJ+pMrMYyw=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1590560749-29136-1-git-send-email-weiyi.lu@mediatek.com>
References: <1590560749-29136-1-git-send-email-weiyi.lu@mediatek.com>
Subject: Re: [PATCH v2] clk: mediatek: assign the initial value to clk_init_data of mtk_mux
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     James Liao <jamesjj.liao@mediatek.com>,
        Fan Chen <fan.chen@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-clk@vger.kernel.org,
        srv_heupstream@mediatek.com, stable@vger.kernel.org,
        Weiyi Lu <weiyi.lu@mediatek.com>,
        Owen Chen <owen.chen@mediatek.com>
To:     Matthias Brugger <matthias.bgg@gmail.com>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Weiyi Lu <weiyi.lu@mediatek.com>
Date:   Thu, 28 May 2020 21:26:36 -0700
Message-ID: <159072639634.69627.7492835408539422310@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Weiyi Lu (2020-05-26 23:25:49)
> When some new clock supports are introduced, e.g. [1]
> it might lead to an error although it should be NULL because
> clk_init_data is on the stack and it might have random values
> if using without initialization.
> Add the missing initial value to clk_init_data.
>=20
> [1] https://android-review.googlesource.com/c/kernel/common/+/1278046
>=20
> Fixes: a3ae549917f1 ("clk: mediatek: Add new clkmux register API")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Weiyi Lu <weiyi.lu@mediatek.com>
> Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---

Applied to clk-next
