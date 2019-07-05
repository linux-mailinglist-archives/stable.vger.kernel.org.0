Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 741C360885
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 16:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfGEO5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 10:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfGEO5h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jul 2019 10:57:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2556B21738;
        Fri,  5 Jul 2019 14:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562338656;
        bh=51QgH1JPeG0IEddaifh+M0kdSWEnLBaN4b4ld7MtVww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oUx3/N4jaGZJ4cfdDNoAURc+aSlyUxsvYiEzcq1GaMOxqpCoufWPSsS10wZLvS7kz
         0L7MqARsIioZsx1H+eqTtoqa/nemXva2Mb3KNCyUSB8+necVeJymwlWPnF+pdgc7FQ
         xPPqwTaoZrutXVR4SR0X6iBIeZotCRUXgTiFrfXM=
Date:   Fri, 5 Jul 2019 10:57:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.1
Message-ID: <20190705145735.GG10104@sasha-vm>
References: <cki.23B379E428.A2S9JGOBXU@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cki.23B379E428.A2S9JGOBXU@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 05, 2019 at 10:12:51AM -0400, CKI Project wrote:
>Hello,
>
>We ran automated tests on a patchset that was proposed for merging into this
>kernel tree. The patches were applied to:
>
>       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>            Commit: 8584aaf1c326 - Linux 5.1.16
>
>The results of these automated tests are provided below.
>
>    Overall result: FAILED (see details below)
>             Merge: FAILED
>
>
>
>
>When we attempted to merge the patchset, we received an error:
>
>  error: patch failed: arch/x86/kernel/ftrace.c:22
>  error: arch/x86/kernel/ftrace.c: patch does not apply
>  error: patch failed: kernel/trace/ftrace.c:34
>  error: kernel/trace/ftrace.c: patch does not apply
>  hint: Use 'git am --show-current-patch' to see the failed patch
>  Applying: ftrace/x86: Remove possible deadlock between register_kprobe() and ftrace_run_update_code()
>  Patch failed at 0001 ftrace/x86: Remove possible deadlock between register_kprobe() and ftrace_run_update_code()

That was me, should already be fixed.

--
Thanks,
Sasha
