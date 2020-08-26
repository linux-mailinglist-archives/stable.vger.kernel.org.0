Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA94B2530BA
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730406AbgHZNzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:55:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730399AbgHZNxq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:53:46 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C716E22B43;
        Wed, 26 Aug 2020 13:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598450026;
        bh=4p6wpkWaDcp9XBZaMAKxdaroTMtymsvOF4iCoZOz7AQ=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=MDLmtSPrXGG0+KCLXkont5i6mhidpZqEVju78oDykURN6R4OCA1WDO9uM/HmQF0QY
         KWYGlZoXUpxruATJ9aPERy9JESd4GMVJY46P2t0YBBuK+i8hZIKARVEnWFlKr0HGj+
         6jzQEZCiyxVeTmcxLW5AFMY7rYZaQFVo98vGoRrw=
Date:   Wed, 26 Aug 2020 13:53:45 +0000
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
Subject: Re: [PATCH v1 4/4] drm/ast: Disable planes while switching display modes
In-Reply-To: <20200805105428.2590-5-tzimmermann@suse.de>
References: <20200805105428.2590-5-tzimmermann@suse.de>
Message-Id: <20200826135345.C716E22B43@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 4961eb60f145 ("drm/ast: Enable atomic modesetting").

The bot has tested the following trees: v5.8.2, v5.7.16.

v5.8.2: Failed to apply! Possible dependencies:
    05f13f5b5996 ("drm/ast: Remove unused code paths for AST 1180")
    1728bf6402c3 ("drm/ast: Use managed mode-config init")
    2ccebf561e4a ("drm/ast: Move cursor functions to ast_cursor.c")
    6bb18c9be6d2 ("drm/ast: Init cursors before creating modesetting structures")
    beb2355eecbf ("drm/ast: Pass struct ast_private instance to cursor init/fini functions")
    e6949ff3ca85 ("drm/ast: Initialize mode setting in ast_mode_config_init()")
    fa7dbd768884 ("drm/ast: Upcast from DRM device to ast structure via to_ast_private()")

v5.7.16: Failed to apply! Possible dependencies:
    05f13f5b5996 ("drm/ast: Remove unused code paths for AST 1180")
    1728bf6402c3 ("drm/ast: Use managed mode-config init")
    2ccebf561e4a ("drm/ast: Move cursor functions to ast_cursor.c")
    3a53230e1c4b ("drm/ast: Make ast_primary_plane_helper_atomic_update static")
    6bb18c9be6d2 ("drm/ast: Init cursors before creating modesetting structures")
    beb2355eecbf ("drm/ast: Pass struct ast_private instance to cursor init/fini functions")
    e6949ff3ca85 ("drm/ast: Initialize mode setting in ast_mode_config_init()")
    fa7dbd768884 ("drm/ast: Upcast from DRM device to ast structure via to_ast_private()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
