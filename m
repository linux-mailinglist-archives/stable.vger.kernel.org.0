Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A192624AA38
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgHSX5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgHSX5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:57:02 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF25622B47;
        Wed, 19 Aug 2020 23:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881422;
        bh=NFqkHQ7qxaIIbvZMqxzEDeEzaXOH6M8gQU88Y/OeO4I=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=UhsC72eLnaNRKZgDGDt1tmmeYUFr5DcrCXeFh0RigJZ0sjBPZgq8HEt5FKViDVTu/
         o/j5tWrM87Sbv+H/JfBLbs8eIDc15OrsKIjKW9lJEDG8eYwfnj3v65ODxHwcJcaleF
         +XBAVYNxFWz0F6WWE2mhpYKZtZyo3QFmivOn0Um0=
Date:   Wed, 19 Aug 2020 23:57:01 +0000
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
Subject: Re: [PATCH v1 1/4] drm/ast: Only set format registers if primary plane's format changes
In-Reply-To: <20200805105428.2590-2-tzimmermann@suse.de>
References: <20200805105428.2590-2-tzimmermann@suse.de>
Message-Id: <20200819235701.CF25622B47@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 4961eb60f145 ("drm/ast: Enable atomic modesetting").

The bot has tested the following trees: v5.8.1, v5.7.15.

v5.8.1: Failed to apply! Possible dependencies:
    05f13f5b5996 ("drm/ast: Remove unused code paths for AST 1180")
    fa7dbd768884 ("drm/ast: Upcast from DRM device to ast structure via to_ast_private()")

v5.7.15: Failed to apply! Possible dependencies:
    05f13f5b5996 ("drm/ast: Remove unused code paths for AST 1180")
    3a53230e1c4b ("drm/ast: Make ast_primary_plane_helper_atomic_update static")
    fa7dbd768884 ("drm/ast: Upcast from DRM device to ast structure via to_ast_private()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
