Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF447487D
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 09:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388585AbfGYHyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 03:54:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55522 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388335AbfGYHyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 03:54:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mfL8H17mom9d7I+zISHocyesDcn8O+d6gD5bGECM2cI=; b=Wd/WGOBUlkdqmsCZIK83YGRH+
        9t4Ko7NctEsCihrMcKkz+hifwZctFmmLsAK8NJHb002+vptCcizVP7J7icFNwlRr4Sv9yUmspLjzg
        HsZtHukOSIgTbH+kdV/N7dp9OWorCNS+AEkv7UNUSnuLGqlLwOs8b3/35gWG3KMps8mGKyZMO24cZ
        /57p0LTQYLr/mlgi1QGJ1FTTuQYimJ8dqJwQwV4UuxL2isNhHEk/hhmLKf5yBliYfmdP5rzvRoZ3R
        rTOxcj5c9Ny+jZAqfJ251K/jX9QpTFZk2Y+5TAK4llQNYRjITuf0nX8ccKNRnyxLadoA7GzUrAweg
        MJatFIbAA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hqYaS-0002ef-4C; Thu, 25 Jul 2019 07:54:52 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8B360201D171E; Thu, 25 Jul 2019 09:54:50 +0200 (CEST)
Date:   Thu, 25 Jul 2019 09:54:50 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     kan.liang@linux.intel.com
Cc:     mingo@kernel.org, linux-kernel@vger.kernel.org, ak@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] perf/x86/intel: Fix SLOTS pebs event constraint
Message-ID: <20190725075450.GH31381@hirez.programming.kicks-ass.net>
References: <20190723200429.8180-1-kan.liang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723200429.8180-1-kan.liang@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 23, 2019 at 01:04:29PM -0700, kan.liang@linux.intel.com wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> Sampling SLOTS event and ref-cycles event in a group on Icelake gives
> EINVAL.
> 
> SLOTS event is the event stands for the fixed counter 3, not fixed
> counter 2. Wrong mask was set to SLOTS event in
> intel_icl_pebs_event_constraints[].
> 
> Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
> Reported-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>

Thanks!
