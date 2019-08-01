Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE0C77E404
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 22:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfHAUWA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 1 Aug 2019 16:22:00 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:49597 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725790AbfHAUWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 16:22:00 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 17798335-1500050 
        for multiple; Thu, 01 Aug 2019 21:21:57 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     "Kumar Valsan, Prathap" <prathap.kumar.valsan@intel.com>
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20190801203344.GY3842@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
References: <20190730112151.5633-1-chris@chris-wilson.co.uk>
 <20190730112151.5633-4-chris@chris-wilson.co.uk>
 <20190801203344.GY3842@intel.com>
Message-ID: <156469091549.12570.8633612310154953207@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [Intel-gfx] [PATCH 3/3] drm/i915: Flush extra hard after writing
 relocations through the GTT
Date:   Thu, 01 Aug 2019 21:21:55 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Kumar Valsan, Prathap (2019-08-01 21:33:44)
> On Tue, Jul 30, 2019 at 12:21:51PM +0100, Chris Wilson wrote:
> > Recently discovered in commit bdae33b8b82b ("drm/i915: Use maximum write
> > flush for pwrite_gtt") was that we needed to our full write barrier
> > before changing the GGTT PTE to ensure that our indirect writes through
> > the GTT landed before the PTE changed (and the writes end up in a
> > different page). That also applies to our GGTT relocation path.
> 
> Chris,
> 
> As i understand, changing the GGTT PTE also an indirect write. If so, isn't a wmb()
> should be good enough.

Ha! If only that was true.
-Chris
