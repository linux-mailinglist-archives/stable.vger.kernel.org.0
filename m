Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81FF24A509
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 19:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgHSRhA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 19 Aug 2020 13:37:00 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:63705 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726703AbgHSRg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 13:36:58 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22177012-1500050 
        for multiple; Wed, 19 Aug 2020 18:36:48 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200819172331.GA4796@amd>
References: <20200819103952.19083-1-chris@chris-wilson.co.uk> <20200819172331.GA4796@amd>
Subject: Re: [PATCH 1/2] drm/i915/gem: Replace reloc chain with terminator on error unwind
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
To:     Pavel Machek <pavel@ucw.cz>
Date:   Wed, 19 Aug 2020 18:36:50 +0100
Message-ID: <159785861047.667.10730572472834322633@build.alporthouse.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Pavel Machek (2020-08-19 18:23:31)
> Hi!
> 
> > If we hit an error during construction of the reloc chain, we need to
> > replace the chain into the next batch with the terminator so that upon
> > flushing the relocations so far, we do not execute a hanging batch.
> 
> Thanks for the patches. I assume this should fix problem from
> "5.9-rc1: graphics regression moved from -next to mainline" thread.
> 
> I have applied them over current -next, and my machine seems to be
> working so far (but uptime is less than 30 minutes).
> 
> If the machine still works tommorow, I'll assume problem is solved.

Aye, best wait until we have to start competing with Chromium for
memory... The suspicion is that it was the resource allocation failure
path.
-Chris
