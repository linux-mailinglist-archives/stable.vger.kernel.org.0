Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F8C3C6DB8
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 11:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhGMJwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 05:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbhGMJwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 05:52:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A43C0613DD;
        Tue, 13 Jul 2021 02:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DsRs0GWZtjxgV/G+0LfR+smdacS384gtQB/dib23CM0=; b=B7IJS4LyOfpUzyzT/QH90vbIW9
        0n+XQba6i3wYq4xVYxKcBVocZtWn4HIYzAL6myclgAvoQ0dbAM7PlZf07GesiXZA3j2MR5HB/fDuO
        Zk0g2R50qMc1DEfyvBVJd9s+qZ6uoFSqlPSR04HGH0m/FLggHRAQq/csieQCoV32++JtGmpEPxJbW
        x6FsOhBU6WI53Yivyk35MzvyxrqOL+h+7kqOYfz1w0U4LfS58UZ/lYSi8A5ezkDIw3q4uVbuWgptg
        IsS4U7d2YzM8WsLb82REEr/qhO5SOJOJNaoGKe0oZBqkv9Xg184H9Mvj7TwM1TAKrpdQVEzYslsXv
        95dgMwbA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3F1e-000xYr-VD; Tue, 13 Jul 2021 09:48:32 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8B9839866F6; Tue, 13 Jul 2021 11:48:25 +0200 (CEST)
Date:   Tue, 13 Jul 2021 11:48:25 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Marco Elver <elver@google.com>
Cc:     tglx@linutronix.de, mingo@kernel.org, dvyukov@google.com,
        glider@google.com, kasan-dev@googlegroups.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org,
        linux-perf-users@vger.kernel.org, ebiederm@xmission.com,
        omosnace@redhat.com, serge@hallyn.com,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] perf: Fix required permissions if sigtrap is
 requested
Message-ID: <20210713094825.GC4132@worktop.programming.kicks-ass.net>
References: <20210705084453.2151729-1-elver@google.com>
 <CANpmjNP7Z0mxaF+eYCtP1aabPcoh-0aDSOiW6FQsPkR8SbVwnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNP7Z0mxaF+eYCtP1aabPcoh-0aDSOiW6FQsPkR8SbVwnA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 12:32:33PM +0200, Marco Elver wrote:
> It'd be good to get this sorted -- please take another look.

Thanks!

I'll queue them into perf/urgent.
