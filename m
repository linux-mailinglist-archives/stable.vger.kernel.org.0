Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA732F0A9E
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 01:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbhAKAfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 19:35:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbhAKAfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Jan 2021 19:35:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4452E22AAF
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 00:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610325292;
        bh=AvZu/yzQZ0S81xr5zCgx+Fvr+whTVdrmiVGT+KFZxfg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bEpnuXMPJh9ekZQmhwgUGMCUzcB7E6ENaLAXtp5nFoJU8wkkfGFwiJWmio1zrJSE7
         W19ON01uBM5zhUS96w4L7l/bDrBfCO/OB/t9Plwpfoc1bMgN9dVb5KZP/5Yu0eAcui
         QghdIrPY8Zkn18vL+UqSiN+KDsgLFjdjruFQuZVVHqAiEKxRwJ0474ei3RSg9kMCyM
         XT4Nd2aV/SftCPdrDXN+7lQwNvXFVkrpku1fikc2S3P+9qiRUSKSx/TioFOJ8OLVm2
         fDgJGEgRzCEnHWIkv/2lWwXWfFiNnsglfUdRsRV5IBDlsJ175KgP2e1JSr4EXX5wlI
         LwD0liul1rm3A==
Received: by mail-oo1-f50.google.com with SMTP id j8so3746076oon.3
        for <stable@vger.kernel.org>; Sun, 10 Jan 2021 16:34:52 -0800 (PST)
X-Gm-Message-State: AOAM530GwhhG3ncOdlJueUSW/URbZM6ryyOgOayUxNWPOt3jicnSAXGy
        nmxj87N3YIUVN1oMLG4CTr+l/0f9NC6KBVvTPhs=
X-Google-Smtp-Source: ABdhPJx5iT08c4secGGQgi7nIojpTVasG/O1eGpuiPcg/1hANvlzV8WvborVk6YIZh+mCZnNLIYHEUvPMShZZpJrE1Q=
X-Received: by 2002:a4a:946d:: with SMTP id j42mr10441427ooi.39.1610325291623;
 Sun, 10 Jan 2021 16:34:51 -0800 (PST)
MIME-Version: 1.0
References: <20201222155908.48600-1-smoch@web.de> <20210111003134.GS28365@dragon>
In-Reply-To: <20210111003134.GS28365@dragon>
From:   Shawn Guo <shawnguo@kernel.org>
Date:   Mon, 11 Jan 2021 08:34:41 +0800
X-Gmail-Original-Message-ID: <CAJBJ56+RiYXEM-0zdzeYQgi7+dLPs2JDfSRwpM7U9oCmegU9Nw@mail.gmail.com>
Message-ID: <CAJBJ56+RiYXEM-0zdzeYQgi7+dLPs2JDfSRwpM7U9oCmegU9Nw@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: tbs2910: rename MMC node aliases
To:     Soeren Moch <smoch@web.de>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 8:32 AM Shawn Guo <shawnguo@kernel.org> wrote:
>
> On Tue, Dec 22, 2020 at 04:59:08PM +0100, Soeren Moch wrote:
> > to be consistent with kernel versions up to v5.9 (mmc aliases not used here).
> > usdhc1 is not wired up on this board and therefore cannot be used.
> > Start mmc aliases with usdhc2.
> >
> > Signed-off-by: Soeren Moch <smoch@web.de>
> > Cc: stable@vger.kernel.org                # 5.10.x
>
> Can we have a Fixes tag as well?

Doesn't matter, since it's essentially just backport to 5.10 stable kernel.

Applied, thanks.
