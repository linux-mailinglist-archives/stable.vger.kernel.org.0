Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D011A3DDFEC
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 21:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhHBTVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 15:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhHBTVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 15:21:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38D6260EE3;
        Mon,  2 Aug 2021 19:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627932096;
        bh=rTzrVO1yW8FhTh4+7+FTN0jF2iI6ZMSnmgfeML3g4k4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GHltwQDfrfFBe/s/3iHzefrNLyb6cmNroTNqTgZ1d2gjSAyvsPrEBf7YaA/wlvrEP
         /e97GwUtGjUJly02UhjslHNmg4P8pRaDPfT9Cd8f4E39qoxHgy1n/T1UKP7kjdJQLZ
         eW4HCpXuQkKIaJm9Mg299u6stdrbz5KbiOjfRqJAsAwBj9Lq73wjZnWnIflvCArAER
         Tr5maaSk1gRf7OQQwd5ZL2t2BH7+gZzflQyj/5FbvQeWewi4k7X1VdsB8gdryz141u
         5UEyvAQw1iwRNr/buEZ2zCPQpy0UCOtPvklYhb5oBk3k/SqLN6ipsDdcIWwgmQXad+
         OZEQOjXaEx2mw==
Date:   Mon, 2 Aug 2021 15:21:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jason Ekstrand <jason@jlekstrand.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 0/2] BACKPORT: drm/i915: Get rid of fence error
 propagation
Message-ID: <YQhFv7PKK84e2XkU@sashalap>
References: <20210802184819.414914-1-jason@jlekstrand.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210802184819.414914-1-jason@jlekstrand.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 01:48:17PM -0500, Jason Ekstrand wrote:
>This is a back-port of the following patches from torvalds/master to 5.13:
>
> - 686c7c35abc2 ("drm/i915/gem: Asynchronous cmdparser")
> - 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
>
>Jason Ekstrand (2):
>  drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"
>  Revert "drm/i915: Propagate errors on awaiting already signaled
>    fences"
>
> .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 227 +-----------------
> .../i915/gem/selftests/i915_gem_execbuffer.c  |   4 +
> drivers/gpu/drm/i915/i915_cmd_parser.c        | 118 +++++----
> drivers/gpu/drm/i915/i915_drv.h               |   7 +-
> drivers/gpu/drm/i915/i915_request.c           |   8 +-
> 5 files changed, 93 insertions(+), 271 deletions(-)

Queued up, thanks!

-- 
Thanks,
Sasha
