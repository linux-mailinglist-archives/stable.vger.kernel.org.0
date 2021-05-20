Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E066D38AF80
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 15:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237067AbhETNDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 09:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238364AbhETNCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 09:02:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF0D16100C;
        Thu, 20 May 2021 13:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621515676;
        bh=5vd7uMQxHnOdIBclSApMDhdXfiQA/0h+3cPtI10RZJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PHEf4q6cAVOKEJZ0qvWMLV5AU/5OocxspmxbFFGukaaseiXcj4Jz05xPO39Q6S9kM
         zRG29DZXPzynukyznAOMkiFLG3sofv6+CR+LpnUTrlLEAPPOaUjGNNI/Q9J7LWesH5
         9Qolks+FF8XLcK7td7OLfQ+xnaMu02Vpqq6cENNA=
Date:   Thu, 20 May 2021 15:01:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/190] 4.4.269-rc1 review
Message-ID: <YKZdmulG8YIguBss@kroah.com>
References: <20210520092102.149300807@linuxfoundation.org>
 <cf63f39b-6323-4c11-8e53-d04532ed0b6a@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf63f39b-6323-4c11-8e53-d04532ed0b6a@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 04:30:26AM -0700, Guenter Roeck wrote:
> On 5/20/21 2:21 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.269 release.
> > There are 190 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> > Anything received after that time might be too late.
> > 
> 
> All mips builds still fail.
> 
> Building mips:defconfig ... failed
> --------------
> Error log:
> In file included from include/linux/kernel.h:136,
>                  from include/asm-generic/bug.h:13,
>                  from arch/mips/include/asm/bug.h:41,
>                  from include/linux/bug.h:4,
>                  from include/linux/page-flags.h:9,
>                  from kernel/bounds.c:9:
> arch/mips/include/asm/div64.h:59:30: error: expected identifier or '(' before '{' token
>    59 | #define __div64_32(n, base) ({      \
>       |                              ^
> include/asm-generic/div64.h:35:17: note: in expansion of macro '__div64_32'
>    35 | extern uint32_t __div64_32(uint64_t *dividend, uint32_t divisor);
>       |                 ^~~~~~~~~~
> 
> It looks like the changes conflict with the code in include/asm-generic/div64.h.
> That code is completely different in later kernel versions.

Now dropped.

thanks,

greg k-h
