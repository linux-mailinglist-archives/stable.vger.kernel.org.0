Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5FD49B2C7
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 12:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352168AbiAYLPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 06:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380976AbiAYLM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 06:12:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFCFC06175A;
        Tue, 25 Jan 2022 03:12:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D9E5616A8;
        Tue, 25 Jan 2022 11:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30511C340E0;
        Tue, 25 Jan 2022 11:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643109135;
        bh=EXpwGg861uLmaEF+JJ31AhZEkqtBcYUioaeRZcJ/cNA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vAdBKofCf3Ekeo4Wi9Un7RG6i001dEVMnyExy2F4nKVGlyqX7gUaLQ+kDb9G36skf
         JO9G1cr0IKVaXAAdrbL2FzyxVnrgjIaXV28qY5lhVINkS/i6/6Fj4WUvFdqI2xL52g
         UM3slvzT86aqcaCjHnk6XEt7ObRfoJvxHD1c/mTI=
Date:   Tue, 25 Jan 2022 12:12:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/320] 5.4.174-rc1 review
Message-ID: <Ye/bDM37enfsGB5B@kroah.com>
References: <20220124183953.750177707@linuxfoundation.org>
 <19ade631-f2cb-f51a-2ca4-832613dd66b5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19ade631-f2cb-f51a-2ca4-832613dd66b5@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 07:42:11PM -0800, Florian Fainelli wrote:
> 
> 
> On 1/24/2022 10:39 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.174 release.
> > There are 320 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.174-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> same perf/libbpf error as reported by Daniel for arm64.

What is the perf issue?
