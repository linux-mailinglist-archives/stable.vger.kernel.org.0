Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F8A18EDCB
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 02:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgCWB6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Mar 2020 21:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgCWB6a (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Mar 2020 21:58:30 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C95FB20722;
        Mon, 23 Mar 2020 01:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584928710;
        bh=w1tcwWtpPMAsA+9omi4eLsU7Mm02AQjta+kf1gJR46c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pZ7WI4A5+SblgQqaH5kLb2zlWYWeKGnx6+tt5Gye10mhj3UeJUdRUdnvKPYggXKKr
         IKtWZ7WpAvcCf+iQN4T2aO8R+7NyxGZ0e9HpwsoHYxTSKxFhuu7jwAkV2X+264+/JQ
         LANFF7NlU/fmxQjTQQQnK0qxg9Ar1AU8juefv40U=
Date:   Sun, 22 Mar 2020 21:58:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Ondrej Moris <omoris@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Xiong Zhou <xzhou@redhat.com>
Subject: Re: =?utf-8?B?8J+SpSBQQU5JQ0tFRA==?= =?utf-8?Q?=3A?= Test report for
 kernel 5.5.11-6df57ed.cki (stable-queue)
Message-ID: <20200323015828.GS4189@sasha-vm>
References: <cki.D9E02DA05E.6L1W61X8RG@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cki.D9E02DA05E.6L1W61X8RG@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 22, 2020 at 11:50:11PM -0000, CKI Project wrote:
>
>Hello,
>
>We ran automated tests on a recent commit from this kernel tree:
>
>       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>            Commit: 6df57ed14ddf - Revert "drm/fbdev: Fallback to non tiled mode if all tiles not present"
>
>The results of these automated tests are provided below.
>
>    Overall result: FAILED (see details below)
>             Merge: OK
>           Compile: OK
>             Tests: PANICKED
>
>All kernel binaries, config files, and logs are available for download here:
>
>  https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/03/22/500600
>
>One or more kernel tests failed:
>
>    ppc64le:
>     ❌ LTP
>
>    aarch64:
>     ❌ Boot test
>
>    x86_64:
>     💥 xfstests - ext4

So I go in the xfstests___ext4/ directory to see what paniced, right? I
don't see panics in those logs...

-- 
Thanks,
Sasha
