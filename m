Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411A1405B3F
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 18:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbhIIQuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 12:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236956AbhIIQuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 12:50:14 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02F4C061574;
        Thu,  9 Sep 2021 09:49:04 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id w4so3961922ljh.13;
        Thu, 09 Sep 2021 09:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qWOIaC+TvNWd+AMzTos4mtf9fM8rknThYeJRH9lEJXU=;
        b=U9NX86XabwKIJAdsKSFV+4yQ8gXdlGcU6tN5lENt3KbAmusF0kqVz9cvV9qvSHWgmM
         Axh1CQoKuU+OljYQMr177RTseXOLYwf45ve0MPtQZS4xQi7iKeFrkjgPyb0THg+gREi9
         VYsJvR46y6fZUxjEp45buNqa97AN3bBYaN/GQGAi5C80jGQksm3avxVJr4itLxuALxkY
         IaMYpdjj+Bj0DppVpo8pZ2VLD7r1k2Lyd2kl9bxeYGW3zns+ZiJN90VlLd5QoqFnFLiS
         ONMyqRV2P4pWHhrdJ3EIySaInOdH1JwyAxZnUEBkHqzj57AzX6c7gy30Lz9UGs/nSjpQ
         QAcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qWOIaC+TvNWd+AMzTos4mtf9fM8rknThYeJRH9lEJXU=;
        b=vyfzDZH9KP1LOdyWFZ5zdXrRvT9PbQknfj8xl3rjyWMPCV503F/BVO5toarldRAkbP
         Ph4DUdXhPojjkHXq6TY+IaSIswuPRq0JlRDAs3dmhKeDLfFWbbY2bK0pLlD+2UdJkR1n
         NArsoPxT1a4kdfMyIeGPF4KRV4HiKK+mBJCXyyJKAYv38D0VnzXgAmjeIVUxoJ+upzOr
         SKKxlcuBUSbPXnx59KKSosfRdS+FxbR21g6Yq2qCdZgKJyzDO7a9oBnE0kMxyOUNHvf1
         sLx26lI2+pyd2Sx3qkjIJY3JST15JtK7S3H4m5yr0bYicb1Di0WYZj6lhQ9iVSLsrXls
         DsJA==
X-Gm-Message-State: AOAM5317hpw+NK4eydH+mGi00oWIyHA+xA0Ew0D8bBDIqPM156dsty8l
        gV0GnCziyYF7OMc+7DFD6+ZHK6jg47isd05Z02c=
X-Google-Smtp-Source: ABdhPJw4kkUR2ubxtTJMGrVUUYI3maIUqzLrEiloqFnTwt2MR8ws2t3UMujd+lFeKL+GvF2tTw7O8N48SninAhZ2p+U=
X-Received: by 2002:a2e:b53a:: with SMTP id z26mr625960ljm.95.1631206142992;
 Thu, 09 Sep 2021 09:49:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210909114106.141462-1-sashal@kernel.org> <20210909114106.141462-58-sashal@kernel.org>
 <500c68753cac86d9b3021ddf1e8580779e685332.camel@pengutronix.de>
In-Reply-To: <500c68753cac86d9b3021ddf1e8580779e685332.camel@pengutronix.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 9 Sep 2021 13:48:51 -0300
Message-ID: <CAOMZO5D6pbTG3O14OtZRUCa5DPcG0seUzot4gX4Y=hQOpxRfdQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.14 058/252] spi: imx: fix ERR009165
To:     Lucas Stach <l.stach@pengutronix.de>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Robin Gong <yibin.gong@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lucas,

On Thu, Sep 9, 2021 at 1:43 PM Lucas Stach <l.stach@pengutronix.de> wrote:
>
> Hi Sasha,
>
> Am Donnerstag, dem 09.09.2021 um 07:37 -0400 schrieb Sasha Levin:
> > From: Robin Gong <yibin.gong@nxp.com>
> >
> > [ Upstream commit 980f884866eed4dda2a18de888c5a67dde67d640 ]
> >
> > Change to XCH  mode even in dma mode, please refer to the below
> > errata:
> > https://www.nxp.com/docs/en/errata/IMX6DQCE.pdf
> >
>
> This patch is part of a quite extensive series touching multiple
> drivers and devicetree descriptions and will do more harm than good if
> backported without the rest of the series. The options here are:
> a) backport the entire series (this will most likely not match the
> stable criteria)
> b) drop the patch from the stable queue

Yes, I agree. I prefer going with option b).

Thanks
