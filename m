Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2509D1C15
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 00:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731589AbfJIWoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 18:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730675AbfJIWoi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 18:44:38 -0400
Received: from localhost (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C627206A1;
        Wed,  9 Oct 2019 22:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570661078;
        bh=azQRUuIePWmBhr0zJzfHTHPhIyFV2axyImRVQA6Gso0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gEWq98E01rspN/l/iBBCt6TzQ1fPMiDiQauVq0odD0jGRYcSxzyaqHIGXYQ4Iy6KR
         LpxPSqcM3GIRfKuUeU8yW+8W/VlbLZQn6auSpTPSsbT8g93oScQttl/Twc+iQ5p2vq
         WDsBYKfQ5DBsyjJUvbF6I3f6Hqmg03nnaJdb+Em8=
Date:   Wed, 9 Oct 2019 18:44:37 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Zhaojuan Guo <zguo@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.3
Message-ID: <20191009224437.GY1396@sasha-vm>
References: <cki.F2FC419F40.7K0EACX2QA@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cki.F2FC419F40.7K0EACX2QA@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 06:11:40PM -0400, CKI Project wrote:
>
>Hello,
>
>We ran automated tests on a patchset that was proposed for merging into this
>kernel tree. The patches were applied to:
>
>       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>            Commit: 52020d3f6633 - Linux 5.3.5
>
>The results of these automated tests are provided below.
>
>    Overall result: FAILED (see details below)
>             Merge: OK
>           Compile: OK
>             Tests: FAILED
>
>All kernel binaries, config files, and logs are available for download here:
>
>  https://artifacts.cki-project.org/pipelines/214657
>
>One or more kernel tests failed:
>
>    x86_64:
>      ❌ Boot test
>      ❌ Boot test
>      ❌ Boot test
>      ❌ Boot test

Hm, I looked here:

https://artifacts.cki-project.org/pipelines/214657/logs/x86_64_host_1_Boot_test_dmesg.log

and here:

https://artifacts.cki-project.org/pipelines/214657/logs/x86_64_host_2_Boot_test_dmesg.log

but both look sane. What am I missing?

-- 
Thanks,
Sasha
