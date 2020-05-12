Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DD11CF2E4
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 12:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbgELKwC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 12 May 2020 06:52:02 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:54379 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729247AbgELKwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 06:52:02 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 21171647-1500050 
        for multiple; Tue, 12 May 2020 11:51:24 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <87lflx309o.fsf@gaia.fi.intel.com>
References: <20200509115217.26853-1-chris@chris-wilson.co.uk> <87lflx309o.fsf@gaia.fi.intel.com>
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Watch out for idling during i915_gem_evict_something
To:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Message-ID: <158928068371.21674.17585538612679770949@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Tue, 12 May 2020 11:51:23 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Mika Kuoppala (2020-05-12 11:39:31)
> Chris Wilson <chris@chris-wilson.co.uk> writes:
> 
> > i915_gem_evict_something() is charged with finding a slot within the GTT
> > that we may reuse. Since our goal is not to stall, we first look for a
> > slot that only overlaps idle vma. To this end, on the first pass we move
> > any active vma to the end of the search list. However, we only stopped
> > moving active vma after we see the first active vma twice. If during the
> > search, that first active vma completed, we would not notice and keep on
> > extending the search list.
> >
> > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1746
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> > Cc: <stable@vger.kernel.org> # v5.5+
> 
> Only thing I would change is tune up the subject line.
> It fixes a possible busy loop in eviction so I feel 'watch out' is not
> strong enough for my liking.

Duck and cover for the idling is a-coming!
-Chris
