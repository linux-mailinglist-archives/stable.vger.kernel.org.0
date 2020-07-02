Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A43212F10
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 23:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgGBVvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 17:51:09 -0400
Received: from 18.mo3.mail-out.ovh.net ([87.98.172.162]:54477 "EHLO
        18.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGBVvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 17:51:08 -0400
Received: from player737.ha.ovh.net (unknown [10.110.115.149])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id B33EF25ADE2
        for <stable@vger.kernel.org>; Thu,  2 Jul 2020 23:15:18 +0200 (CEST)
Received: from etezian.org (213-243-141-64.bb.dnainternet.fi [213.243.141.64])
        (Authenticated sender: andi@etezian.org)
        by player737.ha.ovh.net (Postfix) with ESMTPSA id EF439A89D2D4;
        Thu,  2 Jul 2020 21:15:15 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-106R006d9394081-6ce4-426a-9017-d6615d2d9935,FB3D8E5C650F7CFAB96446367E683FB3BA96C23C) smtp.auth=andi@etezian.org
Date:   Fri, 3 Jul 2020 00:15:14 +0300
From:   Andi Shyti <andi@etezian.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Also drop vm.ref along error paths
 for vma construction
Message-ID: <20200702211514.GC1969@jack.zhora.eu>
References: <20200702211015.29604-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702211015.29604-1-chris@chris-wilson.co.uk>
X-Ovh-Tracer-Id: 5649202785312162313
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduiedrtdeggdduheegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhguihcuufhhhihtihcuoegrnhguihesvghtvgiiihgrnhdrohhrgheqnecuggftrfgrthhtvghrnheptdfgudduhfefueeujeefieehtdeftefggeevhefgueellefhudetgeeikeduieefnecukfhppedtrddtrddtrddtpddvudefrddvgeefrddugedurdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejfeejrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheprghnughisegvthgviihirghnrdhorhhgpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Chris,

On Thu, Jul 02, 2020 at 10:10:15PM +0100, Chris Wilson wrote:
> Not only do we need to release the vm.ref we acquired for the vma on the
> duplicate insert branch, but also for the normal error paths, so roll
> them all into one.
> 
> Reported-by: Andi Shyti <andi.shyti@intel.com>
> Suggested-by: Andi Shyti <andi.shyti@intel.com>
> Fixes: 2850748ef876 ("drm/i915: Pull i915_vma_pin under the vm->mutex")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Andi Shyti <andi.shyti@intel.com>
> Cc: <stable@vger.kernel.org> # v5.5+

I've never been mentioned this much before, not even at school.
But that's not enough and I'll give myself another mention:

Reviewed-by: Andi Shyti <andi.shyti@intel.com>

Andi
