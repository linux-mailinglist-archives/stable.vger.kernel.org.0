Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1A2417A0B
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 19:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344465AbhIXRxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 13:53:15 -0400
Received: from mga05.intel.com ([192.55.52.43]:17413 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344431AbhIXRxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 13:53:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10117"; a="309685369"
X-IronPort-AV: E=Sophos;i="5.85,320,1624345200"; 
   d="scan'208";a="309685369"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2021 10:51:42 -0700
X-IronPort-AV: E=Sophos;i="5.85,320,1624345200"; 
   d="scan'208";a="535809104"
Received: from wchriste-mobl1.amr.corp.intel.com ([10.251.2.203])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2021 10:51:41 -0700
Message-ID: <9d1eb69d6b498856e193f86b117665c868425d17.camel@linux.intel.com>
Subject: Re: [PATCH v2 1/2] thermal: int340x: do not set a wrong tcc offset
 on resume
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Antoine Tenart <atenart@kernel.org>, rui.zhang@intel.com,
        amitk@kernel.org
Cc:     linux-pm@vger.kernel.org, stable@vger.kernel.org
Date:   Fri, 24 Sep 2021 10:51:35 -0700
In-Reply-To: <03ba2e41-6ae6-d4ee-ace5-055ac40c1128@linaro.org>
References: <20210909085613.5577-1-atenart@kernel.org>
         <20210909085613.5577-2-atenart@kernel.org>
         <46d6d30201e11422f57bd79691133dc0491bd4c5.camel@linux.intel.com>
         <03ba2e41-6ae6-d4ee-ace5-055ac40c1128@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-09-24 at 19:40 +0200, Daniel Lezcano wrote:
> On 24/09/2021 18:27, Srinivas Pandruvada wrote:
> > Hi Daniel,
> > 
> > This patch is important. Can we send for 5.15 rc release?
> > 
> > I see the previous version of this patch is applied to linux-next.
> > But this series is better as it splits into two patches. The first
> > one
> > can be easily backported and will fix the problem. The second one
> > is an
> > improvement.
> 
> Yes, it is in the pipe.
> 
> I've applied the patch 1/2 to the fixes branch and the patch 2/2 will
> land in the next branch as soon as the next -rc is released with the
> fix
> and merged to the next branch.

Thanks Daniel.

-Srinivas

> 
> 


