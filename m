Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06AF439D6CA
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 10:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhFGILf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 04:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhFGILe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 04:11:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A78C611C0;
        Mon,  7 Jun 2021 08:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623053383;
        bh=IYKAx2B81okjOY0O0QA82BXe1awSC5hEZnI521mFVPo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Na3e0o88/eteAdkCW+MGWBX7soUcuWNtX6sCbcKA3M2Bbz0pvWpJMSWYfaR1NqKU9
         Wz3eG7K+lKo1zC/83Mmn1pAqtXB/QV1n94Jxvl95WjRchAfPc7lgo8XQ2yRxNNHXPL
         JNZkTx18zErptV1nQ1QsCDIqwSgDuycqAOfuyO0o=
Date:   Mon, 7 Jun 2021 10:09:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wen Yang <wenyang@linux.alibaba.com>
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
Subject: Re: [PATCH 4.20 1/2] perf/cgroups: Don't rotate events for cgroups
 unnecessarily
Message-ID: <YL3URDqVmdIP9647@kroah.com>
References: <20210607080017.8894-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607080017.8894-1-wenyang@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 07, 2021 at 04:00:16PM +0800, Wen Yang wrote:
> From: Ian Rogers <irogers@google.com>
> 
> [ Upstream commit fd7d55172d1e2e501e6da0a5c1de25f06612dc2e ]

<snip>

If you look at the releases page of kernel.org, you will see the active
kernels (also the front page of kernel.org shows this).

So why are you sending patches for kernels that are long long
end-of-life?  Who is going to use these patches, and for what trees?

thanks,

greg k-h
