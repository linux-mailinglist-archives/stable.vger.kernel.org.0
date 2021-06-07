Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D738339D6EB
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 10:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhFGITM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 04:19:12 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:60735 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhFGITM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 04:19:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0UbZRCfR_1623053837;
Received: from IT-C02W23QPG8WN.local(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UbZRCfR_1623053837)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Jun 2021 16:17:18 +0800
Subject: Re: [PATCH 4.20 1/2] perf/cgroups: Don't rotate events for cgroups
 unnecessarily
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>
References: <20210607080017.8894-1-wenyang@linux.alibaba.com>
 <YL3URDqVmdIP9647@kroah.com>
From:   Wen Yang <wenyang@linux.alibaba.com>
Message-ID: <08a4df69-b37b-832d-26ae-88d6a06e4772@linux.alibaba.com>
Date:   Mon, 7 Jun 2021 16:17:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YL3URDqVmdIP9647@kroah.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



ÔÚ 2021/6/7 ÏÂÎç4:09, Greg Kroah-Hartman Ð´µÀ:
> On Mon, Jun 07, 2021 at 04:00:16PM +0800, Wen Yang wrote:
>> From: Ian Rogers <irogers@google.com>
>>
>> [ Upstream commit fd7d55172d1e2e501e6da0a5c1de25f06612dc2e ]
> 
> <snip>
> 
> If you look at the releases page of kernel.org, you will see the active
> kernels (also the front page of kernel.org shows this).
> 
> So why are you sending patches for kernels that are long long
> end-of-life?  Who is going to use these patches, and for what trees?
> 
> thanks,
> 
> greg k-h
> 

Okay, thank you for your reminder.
The 4.19 kernel is used in our environment (it is also active). This bug 
exists in versions from 4.19 to 5.2, but in fact it only needs to be 
fixed on 4.19, thanks

--
Best wishes,
Wen
