Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED08514CB9B
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 14:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgA2Nme convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 29 Jan 2020 08:42:34 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:54911 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726069AbgA2Nme (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 08:42:34 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20047986-1500050 
        for multiple; Wed, 29 Jan 2020 13:42:26 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20200129133912.810-1-mika.kuoppala@linux.intel.com>
Cc:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Stable <stable@vger.kernel.org>
References: <20200129133912.810-1-mika.kuoppala@linux.intel.com>
Message-ID: <158030534546.11197.11834221479926714378@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [PATCH] drm/i915: Park faster to alleviate kept forcewake
Date:   Wed, 29 Jan 2020 13:42:25 +0000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Mika Kuoppala (2020-01-29 13:39:12)
> To avoid context corruption on some gens, we need to hold forcewake
> for long periods of time. This leads to increased energy expenditure
> for mostly idle workloads.
> 
> To combat the increased power consumption, park GPU more hastily.
> 
> As the HW isn't so quick to end up in rc6, this software mechanism
> supplements it. So we can apply it, across all gens.
> 
> Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
> Testcase: igt/i915_pm_rc6_residency/rc6-idle
> References: "Add RC6 CTX corruption WA"
> Cc: Stable <stable@vger.kernel.org>    # v4.19+
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Signed-off-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

Seems to work and play nice with the older style of locking,
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris
