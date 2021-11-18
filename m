Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A8C455E02
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 15:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbhKROdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 09:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbhKROdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 09:33:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E91FC061574;
        Thu, 18 Nov 2021 06:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ekjbeMSSluitq89HmbpZTemKWo5ngK3iUKiP5ZJguVc=; b=VF+HazTrHE8GalajWnK4zFuJLv
        D6WCXPblJLo7kFhjP+L3Uta2+eLf3mHsF6JXywBRZu7Q2I72TOBiYWvz5n95a+VQ4S6fDTJKKH3nU
        pfNI0hd+eTSPtOXC0l+u9QDssagKuvjr2G8h+Nn70Sn0mwIYsSMw6r2i1AfEVk+GVTytDXuJd5rr5
        eIkcgr7rtPSkjuR6memzpUw8VgQ6R1/pqPsKFhvEC41v7qoMTDzJN4CqhIQ3yNzjeAor1eWacV8ko
        Q5jrpfDvqRUc5JkyXRkeuwG1dpXI7GY03XKuFOgKkDWtn9V/3RWe2X7fIzc4nxFJ96YQlQUR6KJUD
        9cFvvqsA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mniQB-008XRp-Oi; Thu, 18 Nov 2021 14:29:52 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 967533001FD;
        Thu, 18 Nov 2021 15:29:51 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5FF4E30255413; Thu, 18 Nov 2021 15:29:51 +0100 (CET)
Date:   Thu, 18 Nov 2021 15:29:51 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Tejun Heo <tj@kernel.org>
Cc:     Andrey Ryabinin <arbn@yandex-team.com>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        stable@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: Re: [PATCH v3 1/4] cputime, cpuacct: Include guest time in user time
 in cpuacct.stat
Message-ID: <YZZjX4NC5gc+poSI@hirez.programming.kicks-ass.net>
References: <20211115164607.23784-1-arbn@yandex-team.com>
 <YZLLyFnT95o4Sa8X@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZLLyFnT95o4Sa8X@slm.duckdns.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 11:06:16AM -1000, Tejun Heo wrote:
> Hello,
> 
> Ingo, Peter, this looks fine to be sans a couple typos in the descriptions.
> Please let me know if you wanna take them through sched tree. Otherwise,
> I'll route them through cgroup tree in a few days.

This is all cgroup only changes, right? That's not immediately obvious
from the changelogs.

But yeah, I can take them I suppose. Lemme go queue them.
