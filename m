Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6922C73F3
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389152AbgK1Vtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 16:49:51 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35201 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731299AbgK1Sto (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Nov 2020 13:49:44 -0500
Received: by mail-lf1-f68.google.com with SMTP id a9so12059741lfh.2;
        Sat, 28 Nov 2020 10:49:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=94w+w4q2DL8CfQBxAM1xY8lwOUr+KvOfw3ByQOJVKuk=;
        b=knwr6FWiDspxB0X1Culaha/p7eb3xJfHmACgGn7ReKXwwN0GGq4cIvMN5nhzJnGPQp
         iBC30DtrWtA5J7PtG5CVaMDQ3kgJ9ZNQtVudKLiK8b+ho3bmlYHLEYPHsaB4ZXXrcD6A
         gpE4X+fdY7dSzrKZODKjwSZDqcIK7nxHWKkxH4+kPM1GPZpgqAYIWnGiOcA0o294xzfs
         zmre0zb1bwYef/gWreJpoCCNdHIIaSs6snkeRjUEV7rHgl2xrCC5CyIz4sG5v1wgipch
         92vj0HfzhENyaCji6X6v9QnwncnyLUCGhQ4V2gx/armh+b4ikysbN02WCWEPAOWnLaBG
         dZPw==
X-Gm-Message-State: AOAM530UZra3eEh2LEKqwiesxNUOz8P2+4eV5kMxYCLX9TEP07GnLkHP
        DrKFWXUSCHLj69uto9geQZc3sNlUgvA=
X-Google-Smtp-Source: ABdhPJyLh6B3nxSjRDcChAYngodNGnYIRfHxi//tXNNB+WXdMW2TXjVSZwSmgZwBFnUYvUFPYdEs3g==
X-Received: by 2002:a17:906:7c56:: with SMTP id g22mr12023158ejp.282.1606563360738;
        Sat, 28 Nov 2020 03:36:00 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id a12sm6295814edu.89.2020.11.28.03.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 03:35:59 -0800 (PST)
Date:   Sat, 28 Nov 2020 12:35:58 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jiri Kosina <trivial@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/5] memory: renesas-rpc-if: Fix a reference leak in
 rpcif_probe()
Message-ID: <20201128113558.GC4761@kozik-lap>
References: <20201126191146.8753-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20201126191146.8753-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20201127224114.GB19743@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201127224114.GB19743@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 11:41:14PM +0100, Pavel Machek wrote:
> On Thu 2020-11-26 19:11:44, Lad Prabhakar wrote:
> > Release the node reference by calling of_node_put(flash) in the probe.
> > 
> > Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
> > Reported-by: Pavel Machek <pavel@denx.de>
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
> 
> Reviewed-by: Pavel Machek (CIP)< <pavel@denx.de>

This breaks b4. Corrected and applied.

Best regards,
Krzysztof
