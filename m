Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF823DDFED
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 21:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhHBTV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 15:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhHBTV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 15:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55067604D7;
        Mon,  2 Aug 2021 19:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627932109;
        bh=En3VS7Jc1Y6NHhNl7fqNOtEa8Hl3+0Wh7AIipLwGn+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oN6CgzM/wVfx3WcHafWoLnZFXmod0WTPeWBMswgKHGlasA5z2Nd0SX1RcBwHHz84T
         DM+vJ664/ZcBjGCCkVzCJSHhoiQaKRID2eDNl6U759Rl3ZXk19GB6fqahOdT9PskEt
         tnIJS7P+R9/Y8HwbfQfU8873wYC+5akCcDiS6ae3SHRwppKu7OxNVa4Y5nbpWcs1N3
         AJ+rqRTOrj3xV4qNYeZy+RLllhQIuHBPYxMaCIh642EKnYRIGaqV4kP3ckUv9RWcMw
         DeVX7JimyKcWVJAeKC7eTMRUXD888XMSSiu26tCmgUfeO1u+FXVRIJ9ncJRr0jBDNw
         5sV9Av9cuAXXQ==
Date:   Mon, 2 Aug 2021 15:21:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jason Ekstrand <jason@jlekstrand.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 0/2] BACKPORT: drm/i915: Get rid of fence error
 propagation
Message-ID: <YQhFzBTglOJMSC1k@sashalap>
References: <20210802184802.414849-1-jason@jlekstrand.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210802184802.414849-1-jason@jlekstrand.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 01:48:00PM -0500, Jason Ekstrand wrote:
>This is a back-port of the following patches from torvalds/master to 5.10:
>
> - 686c7c35abc2 ("drm/i915/gem: Asynchronous cmdparser")
> - 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
>
>Jason Ekstrand (2):
>  drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"
>  Revert "drm/i915: Propagate errors on awaiting already signaled
>    fences"
>
> .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 164 +-----------------
> drivers/gpu/drm/i915/i915_cmd_parser.c        |  28 +--
> drivers/gpu/drm/i915/i915_request.c           |   8 +-
> 3 files changed, 27 insertions(+), 173 deletions(-)

Queued up, thanks!

-- 
Thanks,
Sasha
