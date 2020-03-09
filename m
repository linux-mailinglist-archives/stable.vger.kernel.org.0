Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54CAE17EB8C
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 22:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgCIVxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 17:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbgCIVxH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 17:53:07 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC2432146E;
        Mon,  9 Mar 2020 21:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583790786;
        bh=8HvFafHKYIAnGdw58ZUkwzQxxJQ0wlGlJmTvXiSzUMs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qXUvoDk2WHWlsVdsQ1snSKdtpCR9Y7uKPYKoyF4kQv7/uO1XHb1QHWPpp/EJuz6KQ
         8srnXpWOmBGRfoxx2hdlNwdpW9lgiKFSH+0x1HLBVm6UfNX2lPmu88F/LPNZWgkftn
         KlKU/mgH2oXeck/kbr5c3oFFYtQEhXG+TRRJwotU=
Date:   Mon, 9 Mar 2020 17:53:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Ondrej Moris <omoris@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        William Gomeringer <wgomeringer@redhat.com>
Subject: Re: =?utf-8?B?4p2MIFBBTklDS0VE?= =?utf-8?Q?=3A?= Test report for
 kernel 5.5.8-c30f33b.cki (stable-queue)
Message-ID: <20200309215305.GV21491@sasha-vm>
References: <cki.411617A928.D7E40QQCW6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cki.411617A928.D7E40QQCW6@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 09, 2020 at 09:24:35PM -0000, CKI Project wrote:
>
>Hello,
>
>We ran automated tests on a recent commit from this kernel tree:
>
>       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>            Commit: c30f33bfb014 - selftests: forwarding: vxlan_bridge_1d: use more proper tos value
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
>  https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/03/09/480158
>
>One or more kernel tests failed:
>
>    s390x:
>     ❌ LTP
>
>    ppc64le:
>     ❌ LTP
>
>    aarch64:
>     ❌ audit: audit testsuite test
>
>    x86_64:
>     ❌ audit: audit testsuite test

Following the link above I got to
https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/03/09/480158/audit__audit_testsuite_test/,
but it shows that all tests are passing? The console log looks fine too:
https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/03/09/480158/x86_64_5_console.log.
Where's the panic?

-- 
Thanks,
Sasha
