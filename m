Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81878E61CA
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 10:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfJ0JUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 05:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbfJ0JUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 05:20:33 -0400
Received: from localhost (smb-adpcdg1-03.hotspot.hub-one.net [213.174.99.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C658E20679;
        Sun, 27 Oct 2019 09:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572168033;
        bh=vW/fZBUaOOIOA5ZT9AZtEp8kRpkJlWaZVSCXXeEtMbo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xoxk8vZOHzpokTJcbnyTRiudvGldf5zW0CLee/whoG6MGBTc9r97sy/eAvcrqZ9l3
         kB5+YouBFQPD0T5UMapwodwn6k9Oy78WfW6ff6LNZSlD99Elemp4EmZ01yu6jnw86o
         TYD9YTbWp/t4b6v1ukegzd7Z6fzzJFl9Fn1nvPXQ=
Date:   Sun, 27 Oct 2019 05:20:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.3
Message-ID: <20191027092030.GB1560@sasha-vm>
References: <cki.50B692ED30.9T78VCP4SR@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cki.50B692ED30.9T78VCP4SR@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 27, 2019 at 09:08:40AM -0000, CKI Project wrote:
>
>Hello,
>
>We ran automated tests on a patchset that was proposed for merging into this
>kernel tree. The patches were applied to:
>
>       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>            Commit: 365dab61f74e - Linux 5.3.7
>
>The results of these automated tests are provided below.
>
>    Overall result: FAILED (see details below)
>             Merge: OK
>           Compile: FAILED
>
>All kernel binaries, config files, and logs are available for download here:
>
>  https://artifacts.cki-project.org/pipelines/250837
>
>We attempted to compile the kernel for multiple architectures, but the compile
>failed on one or more architectures:
>
>           aarch64: FAILED (see build-aarch64.log.xz attachment)
>           ppc64le: FAILED (see build-ppc64le.log.xz attachment)
>             s390x: FAILED (see build-s390x.log.xz attachment)
>            x86_64: FAILED (see build-x86_64.log.xz attachment)

My bad. Should be fixed now.

-- 
Thanks,
Sasha
