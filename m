Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802C623FF16
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 17:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgHIPxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Aug 2020 11:53:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgHIPxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Aug 2020 11:53:12 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E724F2073E;
        Sun,  9 Aug 2020 15:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596988392;
        bh=sH4Vuic7mcb5kc+ZXbE8/JTtggI05DY+XJSZJp+wPfs=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=QrbWwaDYxSaPWOdQs+NU4c1XvzIL7d1OTbDgImHr62sPzhg7qtXb1/bBTz8EgfE6C
         HXlGBPfwmmOlyC2ot8YicGDSXga/tmTgst7xW14BGNaS0lVdt1cehlYht7vmhjOGpZ
         MXpPdYAtYeIBVwmr90IepX7yWCfEfEm+wkDkx+I4=
Date:   Sun, 09 Aug 2020 15:53:11 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>
To:     airlied@redhat.com, daniel@ffwll.ch, sam@ravnborg.org
Cc:     dri-devel@lists.freedesktop.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Dave Airlie <airlied@redhat.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Sam Ravnborg <sam@ravnborg.org>
Cc:     Emil Velikov <emil.l.velikov@gmail.com>
Cc:     "Y.C. Chen" <yc_chen@aspeedtech.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v1 2/4] drm/ast: Set display mode in atomic_begin()
In-Reply-To: <20200805105428.2590-3-tzimmermann@suse.de>
References: <20200805105428.2590-3-tzimmermann@suse.de>
Message-Id: <20200809155311.E724F2073E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 4961eb60f145 ("drm/ast: Enable atomic modesetting").

The bot has tested the following trees: v5.8, v5.7.13.

v5.8: Failed to apply! Possible dependencies:
    05f13f5b5996 ("drm/ast: Remove unused code paths for AST 1180")
    fa7dbd768884 ("drm/ast: Upcast from DRM device to ast structure via to_ast_private()")

v5.7.13: Failed to apply! Possible dependencies:
    05f13f5b5996 ("drm/ast: Remove unused code paths for AST 1180")
    3a53230e1c4b ("drm/ast: Make ast_primary_plane_helper_atomic_update static")
    fa7dbd768884 ("drm/ast: Upcast from DRM device to ast structure via to_ast_private()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
