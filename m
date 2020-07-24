Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F54A22C498
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 13:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgGXL4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 07:56:10 -0400
Received: from mga03.intel.com ([134.134.136.65]:11727 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbgGXL4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jul 2020 07:56:10 -0400
IronPort-SDR: LoBl6VTnkrDB9V0L4TI+cmGt3UFXK/oGCG9SfgVfZfPNGkbpsG9tqCVSihlM0PLOTkeiA4v3uS
 KbWCug0ICsjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="150681516"
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="150681516"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2020 04:56:09 -0700
IronPort-SDR: 5cR1ncTT32iRwPUdvGxPk7qiuG/pFN6t9JCqd13HbOAC7qzXgjRzNYZVLtgiHxN2zm8mWCfmyA
 fM0UbwBsmbqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="489183348"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by fmsmga005.fm.intel.com with ESMTP; 24 Jul 2020 04:56:08 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id 1FB035C0D00; Fri, 24 Jul 2020 14:55:39 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gem: Delay tracking the GEM context until it is registered
In-Reply-To: <159552931718.21069.13813749151778428706@build.alporthouse.com>
References: <20200723183348.4037-1-chris@chris-wilson.co.uk> <159552931718.21069.13813749151778428706@build.alporthouse.com>
Date:   Fri, 24 Jul 2020 14:55:39 +0300
Message-ID: <87tuxx1610.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> Quoting Chris Wilson (2020-07-23 19:33:48)
>> Avoid exposing a partially constructed context by deferring the
>> list_add() from the initial construction to the end of registration.
>> Otherwise, if we peek into the list of contexts from inside debugfs, we
>> may see the partially constructed context and change down some dangling
>
> s/change/chase/

that.

Are you sure about the fixes as it is not the commit that
actually introduces the registration into context.list?

For me it looks like it is a4e7ccdac38e.
-Mika

>
>> incomplete pointers.
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
