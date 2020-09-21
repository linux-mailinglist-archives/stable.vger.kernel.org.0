Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F3F27244E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgIUMyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbgIUMyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 08:54:53 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 222E1218AC;
        Mon, 21 Sep 2020 12:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600692893;
        bh=Cdt5fsam+VR8mdLWnkpxr4eIjtXGKQuf8E1hseoXCMc=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=hJjyHUPFvysy/f2qcleT7GQAhmgn7mg6nrnhEDac4XszG08fZM8Jn620GcXGC5Pon
         YfT1tCa5ORpimz8KnrAx2yB5NaeKGmPBLuCdAJvTdcS6Cp2F2G0qpVCXIhtsJXNjoA
         ADkWvvBOUG6ehCx2zz0z2PuAB0xuwtu3ChLVh1sw=
Date:   Mon, 21 Sep 2020 12:54:52 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Biju Das <biju.das.jz@bp.renesas.com>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] drm: rcar-du: Fix LVDS dual link mode kernel crash
In-Reply-To: <20200918110818.11303-1-biju.das.jz@bp.renesas.com>
References: <20200918110818.11303-1-biju.das.jz@bp.renesas.com>
Message-Id: <20200921125453.222E1218AC@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: a6cc417d3eee ("drm: rcar-du: Turn LVDS clock output on/off for DPAD0 output on D3/E3").

The bot has tested the following trees: v5.8.10, v5.4.66.

v5.8.10: Build OK!
v5.4.66: Failed to apply! Possible dependencies:
    35a61fe9218a ("drm: Stop accessing encoder->bridge directly")
    62afb4ad425a ("drm/connector: Allow max possible encoders to attach to a connector")
    89958b7cd955 ("drm/bridge: panel: Infer connector type from panel by default")
    a92462d6bf49 ("drm/connector: Share with non-atomic drivers the function to get the single encoder")
    ea099adfdf4b ("drm/bridge: Rename bridge helpers targeting a bridge chain")
    fadf872d9d92 ("drm/bridge: Introduce drm_bridge_get_next_bridge()")
    fe9e557dfb48 ("drm/bridge: Fix references to drm_bridge_funcs in documentation")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
