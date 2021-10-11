Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410D5428E75
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbhJKNqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233144AbhJKNqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:46:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED16560E8B;
        Mon, 11 Oct 2021 13:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633959887;
        bh=agOywIb9aX8k3b55nl5aiCjBMrVgHxyoD/oZ32pw97A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CpepD43OnreIyuUNdYXrhc/pBDQbGtGLZ7JOhNJYl2JBDLmjSKeRHPNM4x3NnNXdi
         EhdhwangxgJWqOFkPKPyWDKwW4FXCqbySQGU37IR3FOmkLOYu8pvySPm8grDlwnY9p
         E72SWb4wZ8Yw3pFKUyxpptTiTa5+bskvkjvo8Hs8=
Date:   Mon, 11 Oct 2021 15:43:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     John Garry <john.garry@huawei.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: pmu-events/jevents.c:1188:9: warning: implicit declaration of
 function 'free_sys_event_tables' [-Wimplicit-function-declaration]
Message-ID: <YWQ/mZMqAKNJT32l@kroah.com>
References: <CA+G9fYvfWNnBEpgzSQrh8AocmJVcTRtRT3uhJCG__js7aEWwjg@mail.gmail.com>
 <3385c786-625c-6d4d-cf2e-09b0422e9fef@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3385c786-625c-6d4d-cf2e-09b0422e9fef@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 01:48:44PM +0100, John Garry wrote:
> On 11/10/2021 13:17, Naresh Kamboju wrote:
> > stable-rc 5.10 perf build failed due to these warnings  / errors.
> > 
> 
> It seems that the Fixes tag was incorrect for commit b94729919db2 ("perf
> jevents: Fix sys_event_tables to be freed like arch_std_events").
> 
> It should really have fixed 4689f56796f8, not e9d32c1bf0cd7a98.

Thanks for the info, now dropped.

greg k-h
