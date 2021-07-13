Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518043C7303
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 17:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236984AbhGMPUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 11:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236932AbhGMPUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 11:20:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA16C61279;
        Tue, 13 Jul 2021 15:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626189480;
        bh=rZjujF/vPkBIas5SoG/bbXxCaN/AiQbLT6fvBz7dtZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pkn41h1NU8wl+5uE7ca2LeuyWbYCgI8VphCpDn3Ez+57tY1Iuf32SQDIVw9CYYANC
         7VMpFYMEX1enANTTqYDa3QJfsoGuEGdC8pxAkbeNVxbSSO7H/2sYN8c0YiPsJd6+WN
         GD6aLB4lv2SQKqSjy7lDy0zfN3b9RkVtnFRfnqBw=
Date:   Tue, 13 Jul 2021 17:17:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     perf-users <perf-users@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, Leo Yan <leo.yan@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: perf: bench/sched-messaging.c:73:13: error: 'dummy' may be used
 uninitialized
Message-ID: <YO2upa4SZWS59KeB@kroah.com>
References: <CA+G9fYubOg+Pu8N3LYFKn-eL3f=gn4ceK9Asj1RdBDntU_A2ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYubOg+Pu8N3LYFKn-eL3f=gn4ceK9Asj1RdBDntU_A2ng@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 08:40:28PM +0530, Naresh Kamboju wrote:
> LKFT have noticed these warnings / errors when we have updated gcc version from
> gcc-9 to gcc-11 on stable-rc linux-5.4.y branch. I have provided the steps to
> reproduce in this email below.
> 
> Following perf builds failed with gcc-11 with linux-5.4.y branch.
> - build-arm-gcc-11-perf
> - build-arm64-gcc-11-perf
> - build-i386-gcc-11-perf
> - build-x86-gcc-11-perf
> 
> Build error log:
> --------------------

<snip>

I imagine this is fixed in newer kernel versions, so if you could
provide the git ids of the patches needed to fix this up in 5.4, that
would be great!

thanks,

greg k-h
