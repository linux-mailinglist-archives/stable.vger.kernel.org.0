Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5972028DBA2
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 10:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgJNIdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 04:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729140AbgJNIdm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 04:33:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACDC5221FE;
        Wed, 14 Oct 2020 08:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602664424;
        bh=rrcS3Go+Or19lj+nA4BiIinDvBjOGlFS21mMUtfa8ZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dgLfHghg2A9FTowHl5Qcwi6OKy1JQlVVVAURIWOxJOAmJPUOD7yf9QRAjK6xNh+L5
         pEP5khA+hrg4OUIeUgq83WXFPCsixsLSnaJLlBrTVrQjm6mC4j0R7jhcP+uewsEc0O
         5SOtiGXvAjm/eZRvsnT6p8i6cZ1bhurrPfV3DQZ8=
Date:   Wed, 14 Oct 2020 10:34:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/49] 4.19.151-rc1 review
Message-ID: <20201014083419.GB3034607@kroah.com>
References: <20201012132629.469542486@linuxfoundation.org>
 <20201013164032.GD251780@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013164032.GD251780@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 13, 2020 at 09:40:32AM -0700, Guenter Roeck wrote:
> On Mon, Oct 12, 2020 at 03:26:46PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.151 release.
> > There are 49 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 153 fail: 2
> Failed builds:
> 	i386:tools/perf
> 	x86_64:tools/perf

I tried to fix up the perf build issues, and am just going to give up,
it's not a trivial backport at all, and it looks like no one seems to
care :(

So you might want to take these two builds out of your testing
framework for the moment.

thanks,

greg k-h
