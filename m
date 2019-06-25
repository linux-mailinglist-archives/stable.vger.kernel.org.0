Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D50265292C
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 12:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbfFYKNe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 25 Jun 2019 06:13:34 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:58552 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727763AbfFYKNe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 06:13:34 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 17015900-1500050 
        for multiple; Tue, 25 Jun 2019 11:13:34 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <87ef3i572x.fsf@gaia.fi.intel.com>
Cc:     Kenneth Graunke <kenneth@whitecape.org>, stable@vger.kernel.org
References: <20190625070829.25277-1-kenneth@whitecape.org>
 <20190625090655.19220-1-chris@chris-wilson.co.uk>
 <87ef3i572x.fsf@gaia.fi.intel.com>
Message-ID: <156145760989.2637.9780027070420704421@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Disable SAMPLER_STATE prefetching on all
 Gen11 steppings.
Date:   Tue, 25 Jun 2019 11:13:29 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Mika Kuoppala (2019-06-25 10:48:22)
> Chris Wilson <chris@chris-wilson.co.uk> writes:
> 
> > From: Kenneth Graunke <kenneth@whitecape.org>
> >
> > The Demand Prefetch workaround (binding table prefetching) only applies
> > to Icelake A0/B0.  But the Sampler Prefetch workaround needs to be
> > applied to all Gen11 steppings, according to a programming note in the
> > SARCHKMD documentation.
> >
> > Using the Intel Gallium driver, I have seen intermittent failures in
> > the dEQP-GLES31.functional.copy_image.non_compressed.* tests.  After
> > applying this workaround, the tests reliably pass.
> >
> > v2: Remove the overlap with a pre-production w/a
> >
> > BSpec: 9663
> > Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: stable@vger.kernel.org
> 
> Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

And pushed. Thanks for the patch!
-Chris
