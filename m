Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6738F2530AB
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730455AbgHZNzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730453AbgHZNx7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:53:59 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4D4C22B4B;
        Wed, 26 Aug 2020 13:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598450039;
        bh=K5QLd/X1fnK2BhaLCj1T0f0LtdugxVd+h+B5AjNrEw4=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:
         Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=d9t+9O/5L1pVr1cn+LCeNjQnxckoIX4KWNn9hhvwRA9015CapL+hwvn8aRci0zkC7
         9eRPuvnVVzxHNSdsjyrcW0BFEOemmwwv99edARWoGrSC4cIH7Z3eZ+nNIqiKAK4KbV
         3lAt67YzGUbOvaFIcGgkbj5NwbXMV4oSg/XtdACs=
Date:   Wed, 26 Aug 2020 13:53:58 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Kim Phillips <kim.phillips@amd.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Stephane Eranian <eranian@google.com>
Cc:     Stephane Eranian <eranian@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>
Cc:     Ingo Molnar <mingo@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Borislav Petkov <bp@alien8.de>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Jiri Olsa <jolsa@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>
Cc:     Michael Petlan <mpetlan@redhat.com>
Cc:     Namhyung Kim <namhyung@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86 <x86@kernel.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/7 RESEND] perf/amd/uncore: Set all slices and threads to restore perf stat -a behaviour
In-Reply-To: <20200817220628.7604-1-kim.phillips@amd.com>
References: <20200817220628.7604-1-kim.phillips@amd.com>
Message-Id: <20200826135358.C4D4C22B4B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 2f217d58a8a0 ("perf/x86/amd/uncore: Set the thread mask for F17h L3 PMCs").

The bot has tested the following trees: v5.8.2, v5.7.16, v5.4.59, v4.19.140, v4.14.193.

v5.8.2: Build OK!
v5.7.16: Build OK!
v5.4.59: Failed to apply! Possible dependencies:
    4dcc3df82573 ("perf/amd/uncore: Prepare L3 thread mask code for Family 19h")
    9689dbbeaea8 ("perf/amd/uncore: Make L3 thread mask code more readable")
    e48667b86548 ("perf/amd/uncore: Add support for Family 19h L3 PMU")

v4.19.140: Failed to apply! Possible dependencies:
    4dcc3df82573 ("perf/amd/uncore: Prepare L3 thread mask code for Family 19h")
    6d0ef316b9f8 ("x86/events: Add Hygon Dhyana support to PMU infrastructure")
    9689dbbeaea8 ("perf/amd/uncore: Make L3 thread mask code more readable")
    e48667b86548 ("perf/amd/uncore: Add support for Family 19h L3 PMU")

v4.14.193: Failed to apply! Possible dependencies:
    4dcc3df82573 ("perf/amd/uncore: Prepare L3 thread mask code for Family 19h")
    6d0ef316b9f8 ("x86/events: Add Hygon Dhyana support to PMU infrastructure")
    9689dbbeaea8 ("perf/amd/uncore: Make L3 thread mask code more readable")
    e48667b86548 ("perf/amd/uncore: Add support for Family 19h L3 PMU")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
