Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247BE1B719C
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 12:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgDXKLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 06:11:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbgDXKLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 06:11:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 205562071E;
        Fri, 24 Apr 2020 10:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587723080;
        bh=MWJxf0Q2AXB9eopVRDR4/tkh86oKOrlcccE3H6d+Cac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b1aJyMqQgngxdqsApnT8bhAIdFBrl9zFIwCPYuCTYKj7KNwRRgRpAyLEb4kE7bzQO
         U+iylP5o2+iMV8c1ad4qv0dVxveUgnhrDg926TCf6NI8IJSGoz8G9ngSC8ySv7pm5i
         X/5ArrtDbxQ+V+OlkxFD58VicBCxXB8pMC5yinRs=
Date:   Fri, 24 Apr 2020 12:11:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: List of patches to apply to stable releases
Message-ID: <20200424101118.GC381429@kroah.com>
References: <20200422194306.GA103402@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422194306.GA103402@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 12:43:06PM -0700, Guenter Roeck wrote:
> Hi,
> 
> Please consider applying the following patches to the listed stable releases.
> 
> The following patches were found to be missing in stable releases by the
> Chrome OS missing patch robot. The patches meet the following criteria.
> - The patch includes a Fixes: tag
> - The patch referenced in the Fixes: tag has been applied to the listed
>   stable release
> - The patch has not been applied to that stable release
> 
> All patches have been applied to the listed stable releases and to at least one
> Chrome OS branch. Resulting images have been build- and runtime-tested (where
> applicable) on real hardware and with virtual hardware on kerneltests.org.
> 
> Thanks,
> Guenter
> 
> ---
> Upstream commit 6a30abaa40b6 ("ALSA: hda - Fix incorrect usage of IS_REACHABLE()")
>   upstream: v4.17-rc4
>     Fixes: c469652bb5e8 ("ALSA: hda - Use IS_REACHABLE() for dependency on input")
>       in linux-4.4.y: 4281754e6bea
>       in linux-4.9.y: 71bff398b0d4
>       in linux-4.14.y: d3222cfc0b58
>       upstream: v4.16-rc1
>     Affected branches:
>       linux-4.4.y
>       linux-4.9.y (already applied)
>       linux-4.14.y (already applied)

Now queued up.

> Upstream commit 20b50d79974e ("net: ipv4: emulate READ_ONCE() on ->hdrincl bit-field in raw_sendmsg()")
>   upstream: v4.15-rc8
>     Fixes: 8f659a03a0ba ("net: ipv4: fix for a race condition in raw_sendmsg")
>       in linux-4.4.y: be27b620a861
>       in linux-4.9.y: f75f910ffa90
>       in linux-4.14.y: 3bc400bad0e0
>       upstream: v4.15-rc4
>     Affected branches:
>       linux-4.4.y
>       linux-4.9.y
>       linux-4.14.y

Now queued up.

> Upstream commit 773daa3caf5d ("net: ipv4: avoid unused variable warning for sysctl")
>   upstream: v4.16-rc5
>     Fixes: c7272c2f1229 ("net: ipv4: don't allow setting net.ipv4.route.min_pmtu below 68")
>       in linux-4.4.y: 94522bee72fd
>       in linux-4.9.y: 06f01887683f
>       in linux-4.14.y: 3bcf69f8e786
>       upstream: v4.16-rc5
>     Affected branches:
>       linux-4.4.y
>       linux-4.9.y
>       linux-4.14.y

Now queued up.

> Upstream commit 2ecefa0a15fd ("keys: Fix the use of the C++ keyword "private" in uapi/linux/keyctl.h")
>   upstream: v4.20-rc1
>     Fixes: 8a2336e549d3 ("uapi/linux/keyctl.h: don't use C++ reserved keyword as a struct member name")
>       in linux-4.14.y: 448b5498f6c6
>       upstream: v4.19-rc3
>     Affected branches:
>       linux-4.14.y
>       linux-4.19.y (already applied)

Now queued up.

> Upstream commit 9f614197c744 ("drm/msm: Use the correct dma_sync calls harder")
>   upstream: v5.4-rc1
>     Fixes: 3de433c5b38a ("drm/msm: Use the correct dma_sync calls in msm_gem")
>       in linux-4.9.y: dca98889e8e5
>       in linux-4.14.y: 7ed71842d3c8
>       in linux-4.19.y: 39718d086d9b
>       upstream: v5.3-rc3
>     Affected branches:
>       linux-4.9.y
>       linux-4.14.y
>       linux-4.19.y

Now queued up.

> 
> Upstream commit 555089fdfc37 ("bpftool: Fix printing incorrect pointer in btf_dump_ptr")
>   upstream: v5.5-rc7
>     Fixes: 22c349e8db89 ("tools: bpftool: fix format strings and arguments for jsonw_printf()")
>       in linux-4.19.y: 5fab87c26f0a
>       upstream: v5.4-rc1
>     Affected branches:
>       linux-4.19.y
>       linux-5.4.y (already applied)

Now queued up.

> 
> Upstream commit ce4e45842de3 ("crypto: mxs-dcp - make symbols 'sha1_null_hash' and 'sha256_null_hash' static")
>   upstream: v4.20-rc1
>     Fixes: c709eebaf5c5 ("crypto: mxs-dcp - Fix SHA null hashes and output length")
>       in linux-4.4.y: 33378afbd12b
>       in linux-4.9.y: df1ef6f3c9ad
>       in linux-4.14.y: c0933fa586b4
>       in linux-4.19.y: 70ecd0459d03
>       upstream: v4.20-rc1
>     Affected branches:
>       linux-4.4.y
>       linux-4.9.y
>       linux-4.14.y
>       linux-4.19.y

That's really not a "bug", but I'll take it to keep your scripts happy.

> 
> Upstream commit 01ce31c57b3f ("vti4: removed duplicate log message.")
>   upstream: v5.1
>     Fixes: dd9ee3444014 ("vti4: Fix a ipip packet processing bug in 'IPCOMP' virtual tunnel")
>       in linux-4.4.y: a4fa2a130412
>       in linux-4.9.y: d2a6df768b55
>       in linux-4.14.y: 61a2e1118c8a
>       in linux-4.19.y: 8ce41db0dcfc
>       upstream: v5.0-rc5
>     Affected branches:
>       linux-4.4.y
>       linux-4.9.y
>       linux-4.14.y
>       linux-4.19.y

All now queued up, thanks for this list.

greg k-h
