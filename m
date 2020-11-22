Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B472BC4A4
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 10:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgKVJS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 04:18:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgKVJSy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Nov 2020 04:18:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6D6120781;
        Sun, 22 Nov 2020 09:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606036734;
        bh=Ztmf3cfSkwTfLgfvs4YxzReZXN2LiVa7IVdDsGcYMz8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oBhbmKIy3K3ZdzdbLKYX1ezhiyzf9u/kA19KwwOpJM97A6N7GFB9JvLLd+mMgILHO
         GvwZeH8ajGjTU8BtbIrgUaBEIgfb9EqClLXH+KUapKqxAmqUPF7WuyaW0vC3CT9TFD
         aWN0mCIPzaHYsEXtPHZuiIADZ2ShNPweXOHI25II=
Date:   Sun, 22 Nov 2020 10:19:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 00/14] 5.9.10-rc1 review
Message-ID: <X7otJNXeRTEvZE2i@kroah.com>
References: <20201120104541.168007611@linuxfoundation.org>
 <20201121183817.GG111877@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121183817.GG111877@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 21, 2020 at 10:38:17AM -0800, Guenter Roeck wrote:
> On Fri, Nov 20, 2020 at 12:03:38PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.10 release.
> > There are 14 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 426 pass: 426 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for the testing.  I'll leave the powerpc build failures in as the
issue being fixed is better to have at the moment.  Hopefully the ppc
developers can fix those up soon.

thanks,

greg k-h
