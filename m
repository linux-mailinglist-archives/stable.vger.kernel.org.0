Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5B64983E0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbiAXPz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbiAXPz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 10:55:26 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFC2C061401
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 07:55:26 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id i62so4347755ioa.1
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 07:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PAk46n1MPi9gPpAjJNci/8kPlMhpslWLN7yEsIjhWq4=;
        b=GewqqABG6/7V/ms2Yxh7ww0Nktw+O/cM64/81V2i9uPU+eqLQGhPIxs51HP/nA4dY3
         NBwP5hsYz/pkFblWVNpzZWr2f1OLQNhVUcqIZaiWJK0qbBeZ/mhUzr5oUmVvgxDGxLdS
         Yc2pEbNFbzn8HwdF0zHkzo0nTuUQqmtK9e0zY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PAk46n1MPi9gPpAjJNci/8kPlMhpslWLN7yEsIjhWq4=;
        b=MIkTrGvgqx2suDpVsGDqEyS8lPkQN185CR+3K9t7zwOpc2Jc7+lLi7j6r4GlPvmvnJ
         7/WXNF7LqelDTKcqsVeKAw7sLE6eIjI8hhwDdnkLbHOBeXP0mbbfTUcXncFAj7MzaRCN
         RCV2QSqeJ3wJ5L/MU2LmMSToS8M/H6QlUkeQwG5QRIjNdFFlOdZixltKqRcIACHRU28b
         o8RVHZbLLaA/1LhtYC6UwGCP/UfxoexegvdNDxMg8IKZgqYxPc4U+DUiHehDRJrCaE6R
         42m0DSMCqCNdasAgXSPah007dQMzBdM8Cef51P/R1lJ1DIlu411LmUFWOqmEsLJaWZQ5
         v7GA==
X-Gm-Message-State: AOAM5316f8QDxdDepulcXnDwO8GojJGmDlLLBuXYNaSV/FmacgleWXjU
        MWwLn7oxGjTmRHsniBqYJhY1y4sga1FR4ijlk5VHHM+IDL8=
X-Google-Smtp-Source: ABdhPJyxBqzCdPqA56UWB4jv/1dn8GxVWqJQuoJalf6pMaCqUpsM+VCbcLeIjIQvF+SRKk4FjmW02qOpqmaS1PtY8Pg=
X-Received: by 2002:a02:6d04:: with SMTP id m4mr6392976jac.80.1643039725076;
 Mon, 24 Jan 2022 07:55:25 -0800 (PST)
MIME-Version: 1.0
References: <20220123001258.2460594-1-sashal@kernel.org> <20220123001258.2460594-3-sashal@kernel.org>
 <20220124075041.13c015a6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220124075041.13c015a6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Mon, 24 Jan 2022 15:55:14 +0000
Message-ID: <CALrw=nFwuo=OWzDimGK0MyqLs4LBu9_WkKxXLpw+e2oTJAD8Lw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.10 3/9] sit: allow encapsulated IPv6 traffic to
 be delivered locally
To:     Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>,
        stable@vger.kernel.org, netdev <netdev@vger.kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Amir Razmjou <arazmjou@cloudflare.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 3:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 22 Jan 2022 19:12:52 -0500 Sasha Levin wrote:
> > From: Ignat Korchagin <ignat@cloudflare.com>
> >
> > [ Upstream commit ed6ae5ca437d9d238117d90e95f7f2cc27da1b31 ]
> >
> > While experimenting with FOU encapsulation Amir noticed that encapsulated IPv6
> > traffic fails to be delivered, if the peer IP address is configured locally.
>
> Unless Ignat and Amir need it I'd vote for not backporting this to LTS.
> This patch is firmly in the "this configuration was never supported"
> category. 5.15 and 5.16 are probably fine.

We planned to use it on 5.15 and onwards. Not backporting to 5.10 is
fine for us.
