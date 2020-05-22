Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398311DDBE7
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 02:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbgEVAMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 20:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730618AbgEVAMh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 20:12:37 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 842A220874;
        Fri, 22 May 2020 00:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590106356;
        bh=C0bLMgpWA8CkohCmOWW8pbkBsJj/HYCvxJjahetdYys=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=zcGd0EnwE2IcI7ohqBCRCdQkO+2iMmaCJ8BVKX9v8X9QJ9B4KrA186ZyoHStlbu80
         mkkXhoGKjuOF83y7wzMFXqR4DIuMOP1e/Sm0jHBDFSpz3LMB5wZYMoAIMe8M85J64z
         +mXFygvdgQVOgmrHiXfanM4mXE9em+YK1ckdWPpk=
Date:   Fri, 22 May 2020 00:12:35 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Martin Fuzzey <martin.fuzzey@flowbird.group>
To:     Lucas Stach <l.stach@pengutronix.de>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] drm/etnaviv: fix memory leak when mapping prime imported buffers
In-Reply-To: <1589969500-6554-1-git-send-email-martin.fuzzey@flowbird.group>
References: <1589969500-6554-1-git-send-email-martin.fuzzey@flowbird.group>
Message-Id: <20200522001236.842A220874@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.13, v5.4.41, v4.19.123, v4.14.180, v4.9.223, v4.4.223.

v5.6.13: Build OK!
v5.4.41: Build OK!
v4.19.123: Build OK!
v4.14.180: Build OK!
v4.9.223: Build OK!
v4.4.223: Failed to apply! Possible dependencies:
    0e7f26e6b950 ("drm/etnaviv: take etnaviv_gem_obj in etnaviv_gem_mmap_obj")
    9f07bb0d4ada ("drm/etnaviv: fix get pages error path in etnaviv_gem_vaddr")
    a0a5ab3e99b8 ("drm/etnaviv: call correct function when trying to vmap a DMABUF")
    a10e2bde5d91 ("drm/etnaviv: fix mmap operations for userptr and dma-buf objects")
    a8c21a5451d8 ("drm/etnaviv: add initial etnaviv DRM driver")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
