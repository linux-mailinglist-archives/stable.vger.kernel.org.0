Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F43A2C73BF
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387516AbgK1Vty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 16:49:54 -0500
Received: from mail-ej1-f65.google.com ([209.85.218.65]:45567 "EHLO
        mail-ej1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387461AbgK1TJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Nov 2020 14:09:58 -0500
Received: by mail-ej1-f65.google.com with SMTP id qw4so2452199ejb.12;
        Sat, 28 Nov 2020 11:09:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/ME2+2j5cxtJTHTHYnz5FDVE1s+VeZgq/6+1g5PUpbU=;
        b=OILOcHvlV831nnq4Hs3tfTQ7YsyOTjDekgwJ99WGG/GoJsfMxnWlwdaGGuWmKr/Mew
         S1+D08k3ZNE6INgSV8cRn9e4TLGGBLXhX64kyRJyalHknsBJmzBFszYFHheJTOWobhkB
         8mXcXa55M4OilqOzbyA0lxNWBDiGFqdGM+gn0lgh7NsXyMdgMwuwHvRHHxLuE2FQewx/
         NVf1dFCPK782ubyjo2Ddt0SvfSCL8W43VdEJLFtciS4UnCje7PjRKDzyfmun+KSsj+XN
         0unsLWivnFfID8Xv7yfrKhpApsIPGQwe+FMKIIQzxwV9TINFOS1DIxs/xBe2bCowDObc
         FRag==
X-Gm-Message-State: AOAM530ydpL6yvl95iABFGfh+mcK1alvA61un5ogoxhM3cL/NhjzyzBG
        PejONck7B1Ag+pJgE3sX/d6odMqeA84=
X-Google-Smtp-Source: ABdhPJxyr32QgRBuEUlVkPnf5RE1qVYd9nKcCKgCUyLEI8ViBgxfjsH66kvx+1LkdV5Qj0xElpN56A==
X-Received: by 2002:a17:906:7f19:: with SMTP id d25mr12318928ejr.0.1606563230246;
        Sat, 28 Nov 2020 03:33:50 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id f24sm5786121ejf.117.2020.11.28.03.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 03:33:49 -0800 (PST)
Date:   Sat, 28 Nov 2020 12:33:47 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jiri Kosina <trivial@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        linux-renesas-soc@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/5] memory: renesas-rpc-if: Fix unbalanced
 pm_runtime_enable in rpcif_{enable,disable}_rpm
Message-ID: <20201128113347.GB4761@kozik-lap>
References: <20201126191146.8753-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20201126191146.8753-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201126191146.8753-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 26, 2020 at 07:11:43PM +0000, Lad Prabhakar wrote:
> rpcif_enable_rpm calls pm_runtime_enable, so rpcif_disable_rpm needs to
> call pm_runtime_disable and not pm_runtime_put_sync.
> 
> Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
> Reported-by: Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/memory/renesas-rpc-if.c | 2 +-

Thanks, applied with corrected Reported-by.

Best regards,
Krzysztof

