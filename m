Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B9455E7C4
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 18:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345229AbiF1OIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 10:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiF1OIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 10:08:52 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6B03466B;
        Tue, 28 Jun 2022 07:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656425331; x=1687961331;
  h=date:from:to:cc:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding:resent-date:
   resent-from:subject:resent-message-id:resent-to;
  bh=NlN93CPLmTbVnxPPhc+BVfuBiZgxZ+dnkYTe/LYS/gQ=;
  b=GQFp4GSMz9aZsJu51arHOXiSc917AQpi6WBE1e4nVvydAmiIMOBLm7hm
   1ObneK1tIPaJfOu630qcEi9ksKWUh7Ggel96xi4mLHBYh3l7LiNTJ6+qk
   km1qo9fL1RsgNVQf3kZuHv+DRl5N3gl+tR1O1/ZdatZs68AyKL7/e66Fj
   np2DYK12fXqB0yL6BaWGcHDpmgBkB/HPqe5RzB15ADRjgxyljoVWiECn9
   K3yL05MtXyhsEq4bFZfU5zGgczqM5DFZN9NCTXIcm0R6AJ2Gm66wIOAFm
   /oaVwwfjXm9PPxNop6OIwI+ORH2G7JteqsrJnS2snbV+Dp+F8Dqhps2pp
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="307233331"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="307233331"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 07:08:51 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="594809580"
Received: from maurocar-mobl2.ger.corp.intel.com (HELO maurocar-mobl2) ([10.252.40.41])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 07:08:44 -0700
Date:   Mon, 27 Jun 2022 11:00:56 +0200
From:   Mauro Carvalho Chehab <mauro.chehab@linux.intel.com> (by way of
        Mauro Carvalho Chehab <mauro.chehab@linux.intel.com>)
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc:     Andi Shyti <andi.shyti@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Thomas Hellstrom <thomas.hellstrom@intel.com>,
        Bruce Chang <yu.bruce.chang@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        stable@vger.kernel.org,
        Thomas =?UTF-8?B?SGVs?= =?UTF-8?B?bHN0csO2bQ==?= 
        <thomas.hellstrom@linux.intel.com>
Message-ID: <20220627110056.6dfa4f9b@maurocar-mobl2>
In-Reply-To: <160e613f-a0a8-18ff-5d4b-249d4280caa8@linux.intel.com>
References: <cover.1655306128.git.mchehab@kernel.org>
 <5ee647f243a774927ec328bfca8212abc4957909.1655306128.git.mchehab@kernel.org>
 <YrRLyg1IJoZpVGfg@intel.intel>
 <160e613f-a0a8-18ff-5d4b-249d4280caa8@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 5/6] drm/i915/gt: Serialize GRDOM access between
 multiple engine resets
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tvrtko,

On Fri, 24 Jun 2022 09:34:21 +0100
Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:

> On 23/06/2022 12:17, Andi Shyti wrote:
> > Hi Mauro,
> >=20
> > On Wed, Jun 15, 2022 at 04:27:39PM +0100, Mauro Carvalho Chehab wrote: =
=20
> >> From: Chris Wilson <chris.p.wilson@intel.com>
> >>
> >> Don't allow two engines to be reset in parallel, as they would both
> >> try to select a reset bit (and send requests to common registers)
> >> and wait on that register, at the same time. Serialize control of
> >> the reset requests/acks using the uncore->lock, which will also ensure
> >> that no other GT state changes at the same time as the actual reset.
> >>
> >> Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing st=
ore")
> >>
> >> Reported-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> >> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> >> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> >> Cc: Andi Shyti <andi.shyti@intel.com>
> >> Cc: stable@vger.kernel.org
> >> Acked-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org> =20
> >=20
> > Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com> =20
>=20
> Notice I had a bunch of questions and asks in this series so please do=20
> not merge until those are addressed.
>=20
> In this particular patch (and some others) for instance Fixes: tag, at=20
> least against that sha, shouldn't be there.

Hmm... I sent an answer to your points, but I can't see it at:

	https://lore.kernel.org/all/160e613f-a0a8-18ff-5d4b-249d4280caa8@linux.int=
el.com/

Maybe it got lost somewhere, I dunno.

Yeah, indeed the fixes tag on patch 5/6 should be removed as this is not
directly related to changeset 7938d61591d3. Yet, this one is required for
patch 6 to work.

The other patches on this series, though, are modifying the code=20
introduced by changeset 7938d61591d3.

Patch 2 is clearly a workaround needed for TLB cache invalidation to
work on some GPUs. So, while not related to Broadwell, they're also
fixing some TLB cache issues. So, IMO, it should keep the fixes.

I tried to port just the two serialize patches to drm-tip, in order
to solve the issues on Broadwell, but it didn't work, as the logic=20
inside the spinlock could be calling schedule() with a spinlock hold:
=20
	Jun 14 17:38:48 silver kernel: [   23.227813] BUG: sleeping function calle=
d from invalid context at drivers/gpu/drm/i915/intel_uncore.c:2496
	Jun 14 17:38:48 silver kernel: [   23.227816] in_atomic(): 1, irqs_disable=
d(): 1, non_block: 0, pid: 37, name: kworker/u8:1
	Jun 14 17:38:48 silver kernel: [   23.227818] preempt_count: 1, expected: 0
	Jun 14 17:38:48 silver kernel: [   23.227819] RCU nest depth: 0, expected:=
 0
	Jun 14 17:38:48 silver kernel: [   23.227820] 5 locks held by kworker/u8:1=
/37:
	Jun 14 17:38:48 silver kernel: [   23.227822]  #0: ffff88811159b538 ((wq_c=
ompletion)i915){+.+.}-{0:0}, at: process_one_work+0x1e0/0x580
	Jun 14 17:38:48 silver kernel: [   23.227831]  #1: ffffc90000183e60 ((work=
_completion)(&(&i915->mm.free_work)->work)){+.+.}-{0:0}, at: process_one_wo=
rk+0x1e0/0x580
	Jun 14 17:38:48 silver kernel: [   23.227837]  #2: ffff88811b34c5e8 (reser=
vation_ww_class_mutex){+.+.}-{3:3}, at: __i915_gem_free_objects+0xba/0x210 =
[i915]
	Jun 14 17:38:48 silver kernel: [   23.228283]  #3: ffff88810a66c2d8 (&gt->=
tlb_invalidate_lock){+.+.}-{3:3}, at: intel_gt_invalidate_tlbs+0xe7/0x4d0 [=
i915]
	Jun 14 17:38:48 silver kernel: [   23.228663]  #4: ffff88810a668f28 (&unco=
re->lock){-.-.}-{2:2}, at: intel_gt_invalidate_tlbs+0x115/0x4d0 [i915]

I didn't investigate the root cause, but it seems related to PM, so=20
patches 1 and 3 seem to be required for the serialization logic
to actually work.

So, I would keep the Fixes: tag mentioning changeset 7938d61591d3
on patches: 1, 2, 3 and 6.

Yet, IMO the entire series should be merged on -stable.

If that's OK for you and there's no additional issues to be
addressed, I'll submit a v2 of this series removing the Fixes tag
from patches 4 and 5.

Regards,
Mauro
