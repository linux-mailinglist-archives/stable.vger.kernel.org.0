Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC101C7E13
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 01:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgEFXmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 19:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728237AbgEFXmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 19:42:16 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56CD520746;
        Wed,  6 May 2020 23:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588808536;
        bh=CrL0vY8NzNe+Jnr1Alkh1Cnhdd78xGVrP+CFWalWXyo=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=ddydAYBsduwGjeUcHL4xDkyQ580G+g2s4yZ2xCKMa7cR92E1yV1772Ql6zXWnvZJf
         BbSwi5arayt+i9jYovmeJMUCoH67bu6cep4RJbaz0+ZIpkCDFgezaIYu9SdTEo7iCZ
         P+c0REtDVpCe1pQPeL9LByKhKJ4CKWvwRc+tM6a4=
Date:   Wed, 06 May 2020 23:42:15 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     tvrtko.ursulin@intel.com, lionel.g.landwerlin@intel.com
Cc:     Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/6] drm/i915: Mark concurrent submissions with a weak-dependency
In-Reply-To: <20200504135030.19210-2-chris@chris-wilson.co.uk>
References: <20200504135030.19210-2-chris@chris-wilson.co.uk>
Message-Id: <20200506234216.56CD520746@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: c81471f5e95c ("drm/i915: Copy across scheduler behaviour flags across submit fences").

The bot has tested the following trees: v5.6.10.

v5.6.10: Failed to apply! Possible dependencies:
    8e9f84cf5cac ("drm/i915/gt: Propagate change in error status to children on unhold")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
