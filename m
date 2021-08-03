Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78D33DF440
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 20:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbhHCSAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 14:00:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:36888 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238536AbhHCSAU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 14:00:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="200937981"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="200937981"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 11:00:08 -0700
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="419129393"
Received: from akleen-mobl1.amr.corp.intel.com (HELO [10.209.96.93]) ([10.209.96.93])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 11:00:08 -0700
Subject: Re: [PATCH V2] perf/x86/intel: Apply mid ACK for small core
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     mingo@redhat.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1627997128-57891-1-git-send-email-kan.liang@linux.intel.com>
 <YQlY2o62E5A9xcdq@hirez.programming.kicks-ass.net>
 <9b0cb4ec-e8b8-3739-7b8d-e1c05785023a@linux.intel.com>
 <YQlsIvh7vwLt3f6g@hirez.programming.kicks-ass.net>
 <20f884f0-bf32-a8a0-1636-674d1b3a4715@linux.intel.com>
From:   Andi Kleen <ak@linux.intel.com>
Message-ID: <7bc98060-f22a-27f8-1bbb-bceda58319a7@linux.intel.com>
Date:   Tue, 3 Aug 2021 11:00:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20f884f0-bf32-a8a0-1636-674d1b3a4715@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>> Any chance that would also work for the chips that now use late_ack?
>>
>
> Let me check and do some tests.


I suspect we won't be able to test all, so we'll probably have to keep 
all three options.


-Andi


