Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5282EBF15
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 14:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbhAFNpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 08:45:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:49688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726993AbhAFNpo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 08:45:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 084B22311C;
        Wed,  6 Jan 2021 13:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609940704;
        bh=lnhvbbcPYunyJG4MzqyaJSRiLqRrm960H1O2G+KiZ1k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=izVPflZGKvvaLXeqysQ3++Z9JgVyp+2BkiSspkY6nH623WWxds+ugyS/BZUfY5jdA
         emIeheQRyehSjjTcnh97vgApOutXzl/0UZNdBs1l0qDoFPHeDFqUtbxzJ9P58xZfqt
         2X8C8b1DAJGNT6wGY8qZcyaxx2cPluF/wjXUTeAo=
Date:   Wed, 6 Jan 2021 14:46:21 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/29] 4.19.165-rc2 review
Message-ID: <X/W/LZZb/yrnaauF@kroah.com>
References: <20210105090818.518271884@linuxfoundation.org>
 <20210105101233.GA28479@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105101233.GA28479@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 11:12:33AM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.165 release.
> > There are 29 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 07 Jan 2021 09:08:03 +0000.
> > Anything received after that time might be too late.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-4.19.y
> 
> We did not find any problems with -rc1, so I guess we don't test
> exotic-enough configs...
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>
> 

Thanks for testing this one.

greg k-h
