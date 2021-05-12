Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DFF37B36B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 03:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhELBXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 21:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230157AbhELBXS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 May 2021 21:23:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 873C06191D;
        Wed, 12 May 2021 01:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620782526;
        bh=CL11Sa69JgRRcLKPqiCztBZPAUlz2+dPW7PK/v1PTk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bwl/9wcthBc8n6f6G718qzN97uhHfZ7pF/hsoa/GUTABUXOOgu7WHvyosieadBmNY
         +Ea5nUrYpwZC2RZNAWKtzGrlISBXwAII07i8LzCXk9VDyxL3952wNQHqp4cjgECyMv
         OJe/lBkqGEuuZwQjLUXgJIE1MzNRCnSaQPv4OPli1yRCH6WFbkF1IVTPHDDuPiwbY+
         JOgHYractRA/Qufx6LbO4xV4dEfzILnBWs37wnn/mZ1cok70L6Xm5RmtlKmnc0LF94
         KGxmXkbKp1BZw87qP57uzK+KJRJenVpId/x8RlTEG7BeyY0YkyyhKx8/2eN2/TVvlL
         m9SbrkaggVjcg==
Date:   Tue, 11 May 2021 21:22:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     skt-results-master@redhat.com,
        Linux Stable maillist <stable@vger.kernel.org>,
        Jianlin Shi <jishi@redhat.com>, Jianwen Ji <jiji@redhat.com>,
        Hangbin Liu <haliu@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.11.19 (stable-queue, beb6df0c)
Message-ID: <YJstva9S9qPO+2F3@sashalap>
References: <cki.30AF028A01.OS9TECV9G1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cki.30AF028A01.OS9TECV9G1@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 11, 2021 at 09:43:50PM -0000, CKI Project wrote:
>
>Hello,
>
>We ran automated tests on a recent commit from this kernel tree:
>
>       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>            Commit: beb6df0ce94f - thermal/core/fair share: Lock the thermal zone while looping over instances
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
>  https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?prefix=datawarehouse-public/2021/05/11/300944713
>
>One or more kernel tests failed:
>
>    s390x:
>     ❌ Networking tunnel: geneve basic test
>
>    ppc64le:
>     ❌ LTP
>     ❌ Networking tunnel: geneve basic test
>
>    aarch64:
>     ❌ Networking tunnel: geneve basic test
>
>    x86_64:
>     ❌ Networking tunnel: geneve basic test

CKI folks, looks like there was a gap between 5.11.16 and now, and idea
if the reported issue here is new in the 5.11.19 -rc, or something that
regressed earlier?

-- 
Thanks,
Sasha
