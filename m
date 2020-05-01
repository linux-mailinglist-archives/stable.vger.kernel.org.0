Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABDC1C0C5D
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 04:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgEACz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 22:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgEACz1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 22:55:27 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5462721775;
        Fri,  1 May 2020 02:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588301727;
        bh=rtxLTLaAVwNzQf+fMXmwlP8FIq4ep4XneNxZVzT4GaM=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=yZCeJEFZepLOlIqwoMzPPfRioJluWSNw0Rb1F/VFMUo9Rg9g4ckW8MLVmLpUN007u
         74iFCFXgUST7J3SVCgERw1N1HQK3o6JqmXjmuMQlbiU1Uo24t9ozDSHB65C/9UlW90
         Jjck7R1pOarfDrD1pMDW53BWvj4ojk35VSeNpbfs=
Date:   Fri, 01 May 2020 02:55:26 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/execlists: Avoid reusing the same logical CC_ID
In-Reply-To: <20200427174122.13415-1-chris@chris-wilson.co.uk>
References: <20200427174122.13415-1-chris@chris-wilson.co.uk>
Message-Id: <20200501025527.5462721775@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 2935ed5339c4 ("drm/i915: Remove logical HW ID").

The bot has tested the following trees: v5.6.7.

v5.6.7: Failed to apply! Possible dependencies:
    03d0ed8a8e93 ("drm/i915: Skip capturing errors from internal contexts")
    1883a0a4658e ("drm/i915: Track hw reported context runtime")
    6f280b133dc2 ("drm/i915/perf: Fix OA context id overlap with idle context id")
    70a76a9b8e9d ("drm/i915/gt: Hook up CS_MASTER_ERROR_INTERRUPT")
    ff3d4ff6c9e6 ("drm/i915/gt: Tidy repetition in declaring gen8+ interrupts")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
