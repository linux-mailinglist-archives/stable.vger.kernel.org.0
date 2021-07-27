Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2293D6EE0
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 08:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhG0GM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 02:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233553AbhG0GM1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 02:12:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2612460551;
        Tue, 27 Jul 2021 06:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627366346;
        bh=+MeKFzpNWS3o65+98lA2iIWwmUvQdXff746vqMsz0J4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HwAvU0X4A07MajG3WuyfCv6HzlCMTXBuMBHClSN3hUkg1bGqtXudZmiBrE2wa7Vqy
         khq11hzUf7IG0/EkNkHYfMHMAQHSurtmAGDfiB5JgjAJtHSnxNtDu+SHLvg0AiwNOM
         0XDElNJ+cR1G+H7moYaCvaCH+CWZDu5PKIB1sU4c=
Date:   Tue, 27 Jul 2021 08:12:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/120] 4.19.199-rc1 review
Message-ID: <YP+jx2hxYK0zcvcd@kroah.com>
References: <20210726153832.339431936@linuxfoundation.org>
 <20210726193553.GB2686017@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210726193553.GB2686017@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 12:35:53PM -0700, Guenter Roeck wrote:
> On Mon, Jul 26, 2021 at 05:37:32PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.199 release.
> > There are 120 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> > Anything received after that time might be too late.
> > 
> 
> perf fails to build:
> 
> builtin-script.c: In function ‘perf_script__exit’:
> builtin-script.c:2212:2: error: implicit declaration of function ‘perf_thread_map__put’; did you mean ‘thread_map__put’?
> 
> builtin-script.c:2212:2: error: nested extern declaration of ‘perf_thread_map__put’ [-Werror=nested-externs]
> builtin-script.c:2213:2: error: implicit declaration of function ‘perf_cpu_map__put’; did you mean ‘perf_mmap__put’?

I'll go fix this one up as well...

thanks,

greg k-h
