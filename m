Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9EB1C0C52
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 04:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgEACzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 22:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727985AbgEACzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 22:55:19 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEED32137B;
        Fri,  1 May 2020 02:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588301719;
        bh=CfnIrlYtAOs7sDyfADJhisKJglxD7RBQjtJiwVgX+2A=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=GH4QRhnmJwa3Sl5ilD5HeCmDzJnIustWP8cJrLHrZwc7wpgPMqx7QkhVXR5fN7AeA
         NuWxDZ5i5oyUYD4/FLLuMA4gYiK4L4VPwTpHG66eD7S/+FbA6hQtEILE8//nWehfM+
         8JC9ySK+QnkguLy2BRAnMgB21Qx/5QI/tXku7k8Q=
Date:   Fri, 01 May 2020 02:55:18 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/i915/execlists: Avoid reusing the same logical CCID
In-Reply-To: <20200428085336.9580-1-chris@chris-wilson.co.uk>
References: <20200428085336.9580-1-chris@chris-wilson.co.uk>
Message-Id: <20200501025518.EEED32137B@mail.kernel.org>
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
    1883a0a4658e ("drm/i915: Track hw reported context runtime")
    35f3fd8182ba ("drm/i915/execlists: Workaround switching back to a completed context")
    489645d522df ("drm/i915/gt: Show the cumulative context runtime in engine debug")
    4c8ed8b12674 ("drm/i915/selftests: Exercise timeslice rewinding")
    4c977837ba29 ("drm/i915/execlists: Peek at the next submission for error interrupts")
    606727842d8b ("drm/i915/gt: Include the execlists CCID of each port in the engine dump")
    61f874d6e001 ("drm/i915/gt: Use scnprintf() for avoiding potential buffer overflow")
    6f280b133dc2 ("drm/i915/perf: Fix OA context id overlap with idle context id")
    70a76a9b8e9d ("drm/i915/gt: Hook up CS_MASTER_ERROR_INTERRUPT")
    8b6d457f9532 ("drm/i915/execlists: Include priority info in trace_ports")
    b4892e440432 ("drm/i915: Make define for lrc state offset")
    b4d3acaa7333 ("drm/i915/gt: Pull sseu context updates under gt")
    c4e8ba739034 ("drm/i915/gt: Yield the timeslice if caught waiting on a user semaphore")
    ff3d4ff6c9e6 ("drm/i915/gt: Tidy repetition in declaring gen8+ interrupts")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
