Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E921CB1C1
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 16:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgEHO0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 10:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgEHO0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 10:26:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B20824954;
        Fri,  8 May 2020 14:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588947975;
        bh=6b8YGMJkYUmjuyizBgw94aYNmIm4Dx+h8LwG/nDQZUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hgu6cwX1VlUfQlDjUijm1axY/KMFXW8hdj6fwxL/QPec9Ev8uywMXUltBUkxIDCF+
         uFln6081TAZK6fBzAVNwh3qRrOGK7o8cKDxpIP38Mj3IY7xEvhfGPqLahoKVi6fJfO
         ipq/yLg84K/8bFJPcBsGCO95wwjTBh/5dxQVjW00=
Date:   Fri, 8 May 2020 16:26:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/312] 4.4.223-rc1 review
Message-ID: <20200508142613.GA426400@kroah.com>
References: <20200508123124.574959822@linuxfoundation.org>
 <fe060262-1712-9205-b1cd-cd209d0ed395@roeck-us.net>
 <20200508134408.GA196344@kroah.com>
 <cfb6cb83-81c2-7491-c58b-70986119eb65@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfb6cb83-81c2-7491-c58b-70986119eb65@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 08, 2020 at 06:54:11AM -0700, Guenter Roeck wrote:
> On 5/8/20 6:44 AM, Greg Kroah-Hartman wrote:
> > On Fri, May 08, 2020 at 06:37:56AM -0700, Guenter Roeck wrote:
> >> On 5/8/20 5:29 AM, Greg Kroah-Hartman wrote:
> >>> This is the start of the stable review cycle for the 4.4.223 release.
> >>> There are 312 patches in this series, all will be posted as a response
> >>> to this one.  If anyone has any issues with these being applied, please
> >>> let me know.
> >>>
> >>> Responses should be made by Sun, 10 May 2020 12:29:44 +0000.
> >>> Anything received after that time might be too late.
> >>>
> >>
> >> This is not a complete list of errors.
> > 
> > Yeah, I knew this was going to be a rough one.  I was hoping the "early
> > warning" messages from Linaro would have caught most of these, oh well
> > :(
> > 
> 
> To be fair, I had noticed the errors yesterday. I just thought this was
> so bad that it looked like a stray (bad) push to me, and I didn't send
> feedback. Maybe I should always send feedback if I see errors prior to
> an -rc release. I don't want to spam people with noise, so I am not sure.
> Any thoughts on that ?

If the tree is broken, I'd like to know about it.  Rarely do I know that
it is broken and leave it alone.  One exception would be last night when
it was too late for me to fix the build issues, but Sasha was kind
enough to do so.

So it's not noise to me, if it's easy enough for you to do so.

I think I fixed up the MIPS stuff, turns out gcc was just crashing on a
filesystem driver with an internal error.  I think I need a different
version of gcc if I want to build more arches...

I'll go push out a -rc with this fixed up now, thanks.

greg k-h
