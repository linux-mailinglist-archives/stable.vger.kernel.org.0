Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E442817D091
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 00:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCGXUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 18:20:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgCGXUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Mar 2020 18:20:32 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A51D2075E;
        Sat,  7 Mar 2020 23:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583623231;
        bh=2e9Uk9Ox7nQ3Ma8w5WA1dA9eAaWApX+Q35PkLEOPDbo=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=LId5YY7p03uuE/FdbMWyh4TL6WyEZUVWyqQ63yaT0AXJnTSE4ulUeigQvG5b+LtJd
         JNv6yl7Pz1Tr/uDUAL0e1DNa+WHAebRHSOAsx9TTPsm6b68oAfSpU3Fusu8ctREpqs
         1DjaWEXmNVVBwaqKCNXsNnxvmdnQN7JiN+2GScHc=
Date:   Sat, 07 Mar 2020 23:20:30 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     mika.kuoppala@linux.intel.com, tvrtko.ursulin@intel.com
Cc:     Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc:     Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 02/17] drm/i915/execlists: Enable timeslice on partial virtual engine dequeue
In-Reply-To: <20200306133852.3420322-2-chris@chris-wilson.co.uk>
References: <20200306133852.3420322-2-chris@chris-wilson.co.uk>
Message-Id: <20200307232031.8A51D2075E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 8ee36e048c98 ("drm/i915/execlists: Minimalistic timeslicing").

The bot has tested the following trees: v5.5.8, v5.4.24.

v5.5.8: Build OK!
v5.4.24: Failed to apply! Possible dependencies:
    16ffe73c186b ("drm/i915/pmu: Use GT parked for estimating RC6 while asleep")
    253a774bb08b ("drm/i915/execlists: Don't merely skip submission if maybe timeslicing")
    3c00660db183 ("drm/i915/execlists: Assert tasklet is locked for process_csb()")
    42014f69bb23 ("drm/i915: Hook up GT power management")
    5d904e3c5d40 ("drm/i915: Pass in intel_gt at some for_each_engine sites")
    61fa60ff6e6a ("drm/i915: Move GT init to intel_gt.c")
    c113236718e8 ("drm/i915: Extract GT render sleep (rc6) management")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
